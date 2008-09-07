From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/3] lpfc 8.2.8 v2 : Revert target busy in favor of
	transport disrupted
Date: Sun, 07 Sep 2008 11:51:56 -0400
Message-ID: <1220802716.6747.11.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:61720 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbYIGPxR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2008 11:53:17 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m87FrG9S026396
	for <linux-scsi@vger.kernel.org>; Sun, 7 Sep 2008 08:53:16 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Revert the target busy response in favor of the transport disrupted
response for node state transitions.

 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-09-07 10:28:20.000000000 -0400
@@ -1071,8 +1071,10 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	 * Catch race where our node has transitioned, but the
 	 * transport is still transitioning.
 	 */
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
-		goto out_target_busy;
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+		cmnd->result = ScsiResult(DID_TRANSPORT_DISRUPTED, 0);
+		goto out_fail_command;
+	}
 
 	lpfc_cmd = lpfc_get_scsi_buf(phba);
 	if (lpfc_cmd == NULL) {
@@ -1118,8 +1120,6 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
  out_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
- out_target_busy:
-	return SCSI_MLQUEUE_TARGET_BUSY;
 
  out_fail_command:
 	done(cmnd);


