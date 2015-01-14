From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 33/48] hpsa: slightly optimize SA5_performant_completed
Date: Wed, 14 Jan 2015 16:02:32 -0600
Message-ID: <20150114220232.21325.30631.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t2354.austin.hp.com ([15.217.128.53]:34363 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbbANWDT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:03:19 -0500
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 1856445..aa6cb0b 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -412,19 +412,19 @@ static unsigned long SA5_performant_completed(struct ctlr_info *h, u8 q)
 	unsigned long register_value = FIFO_EMPTY;
 
 	/* msi auto clears the interrupt pending bit. */
-	if (!(h->msi_vector || h->msix_vector)) {
+	if (unlikely(!(h->msi_vector || h->msix_vector))) {
 		/* flush the controller write of the reply queue by reading
 		 * outbound doorbell status register.
 		 */
-		register_value = readl(h->vaddr + SA5_OUTDB_STATUS);
+		(void) readl(h->vaddr + SA5_OUTDB_STATUS);
 		writel(SA5_OUTDB_CLEAR_PERF_BIT, h->vaddr + SA5_OUTDB_CLEAR);
 		/* Do a read in order to flush the write to the controller
 		 * (as per spec.)
 		 */
-		register_value = readl(h->vaddr + SA5_OUTDB_STATUS);
+		(void) readl(h->vaddr + SA5_OUTDB_STATUS);
 	}
 
-	if ((rq->head[rq->current_entry] & 1) == rq->wraparound) {
+	if ((((u32) rq->head[rq->current_entry]) & 1) == rq->wraparound) {
 		register_value = rq->head[rq->current_entry];
 		rq->current_entry++;
 		atomic_dec(&h->commands_outstanding);

