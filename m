From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic7xxx: remove the last vestiges of the runq
Date: Mon, 16 May 2005 16:37:58 -0500
Message-ID: <1116279478.5040.48.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:5299 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261889AbVEPViI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 17:38:08 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j4GLc1A25418
	for <linux-scsi@vger.kernel.org>; Mon, 16 May 2005 17:38:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This was rendered obsolete by the busyq removal; remove some of the last
remnants of its presence.

James

--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1332,7 +1332,6 @@ ahc_platform_alloc(struct ahc_softc *ahc
 		return (ENOMEM);
 	memset(ahc->platform_data, 0, sizeof(struct ahc_platform_data));
 	TAILQ_INIT(&ahc->platform_data->completeq);
-	TAILQ_INIT(&ahc->platform_data->device_runq);
 	ahc->platform_data->irq = AHC_LINUX_NOIRQ;
 	ahc_lockinit(ahc);
 	init_timer(&ahc->platform_data->completeq_timer);
@@ -2107,10 +2106,6 @@ ahc_done(struct ahc_softc *ahc, struct s
 	    && dev->active == 0
 	    && (dev->flags & AHC_DEV_TIMER_ACTIVE) == 0)
 		ahc_linux_free_device(ahc, dev);
-	else if ((dev->flags & AHC_DEV_ON_RUN_LIST) == 0) {
-		TAILQ_INSERT_TAIL(&ahc->platform_data->device_runq, dev, links);
-		dev->flags |= AHC_DEV_ON_RUN_LIST;
-	}
 
 	if ((scb->flags & SCB_RECOVERY_SCB) != 0) {
 		printf("Recovery SCB completes\n");
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -325,7 +325,6 @@ typedef enum {
 	AHC_DEV_UNCONFIGURED	 = 0x01,
 	AHC_DEV_FREEZE_TIL_EMPTY = 0x02, /* Freeze queue until active == 0 */
 	AHC_DEV_TIMER_ACTIVE	 = 0x04, /* Our timer is active */
-	AHC_DEV_ON_RUN_LIST	 = 0x08, /* Queued to be run later */
 	AHC_DEV_Q_BASIC		 = 0x10, /* Allow basic device queuing */
 	AHC_DEV_Q_TAGGED	 = 0x20, /* Allow full SCSI2 command queueing */
 	AHC_DEV_PERIODIC_OTAG	 = 0x40, /* Send OTAG to prevent starvation */
@@ -466,7 +465,6 @@ struct ahc_platform_data {
 	 * Fields accessed from interrupt context.
 	 */
 	struct ahc_linux_target *targets[AHC_NUM_TARGETS]; 
-	TAILQ_HEAD(, ahc_linux_device) device_runq;
 	struct ahc_completeq	 completeq;
 
 	spinlock_t		 spin_lock;


