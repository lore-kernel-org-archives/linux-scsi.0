From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 2/4] aic79xx: remove Linux 2.4 ifdefs
Date: Sun, 29 May 2005 03:40:50 -0400
Message-ID: <20050529074050.GA25977@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlmail.prod.rxgsys.com ([69.61.70.25]:23689 "EHLO
	bastet.signetmail.com") by vger.kernel.org with ESMTP
	id S261269AbVE2Hk7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 May 2005 03:40:59 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by bastet.signetmail.com (RXG Elite Mail Server) with ESMTP id 26A74A883F
	for <linux-scsi@vger.kernel.org>; Sun, 29 May 2005 02:20:12 -0400 (EDT)
Received: from bastet.signetmail.com ([127.0.0.1])
 by localhost (atlmail.prod.rxgsys.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 30197-10 for <linux-scsi@vger.kernel.org>;
 Sun, 29 May 2005 02:20:05 -0400 (EDT)
Received: from havoc.gtf.org (havoc.gtf.org [63.115.148.101])
	by bastet.signetmail.com (RXG Elite Mail Server) with ESMTP id 870E6A8818
	for <linux-scsi@vger.kernel.org>; Sun, 29 May 2005 02:20:04 -0400 (EDT)
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 81B861C20C01
	for <linux-scsi@vger.kernel.org>; Sun, 29 May 2005 03:40:50 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j4T7eo4v025988
	for linux-scsi@vger.kernel.org; Sun, 29 May 2005 03:40:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



[note:  just for review...  do not apply, will be submitted later via git]

author Jeff Garzik <jgarzik@pobox.com> Sun, 29 May 2005 06:57:07 -0400
committer Jeff Garzik <jgarzik@pobox.com> Sun, 29 May 2005 06:57:07 -0400

[SCSI] aic79xx: remove Linux 2.4 ifdefs

There's not much sense in sharing code anymore now that aic79xx uses
various transport class facilities.

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -53,11 +53,6 @@
 #include "aiclib.c"
 
 #include <linux/init.h>		/* __setup */
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-#include "sd.h"			/* For geometry detection */
-#endif
-
 #include <linux/mm.h>		/* For fetching system memory size */
 #include <linux/delay.h>	/* For ssleep/msleep */
 
@@ -66,11 +61,6 @@
  */
 spinlock_t ahd_list_spinlock;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-/* For dynamic sglist size calculation. */
-u_int ahd_linux_nseg;
-#endif
-
 /*
  * Bucket size for counting good commands in between bad ones.
  */
@@ -457,7 +447,6 @@ static void ahd_linux_filter_inquiry(str
 static void ahd_linux_dev_timed_unfreeze(u_long arg);
 static void ahd_linux_sem_timeout(u_long arg);
 static void ahd_linux_initialize_scsi_bus(struct ahd_softc *ahd);
-static void ahd_linux_size_nseg(void);
 static void ahd_linux_thread_run_complete_queue(struct ahd_softc *ahd);
 static void ahd_linux_start_dv(struct ahd_softc *ahd);
 static void ahd_linux_dv_timeout(struct scsi_cmnd *cmd);
@@ -709,7 +698,6 @@ ahd_linux_unmap_scb(struct ahd_softc *ah
 static int	   ahd_linux_detect(Scsi_Host_Template *);
 static const char *ahd_linux_info(struct Scsi_Host *);
 static int	   ahd_linux_queue(Scsi_Cmnd *, void (*)(Scsi_Cmnd *));
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 static int	   ahd_linux_slave_alloc(Scsi_Device *);
 static int	   ahd_linux_slave_configure(Scsi_Device *);
 static void	   ahd_linux_slave_destroy(Scsi_Device *);
@@ -717,78 +705,10 @@ static void	   ahd_linux_slave_destroy(S
 static int	   ahd_linux_biosparam(struct scsi_device*,
 				       struct block_device*, sector_t, int[]);
 #endif
-#else
-static int	   ahd_linux_release(struct Scsi_Host *);
-static void	   ahd_linux_select_queue_depth(struct Scsi_Host *host,
-						Scsi_Device *scsi_devs);
-#if defined(__i386__)
-static int	   ahd_linux_biosparam(Disk *, kdev_t, int[]);
-#endif
-#endif
 static int	   ahd_linux_bus_reset(Scsi_Cmnd *);
 static int	   ahd_linux_dev_reset(Scsi_Cmnd *);
 static int	   ahd_linux_abort(Scsi_Cmnd *);
 
-/*
- * Calculate a safe value for AHD_NSEG (as expressed through ahd_linux_nseg).
- *
- * In pre-2.5.X...
- * The midlayer allocates an S/G array dynamically when a command is issued
- * using SCSI malloc.  This array, which is in an OS dependent format that
- * must later be copied to our private S/G list, is sized to house just the
- * number of segments needed for the current transfer.  Since the code that
- * sizes the SCSI malloc pool does not take into consideration fragmentation
- * of the pool, executing transactions numbering just a fraction of our
- * concurrent transaction limit with SG list lengths aproaching AHC_NSEG will
- * quickly depleat the SCSI malloc pool of usable space.  Unfortunately, the
- * mid-layer does not properly handle this scsi malloc failures for the S/G
- * array and the result can be a lockup of the I/O subsystem.  We try to size
- * our S/G list so that it satisfies our drivers allocation requirements in
- * addition to avoiding fragmentation of the SCSI malloc pool.
- */
-static void
-ahd_linux_size_nseg(void)
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
-		if (nseg < AHD_LINUX_MIN_NSEG)
-			continue;
-
-		if (best_size == 0) {
-			best_size = cur_size;
-			ahd_linux_nseg = nseg;
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
-				ahd_linux_nseg = nseg;
-			}
-		}
-	}
-#endif
-}
 
 /*
  * Try to detect an Adaptec 79XX controller.
@@ -800,14 +720,6 @@ ahd_linux_detect(Scsi_Host_Template *tem
 	int     found;
 	int	error = 0;
 
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
@@ -819,10 +731,7 @@ ahd_linux_detect(Scsi_Host_Template *tem
 		printf("ahd_linux_detect: Unable to attach\n");
 		return (0);
 	}
-	/*
-	 * Determine an appropriate size for our Scatter Gatther lists.
-	 */
-	ahd_linux_size_nseg();
+
 #ifdef MODULE
 	/*
 	 * If we've been passed any parameters, process them now.
@@ -855,47 +764,10 @@ ahd_linux_detect(Scsi_Host_Template *tem
 		if (ahd_linux_register_host(ahd, template) == 0)
 			found++;
 	}
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	spin_lock_irq(&io_request_lock);
-#endif
 	aic79xx_detect_complete++;
 	return 0;
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-/*
- * Free the passed in Scsi_Host memory structures prior to unloading the
- * module.
- */
-static int
-ahd_linux_release(struct Scsi_Host * host)
-{
-	struct ahd_softc *ahd;
-	u_long l;
-
-	ahd_list_lock(&l);
-	if (host != NULL) {
-
-		/*
-		 * We should be able to just perform
-		 * the free directly, but check our
-		 * list for extra sanity.
-		 */
-		ahd = ahd_find_softc(*(struct ahd_softc **)host->hostdata);
-		if (ahd != NULL) {
-			u_long s;
-
-			ahd_lock(ahd, &s);
-			ahd_intr_enable(ahd, FALSE);
-			ahd_unlock(ahd, &s);
-			ahd_free(ahd);
-		}
-	}
-	ahd_list_unlock(&l);
-	return (0);
-}
-#endif
-
 /*
  * Return a string describing the driver.
  */
@@ -983,7 +855,6 @@ ahd_linux_queue(Scsi_Cmnd * cmd, void (*
 	return (0);
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 static int
 ahd_linux_slave_alloc(Scsi_Device *device)
 {
@@ -1056,92 +927,16 @@ ahd_linux_slave_destroy(Scsi_Device *dev
 	}
 	ahd_midlayer_entrypoint_unlock(ahd, &flags);
 }
-#else
-/*
- * Sets the queue depth for each SCSI device hanging
- * off the input host adapter.
- */
-static void
-ahd_linux_select_queue_depth(struct Scsi_Host * host,
-			     Scsi_Device * scsi_devs)
-{
-	Scsi_Device *device;
-	Scsi_Device *ldev;
-	struct	ahd_softc *ahd;
-	u_long	flags;
-
-	ahd = *((struct ahd_softc **)host->hostdata);
-	ahd_lock(ahd, &flags);
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
-			struct	 ahd_linux_device *dev;
-
-			/*
-			 * Since Linux has attached to the device, configure
-			 * it so we don't free and allocate the device
-			 * structure on every command.
-			 */
-			dev = ahd_linux_get_device(ahd, device->channel,
-						   device->id, device->lun,
-						   /*alloc*/TRUE);
-			if (dev != NULL) {
-				dev->flags &= ~AHD_DEV_UNCONFIGURED;
-				dev->scsi_device = device;
-				ahd_linux_device_queue_depth(ahd, dev);
-				device->queue_depth = dev->openings
-						    + dev->active;
-				if ((dev->flags & (AHD_DEV_Q_BASIC
-						| AHD_DEV_Q_TAGGED)) == 0) {
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
-	ahd_unlock(ahd, &flags);
-}
-#endif
 
 #if defined(__i386__)
 /*
  * Return the disk geometry for the given SCSI device.
  */
 static int
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 ahd_linux_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 		    sector_t capacity, int geom[])
 {
 	uint8_t *bh;
-#else
-ahd_linux_biosparam(Disk *disk, kdev_t dev, int geom[])
-{
-	struct	scsi_device *sdev = disk->device;
-	u_long	capacity = disk->capacity;
-	struct	buffer_head *bh;
-#endif
 	int	 heads;
 	int	 sectors;
 	int	 cylinders;
@@ -1151,22 +946,11 @@ ahd_linux_biosparam(Disk *disk, kdev_t d
 
 	ahd = *((struct ahd_softc **)sdev->host->hostdata);
 
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
@@ -1997,11 +1781,7 @@ ahd_linux_register_host(struct ahd_softc
 
 	*((struct ahd_softc **)host->hostdata) = ahd;
 	ahd_lock(ahd, &s);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	scsi_assign_lock(host, &ahd->platform_data->spin_lock);
-#elif AHD_SCSI_HAS_HOST_LOCK != 0
-	host->lock = &ahd->platform_data->spin_lock;
-#endif
 	ahd->platform_data->host = host;
 	host->can_queue = AHD_MAX_QUEUE;
 	host->cmd_per_lun = 2;
@@ -2020,11 +1800,7 @@ ahd_linux_register_host(struct ahd_softc
 		ahd_set_name(ahd, new_name);
 	}
 	host->unique_id = ahd->unit;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	scsi_set_pci_device(host, ahd->dev_softc);
-#else
 	scsi_set_device(host, pci_dev_to_dev(ahd->dev_softc));
-#endif
 	ahd_linux_setup_user_rd_strm_settings(ahd);
 	ahd_linux_initialize_scsi_bus(ahd);
 	ahd_unlock(ahd, &s);
@@ -2066,10 +1842,8 @@ ahd_linux_register_host(struct ahd_softc
 	ahd_linux_start_dv(ahd);
 	ahd_unlock(ahd, &s);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	scsi_add_host(host, &ahd->dev_softc->dev); /* XXX handle failure */
 	scsi_scan_host(host);
-#endif
 	return (0);
 }
 
@@ -2194,9 +1968,7 @@ ahd_platform_free(struct ahd_softc *ahd)
 		ahd_linux_kill_dv_thread(ahd);
 		ahd_teardown_runq_tasklet(ahd);
 		if (ahd->platform_data->host != NULL) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 			scsi_remove_host(ahd->platform_data->host);
-#endif
 			scsi_host_put(ahd->platform_data->host);
 		}
 
@@ -2235,16 +2007,6 @@ ahd_platform_free(struct ahd_softc *ahd)
 			release_mem_region(ahd->platform_data->mem_busaddr,
 					   0x1000);
 		}
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-    		/*
-		 * In 2.4 we detach from the scsi midlayer before the PCI
-		 * layer invokes our remove callback.  No per-instance
-		 * detach is provided, so we must reach inside the PCI
-		 * subsystem's internals and detach our driver manually.
-		 */
-		if (ahd->dev_softc != NULL)
-			ahd->dev_softc->driver = NULL;
-#endif
 		free(ahd->platform_data, M_DEVBUF);
 	}
 }
@@ -2341,7 +2103,7 @@ ahd_platform_set_tags(struct ahd_softc *
 		dev->maxtags = 0;
 		dev->openings =  1 - dev->active;
 	}
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+
 	if (dev->scsi_device != NULL) {
 		switch ((dev->flags & (AHD_DEV_Q_BASIC|AHD_DEV_Q_TAGGED))) {
 		case AHD_DEV_Q_BASIC:
@@ -2367,7 +2129,6 @@ ahd_platform_set_tags(struct ahd_softc *
 			break;
 		}
 	}
-#endif
 }
 
 int
@@ -2480,18 +2241,10 @@ ahd_linux_dv_thread(void *data)
 	 * Complete thread creation.
 	 */
 	lock_kernel();
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,60)
-	/*
-	 * Don't care about any signals.
-	 */
-	siginitsetinv(&current->blocked, 0);
 
-	daemonize();
-	sprintf(current->comm, "ahd_dv_%d", ahd->unit);
-#else
 	daemonize("ahd_dv_%d", ahd->unit);
 	current->flags |= PF_FREEZE;
-#endif
+
 	unlock_kernel();
 
 	while (1) {
@@ -3987,7 +3740,6 @@ ahd_linux_run_device_queue(struct ahd_so
 		}
 
 		if ((dev->flags & (AHD_DEV_Q_TAGGED|AHD_DEV_Q_BASIC)) != 0) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 			int	msg_bytes;
 			uint8_t tag_msgs[2];
 
@@ -3997,7 +3749,6 @@ ahd_linux_run_device_queue(struct ahd_so
 				if (tag_msgs[0] == MSG_ORDERED_TASK)
 					dev->commands_since_idle_or_otag = 0;
 			} else
-#endif
 			if (dev->commands_since_idle_or_otag == AHD_OTAG_THRESH
 			 && (dev->flags & AHD_DEV_Q_TAGGED) != 0) {
 				hscb->control |= MSG_ORDERED_TASK;
@@ -4266,28 +4017,9 @@ ahd_send_async(struct ahd_softc *ahd, ch
 	}
         case AC_SENT_BDR:
 	{
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 		WARN_ON(lun != CAM_LUN_WILDCARD);
 		scsi_report_device_reset(ahd->platform_data->host,
 					 channel - 'A', target);
-#else
-		Scsi_Device *scsi_dev;
-
-		/*
-		 * Find the SCSI device associated with this
-		 * request and indicate that a UA is expected.
-		 */
-		for (scsi_dev = ahd->platform_data->host->host_queue;
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
@@ -4974,18 +4706,7 @@ ahd_platform_dump_card_state(struct ahd_
 static int __init
 ahd_linux_init(void)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	return ahd_linux_detect(&aic79xx_driver_template);
-#else
-	scsi_register_module(MODULE_SCSI_HA, &aic79xx_driver_template);
-	if (aic79xx_driver_template.present == 0) {
-		scsi_unregister_module(MODULE_SCSI_HA,
-				       &aic79xx_driver_template);
-		return (-ENODEV);
-	}
-
-	return (0);
-#endif
 }
 
 static void __exit
@@ -5004,14 +4725,6 @@ ahd_linux_exit(void)
 		ahd_linux_kill_dv_thread(ahd);
 	}
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	/*
-	 * In 2.4 we have to unregister from the PCI core _after_
-	 * unregistering from the scsi midlayer to avoid dangling
-	 * references.
-	 */
-	scsi_unregister_module(MODULE_SCSI_HA, &aic79xx_driver_template);
-#endif
 	ahd_linux_pci_exit();
 }
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -269,11 +269,7 @@ ahd_scb_timer_reset(struct scb *scb, u_i
 /***************************** SMP support ************************************/
 #include <linux/spinlock.h>
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0) || defined(SCSI_HAS_HOST_LOCK))
 #define AHD_SCSI_HAS_HOST_LOCK 1
-#else
-#define AHD_SCSI_HAS_HOST_LOCK 0
-#endif
 
 #define AIC79XX_DRIVER_VERSION "1.3.11"
 
@@ -470,18 +466,7 @@ struct ahd_linux_target {
  * manner and are allocated below 4GB, the number of S/G segments is
  * unrestricted.
  */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-/*
- * We dynamically adjust the number of segments in pre-2.5 kernels to
- * avoid fragmentation issues in the SCSI mid-layer's private memory
- * allocator.  See aic79xx_osm.c ahd_linux_size_nseg() for details.
- */
-extern u_int ahd_linux_nseg;
-#define	AHD_NSEG ahd_linux_nseg
-#define	AHD_LINUX_MIN_NSEG 64
-#else
 #define	AHD_NSEG 128
-#endif
 
 /*
  * Per-SCB OSM storage.
@@ -942,12 +927,8 @@ ahd_flush_device_writes(struct ahd_softc
 }
 
 /**************************** Proc FS Support *********************************/
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-int	ahd_linux_proc_info(char *, char **, off_t, int, int, int);
-#else
 int	ahd_linux_proc_info(struct Scsi_Host *, char *, char **,
 			    off_t, int, int);
-#endif
 
 /*************************** Domain Validation ********************************/
 #define AHD_DV_CMD(cmd) ((cmd)->scsi_done == ahd_linux_dv_complete)
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -195,13 +195,7 @@ ahd_linux_pci_dev_probe(struct pci_dev *
 	}
 	pci_set_drvdata(pdev, ahd);
 	if (aic79xx_detect_complete) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 		ahd_linux_register_host(ahd, &aic79xx_driver_template);
-#else
-		printf("aic79xx: ignoring PCI device found after "
-		       "initialization\n");
-		return (-ENODEV);
-#endif
 	}
 	return (0);
 }
diff --git a/drivers/scsi/aic7xxx/aic79xx_proc.c b/drivers/scsi/aic7xxx/aic79xx_proc.c
--- a/drivers/scsi/aic7xxx/aic79xx_proc.c
+++ b/drivers/scsi/aic7xxx/aic79xx_proc.c
@@ -278,13 +278,8 @@ done:
  * Return information to handle /proc support for the driver.
  */
 int
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-ahd_linux_proc_info(char *buffer, char **start, off_t offset,
-		    int length, int hostno, int inout)
-#else
 ahd_linux_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 		    off_t offset, int length, int inout)
-#endif
 {
 	struct	ahd_softc *ahd;
 	struct	info_str info;
@@ -296,14 +291,7 @@ ahd_linux_proc_info(struct Scsi_Host *sh
 
 	retval = -EINVAL;
 	ahd_list_lock(&l);
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	TAILQ_FOREACH(ahd, &ahd_tailq, links) {
-		if (ahd->platform_data->host->host_no == hostno)
-			break;
-	}
-#else
 	ahd = ahd_find_softc(*(struct ahd_softc **)shost->hostdata);
-#endif
 
 	if (ahd == NULL)
 		goto done;
