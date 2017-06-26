From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 3/4] g_NCR5380: Cleanup comments and whitespace
Date: Mon, 26 Jun 2017 03:30:34 -0400 (EDT)
Message-ID: <620b019297a3ad7024a2d289a4b9b3a82586adca.1498461406.git.fthain@telegraphics.com.au>
References: <cover.1498461406.git.fthain@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33744 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbdFZHaf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 03:30:35 -0400
In-Reply-To: <cover.1498461406.git.fthain@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/g_NCR5380.c | 61 ++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 911a4300ea51..9f18082415c4 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -1,17 +1,17 @@
 /*
  * Generic Generic NCR5380 driver
- *	
+ *
  * Copyright 1993, Drew Eckhardt
- *	Visionary Computing
- *	(Unix and Linux consulting and custom programming)
- *	drew@colorado.edu
- *      +1 (303) 440-4894
+ * Visionary Computing
+ * (Unix and Linux consulting and custom programming)
+ * drew@colorado.edu
+ * +1 (303) 440-4894
  *
  * NCR53C400 extensions (c) 1994,1995,1996, Kevin Lentin
- *    K.Lentin@cs.monash.edu.au
+ * K.Lentin@cs.monash.edu.au
  *
  * NCR53C400A extensions (c) 1996, Ingmar Baumgart
- *    ingmar@gonzo.schwaben.de
+ * ingmar@gonzo.schwaben.de
  *
  * DTC3181E extensions (c) 1997, Ronald van Cuijlenborg
  * ronald.van.cuijlenborg@tip.nl or nutty@dds.nl
@@ -481,15 +481,14 @@ static void generic_NCR5380_release_resources(struct Scsi_Host *instance)
 }
 
 /**
- *	generic_NCR5380_pread - pseudo DMA read
- *	@hostdata: scsi host private data
- *	@dst: buffer to read into
- *	@len: buffer length
+ * generic_NCR5380_pread - pseudo DMA receive
+ * @hostdata: scsi host private data
+ * @dst: buffer to write into
+ * @len: transfer size
  *
- *	Perform a pseudo DMA mode read from an NCR53C400 or equivalent
- *	controller
+ * Perform a pseudo DMA mode receive from a 53C400 or equivalent device.
  */
- 
+
 static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
                                         unsigned char *dst, int len)
 {
@@ -508,10 +507,10 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
 
 		if (hostdata->io_port && hostdata->io_width == 2)
 			insw(hostdata->io_port + hostdata->c400_host_buf,
-							dst + start, 64);
+			     dst + start, 64);
 		else if (hostdata->io_port)
 			insb(hostdata->io_port + hostdata->c400_host_buf,
-							dst + start, 128);
+			     dst + start, 128);
 		else
 			memcpy_fromio(dst + start,
 				hostdata->io + NCR53C400_host_buffer, 128);
@@ -558,13 +557,12 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
 }
 
 /**
- *	generic_NCR5380_pwrite - pseudo DMA write
- *	@hostdata: scsi host private data
- *	@dst: buffer to read into
- *	@len: buffer length
+ * generic_NCR5380_pwrite - pseudo DMA send
+ * @hostdata: scsi host private data
+ * @src: buffer to read from
+ * @len: transfer size
  *
- *	Perform a pseudo DMA mode read from an NCR53C400 or equivalent
- *	controller
+ * Perform a pseudo DMA mode send to a 53C400 or equivalent device.
  */
 
 static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
@@ -603,10 +601,10 @@ static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
 
 		if (hostdata->io_port && hostdata->io_width == 2)
 			outsw(hostdata->io_port + hostdata->c400_host_buf,
-							src + start, 64);
+			      src + start, 64);
 		else if (hostdata->io_port)
 			outsb(hostdata->io_port + hostdata->c400_host_buf,
-							src + start, 128);
+			      src + start, 128);
 		else
 			memcpy_toio(hostdata->io + NCR53C400_host_buffer,
 			            src + start, 128);
@@ -656,10 +654,8 @@ static int generic_NCR5380_dma_residual(struct NCR5380_hostdata *hostdata)
 	return hostdata->pdma_residual;
 }
 
-/*
- *	Include the NCR5380 core code that we build our driver around	
- */
- 
+/* Include the core driver code. */
+
 #include "NCR5380.c"
 
 static struct scsi_host_template driver_template = {
@@ -679,11 +675,10 @@ static struct scsi_host_template driver_template = {
 	.max_sectors		= 128,
 };
 
-
 static int generic_NCR5380_isa_match(struct device *pdev, unsigned int ndev)
 {
 	int ret = generic_NCR5380_init_one(&driver_template, pdev, base[ndev],
-					  irq[ndev], card[ndev]);
+	                                   irq[ndev], card[ndev]);
 	if (ret) {
 		if (base[ndev])
 			printk(KERN_WARNING "Card not found at address 0x%03x\n",
@@ -695,7 +690,7 @@ static int generic_NCR5380_isa_match(struct device *pdev, unsigned int ndev)
 }
 
 static int generic_NCR5380_isa_remove(struct device *pdev,
-				   unsigned int ndev)
+                                      unsigned int ndev)
 {
 	generic_NCR5380_release_resources(dev_get_drvdata(pdev));
 	dev_set_drvdata(pdev, NULL);
@@ -718,7 +713,7 @@ static struct pnp_device_id generic_NCR5380_pnp_ids[] = {
 MODULE_DEVICE_TABLE(pnp, generic_NCR5380_pnp_ids);
 
 static int generic_NCR5380_pnp_probe(struct pnp_dev *pdev,
-			       const struct pnp_device_id *id)
+                                     const struct pnp_device_id *id)
 {
 	int base, irq;
 
@@ -729,7 +724,7 @@ static int generic_NCR5380_pnp_probe(struct pnp_dev *pdev,
 	irq = pnp_irq(pdev, 0);
 
 	return generic_NCR5380_init_one(&driver_template, &pdev->dev, base, irq,
-				       id->driver_data);
+	                                id->driver_data);
 }
 
 static void generic_NCR5380_pnp_remove(struct pnp_dev *pdev)
-- 
2.13.0
