From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 4/6] ncr5380: Resolve various static checker warnings
Date: Sun, 15 Jan 2017 18:50:57 -0500 (EST)
Message-ID: <090327a93080f332949dd5535f3c80519e349a2a.1484523085.git.fthain@telegraphics.com.au>
References: <cover.1484523085.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1484523085.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Avoid various warnings from "make C=1" by annotating a couple of
unlock-then-lock sequences, replacing a zero with NULL and
correcting some type casts.

Also avoid a warning from "make W=1" by adding braces.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
These are the warning messages referred to above:

drivers/scsi/NCR5380.c:
warning: context imbalance in 'NCR5380_select' - unexpected unlock
warning: context imbalance in 'NCR5380_information_transfer' - unexpected unlock

drivers/scsi/atari_scsi.c:816:39: warning: Using plain integer as NULL pointer

drivers/scsi/mac_scsi.c:157:46: warning: incorrect type in initializer (different address spaces)
drivers/scsi/mac_scsi.c:157:46: expected unsigned char *s
drivers/scsi/mac_scsi.c:157:46:    got unsigned char [noderef] [usertype] <asn:2>*

drivers/scsi/mac_scsi.c:260:46: warning: incorrect type in initializer (different address spaces)
drivers/scsi/mac_scsi.c:260:46: expected unsigned char *d
drivers/scsi/mac_scsi.c:260:46:    got unsigned char [noderef] [usertype] <asn:2>*

drivers/scsi/mac_scsi.c:384:22: warning: incorrect type in assignment (different address spaces)
drivers/scsi/mac_scsi.c:384:22: expected unsigned char [noderef] [usertype] <asn:2>*io
drivers/scsi/mac_scsi.c:384:22:    got void *<noident>

drivers/scsi/mac_scsi.c:387:35: warning: incorrect type in assignment (different address spaces)
drivers/scsi/mac_scsi.c:387:35: expected unsigned char [noderef] [usertype] <asn:2>*pdma_io
drivers/scsi/mac_scsi.c:387:35:    got void *<noident>

drivers/scsi/NCR5380.c: In function 'maybe_release_dma_irq':
drivers/scsi/NCR5380.c:626:36: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
   NCR5380_release_dma_irq(instance);

Avoiding these messages doesn't fix any bugs but may improve the
signal/noise ratio of static checker output.
---
 drivers/scsi/NCR5380.c    | 5 ++++-
 drivers/scsi/atari_scsi.c | 2 +-
 drivers/scsi/mac_scsi.c   | 8 ++++----
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index f29b407..518d101 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -591,8 +591,9 @@ static inline void maybe_release_dma_irq(struct Scsi_Host *instance)
 	    list_empty(&hostdata->unissued) &&
 	    list_empty(&hostdata->autosense) &&
 	    !hostdata->connected &&
-	    !hostdata->selecting)
+	    !hostdata->selecting) {
 		NCR5380_release_dma_irq(instance);
+	}
 }
 
 /**
@@ -931,6 +932,7 @@ static irqreturn_t __maybe_unused NCR5380_intr(int irq, void *dev_id)
 
 static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
                                         struct scsi_cmnd *cmd)
+	__releases(&hostdata->lock) __acquires(&hostdata->lock)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char tmp[3], phase;
@@ -1623,6 +1625,7 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
  */
 
 static void NCR5380_information_transfer(struct Scsi_Host *instance)
+	__releases(&hostdata->lock) __acquires(&hostdata->lock)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char msgout = NOP;
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 2b6eb7c..b2ffab65 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -782,7 +782,7 @@ static int __init atari_scsi_probe(struct platform_device *pdev)
 			return -ENOMEM;
 		}
 		atari_dma_phys_buffer = atari_stram_to_phys(atari_dma_buffer);
-		atari_dma_orig_addr = 0;
+		atari_dma_orig_addr = NULL;
 	}
 
 	instance = scsi_host_alloc(&atari_scsi_template,
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index ccb68d1..196acc7 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -154,7 +154,7 @@ __asm__ __volatile__					\
 static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
                                 unsigned char *dst, int len)
 {
-	unsigned char *s = hostdata->pdma_io + (INPUT_DATA_REG << 4);
+	u8 __iomem *s = hostdata->pdma_io + (INPUT_DATA_REG << 4);
 	unsigned char *d = dst;
 	int n = len;
 	int transferred;
@@ -257,7 +257,7 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
                                  unsigned char *src, int len)
 {
 	unsigned char *s = src;
-	unsigned char *d = hostdata->pdma_io + (OUTPUT_DATA_REG << 4);
+	u8 __iomem *d = hostdata->pdma_io + (OUTPUT_DATA_REG << 4);
 	int n = len;
 	int transferred;
 
@@ -381,10 +381,10 @@ static int __init mac_scsi_probe(struct platform_device *pdev)
 
 	hostdata = shost_priv(instance);
 	hostdata->base = pio_mem->start;
-	hostdata->io = (void *)pio_mem->start;
+	hostdata->io = (u8 __iomem *)pio_mem->start;
 
 	if (pdma_mem && setup_use_pdma)
-		hostdata->pdma_io = (void *)pdma_mem->start;
+		hostdata->pdma_io = (u8 __iomem *)pdma_mem->start;
 	else
 		host_flags |= FLAG_NO_PSEUDO_DMA;
 
-- 
2.10.2
