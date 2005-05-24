From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic7xxx: remove separate target and device allocations
Date: Tue, 24 May 2005 17:15:43 -0500
Message-ID: <1116972943.7710.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:47580 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262202AbVEXWPq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 18:15:46 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j4OMFiA04793
	for <linux-scsi@vger.kernel.org>; Tue, 24 May 2005 18:15:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Since the aic driver is now taught to speak in terms of the generic
linux devices, we can now also dispense with the transport class get
routines (since we update the parameters when the driver sees they
change) and also plumb it into the spi transport transfer agreement
reporting infrastructure.

James

---

 aic7xxx_osm.c  |  574 ++++++++++++++++++++-------------------------------------
 aic7xxx_osm.h  |   15 -
 aic7xxx_proc.c |   21 +-
 3 files changed, 219 insertions(+), 391 deletions(-)


--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -122,8 +122,6 @@
 #include "aic7xxx_osm.h"
 #include "aic7xxx_inline.h"
 #include <scsi/scsicam.h>
-#include <scsi/scsi_transport.h>
-#include <scsi/scsi_transport_spi.h>
 
 static struct scsi_transport_template *ahc_linux_transport_template = NULL;
 
@@ -423,7 +421,7 @@ MODULE_PARM_DESC(aic7xxx,
 );
 
 static void ahc_linux_handle_scsi_status(struct ahc_softc *,
-					 struct ahc_linux_device *,
+					 struct scsi_device *,
 					 struct scb *);
 static void ahc_linux_queue_cmd_complete(struct ahc_softc *ahc,
 					 struct scsi_cmnd *cmd);
@@ -434,17 +432,7 @@ static int  ahc_linux_queue_recovery_cmd
 static void ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc);
 static u_int ahc_linux_user_tagdepth(struct ahc_softc *ahc,
 				     struct ahc_devinfo *devinfo);
-static void ahc_linux_device_queue_depth(struct ahc_softc *ahc,
-					 struct ahc_linux_device *dev);
-static struct ahc_linux_target*	ahc_linux_alloc_target(struct ahc_softc*,
-						       u_int, u_int);
-static void			ahc_linux_free_target(struct ahc_softc*,
-						      struct ahc_linux_target*);
-static struct ahc_linux_device*	ahc_linux_alloc_device(struct ahc_softc*,
-						       struct ahc_linux_target*,
-						       u_int);
-static void			ahc_linux_free_device(struct ahc_softc*,
-						      struct ahc_linux_device*);
+static void ahc_linux_device_queue_depth(struct scsi_device *);
 static int ahc_linux_run_command(struct ahc_softc*,
 				 struct ahc_linux_device *,
 				 struct scsi_cmnd *);
@@ -454,32 +442,12 @@ static int  aic7xxx_setup(char *s);
 static int  ahc_linux_next_unit(void);
 
 /********************************* Inlines ************************************/
-static __inline struct ahc_linux_device*
-		     ahc_linux_get_device(struct ahc_softc *ahc, u_int channel,
-					  u_int target, u_int lun);
 static __inline void ahc_linux_unmap_scb(struct ahc_softc*, struct scb*);
 
 static __inline int ahc_linux_map_seg(struct ahc_softc *ahc, struct scb *scb,
 		 		      struct ahc_dma_seg *sg,
 				      dma_addr_t addr, bus_size_t len);
 
-static __inline struct ahc_linux_device*
-ahc_linux_get_device(struct ahc_softc *ahc, u_int channel, u_int target,
-		     u_int lun)
-{
-	struct ahc_linux_target *targ;
-	struct ahc_linux_device *dev;
-	u_int target_offset;
-
-	target_offset = target;
-	if (channel != 0)
-		target_offset += 8;
-	targ = ahc->platform_data->targets[target_offset];
-	BUG_ON(targ == NULL);
-	dev = targ->devices[lun];
-	return dev;
-}
-
 static __inline void
 ahc_linux_unmap_scb(struct ahc_softc *ahc, struct scb *scb)
 {
@@ -611,7 +579,7 @@ static int
 ahc_linux_queue(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd *))
 {
 	struct	 ahc_softc *ahc;
-	struct	 ahc_linux_device *dev;
+	struct	 ahc_linux_device *dev = scsi_transport_device_data(cmd->device);
 
 	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
 
@@ -629,129 +597,162 @@ ahc_linux_queue(struct scsi_cmnd * cmd, 
 	if (ahc->platform_data->qfrozen != 0)
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	dev = ahc_linux_get_device(ahc, cmd->device->channel, cmd->device->id,
-				   cmd->device->lun);
-	BUG_ON(dev == NULL);
-
 	cmd->result = CAM_REQ_INPROG << 16;
 
 	return ahc_linux_run_command(ahc, dev, cmd);
 }
 
-static int
-ahc_linux_slave_alloc(struct scsi_device *device)
+static inline struct scsi_target **
+ahc_linux_target_in_softc(struct scsi_target *starget)
 {
-	struct	ahc_softc *ahc;
-	struct ahc_linux_target *targ;
-	struct scsi_target *starget = device->sdev_target;
-	struct ahc_linux_device *dev;
+	struct	ahc_softc *ahc =
+		*((struct ahc_softc **)dev_to_shost(&starget->dev)->hostdata);
 	unsigned int target_offset;
+
+	target_offset = starget->id;
+	if (starget->channel != 0)
+		target_offset += 8;
+
+	return &ahc->platform_data->starget[target_offset];
+}
+
+static int
+ahc_linux_target_alloc(struct scsi_target *starget)
+{
+	struct	ahc_softc *ahc =
+		*((struct ahc_softc **)dev_to_shost(&starget->dev)->hostdata);
+	struct seeprom_config *sc = ahc->seep_config;
 	unsigned long flags;
-	int retval = -ENOMEM;
+	struct scsi_target **ahc_targp = ahc_linux_target_in_softc(starget);
+	struct ahc_linux_target *targ = scsi_transport_target_data(starget);
+	unsigned short scsirate;
+	struct ahc_devinfo devinfo;
+	struct ahc_initiator_tinfo *tinfo;
+	struct ahc_tmode_tstate *tstate;
+	char channel = starget->channel + 'A';
+	unsigned int our_id = ahc->our_id;
+	unsigned int target_offset;
 
 	target_offset = starget->id;
 	if (starget->channel != 0)
 		target_offset += 8;
+	  
+	if (starget->channel)
+		our_id = ahc->our_id_b;
 
-	ahc = *((struct ahc_softc **)device->host->hostdata);
-	if (bootverbose)
-		printf("%s: Slave Alloc %d\n", ahc_name(ahc), device->id);
 	ahc_lock(ahc, &flags);
-	targ = ahc->platform_data->targets[target_offset];
-	if (targ == NULL) {
-		targ = ahc_linux_alloc_target(ahc, starget->channel, starget->id);
-		struct seeprom_config *sc = ahc->seep_config;
-		if (targ == NULL)
-			goto out;
 
-		if (sc) {
-			unsigned short scsirate;
-			struct ahc_devinfo devinfo;
-			struct ahc_initiator_tinfo *tinfo;
-			struct ahc_tmode_tstate *tstate;
-			char channel = starget->channel + 'A';
-			unsigned int our_id = ahc->our_id;
+	BUG_ON(*ahc_targp != NULL);
 
-			if (starget->channel)
-				our_id = ahc->our_id_b;
+	*ahc_targp = starget;
+	memset(targ, 0, sizeof(*targ));
 
-			if ((ahc->features & AHC_ULTRA2) != 0) {
-				scsirate = sc->device_flags[target_offset] & CFXFER;
-			} else {
-				scsirate = (sc->device_flags[target_offset] & CFXFER) << 4;
-				if (sc->device_flags[target_offset] & CFSYNCH)
-					scsirate |= SOFS;
-			}
-			if (sc->device_flags[target_offset] & CFWIDEB) {
-				scsirate |= WIDEXFER;
-				spi_max_width(starget) = 1;
-			} else
-				spi_max_width(starget) = 0;
-			spi_min_period(starget) = 
-				ahc_find_period(ahc, scsirate, AHC_SYNCRATE_DT);
-			tinfo = ahc_fetch_transinfo(ahc, channel, ahc->our_id,
-						    targ->target, &tstate);
-			ahc_compile_devinfo(&devinfo, our_id, targ->target,
-					    CAM_LUN_WILDCARD, channel,
-					    ROLE_INITIATOR);
-			ahc_set_syncrate(ahc, &devinfo, NULL, 0, 0, 0,
-					 AHC_TRANS_GOAL, /*paused*/FALSE);
-			ahc_set_width(ahc, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
-				      AHC_TRANS_GOAL, /*paused*/FALSE);
-		}
-			
-	}
-	dev = targ->devices[device->lun];
-	if (dev == NULL) {
-		dev = ahc_linux_alloc_device(ahc, targ, device->lun);
-		if (dev == NULL)
-			goto out;
+	if (sc) {
+		if ((ahc->features & AHC_ULTRA2) != 0) {
+			scsirate = sc->device_flags[target_offset] & CFXFER;
+		} else {
+			scsirate = (sc->device_flags[target_offset] & CFXFER) << 4;
+			if (sc->device_flags[target_offset] & CFSYNCH)
+				scsirate |= SOFS;
+		}
+		if (sc->device_flags[target_offset] & CFWIDEB) {
+			scsirate |= WIDEXFER;
+			spi_max_width(starget) = 1;
+		} else
+			spi_max_width(starget) = 0;
+		spi_min_period(starget) = 
+			ahc_find_period(ahc, scsirate, AHC_SYNCRATE_DT);
+		tinfo = ahc_fetch_transinfo(ahc, channel, ahc->our_id,
+					    starget->id, &tstate);
 	}
-	retval = 0;
-
- out:
+	ahc_compile_devinfo(&devinfo, our_id, starget->id,
+			    CAM_LUN_WILDCARD, channel,
+			    ROLE_INITIATOR);
+	ahc_set_syncrate(ahc, &devinfo, NULL, 0, 0, 0,
+			 AHC_TRANS_GOAL, /*paused*/FALSE);
+	ahc_set_width(ahc, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
+		      AHC_TRANS_GOAL, /*paused*/FALSE);
 	ahc_unlock(ahc, &flags);
-	return retval;
+
+	return 0;
+}
+
+static void
+ahc_linux_target_destroy(struct scsi_target *starget)
+{
+	struct scsi_target **ahc_targp = ahc_linux_target_in_softc(starget);
+
+	*ahc_targp = NULL;
 }
 
 static int
-ahc_linux_slave_configure(struct scsi_device *device)
+ahc_linux_slave_alloc(struct scsi_device *sdev)
+{
+	struct	ahc_softc *ahc =
+		*((struct ahc_softc **)sdev->host->hostdata);
+	struct scsi_target *starget = sdev->sdev_target;
+	struct ahc_linux_target *targ = scsi_transport_target_data(starget);
+	struct ahc_linux_device *dev;
+
+	if (bootverbose)
+		printf("%s: Slave Alloc %d\n", ahc_name(ahc), sdev->id);
+
+	BUG_ON(targ->sdev[sdev->lun] != NULL);
+
+	dev = scsi_transport_device_data(sdev);
+	memset(dev, 0, sizeof(*dev));
+
+	/*
+	 * We start out life using untagged
+	 * transactions of which we allow one.
+	 */
+	dev->openings = 1;
+
+	/*
+	 * Set maxtags to 0.  This will be changed if we
+	 * later determine that we are dealing with
+	 * a tagged queuing capable device.
+	 */
+	dev->maxtags = 0;
+	
+	targ->sdev[sdev->lun] = sdev;
+
+	return 0;
+}
+
+static int
+ahc_linux_slave_configure(struct scsi_device *sdev)
 {
 	struct	ahc_softc *ahc;
-	struct	ahc_linux_device *dev;
 
-	ahc = *((struct ahc_softc **)device->host->hostdata);
+	ahc = *((struct ahc_softc **)sdev->host->hostdata);
 
 	if (bootverbose)
-		printf("%s: Slave Configure %d\n", ahc_name(ahc), device->id);
+		printf("%s: Slave Configure %d\n", ahc_name(ahc), sdev->id);
 
-	dev = ahc_linux_get_device(ahc, device->channel, device->id,
-				   device->lun);
-	dev->scsi_device = device;
-	ahc_linux_device_queue_depth(ahc, dev);
+	ahc_linux_device_queue_depth(sdev);
 
 	/* Initial Domain Validation */
-	if (!spi_initial_dv(device->sdev_target))
-		spi_dv_device(device);
+	if (!spi_initial_dv(sdev->sdev_target))
+		spi_dv_device(sdev);
 
 	return 0;
 }
 
 static void
-ahc_linux_slave_destroy(struct scsi_device *device)
+ahc_linux_slave_destroy(struct scsi_device *sdev)
 {
 	struct	ahc_softc *ahc;
-	struct	ahc_linux_device *dev;
+	struct	ahc_linux_device *dev = scsi_transport_device_data(sdev);
+	struct	ahc_linux_target *targ = scsi_transport_target_data(sdev->sdev_target);
 
-	ahc = *((struct ahc_softc **)device->host->hostdata);
+	ahc = *((struct ahc_softc **)sdev->host->hostdata);
 	if (bootverbose)
-		printf("%s: Slave Destroy %d\n", ahc_name(ahc), device->id);
-	dev = ahc_linux_get_device(ahc, device->channel,
-				   device->id, device->lun);
+		printf("%s: Slave Destroy %d\n", ahc_name(ahc), sdev->id);
 
 	BUG_ON(dev->active);
 
-	ahc_linux_free_device(ahc, dev);
+	targ->sdev[sdev->lun] = NULL;
 }
 
 #if defined(__i386__)
@@ -871,6 +872,8 @@ struct scsi_host_template aic7xxx_driver
 	.slave_alloc		= ahc_linux_slave_alloc,
 	.slave_configure	= ahc_linux_slave_configure,
 	.slave_destroy		= ahc_linux_slave_destroy,
+	.target_alloc		= ahc_linux_target_alloc,
+	.target_destroy		= ahc_linux_target_destroy,
 };
 
 /**************************** Tasklet Handler *********************************/
@@ -1332,8 +1335,7 @@ ahc_platform_alloc(struct ahc_softc *ahc
 void
 ahc_platform_free(struct ahc_softc *ahc)
 {
-	struct ahc_linux_target *targ;
-	struct ahc_linux_device *dev;
+	struct scsi_target *starget;
 	int i, j;
 
 	if (ahc->platform_data != NULL) {
@@ -1344,22 +1346,17 @@ ahc_platform_free(struct ahc_softc *ahc)
 
 		/* destroy all of the device and target objects */
 		for (i = 0; i < AHC_NUM_TARGETS; i++) {
-			targ = ahc->platform_data->targets[i];
-			if (targ != NULL) {
-				/* Keep target around through the loop. */
-				targ->refcount++;
+			starget = ahc->platform_data->starget[i];
+			if (starget != NULL) {
 				for (j = 0; j < AHC_NUM_LUNS; j++) {
+					struct ahc_linux_target *targ =
+						scsi_transport_target_data(starget);
 
-					if (targ->devices[j] == NULL)
+					if (targ->sdev[j] == NULL)
 						continue;
-					dev = targ->devices[j];
-					ahc_linux_free_device(ahc, dev);
+					targ->sdev[j] = NULL;
 				}
-				/*
-				 * Forcibly free the target now that
-				 * all devices are gone.
-				 */
-				ahc_linux_free_target(ahc, targ);
+				ahc->platform_data->starget[i] = NULL;
  			}
  		}
 
@@ -1392,15 +1389,25 @@ void
 ahc_platform_set_tags(struct ahc_softc *ahc, struct ahc_devinfo *devinfo,
 		      ahc_queue_alg alg)
 {
+	struct scsi_target *starget;
+	struct ahc_linux_target *targ;
 	struct ahc_linux_device *dev;
+	struct scsi_device *sdev;
+	u_int target_offset;
 	int was_queuing;
 	int now_queuing;
 
-	dev = ahc_linux_get_device(ahc, devinfo->channel - 'A',
-				   devinfo->target,
-				   devinfo->lun);
-	if (dev == NULL)
+	target_offset = devinfo->target;
+	if (devinfo->channel != 'A')
+		target_offset += 8;
+	starget = ahc->platform_data->starget[target_offset];
+	targ = scsi_transport_target_data(starget);
+	BUG_ON(targ == NULL);
+	sdev = targ->sdev[devinfo->lun];
+	if (sdev == NULL)
 		return;
+	dev = scsi_transport_device_data(sdev);
+
 	was_queuing = dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED);
 	switch (alg) {
 	default:
@@ -1451,30 +1458,28 @@ ahc_platform_set_tags(struct ahc_softc *
 		dev->maxtags = 0;
 		dev->openings =  1 - dev->active;
 	}
-	if (dev->scsi_device != NULL) {
-		switch ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED))) {
-		case AHC_DEV_Q_BASIC:
-			scsi_adjust_queue_depth(dev->scsi_device,
-						MSG_SIMPLE_TASK,
-						dev->openings + dev->active);
-			break;
-		case AHC_DEV_Q_TAGGED:
-			scsi_adjust_queue_depth(dev->scsi_device,
-						MSG_ORDERED_TASK,
-						dev->openings + dev->active);
-			break;
-		default:
-			/*
-			 * We allow the OS to queue 2 untagged transactions to
-			 * us at any time even though we can only execute them
-			 * serially on the controller/device.  This should
-			 * remove some latency.
-			 */
-			scsi_adjust_queue_depth(dev->scsi_device,
-						/*NON-TAGGED*/0,
-						/*queue depth*/2);
-			break;
-		}
+	switch ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED))) {
+	case AHC_DEV_Q_BASIC:
+		scsi_adjust_queue_depth(sdev,
+					MSG_SIMPLE_TASK,
+					dev->openings + dev->active);
+		break;
+	case AHC_DEV_Q_TAGGED:
+		scsi_adjust_queue_depth(sdev,
+					MSG_ORDERED_TASK,
+					dev->openings + dev->active);
+		break;
+	default:
+		/*
+		 * We allow the OS to queue 2 untagged transactions to
+		 * us at any time even though we can only execute them
+		 * serially on the controller/device.  This should
+		 * remove some latency.
+		 */
+		scsi_adjust_queue_depth(sdev,
+					/*NON-TAGGED*/0,
+					/*queue depth*/2);
+		break;
 	}
 }
 
@@ -1520,22 +1525,20 @@ ahc_linux_user_tagdepth(struct ahc_softc
  * Determines the queue depth for a given device.
  */
 static void
-ahc_linux_device_queue_depth(struct ahc_softc *ahc,
-			     struct ahc_linux_device *dev)
+ahc_linux_device_queue_depth(struct scsi_device *sdev)
 {
 	struct	ahc_devinfo devinfo;
 	u_int	tags;
+	struct ahc_softc *ahc = *((struct ahc_softc **)sdev->host->hostdata);
 
 	ahc_compile_devinfo(&devinfo,
-			    dev->target->channel == 0
+			    sdev->sdev_target->channel == 0
 			  ? ahc->our_id : ahc->our_id_b,
-			    dev->target->target, dev->lun,
-			    dev->target->channel == 0 ? 'A' : 'B',
+			    sdev->sdev_target->id, sdev->lun,
+			    sdev->sdev_target->channel == 0 ? 'A' : 'B',
 			    ROLE_INITIATOR);
 	tags = ahc_linux_user_tagdepth(ahc, &devinfo);
-	if (tags != 0
-	 && dev->scsi_device != NULL
-	 && dev->scsi_device->tagged_supported != 0) {
+	if (tags != 0 && sdev->tagged_supported != 0) {
 
 		ahc_set_tags(ahc, &devinfo, AHC_QUEUE_TAGGED);
 		ahc_print_devinfo(ahc, &devinfo);
@@ -1764,106 +1767,6 @@ ahc_platform_flushwork(struct ahc_softc 
 
 }
 
-static struct ahc_linux_target*
-ahc_linux_alloc_target(struct ahc_softc *ahc, u_int channel, u_int target)
-{
-	struct ahc_linux_target *targ;
-	u_int target_offset;
-
-	target_offset = target;
-	if (channel != 0)
-		target_offset += 8;
-
-	targ = malloc(sizeof(*targ), M_DEVBUG, M_NOWAIT);
-	if (targ == NULL)
-		return (NULL);
-	memset(targ, 0, sizeof(*targ));
-	targ->channel = channel;
-	targ->target = target;
-	targ->ahc = ahc;
-	ahc->platform_data->targets[target_offset] = targ;
-	return (targ);
-}
-
-static void
-ahc_linux_free_target(struct ahc_softc *ahc, struct ahc_linux_target *targ)
-{
-	struct ahc_devinfo devinfo;
-	struct ahc_initiator_tinfo *tinfo;
-	struct ahc_tmode_tstate *tstate;
-	u_int our_id;
-	u_int target_offset;
-	char channel;
-
-	/*
-	 * Force a negotiation to async/narrow on any
-	 * future command to this device unless a bus
-	 * reset occurs between now and that command.
-	 */
-	channel = 'A' + targ->channel;
-	our_id = ahc->our_id;
-	target_offset = targ->target;
-	if (targ->channel != 0) {
-		target_offset += 8;
-		our_id = ahc->our_id_b;
-	}
-	tinfo = ahc_fetch_transinfo(ahc, channel, our_id,
-				    targ->target, &tstate);
-	ahc_compile_devinfo(&devinfo, our_id, targ->target, CAM_LUN_WILDCARD,
-			    channel, ROLE_INITIATOR);
-	ahc_set_syncrate(ahc, &devinfo, NULL, 0, 0, 0,
-			 AHC_TRANS_GOAL, /*paused*/FALSE);
-	ahc_set_width(ahc, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
-		      AHC_TRANS_GOAL, /*paused*/FALSE);
-	ahc_update_neg_request(ahc, &devinfo, tstate, tinfo, AHC_NEG_ALWAYS);
-	ahc->platform_data->targets[target_offset] = NULL;
-	free(targ, M_DEVBUF);
-}
-
-static struct ahc_linux_device*
-ahc_linux_alloc_device(struct ahc_softc *ahc,
-		 struct ahc_linux_target *targ, u_int lun)
-{
-	struct ahc_linux_device *dev;
-
-	dev = malloc(sizeof(*dev), M_DEVBUG, M_NOWAIT);
-	if (dev == NULL)
-		return (NULL);
-	memset(dev, 0, sizeof(*dev));
-	dev->lun = lun;
-	dev->target = targ;
-
-	/*
-	 * We start out life using untagged
-	 * transactions of which we allow one.
-	 */
-	dev->openings = 1;
-
-	/*
-	 * Set maxtags to 0.  This will be changed if we
-	 * later determine that we are dealing with
-	 * a tagged queuing capable device.
-	 */
-	dev->maxtags = 0;
-	
-	targ->refcount++;
-	targ->devices[lun] = dev;
-	return (dev);
-}
-
-static void
-ahc_linux_free_device(struct ahc_softc *ahc, struct ahc_linux_device *dev)
-{
-	struct ahc_linux_target *targ;
-
-	targ = dev->target;
-	targ->devices[dev->lun] = NULL;
-	free(dev, M_DEVBUF);
-	targ->refcount--;
-	if (targ->refcount == 0)
-		ahc_linux_free_target(ahc, targ);
-}
-
 void
 ahc_send_async(struct ahc_softc *ahc, char channel,
 	       u_int target, u_int lun, ac_code code, void *arg)
@@ -1872,11 +1775,15 @@ ahc_send_async(struct ahc_softc *ahc, ch
 	case AC_TRANSFER_NEG:
 	{
 		char	buf[80];
+		struct	scsi_target *starget;
 		struct	ahc_linux_target *targ;
 		struct	info_str info;
 		struct	ahc_initiator_tinfo *tinfo;
 		struct	ahc_tmode_tstate *tstate;
 		int	target_offset;
+		unsigned int target_ppr_options;
+
+		BUG_ON(target == CAM_TARGET_WILDCARD);
 
 		info.buffer = buf;
 		info.length = sizeof(buf);
@@ -1905,32 +1812,30 @@ ahc_send_async(struct ahc_softc *ahc, ch
 		target_offset = target;
 		if (channel == 'B')
 			target_offset += 8;
-		targ = ahc->platform_data->targets[target_offset];
+		starget = ahc->platform_data->starget[target_offset];
+		targ = scsi_transport_target_data(starget);
 		if (targ == NULL)
 			break;
-		if (tinfo->curr.period == targ->last_tinfo.period
-		 && tinfo->curr.width == targ->last_tinfo.width
-		 && tinfo->curr.offset == targ->last_tinfo.offset
-		 && tinfo->curr.ppr_options == targ->last_tinfo.ppr_options)
+
+		target_ppr_options =
+			(spi_dt(starget) ? MSG_EXT_PPR_DT_REQ : 0)
+			+ (spi_qas(starget) ? MSG_EXT_PPR_QAS_REQ : 0)
+			+ (spi_iu(starget) ?  MSG_EXT_PPR_IU_REQ : 0);
+
+		if (tinfo->curr.period == spi_period(starget)
+		    && tinfo->curr.width == spi_width(starget)
+		    && tinfo->curr.offset == spi_offset(starget)
+		 && tinfo->curr.ppr_options == target_ppr_options)
 			if (bootverbose == 0)
 				break;
 
-		targ->last_tinfo.period = tinfo->curr.period;
-		targ->last_tinfo.width = tinfo->curr.width;
-		targ->last_tinfo.offset = tinfo->curr.offset;
-		targ->last_tinfo.ppr_options = tinfo->curr.ppr_options;
-
-		printf("(%s:%c:", ahc_name(ahc), channel);
-		if (target == CAM_TARGET_WILDCARD)
-			printf("*): ");
-		else
-			printf("%d): ", target);
-		ahc_format_transinfo(&info, &tinfo->curr);
-		if (info.pos < info.length)
-			*info.buffer = '\0';
-		else
-			buf[info.length - 1] = '\0';
-		printf("%s", buf);
+		spi_period(starget) = tinfo->curr.period;
+		spi_width(starget) = tinfo->curr.width;
+		spi_offset(starget) = tinfo->curr.offset;
+		spi_dt(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_DT_REQ;
+		spi_qas(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_QAS_REQ;
+		spi_iu(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ;
+		spi_display_xfer_agreement(starget);
 		break;
 	}
         case AC_SENT_BDR:
@@ -2035,7 +1940,7 @@ ahc_done(struct ahc_softc *ahc, struct s
 			ahc_set_transaction_status(scb, CAM_REQ_CMP);
 		}
 	} else if (ahc_get_transaction_status(scb) == CAM_SCSI_STATUS_ERROR) {
-		ahc_linux_handle_scsi_status(ahc, dev, scb);
+		ahc_linux_handle_scsi_status(ahc, cmd->device, scb);
 	}
 
 	if (dev->openings == 1
@@ -2074,14 +1979,15 @@ ahc_done(struct ahc_softc *ahc, struct s
 
 static void
 ahc_linux_handle_scsi_status(struct ahc_softc *ahc,
-			     struct ahc_linux_device *dev, struct scb *scb)
+			     struct scsi_device *sdev, struct scb *scb)
 {
 	struct	ahc_devinfo devinfo;
+	struct ahc_linux_device *dev = scsi_transport_device_data(sdev);
 
 	ahc_compile_devinfo(&devinfo,
 			    ahc->our_id,
-			    dev->target->target, dev->lun,
-			    dev->target->channel == 0 ? 'A' : 'B',
+			    sdev->sdev_target->id, sdev->lun,
+			    sdev->sdev_target->channel == 0 ? 'A' : 'B',
 			    ROLE_INITIATOR);
 	
 	/*
@@ -2365,8 +2271,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	 * at all, and the system wanted us to just abort the
 	 * command, return success.
 	 */
-	dev = ahc_linux_get_device(ahc, cmd->device->channel, cmd->device->id,
-				   cmd->device->lun);
+	dev = scsi_transport_device_data(cmd->device);
 
 	if (dev == NULL) {
 		/*
@@ -2623,18 +2528,6 @@ ahc_platform_dump_card_state(struct ahc_
 
 static void ahc_linux_exit(void);
 
-static void ahc_linux_get_width(struct scsi_target *starget)
-{
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
-	struct ahc_tmode_tstate *tstate;
-	struct ahc_initiator_tinfo *tinfo 
-		= ahc_fetch_transinfo(ahc,
-				      starget->channel + 'A',
-				      shost->this_id, starget->id, &tstate);
-	spi_width(starget) = tinfo->curr.width;
-}
-
 static void ahc_linux_set_width(struct scsi_target *starget, int width)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -2649,18 +2542,6 @@ static void ahc_linux_set_width(struct s
 	ahc_unlock(ahc, &flags);
 }
 
-static void ahc_linux_get_period(struct scsi_target *starget)
-{
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
-	struct ahc_tmode_tstate *tstate;
-	struct ahc_initiator_tinfo *tinfo 
-		= ahc_fetch_transinfo(ahc,
-				      starget->channel + 'A',
-				      shost->this_id, starget->id, &tstate);
-	spi_period(starget) = tinfo->curr.period;
-}
-
 static void ahc_linux_set_period(struct scsi_target *starget, int period)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -2689,7 +2570,6 @@ static void ahc_linux_set_period(struct 
 
 	/* all PPR requests apart from QAS require wide transfers */
 	if (ppr_options & ~MSG_EXT_PPR_QAS_REQ) {
-		ahc_linux_get_width(starget);
 		if (spi_width(starget) == 0)
 			ppr_options &= MSG_EXT_PPR_QAS_REQ;
 	}
@@ -2701,18 +2581,6 @@ static void ahc_linux_set_period(struct 
 	ahc_unlock(ahc, &flags);
 }
 
-static void ahc_linux_get_offset(struct scsi_target *starget)
-{
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
-	struct ahc_tmode_tstate *tstate;
-	struct ahc_initiator_tinfo *tinfo 
-		= ahc_fetch_transinfo(ahc,
-				      starget->channel + 'A',
-				      shost->this_id, starget->id, &tstate);
-	spi_offset(starget) = tinfo->curr.offset;
-}
-
 static void ahc_linux_set_offset(struct scsi_target *starget, int offset)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -2741,18 +2609,6 @@ static void ahc_linux_set_offset(struct 
 	ahc_unlock(ahc, &flags);
 }
 
-static void ahc_linux_get_dt(struct scsi_target *starget)
-{
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
-	struct ahc_tmode_tstate *tstate;
-	struct ahc_initiator_tinfo *tinfo 
-		= ahc_fetch_transinfo(ahc,
-				      starget->channel + 'A',
-				      shost->this_id, starget->id, &tstate);
-	spi_dt(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_DT_REQ;
-}
-
 static void ahc_linux_set_dt(struct scsi_target *starget, int dt)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -2784,18 +2640,6 @@ static void ahc_linux_set_dt(struct scsi
 	ahc_unlock(ahc, &flags);
 }
 
-static void ahc_linux_get_qas(struct scsi_target *starget)
-{
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
-	struct ahc_tmode_tstate *tstate;
-	struct ahc_initiator_tinfo *tinfo 
-		= ahc_fetch_transinfo(ahc,
-				      starget->channel + 'A',
-				      shost->this_id, starget->id, &tstate);
-	spi_dt(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_QAS_REQ;
-}
-
 static void ahc_linux_set_qas(struct scsi_target *starget, int qas)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -2824,18 +2668,6 @@ static void ahc_linux_set_qas(struct scs
 	ahc_unlock(ahc, &flags);
 }
 
-static void ahc_linux_get_iu(struct scsi_target *starget)
-{
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
-	struct ahc_tmode_tstate *tstate;
-	struct ahc_initiator_tinfo *tinfo 
-		= ahc_fetch_transinfo(ahc,
-				      starget->channel + 'A',
-				      shost->this_id, starget->id, &tstate);
-	spi_dt(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ;
-}
-
 static void ahc_linux_set_iu(struct scsi_target *starget, int iu)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -2865,22 +2697,16 @@ static void ahc_linux_set_iu(struct scsi
 }
 
 static struct spi_function_template ahc_linux_transport_functions = {
-	.get_offset	= ahc_linux_get_offset,
 	.set_offset	= ahc_linux_set_offset,
 	.show_offset	= 1,
-	.get_period	= ahc_linux_get_period,
 	.set_period	= ahc_linux_set_period,
 	.show_period	= 1,
-	.get_width	= ahc_linux_get_width,
 	.set_width	= ahc_linux_set_width,
 	.show_width	= 1,
-	.get_dt		= ahc_linux_get_dt,
 	.set_dt		= ahc_linux_set_dt,
 	.show_dt	= 1,
-	.get_iu		= ahc_linux_get_iu,
 	.set_iu		= ahc_linux_set_iu,
 	.show_iu	= 1,
-	.get_qas	= ahc_linux_get_qas,
 	.set_qas	= ahc_linux_set_qas,
 	.show_qas	= 1,
 };
@@ -2893,6 +2719,10 @@ ahc_linux_init(void)
 	ahc_linux_transport_template = spi_attach_transport(&ahc_linux_transport_functions);
 	if (!ahc_linux_transport_template)
 		return -ENODEV;
+	scsi_transport_reserve_target(ahc_linux_transport_template,
+				      sizeof(struct ahc_linux_target));
+	scsi_transport_reserve_device(ahc_linux_transport_template,
+				      sizeof(struct ahc_linux_device));
 	if (ahc_linux_detect(&aic7xxx_driver_template))
 		return 0;
 	spi_release_transport(ahc_linux_transport_template);
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -79,6 +79,8 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
 
 /* Core SCSI definitions */
 #define AIC_LIB_PREFIX ahc
@@ -330,8 +332,6 @@ typedef enum {
 
 struct ahc_linux_target;
 struct ahc_linux_device {
-	TAILQ_ENTRY(ahc_linux_device) links;
-
 	/*
 	 * The number of transactions currently
 	 * queued to the device.
@@ -401,17 +401,10 @@ struct ahc_linux_device {
 	 */
 	u_int			commands_since_idle_or_otag;
 #define AHC_OTAG_THRESH	500
-
-	int			lun;
-	struct scsi_device       *scsi_device;
-	struct			ahc_linux_target *target;
 };
 
 struct ahc_linux_target {
-	struct ahc_linux_device	 *devices[AHC_NUM_LUNS];
-	int			  channel;
-	int			  target;
-	int			  refcount;
+	struct scsi_device	 *sdev[AHC_NUM_LUNS];
 	struct ahc_transinfo	  last_tinfo;
 	struct ahc_softc	 *ahc;
 };
@@ -445,7 +438,7 @@ struct ahc_platform_data {
 	/*
 	 * Fields accessed from interrupt context.
 	 */
-	struct ahc_linux_target *targets[AHC_NUM_TARGETS]; 
+	struct scsi_target *starget[AHC_NUM_TARGETS]; 
 
 	spinlock_t		 spin_lock;
 	u_int			 qfrozen;
--- a/drivers/scsi/aic7xxx/aic7xxx_proc.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_proc.c
@@ -50,7 +50,7 @@ static void	ahc_dump_target_state(struct
 				      u_int our_id, char channel,
 				      u_int target_id, u_int target_offset);
 static void	ahc_dump_device_state(struct info_str *info,
-				      struct ahc_linux_device *dev);
+				      struct scsi_device *dev);
 static int	ahc_proc_write_seeprom(struct ahc_softc *ahc,
 				       char *buffer, int length);
 
@@ -142,6 +142,7 @@ ahc_dump_target_state(struct ahc_softc *
 		      u_int target_offset)
 {
 	struct	ahc_linux_target *targ;
+	struct	scsi_target *starget;
 	struct	ahc_initiator_tinfo *tinfo;
 	struct	ahc_tmode_tstate *tstate;
 	int	lun;
@@ -153,7 +154,8 @@ ahc_dump_target_state(struct ahc_softc *
 	copy_info(info, "Target %d Negotiation Settings\n", target_id);
 	copy_info(info, "\tUser: ");
 	ahc_format_transinfo(info, &tinfo->user);
-	targ = ahc->platform_data->targets[target_offset];
+	starget = ahc->platform_data->starget[target_offset];
+	targ = scsi_transport_target_data(starget);
 	if (targ == NULL)
 		return;
 
@@ -163,22 +165,25 @@ ahc_dump_target_state(struct ahc_softc *
 	ahc_format_transinfo(info, &tinfo->curr);
 
 	for (lun = 0; lun < AHC_NUM_LUNS; lun++) {
-		struct ahc_linux_device *dev;
+		struct scsi_device *sdev;
 
-		dev = targ->devices[lun];
+		sdev = targ->sdev[lun];
 
-		if (dev == NULL)
+		if (sdev == NULL)
 			continue;
 
-		ahc_dump_device_state(info, dev);
+		ahc_dump_device_state(info, sdev);
 	}
 }
 
 static void
-ahc_dump_device_state(struct info_str *info, struct ahc_linux_device *dev)
+ahc_dump_device_state(struct info_str *info, struct scsi_device *sdev)
 {
+	struct ahc_linux_device *dev = scsi_transport_device_data(sdev);
+
 	copy_info(info, "\tChannel %c Target %d Lun %d Settings\n",
-		  dev->target->channel + 'A', dev->target->target, dev->lun);
+		  sdev->sdev_target->channel + 'A',
+		  sdev->sdev_target->id, sdev->lun);
 
 	copy_info(info, "\t\tCommands Queued %ld\n", dev->commands_issued);
 	copy_info(info, "\t\tCommands Active %d\n", dev->active);


