From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: 27 Feb 2004 12:26:22 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077906383.2157.98.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:22501 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262930AbUB0S02 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 13:26:28 -0500
List-Id: linux-scsi@vger.kernel.org
To: gibbs@scsiguy.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

The deadlock is quite simple: if the device timer ever fires, it can
call a linux_free_device() from the timer which will do a del_timer_sync
on the timer and hang.

The best fix, I think is to eliminate this timer from the driver.  All
it was doing was providing a time limited queue freeze for the BUSY and
QUEUE_FULL on no outstanding commands cases.  These are handled
correctly by the mid-layer, so there's no need for the driver do try to
handle them on it's own.

It looks like the only other consumer of the queue freezing api is an
untimed tag/untagged switch, so I pulled out the per device timer as
well.

James

===== drivers/scsi/aic7xxx/aic79xx_osm.c 1.52 vs edited =====
--- 1.52/drivers/scsi/aic7xxx/aic79xx_osm.c	Wed Feb 18 21:42:35 2004
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm.c	Fri Feb 27 12:20:52 2004
@@ -472,7 +472,6 @@
 					 Scsi_Cmnd *cmd);
 static void ahd_linux_filter_inquiry(struct ahd_softc *ahd,
 				     struct ahd_devinfo *devinfo);
-static void ahd_linux_dev_timed_unfreeze(u_long arg);
 static void ahd_linux_sem_timeout(u_long arg);
 static void ahd_linux_initialize_scsi_bus(struct ahd_softc *ahd);
 static void ahd_linux_size_nseg(void);
@@ -4262,7 +4261,6 @@
 	if (dev == NULL)
 		return (NULL);
 	memset(dev, 0, sizeof(*dev));
-	init_timer(&dev->timer);
 	TAILQ_INIT(&dev->busyq);
 	dev->flags = AHD_DEV_UNCONFIGURED;
 	dev->lun = lun;
@@ -4291,7 +4289,6 @@
 {
 	struct ahd_linux_target *targ;
 
-	del_timer(&dev->timer);
 	targ = dev->target;
 	targ->devices[dev->lun] = NULL;
 	free(dev, M_DEVBUF);
@@ -4683,28 +4680,9 @@
 			     (dev->flags & AHD_DEV_Q_BASIC)
 			   ? AHD_QUEUE_BASIC : AHD_QUEUE_TAGGED);
 		ahd_set_scsi_status(scb, SCSI_STATUS_BUSY);
-		/* FALLTHROUGH */
-	}
-	case SCSI_STATUS_BUSY:
-		/*
-		 * Set a short timer to defer sending commands for
-		 * a bit since Linux will not delay in this case.
-		 */
-		if ((dev->flags & AHD_DEV_TIMER_ACTIVE) != 0) {
-			printf("%s:%c:%d: Device Timer still active during "
-			       "busy processing\n", ahd_name(ahd),
-				dev->target->channel, dev->target->target);
-			break;
-		}
-		dev->flags |= AHD_DEV_TIMER_ACTIVE;
-		dev->qfrozen++;
-		init_timer(&dev->timer);
-		dev->timer.data = (u_long)dev;
-		dev->timer.expires = jiffies + (HZ/2);
-		dev->timer.function = ahd_linux_dev_timed_unfreeze;
-		add_timer(&dev->timer);
 		break;
 	}
+	}
 }
 
 static void
@@ -5017,28 +4995,6 @@
 		scb->platform_data->flags &= ~AHD_SCB_UP_EH_SEM;
 		up(&ahd->platform_data->eh_sem);
 	}
-	ahd_unlock(ahd, &s);
-}
-
-static void
-ahd_linux_dev_timed_unfreeze(u_long arg)
-{
-	struct ahd_linux_device *dev;
-	struct ahd_softc *ahd;
-	u_long s;
-
-	dev = (struct ahd_linux_device *)arg;
-	ahd = dev->target->ahd;
-	ahd_lock(ahd, &s);
-	dev->flags &= ~AHD_DEV_TIMER_ACTIVE;
-	if (dev->qfrozen > 0)
-		dev->qfrozen--;
-	if (dev->qfrozen == 0
-	 && (dev->flags & AHD_DEV_ON_RUN_LIST) == 0)
-		ahd_linux_run_device_queue(ahd, dev);
-	if ((dev->flags & AHD_DEV_UNCONFIGURED) != 0
-	 && dev->active == 0)
-		ahd_linux_free_device(ahd, dev);
 	ahd_unlock(ahd, &s);
 }
 
===== drivers/scsi/aic7xxx/aic79xx_osm.h 1.35 vs edited =====
--- 1.35/drivers/scsi/aic7xxx/aic79xx_osm.h	Tue Dec 30 12:12:35 2003
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm.h	Fri Feb 27 12:16:56 2004
@@ -387,11 +387,6 @@
 	ahd_linux_dev_flags	flags;
 
 	/*
-	 * Per device timer.
-	 */
-	struct timer_list	timer;
-
-	/*
 	 * The high limit for the tags variable.
 	 */
 	u_int			maxtags;
===== drivers/scsi/aic7xxx/aic7xxx_osm.c 1.49 vs edited =====
--- 1.49/drivers/scsi/aic7xxx/aic7xxx_osm.c	Wed Feb 18 21:42:35 2004
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.c	Fri Feb 27 12:12:51 2004
@@ -490,7 +490,6 @@
 static void ahc_linux_sem_timeout(u_long arg);
 static void ahc_linux_freeze_simq(struct ahc_softc *ahc);
 static void ahc_linux_release_simq(u_long arg);
-static void ahc_linux_dev_timed_unfreeze(u_long arg);
 static int  ahc_linux_queue_recovery_cmd(Scsi_Cmnd *cmd, scb_flag flag);
 static void ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc);
 static void ahc_linux_size_nseg(void);
@@ -3944,7 +3943,6 @@
 	if (dev == NULL)
 		return (NULL);
 	memset(dev, 0, sizeof(*dev));
-	init_timer(&dev->timer);
 	TAILQ_INIT(&dev->busyq);
 	dev->flags = AHC_DEV_UNCONFIGURED;
 	dev->lun = lun;
@@ -3973,7 +3971,6 @@
 {
 	struct ahc_linux_target *targ;
 
-	del_timer_sync(&dev->timer);
 	targ = dev->target;
 	targ->devices[dev->lun] = NULL;
 	free(dev, M_DEVBUF);
@@ -4363,27 +4360,6 @@
 		ahc_platform_set_tags(ahc, &devinfo,
 			     (dev->flags & AHC_DEV_Q_BASIC)
 			   ? AHC_QUEUE_BASIC : AHC_QUEUE_TAGGED);
-		/* FALLTHROUGH */
-	}
-	case SCSI_STATUS_BUSY:
-	{
-		/*
-		 * Set a short timer to defer sending commands for
-		 * a bit since Linux will not delay in this case.
-		 */
-		if ((dev->flags & AHC_DEV_TIMER_ACTIVE) != 0) {
-			printf("%s:%c:%d: Device Timer still active during "
-			       "busy processing\n", ahc_name(ahc),
-				dev->target->channel, dev->target->target);
-			break;
-		}
-		dev->flags |= AHC_DEV_TIMER_ACTIVE;
-		dev->qfrozen++;
-		init_timer(&dev->timer);
-		dev->timer.data = (u_long)dev;
-		dev->timer.expires = jiffies + (HZ/2);
-		dev->timer.function = ahc_linux_dev_timed_unfreeze;
-		add_timer(&dev->timer);
 		break;
 	}
 	}
@@ -4673,28 +4649,6 @@
 	 */
 	if (unblock_reqs)
 		scsi_unblock_requests(ahc->platform_data->host);
-}
-
-static void
-ahc_linux_dev_timed_unfreeze(u_long arg)
-{
-	struct ahc_linux_device *dev;
-	struct ahc_softc *ahc;
-	u_long s;
-
-	dev = (struct ahc_linux_device *)arg;
-	ahc = dev->target->ahc;
-	ahc_lock(ahc, &s);
-	dev->flags &= ~AHC_DEV_TIMER_ACTIVE;
-	if (dev->qfrozen > 0)
-		dev->qfrozen--;
-	if (dev->qfrozen == 0
-	 && (dev->flags & AHC_DEV_ON_RUN_LIST) == 0)
-		ahc_linux_run_device_queue(ahc, dev);
-	if (TAILQ_EMPTY(&dev->busyq)
-	 && dev->active == 0)
-		ahc_linux_free_device(ahc, dev);
-	ahc_unlock(ahc, &s);
 }
 
 static int
===== drivers/scsi/aic7xxx/aic7xxx_osm.h 1.51 vs edited =====
--- 1.51/drivers/scsi/aic7xxx/aic7xxx_osm.h	Tue Dec 30 12:12:37 2003
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.h	Fri Feb 27 12:13:34 2004
@@ -399,11 +399,6 @@
 	ahc_linux_dev_flags	flags;
 
 	/*
-	 * Per device timer.
-	 */
-	struct timer_list	timer;
-
-	/*
 	 * The high limit for the tags variable.
 	 */
 	u_int			maxtags;

