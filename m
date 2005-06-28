From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic7xxx: remove ahc_tailq
Date: Tue, 28 Jun 2005 16:50:40 +0200
Message-ID: <20050628145040.GB5130@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:38810 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261793AbVF1Oup (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2005 10:50:45 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

now that we do normal PCI probing there's no need to keep a list of
all HBAs. 


Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7770.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7770.c	2005-06-11 00:06:08.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7770.c	2005-06-28 14:39:00.000000000 +0200
@@ -254,19 +254,12 @@
 	if (error != 0)
 		return (error);
 
-	ahc_list_lock(&l);
-	/*
-	 * Link this softc in with all other ahc instances.
-	 */
-	ahc_softc_insert(ahc);
+	ahc->init_level++;
 
 	/*
 	 * Enable the board's BUS drivers
 	 */
 	ahc_outb(ahc, BCTL, ENABLE);
-
-	ahc_list_unlock(&l);
-
 	return (0);
 }
 
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx.h	2005-06-12 12:19:49.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx.h	2005-06-28 14:44:07.000000000 +0200
@@ -1023,9 +1023,6 @@
 	struct cs		 *critical_sections;
 	u_int			  num_critical_sections;
 
-	/* Links for chaining softcs */
-	TAILQ_ENTRY(ahc_softc)	  links;
-
 	/* Channel Names ('A', 'B', etc.) */
 	char			  channel;
 	char			  channel_b;
@@ -1110,9 +1107,6 @@
 	uint16_t		  user_tagenable;/* Tagged Queuing allowed */
 };
 
-TAILQ_HEAD(ahc_softc_tailq, ahc_softc);
-extern struct ahc_softc_tailq ahc_tailq;
-
 /************************ Active Device Information ***************************/
 typedef enum {
 	ROLE_UNKNOWN,
@@ -1198,7 +1192,6 @@
 void			 ahc_pause_and_flushwork(struct ahc_softc *ahc);
 int			 ahc_suspend(struct ahc_softc *ahc); 
 int			 ahc_resume(struct ahc_softc *ahc);
-void			 ahc_softc_insert(struct ahc_softc *);
 void			 ahc_set_unit(struct ahc_softc *, int);
 void			 ahc_set_name(struct ahc_softc *, char *);
 void			 ahc_alloc_scbs(struct ahc_softc *ahc);
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_core.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_core.c	2005-06-28 14:28:01.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_core.c	2005-06-28 14:42:42.000000000 +0200
@@ -52,9 +52,6 @@
 #include <dev/aic7xxx/aicasm/aicasm_insformat.h>
 #endif
 
-/****************************** Softc Data ************************************/
-struct ahc_softc_tailq ahc_tailq = TAILQ_HEAD_INITIALIZER(ahc_tailq);
-
 /***************************** Lookup Tables **********************************/
 char *ahc_chip_names[] =
 {
@@ -3879,25 +3876,6 @@
 }
 
 void
-ahc_softc_insert(struct ahc_softc *ahc)
-{
-	struct ahc_softc *list_ahc;
-
-	/*
-	 * Insertion sort into our list of softcs.
-	 */
-	list_ahc = TAILQ_FIRST(&ahc_tailq);
-	while (list_ahc != NULL
-	    && ahc_softc_comp(ahc, list_ahc) <= 0)
-		list_ahc = TAILQ_NEXT(list_ahc, links);
-	if (list_ahc != NULL)
-		TAILQ_INSERT_BEFORE(list_ahc, ahc, links);
-	else
-		TAILQ_INSERT_TAIL(&ahc_tailq, ahc, links);
-	ahc->init_level++;
-}
-
-void
 ahc_set_unit(struct ahc_softc *ahc, int unit)
 {
 	ahc->unit = unit;
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-06-28 14:31:59.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-06-28 14:47:32.000000000 +0200
@@ -136,10 +136,6 @@
 #include <linux/blkdev.h>		/* For block_size() */
 #include <linux/delay.h>	/* For ssleep/msleep */
 
-/*
- * Lock protecting manipulation of the ahc softc list.
- */
-spinlock_t ahc_list_spinlock;
 
 /*
  * Set this to the delay in seconds after SCSI bus reset.
@@ -292,25 +288,6 @@
 static uint32_t aic7xxx_no_reset;
 
 /*
- * Certain PCI motherboards will scan PCI devices from highest to lowest,
- * others scan from lowest to highest, and they tend to do all kinds of
- * strange things when they come into contact with PCI bridge chips.  The
- * net result of all this is that the PCI card that is actually used to boot
- * the machine is very hard to detect.  Most motherboards go from lowest
- * PCI slot number to highest, and the first SCSI controller found is the
- * one you boot from.  The only exceptions to this are when a controller
- * has its BIOS disabled.  So, we by default sort all of our SCSI controllers
- * from lowest PCI slot number to highest PCI slot number.  We also force
- * all controllers with their BIOS disabled to the end of the list.  This
- * works on *almost* all computers.  Where it doesn't work, we have this
- * option.  Setting this option to non-0 will reverse the order of the sort
- * to highest first, then lowest, but will still leave cards with their BIOS
- * disabled at the very end.  That should fix everyone up unless there are
- * really strange cirumstances.
- */
-static uint32_t aic7xxx_reverse_scan;
-
-/*
  * Should we force EXTENDED translation on a controller.
  *     0 == Use whatever is in the SEEPROM or default to off
  *     1 == Use whatever is in the SEEPROM or default to on
@@ -416,7 +393,9 @@
 static void ahc_linux_setup_tag_info_global(char *p);
 static aic_option_callback_t ahc_linux_setup_tag_info;
 static int  aic7xxx_setup(char *s);
-static int  ahc_linux_next_unit(void);
+
+static int ahc_linux_unit;
+
 
 /********************************* Inlines ************************************/
 static __inline void ahc_linux_unmap_scb(struct ahc_softc*, struct scb*);
@@ -911,99 +890,6 @@
 	return (0);
 }
 
-/********************* Platform Dependent Functions ***************************/
-/*
- * Compare "left hand" softc with "right hand" softc, returning:
- * < 0 - lahc has a lower priority than rahc
- *   0 - Softcs are equal
- * > 0 - lahc has a higher priority than rahc
- */
-int
-ahc_softc_comp(struct ahc_softc *lahc, struct ahc_softc *rahc)
-{
-	int	value;
-	int	rvalue;
-	int	lvalue;
-
-	/*
-	 * Under Linux, cards are ordered as follows:
-	 *	1) VLB/EISA BIOS enabled devices sorted by BIOS address.
-	 *	2) PCI devices with BIOS enabled sorted by bus/slot/func.
-	 *	3) All remaining VLB/EISA devices sorted by ioport.
-	 *	4) All remaining PCI devices sorted by bus/slot/func.
-	 */
-	value = (lahc->flags & AHC_BIOS_ENABLED)
-	      - (rahc->flags & AHC_BIOS_ENABLED);
-	if (value != 0)
-		/* Controllers with BIOS enabled have a *higher* priority */
-		return (value);
-
-	/*
-	 * Same BIOS setting, now sort based on bus type.
-	 * EISA and VL controllers sort together.  EISA/VL
-	 * have higher priority than PCI.
-	 */
-	rvalue = (rahc->chip & AHC_BUS_MASK);
- 	if (rvalue == AHC_VL)
-		rvalue = AHC_EISA;
-	lvalue = (lahc->chip & AHC_BUS_MASK);
- 	if (lvalue == AHC_VL)
-		lvalue = AHC_EISA;
-	value = rvalue - lvalue;
-	if (value != 0)
-		return (value);
-
-	/* Still equal.  Sort by BIOS address, ioport, or bus/slot/func. */
-	switch (rvalue) {
-#ifdef CONFIG_PCI
-	case AHC_PCI:
-	{
-		char primary_channel;
-
-		if (aic7xxx_reverse_scan != 0)
-			value = ahc_get_pci_bus(lahc->dev_softc)
-			      - ahc_get_pci_bus(rahc->dev_softc);
-		else
-			value = ahc_get_pci_bus(rahc->dev_softc)
-			      - ahc_get_pci_bus(lahc->dev_softc);
-		if (value != 0)
-			break;
-		if (aic7xxx_reverse_scan != 0)
-			value = ahc_get_pci_slot(lahc->dev_softc)
-			      - ahc_get_pci_slot(rahc->dev_softc);
-		else
-			value = ahc_get_pci_slot(rahc->dev_softc)
-			      - ahc_get_pci_slot(lahc->dev_softc);
-		if (value != 0)
-			break;
-		/*
-		 * On multi-function devices, the user can choose
-		 * to have function 1 probed before function 0.
-		 * Give whichever channel is the primary channel
-		 * the highest priority.
-		 */
-		primary_channel = (lahc->flags & AHC_PRIMARY_CHANNEL) + 'A';
-		value = -1;
-		if (lahc->channel == primary_channel)
-			value = 1;
-		break;
-	}
-#endif
-	case AHC_EISA:
-		if ((rahc->flags & AHC_BIOS_ENABLED) != 0) {
-			value = rahc->platform_data->bios_address
-			      - lahc->platform_data->bios_address; 
-		} else {
-			value = rahc->bsh.ioport
-			      - lahc->bsh.ioport; 
-		}
-		break;
-	default:
-		panic("ahc_softc_sort: invalid bus type");
-	}
-	return (value);
-}
-
 static void
 ahc_linux_setup_tag_info_global(char *p)
 {
@@ -1055,7 +941,6 @@
 #ifdef AHC_DEBUG
 		{ "debug", &ahc_debug },
 #endif
-		{ "reverse_scan", &aic7xxx_reverse_scan },
 		{ "periodic_otag", &aic7xxx_periodic_otag },
 		{ "pci_parity", &aic7xxx_pci_parity },
 		{ "seltime", &aic7xxx_seltime },
@@ -1130,7 +1015,7 @@
 	host->max_lun = AHC_NUM_LUNS;
 	host->max_channel = (ahc->features & AHC_TWIN) ? 1 : 0;
 	host->sg_tablesize = AHC_NSEG;
-	ahc_set_unit(ahc, ahc_linux_next_unit());
+	ahc_set_unit(ahc, ahc_linux_unit++);
 	sprintf(buf, "scsi%d", host->host_no);
 	new_name = malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
 	if (new_name != NULL) {
@@ -1159,29 +1044,6 @@
 }
 
 /*
- * Find the smallest available unit number to use
- * for a new device.  We don't just use a static
- * count to handle the "repeated hot-(un)plug"
- * scenario.
- */
-static int
-ahc_linux_next_unit(void)
-{
-	struct ahc_softc *ahc;
-	int unit;
-
-	unit = 0;
-retry:
-	TAILQ_FOREACH(ahc, &ahc_tailq, links) {
-		if (ahc->unit == unit) {
-			unit++;
-			goto retry;
-		}
-	}
-	return (unit);
-}
-
-/*
  * Place the SCSI bus into a known state by either resetting it,
  * or forcing transfer negotiations on the next command to any
  * target.
@@ -2677,12 +2539,6 @@
 	scsi_transport_reserve_device(ahc_linux_transport_template,
 				      sizeof(struct ahc_linux_device));
 
-	/*
-	 * Initialize our softc list lock prior to
-	 * probing for any adapters.
-	 */
-	ahc_list_lockinit();
-
 	ahc_linux_pci_init();
 	ahc_linux_eisa_init();
 	return 0;
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-06-28 14:29:42.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-06-28 14:47:45.000000000 +0200
@@ -509,15 +509,6 @@
 
 /******************************** Locking *************************************/
 /* Lock protecting internal data structures */
-static __inline void ahc_lockinit(struct ahc_softc *);
-static __inline void ahc_lock(struct ahc_softc *, unsigned long *flags);
-static __inline void ahc_unlock(struct ahc_softc *, unsigned long *flags);
-
-/* Lock held during ahc_list manipulation and ahc softc frees */
-extern spinlock_t ahc_list_spinlock;
-static __inline void ahc_list_lockinit(void);
-static __inline void ahc_list_lock(unsigned long *flags);
-static __inline void ahc_list_unlock(unsigned long *flags);
 
 static __inline void
 ahc_lockinit(struct ahc_softc *ahc)
@@ -537,24 +528,6 @@
 	spin_unlock_irqrestore(&ahc->platform_data->spin_lock, *flags);
 }
 
-static __inline void
-ahc_list_lockinit(void)
-{
-	spin_lock_init(&ahc_list_spinlock);
-}
-
-static __inline void
-ahc_list_lock(unsigned long *flags)
-{
-	spin_lock_irqsave(&ahc_list_spinlock, *flags);
-}
-
-static __inline void
-ahc_list_unlock(unsigned long *flags)
-{
-	spin_unlock_irqrestore(&ahc_list_spinlock, *flags);
-}
-
 /******************************* PCI Definitions ******************************/
 /*
  * PCIM_xxx: mask to locate subfield in register
@@ -891,7 +864,6 @@
 irqreturn_t
 	ahc_linux_isr(int irq, void *dev_id, struct pt_regs * regs);
 void	ahc_platform_flushwork(struct ahc_softc *ahc);
-int	ahc_softc_comp(struct ahc_softc *, struct ahc_softc *);
 void	ahc_done(struct ahc_softc*, struct scb*);
 void	ahc_send_async(struct ahc_softc *, char channel,
 		       u_int target, u_int lun, ac_code, void *);
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2005-06-28 14:29:29.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2005-06-28 14:36:21.000000000 +0200
@@ -143,10 +143,6 @@
 	struct ahc_softc *ahc = pci_get_drvdata(pdev);
 	u_long s;
 
-	ahc_list_lock(&s);
-	TAILQ_REMOVE(&ahc_tailq, ahc, links);
-	ahc_list_unlock(&s);
-
 	ahc_lock(ahc, &s);
 	ahc_intr_enable(ahc, FALSE);
 	ahc_unlock(ahc, &s);
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_pci.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_pci.c	2005-05-31 17:29:48.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_pci.c	2005-06-28 14:44:44.000000000 +0200
@@ -704,7 +704,6 @@
 int
 ahc_pci_config(struct ahc_softc *ahc, struct ahc_pci_identity *entry)
 {
-	u_long	 l;
 	u_int	 command;
 	u_int	 our_id;
 	u_int	 sxfrctl1;
@@ -964,12 +963,7 @@
 	if (error != 0)
 		return (error);
 
-	ahc_list_lock(&l);
-	/*
-	 * Link this softc in with all other ahc instances.
-	 */
-	ahc_softc_insert(ahc);
-	ahc_list_unlock(&l);
+	ahc->init_level++;
 	return (0);
 }
 
