From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 1/5] bfa: add fc transport class based vport create/delete
Date: Fri, 19 Mar 2010 11:05:39 -0700
Message-ID: <1269021939-10336-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:54936 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803Ab0CSSWs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 14:22:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com

Use duplicate fc transport template for physical and vitual port. Add 
vport create/delete/disalbe functions in the transport template of physical
port. Changes to make the vport create/delete function to work under this
framework.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfad.c      |   10 +-
 drivers/scsi/bfa/bfad_attr.c |  201 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfad_drv.h  |    2 +-
 drivers/scsi/bfa/bfad_im.c   |   53 ++++++------
 drivers/scsi/bfa/bfad_im.h   |    6 +-
 5 files changed, 239 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 6bff08e..fcbba84 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -298,8 +298,6 @@ bfa_fcb_vport_delete(struct bfad_vport_s *vport_drv)
 		complete(vport_drv->comp_del);
 		return;
 	}
-
-	kfree(vport_drv);
 }
 
 /**
@@ -482,7 +480,7 @@ ext:
  */
 bfa_status_t
 bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
-		  struct bfa_port_cfg_s *port_cfg)
+		  struct bfa_port_cfg_s *port_cfg, struct device *dev)
 {
 	struct bfad_vport_s *vport;
 	int             rc = BFA_STATUS_OK;
@@ -505,7 +503,8 @@ bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
 		goto ext_free_vport;
 
 	if (port_cfg->roles & BFA_PORT_ROLE_FCP_IM) {
-		rc = bfad_im_scsi_host_alloc(bfad, vport->drv_port.im_port);
+		rc = bfad_im_scsi_host_alloc(bfad, vport->drv_port.im_port,
+							dev);
 		if (rc != BFA_STATUS_OK)
 			goto ext_free_fcs_vport;
 	}
@@ -847,7 +846,8 @@ bfad_cfg_pport(struct bfad_s *bfad, enum bfa_port_role role)
 			goto out;
 		}
 
-		rc = bfad_im_scsi_host_alloc(bfad, bfad->pport.im_port);
+		rc = bfad_im_scsi_host_alloc(bfad, bfad->pport.im_port,
+						&bfad->pcidev->dev);
 		if (rc != BFA_STATUS_OK)
 			goto out;
 
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index d97f691..d80ee50 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -363,6 +363,152 @@ bfad_im_set_rport_loss_tmo(struct fc_rport *rport, u32 timeout)
 
 }
 
+static int
+bfad_im_vport_create(struct fc_vport *fc_vport, bool disable)
+{
+	char *vname = fc_vport->symbolic_name;
+	struct Scsi_Host *shost = fc_vport->shost;
+	struct bfad_im_port_s *im_port =
+		(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s *bfad = im_port->bfad;
+	struct bfa_port_cfg_s port_cfg;
+	int status = 0, rc;
+	unsigned long flags;
+
+	memset(&port_cfg, 0, sizeof(port_cfg));
+
+	port_cfg.pwwn = wwn_to_u64((u8 *) &fc_vport->port_name);
+	port_cfg.nwwn = wwn_to_u64((u8 *) &fc_vport->node_name);
+
+	if (strlen(vname) > 0)
+		strcpy((char *)&port_cfg.sym_name, vname);
+
+	port_cfg.roles = BFA_PORT_ROLE_FCP_IM;
+	rc = bfad_vport_create(bfad, 0, &port_cfg, &fc_vport->dev);
+
+	if (rc == BFA_STATUS_OK) {
+		struct bfad_vport_s   *vport;
+		struct bfa_fcs_vport_s *fcs_vport;
+		struct Scsi_Host *vshost;
+
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		fcs_vport = bfa_fcs_vport_lookup(&bfad->bfa_fcs, 0,
+					port_cfg.pwwn);
+		if (fcs_vport == NULL) {
+			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+			return VPCERR_BAD_WWN;
+		}
+
+		fc_vport_set_state(fc_vport, FC_VPORT_ACTIVE);
+		if (disable) {
+			bfa_fcs_vport_stop(fcs_vport);
+			fc_vport_set_state(fc_vport, FC_VPORT_DISABLED);
+		}
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+		vport = fcs_vport->vport_drv;
+		vshost = vport->drv_port.im_port->shost;
+		fc_host_node_name(vshost) = wwn_to_u64((u8 *) &port_cfg.nwwn);
+		fc_host_port_name(vshost) = wwn_to_u64((u8 *) &port_cfg.pwwn);
+		fc_vport->dd_data = vport;
+		vport->drv_port.im_port->fc_vport = fc_vport;
+
+	} else if (rc == BFA_STATUS_INVALID_WWN)
+		return VPCERR_BAD_WWN;
+	else if (rc == BFA_STATUS_VPORT_EXISTS)
+		return VPCERR_BAD_WWN;
+	else if (rc == BFA_STATUS_VPORT_MAX)
+		return VPCERR_NO_FABRIC_SUPP;
+	else if (rc == BFA_STATUS_VPORT_WWN_BP)
+		return VPCERR_BAD_WWN;
+	 else
+		return FC_VPORT_FAILED;
+
+	return status;
+}
+
+static int
+bfad_im_vport_delete(struct fc_vport *fc_vport)
+{
+	struct bfad_vport_s *vport = (struct bfad_vport_s *)fc_vport->dd_data;
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) vport->drv_port.im_port;
+	struct bfad_s *bfad = im_port->bfad;
+	struct bfad_port_s *port;
+	struct bfa_fcs_vport_s *fcs_vport;
+	struct Scsi_Host *vshost;
+	wwn_t   pwwn;
+	int rc;
+	unsigned long flags;
+	struct completion fcomp;
+
+	if (im_port->flags & BFAD_PORT_DELETE)
+		goto free_scsi_host;
+
+	port = im_port->port;
+
+	vshost = vport->drv_port.im_port->shost;
+	pwwn = wwn_to_u64((u8 *) &fc_host_port_name(vshost));
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	fcs_vport = bfa_fcs_vport_lookup(&bfad->bfa_fcs, 0, pwwn);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (fcs_vport == NULL)
+		return VPCERR_BAD_WWN;
+
+	vport->drv_port.flags |= BFAD_PORT_DELETE;
+
+	vport->comp_del = &fcomp;
+	init_completion(vport->comp_del);
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	rc = bfa_fcs_vport_delete(&vport->fcs_vport);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	wait_for_completion(vport->comp_del);
+
+free_scsi_host:
+	bfad_os_scsi_host_free(bfad, im_port);
+
+	kfree(vport);
+
+	return 0;
+}
+
+static int
+bfad_im_vport_disable(struct fc_vport *fc_vport, bool disable)
+{
+	struct bfad_vport_s *vport;
+	struct bfad_s *bfad;
+	struct bfa_fcs_vport_s *fcs_vport;
+	struct Scsi_Host *vshost;
+	wwn_t   pwwn;
+	unsigned long flags;
+
+	vport = (struct bfad_vport_s *)fc_vport->dd_data;
+	bfad = vport->drv_port.bfad;
+	vshost = vport->drv_port.im_port->shost;
+	pwwn = wwn_to_u64((u8 *) &fc_vport->port_name);
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	fcs_vport = bfa_fcs_vport_lookup(&bfad->bfa_fcs, 0, pwwn);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (fcs_vport == NULL)
+		return VPCERR_BAD_WWN;
+
+	if (disable) {
+		bfa_fcs_vport_stop(fcs_vport);
+		fc_vport_set_state(fc_vport, FC_VPORT_DISABLED);
+	} else {
+		bfa_fcs_vport_start(fcs_vport);
+		fc_vport_set_state(fc_vport, FC_VPORT_ACTIVE);
+	}
+
+	return 0;
+}
+
 struct fc_function_template bfad_im_fc_function_template = {
 
 	/* Target dynamic attributes */
@@ -412,6 +558,61 @@ struct fc_function_template bfad_im_fc_function_template = {
 	.show_rport_dev_loss_tmo = 1,
 	.get_rport_dev_loss_tmo = bfad_im_get_rport_loss_tmo,
 	.set_rport_dev_loss_tmo = bfad_im_set_rport_loss_tmo,
+
+	.vport_create = bfad_im_vport_create,
+	.vport_delete = bfad_im_vport_delete,
+	.vport_disable = bfad_im_vport_disable,
+};
+
+struct fc_function_template bfad_im_vport_fc_function_template = {
+
+	/* Target dynamic attributes */
+	.get_starget_port_id = bfad_im_get_starget_port_id,
+	.show_starget_port_id = 1,
+	.get_starget_node_name = bfad_im_get_starget_node_name,
+	.show_starget_node_name = 1,
+	.get_starget_port_name = bfad_im_get_starget_port_name,
+	.show_starget_port_name = 1,
+
+	/* Host dynamic attribute */
+	.get_host_port_id = bfad_im_get_host_port_id,
+	.show_host_port_id = 1,
+
+	/* Host fixed attributes */
+	.show_host_node_name = 1,
+	.show_host_port_name = 1,
+	.show_host_supported_classes = 1,
+	.show_host_supported_fc4s = 1,
+	.show_host_supported_speeds = 1,
+	.show_host_maxframe_size = 1,
+
+	/* More host dynamic attributes */
+	.show_host_port_type = 1,
+	.get_host_port_type = bfad_im_get_host_port_type,
+	.show_host_port_state = 1,
+	.get_host_port_state = bfad_im_get_host_port_state,
+	.show_host_active_fc4s = 1,
+	.get_host_active_fc4s = bfad_im_get_host_active_fc4s,
+	.show_host_speed = 1,
+	.get_host_speed = bfad_im_get_host_speed,
+	.show_host_fabric_name = 1,
+	.get_host_fabric_name = bfad_im_get_host_fabric_name,
+
+	.show_host_symbolic_name = 1,
+
+	/* Statistics */
+	.get_fc_host_stats = bfad_im_get_stats,
+	.reset_fc_host_stats = bfad_im_reset_stats,
+
+	/* Allocation length for host specific data */
+	.dd_fcrport_size = sizeof(struct bfad_itnim_data_s *),
+
+	/* Remote port fixed attributes */
+	.show_rport_maxframe_size = 1,
+	.show_rport_supported_classes = 1,
+	.show_rport_dev_loss_tmo = 1,
+	.get_rport_dev_loss_tmo = bfad_im_get_rport_loss_tmo,
+	.set_rport_dev_loss_tmo = bfad_im_set_rport_loss_tmo,
 };
 
 /**
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 107848c..f4b1439 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -254,7 +254,7 @@ do {                                            	\
 
 
 bfa_status_t    bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
-				  struct bfa_port_cfg_s *port_cfg);
+			  struct bfa_port_cfg_s *port_cfg, struct device *dev);
 bfa_status_t    bfad_vf_create(struct bfad_s *bfad, u16 vf_id,
 			       struct bfa_port_cfg_s *port_cfg);
 bfa_status_t    bfad_cfg_pport(struct bfad_s *bfad, enum bfa_port_role role);
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index f9fc67a..a4676a7 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -29,6 +29,7 @@ BFA_TRC_FILE(LDRV, IM);
 
 DEFINE_IDR(bfad_im_port_index);
 struct scsi_transport_template *bfad_im_scsi_transport_template;
+struct scsi_transport_template *bfad_im_scsi_vport_transport_template;
 static void bfad_im_itnim_work_handler(struct work_struct *work);
 static int bfad_im_queuecommand(struct scsi_cmnd *cmnd,
 		void (*done)(struct scsi_cmnd *));
@@ -512,7 +513,8 @@ void bfa_fcb_itnim_tov(struct bfad_itnim_s *itnim)
  * Allocate a Scsi_Host for a port.
  */
 int
-bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port)
+bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
+				struct device *dev)
 {
 	int error = 1;
 
@@ -541,12 +543,15 @@ bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port)
 	im_port->shost->max_lun = MAX_FCP_LUN;
 	im_port->shost->max_cmd_len = 16;
 	im_port->shost->can_queue = bfad->cfg_data.ioc_queue_depth;
-	im_port->shost->transportt = bfad_im_scsi_transport_template;
+	if (im_port->port->pvb_type == BFAD_PORT_PHYS_BASE)
+		im_port->shost->transportt = bfad_im_scsi_transport_template;
+	else
+		im_port->shost->transportt =
+				bfad_im_scsi_vport_transport_template;
 
-	error = bfad_os_scsi_add_host(im_port->shost, im_port, bfad);
+	error = scsi_add_host(im_port->shost, dev);
 	if (error) {
-		printk(KERN_WARNING "bfad_os_scsi_add_host failure %d\n",
-							error);
+		printk(KERN_WARNING "scsi_add_host failure %d\n", error);
 		goto out_fc_rel;
 	}
 
@@ -588,9 +593,11 @@ bfad_im_port_delete_handler(struct work_struct *work)
 	struct bfad_im_port_s *im_port =
 		container_of(work, struct bfad_im_port_s, port_delete_work);
 
-	bfad_im_scsi_host_free(im_port->bfad, im_port);
-	bfad_im_port_clean(im_port);
-	kfree(im_port);
+	if (im_port->port->pvb_type != BFAD_PORT_PHYS_BASE) {
+		im_port->flags |= BFAD_PORT_DELETE;
+		fc_vport_terminate(im_port->fc_vport);
+	}
+
 }
 
 bfa_status_t
@@ -689,23 +696,6 @@ bfad_im_probe_undo(struct bfad_s *bfad)
 	}
 }
 
-
-
-
-int
-bfad_os_scsi_add_host(struct Scsi_Host *shost, struct bfad_im_port_s *im_port,
-			struct bfad_s *bfad)
-{
-    struct device *dev;
-
-    if (im_port->port->pvb_type == BFAD_PORT_PHYS_BASE)
-		dev = &bfad->pcidev->dev;
-    else
-		dev = &bfad->pport.im_port->shost->shost_gendev;
-
-    return scsi_add_host(shost, dev);
-}
-
 struct Scsi_Host *
 bfad_os_scsi_host_alloc(struct bfad_im_port_s *im_port, struct bfad_s *bfad)
 {
@@ -724,7 +714,8 @@ bfad_os_scsi_host_alloc(struct bfad_im_port_s *im_port, struct bfad_s *bfad)
 void
 bfad_os_scsi_host_free(struct bfad_s *bfad, struct bfad_im_port_s *im_port)
 {
-	flush_workqueue(bfad->im->drv_workq);
+	if (!(im_port->flags & BFAD_PORT_DELETE))
+		flush_workqueue(bfad->im->drv_workq);
 	bfad_im_scsi_host_free(im_port->bfad, im_port);
 	bfad_im_port_clean(im_port);
 	kfree(im_port);
@@ -829,6 +820,13 @@ bfad_im_module_init(void)
 	if (!bfad_im_scsi_transport_template)
 		return BFA_STATUS_ENOMEM;
 
+	bfad_im_scsi_vport_transport_template =
+		fc_attach_transport(&bfad_im_vport_fc_function_template);
+	if (!bfad_im_scsi_vport_transport_template) {
+		fc_release_transport(bfad_im_scsi_transport_template);
+		return BFA_STATUS_ENOMEM;
+	}
+
 	return BFA_STATUS_OK;
 }
 
@@ -837,6 +835,8 @@ bfad_im_module_exit(void)
 {
 	if (bfad_im_scsi_transport_template)
 		fc_release_transport(bfad_im_scsi_transport_template);
+	if (bfad_im_scsi_vport_transport_template)
+		fc_release_transport(bfad_im_scsi_vport_transport_template);
 }
 
 void
@@ -937,6 +937,7 @@ bfad_os_fc_host_init(struct bfad_im_port_s *im_port)
 		bfa_os_htonll((bfa_fcs_port_get_nwwn(port->fcs_port)));
 	fc_host_port_name(host) =
 		bfa_os_htonll((bfa_fcs_port_get_pwwn(port->fcs_port)));
+	fc_host_max_npiv_vports(host) = bfa_lps_get_max_vport(&bfad->bfa);
 
 	fc_host_supported_classes(host) = FC_COS_CLASS3;
 
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index 85ab2da..973cab4 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -34,7 +34,7 @@ void bfad_im_port_online(struct bfad_s *bfad, struct bfad_port_s *port);
 void bfad_im_port_offline(struct bfad_s *bfad, struct bfad_port_s *port);
 void bfad_im_port_clean(struct bfad_im_port_s *im_port);
 int  bfad_im_scsi_host_alloc(struct bfad_s *bfad,
-				struct bfad_im_port_s *im_port);
+		struct bfad_im_port_s *im_port, struct device *dev);
 void bfad_im_scsi_host_free(struct bfad_s *bfad,
 				struct bfad_im_port_s *im_port);
 
@@ -64,9 +64,11 @@ struct bfad_im_port_s {
 	struct work_struct port_delete_work;
 	int             idr_id;
 	u16        cur_scsi_id;
+	u16	   flags;
 	struct list_head binding_list;
 	struct Scsi_Host *shost;
 	struct list_head itnim_mapped_list;
+	struct fc_vport *fc_vport;
 };
 
 enum bfad_itnim_state {
@@ -140,6 +142,8 @@ void bfad_im_itnim_unmap(struct bfad_im_port_s  *im_port,
 extern struct scsi_host_template bfad_im_scsi_host_template;
 extern struct scsi_host_template bfad_im_vport_template;
 extern struct fc_function_template bfad_im_fc_function_template;
+extern struct fc_function_template bfad_im_vport_fc_function_template;
 extern struct scsi_transport_template *bfad_im_scsi_transport_template;
+extern struct scsi_transport_template *bfad_im_scsi_vport_transport_template;
 
 #endif
-- 
1.6.5.2

