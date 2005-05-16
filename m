From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic7xxx: remove Linux 2.4 ifdefs
Date: Mon, 16 May 2005 20:52:06 +0200
Message-ID: <20050516185206.GB16811@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:48012 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261808AbVEPSwK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 14:52:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

There's not much sense in sharing code anymore now that aic7xxx uses
various transport class facilities.


Index: linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2005-04-30 10:17:16.000000000 +0200
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2005-05-16 19:48:24.000000000 +0200
@@ -236,15 +236,8 @@
 		return (-error);
 	}
 	pci_set_drvdata(pdev, ahc);
-	if (aic7xxx_detect_complete) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	if (aic7xxx_detect_complete)
 		ahc_linux_register_host(ahc, &aic7xxx_driver_template);
-#else
-		printf("aic7xxx: ignoring PCI device found after "
-		       "initialization\n");
-		return (-ENODEV);
-#endif
-	}
 	return (0);
 }
 
Index: linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-05-16 19:25:37.000000000 +0200
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-05-16 20:00:29.000000000 +0200
@@ -134,11 +134,6 @@
 #include "aiclib.c"
 
 #include <linux/init.h>		/* __setup */
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-#include "sd.h"			/* For geometry detection */
-#endif
-
 #include <linux/mm.h>		/* For fetching system memory size */
 #include <linux/blkdev.h>		/* For block_size() */
 #include <linux/delay.h>	/* For ssleep/msleep */
@@ -148,11 +143,6 @@
  */
 spinlock_t ahc_list_spinlock;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-/* For dynamic sglist size calculation. */
-u_int ahc_linux_nseg;
-#endif
-
 /*
  * Set this to the delay in seconds after SCSI bus reset.
  * Note, we honor this only for the initial bus reset.
@@ -443,7 +433,6 @@
 static void ahc_linux_dev_timed_unfreeze(u_long arg);
 static int  ahc_linux_queue_recovery_cmd(Scsi_Cmnd *cmd, scb_flag flag);
 static void ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc);
-static void ahc_linux_size_nseg(void);
 static void ahc_linux_thread_run_complete_queue(struct ahc_softc *ahc);
 static u_int ahc_linux_user_tagdepth(struct ahc_softc *ahc,
 				     struct ahc_devinfo *devinfo);
@@ -519,11 +508,9 @@
 ahc_linux_run_complete_queue(struct ahc_softc *ahc)
 {
 	struct	ahc_cmd *acmd;
-	u_long	done_flags;
 	int	with_errors;
 
 	with_errors = 0;
-	ahc_done_lock(ahc, &done_flags);
 	while ((acmd = TAILQ_FIRST(&ahc->platform_data->completeq)) != NULL) {
 		Scsi_Cmnd *cmd;
 
@@ -549,7 +536,6 @@
 
 		cmd->scsi_done(cmd);
 	}
-	ahc_done_unlock(ahc, &done_flags);
 	return (acmd);
 }
 
@@ -600,7 +586,6 @@
 static int	   ahc_linux_detect(Scsi_Host_Template *);
 static int	   ahc_linux_queue(Scsi_Cmnd *, void (*)(Scsi_Cmnd *));
 static const char *ahc_linux_info(struct Scsi_Host *);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 static int	   ahc_linux_slave_alloc(Scsi_Device *);
 static int	   ahc_linux_slave_configure(Scsi_Device *);
 static void	   ahc_linux_slave_destroy(Scsi_Device *);
@@ -609,80 +594,11 @@
 				       struct block_device*,
 				       sector_t, int[]);
 #endif
-#else
-static int	   ahc_linux_release(struct Scsi_Host *);
-static void	   ahc_linux_select_queue_depth(struct Scsi_Host *host,
-						Scsi_Device *scsi_devs);
-#if defined(__i386__)
-static int	   ahc_linux_biosparam(Disk *, kdev_t, int[]);
-#endif
-#endif
 static int	   ahc_linux_bus_reset(Scsi_Cmnd *);
 static int	   ahc_linux_dev_reset(Scsi_Cmnd *);
 static int	   ahc_linux_abort(Scsi_Cmnd *);
 
 /*
- * Calculate a safe value for AHC_NSEG (as expressed through ahc_linux_nseg).
- *
- * In pre-2.5.X...
- * The midlayer allocates an S/G array dynamically when a command is issued
- * using SCSI malloc.  This array, which is in an OS dependent format that
- * must later be copied to our private S/G list, is sized to house just the
- * number of segments needed for the current transfer.  Since the code that
- * sizes the SCSI malloc pool does not take into consideration fragmentation
- * of the pool, executing transactions numbering just a fraction of our
- * concurrent transaction limit with list lengths aproaching AHC_NSEG will
- * quickly depleat the SCSI malloc pool of usable space.  Unfortunately, the
- * mid-layer does not properly handle this scsi malloc failures for the S/G
- * array and the result can be a lockup of the I/O subsystem.  We try to size
- * our S/G list so that it satisfies our drivers allocation requirements in
- * addition to avoiding fragmentation of the SCSI malloc pool.
- */
-static void
-ahc_linux_size_nseg(void)
-{
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	u_int cur_size;
-	u_int best_size;
-
-	/*
-	 * The SCSI allocator rounds to the nearest 512 bytes
-	 * an cannot allocate across a page boundary.  Our algorithm
-	 * is to start at 1K of scsi malloc space per-command and
-	 * loop through all factors of the PAGE_SIZE and pick the best.
-	 */
-	best_size = 0;
-	for (cur_size = 1024; cur_size <= PAGE_SIZE; cur_size *= 2) {
-		u_int nseg;
-
-		nseg = cur_size / sizeof(struct scatterlist);
-		if (nseg < AHC_LINUX_MIN_NSEG)
-			continue;
-
-		if (best_size == 0) {
-			best_size = cur_size;
-			ahc_linux_nseg = nseg;
-		} else {
-			u_int best_rem;
-			u_int cur_rem;
-
-			/*
-			 * Compare the traits of the current "best_size"
-			 * with the current size to determine if the
-			 * current size is a better size.
-			 */
-			best_rem = best_size % sizeof(struct scatterlist);
-			cur_rem = cur_size % sizeof(struct scatterlist);
-			if (cur_rem < best_rem) {
-				best_size = cur_size;
-				ahc_linux_nseg = nseg;
-			}
-		}
-	}
-#endif
-}
-
-/*
  * Try to detect an Adaptec 7XXX controller.
  */
 static int
@@ -691,14 +607,6 @@
 	struct	ahc_softc *ahc;
 	int     found = 0;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	/*
-	 * It is a bug that the upper layer takes
-	 * this lock just prior to calling us.
-	 */
-	spin_unlock_irq(&io_request_lock);
-#endif
-
 	/*
 	 * Sanity checking of Linux SCSI data structures so
 	 * that some of our hacks^H^H^H^H^Hassumptions aren't
@@ -710,7 +618,6 @@
 		printf("ahc_linux_detect: Unable to attach\n");
 		return (0);
 	}
-	ahc_linux_size_nseg();
 	/*
 	 * If we've been passed any parameters, process them now.
 	 */
@@ -739,48 +646,11 @@
 			found++;
 	}
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	spin_lock_irq(&io_request_lock);
-#endif
 	aic7xxx_detect_complete++;
 
 	return (found);
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-/*
- * Free the passed in Scsi_Host memory structures prior to unloading the
- * module.
- */
-int
-ahc_linux_release(struct Scsi_Host * host)
-{
-	struct ahc_softc *ahc;
-	u_long l;
-
-	ahc_list_lock(&l);
-	if (host != NULL) {
-
-		/*
-		 * We should be able to just perform
-		 * the free directly, but check our
-		 * list for extra sanity.
-		 */
-		ahc = ahc_find_softc(*(struct ahc_softc **)host->hostdata);
-		if (ahc != NULL) {
-			u_long s;
-
-			ahc_lock(ahc, &s);
-			ahc_intr_enable(ahc, FALSE);
-			ahc_unlock(ahc, &s);
-			ahc_free(ahc);
-		}
-	}
-	ahc_list_unlock(&l);
-	return (0);
-}
-#endif
-
 /*
  * Return a string describing the driver.
  */
@@ -843,7 +713,6 @@
 	return ahc_linux_run_command(ahc, dev, cmd);
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 static int
 ahc_linux_slave_alloc(Scsi_Device *device)
 {
@@ -860,12 +729,10 @@
 {
 	struct	ahc_softc *ahc;
 	struct	ahc_linux_device *dev;
-	u_long	flags;
 
 	ahc = *((struct ahc_softc **)device->host->hostdata);
 	if (bootverbose)
 		printf("%s: Slave Configure %d\n", ahc_name(ahc), device->id);
-	ahc_midlayer_entrypoint_lock(ahc, &flags);
 	/*
 	 * Since Linux has attached to the device, configure
 	 * it so we don't free and allocate the device
@@ -879,7 +746,6 @@
 		dev->scsi_device = device;
 		ahc_linux_device_queue_depth(ahc, dev);
 	}
-	ahc_midlayer_entrypoint_unlock(ahc, &flags);
 
 	/* Initial Domain Validation */
 	if (!spi_initial_dv(device->sdev_target))
@@ -893,12 +759,10 @@
 {
 	struct	ahc_softc *ahc;
 	struct	ahc_linux_device *dev;
-	u_long	flags;
 
 	ahc = *((struct ahc_softc **)device->host->hostdata);
 	if (bootverbose)
 		printf("%s: Slave Destroy %d\n", ahc_name(ahc), device->id);
-	ahc_midlayer_entrypoint_lock(ahc, &flags);
 	dev = ahc_linux_get_device(ahc, device->channel,
 				   device->id, device->lun,
 					   /*alloc*/FALSE);
@@ -916,93 +780,17 @@
 	 	 && (dev->flags & AHC_DEV_TIMER_ACTIVE) == 0)
 			ahc_linux_free_device(ahc, dev);
 	}
-	ahc_midlayer_entrypoint_unlock(ahc, &flags);
-}
-#else
-/*
- * Sets the queue depth for each SCSI device hanging
- * off the input host adapter.
- */
-static void
-ahc_linux_select_queue_depth(struct Scsi_Host *host, Scsi_Device *scsi_devs)
-{
-	Scsi_Device *device;
-	Scsi_Device *ldev;
-	struct	ahc_softc *ahc;
-	u_long	flags;
-
-	ahc = *((struct ahc_softc **)host->hostdata);
-	ahc_lock(ahc, &flags);
-	for (device = scsi_devs; device != NULL; device = device->next) {
-
-		/*
-		 * Watch out for duplicate devices.  This works around
-		 * some quirks in how the SCSI scanning code does its
-		 * device management.
-		 */
-		for (ldev = scsi_devs; ldev != device; ldev = ldev->next) {
-			if (ldev->host == device->host
-			 && ldev->channel == device->channel
-			 && ldev->id == device->id
-			 && ldev->lun == device->lun)
-				break;
-		}
-		/* Skip duplicate. */
-		if (ldev != device)
-			continue;
-
-		if (device->host == host) {
-			struct	 ahc_linux_device *dev;
-
-			/*
-			 * Since Linux has attached to the device, configure
-			 * it so we don't free and allocate the device
-			 * structure on every command.
-			 */
-			dev = ahc_linux_get_device(ahc, device->channel,
-						   device->id, device->lun,
-						   /*alloc*/TRUE);
-			if (dev != NULL) {
-				dev->flags &= ~AHC_DEV_UNCONFIGURED;
-				dev->scsi_device = device;
-				ahc_linux_device_queue_depth(ahc, dev);
-				device->queue_depth = dev->openings
-						    + dev->active;
-				if ((dev->flags & (AHC_DEV_Q_BASIC
-						| AHC_DEV_Q_TAGGED)) == 0) {
-					/*
-					 * We allow the OS to queue 2 untagged
-					 * transactions to us at any time even
-					 * though we can only execute them
-					 * serially on the controller/device.
-					 * This should remove some latency.
-					 */
-					device->queue_depth = 2;
-				}
-			}
-		}
-	}
-	ahc_unlock(ahc, &flags);
 }
-#endif
 
 #if defined(__i386__)
 /*
  * Return the disk geometry for the given SCSI device.
  */
 static int
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 ahc_linux_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 		    sector_t capacity, int geom[])
 {
 	uint8_t *bh;
-#else
-ahc_linux_biosparam(Disk *disk, kdev_t dev, int geom[])
-{
-	struct	scsi_device *sdev = disk->device;
-	u_long	capacity = disk->capacity;
-	struct	buffer_head *bh;
-#endif
 	int	 heads;
 	int	 sectors;
 	int	 cylinders;
@@ -1014,22 +802,11 @@
 	ahc = *((struct ahc_softc **)sdev->host->hostdata);
 	channel = sdev->channel;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	bh = scsi_bios_ptable(bdev);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,17)
-	bh = bread(MKDEV(MAJOR(dev), MINOR(dev) & ~0xf), 0, block_size(dev));
-#else
-	bh = bread(MKDEV(MAJOR(dev), MINOR(dev) & ~0xf), 0, 1024);
-#endif
-
 	if (bh) {
 		ret = scsi_partsize(bh, capacity,
 				    &geom[2], &geom[0], &geom[1]);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 		kfree(bh);
-#else
-		brelse(bh);
-#endif
 		if (ret != -1)
 			return (ret);
 	}
@@ -1090,15 +867,12 @@
 ahc_linux_bus_reset(Scsi_Cmnd *cmd)
 {
 	struct ahc_softc *ahc;
-	u_long s;
 	int    found;
 
 	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
-	ahc_midlayer_entrypoint_lock(ahc, &s);
 	found = ahc_reset_channel(ahc, cmd->device->channel + 'A',
 				  /*initiate reset*/TRUE);
 	ahc_linux_run_complete_queue(ahc);
-	ahc_midlayer_entrypoint_unlock(ahc, &s);
 
 	if (bootverbose)
 		printf("%s: SCSI bus reset delivered. "
@@ -1461,11 +1235,7 @@
 
 	*((struct ahc_softc **)host->hostdata) = ahc;
 	ahc_lock(ahc, &s);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	scsi_assign_lock(host, &ahc->platform_data->spin_lock);
-#elif AHC_SCSI_HAS_HOST_LOCK != 0
-	host->lock = &ahc->platform_data->spin_lock;
-#endif
 	ahc->platform_data->host = host;
 	host->can_queue = AHC_MAX_QUEUE;
 	host->cmd_per_lun = 2;
@@ -1484,19 +1254,14 @@
 		ahc_set_name(ahc, new_name);
 	}
 	host->unique_id = ahc->unit;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	scsi_set_pci_device(host, ahc->dev_softc);
-#endif
 	ahc_linux_initialize_scsi_bus(ahc);
 	ahc_intr_enable(ahc, TRUE);
 	ahc_unlock(ahc, &s);
 
 	host->transportt = ahc_linux_transport_template;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	scsi_add_host(host, (ahc->dev_softc ? &ahc->dev_softc->dev : NULL)); /* XXX handle failure */
 	scsi_scan_host(host);
-#endif
 	return (0);
 }
 
@@ -1619,7 +1384,6 @@
 	ahc->platform_data->irq = AHC_LINUX_NOIRQ;
 	ahc->platform_data->hw_dma_mask = 0xFFFFFFFF;
 	ahc_lockinit(ahc);
-	ahc_done_lockinit(ahc);
 	init_timer(&ahc->platform_data->completeq_timer);
 	ahc->platform_data->completeq_timer.data = (u_long)ahc;
 	ahc->platform_data->completeq_timer.function =
@@ -1643,9 +1407,7 @@
 	if (ahc->platform_data != NULL) {
 		del_timer_sync(&ahc->platform_data->completeq_timer);
 		if (ahc->platform_data->host != NULL) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 			scsi_remove_host(ahc->platform_data->host);
-#endif
 			scsi_host_put(ahc->platform_data->host);
 		}
 
@@ -1681,16 +1443,7 @@
 			release_mem_region(ahc->platform_data->mem_busaddr,
 					   0x1000);
 		}
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-		/*
-		 * In 2.4 we detach from the scsi midlayer before the PCI
-		 * layer invokes our remove callback.  No per-instance
-		 * detach is provided, so we must reach inside the PCI
-		 * subsystem's internals and detach our driver manually.
-		 */
-		if (ahc->dev_softc != NULL)
-			ahc->dev_softc->driver = NULL;
-#endif
+
 		free(ahc->platform_data, M_DEVBUF);
 	}
 }
@@ -1767,7 +1520,6 @@
 		dev->maxtags = 0;
 		dev->openings =  1 - dev->active;
 	}
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	if (dev->scsi_device != NULL) {
 		switch ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED))) {
 		case AHC_DEV_Q_BASIC:
@@ -1793,7 +1545,6 @@
 			break;
 		}
 	}
-#endif
 }
 
 int
@@ -1948,7 +1699,6 @@
 	}
 
 	if ((dev->flags & (AHC_DEV_Q_TAGGED|AHC_DEV_Q_BASIC)) != 0) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 		int	msg_bytes;
 		uint8_t tag_msgs[2];
 		
@@ -1957,10 +1707,8 @@
 			hscb->control |= tag_msgs[0];
 			if (tag_msgs[0] == MSG_ORDERED_TASK)
 				dev->commands_since_idle_or_otag = 0;
-		} else
-#endif
-		if (dev->commands_since_idle_or_otag == AHC_OTAG_THRESH
-		    && (dev->flags & AHC_DEV_Q_TAGGED) != 0) {
+		} else if (dev->commands_since_idle_or_otag == AHC_OTAG_THRESH
+				&& (dev->flags & AHC_DEV_Q_TAGGED) != 0) {
 			hscb->control |= MSG_ORDERED_TASK;
 			dev->commands_since_idle_or_otag = 0;
 		} else {
@@ -2280,28 +2028,9 @@
 	}
         case AC_SENT_BDR:
 	{
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 		WARN_ON(lun != CAM_LUN_WILDCARD);
 		scsi_report_device_reset(ahc->platform_data->host,
 					 channel - 'A', target);
-#else
-		Scsi_Device *scsi_dev;
-
-		/*
-		 * Find the SCSI device associated with this
-		 * request and indicate that a UA is expected.
-		 */
-		for (scsi_dev = ahc->platform_data->host->host_queue;
-		     scsi_dev != NULL; scsi_dev = scsi_dev->next) {
-			if (channel - 'A' == scsi_dev->channel
-			 && target == scsi_dev->id
-			 && (lun == CAM_LUN_WILDCARD
-			  || lun == scsi_dev->lun)) {
-				scsi_dev->was_reset = 1;
-				scsi_dev->expecting_cc_ua = 1;
-			}
-		}
-#endif
 		break;
 	}
         case AC_BUS_RESET:
@@ -2791,7 +2520,6 @@
 	struct ahc_softc *ahc;
 	struct ahc_linux_device *dev;
 	struct scb *pending_scb;
-	u_long s;
 	u_int  saved_scbptr;
 	u_int  active_scb_index;
 	u_int  last_phase;
@@ -2819,22 +2547,6 @@
 	printf("\n");
 
 	/*
-	 * In all versions of Linux, we have to work around
-	 * a major flaw in how the mid-layer is locked down
-	 * if we are to sleep successfully in our error handler
-	 * while allowing our interrupt handler to run.  Since
-	 * the midlayer acquires either the io_request_lock or
-	 * our lock prior to calling us, we must use the
-	 * spin_unlock_irq() method for unlocking our lock.
-	 * This will force interrupts to be enabled on the
-	 * current CPU.  Since the EH thread should not have
-	 * been running with CPU interrupts disabled other than
-	 * by acquiring either the io_request_lock or our own
-	 * lock, this *should* be safe.
-	 */
-	ahc_midlayer_entrypoint_lock(ahc, &s);
-
-	/*
 	 * First determine if we currently own this command.
 	 * Start by searching the device queue.  If not found
 	 * there, check the pending_scb list.  If not found
@@ -3090,7 +2802,6 @@
 		spin_lock_irq(&ahc->platform_data->spin_lock);
 	}
 	ahc_linux_run_complete_queue(ahc);
-	ahc_midlayer_entrypoint_unlock(ahc, &s);
 	return (retval);
 }
 
@@ -3354,7 +3065,6 @@
 static int __init
 ahc_linux_init(void)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	ahc_linux_transport_template = spi_attach_transport(&ahc_linux_transport_functions);
 	if (!ahc_linux_transport_template)
 		return -ENODEV;
@@ -3363,29 +3073,11 @@
 	spi_release_transport(ahc_linux_transport_template);
 	ahc_linux_exit();
 	return -ENODEV;
-#else
-	scsi_register_module(MODULE_SCSI_HA, &aic7xxx_driver_template);
-	if (aic7xxx_driver_template.present == 0) {
-		scsi_unregister_module(MODULE_SCSI_HA,
-				       &aic7xxx_driver_template);
-		return (-ENODEV);
-	}
-
-	return (0);
-#endif
 }
 
 static void
 ahc_linux_exit(void)
 {
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	/*
-	 * In 2.4 we have to unregister from the PCI core _after_
-	 * unregistering from the scsi midlayer to avoid dangling
-	 * references.
-	 */
-	scsi_unregister_module(MODULE_SCSI_HA, &aic7xxx_driver_template);
-#endif
 	ahc_linux_pci_exit();
 	ahc_linux_eisa_exit();
 	spi_release_transport(ahc_linux_transport_template);
Index: linux-2.6/drivers/scsi/aic7xxx/aic7770_osm.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7770_osm.c	2005-05-06 13:34:57.000000000 +0200
+++ linux-2.6/drivers/scsi/aic7xxx/aic7770_osm.c	2005-05-16 19:49:38.000000000 +0200
@@ -41,7 +41,6 @@
 
 #include "aic7xxx_osm.h"
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 #include <linux/device.h>
 #include <linux/eisa.h>
 
@@ -62,13 +61,6 @@
 };
 
 typedef  struct device *aic7770_dev_t;
-#else
-#define MINSLOT			1
-#define NUMSLOTS		16
-#define IDOFFSET		0x80
-
-typedef void *aic7770_dev_t;
-#endif
 
 static int aic7770_linux_config(struct aic7770_identity *entry,
 				aic7770_dev_t dev, u_int eisaBase);
@@ -76,7 +68,6 @@
 int
 ahc_linux_eisa_init(void)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	struct eisa_device_id *eid;
 	struct aic7770_identity *id;
 	int i;
@@ -110,44 +101,6 @@
 	eid->sig[0] = 0;
 
 	return eisa_driver_register(&aic7770_driver);
-#else /* LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0) */
-	struct aic7770_identity *entry;
-	u_int  slot;
-	u_int  eisaBase;
-	u_int  i;
-	int ret = -ENODEV;
-
-	if (aic7xxx_probe_eisa_vl == 0)
-		return ret;
-
-	eisaBase = 0x1000 + AHC_EISA_SLOT_OFFSET;
-	for (slot = 1; slot < NUMSLOTS; eisaBase+=0x1000, slot++) {
-		uint32_t eisa_id;
-		size_t	 id_size;
-
-		if (request_region(eisaBase, AHC_EISA_IOSIZE, "aic7xxx") == 0)
-			continue;
-
-		eisa_id = 0;
-		id_size = sizeof(eisa_id);
-		for (i = 0; i < 4; i++) {
-			/* VLcards require priming*/
-			outb(0x80 + i, eisaBase + IDOFFSET);
-			eisa_id |= inb(eisaBase + IDOFFSET + i)
-				   << ((id_size-i-1) * 8);
-		}
-		release_region(eisaBase, AHC_EISA_IOSIZE);
-		if (eisa_id & 0x80000000)
-			continue;  /* no EISA card in slot */
-
-		entry = aic7770_find_device(eisa_id);
-		if (entry != NULL) {
-			aic7770_linux_config(entry, NULL, eisaBase);
-			ret = 0;
-		}
-	}
-	return ret;
-#endif
 }
 
 void
@@ -187,11 +140,10 @@
 		ahc_free(ahc);
 		return (error);
 	}
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+
 	dev->driver_data = (void *)ahc;
 	if (aic7xxx_detect_complete)
 		error = ahc_linux_register_host(ahc, &aic7xxx_driver_template);
-#endif
 	return (error);
 }
 
@@ -225,7 +177,6 @@
 	return (-error);
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 static int
 aic7770_eisa_dev_probe(struct device *dev)
 {
@@ -261,4 +212,3 @@
 
 	return (0);
 }
-#endif
Index: linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-05-16 19:26:55.000000000 +0200
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-05-16 19:47:59.000000000 +0200
@@ -281,12 +281,6 @@
 /***************************** SMP support ************************************/
 #include <linux/spinlock.h>
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0) || defined(SCSI_HAS_HOST_LOCK))
-#define AHC_SCSI_HAS_HOST_LOCK 1
-#else
-#define AHC_SCSI_HAS_HOST_LOCK 0
-#endif
-
 #define AIC7XXX_DRIVER_VERSION "6.2.36"
 
 /**************************** Front End Queues ********************************/
@@ -438,18 +432,7 @@
  * manner and are allocated below 4GB, the number of S/G segments is
  * unrestricted.
  */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-/*
- * We dynamically adjust the number of segments in pre-2.5 kernels to
- * avoid fragmentation issues in the SCSI mid-layer's private memory
- * allocator.  See aic7xxx_osm.c ahc_linux_size_nseg() for details.
- */
-extern u_int ahc_linux_nseg;
-#define	AHC_NSEG ahc_linux_nseg
-#define	AHC_LINUX_MIN_NSEG 64
-#else
 #define	AHC_NSEG 128
-#endif
 
 /*
  * Per-SCB OSM storage.
@@ -607,17 +590,6 @@
 static __inline void ahc_lock(struct ahc_softc *, unsigned long *flags);
 static __inline void ahc_unlock(struct ahc_softc *, unsigned long *flags);
 
-/* Lock acquisition and release of the above lock in midlayer entry points. */
-static __inline void ahc_midlayer_entrypoint_lock(struct ahc_softc *,
-						  unsigned long *flags);
-static __inline void ahc_midlayer_entrypoint_unlock(struct ahc_softc *,
-						    unsigned long *flags);
-
-/* Lock held during command compeletion to the upper layer */
-static __inline void ahc_done_lockinit(struct ahc_softc *);
-static __inline void ahc_done_lock(struct ahc_softc *, unsigned long *flags);
-static __inline void ahc_done_unlock(struct ahc_softc *, unsigned long *flags);
-
 /* Lock held during ahc_list manipulation and ahc softc frees */
 extern spinlock_t ahc_list_spinlock;
 static __inline void ahc_list_lockinit(void);
@@ -643,57 +615,6 @@
 }
 
 static __inline void
-ahc_midlayer_entrypoint_lock(struct ahc_softc *ahc, unsigned long *flags)
-{
-	/*
-	 * In 2.5.X and some 2.4.X versions, the midlayer takes our
-	 * lock just before calling us, so we avoid locking again.
-	 * For other kernel versions, the io_request_lock is taken
-	 * just before our entry point is called.  In this case, we
-	 * trade the io_request_lock for our per-softc lock.
-	 */
-#if AHC_SCSI_HAS_HOST_LOCK == 0
-	spin_unlock(&io_request_lock);
-	spin_lock(&ahc->platform_data->spin_lock);
-#endif
-}
-
-static __inline void
-ahc_midlayer_entrypoint_unlock(struct ahc_softc *ahc, unsigned long *flags)
-{
-#if AHC_SCSI_HAS_HOST_LOCK == 0
-	spin_unlock(&ahc->platform_data->spin_lock);
-	spin_lock(&io_request_lock);
-#endif
-}
-
-static __inline void
-ahc_done_lockinit(struct ahc_softc *ahc)
-{
-	/*
-	 * In 2.5.X, our own lock is held during completions.
-	 * In previous versions, the io_request_lock is used.
-	 * In either case, we can't initialize this lock again.
-	 */
-}
-
-static __inline void
-ahc_done_lock(struct ahc_softc *ahc, unsigned long *flags)
-{
-#if AHC_SCSI_HAS_HOST_LOCK == 0
-	spin_lock_irqsave(&io_request_lock, *flags);
-#endif
-}
-
-static __inline void
-ahc_done_unlock(struct ahc_softc *ahc, unsigned long *flags)
-{
-#if AHC_SCSI_HAS_HOST_LOCK == 0
-	spin_unlock_irqrestore(&io_request_lock, *flags);
-#endif
-}
-
-static __inline void
 ahc_list_lockinit(void)
 {
 	spin_lock_init(&ahc_list_spinlock);
@@ -759,12 +680,6 @@
 } ahc_power_state;
 
 /**************************** VL/EISA Routines ********************************/
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0) \
-  && (defined(__i386__) || defined(__alpha__)) \
-  && (!defined(CONFIG_EISA)))
-#define CONFIG_EISA
-#endif
-
 #ifdef CONFIG_EISA
 extern uint32_t aic7xxx_probe_eisa_vl;
 int			 ahc_linux_eisa_init(void);
@@ -880,12 +795,8 @@
 }
 
 /**************************** Proc FS Support *********************************/
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-int	ahc_linux_proc_info(char *, char **, off_t, int, int, int);
-#else
 int	ahc_linux_proc_info(struct Scsi_Host *, char *, char **,
 			    off_t, int, int);
-#endif
 
 /*************************** Domain Validation ********************************/
 /*********************** Transaction Access Wrappers *************************/
Index: linux-2.6/drivers/scsi/aic7xxx/aic7xxx_proc.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_proc.c	2005-04-30 10:17:16.000000000 +0200
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_proc.c	2005-05-16 19:48:41.000000000 +0200
@@ -289,13 +289,8 @@
  * Return information to handle /proc support for the driver.
  */
 int
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-ahc_linux_proc_info(char *buffer, char **start, off_t offset,
-		    int length, int hostno, int inout)
-#else
 ahc_linux_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 		    off_t offset, int length, int inout)
-#endif
 {
 	struct	ahc_softc *ahc;
 	struct	info_str info;
@@ -307,15 +302,7 @@
 
 	retval = -EINVAL;
 	ahc_list_lock(&s);
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	TAILQ_FOREACH(ahc, &ahc_tailq, links) {
-		if (ahc->platform_data->host->host_no == hostno)
-			break;
-	}
-#else
 	ahc = ahc_find_softc(*(struct ahc_softc **)shost->hostdata);
-#endif
-
 	if (ahc == NULL)
 		goto done;
 
