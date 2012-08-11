From: <kgudipat@brocade.com>
Subject: [RFC - PATCH 2/3] bfa: Revert current LUN Masking implementation using slave callouts
Date: Fri, 10 Aug 2012 19:36:17 -0700
Message-ID: <1344652577-14286-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:34385 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382Ab2HKChG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2012 22:37:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, revers@redhat.com, michaelc@cs.wisc.edu, hch@infradead.org
Cc: adapter_linux_open_src_team@brocade.com, amathur@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Temporarily revert the current LUN Masking implementation using slave_callouts.
	- Please NOTE this is currently an RFC patch and it is done for clear review of
	  how an LLD will use LUN Masking implementation in scsi mid-layer.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfad_bsg.c |   27 ++-------------------
 drivers/scsi/bfa/bfad_im.c  |   54 -------------------------------------------
 drivers/scsi/bfa/bfad_im.h  |   26 --------------------
 3 files changed, 3 insertions(+), 104 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 9c1495b..3c176b4 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -2353,21 +2353,6 @@ out:
 	return 0;
 }
 
-/* Function to reset the LUN SCAN mode */
-static void
-bfad_iocmd_lunmask_reset_lunscan_mode(struct bfad_s *bfad, int lunmask_cfg)
-{
-	struct bfad_im_port_s *pport_im = bfad->pport.im_port;
-	struct bfad_vport_s *vport = NULL;
-
-	/* Set the scsi device LUN SCAN flags for base port */
-	bfad_reset_sdev_bflags(pport_im, lunmask_cfg);
-
-	/* Set the scsi device LUN SCAN flags for the vports */
-	list_for_each_entry(vport, &bfad->vport_list, list_entry)
-		bfad_reset_sdev_bflags(vport->drv_port.im_port, lunmask_cfg);
-}
-
 int
 bfad_iocmd_lunmask(struct bfad_s *bfad, void *pcmd, unsigned int v_cmd)
 {
@@ -2375,17 +2360,11 @@ bfad_iocmd_lunmask(struct bfad_s *bfad, void *pcmd, unsigned int v_cmd)
 	unsigned long	flags;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	if (v_cmd == IOCMD_FCPIM_LUNMASK_ENABLE) {
+	if (v_cmd == IOCMD_FCPIM_LUNMASK_ENABLE)
 		iocmd->status = bfa_fcpim_lunmask_update(&bfad->bfa, BFA_TRUE);
-		/* Set the LUN Scanning mode to be Sequential scan */
-		if (iocmd->status == BFA_STATUS_OK)
-			bfad_iocmd_lunmask_reset_lunscan_mode(bfad, BFA_TRUE);
-	} else if (v_cmd == IOCMD_FCPIM_LUNMASK_DISABLE) {
+	else if (v_cmd == IOCMD_FCPIM_LUNMASK_DISABLE)
 		iocmd->status = bfa_fcpim_lunmask_update(&bfad->bfa, BFA_FALSE);
-		/* Set the LUN Scanning mode to default REPORT_LUNS scan */
-		if (iocmd->status == BFA_STATUS_OK)
-			bfad_iocmd_lunmask_reset_lunscan_mode(bfad, BFA_FALSE);
-	} else if (v_cmd == IOCMD_FCPIM_LUNMASK_CLEAR)
+	else if (v_cmd == IOCMD_FCPIM_LUNMASK_CLEAR)
 		iocmd->status = bfa_fcpim_lunmask_clear(&bfad->bfa);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 	return 0;
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 2eebf8d..e4a5a23 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -914,70 +914,16 @@ bfad_get_itnim(struct bfad_im_port_s *im_port, int id)
 }
 
 /*
- * Function is invoked from the SCSI Host Template slave_alloc() entry point.
- * Has the logic to query the LUN Mask database to check if this LUN needs to
- * be made visible to the SCSI mid-layer or not.
- *
- * Returns BFA_STATUS_OK if this LUN needs to be added to the OS stack.
- * Returns -ENXIO to notify SCSI mid-layer to not add this LUN to the OS stack.
- */
-static int
-bfad_im_check_if_make_lun_visible(struct scsi_device *sdev,
-				  struct fc_rport *rport)
-{
-	struct bfad_itnim_data_s *itnim_data =
-				(struct bfad_itnim_data_s *) rport->dd_data;
-	struct bfa_s *bfa = itnim_data->itnim->bfa_itnim->bfa;
-	struct bfa_rport_s *bfa_rport = itnim_data->itnim->bfa_itnim->rport;
-	struct bfa_lun_mask_s *lun_list = bfa_get_lun_mask_list(bfa);
-	int i = 0, ret = -ENXIO;
-
-	for (i = 0; i < MAX_LUN_MASK_CFG; i++) {
-		if (lun_list[i].state == BFA_IOIM_LUN_MASK_ACTIVE &&
-		    scsilun_to_int(&lun_list[i].lun) == sdev->lun &&
-		    lun_list[i].rp_tag == bfa_rport->rport_tag &&
-		    lun_list[i].lp_tag == (u8)bfa_rport->rport_info.lp_tag) {
-			ret = BFA_STATUS_OK;
-			break;
-		}
-	}
-	return ret;
-}
-
-/*
  * Scsi_Host template entry slave_alloc
  */
 static int
 bfad_im_slave_alloc(struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
-	struct bfad_itnim_data_s *itnim_data =
-				(struct bfad_itnim_data_s *) rport->dd_data;
-	struct bfa_s *bfa = itnim_data->itnim->bfa_itnim->bfa;
 
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
 
-	if (bfa_get_lun_mask_status(bfa) == BFA_LUNMASK_ENABLED) {
-		/*
-		 * We should not mask LUN 0 - since this will translate
-		 * to no LUN / TARGET for SCSI ml resulting no scan.
-		 */
-		if (sdev->lun == 0) {
-			sdev->sdev_bflags |= BLIST_NOREPORTLUN |
-					     BLIST_SPARSELUN;
-			goto done;
-		}
-
-		/*
-		 * Query LUN Mask configuration - to expose this LUN
-		 * to the SCSI mid-layer or to mask it.
-		 */
-		if (bfad_im_check_if_make_lun_visible(sdev, rport) !=
-							BFA_STATUS_OK)
-			return -ENXIO;
-	}
-done:
 	sdev->hostdata = rport->dd_data;
 
 	return 0;
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index f6c1023..0bdbd43 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -168,30 +168,4 @@ irqreturn_t bfad_intx(int irq, void *dev_id);
 int bfad_im_bsg_request(struct fc_bsg_job *job);
 int bfad_im_bsg_timeout(struct fc_bsg_job *job);
 
-/*
- * Macro to set the SCSI device sdev_bflags - sdev_bflags are used by the
- * SCSI mid-layer to choose LUN Scanning mode REPORT_LUNS vs. Sequential Scan
- *
- * Internally iterate's over all the ITNIM's part of the im_port & set's the
- * sdev_bflags for the scsi_device associated with LUN #0.
- */
-#define bfad_reset_sdev_bflags(__im_port, __lunmask_cfg) do {		\
-	struct scsi_device *__sdev = NULL;				\
-	struct bfad_itnim_s *__itnim = NULL;				\
-	u32 scan_flags = BLIST_NOREPORTLUN | BLIST_SPARSELUN;		\
-	list_for_each_entry(__itnim, &((__im_port)->itnim_mapped_list),	\
-			    list_entry) {				\
-		__sdev = scsi_device_lookup((__im_port)->shost,		\
-					    __itnim->channel,		\
-					    __itnim->scsi_tgt_id, 0);	\
-		if (__sdev) {						\
-			if ((__lunmask_cfg) == BFA_TRUE)		\
-				__sdev->sdev_bflags |= scan_flags;	\
-			else						\
-				__sdev->sdev_bflags &= ~scan_flags;	\
-			scsi_device_put(__sdev);			\
-		}							\
-	}								\
-} while (0)
-
 #endif
-- 
1.7.3.rc1

