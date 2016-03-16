From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 02/22] ncr5380: Remove FLAG_NO_PSEUDO_DMA where possible
Date: Wed, 16 Mar 2016 14:18:43 +1100
Message-ID: <20160316031842.421691430@telegraphics.com.au>
References: <20160316031841.911913894@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-FLAG_NO_PSEUDO_DMA
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

Drivers that define PSEUDO_DMA also define NCR5380_dma_xfer_len.
The core driver must call NCR5380_dma_xfer_len which means
FLAG_NO_PSEUDO_DMA can be eradicated from the core driver.

dmx3191d doesn't define PSEUDO_DMA and has no use for FLAG_NO_PSEUDO_DMA,
so remove it there also.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
 drivers/scsi/NCR5380.c   |    3 +--
 drivers/scsi/dmx3191d.c  |    2 +-
 drivers/scsi/g_NCR5380.c |    7 ++++++-
 drivers/scsi/g_NCR5380.h |    2 +-
 drivers/scsi/mac_scsi.c  |   15 ++++++++++++++-
 5 files changed, 23 insertions(+), 6 deletions(-)

Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2016-03-16 14:16:56.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2016-03-16 14:18:03.000000000 +1100
@@ -93,7 +93,7 @@ static int dmx3191d_probe_one(struct pci
 	 */
 	shost->irq = NO_IRQ;
 
-	error = NCR5380_init(shost, FLAG_NO_PSEUDO_DMA);
+	error = NCR5380_init(shost, 0);
 	if (error)
 		goto out_host_put;
 
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2016-03-16 14:16:56.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2016-03-16 14:18:03.000000000 +1100
@@ -37,7 +37,9 @@
 
 #define NCR5380_pread                   macscsi_pread
 #define NCR5380_pwrite                  macscsi_pwrite
-#define NCR5380_dma_xfer_len(instance, cmd, phase)	(cmd->transfersize)
+
+#define NCR5380_dma_xfer_len(instance, cmd, phase) \
+        macscsi_dma_xfer_len(instance, cmd)
 
 #define NCR5380_intr                    macscsi_intr
 #define NCR5380_queue_command           macscsi_queue_command
@@ -303,6 +305,17 @@ static int macscsi_pwrite(struct Scsi_Ho
 }
 #endif
 
+static int macscsi_dma_xfer_len(struct Scsi_Host *instance,
+                                struct scsi_cmnd *cmd)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+	if (hostdata->flags & FLAG_NO_PSEUDO_DMA)
+		return 0;
+
+	return cmd->transfersize;
+}
+
 #include "NCR5380.c"
 
 #define DRV_MODULE_NAME         "mac_scsi"
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-03-16 14:18:01.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-03-16 14:18:03.000000000 +1100
@@ -712,10 +712,15 @@ static inline int NCR5380_pwrite(struct
 	return 0;
 }
 
-static int generic_NCR5380_dma_xfer_len(struct scsi_cmnd *cmd)
+static int generic_NCR5380_dma_xfer_len(struct Scsi_Host *instance,
+                                        struct scsi_cmnd *cmd)
 {
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int transfersize = cmd->transfersize;
 
+	if (hostdata->flags & FLAG_NO_PSEUDO_DMA)
+		return 0;
+
 	/* Limit transfers to 32K, for xx400 & xx406
 	 * pseudoDMA that transfers in 128 bytes blocks.
 	 */
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-16 14:18:01.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-16 14:18:03.000000000 +1100
@@ -1833,8 +1833,7 @@ static void NCR5380_information_transfer
 
 #if defined(PSEUDO_DMA) || defined(REAL_DMA_POLL)
 				transfersize = 0;
-				if (!cmd->device->borken &&
-				    !(hostdata->flags & FLAG_NO_PSEUDO_DMA))
+				if (!cmd->device->borken)
 					transfersize = NCR5380_dma_xfer_len(instance, cmd, phase);
 
 				if (transfersize) {
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2016-03-16 14:18:01.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2016-03-16 14:18:03.000000000 +1100
@@ -61,7 +61,7 @@
 #endif
 
 #define NCR5380_dma_xfer_len(instance, cmd, phase) \
-        generic_NCR5380_dma_xfer_len(cmd)
+        generic_NCR5380_dma_xfer_len(instance, cmd)
 
 #define NCR5380_intr generic_NCR5380_intr
 #define NCR5380_queue_command generic_NCR5380_queue_command
