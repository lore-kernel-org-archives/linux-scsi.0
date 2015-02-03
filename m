From: <anil.gurumurthy@qlogic.com>
Subject: [PATCH RESEND 2/4] bfa:Fix for crash when bfa_itnim is NULL
Date: Tue, 3 Feb 2015 03:45:01 -0500
Message-ID: <1422953103-5470-3-git-send-email-anil.gurumurthy@qlogic.com>
References: <1422953103-5470-1-git-send-email-anil.gurumurthy@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:13023 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254AbbBCJYk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2015 04:24:40 -0500
In-Reply-To: <1422953103-5470-1-git-send-email-anil.gurumurthy@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Anil Gurumurthy <anil.gurumurthy@qlogic.com>

From: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

    Signed-off-by: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
    Signed-off-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
---
 drivers/scsi/bfa/bfad_im.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 575efdc..3e4dce7 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -272,6 +272,19 @@ bfad_im_target_reset_send(struct bfad_s *bfad, struct scsi_cmnd *cmnd,
 	cmnd->host_scribble = NULL;
 	cmnd->SCp.Status = 0;
 	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
+	/*
+	 * bfa_itnim can be NULL if the port gets disconnected and the bfa
+	 * and fcs layers have cleaned up their nexus with the targets and
+	 * the same has not been cleaned up by the shim
+	 */
+	if (bfa_itnim == NULL) {
+		bfa_tskim_free(tskim);
+		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
+			"target reset, bfa_itnim is NULL\n");
+		rc = BFA_STATUS_FAILED;
+		goto out;
+	}
+
 	memset(&scsilun, 0, sizeof(scsilun));
 	bfa_tskim_start(tskim, bfa_itnim, scsilun,
 			    FCP_TM_TARGET_RESET, BFAD_TARGET_RESET_TMO);
@@ -327,6 +340,19 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 	cmnd->SCp.ptr = (char *)&wq;
 	cmnd->SCp.Status = 0;
 	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
+	/*
+	 * bfa_itnim can be NULL if the port gets disconnected and the bfa
+	 * and fcs layers have cleaned up their nexus with the targets and
+	 * the same has not been cleaned up by the shim
+	 */
+	if (bfa_itnim == NULL) {
+		bfa_tskim_free(tskim);
+		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
+			"lun reset, bfa_itnim is NULL\n");
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		rc = FAILED;
+		goto out;
+	}
 	int_to_scsilun(cmnd->device->lun, &scsilun);
 	bfa_tskim_start(tskim, bfa_itnim, scsilun,
 			    FCP_TM_LUN_RESET, BFAD_LUN_RESET_TMO);
-- 
1.7.1

