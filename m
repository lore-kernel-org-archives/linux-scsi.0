From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 27/47] lpfc: use rport as argument for lpfc_chk_tgt_mapped()
Date: Wed, 28 Jun 2017 10:32:53 +0200
Message-ID: <1498638793-44672-28-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53804 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751689AbdF1IdV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:21 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

We only need the rport structure for lpfc_chk_tgt_mapped().

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index f100779..107c0f6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5055,7 +5055,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 /**
  * lpfc_chk_tgt_mapped -
  * @vport: The virtual port to check on
- * @cmnd: Pointer to scsi_cmnd data structure.
+ * @rport: Pointer to fc_rport data structure.
  *
  * This routine delays until the scsi target (aka rport) for the
  * command exists (is present and logged in) or we declare it non-existent.
@@ -5065,19 +5065,15 @@ void lpfc_poll_timeout(unsigned long ptr)
  *  0x2002 - Success
  **/
 static int
-lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct scsi_cmnd *cmnd)
+lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct fc_rport *rport)
 {
 	struct lpfc_rport_data *rdata;
-	struct lpfc_nodelist *pnode;
+	struct lpfc_nodelist *pnode = NULL;
 	unsigned long later;
 
-	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
-	if (!rdata) {
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-			"0797 Tgt Map rport failure: rdata x%p\n", rdata);
-		return FAILED;
-	}
-	pnode = rdata->pnode;
+	rdata = rport->dd_data;
+	if (rdata)
+		pnode = rdata->pnode;
 	/*
 	 * If target is not in a MAPPED state, delay until
 	 * target is rediscovered or devloss timeout expires.
@@ -5089,7 +5085,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 		if (pnode->nlp_state == NLP_STE_MAPPED_NODE)
 			return SUCCESS;
 		schedule_timeout_uninterruptible(msecs_to_jiffies(500));
-		rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
+		rdata = rport->dd_data;
 		if (!rdata)
 			return FAILED;
 		pnode = rdata->pnode;
@@ -5182,7 +5178,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 	if (status != 0 && status != SUCCESS)
 		return status;
 
-	status = lpfc_chk_tgt_mapped(vport, cmnd);
+	status = lpfc_chk_tgt_mapped(vport, rport);
 	if (status == FAILED) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 			"0721 Device Reset rport failure: rdata x%p\n", rdata);
@@ -5242,7 +5238,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	int status;
 
-	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
+	rdata = rport->dd_data;
 	if (!rdata) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 			"0799 Target Reset rport failure: rdata x%p\n", rdata);
@@ -5253,7 +5249,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 	if (status != 0 && status != SUCCESS)
 		return status;
 
-	status = lpfc_chk_tgt_mapped(vport, cmnd);
+	status = lpfc_chk_tgt_mapped(vport, rport);
 	if (status == FAILED) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 			"0722 Target Reset rport failure: rdata x%p\n", rdata);
-- 
1.8.5.6
