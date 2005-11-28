From: James.Smart@Emulex.Com
Subject: [PATCH 4/11]  lpfc 8.1.1 : Adjust use of scsi_block_requests and interaction w/ FC transport
Date: Mon, 28 Nov 2005 11:41:44 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C48@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33269 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751290AbVK1Qlq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 11:41:46 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id jASGfjs3014110
	for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2005 08:41:45 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com


Adjust use of scsi_block_requests and interaction w/ FC transport

- Remove unnecessary scsi_block_requests calls on rport deletes.
  This was deadlocking the sdev removals as they wanted to flush commands.
- No longer block requests when adding the remote port (to block
  discovery). Instead, register, then change port role. Maps to Qlogic
  behavior, and closer to the register-node-upon-first-ELS behavior.


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2005-11-24 10:07:36.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2005-11-28 10:21:58.000000000 -0500
@@ -1017,12 +1017,7 @@ lpfc_register_remote_port(struct lpfc_hb
 	rport_ids.port_name = wwn_to_u64(ndlp->nlp_portname.u.wwn);
 	rport_ids.port_id = ndlp->nlp_DID;
 	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
-	if (ndlp->nlp_type & NLP_FCP_TARGET)
-		rport_ids.roles |= FC_RPORT_ROLE_FCP_TARGET;
-	if (ndlp->nlp_type & NLP_FCP_INITIATOR)
-		rport_ids.roles |= FC_RPORT_ROLE_FCP_INITIATOR;
 
-	scsi_block_requests(phba->host);
 	ndlp->rport = rport = fc_remote_port_add(phba->host, 0, &rport_ids);
 	if (!rport) {
 		dev_printk(KERN_WARNING, &phba->pcidev->dev,
@@ -1039,7 +1034,16 @@ lpfc_register_remote_port(struct lpfc_hb
 	}
 	rdata = rport->dd_data;
 	rdata->pnode = ndlp;
-	scsi_unblock_requests(phba->host);
+
+	if (ndlp->nlp_type & NLP_FCP_TARGET)
+		rport_ids.roles |= FC_RPORT_ROLE_FCP_TARGET;
+	if (ndlp->nlp_type & NLP_FCP_INITIATOR)
+		rport_ids.roles |= FC_RPORT_ROLE_FCP_INITIATOR;
+
+
+	if (rport_ids.roles !=  FC_RPORT_ROLE_UNKNOWN)
+		fc_remote_port_rolechg(rport, rport_ids.roles);
+
 
 	return;
 }
@@ -1053,9 +1057,7 @@ lpfc_unregister_remote_port(struct lpfc_
 
 	ndlp->rport = NULL;
 	rdata->pnode = NULL;
-	scsi_block_requests(phba->host);
 	fc_remote_port_delete(rport);
-	scsi_unblock_requests(phba->host);
 
 	return;
 }
