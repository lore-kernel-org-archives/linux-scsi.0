From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 5/4] aic79xx: remove the last vestiges of the runq
Date: Sun, 29 May 2005 12:54:49 -0400
Message-ID: <4299F3D9.3050405@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020301050803000601000104"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:28903 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261213AbVE2Qyx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 May 2005 12:54:53 -0400
Received: from cpe-065-184-065-144.nc.res.rr.com ([65.184.65.144] helo=[10.10.10.88])
	by mail.dvmed.net with esmtpsa (Exim 4.51 #1 (Red Hat Linux))
	id 1DcR3s-0003W9-Cl
	for linux-scsi@vger.kernel.org; Sun, 29 May 2005 16:54:52 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020301050803000601000104
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


Next patch in the aic series...  this one should have been posted with 
the last 4-part patch series.

Do not apply, only for review.



--------------020301050803000601000104
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

author Jeff Garzik <jgarzik@pobox.com> Sun, 29 May 2005 12:22:46 -0400
committer Jeff Garzik <jgarzik@pobox.com> Sun, 29 May 2005 12:22:46 -0400

[SCSI] aic79xx: remove the last vestiges of the runq

This was rendered obsolete by the busyq removal; remove some of the last
remnants of its presence.

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1796,7 +1796,6 @@ ahd_platform_alloc(struct ahd_softc *ahd
 		return (ENOMEM);
 	memset(ahd->platform_data, 0, sizeof(struct ahd_platform_data));
 	TAILQ_INIT(&ahd->platform_data->completeq);
-	TAILQ_INIT(&ahd->platform_data->device_runq);
 	ahd->platform_data->irq = AHD_LINUX_NOIRQ;
 	ahd->platform_data->hw_dma_mask = 0xFFFFFFFF;
 	ahd_lockinit(ahd);
@@ -3923,10 +3922,6 @@ ahd_done(struct ahd_softc *ahd, struct s
 	    && dev->active == 0
 	    && (dev->flags & AHD_DEV_TIMER_ACTIVE) == 0)
 		ahd_linux_free_device(ahd, dev);
-	else if ((dev->flags & AHD_DEV_ON_RUN_LIST) == 0) {
-		TAILQ_INSERT_TAIL(&ahd->platform_data->device_runq, dev, links);
-		dev->flags |= AHD_DEV_ON_RUN_LIST;
-	}
 
 	if ((scb->flags & SCB_RECOVERY_SCB) != 0) {
 		printf("Recovery SCB completes\n");
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -315,7 +315,6 @@ typedef enum {
 	AHD_DEV_UNCONFIGURED	 = 0x01,
 	AHD_DEV_FREEZE_TIL_EMPTY = 0x02, /* Freeze queue until active == 0 */
 	AHD_DEV_TIMER_ACTIVE	 = 0x04, /* Our timer is active */
-	AHD_DEV_ON_RUN_LIST	 = 0x08, /* Queued to be run later */
 	AHD_DEV_Q_BASIC		 = 0x10, /* Allow basic device queuing */
 	AHD_DEV_Q_TAGGED	 = 0x20, /* Allow full SCSI2 command queueing */
 	AHD_DEV_PERIODIC_OTAG	 = 0x40, /* Send OTAG to prevent starvation */
@@ -503,7 +502,6 @@ struct ahd_platform_data {
 	 * Fields accessed from interrupt context.
 	 */
 	struct ahd_linux_target *targets[AHD_NUM_TARGETS]; 
-	TAILQ_HEAD(, ahd_linux_device) device_runq;
 	struct ahd_completeq	 completeq;
 
 	spinlock_t		 spin_lock;

--------------020301050803000601000104--
