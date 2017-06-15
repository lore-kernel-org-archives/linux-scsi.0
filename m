From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 4/4] g_NCR5380: Cleanup comments and whitespace
Date: Thu, 15 Jun 2017 08:17:56 -0400 (EDT)
Message-ID: <54fac2a20d0e224f683b84f47b4165e7fbbff385.1497528687.git.fthain@telegraphics.com.au>
References: <cover.1497528687.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1497528687.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/g_NCR5380.c | 61 ++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 784913193ea5..e9a942d86865 100644
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
@@ -482,15 +482,14 @@ static void generic_NCR5380_release_resources(struct Scsi_Host *instance)
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
@@ -509,10 +508,10 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
 
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
@@ -556,13 +555,12 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
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
@@ -601,10 +599,10 @@ static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
 
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
@@ -650,10 +648,8 @@ static int generic_NCR5380_dma_residual(struct NCR5380_hostdata *hostdata)
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
@@ -673,11 +669,10 @@ static struct scsi_host_template driver_template = {
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
@@ -689,7 +684,7 @@ static int generic_NCR5380_isa_match(struct device *pdev, unsigned int ndev)
 }
 
 static int generic_NCR5380_isa_remove(struct device *pdev,
-				   unsigned int ndev)
+                                      unsigned int ndev)
 {
 	generic_NCR5380_release_resources(dev_get_drvdata(pdev));
 	dev_set_drvdata(pdev, NULL);
@@ -712,7 +707,7 @@ static struct pnp_device_id generic_NCR5380_pnp_ids[] = {
 MODULE_DEVICE_TABLE(pnp, generic_NCR5380_pnp_ids);
 
 static int generic_NCR5380_pnp_probe(struct pnp_dev *pdev,
-			       const struct pnp_device_id *id)
+                                     const struct pnp_device_id *id)
 {
 	int base, irq;
 
@@ -723,7 +718,7 @@ static int generic_NCR5380_pnp_probe(struct pnp_dev *pdev,
 	irq = pnp_irq(pdev, 0);
 
 	return generic_NCR5380_init_one(&driver_template, &pdev->dev, base, irq,
-				       id->driver_data);
+	                                id->driver_data);
 }
 
 static void generic_NCR5380_pnp_remove(struct pnp_dev *pdev)
-- 
2.13.0
