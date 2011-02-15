From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2/6] hpsa: make hpsa.hpsa_simple_mode=1 module parameter
	actually work
Date: Tue, 15 Feb 2011 15:32:53 -0600
Message-ID: <20110215213253.5407.52931.stgit@beardog.cce.hp.com>
References: <20110215212856.5407.3438.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110215212856.5407.3438.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mike.mikem@beardog.cce.hp.com, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

It's not enough to simple avoid putting the board into performant
mode, as we have to set up the interrupts differently, etc.  When
I originally tested this module parameter, I tested it incorrectly
without realizing it, and the driver was running in performant mode
the whole time unbeknownst to me.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   37 +++++++++++++++++++++++--------------
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0f40de2..66ccacf 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1186,7 +1186,7 @@ static int hpsa_scsi_detect(struct ctlr_info *h)
 	sh->sg_tablesize = h->maxsgentries;
 	h->scsi_host = sh;
 	sh->hostdata[0] = (unsigned long) h;
-	sh->irq = h->intr[PERF_MODE_INT];
+	sh->irq = h->intr[h->intr_mode];
 	sh->unique_id = sh->irq;
 	error = scsi_add_host(sh, &h->pdev->dev);
 	if (error)
@@ -2902,10 +2902,14 @@ static inline u32 hpsa_tag_to_index(u32 tag)
 	return tag >> DIRECT_LOOKUP_SHIFT;
 }
 
-static inline u32 hpsa_tag_discard_error_bits(u32 tag)
+
+static inline u32 hpsa_tag_discard_error_bits(struct ctlr_info *h, u32 tag)
 {
-#define HPSA_ERROR_BITS 0x03
-	return tag & ~HPSA_ERROR_BITS;
+#define HPSA_PERF_ERROR_BITS ((1 << DIRECT_LOOKUP_SHIFT) - 1)
+#define HPSA_SIMPLE_ERROR_BITS 0x03
+	if (unlikely(h->transMethod != CFGTBL_Trans_Performant))
+		return tag & ~HPSA_SIMPLE_ERROR_BITS;
+	return tag & ~HPSA_PERF_ERROR_BITS;
 }
 
 /* process completion of an indexed ("direct lookup") command */
@@ -2930,7 +2934,7 @@ static inline u32 process_nonindexed_cmd(struct ctlr_info *h,
 	u32 tag;
 	struct CommandList *c = NULL;
 
-	tag = hpsa_tag_discard_error_bits(raw_tag);
+	tag = hpsa_tag_discard_error_bits(h, raw_tag);
 	list_for_each_entry(c, &h->cmpQ, list) {
 		if ((c->busaddr & 0xFFFFFFE0) == (tag & 0xFFFFFFE0)) {
 			finish_cmd(c, raw_tag);
@@ -2981,7 +2985,10 @@ static irqreturn_t do_hpsa_intr_msi(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-/* Send a message CDB to the firmware. */
+/* Send a message CDB to the firmware. Careful, this only works
+ * in simple mode, not performant mode due to the tag lookup.
+ * We only ever use this immediately after a controller reset.
+ */
 static __devinit int hpsa_message(struct pci_dev *pdev, unsigned char opcode,
 						unsigned char type)
 {
@@ -3047,7 +3054,7 @@ static __devinit int hpsa_message(struct pci_dev *pdev, unsigned char opcode,
 
 	for (i = 0; i < HPSA_MSG_SEND_RETRY_LIMIT; i++) {
 		tag = readl(vaddr + SA5_REPLY_PORT_OFFSET);
-		if (hpsa_tag_discard_error_bits(tag) == paddr32)
+		if ((tag & ~HPSA_SIMPLE_ERROR_BITS) == paddr32)
 			break;
 		msleep(HPSA_MSG_SEND_RETRY_INTERVAL_MSECS);
 	}
@@ -3379,7 +3386,7 @@ static void __devinit hpsa_interrupt_mode(struct ctlr_info *h)
 default_int_mode:
 #endif				/* CONFIG_PCI_MSI */
 	/* if we get here we're going to use the default interrupt mode */
-	h->intr[PERF_MODE_INT] = h->pdev->irq;
+	h->intr[h->intr_mode] = h->pdev->irq;
 }
 
 static int __devinit hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
@@ -3760,6 +3767,8 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 
 	h->pdev = pdev;
 	h->busy_initializing = 1;
+	h->intr_mode = hpsa_simple_mode ? SIMPLE_MODE_INT : PERF_MODE_INT;
+	printk(KERN_WARNING "hpsa_simple_mode is %d\n", hpsa_simple_mode);
 	INIT_LIST_HEAD(&h->cmpQ);
 	INIT_LIST_HEAD(&h->reqQ);
 	spin_lock_init(&h->lock);
@@ -3790,20 +3799,20 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
 
 	if (h->msix_vector || h->msi_vector)
-		rc = request_irq(h->intr[PERF_MODE_INT], do_hpsa_intr_msi,
+		rc = request_irq(h->intr[h->intr_mode], do_hpsa_intr_msi,
 				IRQF_DISABLED, h->devname, h);
 	else
-		rc = request_irq(h->intr[PERF_MODE_INT], do_hpsa_intr_intx,
+		rc = request_irq(h->intr[h->intr_mode], do_hpsa_intr_intx,
 				IRQF_DISABLED, h->devname, h);
 	if (rc) {
 		dev_err(&pdev->dev, "unable to get irq %d for %s\n",
-		       h->intr[PERF_MODE_INT], h->devname);
+		       h->intr[h->intr_mode], h->devname);
 		goto clean2;
 	}
 
 	dev_info(&pdev->dev, "%s: <0x%x> at IRQ %d%s using DAC\n",
 	       h->devname, pdev->device,
-	       h->intr[PERF_MODE_INT], dac ? "" : " not");
+	       h->intr[h->intr_mode], dac ? "" : " not");
 
 	h->cmd_pool_bits =
 	    kmalloc(((h->nr_cmds + BITS_PER_LONG -
@@ -3854,7 +3863,7 @@ clean4:
 			    h->nr_cmds * sizeof(struct ErrorInfo),
 			    h->errinfo_pool,
 			    h->errinfo_pool_dhandle);
-	free_irq(h->intr[PERF_MODE_INT], h);
+	free_irq(h->intr[h->intr_mode], h);
 clean2:
 clean1:
 	h->busy_initializing = 0;
@@ -3898,7 +3907,7 @@ static void hpsa_shutdown(struct pci_dev *pdev)
 	 */
 	hpsa_flush_cache(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
-	free_irq(h->intr[PERF_MODE_INT], h);
+	free_irq(h->intr[h->intr_mode], h);
 #ifdef CONFIG_PCI_MSI
 	if (h->msix_vector)
 		pci_disable_msix(h->pdev);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index e898193..621a153 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -72,6 +72,7 @@ struct ctlr_info {
 	unsigned int intr[4];
 	unsigned int msix_vector;
 	unsigned int msi_vector;
+	int intr_mode; /* either PERF_MODE_INT or SIMPLE_MODE_INT */
 	struct access_method access;
 
 	/* queue and queue Info */
