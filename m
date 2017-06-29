From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v5 6/6] g_NCR5380: Use unambiguous terminology for PDMA send
 and receive
Date: Thu, 29 Jun 2017 01:24:19 -0400 (EDT)
Message-ID: <bd604bc1ebf9da2901718de5240254d9085d5089.1498713600.git.fthain@telegraphics.com.au>
References: <cover.1498713600.git.fthain@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:42436 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbdF2FYV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2017 01:24:21 -0400
In-Reply-To: <cover.1498713600.git.fthain@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>

The word "read" may be used to mean "DMA read operation" or
"SCSI READ command", though a READ command implies writing to memory.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/g_NCR5380.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index f7e50d2bca07..b8b1ed2806bb 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -49,8 +49,8 @@
 	int board
 
 #define NCR5380_dma_xfer_len            generic_NCR5380_dma_xfer_len
-#define NCR5380_dma_recv_setup          generic_NCR5380_pread
-#define NCR5380_dma_send_setup          generic_NCR5380_pwrite
+#define NCR5380_dma_recv_setup          generic_NCR5380_precv
+#define NCR5380_dma_send_setup          generic_NCR5380_psend
 #define NCR5380_dma_residual            generic_NCR5380_dma_residual
 
 #define NCR5380_intr                    generic_NCR5380_intr
@@ -507,7 +507,7 @@ static void wait_for_53c80_access(struct NCR5380_hostdata *hostdata)
 }
 
 /**
- * generic_NCR5380_pread - pseudo DMA read
+ * generic_NCR5380_precv - pseudo DMA receive
  * @hostdata: scsi host private data
  * @dst: buffer to write into
  * @len: transfer size
@@ -515,7 +515,7 @@ static void wait_for_53c80_access(struct NCR5380_hostdata *hostdata)
  * Perform a pseudo DMA mode receive from a 53C400 or equivalent device.
  */
 
-static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
+static inline int generic_NCR5380_precv(struct NCR5380_hostdata *hostdata,
                                         unsigned char *dst, int len)
 {
 	int residual;
@@ -574,7 +574,7 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
 }
 
 /**
- * generic_NCR5380_pwrite - pseudo DMA write
+ * generic_NCR5380_psend - pseudo DMA send
  * @hostdata: scsi host private data
  * @src: buffer to read from
  * @len: transfer size
@@ -582,8 +582,8 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
  * Perform a pseudo DMA mode send to a 53C400 or equivalent device.
  */
 
-static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
-                                         unsigned char *src, int len)
+static inline int generic_NCR5380_psend(struct NCR5380_hostdata *hostdata,
+                                        unsigned char *src, int len)
 {
 	int residual;
 	int start = 0;
-- 
2.13.0
