From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 11/15] lpfc 8.2.8 : Update driver to use new Host byte
	error code DID_TRANSPORT_DISRUPTED
Date: Sun, 24 Aug 2008 21:50:18 -0400
Message-ID: <1219629018.7890.41.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52511 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbYHYBuP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2008 21:50:15 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m7P1oENk019999
	for <linux-scsi@vger.kernel.org>; Sun, 24 Aug 2008 18:50:14 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update driver to use new Host byte error code DID_TRANSPORT_DISRUPTED.

This patch depends pending upstream patches described in:
http://marc.info/?l=linux-scsi&m=121263014808604&w=2

Particularly:
http://marc.info/?l=linux-scsi&m=121263014908607&w=2
which defines DID_TRANSPORT_DISRUPTED.

This patch supercedes the lpfc patch in that series:
http://marc.info/?l=linux-scsi&m=121263015008616&w=2


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-08-24 20:47:07.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-08-24 20:49:21.000000000 -0400
@@ -653,7 +653,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 			break;
 		case IOSTAT_NPORT_BSY:
 		case IOSTAT_FABRIC_BSY:
-			cmd->result = ScsiResult(DID_BUS_BUSY, 0);
+			cmd->result = ScsiResult(DID_TRANSPORT_DISRUPTED, 0);
 			break;
 		case IOSTAT_LOCAL_REJECT:
 			if (lpfc_cmd->result == IOERR_INVALID_RPI ||
@@ -669,7 +669,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 
 		if (!pnode || !NLP_CHK_NODE_ACT(pnode)
 		    || (pnode->nlp_state != NLP_STE_MAPPED_NODE))
-			cmd->result = ScsiResult(DID_BUS_BUSY, SAM_STAT_BUSY);
+			cmd->result = ScsiResult(DID_TRANSPORT_DISRUPTED,
+			SAM_STAT_BUSY);
 	} else {
 		cmd->result = ScsiResult(DID_OK, 0);
 	}
@@ -1071,7 +1072,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	 * transport is still transitioning.
 	 */
 	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
-		cmnd->result = ScsiResult(DID_BUS_BUSY, 0);
+		cmnd->result = ScsiResult(DID_TRANSPORT_DISRUPTED, 0);
 		goto out_fail_command;
 	}
 	lpfc_cmd = lpfc_get_scsi_buf(phba);


