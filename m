From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/7] lpfc 8.3.44: Fixed stopped FCF discovery on failed FCF
 record read.
Date: Mon, 2 Dec 2013 12:48:36 -0500
Message-ID: <1386006516.11046.10.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:40821 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab3LBRtX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2013 12:49:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed stopped FCF discovery on failed FCF record read. 


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-11-26 21:45:44.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-12-02 11:52:11.575242041 -0500
@@ -2545,8 +2545,11 @@ lpfc_mbx_cmpl_fcf_rr_read_fcf_rec(struct
 	if (!new_fcf_record) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
 				"2766 Mailbox command READ_FCF_RECORD "
-				"failed to retrieve a FCF record.\n");
-		goto error_out;
+				"failed to retrieve a FCF record. "
+				"hba_flg x%x fcf_flg x%x\n", phba->hba_flag,
+				phba->fcf.fcf_flag);
+		lpfc_unregister_fcf_rescan(phba);
+		goto out;
 	}
 
 	/* Get the needed parameters from FCF record */
@@ -3973,7 +3976,10 @@ lpfc_nlp_counters(struct lpfc_vport *vpo
 		vport->fc_map_cnt += count;
 		break;
 	case NLP_STE_NPR_NODE:
-		vport->fc_npr_cnt += count;
+		if (vport->fc_npr_cnt == 0 && count == -1)
+			vport->fc_npr_cnt = 0;
+		else
+			vport->fc_npr_cnt += count;
 		break;
 	}
 	spin_unlock_irq(shost->host_lock);



