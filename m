From: James Smart <james.smart@emulex.com>
Subject: [PATCH 08/10] lpfc 8.3.32: Fix system panic due to node state change
Date: Tue, 12 Jun 2012 13:54:59 -0400
Message-ID: <1339523700.2162.8.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:17711 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752720Ab2FLRzW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2012 13:55:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix System Panic During IO Test using Medusa tool


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-06-08 11:55:46.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-06-08 11:55:48.000000000 -0400
@@ -4275,10 +4275,8 @@ lpfc_queuecommand_lck(struct scsi_cmnd *
 	 * Catch race where our node has transitioned, but the
 	 * transport is still transitioning.
 	 */
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
-		cmnd->result = ScsiResult(DID_IMM_RETRY, 0);
-		goto out_fail_command;
-	}
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+		goto out_tgt_busy;
 	if (atomic_read(&ndlp->cmd_pending) >= ndlp->cmd_qdepth)
 		goto out_tgt_busy;
 



