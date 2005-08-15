From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic79xx: sane pci probing
Date: Mon, 15 Aug 2005 13:28:46 +0200
Message-ID: <20050815112846.GB17458@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:22478 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932670AbVHOL2t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 07:28:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

remove ahd_tailq and do sane pci probing.  ported over from aic7xxx.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic79xx.h	2005-08-13 14:50:08.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx.h	2005-08-13 14:52:12.000000000 +0200
@@ -1247,9 +1247,6 @@
 	uint16_t		  user_tagenable;/* Tagged Queuing allowed */
 };
 
-TAILQ_HEAD(ahd_softc_tailq, ahd_softc);
-extern struct ahd_softc_tailq ahd_tailq;
-
 /*************************** IO Cell Configuration ****************************/
 #define	AHD_PRECOMP_SLEW_INDEX						\
     (AHD_ANNEXCOL_PRECOMP_SLEW - AHD_ANNEXCOL_PER_DEV0)
@@ -1374,8 +1371,6 @@
 void			 ahd_pause_and_flushwork(struct ahd_softc *ahd);
 int			 ahd_suspend(struct ahd_softc *ahd); 
 int			 ahd_resume(struct ahd_softc *ahd);
-void			 ahd_softc_insert(struct ahd_softc *);
-struct ahd_softc	*ahd_find_softc(struct ahd_softc *ahd);
 void			 ahd_set_unit(struct ahd_softc *, int);
 void			 ahd_set_name(struct ahd_softc *, char *);
 struct scb		*ahd_get_scb(struct ahd_softc *ahd, u_int col_idx);
@@ -1524,7 +1519,6 @@
 void			ahd_print_devinfo(struct ahd_softc *ahd,
 					  struct ahd_devinfo *devinfo);
 void			ahd_dump_sglist(struct scb *scb);
-void			ahd_dump_all_cards_state(void);
 void			ahd_dump_card_state(struct ahd_softc *ahd);
 int			ahd_print_register(ahd_reg_parse_entry_t *table,
 					   u_int num_entries,
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_core.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic79xx_core.c	2005-08-13 14:50:08.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_core.c	2005-08-13 14:52:12.000000000 +0200
@@ -52,8 +52,6 @@
 #include <dev/aic7xxx/aicasm/aicasm_insformat.h>
 #endif
 
-/******************************** Globals *************************************/
-struct ahd_softc_tailq ahd_tailq = TAILQ_HEAD_INITIALIZER(ahd_tailq);
 
 /***************************** Lookup Tables **********************************/
 char *ahd_chip_names[] =
@@ -5180,74 +5178,6 @@
 }
 
 void
-ahd_softc_insert(struct ahd_softc *ahd)
-{
-	struct ahd_softc *list_ahd;
-
-#if AHD_PCI_CONFIG > 0
-	/*
-	 * Second Function PCI devices need to inherit some
-	 * settings from function 0.
-	 */
-	if ((ahd->features & AHD_MULTI_FUNC) != 0) {
-		TAILQ_FOREACH(list_ahd, &ahd_tailq, links) {
-			ahd_dev_softc_t list_pci;
-			ahd_dev_softc_t pci;
-
-			list_pci = list_ahd->dev_softc;
-			pci = ahd->dev_softc;
-			if (ahd_get_pci_slot(list_pci) == ahd_get_pci_slot(pci)
-			 && ahd_get_pci_bus(list_pci) == ahd_get_pci_bus(pci)) {
-				struct ahd_softc *master;
-				struct ahd_softc *slave;
-
-				if (ahd_get_pci_function(list_pci) == 0) {
-					master = list_ahd;
-					slave = ahd;
-				} else {
-					master = ahd;
-					slave = list_ahd;
-				}
-				slave->flags &= ~AHD_BIOS_ENABLED; 
-				slave->flags |=
-				    master->flags & AHD_BIOS_ENABLED;
-				break;
-			}
-		}
-	}
-#endif
-
-	/*
-	 * Insertion sort into our list of softcs.
-	 */
-	list_ahd = TAILQ_FIRST(&ahd_tailq);
-	while (list_ahd != NULL
-	    && ahd_softc_comp(ahd, list_ahd) <= 0)
-		list_ahd = TAILQ_NEXT(list_ahd, links);
-	if (list_ahd != NULL)
-		TAILQ_INSERT_BEFORE(list_ahd, ahd, links);
-	else
-		TAILQ_INSERT_TAIL(&ahd_tailq, ahd, links);
-	ahd->init_level++;
-}
-
-/*
- * Verify that the passed in softc pointer is for a
- * controller that is still configured.
- */
-struct ahd_softc *
-ahd_find_softc(struct ahd_softc *ahd)
-{
-	struct ahd_softc *list_ahd;
-
-	TAILQ_FOREACH(list_ahd, &ahd_tailq, links) {
-		if (list_ahd == ahd)
-			return (ahd);
-	}
-	return (NULL);
-}
-
-void
 ahd_set_unit(struct ahd_softc *ahd, int unit)
 {
 	ahd->unit = unit;
@@ -7902,18 +7832,10 @@
 static void
 ahd_reset_poll(void *arg)
 {
-	struct	ahd_softc *ahd;
+	struct	ahd_softc *ahd = arg;
 	u_int	scsiseq1;
-	u_long	l;
 	u_long	s;
 	
-	ahd_list_lock(&l);
-	ahd = ahd_find_softc((struct ahd_softc *)arg);
-	if (ahd == NULL) {
-		printf("ahd_reset_poll: Instance %p no longer exists\n", arg);
-		ahd_list_unlock(&l);
-		return;
-	}
 	ahd_lock(ahd, &s);
 	ahd_pause(ahd);
 	ahd_update_modes(ahd);
@@ -7924,7 +7846,6 @@
 				ahd_reset_poll, ahd);
 		ahd_unpause(ahd);
 		ahd_unlock(ahd, &s);
-		ahd_list_unlock(&l);
 		return;
 	}
 
@@ -7936,25 +7857,16 @@
 	ahd->flags &= ~AHD_RESET_POLL_ACTIVE;
 	ahd_unlock(ahd, &s);
 	ahd_release_simq(ahd);
-	ahd_list_unlock(&l);
 }
 
 /**************************** Statistics Processing ***************************/
 static void
 ahd_stat_timer(void *arg)
 {
-	struct	ahd_softc *ahd;
-	u_long	l;
+	struct	ahd_softc *ahd = arg;
 	u_long	s;
 	int	enint_coal;
 	
-	ahd_list_lock(&l);
-	ahd = ahd_find_softc((struct ahd_softc *)arg);
-	if (ahd == NULL) {
-		printf("ahd_stat_timer: Instance %p no longer exists\n", arg);
-		ahd_list_unlock(&l);
-		return;
-	}
 	ahd_lock(ahd, &s);
 
 	enint_coal = ahd->hs_mailbox & ENINT_COALESCE;
@@ -7981,7 +7893,6 @@
 	ahd_timer_reset(&ahd->stat_timer, AHD_STAT_UPDATE_US,
 			ahd_stat_timer, ahd);
 	ahd_unlock(ahd, &s);
-	ahd_list_unlock(&l);
 }
 
 /****************************** Status Processing *****************************/
@@ -8745,16 +8656,6 @@
 	return (last_probe);
 }
 
-void
-ahd_dump_all_cards_state(void)
-{
-	struct ahd_softc *list_ahd;
-
-	TAILQ_FOREACH(list_ahd, &ahd_tailq, links) {
-		ahd_dump_card_state(list_ahd);
-	}
-}
-
 int
 ahd_print_register(ahd_reg_parse_entry_t *table, u_int num_entries,
 		   const char *name, u_int address, u_int value,
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-08-13 14:50:08.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-08-13 14:52:12.000000000 +0200
@@ -60,11 +60,6 @@
 #include <linux/delay.h>	/* For ssleep/msleep */
 
 /*
- * Lock protecting manipulation of the ahd softc list.
- */
-spinlock_t ahd_list_spinlock;
-
-/*
  * Bucket size for counting good commands in between bad ones.
  */
 #define AHD_LINUX_ERR_THRESH	1000
@@ -303,13 +298,6 @@
 uint32_t aic79xx_allow_memio = ~0;
 
 /*
- * aic79xx_detect() has been run, so register all device arrivals
- * immediately with the system rather than deferring to the sorted
- * attachment performed by aic79xx_detect().
- */
-int aic79xx_detect_complete;
-
-/*
  * So that we can set how long each device is given as a selection timeout.
  * The table of values goes like this:
  *   0 - 256ms
@@ -387,7 +375,9 @@
 static aic_option_callback_t ahd_linux_setup_tag_info;
 static aic_option_callback_t ahd_linux_setup_iocell_info;
 static int  aic79xx_setup(char *c);
-static int  ahd_linux_next_unit(void);
+
+static int ahd_linux_unit;
+
 
 /****************************** Inlines ***************************************/
 static __inline void ahd_linux_unmap_scb(struct ahd_softc*, struct scb*);
@@ -418,50 +408,6 @@
 	((((cmd)->device->id << TID_SHIFT) & TID) | (ahd)->our_id)
 
 /*
- * Try to detect an Adaptec 79XX controller.
- */
-static int
-ahd_linux_detect(struct scsi_host_template *template)
-{
-	struct	ahd_softc *ahd;
-	int     found;
-	int	error = 0;
-
-	/*
-	 * If we've been passed any parameters, process them now.
-	 */
-	if (aic79xx)
-		aic79xx_setup(aic79xx);
-
-	template->proc_name = "aic79xx";
-
-	/*
-	 * Initialize our softc list lock prior to
-	 * probing for any adapters.
-	 */
-	ahd_list_lockinit();
-
-#ifdef CONFIG_PCI
-	error = ahd_linux_pci_init();
-	if (error)
-		return error;
-#endif
-
-	/*
-	 * Register with the SCSI layer all
-	 * controllers we've found.
-	 */
-	found = 0;
-	TAILQ_FOREACH(ahd, &ahd_tailq, links) {
-
-		if (ahd_linux_register_host(ahd, template) == 0)
-			found++;
-	}
-	aic79xx_detect_complete++;
-	return found;
-}
-
-/*
  * Return a string describing the driver.
  */
 static const char *
@@ -760,6 +706,7 @@
 struct scsi_host_template aic79xx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "aic79xx",
+	.proc_name		= "aic79xx",
 	.proc_info		= ahd_linux_proc_info,
 	.info			= ahd_linux_info,
 	.queuecommand		= ahd_linux_queue,
@@ -1072,7 +1019,7 @@
 	host->max_lun = AHD_NUM_LUNS;
 	host->max_channel = 0;
 	host->sg_tablesize = AHD_NSEG;
-	ahd_set_unit(ahd, ahd_linux_next_unit());
+	ahd_set_unit(ahd, ahd_linux_unit++);
 	sprintf(buf, "scsi%d", host->host_no);
 	new_name = malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
 	if (new_name != NULL) {
@@ -1101,29 +1048,6 @@
 }
 
 /*
- * Find the smallest available unit number to use
- * for a new device.  We don't just use a static
- * count to handle the "repeated hot-(un)plug"
- * scenario.
- */
-static int
-ahd_linux_next_unit(void)
-{
-	struct ahd_softc *ahd;
-	int unit;
-
-	unit = 0;
-retry:
-	TAILQ_FOREACH(ahd, &ahd_tailq, links) {
-		if (ahd->unit == unit) {
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
@@ -2755,23 +2679,31 @@
 	.show_hold_mcs	= 1,
 };
 
-
-
 static int __init
 ahd_linux_init(void)
 {
-	ahd_linux_transport_template = spi_attach_transport(&ahd_linux_transport_functions);
+	int	error = 0;
+
+	/*
+	 * If we've been passed any parameters, process them now.
+	 */
+	if (aic79xx)
+		aic79xx_setup(aic79xx);
+
+	ahd_linux_transport_template =
+		spi_attach_transport(&ahd_linux_transport_functions);
 	if (!ahd_linux_transport_template)
 		return -ENODEV;
+
 	scsi_transport_reserve_target(ahd_linux_transport_template,
 				      sizeof(struct ahd_linux_target));
 	scsi_transport_reserve_device(ahd_linux_transport_template,
 				      sizeof(struct ahd_linux_device));
-	if (ahd_linux_detect(&aic79xx_driver_template) > 0)
-		return 0;
-	spi_release_transport(ahd_linux_transport_template);
 
-	return -ENODEV;
+	error = ahd_linux_pci_init();
+	if (error)
+		spi_release_transport(ahd_linux_transport_template);
+	return error;
 }
 
 static void __exit
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2005-08-13 14:52:11.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2005-08-13 14:56:04.000000000 +0200
@@ -92,27 +92,31 @@
 static void
 ahd_linux_pci_dev_remove(struct pci_dev *pdev)
 {
-	struct ahd_softc *ahd;
-	u_long l;
+	struct ahd_softc *ahd = pci_get_drvdata(pdev);
+	u_long s;
 
-	/*
-	 * We should be able to just perform
-	 * the free directly, but check our
-	 * list for extra sanity.
-	 */
-	ahd_list_lock(&l);
-	ahd = ahd_find_softc((struct ahd_softc *)pci_get_drvdata(pdev));
-	if (ahd != NULL) {
-		u_long s;
-
-		TAILQ_REMOVE(&ahd_tailq, ahd, links);
-		ahd_list_unlock(&l);
-		ahd_lock(ahd, &s);
-		ahd_intr_enable(ahd, FALSE);
-		ahd_unlock(ahd, &s);
-		ahd_free(ahd);
-	} else
-		ahd_list_unlock(&l);
+	ahd_lock(ahd, &s);
+	ahd_intr_enable(ahd, FALSE);
+	ahd_unlock(ahd, &s);
+	ahd_free(ahd);
+}
+
+static void
+ahd_linux_pci_inherit_flags(struct ahd_softc *ahd)
+{
+	struct pci_dev *pdev = ahd->dev_softc, *master_pdev;
+	unsigned int master_devfn = PCI_DEVFN(PCI_SLOT(pdev->devfn), 0);
+
+	master_pdev = pci_get_slot(pdev->bus, master_devfn);
+	if (master_pdev) {
+		struct ahd_softc *master = pci_get_drvdata(master_pdev);
+		if (master) {
+			ahd->flags &= ~AHD_BIOS_ENABLED;
+			ahd->flags |= master->flags & AHD_BIOS_ENABLED;
+		} else
+			printk(KERN_ERR "aic79xx: no multichannel peer found!\n");
+		pci_dev_put(master_pdev);
+	}
 }
 
 static int
@@ -125,22 +129,6 @@
 	char		*name;
 	int		 error;
 
-	/*
-	 * Some BIOSen report the same device multiple times.
-	 */
-	TAILQ_FOREACH(ahd, &ahd_tailq, links) {
-		struct pci_dev *probed_pdev;
-
-		probed_pdev = ahd->dev_softc;
-		if (probed_pdev->bus->number == pdev->bus->number
-		 && probed_pdev->devfn == pdev->devfn)
-			break;
-	}
-	if (ahd != NULL) {
-		/* Skip duplicate. */
-		return (-ENODEV);
-	}
-
 	pci = pdev;
 	entry = ahd_find_pci_device(pci);
 	if (entry == NULL)
@@ -190,16 +178,17 @@
 		ahd_free(ahd);
 		return (-error);
 	}
+
+	/*
+	 * Second Function PCI devices need to inherit some
+	 * * settings from function 0.
+	 */
+	if ((ahd->features & AHD_MULTI_FUNC) && PCI_FUNC(pdev->devfn) != 0)
+		ahd_linux_pci_inherit_flags(ahd);
+
 	pci_set_drvdata(pdev, ahd);
-	if (aic79xx_detect_complete) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-		ahd_linux_register_host(ahd, &aic79xx_driver_template);
-#else
-		printf("aic79xx: ignoring PCI device found after "
-		       "initialization\n");
-		return (-ENODEV);
-#endif
-	}
+
+	ahd_linux_register_host(ahd, &aic79xx_driver_template);
 	return (0);
 }
 
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_proc.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic79xx_proc.c	2005-08-13 14:51:34.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_proc.c	2005-08-13 14:52:32.000000000 +0200
@@ -285,21 +285,13 @@
 ahd_linux_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 		    off_t offset, int length, int inout)
 {
-	struct	ahd_softc *ahd;
+	struct	ahd_softc *ahd = *(struct ahd_softc **)shost->hostdata;
 	struct	info_str info;
 	char	ahd_info[256];
-	u_long	l;
 	u_int	max_targ;
 	u_int	i;
 	int	retval;
 
-	retval = -EINVAL;
-	ahd_list_lock(&l);
-	ahd = ahd_find_softc(*(struct ahd_softc **)shost->hostdata);
-
-	if (ahd == NULL)
-		goto done;
-
 	 /* Has data been written to the file? */ 
 	if (inout == TRUE) {
 		retval = ahd_proc_write_seeprom(ahd, buffer, length);
@@ -349,6 +341,5 @@
 	}
 	retval = info.pos > info.offset ? info.pos - info.offset : 0;
 done:
-	ahd_list_unlock(&l);
 	return (retval);
 }
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm.h	2005-08-13 14:52:11.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm.h	2005-08-13 14:52:12.000000000 +0200
@@ -120,7 +120,6 @@
 
 /************************* Configuration Data *********************************/
 extern uint32_t aic79xx_allow_memio;
-extern int aic79xx_detect_complete;
 extern struct scsi_host_template aic79xx_driver_template;
 
 /***************************** Bus Space/DMA **********************************/
@@ -532,17 +531,6 @@
 			     struct ahd_transinfo *tinfo);
 
 /******************************** Locking *************************************/
-/* Lock protecting internal data structures */
-static __inline void ahd_lockinit(struct ahd_softc *);
-static __inline void ahd_lock(struct ahd_softc *, unsigned long *flags);
-static __inline void ahd_unlock(struct ahd_softc *, unsigned long *flags);
-
-/* Lock held during ahd_list manipulation and ahd softc frees */
-extern spinlock_t ahd_list_spinlock;
-static __inline void ahd_list_lockinit(void);
-static __inline void ahd_list_lock(unsigned long *flags);
-static __inline void ahd_list_unlock(unsigned long *flags);
-
 static __inline void
 ahd_lockinit(struct ahd_softc *ahd)
 {
@@ -561,24 +549,6 @@
 	spin_unlock_irqrestore(&ahd->platform_data->spin_lock, *flags);
 }
 
-static __inline void
-ahd_list_lockinit(void)
-{
-	spin_lock_init(&ahd_list_spinlock);
-}
-
-static __inline void
-ahd_list_lock(unsigned long *flags)
-{
-	spin_lock_irqsave(&ahd_list_spinlock, *flags);
-}
-
-static __inline void
-ahd_list_unlock(unsigned long *flags)
-{
-	spin_unlock_irqrestore(&ahd_list_spinlock, *flags);
-}
-
 /******************************* PCI Definitions ******************************/
 /*
  * PCIM_xxx: mask to locate subfield in register
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_pci.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic79xx_pci.c	2005-08-13 14:50:08.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_pci.c	2005-08-13 14:53:59.000000000 +0200
@@ -283,7 +283,6 @@
 ahd_pci_config(struct ahd_softc *ahd, struct ahd_pci_identity *entry)
 {
 	struct scb_data *shared_scb_data;
-	u_long		 l;
 	u_int		 command;
 	uint32_t	 devconfig;
 	uint16_t	 subvendor; 
@@ -373,16 +372,9 @@
 	 * Allow interrupts now that we are completely setup.
 	 */
 	error = ahd_pci_map_int(ahd);
-	if (error != 0)
-		return (error);
-
-	ahd_list_lock(&l);
-	/*
-	 * Link this softc in with all other ahd instances.
-	 */
-	ahd_softc_insert(ahd);
-	ahd_list_unlock(&l);
-	return (0);
+	if (!error)
+		ahd->init_level++;
+	return error;
 }
 
 /*
