From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 1/6] ncr5380: Shorten host info string by removing unused
 option macros
Date: Sun, 15 Jan 2017 18:50:57 -0500 (EST)
Message-ID: <4ba57fd5cd8cc215b378cdd5658cb79ae179d8a0.1484523085.git.fthain@telegraphics.com.au>
References: <cover.1484523085.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1484523085.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The DIFFERENTIAL and PARITY option macros are unused: no supported
hardware uses differential signalling and the core driver never
implemented parity checking. These options just waste space in the host
info string.

While we are here, fix a typo in the NCR5380_info() kernel-doc comment.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c | 49 +++++++++----------------------------------------
 drivers/scsi/NCR5380.h | 10 +---------
 2 files changed, 10 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 4f5ca79..f29b407 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -96,17 +96,6 @@
  * of chips.  To use it, you write an architecture specific functions
  * and macros and include this file in your driver.
  *
- * These macros control options :
- * AUTOSENSE - if defined, REQUEST SENSE will be performed automatically
- * for commands that return with a CHECK CONDITION status.
- *
- * DIFFERENTIAL - if defined, NCR53c81 chips will use external differential
- * transceivers.
- *
- * PSEUDO_DMA - if defined, PSEUDO DMA is used during the data transfer phases.
- *
- * REAL_DMA - if defined, REAL DMA is used during the data transfer phases.
- *
  * These macros MUST be defined :
  *
  * NCR5380_read(register)  - read from the specified register
@@ -347,7 +336,7 @@ static void NCR5380_print_phase(struct Scsi_Host *instance)
 #endif
 
 /**
- * NCR58380_info - report driver and host information
+ * NCR5380_info - report driver and host information
  * @instance: relevant scsi host instance
  *
  * For use as the host template info() handler.
@@ -360,33 +349,6 @@ static const char *NCR5380_info(struct Scsi_Host *instance)
 	return hostdata->info;
 }
 
-static void prepare_info(struct Scsi_Host *instance)
-{
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-
-	snprintf(hostdata->info, sizeof(hostdata->info),
-	         "%s, irq %d, "
-		 "io_port 0x%lx, base 0x%lx, "
-	         "can_queue %d, cmd_per_lun %d, "
-	         "sg_tablesize %d, this_id %d, "
-	         "flags { %s%s%s}, "
-	         "options { %s} ",
-	         instance->hostt->name, instance->irq,
-		 hostdata->io_port, hostdata->base,
-	         instance->can_queue, instance->cmd_per_lun,
-	         instance->sg_tablesize, instance->this_id,
-	         hostdata->flags & FLAG_DMA_FIXUP     ? "DMA_FIXUP "     : "",
-	         hostdata->flags & FLAG_NO_PSEUDO_DMA ? "NO_PSEUDO_DMA " : "",
-	         hostdata->flags & FLAG_TOSHIBA_DELAY ? "TOSHIBA_DELAY "  : "",
-#ifdef DIFFERENTIAL
-	         "DIFFERENTIAL "
-#endif
-#ifdef PARITY
-	         "PARITY "
-#endif
-	         "");
-}
-
 /**
  * NCR5380_init - initialise an NCR5380
  * @instance: adapter to configure
@@ -436,7 +398,14 @@ static int NCR5380_init(struct Scsi_Host *instance, int flags)
 	if (!hostdata->work_q)
 		return -ENOMEM;
 
-	prepare_info(instance);
+	snprintf(hostdata->info, sizeof(hostdata->info),
+		"%s, irq %d, io_port 0x%lx, base 0x%lx, can_queue %d, cmd_per_lun %d, sg_tablesize %d, this_id %d, flags { %s%s%s}",
+		instance->hostt->name, instance->irq, hostdata->io_port,
+		hostdata->base, instance->can_queue, instance->cmd_per_lun,
+		instance->sg_tablesize, instance->this_id,
+		hostdata->flags & FLAG_DMA_FIXUP     ? "DMA_FIXUP "     : "",
+		hostdata->flags & FLAG_NO_PSEUDO_DMA ? "NO_PSEUDO_DMA " : "",
+		hostdata->flags & FLAG_TOSHIBA_DELAY ? "TOSHIBA_DELAY " : "");
 
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 	NCR5380_write(MODE_REG, MR_BASE);
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 51a3567..e61d9f9 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -81,11 +81,7 @@
 #define ICR_ASSERT_ATN		0x02	/* rw Set to assert ATN */
 #define ICR_ASSERT_DATA		0x01	/* rw SCSI_DATA_REG is asserted */
 
-#ifdef DIFFERENTIAL
-#define ICR_BASE		ICR_DIFF_ENABLE
-#else
 #define ICR_BASE		0
-#endif
 
 #define MODE_REG		2
 /*
@@ -102,11 +98,7 @@
 #define MR_DMA_MODE		0x02	/* rw DMA / pseudo DMA mode */
 #define MR_ARBITRATE		0x01	/* rw start arbitration */
 
-#ifdef PARITY
-#define MR_BASE			MR_ENABLE_PAR_CHECK
-#else
 #define MR_BASE			0
-#endif
 
 #define TARGET_COMMAND_REG	3
 #define TCR_LAST_BYTE_SENT	0x80	/* ro DMA done */
@@ -234,7 +226,7 @@ struct NCR5380_hostdata {
 	unsigned char id_higher_mask;		/* All bits above id_mask */
 	unsigned char last_message;		/* Last Message Out */
 	unsigned long region_size;		/* Size of address/port range */
-	char info[256];
+	char info[168];				/* Host banner message */
 };
 
 #ifdef __KERNEL__
-- 
2.10.2
