From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 11/23] atari_scsi: Adopt NCR5380.c core driver
Date: Wed, 23 Mar 2016 21:10:20 +1100
Message-ID: <20160323101012.131746413@telegraphics.com.au>
References: <20160323101009.341929635@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_scsi-adopt-NCR5380-c
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

Add support for the Atari ST DMA chip to the NCR5380.c core driver.
This code is copied from atari_NCR5380.c.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>

---
 drivers/scsi/NCR5380.c    |   32 ++++++++++++++++++++++++++++++++
 drivers/scsi/atari_scsi.c |    6 +++---
 2 files changed, 35 insertions(+), 3 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-23 21:09:47.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-23 21:09:51.000000000 +1100
@@ -29,6 +29,8 @@
  * Ronald van Cuijlenborg, Alan Cox and others.
  */
 
+/* Ported to Atari by Roman Hodek and others. */
+
 /*
  * Further development / testing that should be done :
  *
@@ -141,6 +143,14 @@
 #define NCR5380_io_delay(x)
 #endif
 
+#ifndef NCR5380_acquire_dma_irq
+#define NCR5380_acquire_dma_irq(x)	(1)
+#endif
+
+#ifndef NCR5380_release_dma_irq
+#define NCR5380_release_dma_irq(x)
+#endif
+
 static int do_abort(struct Scsi_Host *);
 static void do_reset(struct Scsi_Host *);
 
@@ -658,6 +668,9 @@ static int NCR5380_queue_command(struct
 
 	cmd->result = 0;
 
+	if (!NCR5380_acquire_dma_irq(instance))
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	spin_lock_irqsave(&hostdata->lock, flags);
 
 	/*
@@ -682,6 +695,19 @@ static int NCR5380_queue_command(struct
 	return 0;
 }
 
+static inline void maybe_release_dma_irq(struct Scsi_Host *instance)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+	/* Caller does the locking needed to set & test these data atomically */
+	if (list_empty(&hostdata->disconnected) &&
+	    list_empty(&hostdata->unissued) &&
+	    list_empty(&hostdata->autosense) &&
+	    !hostdata->connected &&
+	    !hostdata->selecting)
+		NCR5380_release_dma_irq(instance);
+}
+
 /**
  * dequeue_next_cmd - dequeue a command for processing
  * @instance: the scsi host instance
@@ -783,6 +809,7 @@ static void NCR5380_main(struct work_str
 
 			if (!NCR5380_select(instance, cmd)) {
 				dsprintk(NDEBUG_MAIN, instance, "main: select complete\n");
+				maybe_release_dma_irq(instance);
 			} else {
 				dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES, instance,
 				         "main: select failed, returning %p to queue\n", cmd);
@@ -1828,6 +1855,8 @@ static void NCR5380_information_transfer
 
 					/* Enable reselect interrupts */
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
+
+					maybe_release_dma_irq(instance);
 					return;
 				case MESSAGE_REJECT:
 					/* Accept message by clearing ACK */
@@ -1963,6 +1992,7 @@ static void NCR5380_information_transfer
 					hostdata->connected = NULL;
 					cmd->result = DID_ERROR << 16;
 					complete_cmd(instance, cmd);
+					maybe_release_dma_irq(instance);
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					return;
 				}
@@ -2256,6 +2286,7 @@ out:
 		dsprintk(NDEBUG_ABORT, instance, "abort: successfully aborted %p\n", cmd);
 
 	queue_work(hostdata->work_q, &hostdata->main_task);
+	maybe_release_dma_irq(instance);
 	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	return result;
@@ -2336,6 +2367,7 @@ static int NCR5380_bus_reset(struct scsi
 	hostdata->dma_len = 0;
 
 	queue_work(hostdata->work_q, &hostdata->main_task);
+	maybe_release_dma_irq(instance);
 	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	return SUCCESS;
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2016-03-23 21:09:44.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2016-03-23 21:09:51.000000000 +1100
@@ -99,9 +99,9 @@
 #define NCR5380_abort                   atari_scsi_abort
 #define NCR5380_info                    atari_scsi_info
 
-#define NCR5380_dma_read_setup(instance, data, count) \
+#define NCR5380_dma_recv_setup(instance, data, count) \
         atari_scsi_dma_setup(instance, data, count, 0)
-#define NCR5380_dma_write_setup(instance, data, count) \
+#define NCR5380_dma_send_setup(instance, data, count) \
         atari_scsi_dma_setup(instance, data, count, 1)
 #define NCR5380_dma_residual(instance) \
         atari_scsi_dma_residual(instance)
@@ -715,7 +715,7 @@ static void atari_scsi_falcon_reg_write(
 }
 
 
-#include "atari_NCR5380.c"
+#include "NCR5380.c"
 
 static int atari_scsi_bus_reset(struct scsi_cmnd *cmd)
 {
