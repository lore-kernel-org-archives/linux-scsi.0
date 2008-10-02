From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [9/21] SCSI-ISA-DMA: Remove unchecked_isa_dma in aha1542
Date: Thu,  2 Oct 2008 09:58:47 +0200 (CEST)
Message-ID: <20081002075847.427D43E6A09@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57090 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbYJBH6s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:48 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


- Audited ->cmnd use and it always copies
- Allocate DMAable hostdata separately 
- Tell block layer explicitely to bounce
- Audited sense_buffer use and it always copies
- Remove unchecked_isa_dma finally

Untested due to lack of hardware

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/aha1542.c |   40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

Index: linux/drivers/scsi/aha1542.c
===================================================================
--- linux.orig/drivers/scsi/aha1542.c
+++ linux/drivers/scsi/aha1542.c
@@ -151,7 +151,13 @@ struct aha1542_hostdata {
 	struct ccb ccb[AHA1542_MAILBOXES];
 };
 
-#define HOSTDATA(host) ((struct aha1542_hostdata *) &host->hostdata)
+struct hd_ptr {
+	struct aha1542_hostdata *hostptr;
+	dma_addr_t dma;
+};
+
+#define HOSTDATA(host) (((struct hd_ptr *)shost_priv(host))->hostptr)
+#define HOSTDMA(host) (((struct hd_ptr *)shost_priv(host))->dma)
 
 static DEFINE_SPINLOCK(aha1542_lock);
 
@@ -1125,23 +1131,28 @@ static int __init aha1542_detect(struct 
 	}
 	for (indx = 0; indx < ARRAY_SIZE(bases); indx++)
 		if (bases[indx] != 0 && request_region(bases[indx], 4, "aha1542")) {
-			shpnt = scsi_register(tpnt,
-					sizeof(struct aha1542_hostdata));
+			struct aha1542_hostdata *host;
+
+			shpnt = scsi_register(tpnt, sizeof(struct hd_ptr));
 
 			if(shpnt==NULL) {
 				release_region(bases[indx], 4);
 				continue;
 			}
-			/* For now we do this - until kmalloc is more intelligent
-			   we are resigned to stupid hacks like this */
-			if (SCSI_BUF_PA(shpnt) >= ISA_DMA_THRESHOLD) {
-				printk(KERN_ERR "Invalid address for shpnt with 1542.\n");
-				goto unregister;
+
+			host = dma_alloc_coherent(NULL, sizeof(*host),
+						  &HOSTDMA(shpnt), GFP_KERNEL);
+			if (!host) {
+				scsi_unregister(shpnt);
+				release_region(bases[indx], 4);
+				continue;
 			}
+
+			HOSTDATA(shpnt) = host;
+
 			if (!aha1542_test_port(bases[indx], shpnt))
 				goto unregister;
 
-
 			base_io = bases[indx];
 
 			/* Set the Bus on/off-times as not to ruin floppy performance */
@@ -1259,6 +1270,8 @@ fail:
 			continue;
 unregister:
 			release_region(bases[indx], 4);
+			dma_free_coherent(NULL, sizeof(struct aha1542_hostdata),
+					  HOSTDATA(shpnt), HOSTDMA(shpnt));
 			scsi_unregister(shpnt);
 			continue;
 
@@ -1275,6 +1288,8 @@ static int aha1542_release(struct Scsi_H
 		free_dma(shost->dma_channel);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
+	dma_free_coherent(NULL, sizeof(struct aha1542_hostdata),
+			  HOSTDATA(shost), HOSTDMA(shost));
 	scsi_unregister(shost);
 	return 0;
 }
@@ -1746,6 +1761,11 @@ static int aha1542_biosparam(struct scsi
 }
 MODULE_LICENSE("GPL");
 
+static int aha154x_adjust_queue(struct scsi_device *device)
+{
+	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_ISA);
+	return 0;
+}
 
 static struct scsi_host_template driver_template = {
 	.proc_name		= "aha1542",
@@ -1761,7 +1781,7 @@ static struct scsi_host_template driver_
 	.this_id		= 7,
 	.sg_tablesize		= AHA1542_SCATTER,
 	.cmd_per_lun		= AHA1542_CMDLUN,
-	.unchecked_isa_dma	= 1, 
 	.use_clustering		= ENABLE_CLUSTERING,
+	.slave_alloc		= aha154x_adjust_queue,
 };
 #include "scsi_module.c"
