From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [RFC PATCH 75/71] ncr5380: Remove FLAG_DTC3181E
Date: Mon, 30 Nov 2015 15:56:56 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1511301349250.10574@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <1448791263-30357-1-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1448791263-30357-1-git-send-email-linux@rainbow-software.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Sun, 29 Nov 2015, Ondrej Zary wrote:

> The FLAG_DTC3181E is used to activate a work-around for arbitration lost
> condition that these chips see when ICR is written during arbitration.
> 
> Move the ICR write (to set SEL and BSY) after the arbitration loss check
> and remove FLAG_DTC3181E.

The first test for ICR_ARBITRATION_LOST happens after the required 
arbitration delay, 2.4 us. The second test for ICR_ARBITRATION_LOST 
happens after ICR_ASSERT_SEL.

This second test seems to be pointless. It comes from the flow chart in 
the NCR datasheet (see download link in patch 17). The spec does not 
require this test but some 5380 devices may do. Who knows? It's almost 
impossible to be sure, because it would mean losing a race with another 
bus device right at the end of the arbitration delay (and we extend that 
delay to 3 us anyway).

Certainly one can find other datasheets with sample code and flow charts 
that don't do this second check. The reason is that ICR_ARBITRATION_LOST 
can be triggered when SEL is asserted by any device, so it may be 
triggered after we've won arbitration (because we then set ICR_ASSERT_SEL 
ourselves in order to enter selection phase).

> 
> ... Weird, we now have two consecutive checks for ICR_ARBITRATION_LOST 
> and do different things when they fail...

They do different things because the second exit has to cleanup after the 
ICR write.

I agree that it would be nice to remove the DTC3181E special case. It 
would mean replacing patch 49.

The patch below is another version of your patch 75. It really needs to be 
tested on all kinds of 5380 device, and if possible with a contested bus 
(which would imply diconnection privileges, for which the driver still 
requires that the chip has a working irq).

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-30 15:34:39.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-30 15:34:39.000000000 +1100
@@ -482,14 +482,13 @@ static void prepare_info(struct Scsi_Hos
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
@@ -1085,18 +1084,6 @@ static struct scsi_cmnd *NCR5380_select(
 	NCR5380_write(INITIATOR_COMMAND_REG,
 		      ICR_BASE | ICR_ASSERT_SEL | ICR_ASSERT_BSY);
 
-	/* RvC: DTC3181E has some trouble with this so we simply removed it.
-	 * Seems to work with only Mustek scanner attached.
-	 */
-	if (!(hostdata->flags & FLAG_DTC3181E) &&
-	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
-		NCR5380_write(MODE_REG, MR_BASE);
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		dsprintk(NDEBUG_ARBITRATION, instance, "arbitration lost, negating SEL\n");
-		spin_lock_irq(&hostdata->lock);
-		goto out;
-	}
-
 	/*
 	 * Again, bus clear + bus settle time is 1.2us, however, this is
 	 * a minimum so we'll udelay ceil(1.2)
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2015-11-30 15:34:36.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2015-11-30 15:34:39.000000000 +1100
@@ -233,7 +233,6 @@
 
 #define FLAG_NO_DMA_FIXUP		1	/* No DMA errata workarounds */
 #define FLAG_NO_PSEUDO_DMA		8	/* Inhibit DMA */
-#define FLAG_DTC3181E			16	/* DTC3181E */
 #define FLAG_LATE_DMA_SETUP		32	/* Setup NCR before DMA H/W */
 #define FLAG_TAGGED_QUEUING		64	/* as X3T9.2 spelled it */
 #define FLAG_TOSHIBA_DELAY		128	/* Allow for borken CD-ROMs */
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-30 15:34:39.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-30 15:34:39.000000000 +1100
@@ -586,13 +586,12 @@ static void prepare_info(struct Scsi_Hos
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
@@ -1286,18 +1285,6 @@ static struct scsi_cmnd *NCR5380_select(
 	NCR5380_write(INITIATOR_COMMAND_REG,
 		      ICR_BASE | ICR_ASSERT_SEL | ICR_ASSERT_BSY);
 
-	/* RvC: DTC3181E has some trouble with this so we simply removed it.
-	 * Seems to work with only Mustek scanner attached.
-	 */
-	if (!(hostdata->flags & FLAG_DTC3181E) &&
-	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
-		NCR5380_write(MODE_REG, MR_BASE);
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		dsprintk(NDEBUG_ARBITRATION, instance, "arbitration lost, negating SEL\n");
-		spin_lock_irq(&hostdata->lock);
-		goto out;
-	}
-
 	/*
 	 * Again, bus clear + bus settle time is 1.2us, however, this is
 	 * a minimum so we'll udelay ceil(1.2)
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2015-11-30 15:34:39.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2015-11-30 15:34:39.000000000 +1100
@@ -326,7 +326,7 @@ static int __init generic_NCR5380_detect
 			ports = ncr_53c400a_ports;
 			break;
 		case BOARD_DTC3181E:
-			flags = FLAG_NO_PSEUDO_DMA | FLAG_DTC3181E;
+			flags = FLAG_NO_PSEUDO_DMA;
 			ports = dtc_3181e_ports;
 			break;
 		}
Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2015-11-30 15:34:35.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2015-11-30 15:34:39.000000000 +1100
@@ -92,7 +92,7 @@ static int dmx3191d_probe_one(struct pci
 	 */
 	shost->irq = NO_IRQ;
 
-	error = NCR5380_init(shost, FLAG_NO_PSEUDO_DMA | FLAG_DTC3181E);
+	error = NCR5380_init(shost, FLAG_NO_PSEUDO_DMA);
 	if (error)
 		goto out_host_put;
 
