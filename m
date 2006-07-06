From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/15] lpfc 8.1.7 : Standardize the driver on a single
	define for the maximum supported targets
Date: Thu, 06 Jul 2006 15:49:25 -0400
Message-ID: <1152215365.23158.19.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:16780 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750769AbWGFTtY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:49:24 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k66Jn8Pc006917
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 12:49:09 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Standardize the driver on a single define for the maximum supported targets.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2006-07-05 14:49:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2006-07-06 14:36:09.000000000 -0400
@@ -21,10 +21,12 @@
 
 struct lpfc_sli2_slim;
 
-#define LPFC_MAX_TARGET         256	/* max targets supported */
-#define LPFC_MAX_DISC_THREADS	64	/* max outstanding discovery els req */
-#define LPFC_MAX_NS_RETRY       3	/* max NameServer retries */
 
+#define LPFC_MAX_TARGET		256	/* max number of targets supported */
+#define LPFC_MAX_DISC_THREADS	64	/* max outstanding discovery els
+					   requests */
+#define LPFC_MAX_NS_RETRY	3	/* Number of retry attempts to contact
+					   the NameServer  before giving up. */
 #define LPFC_DFT_HBA_Q_DEPTH	2048	/* max cmds per hba */
 #define LPFC_LC_HBA_Q_DEPTH	1024	/* max cmds per low cost hba */
 #define LPFC_LP101_HBA_Q_DEPTH	128	/* max cmds per low cost hba */
@@ -41,7 +43,6 @@ struct lpfc_sli2_slim;
 			     (( (u64)(high)<<16 ) << 16)|( (u64)(low))))
 /* Provide maximum configuration definitions. */
 #define LPFC_DRVR_TIMEOUT	16	/* driver iocb timeout value in sec */
-#define MAX_FCP_TARGET		256	/* max num of FCP targets supported */
 #define FC_MAX_ADPTMSG		64
 
 #define MAX_HBAEVT	32
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2006-07-05 14:49:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2006-07-06 14:36:09.000000000 -0400
@@ -1084,7 +1084,7 @@ lpfc_register_remote_port(struct lpfc_hb
 		fc_remote_port_rolechg(rport, rport_ids.roles);
 
 	if ((rport->scsi_target_id != -1) &&
-		(rport->scsi_target_id < MAX_FCP_TARGET)) {
+		(rport->scsi_target_id < LPFC_MAX_TARGET)) {
 		ndlp->nlp_sid = rport->scsi_target_id;
 	}
 
@@ -1313,7 +1313,7 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 			if ((rport_add == mapped) &&
 			    ((!nlp->rport) ||
 			     (nlp->rport->scsi_target_id == -1) ||
-			     (nlp->rport->scsi_target_id >= MAX_FCP_TARGET))) {
+			     (nlp->rport->scsi_target_id >= LPFC_MAX_TARGET))) {
 				nlp->nlp_state = NLP_STE_UNMAPPED_NODE;
 				spin_lock_irq(phba->host->host_lock);
 				nlp->nlp_flag |= NLP_TGT_NO_SCSIID;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2006-07-05 14:49:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2006-07-06 14:36:09.000000000 -0400
@@ -1078,7 +1078,7 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 	 * targets known to the driver.  Should any target reset
 	 * fail, this routine returns failure to the midlayer.
 	 */
-	for (i = 0; i < MAX_FCP_TARGET; i++) {
+	for (i = 0; i < LPFC_MAX_TARGET; i++) {
 		/* Search the mapped list for this target ID */
 		match = 0;
 		list_for_each_entry(ndlp, &phba->fc_nlpmap_list, nlp_listp) {


