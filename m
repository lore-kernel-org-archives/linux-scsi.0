From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] aic7xxx: semaphore to completion conversion
Date: Mon, 6 Feb 2006 15:40:45 +0100
Message-ID: <20060206144045.GA2992@lst.de>
References: <20060131172018.GD28889@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:24542 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932127AbWBFOkw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 09:40:52 -0500
Content-Disposition: inline
In-Reply-To: <20060131172018.GD28889@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, hare@suse.de, emmanuel.fuste@laposte.net
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 31, 2006 at 06:20:18PM +0100, Christoph Hellwig wrote:
> switch eh_sem to a completion.  due to wait_for_completion_timeout this
> also nicely simplifies the code.  Unfortunately it's untested, so if
> someone with the hardware could give it a try that would be nice.  Once
> it works the same thing can be applied to aic79xx.

New version that switches to the common onstack completion and just a
pointer in the platform_data struct idiom.  This gets rid of all the
flags fiddling.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c	2006-01-15 21:45:28.000000000 +0100
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c	2006-02-06 15:27:21.000000000 +0100
@@ -373,7 +373,6 @@
 					 struct scb *);
 static void ahc_linux_queue_cmd_complete(struct ahc_softc *ahc,
 					 struct scsi_cmnd *cmd);
-static void ahc_linux_sem_timeout(u_long arg);
 static void ahc_linux_freeze_simq(struct ahc_softc *ahc);
 static void ahc_linux_release_simq(struct ahc_softc *ahc);
 static int  ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag);
@@ -1193,7 +1192,6 @@
 	memset(ahc->platform_data, 0, sizeof(struct ahc_platform_data));
 	ahc->platform_data->irq = AHC_LINUX_NOIRQ;
 	ahc_lockinit(ahc);
-	init_MUTEX_LOCKED(&ahc->platform_data->eh_sem);
 	ahc->seltime = (aic7xxx_seltime & 0x3) << 4;
 	ahc->seltime_b = (aic7xxx_seltime & 0x3) << 4;
 	if (aic7xxx_pci_parity == 0)
@@ -1830,10 +1828,9 @@
 		if (ahc_get_transaction_status(scb) == CAM_BDR_SENT
 		 || ahc_get_transaction_status(scb) == CAM_REQ_ABORTED)
 			ahc_set_transaction_status(scb, CAM_CMD_TIMEOUT);
-		if ((ahc->platform_data->flags & AHC_UP_EH_SEMAPHORE) != 0) {
-			ahc->platform_data->flags &= ~AHC_UP_EH_SEMAPHORE;
-			up(&ahc->platform_data->eh_sem);
-		}
+
+		if (ahc->platform_data->eh_done)
+			complete(ahc->platform_data->eh_done);
 	}
 
 	ahc_free_scb(ahc, scb);
@@ -2040,22 +2037,6 @@
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
@@ -2355,25 +2336,21 @@
 	if (paused)
 		ahc_unpause(ahc);
 	if (wait) {
-		struct timer_list timer;
-		int ret;
+		DECLARE_COMPLETION(done);
 
-		ahc->platform_data->flags |= AHC_UP_EH_SEMAPHORE;
+		ahc->platform_data->eh_done = &done;
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
+		if (!wait_for_completion_timeout(&done, 5 * HZ)) {
+			ahc_lock(ahc, &flags);
+			ahc->platform_data->eh_done = NULL;
+			ahc_unlock(ahc, &flags);
+
 			printf("Timer Expired\n");
 			retval = FAILED;
 		}
+		printf("Recovery code awake\n");
 	} else
 		ahc_unlock(ahc, &flags);
 	return (retval);
Index: linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.h	2006-01-15 21:45:28.000000000 +0100
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h	2006-02-06 15:32:22.000000000 +0100
@@ -369,15 +369,12 @@
 
 	spinlock_t		 spin_lock;
 	u_int			 qfrozen;
-	struct semaphore	 eh_sem;
+	struct completion	*eh_done;
 	struct Scsi_Host        *host;		/* pointer to scsi host */
 #define AHC_LINUX_NOIRQ	((uint32_t)~0)
 	uint32_t		 irq;		/* IRQ for this adapter */
 	uint32_t		 bios_address;
 	uint32_t		 mem_busaddr;	/* Mem Base Addr */
-
-#define	AHC_UP_EH_SEMAPHORE	 0x1
-	uint32_t		 flags;
 };
 
 /************************** OS Utility Wrappers *******************************/
