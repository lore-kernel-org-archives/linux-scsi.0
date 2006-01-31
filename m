From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, RFC] aic7xxx: semaphore to completion conversion
Date: Tue, 31 Jan 2006 18:20:18 +0100
Message-ID: <20060131172018.GD28889@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:37041 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751291AbWAaRUV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 12:20:21 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, hare@suse.de
Cc: linux-scsi@vger.kernel.org

switch eh_sem to a completion.  due to wait_for_completion_timeout this
also nicely simplifies the code.  Unfortunately it's untested, so if
someone with the hardware could give it a try that would be nice.  Once
it works the same thing can be applied to aic79xx.


Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c	2006-01-13 17:55:57.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c	2006-01-31 17:28:31.000000000 +0100
@@ -373,7 +373,6 @@
 					 struct scb *);
 static void ahc_linux_queue_cmd_complete(struct ahc_softc *ahc,
 					 struct scsi_cmnd *cmd);
-static void ahc_linux_sem_timeout(u_long arg);
 static void ahc_linux_freeze_simq(struct ahc_softc *ahc);
 static void ahc_linux_release_simq(struct ahc_softc *ahc);
 static int  ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag);
@@ -1193,7 +1192,7 @@
 	memset(ahc->platform_data, 0, sizeof(struct ahc_platform_data));
 	ahc->platform_data->irq = AHC_LINUX_NOIRQ;
 	ahc_lockinit(ahc);
-	init_MUTEX_LOCKED(&ahc->platform_data->eh_sem);
+	init_completion(&ahc->platform_data->eh_done);
 	ahc->seltime = (aic7xxx_seltime & 0x3) << 4;
 	ahc->seltime_b = (aic7xxx_seltime & 0x3) << 4;
 	if (aic7xxx_pci_parity == 0)
@@ -1832,7 +1831,7 @@
 			ahc_set_transaction_status(scb, CAM_CMD_TIMEOUT);
 		if ((ahc->platform_data->flags & AHC_UP_EH_SEMAPHORE) != 0) {
 			ahc->platform_data->flags &= ~AHC_UP_EH_SEMAPHORE;
-			up(&ahc->platform_data->eh_sem);
+			complete(&ahc->platform_data->eh_done);
 		}
 	}
 
@@ -2040,22 +2039,6 @@
 }
 
 static void
-ahc_linux_sem_timeout(u_long arg)
-{
-	struct	ahc_softc *ahc;
-	u_long	s;
-
-	ahc = (struct ahc_softc *)arg;
-
-	ahc_lock(ahc, &s);
-	if ((ahc->platform_data->flags & AHC_UP_EH_SEMAPHORE) != 0) {
-		ahc->platform_data->flags &= ~AHC_UP_EH_SEMAPHORE;
-		up(&ahc->platform_data->eh_sem);
-	}
-	ahc_unlock(ahc, &s);
-}
-
-static void
 ahc_linux_freeze_simq(struct ahc_softc *ahc)
 {
 	unsigned long s;
@@ -2355,25 +2338,16 @@
 	if (paused)
 		ahc_unpause(ahc);
 	if (wait) {
-		struct timer_list timer;
-		int ret;
-
 		ahc->platform_data->flags |= AHC_UP_EH_SEMAPHORE;
 		ahc_unlock(ahc, &flags);
 
-		init_timer(&timer);
-		timer.data = (u_long)ahc;
-		timer.expires = jiffies + (5 * HZ);
-		timer.function = ahc_linux_sem_timeout;
-		add_timer(&timer);
 		printf("Recovery code sleeping\n");
-		down(&ahc->platform_data->eh_sem);
-		printf("Recovery code awake\n");
-        	ret = del_timer_sync(&timer);
-		if (ret == 0) {
+		if (!wait_for_completion_timeout(
+				&ahc->platform_data->eh_done, 5 * HZ)) {
 			printf("Timer Expired\n");
 			retval = FAILED;
 		}
+		printf("Recovery code awake\n");
 	} else
 		ahc_unlock(ahc, &flags);
 	return (retval);
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.h	2006-01-13 17:55:57.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h	2006-01-31 17:28:42.000000000 +0100
@@ -369,7 +369,7 @@
 
 	spinlock_t		 spin_lock;
 	u_int			 qfrozen;
-	struct semaphore	 eh_sem;
+	struct completion	 eh_done;
 	struct Scsi_Host        *host;		/* pointer to scsi host */
 #define AHC_LINUX_NOIRQ	((uint32_t)~0)
 	uint32_t		 irq;		/* IRQ for this adapter */
