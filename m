From: Luben Tuikov <luben@splentec.com>
Subject: [PATCH] SCSI Core cmd allocation 3/3
Date: Mon, 06 Jan 2003 19:37:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E1A2140.3000408@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id h070bKf21759
	for <linux-scsi@vger.kernel.org>; Mon, 6 Jan 2003 19:37:20 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch introduces slab allocation of SCSI command structs
with (currently) one backup scsi command struct per host in
host->free_list.

New are:

struct scsi_cmnd * scsi_get_command(struct Scsi_Host *host, int alloc_flags);
void scsi_put_command(struct scsi_cmnd *cmd);
void scsi_setup_command(struct scsi_device *dev, struct scsi_cmnd *cmd);

static inline struct scsi_cmnd * scsi_getset_command(struct scsi_device *dev,
                                                     int flags);
For when the device is known (most of the cases).

Also:

int scsi_create_cmdcache(struct scsi_core_data *scsi_core);
int scsi_destroy_cmdcache(struct scsi_core_data *scsi_core);

struct scsi_core_data is a holder of all global SCSI Core data.

This is a joint work.

-- 
Luben

diff -Naur -X /usr/src/dontdiff linux-2.5.54-2/drivers/scsi/aic7xxx/aic79xx_osm.c linux-2.5.54-3/drivers/scsi/aic7xxx/aic79xx_osm.c
--- linux-2.5.54-2/drivers/scsi/aic7xxx/aic79xx_osm.c	2003-01-06 11:57:22.000000000 -0500
+++ linux-2.5.54-3/drivers/scsi/aic7xxx/aic79xx_osm.c	2003-01-06 17:16:13.000000000 -0500
@@ -971,7 +971,7 @@
  	struct	 ahd_linux_device *dev;
  	u_long	 flags;

-	ahd = *(struct ahd_softc **)cmd->host->hostdata;
+	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;

  	/*
  	 * Save the callback on completion function.
@@ -995,8 +995,8 @@
  		ahd_midlayer_entrypoint_unlock(ahd, &flags);
  		return (0);
  	}
-	dev = ahd_linux_get_device(ahd, cmd->channel, cmd->target,
-				   cmd->lun, /*alloc*/TRUE);
+	dev = ahd_linux_get_device(ahd, cmd->device->channel, cmd->device->id,
+				   cmd->device->lun, /*alloc*/TRUE);
  	if (dev == NULL) {
  		ahd_midlayer_entrypoint_unlock(ahd, &flags);
  		printf("aic79xx_linux_queue: Unable to allocate device!\n");
@@ -1217,7 +1217,7 @@
  	int    found;
  #endif

-	ahd = *(struct ahd_softc **)cmd->host->hostdata;
+	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
  #if NOTYET
  	int error;

@@ -1251,7 +1251,7 @@
  	int    found;
  #endif

-	ahd = *(struct ahd_softc **)cmd->host->hostdata;
+	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
  #ifdef AHD_DEBUG
  	if ((ahd_debug & AHD_SHOW_RECOVERY) != 0)
  		printf("%s: Dev reset called for cmd %p\n",
@@ -1283,14 +1283,14 @@
  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
  	spin_unlock_irq(&io_request_lock);
  #endif
-	ahd = *(struct ahd_softc **)cmd->host->hostdata;
+	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
  #ifdef AHD_DEBUG
  	if ((ahd_debug & AHD_SHOW_RECOVERY) != 0)
  		printf("%s: Bus reset called for cmd %p\n",
  		       ahd_name(ahd), cmd);
  #endif
  	ahd_midlayer_entrypoint_lock(ahd, &s);
-	found = ahd_reset_channel(ahd, cmd->channel + 'A',
+	found = ahd_reset_channel(ahd, cmd->device->channel + 'A',
  				  /*initiate reset*/TRUE);
  	acmd = TAILQ_FIRST(&ahd->platform_data->completeq);
  	TAILQ_INIT(&ahd->platform_data->completeq);
@@ -1415,7 +1415,7 @@

  /******************************** Macros **************************************/
  #define BUILD_SCSIID(ahd, cmd)						\
-	((((cmd)->target << TID_SHIFT) & TID) | (ahd)->our_id)
+	((((cmd)->device->id << TID_SHIFT) & TID) | (ahd)->our_id)

  /******************************** Bus DMA *************************************/
  int
@@ -3668,7 +3668,7 @@
  	struct	scb *scb;
  	u_long	flags;

-	ahd = *((struct ahd_softc **)cmd->host->hostdata);
+	ahd = *((struct ahd_softc **)cmd->device->host->hostdata);
  	ahd_lock(ahd, &flags);

  #ifdef AHD_DEBUG
@@ -3696,7 +3696,7 @@
  		ahd_set_transaction_status(scb, CAM_AUTOSENSE_FAIL);
  	else
  		ahd_set_transaction_status(scb, CAM_CMD_TIMEOUT);
-	ahd_reset_channel(ahd, cmd->channel + 'A', /*initiate*/TRUE);
+	ahd_reset_channel(ahd, cmd->device->channel + 'A', /*initiate*/TRUE);

  	/*
  	 * Add a minimal bus settle delay for devices that are slow to
@@ -3746,7 +3746,7 @@
  {
  	struct ahd_softc *ahd;

-	ahd = *((struct ahd_softc **)cmd->host->hostdata);
+	ahd = *((struct ahd_softc **)cmd->device->host->hostdata);

  	/* Delete the DV timer before it goes off! */
  	scsi_delete_timer(cmd);
@@ -3754,7 +3754,8 @@
  #ifdef AHD_DEBUG
  	if (ahd_debug & AHD_SHOW_DV)
  		printf("%s:%c:%d: Command completed, status= 0x%x\n",
-		       ahd_name(ahd), cmd->channel, cmd->target, cmd->result);
+		       ahd_name(ahd), cmd->device->channel,
+		       cmd->device->id, cmd->result);
  #endif

  	/* Wake up the state machine */
@@ -3948,12 +3949,13 @@
  		 * Get an scb to use.
  		 */
  		tinfo = ahd_fetch_transinfo(ahd, 'A', ahd->our_id,
-					    cmd->target, &tstate);
+					    cmd->device->id, &tstate);
  		if ((dev->flags & (AHD_DEV_Q_TAGGED|AHD_DEV_Q_BASIC)) == 0
  		 || (tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ) != 0) {
  			col_idx = AHD_NEVER_COL_IDX;
  		} else {
-			col_idx = AHD_BUILD_COL_IDX(cmd->target, cmd->lun);
+			col_idx = AHD_BUILD_COL_IDX(cmd->device->id,
+						    cmd->device->lun);
  		}
  		if ((scb = ahd_get_scb(ahd, col_idx)) == NULL) {
  			TAILQ_INSERT_TAIL(&ahd->platform_data->device_runq,
@@ -3973,7 +3975,7 @@
  		 */
  		hscb->control = 0;
  		hscb->scsiid = BUILD_SCSIID(ahd, cmd);
-		hscb->lun = cmd->lun;
+		hscb->lun = cmd->device->lun;
  		mask = SCB_GET_TARGET_MASK(ahd, scb);

  		if ((ahd->user_discenable & mask) != 0)
@@ -4641,8 +4643,9 @@
  			struct ahd_devinfo devinfo;
  			uint32_t action;

-			dev = ahd_linux_get_device(ahd, cmd->channel,
-						   cmd->target, cmd->lun,
+			dev = ahd_linux_get_device(ahd, cmd->device->channel,
+						   cmd->device->id,
+						   cmd->device->lun,
  						   /*alloc*/FALSE);

  			if (dev == NULL)
diff -Naur -X /usr/src/dontdiff linux-2.5.54-2/drivers/scsi/aic7xxx/aic7xxx_osm.c linux-2.5.54-3/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- linux-2.5.54-2/drivers/scsi/aic7xxx/aic7xxx_osm.c	2003-01-06 11:57:22.000000000 -0500
+++ linux-2.5.54-3/drivers/scsi/aic7xxx/aic7xxx_osm.c	2003-01-06 17:27:20.000000000 -0500
@@ -975,7 +975,7 @@
  	struct	 ahc_linux_device *dev;
  	u_long	 flags;

-	ahc = *(struct ahc_softc **)cmd->host->hostdata;
+	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;

  	/*
  	 * Save the callback on completion function.
@@ -999,8 +999,8 @@
  		ahc_midlayer_entrypoint_unlock(ahc, &flags);
  		return (0);
  	}
-	dev = ahc_linux_get_device(ahc, cmd->channel, cmd->target,
-				   cmd->lun, /*alloc*/TRUE);
+	dev = ahc_linux_get_device(ahc, cmd->device->channel, cmd->device->id,
+				   cmd->device->lun, /*alloc*/TRUE);
  	if (dev == NULL) {
  		ahc_midlayer_entrypoint_unlock(ahc, &flags);
  		printf("aic7xxx_linux_queue: Unable to allocate device!\n");
@@ -1244,12 +1244,12 @@
  	u_long s;
  	int    found;

-	ahc = *(struct ahc_softc **)cmd->host->hostdata;
+	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
  	spin_unlock_irq(&io_request_lock);
  #endif
  	ahc_midlayer_entrypoint_lock(ahc, &s);
-	found = ahc_reset_channel(ahc, cmd->channel + 'A',
+	found = ahc_reset_channel(ahc, cmd->device->channel + 'A',
  				  /*initiate reset*/TRUE);
  	acmd = TAILQ_FIRST(&ahc->platform_data->completeq);
  	TAILQ_INIT(&ahc->platform_data->completeq);
@@ -1371,10 +1371,10 @@
  }

  /******************************** Macros **************************************/
-#define BUILD_SCSIID(ahc, cmd)						\
-	((((cmd)->target << TID_SHIFT) & TID)				\
-	| (((cmd)->channel == 0) ? (ahc)->our_id : (ahc)->our_id_b)	\
-	| (((cmd)->channel == 0) ? 0 : TWIN_CHNLB))
+#define BUILD_SCSIID(ahc, cmd)						   \
+	((((cmd)->device->id << TID_SHIFT) & TID)			   \
+	| (((cmd)->device->channel == 0) ? (ahc)->our_id : (ahc)->our_id_b)\
+	| (((cmd)->device->channel == 0) ? 0 : TWIN_CHNLB))

  /******************************** Bus DMA *************************************/
  int
@@ -3511,7 +3511,7 @@
  	struct	scb *scb;
  	u_long	flags;

-	ahc = *((struct ahc_softc **)cmd->host->hostdata);
+	ahc = *((struct ahc_softc **)cmd->device->host->hostdata);
  	ahc_lock(ahc, &flags);

  #ifdef AHC_DEBUG
@@ -3539,7 +3539,7 @@
  		ahc_set_transaction_status(scb, CAM_AUTOSENSE_FAIL);
  	else
  		ahc_set_transaction_status(scb, CAM_CMD_TIMEOUT);
-	ahc_reset_channel(ahc, cmd->channel + 'A', /*initiate*/TRUE);
+	ahc_reset_channel(ahc, cmd->device->channel + 'A', /*initiate*/TRUE);

  	/*
  	 * Add a minimal bus settle delay for devices that are slow to
@@ -3589,7 +3589,7 @@
  {
  	struct ahc_softc *ahc;

-	ahc = *((struct ahc_softc **)cmd->host->hostdata);
+	ahc = *((struct ahc_softc **)cmd->device->host->hostdata);

  	/* Delete the DV timer before it goes off! */
  	scsi_delete_timer(cmd);
@@ -3597,7 +3597,8 @@
  #ifdef AHC_DEBUG
  	if (ahc_debug & AHC_SHOW_DV)
  		printf("%s:%d:%d: Command completed, status= 0x%x\n",
-		       ahc_name(ahc), cmd->channel, cmd->target, cmd->result);
+		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
+		       cmd->result);
  #endif

  	/* Wake up the state machine */
@@ -3813,7 +3814,7 @@
  		 */
  		hscb->control = 0;
  		hscb->scsiid = BUILD_SCSIID(ahc, cmd);
-		hscb->lun = cmd->lun;
+		hscb->lun = cmd->device->lun;
  		mask = SCB_GET_TARGET_MASK(ahc, scb);
  		tinfo = ahc_fetch_transinfo(ahc, SCB_GET_CHANNEL(ahc, scb),
  					    SCB_GET_OUR_ID(scb),
@@ -4838,11 +4839,12 @@
  	pending_scb = NULL;
  	paused = FALSE;
  	wait = FALSE;
-	ahc = *(struct ahc_softc **)cmd->host->hostdata;
+	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
  	acmd = (struct ahc_cmd *)cmd;

  	printf("%s:%d:%d:%d: Attempting to queue a%s message\n",
-	       ahc_name(ahc), cmd->channel, cmd->target, cmd->lun,
+	       ahc_name(ahc), cmd->device->channel, cmd->device->id,
+	       cmd->device->lun,
  	       flag == SCB_ABORT ? "n ABORT" : " TARGET RESET");

  	/*
@@ -4871,8 +4873,8 @@
  	 * at all, and the system wanted us to just abort the
  	 * command return success.
  	 */
-	dev = ahc_linux_get_device(ahc, cmd->channel, cmd->target,
-				   cmd->lun, /*alloc*/FALSE);
+	dev = ahc_linux_get_device(ahc, cmd->device->channel, cmd->device->id,
+				   cmd->device->lun, /*alloc*/FALSE);

  	if (dev == NULL) {
  		/*
@@ -4880,7 +4882,8 @@
  		 * so we must not still own the command.
  		 */
  		printf("%s:%d:%d:%d: Is not an active device\n",
-		       ahc_name(ahc), cmd->channel, cmd->target, cmd->lun);
+		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
+		       cmd->device->lun);
  		retval = SUCCESS;
  		goto no_cmd;
  	}
@@ -4892,7 +4895,8 @@

  	if (list_acmd != NULL) {
  		printf("%s:%d:%d:%d: Command found on device queue\n",
-		       ahc_name(ahc), cmd->channel, cmd->target, cmd->lun);
+		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
+		       cmd->device->lun);
  		if (flag == SCB_ABORT) {
  			TAILQ_REMOVE(&dev->busyq, list_acmd, acmd_links.tqe);
  			cmd->result = DID_ABORT << 16;
@@ -4903,11 +4907,13 @@
  	}

  	if ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED)) == 0
-	 && ahc_search_untagged_queues(ahc, cmd, cmd->target,
-				       cmd->channel + 'A', cmd->lun,
+	 && ahc_search_untagged_queues(ahc, cmd, cmd->device->id,
+				       cmd->device->channel + 'A',
+				       cmd->device->lun,
  				       CAM_REQ_ABORTED, SEARCH_COMPLETE) != 0) {
  		printf("%s:%d:%d:%d: Command found on untagged queue\n",
-		       ahc_name(ahc), cmd->channel, cmd->target, cmd->lun);
+		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
+		       cmd->device->lun);
  		retval = SUCCESS;
  		goto done;
  	}
@@ -4924,8 +4930,9 @@

  		/* Any SCB for this device will do for a target reset */
  		LIST_FOREACH(pending_scb, &ahc->pending_scbs, pending_links) {
-		  	if (ahc_match_scb(ahc, pending_scb, cmd->target,
-					  cmd->channel + 'A', CAM_LUN_WILDCARD,
+		  	if (ahc_match_scb(ahc, pending_scb, cmd->device->id,
+					  cmd->device->channel + 'A',
+					  CAM_LUN_WILDCARD,
  					  SCB_LIST_NULL, ROLE_INITIATOR) == 0)
  				break;
  		}
@@ -4933,7 +4940,8 @@

  	if (pending_scb == NULL) {
  		printf("%s:%d:%d:%d: Command not found\n",
-		       ahc_name(ahc), cmd->channel, cmd->target, cmd->lun);
+		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
+		       cmd->device->lun);
  		goto no_cmd;
  	}

@@ -4957,24 +4965,24 @@

  	if ((pending_scb->flags & SCB_ACTIVE) == 0) {
  		printf("%s:%d:%d:%d: Command already completed\n",
-		       ahc_name(ahc), cmd->channel, cmd->target, cmd->lun);
+		       ahc_name(ahc), cmd->device->channel, cmd->device->id, cmd->device->lun);
  		goto no_cmd;
  	}

  	disconnected = TRUE;
  	if (flag == SCB_ABORT) {
-		if (ahc_search_qinfifo(ahc, cmd->target, cmd->channel + 'A',
-				       cmd->lun, pending_scb->hscb->tag,
+		if (ahc_search_qinfifo(ahc, cmd->device->id, cmd->device->channel + 'A',
+				       cmd->device->lun, pending_scb->hscb->tag,
  				       ROLE_INITIATOR, CAM_REQ_ABORTED,
  				       SEARCH_COMPLETE) > 0) {
  			printf("%s:%d:%d:%d: Cmd aborted from QINFIFO\n",
-			       ahc_name(ahc), cmd->channel, cmd->target,
-					cmd->lun);
+			       ahc_name(ahc), cmd->device->channel, cmd->device->id,
+					cmd->device->lun);
  			retval = SUCCESS;
  			goto done;
  		}
-	} else if (ahc_search_qinfifo(ahc, cmd->target, cmd->channel + 'A',
-				      cmd->lun, pending_scb->hscb->tag,
+	} else if (ahc_search_qinfifo(ahc, cmd->device->id, cmd->device->channel + 'A',
+				      cmd->device->lun, pending_scb->hscb->tag,
  				      ROLE_INITIATOR, /*status*/0,
  				      SEARCH_COUNT) > 0) {
  		disconnected = FALSE;
@@ -5006,7 +5014,7 @@
  	if (last_phase != P_BUSFREE
  	 && (pending_scb->hscb->tag == active_scb_index
  	  || (flag == SCB_DEVICE_RESET
-	   && SCSIID_TARGET(ahc, ahc_inb(ahc, SAVED_SCSIID)) == cmd->target))) {
+	   && SCSIID_TARGET(ahc, ahc_inb(ahc, SAVED_SCSIID)) == cmd->device->id))) {

  		/*
  		 * We're active on the bus, so assert ATN
@@ -5017,7 +5025,7 @@
  		ahc_outb(ahc, MSG_OUT, HOST_MSG);
  		ahc_outb(ahc, SCSISIGO, last_phase|ATNO);
  		printf("%s:%d:%d:%d: Device is active, asserting ATN\n",
-		       ahc_name(ahc), cmd->channel, cmd->target, cmd->lun);
+		       ahc_name(ahc), cmd->device->channel, cmd->device->id, cmd->device->lun);
  		wait = TRUE;
  	} else if (disconnected) {

@@ -5047,8 +5055,8 @@
  		 * same element in the SCB, SCB_NEXT, for
  		 * both the qinfifo and the disconnected list.
  		 */
-		ahc_search_disc_list(ahc, cmd->target, cmd->channel + 'A',
-				     cmd->lun, pending_scb->hscb->tag,
+		ahc_search_disc_list(ahc, cmd->device->id, cmd->device->channel + 'A',
+				     cmd->device->lun, pending_scb->hscb->tag,
  				     /*stop_on_first*/TRUE,
  				     /*remove*/TRUE,
  				     /*save_state*/FALSE);
@@ -5071,19 +5079,19 @@
  		 * so we are the next SCB for this target
  		 * to run.
  		 */
-		ahc_search_qinfifo(ahc, cmd->target, cmd->channel + 'A',
-				   cmd->lun, SCB_LIST_NULL, ROLE_INITIATOR,
+		ahc_search_qinfifo(ahc, cmd->device->id, cmd->device->channel + 'A',
+				   cmd->device->lun, SCB_LIST_NULL, ROLE_INITIATOR,
  				   CAM_REQUEUE_REQ, SEARCH_COMPLETE);
  		ahc_print_path(ahc, pending_scb);
  		printf("Queuing a recovery SCB\n");
  		ahc_qinfifo_requeue_tail(ahc, pending_scb);
  		ahc_outb(ahc, SCBPTR, saved_scbptr);
  		printf("%s:%d:%d:%d: Device is disconnected, re-queuing SCB\n",
-		       ahc_name(ahc), cmd->channel, cmd->target, cmd->lun);
+		       ahc_name(ahc), cmd->device->channel, cmd->device->id, cmd->device->lun);
  		wait = TRUE;
  	} else {
  		printf("%s:%d:%d:%d: Unable to deliver message\n",
-		       ahc_name(ahc), cmd->channel, cmd->target, cmd->lun);
+		       ahc_name(ahc), cmd->device->channel, cmd->device->id, cmd->device->lun);
  		retval = FAILED;
  		goto done;
  	}
diff -Naur -X /usr/src/dontdiff linux-2.5.54-2/drivers/scsi/cpqfcTSinit.c linux-2.5.54-3/drivers/scsi/cpqfcTSinit.c
--- linux-2.5.54-2/drivers/scsi/cpqfcTSinit.c	2003-01-06 12:01:16.000000000 -0500
+++ linux-2.5.54-3/drivers/scsi/cpqfcTSinit.c	2003-01-06 16:29:51.000000000 -0500
@@ -1603,8 +1603,7 @@

    scsi_cdb[0] = RELEASE;

-  // allocate with wait = true, interruptible = false
-  SCpnt = scsi_allocate_device(ScsiDev, 1);
+  SCpnt = scsi_getset_command(ScsiDev, GFP_KERNEL);
    {
      CPQFC_DECLARE_COMPLETION(wait);

@@ -1653,7 +1652,7 @@
    result = SCpnt->result;

    SDpnt = SCpnt->device;
-  scsi_release_command(SCpnt);
+  scsi_put_command(SCpnt);
    SCpnt = NULL;

    // if (!SDpnt->was_reset && SDpnt->scsi_request_fn)
diff -Naur -X /usr/src/dontdiff linux-2.5.54-2/drivers/scsi/gdth.c linux-2.5.54-3/drivers/scsi/gdth.c
--- linux-2.5.54-2/drivers/scsi/gdth.c	2003-01-06 12:01:16.000000000 -0500
+++ linux-2.5.54-3/drivers/scsi/gdth.c	2003-01-06 16:31:52.000000000 -0500
@@ -4599,7 +4599,7 @@

  #if LINUX_VERSION_CODE >= 0x020322
      sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-    scp  = scsi_allocate_device(sdev, 1);
+    scp  = scsi_getset_command(sdev, GFP_KERNEL);
      scp->cmd_len = 12;
      scp->use_sg = 0;
  #else
@@ -4627,7 +4627,7 @@
          }
      }
  #if LINUX_VERSION_CODE >= 0x020322
-    scsi_release_command(scp);
+    scsi_put_command(scp);
      scsi_free_host_dev(sdev);
  #endif
  }
@@ -4673,7 +4673,7 @@
          memset(cmnd, 0xff, MAX_COMMAND_SIZE);
  #if LINUX_VERSION_CODE >= 0x020322
          sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-        scp  = scsi_allocate_device(sdev, 1);
+        scp  = scsi_getset_command(sdev, GFP_KERNEL);
          scp->cmd_len = 12;
          scp->use_sg = 0;
  #else
@@ -4690,7 +4690,7 @@
          TRACE2(("gdth_halt(): reset controller %d\n", hanum));
  #if LINUX_VERSION_CODE >= 0x020322
          gdth_do_cmd(scp, &gdtcmd, cmnd, 10);
-        scsi_release_command(scp);
+        scsi_put_command(scp);
          scsi_free_host_dev(sdev);
  #else
          gdth_do_cmd(&scp, &gdtcmd, cmnd, 10);
diff -Naur -X /usr/src/dontdiff linux-2.5.54-2/drivers/scsi/gdth_proc.c linux-2.5.54-3/drivers/scsi/gdth_proc.c
--- linux-2.5.54-2/drivers/scsi/gdth_proc.c	2003-01-06 12:01:16.000000000 -0500
+++ linux-2.5.54-3/drivers/scsi/gdth_proc.c	2003-01-06 16:35:02.000000000 -0500
@@ -48,7 +48,7 @@

  #if LINUX_VERSION_CODE >= 0x020322
      sdev = scsi_get_host_dev(gdth_ctr_vtab[vh]);
-    scp  = scsi_allocate_device(sdev, 1);
+    scp  = scsi_getset_command(sdev, GFP_KERNEL);
      if (!scp)
          return -ENOMEM;
      scp->cmd_len = 12;
@@ -81,7 +81,7 @@
          ret_val = -EINVAL;
      }
  #if LINUX_VERSION_CODE >= 0x020322
-    scsi_release_command(scp);
+    scsi_put_command(scp);
      scsi_free_host_dev(sdev);
  #endif
      return ret_val;
@@ -712,7 +712,7 @@

  #if LINUX_VERSION_CODE >= 0x020322
      sdev = scsi_get_host_dev(gdth_ctr_vtab[vh]);
-    scp  = scsi_allocate_device(sdev, 1);
+    scp  = scsi_getset_command(sdev, GFP_KERNEL);
      if (!scp)
          return -ENOMEM;
      scp->cmd_len = 12;
@@ -1234,7 +1234,7 @@

  stop_output:
  #if LINUX_VERSION_CODE >= 0x020322
-    scsi_release_command(scp);
+    scsi_put_command(scp);
      scsi_free_host_dev(sdev);
  #endif
      *start = buffer +(offset-begin);
diff -Naur -X /usr/src/dontdiff linux-2.5.54-2/drivers/scsi/hosts.c linux-2.5.54-3/drivers/scsi/hosts.c
--- linux-2.5.54-2/drivers/scsi/hosts.c	2003-01-06 12:00:18.000000000 -0500
+++ linux-2.5.54-3/drivers/scsi/hosts.c	2003-01-06 17:01:29.000000000 -0500
@@ -347,6 +347,13 @@
  	/* Cleanup proc */
  	scsi_proc_host_rm(shost);

+	while (!list_empty(&shost->free_list)) {
+		struct scsi_cmnd *cmd;
+		cmd = list_entry(shost->free_list.next,struct scsi_cmnd,list);
+		list_del_init(&cmd->list);
+		kmem_cache_free(scsi_core->scsi_cmd_cache, cmd);
+	}
+
  	kfree(shost);
  }

@@ -367,6 +374,7 @@
  struct Scsi_Host * scsi_register(Scsi_Host_Template *shost_tp, int xtr_bytes)
  {
  	struct Scsi_Host *shost, *shost_scr;
+	struct scsi_cmnd *cmd = NULL;
  	int gfp_mask;
  	DECLARE_MUTEX_LOCKED(sem);

@@ -456,6 +464,15 @@
  found:
  	spin_unlock(&scsi_host_list_lock);

+	INIT_LIST_HEAD(&shost->free_list);
+
+	/* Get one backup command for this host. */
+	cmd = scsi_get_command(shost, GFP_KERNEL);
+	if (cmd)
+		list_add(&cmd->list, &shost->free_list);		
+	else
+		printk(KERN_NOTICE "The system is running low in memory.\n");
+
  	scsi_proc_host_add(shost);

  	shost->eh_notify = &sem;
diff -Naur -X /usr/src/dontdiff linux-2.5.54-2/drivers/scsi/hosts.h linux-2.5.54-3/drivers/scsi/hosts.h
--- linux-2.5.54-2/drivers/scsi/hosts.h	2003-01-06 11:57:16.000000000 -0500
+++ linux-2.5.54-3/drivers/scsi/hosts.h	2003-01-06 12:37:43.000000000 -0500
@@ -375,6 +375,8 @@
      struct list_head      sh_list;
      struct list_head	  my_devices;

+    struct list_head      free_list;   /* backup store of cmd structs */
+
      spinlock_t		  default_lock;
      spinlock_t		  *host_lock;

diff -Naur -X /usr/src/dontdiff linux-2.5.54-2/drivers/scsi/scsi.c linux-2.5.54-3/drivers/scsi/scsi.c
--- linux-2.5.54-2/drivers/scsi/scsi.c	2003-01-06 12:01:16.000000000 -0500
+++ linux-2.5.54-3/drivers/scsi/scsi.c	2003-01-06 18:30:11.000000000 -0500
@@ -265,7 +265,7 @@
  {
  	if( req->sr_command != NULL )
  	{
-		scsi_release_command(req->sr_command);
+		scsi_put_command(req->sr_command);
  		req->sr_command = NULL;
  	}

@@ -768,7 +768,7 @@
  	SRpnt->sr_request->waiting = NULL;
  	if( SRpnt->sr_command != NULL )
  	{
-		scsi_release_command(SRpnt->sr_command);
+		scsi_put_command(SRpnt->sr_command);
  		SRpnt->sr_command = NULL;
  	}

@@ -834,7 +834,7 @@
  	 */
  	if( SRpnt->sr_command != NULL )
  	{
-		scsi_release_command(SRpnt->sr_command);
+		scsi_put_command(SRpnt->sr_command);
  		SRpnt->sr_command = NULL;
  	}

@@ -1506,6 +1506,12 @@
  			SDpnt->new_queue_depth = tags;
  			break;
  	}
+	/* TODO FIXME This is a hack and MUST go eventually.
+	   This fixes a problem in scsi_scan.c::scsi_alloc_sdev()
+	   else we cannot ever have ANY SCSI devices.
+	*/
+	SDpnt->current_queue_depth = 1;
+
  	spin_unlock_irqrestore(&device_request_lock, flags);
  }

@@ -2017,6 +2023,14 @@
  {
  	printk(KERN_INFO "SCSI subsystem driver " REVISION "\n");

+	scsi_core = kmalloc(sizeof(struct scsi_core_data), GFP_KERNEL);
+	if (!scsi_core)
+		goto out_no_mem;
+	memset(scsi_core, 0, sizeof(*scsi_core));
+	
+	if (scsi_create_cmdcache(scsi_core))
+		goto out_no_mem;
+
  	scsi_init_queue();
  	scsi_init_procfs();
  	devfs_mk_dir(NULL, "scsi", NULL);
@@ -2025,6 +2039,10 @@
  	scsi_sysfs_register();
  	open_softirq(SCSI_SOFTIRQ, scsi_softirq, NULL);
  	return 0;
+
+out_no_mem:
+	printk(KERN_CRIT "Couldn't load SCSI Core -- out of memory!\n");
+	return -ENOMEM;
  }

  static void __exit exit_scsi(void)
@@ -2034,6 +2052,12 @@
  	devfs_remove("scsi");
  	scsi_exit_procfs();
  	scsi_exit_queue();
+
+	scsi_destroy_cmdcache(scsi_core);
+
+	if (scsi_core)
+		kfree(scsi_core);
+	scsi_core = NULL;
  }

  subsys_initcall(init_scsi);
diff -Naur -X /usr/src/dontdiff linux-2.5.54-2/drivers/scsi/scsi.h linux-2.5.54-3/drivers/scsi/scsi.h
--- linux-2.5.54-2/drivers/scsi/scsi.h	2003-01-06 12:01:16.000000000 -0500
+++ linux-2.5.54-3/drivers/scsi/scsi.h	2003-01-06 16:29:22.000000000 -0500
@@ -734,7 +734,8 @@
  	Scsi_Request *sc_request;
  	struct scsi_cmnd *next;
  	struct scsi_cmnd *reset_chain;
-	struct list_head list_entry; /* Used to place us on the cmd lists */
+
+	struct list_head list;  /* scsi_cmnd participates in queue lists */

  	int eh_state;		/* Used for state tracking in error handlr */
  	int eh_eflags;		/* Used by error handlr */
@@ -994,4 +995,44 @@
  extern int scsi_sysfs_register(void);
  extern void scsi_sysfs_unregister(void);

+/* -------------------------------------------------- */
+/* data decl: */
+
+/* All the SCSI Core specific global data, etc,
+   should go in here.
+*/
+
+struct scsi_core_data {
+	kmem_cache_t   *scsi_cmd_cache;
+};
+
+extern struct scsi_core_data *scsi_core;
+
+/* -------------------------------------------------- */
+/* fn decl: */
+
+int scsi_create_cmdcache(struct scsi_core_data *scsi_core);
+int scsi_destroy_cmdcache(struct scsi_core_data *scsi_core);
+
+struct scsi_cmnd * scsi_get_command(struct Scsi_Host *host, int alloc_flags);
+void scsi_put_command(struct scsi_cmnd *cmd);
+void scsi_setup_command(struct scsi_device *dev, struct scsi_cmnd *cmd);
+
+/* -------------------------------------------------- */
+/* inline funcs: */
+
+/* scsi_getset_command: allocate, set and return a command struct,
+   when the device is known.
+*/
+static inline struct scsi_cmnd *scsi_getset_command(struct scsi_device *dev,
+						    int flags)
+{
+	struct scsi_cmnd *cmd;
+
+	if (!dev) return NULL;
+	if (!dev->host) return NULL;
+	scsi_setup_command(dev, (cmd = scsi_get_command(dev->host, flags)));
+	return cmd;
+}				
+
  #endif
diff -Naur -X /usr/src/dontdiff linux-2.5.54-2/drivers/scsi/scsi_error.c linux-2.5.54-3/drivers/scsi/scsi_error.c
--- linux-2.5.54-2/drivers/scsi/scsi_error.c	2003-01-06 12:01:16.000000000 -0500
+++ linux-2.5.54-3/drivers/scsi/scsi_error.c	2003-01-06 16:47:57.000000000 -0500
@@ -1384,7 +1384,7 @@
  	scmd->sc_request = NULL;
  	sreq->sr_command = NULL;

-	scsi_release_command(scmd);
+	scsi_put_command(scmd);
  	scsi_release_request(sreq);
  }

diff -Naur -X /usr/src/dontdiff linux-2.5.54-2/drivers/scsi/scsi_lib.c linux-2.5.54-3/drivers/scsi/scsi_lib.c
--- linux-2.5.54-2/drivers/scsi/scsi_lib.c	2003-01-06 12:01:16.000000000 -0500
+++ linux-2.5.54-3/drivers/scsi/scsi_lib.c	2003-01-06 16:49:18.000000000 -0500
@@ -33,7 +33,9 @@
  struct scsi_host_sg_pool scsi_sg_pools[SG_MEMPOOL_NR] = {
  	SP(8), SP(16), SP(32), SP(64), SP(MAX_PHYS_SEGMENTS)
  }; 	
-#undef SP 	
+#undef SP
+
+struct scsi_core_data *scsi_core;

  /*
   * Function:    scsi_insert_special_cmd()
@@ -357,7 +359,7 @@
  	 * This will goose the queue request function at the end, so we don't
  	 * need to worry about launching another command.
  	 */
-	__scsi_release_command(SCpnt);
+	scsi_put_command(SCpnt);
  	scsi_queue_next_request(q, NULL);
  	return NULL;
  }
@@ -802,7 +804,8 @@
  		SRpnt = (Scsi_Request *) req->special;
  		
  		if( SRpnt->sr_magic == SCSI_REQ_MAGIC ) {
-			SCpnt = scsi_allocate_device(SRpnt->sr_device, 0);
+			SCpnt = scsi_getset_command(SRpnt->sr_device,
+						    GFP_ATOMIC);
  			if (!SCpnt)
  				return BLKPREP_DEFER;
  			scsi_init_cmd_from_req(SCpnt, SRpnt);
@@ -815,7 +818,7 @@
  		if (req->special) {
  			SCpnt = (Scsi_Cmnd *) req->special;
  		} else {
-			SCpnt = scsi_allocate_device(SDpnt, 0);
+			SCpnt = scsi_getset_command(SDpnt, GFP_ATOMIC);
  		}
  		/*
  		 * if command allocation failure, wait a bit
@@ -1179,3 +1182,110 @@
  		kmem_cache_destroy(sgp->slab);
  	}
  }
+
+/* -------------------------------------------------- */
+
+int scsi_create_cmdcache(struct scsi_core_data *scsi_core)
+{
+	if (!scsi_core)
+		return -EFAULT;
+	scsi_core->scsi_cmd_cache
+		= kmem_cache_create("scsi_cmd_cache",
+				    sizeof(struct scsi_cmnd), 0,
+				    SLAB_NO_REAP|SLAB_HWCACHE_ALIGN,NULL,NULL);
+	if (!scsi_core->scsi_cmd_cache)
+		return -ENOMEM;
+	return 0;
+} /* end scsi_create_cmdcache() */
+
+/* -------------------------------------------------- */
+
+int scsi_destroy_cmdcache(struct scsi_core_data *scsi_core)
+{
+	if (!scsi_core)
+		return -EFAULT;
+	if (kmem_cache_destroy(scsi_core->scsi_cmd_cache)) {
+		printk(KERN_CRIT "Failed to free scsi command cache"
+		       " -- memory leak\n");
+		return -EFAULT;
+	} else {
+		scsi_core->scsi_cmd_cache = NULL;
+	}
+	return 0;
+} /* end scsi_destroy_cmdcache() */
+
+/* -------------------------------------------------- */
+
+struct scsi_cmnd * scsi_get_command(struct Scsi_Host *host, int alloc_flags)
+{
+	unsigned long flags;
+	struct scsi_cmnd *cmd = NULL;
+	
+	if (!host)
+		return NULL;
+
+	cmd = kmem_cache_alloc(scsi_core->scsi_cmd_cache, alloc_flags);
+
+	if (!cmd) {
+		spin_lock_irqsave(host->host_lock, flags);
+		if (!list_empty(&host->free_list)) {
+			cmd = list_entry(host->free_list.next,
+					 struct scsi_cmnd, list);
+			list_del_init(&cmd->list);
+		}
+		spin_unlock_irqrestore(host->host_lock, flags);
+	}
+
+	return cmd;
+} /* end scsi_get_command() */
+
+/* -------------------------------------------------- */
+/* scsi_put_command: free a scsi_cmnd struct.
+   Note: the command must not belong to any lists!
+*/
+void scsi_put_command(struct scsi_cmnd *cmd)
+{
+	unsigned long flags;
+	struct Scsi_Host *host;
+	
+	if (!cmd)
+		return;
+
+	if (!cmd->device || !cmd->device->host) {
+		printk(KERN_NOTICE "Trying to free a command which"
+		       " doesn't belong to scsi core?!\n");
+		 /* Memory leak, but let the system survive for now --
+		    they'll get it eventually! */
+		return;
+	}
+
+	host = cmd->device->host;
+
+	spin_lock_irqsave(host->host_lock, flags);
+	if (list_empty(&host->free_list)) {
+		list_add(&cmd->list, &host->free_list);
+		cmd = NULL;
+	}
+	spin_unlock_irqrestore(host->host_lock, flags);
+
+	if (cmd)
+		kmem_cache_free(scsi_core->scsi_cmd_cache, cmd);
+} /* end scsi_put_command() */
+
+/* -------------------------------------------------- */
+/* scsi_setup_command: This will do post-alloc init of the command.
+   We want to do as little as possible here.
+*/
+void scsi_setup_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
+{
+	if (!cmd)
+		return;
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->device = dev;
+	cmd->state = SCSI_STATE_UNUSED;
+	cmd->owner = SCSI_OWNER_NOBODY;
+	init_timer(&cmd->eh_timeout);
+	INIT_LIST_HEAD(&cmd->list);
+} /* end scsi_setup_command() */
+
+/* -------------------------------------------------- */
diff -Naur -X /usr/src/dontdiff linux-2.5.54-2/drivers/scsi/scsi_scan.c linux-2.5.54-3/drivers/scsi/scsi_scan.c
--- linux-2.5.54-2/drivers/scsi/scsi_scan.c	2003-01-06 11:57:16.000000000 -0500
+++ linux-2.5.54-3/drivers/scsi/scsi_scan.c	2003-01-06 18:45:38.000000000 -0500
@@ -471,7 +471,6 @@

  		sdev->request_queue->queuedata = sdev;
  		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
-		scsi_build_commandblocks(sdev);
  		if (sdev->current_queue_depth == 0) {
  			goto out_bail;
  		}
@@ -515,7 +514,6 @@
  	} else if (sdev->request_queue)
  		scsi_free_queue(sdev->request_queue);

-	scsi_release_commandblocks(sdev);
  	kfree(sdev);
  	return NULL;
  }
@@ -535,7 +533,6 @@

  	if (sdev->request_queue)
  		scsi_free_queue(sdev->request_queue);
-	scsi_release_commandblocks(sdev);
  	if (sdev->host->hostt->slave_destroy)
  		sdev->host->hostt->slave_destroy(sdev);
  	if (sdev->inquiry)
diff -Naur -X /usr/src/dontdiff linux-2.5.54-2/drivers/scsi/scsi_syms.c linux-2.5.54-3/drivers/scsi/scsi_syms.c
--- linux-2.5.54-2/drivers/scsi/scsi_syms.c	2003-01-06 11:57:16.000000000 -0500
+++ linux-2.5.54-3/drivers/scsi/scsi_syms.c	2003-01-06 16:51:09.000000000 -0500
@@ -39,7 +39,8 @@
  EXPORT_SYMBOL(scsicam_bios_param);
  EXPORT_SYMBOL(scsi_partsize);
  EXPORT_SYMBOL(scsi_bios_ptable);
-EXPORT_SYMBOL(scsi_allocate_device);
+/* Obsolete! Use scsi_get_command() or scsi_getset_command(). */
+/* EXPORT_SYMBOL(scsi_allocate_device); */
  EXPORT_SYMBOL(scsi_do_cmd);
  EXPORT_SYMBOL(scsi_ioctl);
  EXPORT_SYMBOL(print_command);
@@ -50,7 +51,8 @@
  EXPORT_SYMBOL(scsi_sense_key_string);
  EXPORT_SYMBOL(scsi_extd_sense_format);
  EXPORT_SYMBOL(kernel_scsi_ioctl);
-EXPORT_SYMBOL(scsi_release_command);
+/* Obsolete! Use scsi_put_command() instead. */
+/* EXPORT_SYMBOL(scsi_release_command); */
  EXPORT_SYMBOL(print_Scsi_Cmnd);
  EXPORT_SYMBOL(scsi_block_when_processing_errors);
  EXPORT_SYMBOL(scsi_ioctl_send_command);
@@ -114,3 +116,8 @@
   * sysfs support
   */
  EXPORT_SYMBOL(shost_devclass);
+
+EXPORT_SYMBOL(scsi_get_command);
+EXPORT_SYMBOL(scsi_put_command);
+EXPORT_SYMBOL(scsi_setup_command);
+

