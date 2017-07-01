From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v6 4/6] g_NCR5380: Use unambiguous terminology for PDMA send
 and receive
Date: Fri, 30 Jun 2017 22:40:53 -0400 (EDT)
Message-ID: <54d18c57890918191fc63dff00dea3d74560f1e4.1498876618.git.fthain@telegraphics.com.au>
References: <cover.1498876618.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1498876618.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The word "read" may be used to mean "DMA read operation" or
"SCSI READ command", though a READ command implies writing to memory.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/g_NCR5380.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index dedaed2d16e4..33e1a480c903 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -48,8 +48,8 @@
 	int pdma_residual
 
 #define NCR5380_dma_xfer_len            generic_NCR5380_dma_xfer_len
-#define NCR5380_dma_recv_setup          generic_NCR5380_pread
-#define NCR5380_dma_send_setup          generic_NCR5380_pwrite
+#define NCR5380_dma_recv_setup          generic_NCR5380_precv
+#define NCR5380_dma_send_setup          generic_NCR5380_psend
 #define NCR5380_dma_residual            generic_NCR5380_dma_residual
 
 #define NCR5380_intr                    generic_NCR5380_intr
@@ -481,7 +481,7 @@ static void generic_NCR5380_release_resources(struct Scsi_Host *instance)
 }
 
 /**
- * generic_NCR5380_pread - pseudo DMA read
+ * generic_NCR5380_precv - pseudo DMA receive
  * @hostdata: scsi host private data
  * @dst: buffer to write into
  * @len: transfer size
@@ -489,7 +489,7 @@ static void generic_NCR5380_release_resources(struct Scsi_Host *instance)
  * Perform a pseudo DMA mode receive from a 53C400 or equivalent device.
  */
 
-static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
+static inline int generic_NCR5380_precv(struct NCR5380_hostdata *hostdata,
                                         unsigned char *dst, int len)
 {
 	int blocks = len / 128;
@@ -557,7 +557,7 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
 }
 
 /**
- * generic_NCR5380_pwrite - pseudo DMA write
+ * generic_NCR5380_psend - pseudo DMA send
  * @hostdata: scsi host private data
  * @src: buffer to read from
  * @len: transfer size
@@ -565,8 +565,8 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
  * Perform a pseudo DMA mode send to a 53C400 or equivalent device.
  */
 
-static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
-                                         unsigned char *src, int len)
+static inline int generic_NCR5380_psend(struct NCR5380_hostdata *hostdata,
+                                        unsigned char *src, int len)
 {
 	int blocks = len / 128;
 	int start = 0;
-- 
2.13.0
