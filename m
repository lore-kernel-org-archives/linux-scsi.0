From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: PROBLEM: aic7xxx can hang PC on SMP kernel 2.4.22
Date: Thu, 06 Nov 2003 15:25:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1550702704.1068157553@aslan.btc.adaptec.com>
References: <200311062109.58979.simon@munton.demon.co.uk>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from list.adaptec.com ([216.52.22.18]:17054 "EHLO list.adaptec.com")
	by vger.kernel.org with ESMTP id S263846AbTKFWVo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2003 17:21:44 -0500
In-Reply-To: <200311062109.58979.simon@munton.demon.co.uk>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Simon Munton <simon@munton.demon.co.uk>, linux-scsi@vger.kernel.org

> Hi
> 
> I've recently had a problem of my PC freezing when using my scsi scanner via 
> the aic7xxx driver. It only occurs when built for SMP,and is triggered by the 
> scanner returning busy status.

...

The attached patch should fix this for you.  It is included in the latest
driver source that I will be uploading in a moment to my website.  RPMs
and DUDs will follow as soon as the build completes.

--
Justin

==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#191 - /home/gibbs/mod_devel/scsi/aic7xxx/aic79xx_osm.c ====
--- /tmp/tmp.27544.0	2003-11-06 15:19:52.000000000 -0700
+++ /home/gibbs/mod_devel/scsi/aic7xxx/aic79xx_osm.c	2003-11-06 15:10:19.000000000 -0700
@@ -1215,8 +1215,7 @@
 	 && (dev->flags & AIC_DEV_SLAVE_CONFIGURED) != 0) {
 		dev->flags |= AIC_DEV_UNCONFIGURED;
 		if (TAILQ_EMPTY(&dev->busyq)
-		 && dev->active == 0
-		 && (dev->flags & AIC_DEV_TIMER_ACTIVE) == 0)
+		 && dev->active == 0)
 			ahd_linux_free_device(ahd, dev);
 	}
 	ahd_midlayer_entrypoint_unlock(ahd, &flags);
@@ -2250,6 +2249,7 @@
 					if (targ->devices[j] == NULL)
 						continue;
 					dev = targ->devices[j];
+					del_timer_sync(&dev->timer);
 					ahd_linux_free_device(ahd, dev);
 				}
 				/*
@@ -4501,8 +4501,7 @@
 
 	if (TAILQ_EMPTY(&dev->busyq)) {
 		if ((dev->flags & AIC_DEV_UNCONFIGURED) != 0
-		 && dev->active == 0
-		 && (dev->flags & AIC_DEV_TIMER_ACTIVE) == 0)
+		 && dev->active == 0)
 			ahd_linux_free_device(ahd, dev);
 	} else if ((dev->flags & AIC_DEV_ON_RUN_LIST) == 0) {
 		TAILQ_INSERT_TAIL(&ahd->platform_data->device_runq, dev, links);
@@ -5024,6 +5023,7 @@
 	 && (dev->flags & AIC_DEV_ON_RUN_LIST) == 0)
 		ahd_linux_run_device_queue(ahd, dev);
 	if ((dev->flags & AIC_DEV_UNCONFIGURED) != 0
+	 && TAILQ_EMPTY(&dev->busyq)
 	 && dev->active == 0)
 		ahd_linux_free_device(ahd, dev);
 	ahd_unlock(ahd, &s);
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#254 - /home/gibbs/mod_devel/scsi/aic7xxx/aic7xxx_osm.c ====
--- /tmp/tmp.27544.1	2003-11-06 15:19:52.000000000 -0700
+++ /home/gibbs/mod_devel/scsi/aic7xxx/aic7xxx_osm.c	2003-11-06 15:11:24.000000000 -0700
@@ -1217,8 +1217,7 @@
 	 && (dev->flags & AIC_DEV_SLAVE_CONFIGURED) != 0) {
 		dev->flags |= AIC_DEV_UNCONFIGURED;
 		if (TAILQ_EMPTY(&dev->busyq)
-		 && dev->active == 0
-	 	 && (dev->flags & AIC_DEV_TIMER_ACTIVE) == 0)
+		 && dev->active == 0)
 			ahc_linux_free_device(ahc, dev);
 	}
 	ahc_midlayer_entrypoint_unlock(ahc, &flags);
@@ -1928,6 +1927,7 @@
 					if (targ->devices[j] == NULL)
 						continue;
 					dev = targ->devices[j];
+					del_timer_sync(&dev->timer);
 					ahc_linux_free_device(ahc, dev);
 				}
 				/*
@@ -3950,7 +3950,7 @@
 {
 	struct aic_linux_target *targ;
 
-	del_timer_sync(&dev->timer);
+	del_timer(&dev->timer);
 	targ = dev->target;
 	targ->devices[dev->lun] = NULL;
 	free(dev, M_DEVBUF);
@@ -4203,8 +4203,7 @@
 
 	if (TAILQ_EMPTY(&dev->busyq)) {
 		if ((dev->flags & AIC_DEV_UNCONFIGURED) != 0
-		 && dev->active == 0
-	 	 && (dev->flags & AIC_DEV_TIMER_ACTIVE) == 0)
+		 && dev->active == 0)
 			ahc_linux_free_device(ahc, dev);
 	} else if ((dev->flags & AIC_DEV_ON_RUN_LIST) == 0) {
 		TAILQ_INSERT_TAIL(&ahc->platform_data->device_runq, dev, links);
@@ -4679,7 +4678,8 @@
 	if (dev->qfrozen == 0
 	 && (dev->flags & AIC_DEV_ON_RUN_LIST) == 0)
 		ahc_linux_run_device_queue(ahc, dev);
-	if (TAILQ_EMPTY(&dev->busyq)
+	if ((dev->flags & AIC_DEV_UNCONFIGURED) != 0
+	 && TAILQ_EMPTY(&dev->busyq)
 	 && dev->active == 0)
 		ahc_linux_free_device(ahc, dev);
 	ahc_unlock(ahc, &s);

