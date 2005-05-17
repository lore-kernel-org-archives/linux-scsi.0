From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic7xxx: make correct use of slave_alloc/destroy and
	remove the per device timer
Date: Tue, 17 May 2005 13:07:34 -0500
Message-ID: <1116353255.4989.30.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:27084 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261979AbVEQSHi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2005 14:07:38 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j4HI7aA02739
	for <linux-scsi@vger.kernel.org>; Tue, 17 May 2005 14:07:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

The allocation of all of our components should be done in slave alloc.
Currently it's rather fancifully refcounted in the queuecommand
callback.  This patch moves allocation and destroy to their correct
places in slave_alloc/slave_destory.  Now we can guarantee that
everywhere a device is requested, it's actually been allocated, so don't
check for this anymore.

Additionally, the per device busy timer was the only source of potential
use after free.  It's been deleted because Linux does the correct thing
with busy returns, so there's no need to implement a separate timer in
the driver.

Finally, implement code that forces all the device parameters to zero
(i.e. async and narrow) in the slave alloc, inform the spi class of the
bios recorded maximums and wait until slave configure before trying
anything more adventurous.

James

--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -430,7 +430,6 @@ static void ahc_linux_queue_cmd_complete
 static void ahc_linux_sem_timeout(u_long arg);
 static void ahc_linux_freeze_simq(struct ahc_softc *ahc);
 static void ahc_linux_release_simq(u_long arg);
-static void ahc_linux_dev_timed_unfreeze(u_long arg);
 static int  ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag);
 static void ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc);
 static u_int ahc_linux_user_tagdepth(struct ahc_softc *ahc,
@@ -457,7 +456,7 @@ static int  ahc_linux_next_unit(void);
 /********************************* Inlines ************************************/
 static __inline struct ahc_linux_device*
 		     ahc_linux_get_device(struct ahc_softc *ahc, u_int channel,
-					  u_int target, u_int lun, int alloc);
+					  u_int target, u_int lun);
 static __inline void ahc_linux_unmap_scb(struct ahc_softc*, struct scb*);
 
 static __inline int ahc_linux_map_seg(struct ahc_softc *ahc, struct scb *scb,
@@ -466,7 +465,7 @@ static __inline int ahc_linux_map_seg(st
 
 static __inline struct ahc_linux_device*
 ahc_linux_get_device(struct ahc_softc *ahc, u_int channel, u_int target,
-		     u_int lun, int alloc)
+		     u_int lun)
 {
 	struct ahc_linux_target *targ;
 	struct ahc_linux_device *dev;
@@ -476,18 +475,9 @@ ahc_linux_get_device(struct ahc_softc *a
 	if (channel != 0)
 		target_offset += 8;
 	targ = ahc->platform_data->targets[target_offset];
-	if (targ == NULL) {
-		if (alloc != 0) {
-			targ = ahc_linux_alloc_target(ahc, channel, target);
-			if (targ == NULL)
-				return (NULL);
-		} else
-			return (NULL);
-	}
+	BUG_ON(targ == NULL);
 	dev = targ->devices[lun];
-	if (dev == NULL && alloc != 0)
-		dev = ahc_linux_alloc_device(ahc, targ, lun);
-	return (dev);
+	return dev;
 }
 
 static __inline void
@@ -640,7 +630,7 @@ ahc_linux_queue(struct scsi_cmnd * cmd, 
 		return SCSI_MLQUEUE_HOST_BUSY;
 
 	dev = ahc_linux_get_device(ahc, cmd->device->channel, cmd->device->id,
-				   cmd->device->lun, /*alloc*/TRUE);
+				   cmd->device->lun);
 	BUG_ON(dev == NULL);
 
 	cmd->result = CAM_REQ_INPROG << 16;
@@ -652,11 +642,69 @@ static int
 ahc_linux_slave_alloc(struct scsi_device *device)
 {
 	struct	ahc_softc *ahc;
+	struct ahc_linux_target *targ;
+	struct scsi_target *starget = device->sdev_target;
+	struct ahc_linux_device *dev;
+	u_int target_offset;
+
+	target_offset = starget->id;
+	if (starget->channel != 0)
+		target_offset += 8;
 
 	ahc = *((struct ahc_softc **)device->host->hostdata);
 	if (bootverbose)
 		printf("%s: Slave Alloc %d\n", ahc_name(ahc), device->id);
-	return (0);
+	targ = ahc->platform_data->targets[target_offset];
+	if (targ == NULL) {
+		targ = ahc_linux_alloc_target(ahc, starget->channel, starget->id);
+		struct seeprom_config *sc = ahc->seep_config;
+		if (targ == NULL)
+			return -ENOMEM;
+		if (sc) {
+			unsigned short scsirate;
+			struct ahc_devinfo devinfo;
+			struct ahc_initiator_tinfo *tinfo;
+			struct ahc_tmode_tstate *tstate;
+			char channel = starget->channel + 'A';
+			unsigned int our_id = ahc->our_id;
+
+			if (starget->channel)
+				our_id = ahc->our_id_b;
+
+			if ((ahc->features & AHC_ULTRA2) != 0) {
+				scsirate = sc->device_flags[target_offset] & CFXFER;
+			} else {
+				scsirate = (sc->device_flags[target_offset] & CFXFER) << 4;
+				if (sc->device_flags[target_offset] & CFSYNCH)
+					scsirate |= SOFS;
+			}
+			if (sc->device_flags[target_offset] & CFWIDEB) {
+				scsirate |= WIDEXFER;
+				spi_max_width(starget) = 1;
+			} else
+				spi_max_width(starget) = 0;
+			spi_min_period(starget) = 
+				ahc_find_period(ahc, scsirate, AHC_SYNCRATE_DT);
+			tinfo = ahc_fetch_transinfo(ahc, channel, ahc->our_id,
+						    targ->target, &tstate);
+			ahc_compile_devinfo(&devinfo, our_id, targ->target,
+					    CAM_LUN_WILDCARD, channel,
+					    ROLE_INITIATOR);
+			ahc_set_syncrate(ahc, &devinfo, NULL, 0, 0, 0,
+					 AHC_TRANS_GOAL, /*paused*/FALSE);
+			ahc_set_width(ahc, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
+				      AHC_TRANS_GOAL, /*paused*/FALSE);
+		}
+			
+	}
+	dev = targ->devices[device->lun];
+	if (dev == NULL) {
+		dev = ahc_linux_alloc_device(ahc, targ, device->lun);
+		if (dev == NULL)
+			return -ENOMEM;
+	}
+
+	return 0;
 }
 
 static int
@@ -666,27 +714,20 @@ ahc_linux_slave_configure(struct scsi_de
 	struct	ahc_linux_device *dev;
 
 	ahc = *((struct ahc_softc **)device->host->hostdata);
+
 	if (bootverbose)
 		printf("%s: Slave Configure %d\n", ahc_name(ahc), device->id);
-	/*
-	 * Since Linux has attached to the device, configure
-	 * it so we don't free and allocate the device
-	 * structure on every command.
-	 */
-	dev = ahc_linux_get_device(ahc, device->channel,
-				   device->id, device->lun,
-				   /*alloc*/TRUE);
-	if (dev != NULL) {
-		dev->flags &= ~AHC_DEV_UNCONFIGURED;
-		dev->scsi_device = device;
-		ahc_linux_device_queue_depth(ahc, dev);
-	}
+
+	dev = ahc_linux_get_device(ahc, device->channel, device->id,
+				   device->lun);
+	dev->scsi_device = device;
+	ahc_linux_device_queue_depth(ahc, dev);
 
 	/* Initial Domain Validation */
 	if (!spi_initial_dv(device->sdev_target))
 		spi_dv_device(device);
 
-	return (0);
+	return 0;
 }
 
 static void
@@ -699,22 +740,11 @@ ahc_linux_slave_destroy(struct scsi_devi
 	if (bootverbose)
 		printf("%s: Slave Destroy %d\n", ahc_name(ahc), device->id);
 	dev = ahc_linux_get_device(ahc, device->channel,
-				   device->id, device->lun,
-					   /*alloc*/FALSE);
-	/*
-	 * Filter out "silly" deletions of real devices by only
-	 * deleting devices that have had slave_configure()
-	 * called on them.  All other devices that have not
-	 * been configured will automatically be deleted by
-	 * the refcounting process.
-	 */
-	if (dev != NULL
-	 && (dev->flags & AHC_DEV_SLAVE_CONFIGURED) != 0) {
-		dev->flags |= AHC_DEV_UNCONFIGURED;
-		if (dev->active == 0
-	 	 && (dev->flags & AHC_DEV_TIMER_ACTIVE) == 0)
-			ahc_linux_free_device(ahc, dev);
-	}
+				   device->id, device->lun);
+
+	BUG_ON(dev->active);
+
+	ahc_linux_free_device(ahc, dev);
 }
 
 #if defined(__i386__)
@@ -1361,7 +1391,7 @@ ahc_platform_set_tags(struct ahc_softc *
 
 	dev = ahc_linux_get_device(ahc, devinfo->channel - 'A',
 				   devinfo->target,
-				   devinfo->lun, /*alloc*/FALSE);
+				   devinfo->lun);
 	if (dev == NULL)
 		return;
 	was_queuing = dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED);
@@ -1793,8 +1823,6 @@ ahc_linux_alloc_device(struct ahc_softc 
 	if (dev == NULL)
 		return (NULL);
 	memset(dev, 0, sizeof(*dev));
-	init_timer(&dev->timer);
-	dev->flags = AHC_DEV_UNCONFIGURED;
 	dev->lun = lun;
 	dev->target = targ;
 
@@ -1817,7 +1845,7 @@ ahc_linux_alloc_device(struct ahc_softc 
 }
 
 static void
-__ahc_linux_free_device(struct ahc_softc *ahc, struct ahc_linux_device *dev)
+ahc_linux_free_device(struct ahc_softc *ahc, struct ahc_linux_device *dev)
 {
 	struct ahc_linux_target *targ;
 
@@ -1829,13 +1857,6 @@ __ahc_linux_free_device(struct ahc_softc
 		ahc_linux_free_target(ahc, targ);
 }
 
-static void
-ahc_linux_free_device(struct ahc_softc *ahc, struct ahc_linux_device *dev)
-{
-	del_timer_sync(&dev->timer);
-	__ahc_linux_free_device(ahc, dev);
-}
-
 void
 ahc_send_async(struct ahc_softc *ahc, char channel,
 	       u_int target, u_int lun, ac_code code, void *arg)
@@ -2008,8 +2029,6 @@ ahc_done(struct ahc_softc *ahc, struct s
 		}
 	} else if (ahc_get_transaction_status(scb) == CAM_SCSI_STATUS_ERROR) {
 		ahc_linux_handle_scsi_status(ahc, dev, scb);
-	} else if (ahc_get_transaction_status(scb) == CAM_SEL_TIMEOUT) {
-		dev->flags |= AHC_DEV_UNCONFIGURED;
 	}
 
 	if (dev->openings == 1
@@ -2031,11 +2050,6 @@ ahc_done(struct ahc_softc *ahc, struct s
 	if (dev->active == 0)
 		dev->commands_since_idle_or_otag = 0;
 
-	if ((dev->flags & AHC_DEV_UNCONFIGURED) != 0
-	    && dev->active == 0
-	    && (dev->flags & AHC_DEV_TIMER_ACTIVE) == 0)
-		ahc_linux_free_device(ahc, dev);
-
 	if ((scb->flags & SCB_RECOVERY_SCB) != 0) {
 		printf("Recovery SCB completes\n");
 		if (ahc_get_transaction_status(scb) == CAM_BDR_SENT
@@ -2174,27 +2188,6 @@ ahc_linux_handle_scsi_status(struct ahc_
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
@@ -2326,24 +2319,6 @@ ahc_linux_release_simq(u_long arg)
 		scsi_unblock_requests(ahc->platform_data->host);
 }
 
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
-	if (dev->active == 0)
-		__ahc_linux_free_device(ahc, dev);
-	ahc_unlock(ahc, &s);
-}
-
 static int
 ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 {
@@ -2384,7 +2359,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	 * command, return success.
 	 */
 	dev = ahc_linux_get_device(ahc, cmd->device->channel, cmd->device->id,
-				   cmd->device->lun, /*alloc*/FALSE);
+				   cmd->device->lun);
 
 	if (dev == NULL) {
 		/*
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -322,13 +322,10 @@ struct ahc_cmd {
  */
 TAILQ_HEAD(ahc_busyq, ahc_cmd);
 typedef enum {
-	AHC_DEV_UNCONFIGURED	 = 0x01,
 	AHC_DEV_FREEZE_TIL_EMPTY = 0x02, /* Freeze queue until active == 0 */
-	AHC_DEV_TIMER_ACTIVE	 = 0x04, /* Our timer is active */
 	AHC_DEV_Q_BASIC		 = 0x10, /* Allow basic device queuing */
 	AHC_DEV_Q_TAGGED	 = 0x20, /* Allow full SCSI2 command queueing */
 	AHC_DEV_PERIODIC_OTAG	 = 0x40, /* Send OTAG to prevent starvation */
-	AHC_DEV_SLAVE_CONFIGURED = 0x80	 /* slave_configure() has been called */
 } ahc_linux_dev_flags;
 
 struct ahc_linux_target;
@@ -374,11 +371,6 @@ struct ahc_linux_device {
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


