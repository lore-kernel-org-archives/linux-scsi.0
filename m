From: michaelc@cs.wisc.edu
Subject: [PATCH 4/6] lpfc: use SCSI_MLQUEUE_TARGET_BUSY when catching the rport transition race
Date: Sun, 17 Aug 2008 15:24:41 -0500
Message-ID: <1219004683-6468-5-git-send-email-michaelc@cs.wisc.edu>
References: <1219004683-6468-1-git-send-email-michaelc@cs.wisc.edu>
 <1219004683-6468-2-git-send-email-michaelc@cs.wisc.edu>
 <1219004683-6468-3-git-send-email-michaelc@cs.wisc.edu>
 <1219004683-6468-4-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47576 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbYHQUZT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Aug 2008 16:25:19 -0400
In-Reply-To: <1219004683-6468-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Smart <James.Smart@Emulex.Com>

From: Mike Christie <michaelc@cs.wisc.edu>

We do want to call right back into the queuecommand during the race,
so we can just use SCSI_MLQUEUE_TARGET_BUSY.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Smart <James.Smart@Emulex.Com>

---
 drivers/scsi/lpfc/lpfc_scsi.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 1bcebbd..a22bdf9 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -966,10 +966,9 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	 * Catch race where our node has transitioned, but the
 	 * transport is still transitioning.
 	 */
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
-		cmnd->result = ScsiResult(DID_BUS_BUSY, 0);
-		goto out_fail_command;
-	}
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+		goto out_target_busy;
+
 	lpfc_cmd = lpfc_get_scsi_buf(phba);
 	if (lpfc_cmd == NULL) {
 		lpfc_adjust_queue_depth(phba);
@@ -1014,6 +1013,8 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
  out_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
+ out_target_busy:
+	return SCSI_MLQUEUE_TARGET_BUSY;
 
  out_fail_command:
 	done(cmnd);
-- 
1.5.4.1

