From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [8/21] SCSI-ISA-DMA: Remove unchecked_isa_dma in eata.c
Date: Thu,  2 Oct 2008 09:58:46 +0200 (CEST)
Message-ID: <20081002075846.3CAD03E6A07@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57087 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYJBH6r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:47 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


- Allocate hostdata with DMA separately in the driver
- Audited ->cmnd uses and it only ever copies them
- Enable sense_buffer bouncing using new sense_buffer_isa flag
- Enable block layer bouncing explicitely
- Remove unchecked_isa_dma

Untested due to lack of hardware

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/eata.c |   54 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 15 deletions(-)

Index: linux/drivers/scsi/eata.c
===================================================================
--- linux.orig/drivers/scsi/eata.c
+++ linux/drivers/scsi/eata.c
@@ -512,6 +512,13 @@ static int eata2x_bios_param(struct scsi
 			     sector_t, int *);
 static int eata2x_slave_configure(struct scsi_device *);
 
+static int eata_adjust_queue(struct scsi_device *device)
+{
+	if (device->host->sense_buffer_isa)
+		blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_ISA);
+	return 0;
+}
+
 static struct scsi_host_template driver_template = {
 	.name = "EATA/DMA 2.0x rev. 8.10.00 ",
 	.detect = eata2x_detect,
@@ -522,8 +529,8 @@ static struct scsi_host_template driver_
 	.bios_param = eata2x_bios_param,
 	.slave_configure = eata2x_slave_configure,
 	.this_id = 7,
-	.unchecked_isa_dma = 1,
 	.use_clustering = ENABLE_CLUSTERING,
+	.slave_alloc = eata_adjust_queue,
 };
 
 #if !defined(__BIG_ENDIAN_BITFIELD) && !defined(__LITTLE_ENDIAN_BITFIELD)
@@ -834,6 +841,16 @@ struct hostdata {
 	struct mssp sp;		/* Local copy of sp buffer */
 };
 
+struct hostdata_ptr {
+	struct hostdata *host;
+	dma_addr_t dma;
+};
+
+#define eata_shost_priv(shost) \
+	(((struct hostdata_ptr *)shost_priv(shost))->host)
+#define eata_shost_dma(shost) \
+	(((struct hostdata_ptr *)shost_priv(shost))->dma)
+
 static struct Scsi_Host *sh[MAX_BOARDS];
 static const char *driver_name = "EATA";
 static char sha[MAX_BOARDS];
@@ -1266,14 +1283,23 @@ static int port_detect(unsigned long por
 #endif
 
 	spin_unlock_irq(&driver_lock);
-	sh[j] = shost = scsi_register(tpnt, sizeof(struct hostdata));
+	sh[j] = shost = scsi_register(tpnt, sizeof(struct hostdata_ptr));
+	ha = dma_alloc_coherent(pdev ? &pdev->dev : NULL,
+				sizeof(struct hostdata),
+				&eata_shost_dma(shost), GFP_KERNEL);
 	spin_lock_irq(&driver_lock);
 
-	if (shost == NULL) {
+	if (shost == NULL || ha == NULL) {
+		if (ha)
+			dma_free_coherent(pdev ? &pdev->dev : NULL,
+					  sizeof(struct hostdata),
+					  ha, eata_shost_dma(shost));
 		printk("%s: unable to register host, detaching.\n", name);
 		goto freedma;
 	}
 
+	eata_shost_priv(shost) = ha;
+
 	shost->io_port = port_base;
 	shost->unique_id = port_base;
 	shost->n_io_port = REGION_SIZE;
@@ -1283,8 +1309,6 @@ static int port_detect(unsigned long por
 	shost->this_id = (ushort) info.host_addr[3];
 	shost->can_queue = (ushort) info.queue_size;
 	shost->cmd_per_lun = MAX_CMD_PER_LUN;
-
-	ha = (struct hostdata *)shost->hostdata;
 	
 	memset(ha, 0, sizeof(struct hostdata));
 	ha->subversion = subversion;
@@ -1293,11 +1317,9 @@ static int port_detect(unsigned long por
 	ha->pdev = pdev;
 	ha->board_number = j;
 
-	if (ha->subversion == ESA)
-		shost->unchecked_isa_dma = 0;
-	else {
+	if (ha->subversion != ESA) {
 		unsigned long flags;
-		shost->unchecked_isa_dma = 1;
+		shost->sense_buffer_isa = 1;
 
 		flags = claim_dma_lock();
 		disable_dma(dma_channel);
@@ -1355,7 +1377,7 @@ static int port_detect(unsigned long por
 
 	for (i = 0; i < shost->can_queue; i++) {
 		size_t sz = shost->sg_tablesize *sizeof(struct sg_list);
-		gfp_t gfp_mask = (shost->unchecked_isa_dma ? GFP_DMA : 0) | GFP_ATOMIC;
+		gfp_t gfp_mask = (shost->sense_buffer_isa ? GFP_DMA : 0) | GFP_ATOMIC;
 		ha->cp[i].sglist = kmalloc(sz, gfp_mask);
 		if (!ha->cp[i].sglist) {
 			printk
@@ -1752,7 +1774,7 @@ static int eata2x_queuecommand(struct sc
 			       void (*done) (struct scsi_cmnd *))
 {
 	struct Scsi_Host *shost = SCpnt->device->host;
-	struct hostdata *ha = (struct hostdata *)shost->hostdata;
+	struct hostdata *ha = eata_shost_priv(shost);
 	unsigned int i, k;
 	struct mscp *cpp;
 
@@ -1836,7 +1858,7 @@ static int eata2x_queuecommand(struct sc
 static int eata2x_eh_abort(struct scsi_cmnd *SCarg)
 {
 	struct Scsi_Host *shost = SCarg->device->host;
-	struct hostdata *ha = (struct hostdata *)shost->hostdata;
+	struct hostdata *ha = eata_shost_priv(shost);
 	unsigned int i;
 
 	if (SCarg->host_scribble == NULL) {
@@ -1906,7 +1928,7 @@ static int eata2x_eh_host_reset(struct s
 	int arg_done = 0;
 	struct scsi_cmnd *SCpnt;
 	struct Scsi_Host *shost = SCarg->device->host;
-	struct hostdata *ha = (struct hostdata *)shost->hostdata;
+	struct hostdata *ha = eata_shost_priv(shost);
 
 	scmd_printk(KERN_INFO, SCarg,
 		"reset, enter, pid %ld.\n", SCarg->serial_number);
@@ -2292,7 +2314,7 @@ static irqreturn_t ihdlr(struct Scsi_Hos
 	unsigned int i, k, c, status, tstatus, reg;
 	struct mssp *spp;
 	struct mscp *cpp;
-	struct hostdata *ha = (struct hostdata *)shost->hostdata;
+	struct hostdata *ha = eata_shost_priv(shost);
 	int irq = shost->irq;
 
 	/* Check if this board need to be serviced */
@@ -2552,7 +2574,7 @@ static irqreturn_t do_interrupt_handler(
 
 static int eata2x_release(struct Scsi_Host *shost)
 {
-	struct hostdata *ha = (struct hostdata *)shost->hostdata;
+	struct hostdata *ha = eata_shost_priv(shost);
 	unsigned int i;
 
 	for (i = 0; i < shost->can_queue; i++)
@@ -2572,6 +2594,8 @@ static int eata2x_release(struct Scsi_Ho
 		free_dma(shost->dma_channel);
 
 	release_region(shost->io_port, shost->n_io_port);
+	dma_free_coherent(ha->pdev ? &ha->pdev->dev : NULL,
+			  sizeof(*ha), ha, eata_shost_dma(shost));
 	scsi_unregister(shost);
 	return 0;
 }
