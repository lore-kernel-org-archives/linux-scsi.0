From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 03/23] bfa: PBC vport create
Date: Tue, 15 Jun 2010 11:21:53 -0700
Message-ID: <1276626113-3102-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:41354 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755730Ab0FOSWH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2010 14:22:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vravindr@brocade.com, rvadivel@brocade.com, kgudipat@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

This patch enables creating PBC vport.
During fcs init, fcs will read PBC vport using bfa iocfc API and invoke fcb
callback to add the pbc vport entries into a list. The pbc vport list will be
traversed in the subsequent pci probe process and vport will be created using
fc transport provided vport create function.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs.c                      |   10 +++-
 drivers/scsi/bfa/bfa_iocfc.c                    |   11 ++++
 drivers/scsi/bfa/bfa_iocfc.h                    |    3 +
 drivers/scsi/bfa/bfad.c                         |   61 +++++++++++++++++++++--
 drivers/scsi/bfa/bfad_attr.c                    |   43 ++++++++++------
 drivers/scsi/bfa/bfad_drv.h                     |    8 +++
 drivers/scsi/bfa/bfad_im.c                      |    1 +
 drivers/scsi/bfa/fabric.c                       |    2 +-
 drivers/scsi/bfa/fcs_vport.h                    |    1 +
 drivers/scsi/bfa/include/defs/bfa_defs_port.h   |   12 ++--
 drivers/scsi/bfa/include/defs/bfa_defs_status.h |    5 ++-
 drivers/scsi/bfa/include/fcb/bfa_fcb_vport.h    |    3 +-
 drivers/scsi/bfa/include/fcs/bfa_fcs.h          |    4 +-
 drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h    |    4 ++
 drivers/scsi/bfa/vport.c                        |   45 +++++++++++++++++
 15 files changed, 179 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 3516172..3ec2f49 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -99,14 +99,22 @@ bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
 void
 bfa_fcs_init(struct bfa_fcs_s *fcs)
 {
-	int             i;
+	int i, npbc_vports;
 	struct bfa_fcs_mod_s  *mod;
+	struct bfi_pbc_vport_s pbc_vports[BFI_PBC_MAX_VPORTS];
 
 	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
 		mod = &fcs_modules[i];
 		if (mod->modinit)
 			mod->modinit(fcs);
 	}
+	/* Initialize pbc vports */
+	if (!fcs->min_cfg) {
+		npbc_vports =
+			bfa_iocfc_get_pbc_vports(fcs->bfa, pbc_vports);
+		for (i = 0; i < npbc_vports; i++)
+			bfa_fcb_pbc_vport_create(fcs->bfa->bfad, pbc_vports[i]);
+	}
 }
 
 /**
diff --git a/drivers/scsi/bfa/bfa_iocfc.c b/drivers/scsi/bfa/bfa_iocfc.c
index afa3da0..d3f1052 100644
--- a/drivers/scsi/bfa/bfa_iocfc.c
+++ b/drivers/scsi/bfa/bfa_iocfc.c
@@ -882,6 +882,17 @@ bfa_iocfc_get_pbc_boot_cfg(struct bfa_s *bfa, struct bfa_boot_pbc_s *pbcfg)
 	memcpy(pbcfg->pblun, cfgrsp->pbc_cfg.blun, sizeof(pbcfg->pblun));
 }
 
+int
+bfa_iocfc_get_pbc_vports(struct bfa_s *bfa, struct bfi_pbc_vport_s *pbc_vport)
+{
+	struct bfa_iocfc_s *iocfc = &bfa->iocfc;
+	struct bfi_iocfc_cfgrsp_s *cfgrsp = iocfc->cfgrsp;
+
+	memcpy(pbc_vport, cfgrsp->pbc_cfg.vport, sizeof(cfgrsp->pbc_cfg.vport));
+	return cfgrsp->pbc_cfg.nvports;
+}
+
+
 #endif
 
 
diff --git a/drivers/scsi/bfa/bfa_iocfc.h b/drivers/scsi/bfa/bfa_iocfc.h
index 3ee9fe7..a08309f 100644
--- a/drivers/scsi/bfa/bfa_iocfc.h
+++ b/drivers/scsi/bfa/bfa_iocfc.h
@@ -21,6 +21,7 @@
 #include <bfa_ioc.h>
 #include <bfa.h>
 #include <bfi/bfi_iocfc.h>
+#include <bfi/bfi_pbc.h>
 #include <bfa_callback_priv.h>
 
 #define BFA_REQQ_NELEMS_MIN	(4)
@@ -169,6 +170,8 @@ void bfa_com_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi,
 void bfa_iocfc_get_bootwwns(struct bfa_s *bfa, u8 *nwwns, wwn_t **wwns);
 void bfa_iocfc_get_pbc_boot_cfg(struct bfa_s *bfa,
 		struct bfa_boot_pbc_s *pbcfg);
+int bfa_iocfc_get_pbc_vports(struct bfa_s *bfa,
+		struct bfi_pbc_vport_s *pbc_vport);
 
 #endif /* __BFA_IOCFC_H__ */
 
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index d4a1dde..647fb0e 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -322,7 +322,31 @@ ext:
 	return rc;
 }
 
+/**
+ * @brief
+ * FCS PBC VPORT Create
+ */
+void
+bfa_fcb_pbc_vport_create(struct bfad_s *bfad, struct bfi_pbc_vport_s pbc_vport)
+{
+
+	struct bfad_pcfg_s *pcfg;
+
+	pcfg = kzalloc(sizeof(struct bfad_pcfg_s), GFP_ATOMIC);
+	if (!pcfg) {
+		bfa_trc(bfad, 0);
+		return;
+	}
 
+	pcfg->port_cfg.roles = BFA_PORT_ROLE_FCP_IM;
+	pcfg->port_cfg.pwwn = pbc_vport.vp_pwwn;
+	pcfg->port_cfg.nwwn = pbc_vport.vp_nwwn;
+	pcfg->port_cfg.preboot_vp  = BFA_TRUE;
+
+	list_add_tail(&pcfg->list_entry, &bfad->pbc_pcfg_list);
+
+	return;
+}
 
 void
 bfad_hal_mem_release(struct bfad_s *bfad)
@@ -481,10 +505,10 @@ ext:
  */
 bfa_status_t
 bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
-		  struct bfa_port_cfg_s *port_cfg, struct device *dev)
+			struct bfa_port_cfg_s *port_cfg, struct device *dev)
 {
 	struct bfad_vport_s *vport;
-	int             rc = BFA_STATUS_OK;
+	int rc = BFA_STATUS_OK;
 	unsigned long   flags;
 	struct completion fcomp;
 
@@ -496,8 +520,12 @@ bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
 
 	vport->drv_port.bfad = bfad;
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	rc = bfa_fcs_vport_create(&vport->fcs_vport, &bfad->bfa_fcs, vf_id,
-				  port_cfg, vport);
+	if (port_cfg->preboot_vp == BFA_TRUE)
+		rc = bfa_fcs_pbc_vport_create(&vport->fcs_vport,
+				&bfad->bfa_fcs, vf_id, port_cfg, vport);
+	else
+		rc = bfa_fcs_vport_create(&vport->fcs_vport,
+				&bfad->bfa_fcs, vf_id, port_cfg, vport);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
 	if (rc != BFA_STATUS_OK)
@@ -892,6 +920,7 @@ bfa_status_t
 bfad_start_ops(struct bfad_s *bfad)
 {
 	int retval;
+	struct bfad_pcfg_s *pcfg, *pcfg_new;
 
 	/* PPORT FCS config */
 	bfad_fcs_port_cfg(bfad);
@@ -909,6 +938,27 @@ bfad_start_ops(struct bfad_s *bfad)
 
 	bfad_drv_start(bfad);
 
+	/* pbc vport creation */
+	list_for_each_entry_safe(pcfg, pcfg_new,  &bfad->pbc_pcfg_list,
+					list_entry) {
+		struct fc_vport_identifiers vid;
+		struct fc_vport *fc_vport;
+
+		memset(&vid, 0, sizeof(vid));
+		vid.roles = FC_PORT_ROLE_FCP_INITIATOR;
+		vid.vport_type = FC_PORTTYPE_NPIV;
+		vid.disable = false;
+		vid.node_name = wwn_to_u64((u8 *)&pcfg->port_cfg.nwwn);
+		vid.port_name = wwn_to_u64((u8 *)&pcfg->port_cfg.pwwn);
+		fc_vport = fc_vport_create(bfad->pport.im_port->shost, 0, &vid);
+		if (!fc_vport)
+			printk(KERN_WARNING "bfad%d: failed to create pbc vport"
+				" %llx\n", bfad->inst_no, vid.port_name);
+		list_del(&pcfg->list_entry);
+		kfree(pcfg);
+
+	}
+
 	/*
 	 * If bfa_linkup_delay is set to -1 default; try to retrive the
 	 * value using the bfad_os_get_linkup_delay(); else use the
@@ -936,7 +986,7 @@ out_cfg_pport_failure:
 }
 
 int
-bfad_worker (void *ptr)
+bfad_worker(void *ptr)
 {
 	struct bfad_s *bfad;
 	unsigned long   flags;
@@ -1039,6 +1089,7 @@ bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid)
 
 	bfad->ref_count = 0;
 	bfad->pport.bfad = bfad;
+	INIT_LIST_HEAD(&bfad->pbc_pcfg_list);
 
 	bfad->bfad_tsk = kthread_create(bfad_worker, (void *) bfad, "%s",
 					"bfad_worker");
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 8e9b5c4..2b5d5c2 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -762,47 +762,53 @@ bfad_im_vport_create(struct fc_vport *fc_vport, bool disable)
 		(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s *bfad = im_port->bfad;
 	struct bfa_port_cfg_s port_cfg;
+	struct bfad_pcfg_s *pcfg;
 	int status = 0, rc;
 	unsigned long flags;
 
 	memset(&port_cfg, 0, sizeof(port_cfg));
-
-	port_cfg.pwwn = wwn_to_u64((u8 *) &fc_vport->port_name);
-	port_cfg.nwwn = wwn_to_u64((u8 *) &fc_vport->node_name);
-
+	u64_to_wwn(fc_vport->node_name, (u8 *)&port_cfg.nwwn);
+	u64_to_wwn(fc_vport->port_name, (u8 *)&port_cfg.pwwn);
 	if (strlen(vname) > 0)
 		strcpy((char *)&port_cfg.sym_name, vname);
-
 	port_cfg.roles = BFA_PORT_ROLE_FCP_IM;
-	rc = bfad_vport_create(bfad, 0, &port_cfg, &fc_vport->dev);
 
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	list_for_each_entry(pcfg, &bfad->pbc_pcfg_list, list_entry) {
+		if (port_cfg.pwwn == pcfg->port_cfg.pwwn) {
+			port_cfg.preboot_vp = pcfg->port_cfg.preboot_vp;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	rc = bfad_vport_create(bfad, 0, &port_cfg, &fc_vport->dev);
 	if (rc == BFA_STATUS_OK) {
-		struct bfad_vport_s   *vport;
+		struct bfad_vport_s *vport;
 		struct bfa_fcs_vport_s *fcs_vport;
 		struct Scsi_Host *vshost;
 
 		spin_lock_irqsave(&bfad->bfad_lock, flags);
 		fcs_vport = bfa_fcs_vport_lookup(&bfad->bfa_fcs, 0,
 					port_cfg.pwwn);
-		if (fcs_vport == NULL) {
-			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		if (fcs_vport == NULL)
 			return VPCERR_BAD_WWN;
-		}
 
 		fc_vport_set_state(fc_vport, FC_VPORT_ACTIVE);
 		if (disable) {
+			spin_lock_irqsave(&bfad->bfad_lock, flags);
 			bfa_fcs_vport_stop(fcs_vport);
+			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 			fc_vport_set_state(fc_vport, FC_VPORT_DISABLED);
 		}
-		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
 		vport = fcs_vport->vport_drv;
 		vshost = vport->drv_port.im_port->shost;
-		fc_host_node_name(vshost) = wwn_to_u64((u8 *) &port_cfg.nwwn);
-		fc_host_port_name(vshost) = wwn_to_u64((u8 *) &port_cfg.pwwn);
+		fc_host_node_name(vshost) = wwn_to_u64((u8 *)&port_cfg.nwwn);
+		fc_host_port_name(vshost) = wwn_to_u64((u8 *)&port_cfg.pwwn);
 		fc_vport->dd_data = vport;
 		vport->drv_port.im_port->fc_vport = fc_vport;
-
 	} else if (rc == BFA_STATUS_INVALID_WWN)
 		return VPCERR_BAD_WWN;
 	else if (rc == BFA_STATUS_VPORT_EXISTS)
@@ -811,7 +817,7 @@ bfad_im_vport_create(struct fc_vport *fc_vport, bool disable)
 		return VPCERR_NO_FABRIC_SUPP;
 	else if (rc == BFA_STATUS_VPORT_WWN_BP)
 		return VPCERR_BAD_WWN;
-	 else
+	else
 		return FC_VPORT_FAILED;
 
 	return status;
@@ -838,7 +844,7 @@ bfad_im_vport_delete(struct fc_vport *fc_vport)
 	port = im_port->port;
 
 	vshost = vport->drv_port.im_port->shost;
-	pwwn = wwn_to_u64((u8 *) &fc_host_port_name(vshost));
+	u64_to_wwn(fc_host_port_name(vshost), (u8 *)&pwwn);
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	fcs_vport = bfa_fcs_vport_lookup(&bfad->bfa_fcs, 0, pwwn);
@@ -856,6 +862,9 @@ bfad_im_vport_delete(struct fc_vport *fc_vport)
 	rc = bfa_fcs_vport_delete(&vport->fcs_vport);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
+	if (rc == BFA_STATUS_PBC)
+		return -1;
+
 	wait_for_completion(vport->comp_del);
 
 free_scsi_host:
@@ -879,7 +888,7 @@ bfad_im_vport_disable(struct fc_vport *fc_vport, bool disable)
 	vport = (struct bfad_vport_s *)fc_vport->dd_data;
 	bfad = vport->drv_port.bfad;
 	vshost = vport->drv_port.im_port->shost;
-	pwwn = wwn_to_u64((u8 *) &fc_vport->port_name);
+	u64_to_wwn(fc_host_port_name(vshost), (u8 *)&pwwn);
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	fcs_vport = bfa_fcs_vport_lookup(&bfad->bfa_fcs, 0, pwwn);
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 2797723..5de43c3 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -120,6 +120,8 @@ struct bfad_vport_s {
 	struct bfad_port_s     drv_port;
 	struct bfa_fcs_vport_s fcs_vport;
 	struct completion *comp_del;
+	struct list_head list_entry;
+	struct bfa_port_cfg_s port_cfg;
 };
 
 /*
@@ -195,12 +197,18 @@ struct bfad_s {
 	bfa_boolean_t	ipfc_enabled;
 	union bfad_tmp_buf tmp_buf;
 	struct fc_host_statistics link_stats;
+	struct list_head pbc_pcfg_list;
 	u32 fwtrc_len;
 	char *fwtrc;
 	u32 reglen;
 	char *regdata;
 };
 
+struct bfad_pcfg_s {
+	struct list_head list_entry;
+	struct bfa_port_cfg_s port_cfg;
+};
+
 /*
  * RPORT data structure
  */
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 5b7cf53..0dff0d4 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -567,6 +567,7 @@ bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
 
 out_fc_rel:
 	scsi_host_put(im_port->shost);
+	im_port->shost = NULL;
 out_free_idr:
 	mutex_lock(&bfad_mutex);
 	idr_remove(&bfad_im_port_index, im_port->idr_id);
diff --git a/drivers/scsi/bfa/fabric.c b/drivers/scsi/bfa/fabric.c
index 8166e97..9315383 100644
--- a/drivers/scsi/bfa/fabric.c
+++ b/drivers/scsi/bfa/fabric.c
@@ -789,7 +789,7 @@ bfa_fcs_fabric_delete(struct bfa_fcs_fabric_s *fabric)
 
 	list_for_each_safe(qe, qen, &fabric->vport_q) {
 		vport = (struct bfa_fcs_vport_s *)qe;
-		bfa_fcs_vport_delete(vport);
+		bfa_fcs_vport_fcs_delete(vport);
 	}
 
 	bfa_fcs_port_delete(&fabric->bport);
diff --git a/drivers/scsi/bfa/fcs_vport.h b/drivers/scsi/bfa/fcs_vport.h
index 13c32eb..bb647a4 100644
--- a/drivers/scsi/bfa/fcs_vport.h
+++ b/drivers/scsi/bfa/fcs_vport.h
@@ -26,6 +26,7 @@ void bfa_fcs_vport_cleanup(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_online(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_offline(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_delete_comp(struct bfa_fcs_vport_s *vport);
+void bfa_fcs_vport_fcs_delete(struct bfa_fcs_vport_s *vport);
 
 #endif /* __FCS_VPORT_H__ */
 
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_port.h b/drivers/scsi/bfa/include/defs/bfa_defs_port.h
index 501bc97..752a812 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_port.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_port.h
@@ -50,12 +50,12 @@ enum bfa_port_role {
  * FCS port configuration.
  */
 struct bfa_port_cfg_s {
-    wwn_t               pwwn;       /*  port wwn */
-    wwn_t               nwwn;       /*  node wwn */
-    struct bfa_port_symname_s  sym_name;   /*  vm port symbolic name */
-    enum bfa_port_role     roles;      /*  FCS port roles */
-	u32			rsvd;
-    u8             tag[16];	/*  opaque tag from application */
+	wwn_t               pwwn;       /*  port wwn */
+	wwn_t               nwwn;       /*  node wwn */
+	struct bfa_port_symname_s  sym_name;   /*  vm port symbolic name */
+	bfa_boolean_t       preboot_vp;  /* vport created from PBC */
+	enum bfa_port_role     roles;      /*  FCS port roles */
+	u8             tag[16];	/*  opaque tag from application */
 };
 
 /**
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_status.h b/drivers/scsi/bfa/include/defs/bfa_defs_status.h
index ec78b4c..819db5a 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_status.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_status.h
@@ -213,7 +213,8 @@ enum bfa_status {
 					     * loaded */
 	BFA_STATUS_CARD_TYPE_MISMATCH = 131, /*  Card type mismatch */
 	BFA_STATUS_BAD_ASICBLK = 132, /*  Bad ASIC block */
-	BFA_STATUS_NO_DRIVER = 133, /*  Brocade adapter/driver not installed or loaded */
+	BFA_STATUS_NO_DRIVER = 133, /*  Brocade adapter/driver not installed
+				     *  or loaded */
 	BFA_STATUS_INVALID_MAC = 134, /*  Invalid mac address */
 	BFA_STATUS_IM_NO_VLAN = 135, /*  No VLANs configured on the adapter */
 	BFA_STATUS_IM_ETH_LB_FAILED = 136, /*  Ethernet loopback test failed */
@@ -249,6 +250,8 @@ enum bfa_status {
 	BFA_STATUS_IM_TEAM_CFG_NOT_ALLOWED = 153, /*  Given settings are not
 						* allowed for the current
 						* Teaming mode */
+	BFA_STATUS_PBC = 154, /* Operation not allowed for pre-boot
+			       * configuration */
 	BFA_STATUS_MAX_VAL		/*  Unknown error code */
 };
 #define bfa_status_t enum bfa_status
diff --git a/drivers/scsi/bfa/include/fcb/bfa_fcb_vport.h b/drivers/scsi/bfa/include/fcb/bfa_fcb_vport.h
index a39f474..cfd6ba7 100644
--- a/drivers/scsi/bfa/include/fcb/bfa_fcb_vport.h
+++ b/drivers/scsi/bfa/include/fcb/bfa_fcb_vport.h
@@ -40,7 +40,8 @@ struct bfad_vport_s;
  *
  * @return None
  */
-void            bfa_fcb_vport_delete(struct bfad_vport_s *vport_drv);
+void bfa_fcb_vport_delete(struct bfad_vport_s *vport_drv);
+void bfa_fcb_pbc_vport_create(struct bfad_s *bfad, struct bfi_pbc_vport_s);
 
 
 
diff --git a/drivers/scsi/bfa/include/fcs/bfa_fcs.h b/drivers/scsi/bfa/include/fcs/bfa_fcs.h
index f2fd35f..54e5b81 100644
--- a/drivers/scsi/bfa/include/fcs/bfa_fcs.h
+++ b/drivers/scsi/bfa/include/fcs/bfa_fcs.h
@@ -61,8 +61,8 @@ struct bfa_fcs_s {
 /*
  * bfa fcs API functions
  */
-void bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
-			bfa_boolean_t min_cfg);
+void bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa,
+			struct bfad_s *bfad, bfa_boolean_t min_cfg);
 void bfa_fcs_init(struct bfa_fcs_s *fcs);
 void bfa_fcs_driver_info_init(struct bfa_fcs_s *fcs,
 			struct bfa_fcs_driver_info_s *driver_info);
diff --git a/drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h b/drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h
index cd33f2c..0af2624 100644
--- a/drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h
+++ b/drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h
@@ -49,6 +49,10 @@ bfa_status_t bfa_fcs_vport_create(struct bfa_fcs_vport_s *vport,
 			struct bfa_fcs_s *fcs, u16 vf_id,
 			struct bfa_port_cfg_s *port_cfg,
 			struct bfad_vport_s *vport_drv);
+bfa_status_t bfa_fcs_pbc_vport_create(struct bfa_fcs_vport_s *vport,
+			struct bfa_fcs_s *fcs, uint16_t vf_id,
+			struct bfa_port_cfg_s *port_cfg,
+			struct bfad_vport_s *vport_drv);
 bfa_status_t bfa_fcs_vport_delete(struct bfa_fcs_vport_s *vport);
 bfa_status_t bfa_fcs_vport_start(struct bfa_fcs_vport_s *vport);
 bfa_status_t bfa_fcs_vport_stop(struct bfa_fcs_vport_s *vport);
diff --git a/drivers/scsi/bfa/vport.c b/drivers/scsi/bfa/vport.c
index 27cd619..f14e9f2 100644
--- a/drivers/scsi/bfa/vport.c
+++ b/drivers/scsi/bfa/vport.c
@@ -594,6 +594,15 @@ bfa_fcs_vport_cleanup(struct bfa_fcs_vport_s *vport)
 }
 
 /**
+ * delete notification from fabric SM. To be invoked from within FCS.
+ */
+void
+bfa_fcs_vport_fcs_delete(struct bfa_fcs_vport_s *vport)
+{
+	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_DELETE);
+}
+
+/**
  * Delete completion callback from associated lport
  */
 void
@@ -646,6 +655,7 @@ bfa_fcs_vport_create(struct bfa_fcs_vport_s *vport, struct bfa_fcs_s *fcs,
 		return BFA_STATUS_VPORT_MAX;
 
 	vport->vport_drv = vport_drv;
+	vport_cfg->preboot_vp = BFA_FALSE;
 	bfa_sm_set_state(vport, bfa_fcs_vport_sm_uninit);
 
 	bfa_fcs_lport_attach(&vport->lport, fcs, vf_id, vport);
@@ -657,6 +667,36 @@ bfa_fcs_vport_create(struct bfa_fcs_vport_s *vport, struct bfa_fcs_s *fcs,
 }
 
 /**
+ *      Use this function to instantiate a new FCS PBC vport object. This
+ *      function will not trigger any HW initialization process (which will be
+ *      done in vport_start() call)
+ *
+ *      param[in] vport        -       pointer to bfa_fcs_vport_t. This space
+ *                                      needs to be allocated by the driver.
+ *      param[in] fcs          -       FCS instance
+ *      param[in] vport_cfg    -       vport configuration
+ *      param[in] vf_id        -       VF_ID if vport is created within a VF.
+ *                                      FC_VF_ID_NULL to specify base fabric.
+ *      param[in] vport_drv    -       Opaque handle back to the driver's vport
+ *                                      structure
+ *
+ *      retval BFA_STATUS_OK - on success.
+ *      retval BFA_STATUS_FAILED - on failure.
+ */
+bfa_status_t
+bfa_fcs_pbc_vport_create(struct bfa_fcs_vport_s *vport, struct bfa_fcs_s *fcs,
+			uint16_t vf_id, struct bfa_port_cfg_s *vport_cfg,
+			struct bfad_vport_s *vport_drv)
+{
+	bfa_status_t rc;
+
+	rc = bfa_fcs_vport_create(vport, fcs, vf_id, vport_cfg, vport_drv);
+	vport->lport.port_cfg.preboot_vp = BFA_TRUE;
+
+	return rc;
+}
+
+/**
  *  	Use this function initialize the vport.
  *
  *  @param[in] vport - pointer to bfa_fcs_vport_t.
@@ -692,6 +732,8 @@ bfa_fcs_vport_stop(struct bfa_fcs_vport_s *vport)
  *  	Use this function to delete a vport object. Fabric object should
  * 		be stopped before this function call.
  *
+ *	Donot invoke this from within FCS
+ *
  * 	param[in] vport - pointer to bfa_fcs_vport_t.
  *
  * 	return     None
@@ -699,6 +741,9 @@ bfa_fcs_vport_stop(struct bfa_fcs_vport_s *vport)
 bfa_status_t
 bfa_fcs_vport_delete(struct bfa_fcs_vport_s *vport)
 {
+	if (vport->lport.port_cfg.preboot_vp)
+		return BFA_STATUS_PBC;
+
 	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_DELETE);
 
 	return BFA_STATUS_OK;
-- 
1.6.5.2

