From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/22] advansys: Remove 'a_flag'
Date: Fri, 24 Apr 2015 10:32:52 +0200
Message-ID: <1429864377-67002-18-git-send-email-hare@suse.de>
References: <1429864377-67002-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966351AbbDXIdO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 04:33:14 -0400
In-Reply-To: <1429864377-67002-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Unused, so remove it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ec77161..98efd41 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -1717,16 +1717,6 @@ typedef struct adv_carr_t {
 #define ADV_CARRIER_BUFSIZE \
     (ADV_CARRIER_COUNT * sizeof(ADV_CARR_T))
 
-/*
- * ADV_SCSI_REQ_Q 'a_flag' definitions
- *
- * The Adv Library should limit use to the lower nibble (4 bits) of
- * a_flag. Drivers are free to use the upper nibble (4 bits) of a_flag.
- */
-#define ADV_POLL_REQUEST                0x01	/* poll for request completion */
-#define ADV_SCSIQ_DONE                  0x02	/* request done */
-#define ADV_DONT_RETRY                  0x08	/* don't do retry */
-
 #define ADV_CHIP_ASC3550          0x01	/* Ultra-Wide IC */
 #define ADV_CHIP_ASC38C0800       0x02	/* Ultra2-Wide/LVD IC */
 #define ADV_CHIP_ASC38C1600       0x03	/* Ultra3-Wide/LVD2 IC */
@@ -1808,8 +1798,6 @@ typedef struct adv_scsi_req_q {
 	 * is used by the Adv Library and ignored by the microcode.
 	 */
 	u32 srb_tag;
-	uchar a_flag;
-	uchar pad[3];		/* Pad out to a word boundary. */
 	ADV_SG_BLOCK *sg_list_ptr;	/* SG list virtual address. */
 } ADV_SCSI_REQ_Q;
 
@@ -2592,15 +2580,15 @@ static void asc_prt_adv_sgblock(int sgblockno, ADV_SG_BLOCK *b)
 
 	printk(" ADV_SG_BLOCK at addr 0x%lx (sgblockno %d)\n",
 	       (ulong)b, sgblockno);
-	printk("  sg_cnt %u, sg_ptr 0x%lx\n",
-	       b->sg_cnt, (ulong)le32_to_cpu(b->sg_ptr));
+	printk("  sg_cnt %u, sg_ptr 0x%x\n",
+	       b->sg_cnt, (u32)le32_to_cpu(b->sg_ptr));
 	BUG_ON(b->sg_cnt > NO_OF_SG_PER_BLOCK);
 	if (b->sg_ptr != 0)
 		BUG_ON(b->sg_cnt != NO_OF_SG_PER_BLOCK);
 	for (i = 0; i < b->sg_cnt; i++) {
-		printk("  [%u]: sg_addr 0x%lx, sg_count 0x%lx\n",
-		       i, (ulong)b->sg_list[i].sg_addr,
-		       (ulong)b->sg_list[i].sg_count);
+		printk("  [%u]: sg_addr 0x%x, sg_count 0x%x\n",
+		       i, (u32)le32_to_cpu(b->sg_list[i].sg_addr),
+		       (u32)le32_to_cpu(b->sg_list[i].sg_count));
 	}
 }
 
@@ -2617,8 +2605,8 @@ static void asc_prt_adv_scsi_req_q(ADV_SCSI_REQ_Q *q)
 
 	printk("ADV_SCSI_REQ_Q at addr 0x%lx\n", (ulong)q);
 
-	printk("  target_id %u, target_lun %u, srb_tag 0x%x, a_flag 0x%x\n",
-	       q->target_id, q->target_lun, q->srb_tag, q->a_flag);
+	printk("  target_id %u, target_lun %u, srb_tag 0x%x\n",
+	       q->target_id, q->target_lun, q->srb_tag);
 
 	printk("  cntl 0x%x, data_addr 0x%lx\n",
 	       q->cntl, (ulong)le32_to_cpu(q->data_addr));
@@ -6249,7 +6237,6 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 		 * Notify the driver of the completed request by passing
 		 * the ADV_SCSI_REQ_Q pointer to its callback function.
 		 */
-		scsiq->a_flag |= ADV_SCSIQ_DONE;
 		adv_isr_callback(asc_dvc, scsiq);
 		/*
 		 * Note: After the driver callback function is called, 'scsiq'
@@ -8431,11 +8418,6 @@ static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, adv_req_t *reqp)
 
 	asc_dvc->carr_pending_cnt++;
 
-	/*
-	 * Clear the ADV_SCSI_REQ_Q done flag.
-	 */
-	scsiq->a_flag &= ~ADV_SCSIQ_DONE;
-
 	/* Save virtual and physical address of ADV_SCSI_REQ_Q and carrier. */
 	scsiq->scsiq_ptr = cpu_to_le32(scsiq->srb_tag);
 	scsiq->scsiq_rptr = cpu_to_le32(reqp->req_addr);
-- 
1.8.5.2

