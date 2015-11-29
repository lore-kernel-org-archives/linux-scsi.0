From: Ondrej Zary <linux@rainbow-software.org>
Subject: [RFC PATCH 75/71] ncr5380: Remove FLAG_DTC3181E
Date: Sun, 29 Nov 2015 11:01:03 +0100
Message-ID: <1448791263-30357-1-git-send-email-linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151118083455.331768508@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The FLAG_DTC3181E is used to activate a work-around for arbitration lost
condition that these chips see when ICR is written during arbitration.

Move the ICR write (to set SEL and BSY) after the arbitration loss check
and remove FLAG_DTC3181E.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
Weird, we now have two consecutive checks for ICR_ARBITRATION_LOST and
do different things when they fail...

 drivers/scsi/NCR5380.c       |   23 +++++++++--------------
 drivers/scsi/NCR5380.h       |    1 -
 drivers/scsi/atari_NCR5380.c |   23 +++++++++--------------
 drivers/scsi/dmx3191d.c      |    2 +-
 drivers/scsi/g_NCR5380.c     |    2 +-
 5 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index acb359a..b617f99 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -482,14 +482,13 @@ static void prepare_info(struct Scsi_Host *instance)
 	         "base 0x%lx, irq %d, "
 	         "can_queue %d, cmd_per_lun %d, "
 	         "sg_tablesize %d, this_id %d, "
-	         "flags { %s%s%s%s}, "
+	         "flags { %s%s%s}, "
 	         "options { %s} ",
 	         instance->hostt->name, instance->io_port, instance->n_io_port,
 	         instance->base, instance->irq,
 	         instance->can_queue, instance->cmd_per_lun,
 	         instance->sg_tablesize, instance->this_id,
 	         hostdata->flags & FLAG_NO_DMA_FIXUP  ? "NO_DMA_FIXUP "  : "",
-	         hostdata->flags & FLAG_DTC3181E      ? "DTC3181E "      : "",
 	         hostdata->flags & FLAG_NO_PSEUDO_DMA ? "NO_PSEUDO_DMA " : "",
 	         hostdata->flags & FLAG_TOSHIBA_DELAY ? "TOSHIBA_DELAY "  : "",
 #ifdef AUTOPROBE_IRQ
@@ -1078,18 +1077,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 		goto out;
 	}
 
-	/* After/during arbitration, BSY should be asserted.
-	 * IBM DPES-31080 Version S31Q works now
-	 * Tnx to Thomas_Roesch@m2.maus.de for finding this! (Roman)
-	 */
-	NCR5380_write(INITIATOR_COMMAND_REG,
-		      ICR_BASE | ICR_ASSERT_SEL | ICR_ASSERT_BSY);
-
-	/* RvC: DTC3181E has some trouble with this so we simply removed it.
-	 * Seems to work with only Mustek scanner attached.
-	 */
-	if (!(hostdata->flags & FLAG_DTC3181E) &&
-	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
+	if (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		dsprintk(NDEBUG_ARBITRATION, instance, "arbitration lost, negating SEL\n");
@@ -1097,6 +1085,13 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 		goto out;
 	}
 
+	/* After/during arbitration, BSY should be asserted.
+	 * IBM DPES-31080 Version S31Q works now
+	 * Tnx to Thomas_Roesch@m2.maus.de for finding this! (Roman)
+	 */
+	NCR5380_write(INITIATOR_COMMAND_REG,
+		      ICR_BASE | ICR_ASSERT_SEL | ICR_ASSERT_BSY);
+
 	/*
 	 * Again, bus clear + bus settle time is 1.2us, however, this is
 	 * a minimum so we'll udelay ceil(1.2)
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 0d8ec43..5092580 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -222,7 +222,6 @@
 
 #define FLAG_NO_DMA_FIXUP		1	/* No DMA errata workarounds */
 #define FLAG_NO_PSEUDO_DMA		8	/* Inhibit DMA */
-#define FLAG_DTC3181E			16	/* DTC3181E */
 #define FLAG_LATE_DMA_SETUP		32	/* Setup NCR before DMA H/W */
 #define FLAG_TAGGED_QUEUING		64	/* as X3T9.2 spelled it */
 #define FLAG_TOSHIBA_DELAY		128	/* Allow for borken CD-ROMs */
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index d04374d..7640110 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -586,13 +586,12 @@ static void prepare_info(struct Scsi_Host *instance)
 	         "base 0x%lx, irq %d, "
 	         "can_queue %d, cmd_per_lun %d, "
 	         "sg_tablesize %d, this_id %d, "
-	         "flags { %s%s%s}, "
+	         "flags { %s%s}, "
 	         "options { %s} ",
 	         instance->hostt->name, instance->io_port, instance->n_io_port,
 	         instance->base, instance->irq,
 	         instance->can_queue, instance->cmd_per_lun,
 	         instance->sg_tablesize, instance->this_id,
-	         hostdata->flags & FLAG_DTC3181E       ? "DTC3181E "       : "",
 	         hostdata->flags & FLAG_TAGGED_QUEUING ? "TAGGED_QUEUING " : "",
 	         hostdata->flags & FLAG_TOSHIBA_DELAY  ? "TOSHIBA_DELAY "  : "",
 #ifdef DIFFERENTIAL
@@ -1279,18 +1278,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 		goto out;
 	}
 
-	/* After/during arbitration, BSY should be asserted.
-	 * IBM DPES-31080 Version S31Q works now
-	 * Tnx to Thomas_Roesch@m2.maus.de for finding this! (Roman)
-	 */
-	NCR5380_write(INITIATOR_COMMAND_REG,
-		      ICR_BASE | ICR_ASSERT_SEL | ICR_ASSERT_BSY);
-
-	/* RvC: DTC3181E has some trouble with this so we simply removed it.
-	 * Seems to work with only Mustek scanner attached.
-	 */
-	if (!(hostdata->flags & FLAG_DTC3181E) &&
-	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
+	if (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		dsprintk(NDEBUG_ARBITRATION, instance, "arbitration lost, negating SEL\n");
@@ -1298,6 +1286,13 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 		goto out;
 	}
 
+	/* After/during arbitration, BSY should be asserted.
+	 * IBM DPES-31080 Version S31Q works now
+	 * Tnx to Thomas_Roesch@m2.maus.de for finding this! (Roman)
+	 */
+	NCR5380_write(INITIATOR_COMMAND_REG,
+		      ICR_BASE | ICR_ASSERT_SEL | ICR_ASSERT_BSY);
+
 	/*
 	 * Again, bus clear + bus settle time is 1.2us, however, this is
 	 * a minimum so we'll udelay ceil(1.2)
diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index 3c60dfb..ddb4e61 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -92,7 +92,7 @@ static int dmx3191d_probe_one(struct pci_dev *pdev,
 	 */
 	shost->irq = NO_IRQ;
 
-	error = NCR5380_init(shost, FLAG_NO_PSEUDO_DMA | FLAG_DTC3181E);
+	error = NCR5380_init(shost, FLAG_NO_PSEUDO_DMA);
 	if (error)
 		goto out_host_put;
 
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index c3abe48..fae4332 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -331,7 +331,7 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 			ports = ncr_53c400a_ports;
 			break;
 		case BOARD_DTC3181E:
-			flags = FLAG_NO_PSEUDO_DMA | FLAG_DTC3181E;
+			flags = FLAG_NO_PSEUDO_DMA;
 			ports = dtc_3181e_ports;
 			break;
 		}
-- 
Ondrej Zary
