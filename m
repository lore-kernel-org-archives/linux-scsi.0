From: akpm@osdl.org
Subject: [patch 1/3] aic7xxx deadlock fix
Date: Mon, 26 Apr 2004 22:01:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404270501.i3R51V207721@mail.osdl.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:53673 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263467AbUD0FBg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 01:01:36 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: gibbs@scsiguy.com, linux-scsi@vger.kernel.org, akpm@osdl.org



We cannot call del_timer_sync() from within that timer's handler function!


---

 25-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7xxx-deadlock-fix drivers/scsi/aic7xxx/aic7xxx_osm.c
--- 25/drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7xxx-deadlock-fix	2004-04-25 23:09:28.575737936 -0700
+++ 25-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-04-25 23:09:28.581737024 -0700
@@ -3980,11 +3980,10 @@ ahc_linux_alloc_device(struct ahc_softc 
 }
 
 static void
-ahc_linux_free_device(struct ahc_softc *ahc, struct ahc_linux_device *dev)
+__ahc_linux_free_device(struct ahc_softc *ahc, struct ahc_linux_device *dev)
 {
 	struct ahc_linux_target *targ;
 
-	del_timer_sync(&dev->timer);
 	targ = dev->target;
 	targ->devices[dev->lun] = NULL;
 	free(dev, M_DEVBUF);
@@ -3994,6 +3993,13 @@ ahc_linux_free_device(struct ahc_softc *
 		ahc_linux_free_target(ahc, targ);
 }
 
+static void
+ahc_linux_free_device(struct ahc_softc *ahc, struct ahc_linux_device *dev)
+{
+	del_timer_sync(&dev->timer);
+	__ahc_linux_free_device(ahc, dev);
+}
+
 void
 ahc_send_async(struct ahc_softc *ahc, char channel,
 	       u_int target, u_int lun, ac_code code, void *arg)
@@ -4704,7 +4710,7 @@ ahc_linux_dev_timed_unfreeze(u_long arg)
 		ahc_linux_run_device_queue(ahc, dev);
 	if (TAILQ_EMPTY(&dev->busyq)
 	 && dev->active == 0)
-		ahc_linux_free_device(ahc, dev);
+		__ahc_linux_free_device(ahc, dev);
 	ahc_unlock(ahc, &s);
 }
 

_
