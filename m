From: <kgudipat@brocade.com>
Subject: [RFC - PATCH 3/3] bfa: Implement LUN Masking using SCSI mid-layer LUN Masking support.
Date: Fri, 10 Aug 2012 19:36:52 -0700
Message-ID: <1344652612-14600-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:43593 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382Ab2HKCh2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2012 22:37:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, revers@redhat.com, michaelc@cs.wisc.edu, hch@infradead.org
Cc: adapter_linux_open_src_team@brocade.com, amathur@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Re-implemented LUN Masking feature using SCSI mid-layer LUN Masking support.
	- Implemented support to dynamically enable or disable LUN Masking from LLD
	  using SCSI mid-layer API scsi_target_config_lunmask().
	- Implemented support to dynamically add/remove LUNs from scsi_target LUN Masking
	  list from LLD using the SCSI mid-layer APIs. If LUN Masking is enabled the LUNs
	  part of the LUN Masking list are the ones that are made visible during the
	  SCSI scan and rest of the LUNs discovered are not added to the sysfs and removed.
	- Implemented target_alloc SCSI host template entry point to configure LUN Masking
	  on that target, add LUNs to the scsi_target masked_lun_list from LLD during a
	  new target discovery.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfad_bsg.c |   63 ++++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/bfa/bfad_im.c  |   56 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfad_im.h  |   13 +++++++++
 3 files changed, 129 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 3c176b4..96df4d8 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -2353,6 +2353,23 @@ out:
 	return 0;
 }
 
+/*
+ * Function to enable / disable LUN Masking in scsi mid-layer.
+ */
+static void
+bfad_iocmd_scsi_lunmask_config(struct bfad_s *bfad, int lunmask_cfg)
+{
+	struct bfad_im_port_s *pport_im = bfad->pport.im_port;
+	struct bfad_vport_s *vport = NULL;
+
+	/* Pass LUN Masking config to the SCSI stack - for base port */
+	bfad_config_starget_lm(pport_im, lunmask_cfg);
+
+	/* Pass LUN Masking config to the SCSI stack - for the vports */
+	list_for_each_entry(vport, &bfad->vport_list, list_entry)
+		bfad_config_starget_lm(vport->drv_port.im_port, lunmask_cfg);
+}
+
 int
 bfad_iocmd_lunmask(struct bfad_s *bfad, void *pcmd, unsigned int v_cmd)
 {
@@ -2360,11 +2377,15 @@ bfad_iocmd_lunmask(struct bfad_s *bfad, void *pcmd, unsigned int v_cmd)
 	unsigned long	flags;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	if (v_cmd == IOCMD_FCPIM_LUNMASK_ENABLE)
+	if (v_cmd == IOCMD_FCPIM_LUNMASK_ENABLE) {
 		iocmd->status = bfa_fcpim_lunmask_update(&bfad->bfa, BFA_TRUE);
-	else if (v_cmd == IOCMD_FCPIM_LUNMASK_DISABLE)
+		if (iocmd->status == BFA_STATUS_OK)
+			bfad_iocmd_scsi_lunmask_config(bfad, BFA_TRUE);
+	} else if (v_cmd == IOCMD_FCPIM_LUNMASK_DISABLE) {
 		iocmd->status = bfa_fcpim_lunmask_update(&bfad->bfa, BFA_FALSE);
-	else if (v_cmd == IOCMD_FCPIM_LUNMASK_CLEAR)
+		if (iocmd->status == BFA_STATUS_OK)
+			bfad_iocmd_scsi_lunmask_config(bfad, BFA_FALSE);
+	} else if (v_cmd == IOCMD_FCPIM_LUNMASK_CLEAR)
 		iocmd->status = bfa_fcpim_lunmask_clear(&bfad->bfa);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 	return 0;
@@ -2384,6 +2405,40 @@ bfad_iocmd_fcpim_lunmask_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
+/*
+ * Function to add/remove a LUN to the scsi_target masked_lun_list
+ */
+int
+bfad_config_stgt_lunmask_list(struct bfad_s *bfad, unsigned int v_cmd,
+			      struct bfa_bsg_fcpim_lunmask_s *iocmd)
+{
+	struct bfa_fcs_lport_s *port = NULL;
+	struct bfa_fcs_rport_s *rp_fcs = NULL;
+	struct bfad_itnim_s *itnim_drv = NULL;
+	int rc = 0;
+
+	port = bfa_fcs_lookup_port(&bfad->bfa_fcs, iocmd->vf_id, iocmd->pwwn);
+	if (!port)
+		return BFA_STATUS_UNKNOWN_LWWN;
+
+	rp_fcs = bfa_fcs_lport_get_rport_by_pwwn(port, iocmd->rpwwn);
+	if (!rp_fcs)
+		return BFA_STATUS_UNKNOWN_RWWN;
+
+	itnim_drv = rp_fcs->itnim->itnim_drv;
+
+	if (v_cmd == IOCMD_FCPIM_LUNMASK_ADD)
+		rc = scsi_target_mask_lun(itnim_drv->im_port->shost,
+				itnim_drv->channel, itnim_drv->scsi_tgt_id,
+				scsilun_to_int(&iocmd->lun));
+	else if (v_cmd == IOCMD_FCPIM_LUNMASK_DELETE)
+		rc = scsi_target_unmask_lun(itnim_drv->im_port->shost,
+				itnim_drv->channel, itnim_drv->scsi_tgt_id,
+				scsilun_to_int(&iocmd->lun));
+
+	return rc;
+}
+
 int
 bfad_iocmd_fcpim_cfg_lunmask(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
@@ -2399,6 +2454,8 @@ bfad_iocmd_fcpim_cfg_lunmask(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 		iocmd->status = bfa_fcpim_lunmask_delete(&bfad->bfa,
 					iocmd->vf_id, &iocmd->pwwn,
 					iocmd->rpwwn, iocmd->lun);
+
+	bfad_config_stgt_lunmask_list(bfad, v_cmd, iocmd);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 	return 0;
 }
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index e4a5a23..1e2e122 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -33,6 +33,7 @@ struct scsi_transport_template *bfad_im_scsi_vport_transport_template;
 static void bfad_im_itnim_work_handler(struct work_struct *work);
 static int bfad_im_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmnd);
 static int bfad_im_slave_alloc(struct scsi_device *sdev);
+static int bfad_im_target_alloc(struct scsi_target *starget);
 static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
 				struct bfad_itnim_s *itnim);
 
@@ -795,6 +796,7 @@ struct scsi_host_template bfad_im_scsi_host_template = {
 	.eh_device_reset_handler = bfad_im_reset_lun_handler,
 	.eh_bus_reset_handler = bfad_im_reset_bus_handler,
 
+	.target_alloc = bfad_im_target_alloc,
 	.slave_alloc = bfad_im_slave_alloc,
 	.slave_configure = bfad_im_slave_configure,
 	.slave_destroy = bfad_im_slave_destroy,
@@ -914,6 +916,60 @@ bfad_get_itnim(struct bfad_im_port_s *im_port, int id)
 }
 
 /*
+ * Scsi_Host template entry target_alloc
+ * We use this entry point to configure LUN Masking in the SCSI mid-layer
+ * and to add new luns that need to be part of the SCSI target lun mask list.
+ */
+static int
+bfad_im_target_alloc(struct scsi_target *starget)
+{
+	struct fc_rport *rport = starget_to_rport(starget);
+	struct bfad_itnim_data_s *itnim_data;
+	struct bfa_s *bfa;
+
+	if (!rport || fc_remote_port_chkready(rport))
+		return -ENXIO;
+
+	itnim_data = (struct bfad_itnim_data_s *) rport->dd_data;
+	bfa = itnim_data->itnim->bfa_itnim->bfa;
+
+	if (bfa_get_lun_mask_status(bfa) == BFA_LUNMASK_ENABLED) {
+
+		struct Scsi_Host *shost = itnim_data->itnim->im_port->shost;
+		struct bfa_rport_s *bfa_rport =
+					itnim_data->itnim->bfa_itnim->rport;
+		struct bfa_lun_mask_s *lun_list = bfa_get_lun_mask_list(bfa);
+		int i = 0, rc = 0;
+
+		/* Enable LUN Masking in the SCSI mid-layer for this target */
+		scsi_target_config_lunmask(shost, itnim_data->itnim->channel,
+					   itnim_data->itnim->scsi_tgt_id, 1);
+		printk(KERN_INFO "%s Enabling LUN Masking on shost:%d\n",
+			__func__, shost->host_no);
+
+		/* Populate the SCSI mid-layer LUN Mask list */
+		for (i = 0; i < MAX_LUN_MASK_CFG; i++) {
+			if (lun_list[i].state == BFA_IOIM_LUN_MASK_ACTIVE &&
+			    lun_list[i].rp_tag == bfa_rport->rport_tag &&
+			    lun_list[i].lp_tag ==
+			    (u8)bfa_rport->rport_info.lp_tag) {
+				rc = scsi_target_mask_lun(shost,
+					    itnim_data->itnim->channel,
+					    itnim_data->itnim->scsi_tgt_id,
+					    scsilun_to_int(&lun_list[i].lun));
+				printk(KERN_INFO "%s tgt_id: %d channel: %d "
+					" LUN: %d added to SCSI ml\n", __func__,
+					itnim_data->itnim->scsi_tgt_id,
+					itnim_data->itnim->channel,
+					scsilun_to_int(&lun_list[i].lun));
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
  * Scsi_Host template entry slave_alloc
  */
 static int
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index 0bdbd43..0bee0c0 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -168,4 +168,17 @@ irqreturn_t bfad_intx(int irq, void *dev_id);
 int bfad_im_bsg_request(struct fc_bsg_job *job);
 int bfad_im_bsg_timeout(struct fc_bsg_job *job);
 
+/*
+ * TODO: No need to enable LUN Masking on all targets, only enable for the
+ * targets part of the LUN Masking config, check using the rport pwwn.
+ */
+#define bfad_config_starget_lm(__im_port, __lunmask_cfg) do {		\
+	struct bfad_itnim_s *__itnim = NULL;				\
+	list_for_each_entry(__itnim, &((__im_port)->itnim_mapped_list),	\
+			    list_entry)					\
+		scsi_target_config_lunmask((__im_port)->shost,		\
+				__itnim->channel, __itnim->scsi_tgt_id,	\
+				__lunmask_cfg);				\
+} while (0)
+
 #endif
-- 
1.7.3.rc1

