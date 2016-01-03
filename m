From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 49/78] ncr5380: Remove redundant ICR_ARBITRATION_LOST test and eliminate FLAG_DTC3181E
Date: Sun, 03 Jan 2016 16:05:50 +1100
Message-ID: <20160103050513.991541564@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-eliminate-redundant-ICR_ARBITRATION_LOST-test
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove FLAG_DTC3181E. It was used to suppress a final Arbitration Lost
(SEL asserted) test that isn't actually needed. The test was suppressed
because it causes problems for DTC436 and DTC536 chips. It takes place
after the host wins arbitration, so SEL has been asserted. These chips
can't seem to tell whether it was the host or another bus device that
did so.

This questionable final test appears in a flow chart in an early NCR5380
datasheet. It was removed from later documents like the DP5380 datasheet.

By the time this final test takes place, the driver has already tested
the Arbitration Lost bit several times. The first test happens 3 us after
BUS FREE (or longer due to register access delays). The protocol requires
that a device stop signalling within 1.8 us after BUS FREE unless it won
arbitration, in which case it must assert SEL, which is detected 1.2 us
later by the first Arbitration Lost test.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |   14 +-------------
 drivers/scsi/NCR5380.h       |    1 -
 drivers/scsi/atari_NCR5380.c |    9 ---------
 drivers/scsi/dmx3191d.c      |    2 +-
 drivers/scsi/g_NCR5380.c     |    2 +-
 5 files changed, 3 insertions(+), 25 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:04:02.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:04:08.000000000 +1100
@@ -528,14 +528,13 @@ static void prepare_info(struct Scsi_Hos
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
@@ -1159,17 +1158,6 @@ static int NCR5380_select(struct Scsi_Ho
 	NCR5380_write(INITIATOR_COMMAND_REG,
 		      ICR_BASE | ICR_ASSERT_SEL | ICR_ASSERT_BSY);
 
-	if (!(hostdata->flags & FLAG_DTC3181E) &&
-	    /* RvC: DTC3181E has some trouble with this
-	     *      so we simply removed it. Seems to work with
-	     *      only Mustek scanner attached
-	     */
-	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
-		NCR5380_write(MODE_REG, MR_BASE);
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		dprintk(NDEBUG_ARBITRATION, "scsi%d : lost arbitration, deasserting ICR_ASSERT_SEL\n", instance->host_no);
-		return -1;
-	}
 	/* 
 	 * Again, bus clear + bus settle time is 1.2us, however, this is 
 	 * a minimum so we'll udelay ceil(1.2)
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2016-01-03 16:04:00.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2016-01-03 16:04:08.000000000 +1100
@@ -232,7 +232,6 @@
 
 #define FLAG_NO_DMA_FIXUP		1	/* No DMA errata workarounds */
 #define FLAG_NO_PSEUDO_DMA		8	/* Inhibit DMA */
-#define FLAG_DTC3181E			16	/* DTC3181E */
 #define FLAG_LATE_DMA_SETUP		32	/* Setup NCR before DMA H/W */
 #define FLAG_TAGGED_QUEUING		64	/* as X3T9.2 spelled it */
 #define FLAG_TOSHIBA_DELAY		128	/* Allow for borken CD-ROMs */
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:07.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:08.000000000 +1100
@@ -1420,15 +1420,6 @@ static int NCR5380_select(struct Scsi_Ho
 	NCR5380_write(INITIATOR_COMMAND_REG,
 		      ICR_BASE | ICR_ASSERT_SEL | ICR_ASSERT_BSY);
 
-	if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
-	    hostdata->connected) {
-		NCR5380_write(MODE_REG, MR_BASE);
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		dprintk(NDEBUG_ARBITRATION, "scsi%d: lost arbitration, deasserting ICR_ASSERT_SEL\n",
-			   HOSTNO);
-		return -1;
-	}
-
 	/*
 	 * Again, bus clear + bus settle time is 1.2us, however, this is
 	 * a minimum so we'll udelay ceil(1.2)
Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2016-01-03 16:04:03.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2016-01-03 16:04:08.000000000 +1100
@@ -91,7 +91,7 @@ static int dmx3191d_probe_one(struct pci
 	 */
 	shost->irq = NO_IRQ;
 
-	error = NCR5380_init(shost, FLAG_NO_PSEUDO_DMA | FLAG_DTC3181E);
+	error = NCR5380_init(shost, FLAG_NO_PSEUDO_DMA);
 	if (error)
 		goto out_host_put;
 
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-01-03 16:04:03.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-01-03 16:04:08.000000000 +1100
@@ -326,7 +326,7 @@ static int __init generic_NCR5380_detect
 			ports = ncr_53c400a_ports;
 			break;
 		case BOARD_DTC3181E:
-			flags = FLAG_NO_PSEUDO_DMA | FLAG_DTC3181E;
+			flags = FLAG_NO_PSEUDO_DMA;
 			ports = dtc_3181e_ports;
 			break;
 		}
