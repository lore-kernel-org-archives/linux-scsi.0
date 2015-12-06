From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 10/72] atari_NCR5380: Remove RESET_BOOT, CONFIG_ATARI_SCSI_TOSHIBA_DELAY and CONFIG_ATARI_SCSI_RESET_BOOT
Date: Sun, 06 Dec 2015 12:31:36 +1100
Message-ID: <20151206013129.455488052@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_NCR5380-remove-RESET_BOOT
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The atari_NCR5380.c core driver now takes care of bus reset upon driver
initialization if required (same as NCR5380.c). Move the Toshiba CD-ROM
support into the core driver, enabled with a host flag, so that all
NCR5380 drivers can make use of it.

Drop the RESET_BOOT macros and the ATARI_SCSI_RESET_BOOT and 
ATARI_SCSI_TOSHIBA_DELAY Kconfig symbols, which are now redundant.

Remove the atari_scsi_reset_boot(), mac_scsi_reset_boot() and
sun3_scsi_reset_boot() routines. None of this duplicated code is needed
now that all drivers can use NCR5380_maybe_reset_bus().

This brings atari_scsi, mac_scsi and sun3_scsi into line with all of the
other NCR5380 drivers.

The bus reset may raise an interrupt. That would be new behaviour for
atari_scsi only when CONFIG_ATARI_SCSI_RESET_BOOT=n. The ST DMA interrupt
is not assigned to atari_scsi at this stage, so
CONFIG_ATARI_SCSI_RESET_BOOT=y may well be problematic already.
Regardless, do_reset() now raises and clears the interrupt within
local_irq_save/restore which should avoid problems.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---

Changed since v1:
- Fixed minor inconsistency in mac5380= usage message.

---
 drivers/scsi/Kconfig         |   17 -----------
 drivers/scsi/NCR5380.c       |   17 +++++++++--
 drivers/scsi/NCR5380.h       |    1 
 drivers/scsi/atari_NCR5380.c |   22 +++++++++-----
 drivers/scsi/atari_scsi.c    |   60 +++++----------------------------------
 drivers/scsi/mac_scsi.c      |   65 ++++++-------------------------------------
 drivers/scsi/sun3_scsi.c     |   47 -------------------------------
 7 files changed, 51 insertions(+), 178 deletions(-)

Index: linux/drivers/scsi/Kconfig
===================================================================
--- linux.orig/drivers/scsi/Kconfig	2015-12-06 12:29:18.000000000 +1100
+++ linux/drivers/scsi/Kconfig	2015-12-06 12:29:36.000000000 +1100
@@ -1624,23 +1624,6 @@ config ATARI_SCSI
 	  ST-DMA, replacing ACSI).  It does NOT support other schemes, like
 	  in the Hades (without DMA).
 
-config ATARI_SCSI_TOSHIBA_DELAY
-	bool "Long delays for Toshiba CD-ROMs"
-	depends on ATARI_SCSI
-	help
-	  This option increases the delay after a SCSI arbitration to
-	  accommodate some flaky Toshiba CD-ROM drives. Say Y if you intend to
-	  use a Toshiba CD-ROM drive; otherwise, the option is not needed and
-	  would impact performance a bit, so say N.
-
-config ATARI_SCSI_RESET_BOOT
-	bool "Reset SCSI-devices at boottime"
-	depends on ATARI_SCSI
-	help
-	  Reset the devices on your Atari whenever it boots.  This makes the
-	  boot process fractionally longer but may assist recovery from errors
-	  that leave the devices with SCSI operations partway completed.
-
 config MAC_SCSI
 	tristate "Macintosh NCR5380 SCSI"
 	depends on MAC && SCSI=y
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-06 12:29:34.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-06 12:29:36.000000000 +1100
@@ -674,13 +674,14 @@ static void prepare_info(struct Scsi_Hos
 	         "base 0x%lx, irq %d, "
 	         "can_queue %d, cmd_per_lun %d, "
 	         "sg_tablesize %d, this_id %d, "
-	         "flags { %s}, "
+	         "flags { %s%s}, "
 	         "options { %s} ",
 	         instance->hostt->name, instance->io_port, instance->n_io_port,
 	         instance->base, instance->irq,
 	         instance->can_queue, instance->cmd_per_lun,
 	         instance->sg_tablesize, instance->this_id,
 	         hostdata->flags & FLAG_TAGGED_QUEUING ? "TAGGED_QUEUING " : "",
+	         hostdata->flags & FLAG_TOSHIBA_DELAY  ? "TOSHIBA_DELAY "  : "",
 #ifdef DIFFERENTIAL
 	         "DIFFERENTIAL "
 #endif
@@ -860,6 +861,7 @@ static int __init NCR5380_init(struct Sc
 
 static int NCR5380_maybe_reset_bus(struct Scsi_Host *instance)
 {
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int pass;
 
 	for (pass = 1; (NCR5380_read(STATUS_REG) & SR_BSY) && pass <= 6; ++pass) {
@@ -878,6 +880,14 @@ static int NCR5380_maybe_reset_bus(struc
 		case 4:
 			shost_printk(KERN_ERR, instance, "bus busy, attempting reset\n");
 			do_reset(instance);
+			/* Wait after a reset; the SCSI standard calls for
+			 * 250ms, we wait 500ms to be on the safe side.
+			 * But some Toshiba CD-ROMs need ten times that.
+			 */
+			if (hostdata->flags & FLAG_TOSHIBA_DELAY)
+				msleep(2500);
+			else
+				msleep(500);
 			break;
 		case 6:
 			shost_printk(KERN_ERR, instance, "bus locked solid\n");
@@ -1493,12 +1503,10 @@ static int NCR5380_select(struct Scsi_Ho
 	 * a minimum so we'll udelay ceil(1.2)
 	 */
 
-#ifdef CONFIG_ATARI_SCSI_TOSHIBA_DELAY
-	/* ++roman: But some targets (see above :-) seem to need a bit more... */
-	udelay(15);
-#else
-	udelay(2);
-#endif
+	if (hostdata->flags & FLAG_TOSHIBA_DELAY)
+		udelay(15);
+	else
+		udelay(2);
 
 	if (hostdata->connected) {
 		NCR5380_write(MODE_REG, MR_BASE);
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2015-12-06 12:29:18.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2015-12-06 12:29:36.000000000 +1100
@@ -164,15 +164,6 @@ static inline unsigned long SCSI_DMA_GET
 #define HOSTDATA_DMALEN		(((struct NCR5380_hostdata *) \
 				(atari_scsi_host->hostdata))->dma_len)
 
-/* Time (in jiffies) to wait after a reset; the SCSI standard calls for 250ms,
- * we usually do 0.5s to be on the safe side. But Toshiba CD-ROMs once more
- * need ten times the standard value... */
-#ifndef CONFIG_ATARI_SCSI_TOSHIBA_DELAY
-#define	AFTER_RESET_DELAY	(HZ/2)
-#else
-#define	AFTER_RESET_DELAY	(5*HZ/2)
-#endif
-
 #ifdef REAL_DMA
 static void atari_scsi_fetch_restbytes(void);
 #endif
@@ -208,12 +199,12 @@ static int setup_cmd_per_lun = -1;
 module_param(setup_cmd_per_lun, int, 0);
 static int setup_sg_tablesize = -1;
 module_param(setup_sg_tablesize, int, 0);
-#ifdef SUPPORT_TAGS
 static int setup_use_tagged_queuing = -1;
 module_param(setup_use_tagged_queuing, int, 0);
-#endif
 static int setup_hostid = -1;
 module_param(setup_hostid, int, 0);
+static int setup_toshiba_delay = -1;
+module_param(setup_toshiba_delay, int, 0);
 
 
 #if defined(REAL_DMA)
@@ -488,7 +479,7 @@ static int __init atari_scsi_setup(char
 	 * Defaults depend on TT or Falcon, determined at run time.
 	 * Negative values mean don't change.
 	 */
-	int ints[6];
+	int ints[8];
 
 	get_options(str, ARRAY_SIZE(ints), ints);
 
@@ -504,10 +495,11 @@ static int __init atari_scsi_setup(char
 		setup_sg_tablesize = ints[3];
 	if (ints[0] >= 4)
 		setup_hostid = ints[4];
-#ifdef SUPPORT_TAGS
 	if (ints[0] >= 5)
 		setup_use_tagged_queuing = ints[5];
-#endif
+	/* ints[6] (use_pdma) is ignored */
+	if (ints[0] >= 7)
+		setup_toshiba_delay = ints[7];
 
 	return 1;
 }
@@ -516,38 +508,6 @@ __setup("atascsi=", atari_scsi_setup);
 #endif /* !MODULE */
 
 
-#ifdef CONFIG_ATARI_SCSI_RESET_BOOT
-static void __init atari_scsi_reset_boot(void)
-{
-	unsigned long end;
-
-	/*
-	 * Do a SCSI reset to clean up the bus during initialization. No messing
-	 * with the queues, interrupts, or locks necessary here.
-	 */
-
-	printk("Atari SCSI: resetting the SCSI bus...");
-
-	/* get in phase */
-	NCR5380_write(TARGET_COMMAND_REG,
-		      PHASE_SR_TO_TCR(NCR5380_read(STATUS_REG)));
-
-	/* assert RST */
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_RST);
-	/* The min. reset hold time is 25us, so 40us should be enough */
-	udelay(50);
-	/* reset RST and interrupt */
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-
-	end = jiffies + AFTER_RESET_DELAY;
-	while (time_before(jiffies, end))
-		barrier();
-
-	printk(" done\n");
-}
-#endif
-
 #if defined(REAL_DMA)
 
 static unsigned long atari_scsi_dma_setup(struct Scsi_Host *instance,
@@ -917,17 +877,13 @@ static int __init atari_scsi_probe(struc
 	}
 	atari_scsi_host = instance;
 
-#ifdef CONFIG_ATARI_SCSI_RESET_BOOT
-	atari_scsi_reset_boot();
-#endif
-
 	instance->irq = irq->start;
 
 	host_flags |= IS_A_TT() ? 0 : FLAG_LATE_DMA_SETUP;
-
 #ifdef SUPPORT_TAGS
 	host_flags |= setup_use_tagged_queuing > 0 ? FLAG_TAGGED_QUEUING : 0;
 #endif
+	host_flags |= setup_toshiba_delay > 0 ? FLAG_TOSHIBA_DELAY : 0;
 
 	NCR5380_init(instance, host_flags);
 
@@ -975,6 +931,8 @@ static int __init atari_scsi_probe(struc
 #endif
 	}
 
+	NCR5380_maybe_reset_bus(instance);
+
 	error = scsi_add_host(instance, NULL);
 	if (error)
 		goto fail_host;
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2015-12-06 12:29:25.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2015-12-06 12:29:36.000000000 +1100
@@ -49,8 +49,6 @@
 
 #include "NCR5380.h"
 
-#define RESET_BOOT
-
 static int setup_can_queue = -1;
 module_param(setup_can_queue, int, 0);
 static int setup_cmd_per_lun = -1;
@@ -63,17 +61,8 @@ static int setup_use_tagged_queuing = -1
 module_param(setup_use_tagged_queuing, int, 0);
 static int setup_hostid = -1;
 module_param(setup_hostid, int, 0);
-
-/* Time (in jiffies) to wait after a reset; the SCSI standard calls for 250ms,
- * we usually do 0.5s to be on the safe side. But Toshiba CD-ROMs once more
- * need ten times the standard value... */
-#define TOSHIBA_DELAY
-
-#ifdef TOSHIBA_DELAY
-#define	AFTER_RESET_DELAY	(5*HZ/2)
-#else
-#define	AFTER_RESET_DELAY	(HZ/2)
-#endif
+static int setup_toshiba_delay = -1;
+module_param(setup_toshiba_delay, int, 0);
 
 /*
  * NCR 5380 register access functions
@@ -92,12 +81,12 @@ static inline void macscsi_write(struct
 #ifndef MODULE
 static int __init mac_scsi_setup(char *str)
 {
-	int ints[7];
+	int ints[8];
 
 	(void)get_options(str, ARRAY_SIZE(ints), ints);
 
-	if (ints[0] < 1 || ints[0] > 6) {
-		pr_err("Usage: mac5380=<can_queue>[,<cmd_per_lun>[,<sg_tablesize>[,<hostid>[,<use_tags>[,<use_pdma>]]]]]\n");
+	if (ints[0] < 1) {
+		pr_err("Usage: mac5380=<can_queue>[,<cmd_per_lun>[,<sg_tablesize>[,<hostid>[,<use_tags>[,<use_pdma>[,<toshiba_delay>]]]]]]\n");
 		return 0;
 	}
 	if (ints[0] >= 1)
@@ -112,47 +101,14 @@ static int __init mac_scsi_setup(char *s
 		setup_use_tagged_queuing = ints[5];
 	if (ints[0] >= 6)
 		setup_use_pdma = ints[6];
+	if (ints[0] >= 7)
+		setup_toshiba_delay = ints[7];
 	return 1;
 }
 
 __setup("mac5380=", mac_scsi_setup);
 #endif /* !MODULE */
 
-#ifdef RESET_BOOT
-/*
- * Our 'bus reset on boot' function
- */
-
-static void mac_scsi_reset_boot(struct Scsi_Host *instance)
-{
-	unsigned long end;
-
-	/*
-	 * Do a SCSI reset to clean up the bus during initialization. No messing
-	 * with the queues, interrupts, or locks necessary here.
-	 */
-
-	printk(KERN_INFO "Macintosh SCSI: resetting the SCSI bus..." );
-
-	/* get in phase */
-	NCR5380_write( TARGET_COMMAND_REG,
-		      PHASE_SR_TO_TCR( NCR5380_read(STATUS_REG) ));
-
-	/* assert RST */
-	NCR5380_write( INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_RST );
-	/* The min. reset hold time is 25us, so 40us should be enough */
-	udelay( 50 );
-	/* reset RST and interrupt */
-	NCR5380_write( INITIATOR_COMMAND_REG, ICR_BASE );
-	NCR5380_read( RESET_PARITY_INTERRUPT_REG );
-
-	for( end = jiffies + AFTER_RESET_DELAY; time_before(jiffies, end); )
-		barrier();
-
-	printk(KERN_INFO " done\n" );
-}
-#endif
-
 #ifdef PSEUDO_DMA
 /* 
    Pseudo-DMA: (Ove Edlund)
@@ -421,13 +377,10 @@ static int __init mac_scsi_probe(struct
 	} else
 		host_flags |= FLAG_NO_PSEUDO_DMA;
 
-#ifdef RESET_BOOT
-	mac_scsi_reset_boot(instance);
-#endif
-
 #ifdef SUPPORT_TAGS
 	host_flags |= setup_use_tagged_queuing > 0 ? FLAG_TAGGED_QUEUING : 0;
 #endif
+	host_flags |= setup_toshiba_delay > 0 ? FLAG_TOSHIBA_DELAY : 0;
 
 	NCR5380_init(instance, host_flags);
 
@@ -438,6 +391,8 @@ static int __init mac_scsi_probe(struct
 			goto fail_irq;
 	}
 
+	NCR5380_maybe_reset_bus(instance);
+
 	error = scsi_add_host(instance, NULL);
 	if (error)
 		goto fail_host;
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2015-12-06 12:29:19.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2015-12-06 12:29:36.000000000 +1100
@@ -86,10 +86,6 @@ module_param(setup_use_tagged_queuing, i
 static int setup_hostid = -1;
 module_param(setup_hostid, int, 0);
 
-/* #define RESET_BOOT */
-
-#define	AFTER_RESET_DELAY	(HZ/2)
-
 /* ms to wait after hitting dma regs */
 #define SUN3_DMA_DELAY 10
 
@@ -144,45 +140,6 @@ static inline void sun3_udc_write(unsign
 }
 #endif
 
-#ifdef RESET_BOOT
-static void sun3_scsi_reset_boot(struct Scsi_Host *instance)
-{
-	unsigned long end;
-	
-	/*
-	 * Do a SCSI reset to clean up the bus during initialization. No
-	 * messing with the queues, interrupts, or locks necessary here.
-	 */
-
-	printk( "Sun3 SCSI: resetting the SCSI bus..." );
-
-	/* switch off SCSI IRQ - catch an interrupt without IRQ bit set else */
-//       	sun3_disable_irq( IRQ_SUN3_SCSI );
-
-	/* get in phase */
-	NCR5380_write( TARGET_COMMAND_REG,
-		      PHASE_SR_TO_TCR( NCR5380_read(STATUS_REG) ));
-
-	/* assert RST */
-	NCR5380_write( INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_RST );
-
-	/* The min. reset hold time is 25us, so 40us should be enough */
-	udelay( 50 );
-
-	/* reset RST and interrupt */
-	NCR5380_write( INITIATOR_COMMAND_REG, ICR_BASE );
-	NCR5380_read( RESET_PARITY_INTERRUPT_REG );
-
-	for( end = jiffies + AFTER_RESET_DELAY; time_before(jiffies, end); )
-		barrier();
-
-	/* switch on SCSI IRQ again */
-//       	sun3_enable_irq( IRQ_SUN3_SCSI );
-
-	printk( " done\n" );
-}
-#endif
-
 // safe bits for the CSR
 #define CSR_GOOD 0x060f
 
@@ -631,9 +588,7 @@ static int __init sun3_scsi_probe(struct
 	dregs->ivect = VME_DATA24 | (instance->irq & 0xff);
 #endif
 
-#ifdef RESET_BOOT
-	sun3_scsi_reset_boot(instance);
-#endif
+	NCR5380_maybe_reset_bus(instance);
 
 	error = scsi_add_host(instance, NULL);
 	if (error)
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2015-12-06 12:29:30.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2015-12-06 12:29:36.000000000 +1100
@@ -243,6 +243,7 @@
 #define FLAG_DTC3181E			16	/* DTC3181E */
 #define FLAG_LATE_DMA_SETUP		32	/* Setup NCR before DMA H/W */
 #define FLAG_TAGGED_QUEUING		64	/* as X3T9.2 spelled it */
+#define FLAG_TOSHIBA_DELAY		128	/* Allow for borken CD-ROMs */
 
 #ifdef SUPPORT_TAGS
 struct tag_alloc {
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-06 12:29:34.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-06 12:29:36.000000000 +1100
@@ -618,7 +618,7 @@ static void prepare_info(struct Scsi_Hos
 	         "base 0x%lx, irq %d, "
 	         "can_queue %d, cmd_per_lun %d, "
 	         "sg_tablesize %d, this_id %d, "
-	         "flags { %s%s%s}, "
+	         "flags { %s%s%s%s}, "
 #if defined(USLEEP_POLL) && defined(USLEEP_WAITLONG)
 		 "USLEEP_POLL %lu, USLEEP_WAITLONG %lu, "
 #endif
@@ -630,6 +630,7 @@ static void prepare_info(struct Scsi_Hos
 	         hostdata->flags & FLAG_NCR53C400     ? "NCR53C400 "     : "",
 	         hostdata->flags & FLAG_DTC3181E      ? "DTC3181E "      : "",
 	         hostdata->flags & FLAG_NO_PSEUDO_DMA ? "NO_PSEUDO_DMA " : "",
+	         hostdata->flags & FLAG_TOSHIBA_DELAY ? "TOSHIBA_DELAY "  : "",
 #if defined(USLEEP_POLL) && defined(USLEEP_WAITLONG)
 	         USLEEP_POLL, USLEEP_WAITLONG,
 #endif
@@ -831,6 +832,7 @@ static int NCR5380_init(struct Scsi_Host
 
 static int NCR5380_maybe_reset_bus(struct Scsi_Host *instance)
 {
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int pass;
 
 	for (pass = 1; (NCR5380_read(STATUS_REG) & SR_BSY) && pass <= 6; ++pass) {
@@ -849,6 +851,14 @@ static int NCR5380_maybe_reset_bus(struc
 		case 4:
 			shost_printk(KERN_ERR, instance, "bus busy, attempting reset\n");
 			do_reset(instance);
+			/* Wait after a reset; the SCSI standard calls for
+			 * 250ms, we wait 500ms to be on the safe side.
+			 * But some Toshiba CD-ROMs need ten times that.
+			 */
+			if (hostdata->flags & FLAG_TOSHIBA_DELAY)
+				msleep(2500);
+			else
+				msleep(500);
 			break;
 		case 6:
 			shost_printk(KERN_ERR, instance, "bus locked solid\n");
@@ -1253,7 +1263,10 @@ static int NCR5380_select(struct Scsi_Ho
 	 * a minimum so we'll udelay ceil(1.2)
 	 */
 
-	udelay(2);
+	if (hostdata->flags & FLAG_TOSHIBA_DELAY)
+		udelay(15);
+	else
+		udelay(2);
 
 	dprintk(NDEBUG_ARBITRATION, "scsi%d : won arbitration\n", instance->host_no);
 
