From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/23] advansys: rename 'ASC_RQ_XX' to 'ADV_RQ_XX'
Date: Fri, 24 Apr 2015 13:18:35 +0200
Message-ID: <1429874322-85488-18-git-send-email-hare@suse.de>
References: <1429874322-85488-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967105AbbDXLSv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 07:18:51 -0400
In-Reply-To: <1429874322-85488-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

These definitions are only ever used for the wide-scsi board,
so they should be prefixed with 'ADV', not 'ASC'.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 18f75ea..f01839b 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -1700,13 +1700,13 @@ typedef struct adv_carr_t {
 /*
  * Mask used to eliminate low 4 bits of carrier 'next_vpa' field.
  */
-#define ASC_NEXT_VPA_MASK       0xFFFFFFF0
+#define ADV_NEXT_VPA_MASK       0xFFFFFFF0
 
-#define ASC_RQ_DONE             0x00000001
-#define ASC_RQ_GOOD             0x00000002
-#define ASC_CQ_STOPPER          0x00000000
+#define ADV_RQ_DONE             0x00000001
+#define ADV_RQ_GOOD             0x00000002
+#define ADV_CQ_STOPPER          0x00000000
 
-#define ASC_GET_CARRP(carrp) ((carrp) & ASC_NEXT_VPA_MASK)
+#define ADV_GET_CARRP(carrp) ((carrp) & ADV_NEXT_VPA_MASK)
 
 /*
  * Each carrier is 64 bytes, and we need three additional
@@ -4295,7 +4295,7 @@ static ADV_CARR_T *adv_get_next_carrier(struct adv_dvc_var *adv_dvc)
 	/*
 	 * insert stopper carrier to terminate list
 	 */
-	carrp->next_vpa = cpu_to_le32(ASC_CQ_STOPPER);
+	carrp->next_vpa = cpu_to_le32(ADV_CQ_STOPPER);
 
 	return carrp;
 }
@@ -6198,7 +6198,7 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 	 * Check if the IRQ stopper carrier contains a completed request.
 	 */
 	while (((irq_next_vpa =
-		 le32_to_cpu(asc_dvc->irq_sp->next_vpa)) & ASC_RQ_DONE) != 0) {
+		 le32_to_cpu(asc_dvc->irq_sp->next_vpa)) & ADV_RQ_DONE) != 0) {
 		/*
 		 * Get a pointer to the newly completed ADV_SCSI_REQ_Q structure.
 		 * The RISC will have set 'areq_vpa' to a virtual address.
@@ -6219,7 +6219,7 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 		 * DMAed to host memory by the firmware. Set all status fields
 		 * to indicate good status.
 		 */
-		if ((irq_next_vpa & ASC_RQ_GOOD) != 0) {
+		if ((irq_next_vpa & ADV_RQ_GOOD) != 0) {
 			scsiq->done_status = QD_NO_ERROR;
 			scsiq->host_status = scsiq->scsi_status = 0;
 			scsiq->data_cnt = 0L;
@@ -6232,7 +6232,7 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 		 */
 		free_carrp = asc_dvc->irq_sp;
 		asc_dvc->irq_sp = adv_get_carrier(asc_dvc,
-						  ASC_GET_CARRP(irq_next_vpa));
+						  ADV_GET_CARRP(irq_next_vpa));
 
 		free_carrp->next_vpa = asc_dvc->carr_freelist->carr_va;
 		asc_dvc->carr_freelist = free_carrp;
-- 
1.8.5.2

