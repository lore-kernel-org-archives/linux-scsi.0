From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] remove aic7xxx busyq
Date: Mon, 16 May 2005 11:39:38 -0500
Message-ID: <1116261578.5040.28.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:21422 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261738AbVEPQjk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 12:39:40 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j4GGdcA07220
	for <linux-scsi@vger.kernel.org>; Mon, 16 May 2005 12:39:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

The aic7xxx driver has two spurious queues in it's linux glue code: the
busyq which queues incoming commands to the driver and the completeq
which queues finished commands before sending them back to the mid-layer

This patch just removes the busyq and makes the aic finally return the
correct status to get the mid-layer to manage its queueing, so a command
is either committed to the sequencer or returned to the midlayer for
requeue.

---

 aic7xxx_osm.c |  631 +++++++++++++++++-----------------------------------------
 aic7xxx_osm.h |    4 
 2 files changed, 194 insertions(+), 441 deletions(-)

James

--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -458,26 +458,20 @@ static struct ahc_linux_device*	ahc_linu
 						       u_int);
 static void			ahc_linux_free_device(struct ahc_softc*,
 						      struct ahc_linux_device*);
-static void ahc_linux_run_device_queue(struct ahc_softc*,
-				       struct ahc_linux_device*);
+static int ahc_linux_run_command(struct ahc_softc*,
+				 struct ahc_linux_device *,
+				 struct scsi_cmnd *);
 static void ahc_linux_setup_tag_info_global(char *p);
 static aic_option_callback_t ahc_linux_setup_tag_info;
 static int  aic7xxx_setup(char *s);
 static int  ahc_linux_next_unit(void);
-static void ahc_runq_tasklet(unsigned long data);
 static struct ahc_cmd *ahc_linux_run_complete_queue(struct ahc_softc *ahc);
 
 /********************************* Inlines ************************************/
-static __inline void ahc_schedule_runq(struct ahc_softc *ahc);
 static __inline struct ahc_linux_device*
 		     ahc_linux_get_device(struct ahc_softc *ahc, u_int channel,
 					  u_int target, u_int lun, int alloc);
 static __inline void ahc_schedule_completeq(struct ahc_softc *ahc);
-static __inline void ahc_linux_check_device_queue(struct ahc_softc *ahc,
-						  struct ahc_linux_device *dev);
-static __inline struct ahc_linux_device *
-		     ahc_linux_next_device_to_run(struct ahc_softc *ahc);
-static __inline void ahc_linux_run_device_queues(struct ahc_softc *ahc);
 static __inline void ahc_linux_unmap_scb(struct ahc_softc*, struct scb*);
 
 static __inline int ahc_linux_map_seg(struct ahc_softc *ahc, struct scb *scb,
@@ -494,15 +488,6 @@ ahc_schedule_completeq(struct ahc_softc 
 	}
 }
 
-/*
- * Must be called with our lock held.
- */
-static __inline void
-ahc_schedule_runq(struct ahc_softc *ahc)
-{
-	tasklet_schedule(&ahc->platform_data->runq_tasklet);
-}
-
 static __inline struct ahc_linux_device*
 ahc_linux_get_device(struct ahc_softc *ahc, u_int channel, u_int target,
 		     u_int lun, int alloc)
@@ -569,45 +554,6 @@ ahc_linux_run_complete_queue(struct ahc_
 }
 
 static __inline void
-ahc_linux_check_device_queue(struct ahc_softc *ahc,
-			     struct ahc_linux_device *dev)
-{
-	if ((dev->flags & AHC_DEV_FREEZE_TIL_EMPTY) != 0
-	 && dev->active == 0) {
-		dev->flags &= ~AHC_DEV_FREEZE_TIL_EMPTY;
-		dev->qfrozen--;
-	}
-
-	if (TAILQ_FIRST(&dev->busyq) == NULL
-	 || dev->openings == 0 || dev->qfrozen != 0)
-		return;
-
-	ahc_linux_run_device_queue(ahc, dev);
-}
-
-static __inline struct ahc_linux_device *
-ahc_linux_next_device_to_run(struct ahc_softc *ahc)
-{
-	
-	if ((ahc->flags & AHC_RESOURCE_SHORTAGE) != 0
-	    || (ahc->platform_data->qfrozen != 0))
-		return (NULL);
-	return (TAILQ_FIRST(&ahc->platform_data->device_runq));
-}
-
-static __inline void
-ahc_linux_run_device_queues(struct ahc_softc *ahc)
-{
-	struct ahc_linux_device *dev;
-
-	while ((dev = ahc_linux_next_device_to_run(ahc)) != NULL) {
-		TAILQ_REMOVE(&ahc->platform_data->device_runq, dev, links);
-		dev->flags &= ~AHC_DEV_ON_RUN_LIST;
-		ahc_linux_check_device_queue(ahc, dev);
-	}
-}
-
-static __inline void
 ahc_linux_unmap_scb(struct ahc_softc *ahc, struct scb *scb)
 {
 	Scsi_Cmnd *cmd;
@@ -871,7 +817,6 @@ ahc_linux_queue(Scsi_Cmnd * cmd, void (*
 {
 	struct	 ahc_softc *ahc;
 	struct	 ahc_linux_device *dev;
-	u_long	 flags;
 
 	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
 
@@ -880,42 +825,22 @@ ahc_linux_queue(Scsi_Cmnd * cmd, void (*
 	 */
 	cmd->scsi_done = scsi_done;
 
-	ahc_midlayer_entrypoint_lock(ahc, &flags);
-
 	/*
 	 * Close the race of a command that was in the process of
 	 * being queued to us just as our simq was frozen.  Let
 	 * DV commands through so long as we are only frozen to
 	 * perform DV.
 	 */
-	if (ahc->platform_data->qfrozen != 0) {
+	if (ahc->platform_data->qfrozen != 0)
+		return SCSI_MLQUEUE_HOST_BUSY;
 
-		ahc_cmd_set_transaction_status(cmd, CAM_REQUEUE_REQ);
-		ahc_linux_queue_cmd_complete(ahc, cmd);
-		ahc_schedule_completeq(ahc);
-		ahc_midlayer_entrypoint_unlock(ahc, &flags);
-		return (0);
-	}
 	dev = ahc_linux_get_device(ahc, cmd->device->channel, cmd->device->id,
 				   cmd->device->lun, /*alloc*/TRUE);
-	if (dev == NULL) {
-		ahc_cmd_set_transaction_status(cmd, CAM_RESRC_UNAVAIL);
-		ahc_linux_queue_cmd_complete(ahc, cmd);
-		ahc_schedule_completeq(ahc);
-		ahc_midlayer_entrypoint_unlock(ahc, &flags);
-		printf("%s: aic7xxx_linux_queue - Unable to allocate device!\n",
-		       ahc_name(ahc));
-		return (0);
-	}
+	BUG_ON(dev == NULL);
+
 	cmd->result = CAM_REQ_INPROG << 16;
-	TAILQ_INSERT_TAIL(&dev->busyq, (struct ahc_cmd *)cmd, acmd_links.tqe);
-	if ((dev->flags & AHC_DEV_ON_RUN_LIST) == 0) {
-		TAILQ_INSERT_TAIL(&ahc->platform_data->device_runq, dev, links);
-		dev->flags |= AHC_DEV_ON_RUN_LIST;
-		ahc_linux_run_device_queues(ahc);
-	}
-	ahc_midlayer_entrypoint_unlock(ahc, &flags);
-	return (0);
+
+	return ahc_linux_run_command(ahc, dev, cmd);
 }
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
@@ -987,8 +912,7 @@ ahc_linux_slave_destroy(Scsi_Device *dev
 	if (dev != NULL
 	 && (dev->flags & AHC_DEV_SLAVE_CONFIGURED) != 0) {
 		dev->flags |= AHC_DEV_UNCONFIGURED;
-		if (TAILQ_EMPTY(&dev->busyq)
-		 && dev->active == 0
+		if (dev->active == 0
 	 	 && (dev->flags & AHC_DEV_TIMER_ACTIVE) == 0)
 			ahc_linux_free_device(ahc, dev);
 	}
@@ -1206,33 +1130,6 @@ Scsi_Host_Template aic7xxx_driver_templa
 
 /**************************** Tasklet Handler *********************************/
 
-/*
- * In 2.4.X and above, this routine is called from a tasklet,
- * so we must re-acquire our lock prior to executing this code.
- * In all prior kernels, ahc_schedule_runq() calls this routine
- * directly and ahc_schedule_runq() is called with our lock held.
- */
-static void
-ahc_runq_tasklet(unsigned long data)
-{
-	struct ahc_softc* ahc;
-	struct ahc_linux_device *dev;
-	u_long flags;
-
-	ahc = (struct ahc_softc *)data;
-	ahc_lock(ahc, &flags);
-	while ((dev = ahc_linux_next_device_to_run(ahc)) != NULL) {
-	
-		TAILQ_REMOVE(&ahc->platform_data->device_runq, dev, links);
-		dev->flags &= ~AHC_DEV_ON_RUN_LIST;
-		ahc_linux_check_device_queue(ahc, dev);
-		/* Yeild to our interrupt handler */
-		ahc_unlock(ahc, &flags);
-		ahc_lock(ahc, &flags);
-	}
-	ahc_unlock(ahc, &flags);
-}
-
 /******************************** Macros **************************************/
 #define BUILD_SCSIID(ahc, cmd)						    \
 	((((cmd)->device->id << TID_SHIFT) & TID)			    \
@@ -1728,8 +1625,6 @@ ahc_platform_alloc(struct ahc_softc *ahc
 	ahc->platform_data->completeq_timer.function =
 	    (ahc_linux_callback_t *)ahc_linux_thread_run_complete_queue;
 	init_MUTEX_LOCKED(&ahc->platform_data->eh_sem);
-	tasklet_init(&ahc->platform_data->runq_tasklet, ahc_runq_tasklet,
-		     (unsigned long)ahc);
 	ahc->seltime = (aic7xxx_seltime & 0x3) << 4;
 	ahc->seltime_b = (aic7xxx_seltime & 0x3) << 4;
 	if (aic7xxx_pci_parity == 0)
@@ -1747,7 +1642,6 @@ ahc_platform_free(struct ahc_softc *ahc)
 
 	if (ahc->platform_data != NULL) {
 		del_timer_sync(&ahc->platform_data->completeq_timer);
-		tasklet_kill(&ahc->platform_data->runq_tasklet);
 		if (ahc->platform_data->host != NULL) {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 			scsi_remove_host(ahc->platform_data->host);
@@ -1906,71 +1800,7 @@ int
 ahc_platform_abort_scbs(struct ahc_softc *ahc, int target, char channel,
 			int lun, u_int tag, role_t role, uint32_t status)
 {
-	int chan;
-	int maxchan;
-	int targ;
-	int maxtarg;
-	int clun;
-	int maxlun;
-	int count;
-
-	if (tag != SCB_LIST_NULL)
-		return (0);
-
-	chan = 0;
-	if (channel != ALL_CHANNELS) {
-		chan = channel - 'A';
-		maxchan = chan + 1;
-	} else {
-		maxchan = (ahc->features & AHC_TWIN) ? 2 : 1;
-	}
-	targ = 0;
-	if (target != CAM_TARGET_WILDCARD) {
-		targ = target;
-		maxtarg = targ + 1;
-	} else {
-		maxtarg = (ahc->features & AHC_WIDE) ? 16 : 8;
-	}
-	clun = 0;
-	if (lun != CAM_LUN_WILDCARD) {
-		clun = lun;
-		maxlun = clun + 1;
-	} else {
-		maxlun = AHC_NUM_LUNS;
-	}
-
-	count = 0;
-	for (; chan < maxchan; chan++) {
-
-		for (; targ < maxtarg; targ++) {
-
-			for (; clun < maxlun; clun++) {
-				struct ahc_linux_device *dev;
-				struct ahc_busyq *busyq;
-				struct ahc_cmd *acmd;
-
-				dev = ahc_linux_get_device(ahc, chan,
-							   targ, clun,
-							   /*alloc*/FALSE);
-				if (dev == NULL)
-					continue;
-
-				busyq = &dev->busyq;
-				while ((acmd = TAILQ_FIRST(busyq)) != NULL) {
-					Scsi_Cmnd *cmd;
-
-					cmd = &acmd_scsi_cmd(acmd);
-					TAILQ_REMOVE(busyq, acmd,
-						     acmd_links.tqe);
-					count++;
-					cmd->result = status << 16;
-					ahc_linux_queue_cmd_complete(ahc, cmd);
-				}
-			}
-		}
-	}
-
-	return (count);
+	return 0;
 }
 
 static void
@@ -2045,213 +1875,203 @@ ahc_linux_device_queue_depth(struct ahc_
 	}
 }
 
-static void
-ahc_linux_run_device_queue(struct ahc_softc *ahc, struct ahc_linux_device *dev)
+static int
+ahc_linux_run_command(struct ahc_softc *ahc, struct ahc_linux_device *dev,
+		      struct scsi_cmnd *cmd)
 {
-	struct	 ahc_cmd *acmd;
-	struct	 scsi_cmnd *cmd;
 	struct	 scb *scb;
 	struct	 hardware_scb *hscb;
 	struct	 ahc_initiator_tinfo *tinfo;
 	struct	 ahc_tmode_tstate *tstate;
 	uint16_t mask;
+	struct scb_tailq *untagged_q = NULL;
 
-	if ((dev->flags & AHC_DEV_ON_RUN_LIST) != 0)
-		panic("running device on run list");
+	/*
+	 * Schedule us to run later.  The only reason we are not
+	 * running is because the whole controller Q is frozen.
+	 */
+	if (ahc->platform_data->qfrozen != 0)
+		return SCSI_MLQUEUE_HOST_BUSY;
 
-	while ((acmd = TAILQ_FIRST(&dev->busyq)) != NULL
-	    && dev->openings > 0 && dev->qfrozen == 0) {
+	/*
+	 * We only allow one untagged transaction
+	 * per target in the initiator role unless
+	 * we are storing a full busy target *lun*
+	 * table in SCB space.
+	 */
+	if (!blk_rq_tagged(cmd->request)
+	    && (ahc->features & AHC_SCB_BTT) == 0) {
+		int target_offset;
 
-		/*
-		 * Schedule us to run later.  The only reason we are not
-		 * running is because the whole controller Q is frozen.
-		 */
-		if (ahc->platform_data->qfrozen != 0) {
-			TAILQ_INSERT_TAIL(&ahc->platform_data->device_runq,
-					  dev, links);
-			dev->flags |= AHC_DEV_ON_RUN_LIST;
-			return;
-		}
-		/*
-		 * Get an scb to use.
-		 */
-		if ((scb = ahc_get_scb(ahc)) == NULL) {
-			TAILQ_INSERT_TAIL(&ahc->platform_data->device_runq,
-					 dev, links);
-			dev->flags |= AHC_DEV_ON_RUN_LIST;
+		target_offset = cmd->device->id + cmd->device->channel * 8;
+		untagged_q = &(ahc->untagged_queues[target_offset]);
+		if (!TAILQ_EMPTY(untagged_q))
+			/* if we're already executing an untagged command
+			 * we're busy to another */
+			return SCSI_MLQUEUE_DEVICE_BUSY;
+	}
+
+	/*
+	 * Get an scb to use.
+	 */
+	if ((scb = ahc_get_scb(ahc)) == NULL) {
 			ahc->flags |= AHC_RESOURCE_SHORTAGE;
-			return;
-		}
-		TAILQ_REMOVE(&dev->busyq, acmd, acmd_links.tqe);
-		cmd = &acmd_scsi_cmd(acmd);
-		scb->io_ctx = cmd;
-		scb->platform_data->dev = dev;
-		hscb = scb->hscb;
-		cmd->host_scribble = (char *)scb;
-
-		/*
-		 * Fill out basics of the HSCB.
-		 */
-		hscb->control = 0;
-		hscb->scsiid = BUILD_SCSIID(ahc, cmd);
-		hscb->lun = cmd->device->lun;
-		mask = SCB_GET_TARGET_MASK(ahc, scb);
-		tinfo = ahc_fetch_transinfo(ahc, SCB_GET_CHANNEL(ahc, scb),
-					    SCB_GET_OUR_ID(scb),
-					    SCB_GET_TARGET(ahc, scb), &tstate);
-		hscb->scsirate = tinfo->scsirate;
-		hscb->scsioffset = tinfo->curr.offset;
-		if ((tstate->ultraenb & mask) != 0)
-			hscb->control |= ULTRAENB;
-
-		if ((ahc->user_discenable & mask) != 0)
-			hscb->control |= DISCENB;
-
-		if ((tstate->auto_negotiate & mask) != 0) {
-			scb->flags |= SCB_AUTO_NEGOTIATE;
-			scb->hscb->control |= MK_MESSAGE;
-		}
+			return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
-		if ((dev->flags & (AHC_DEV_Q_TAGGED|AHC_DEV_Q_BASIC)) != 0) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-			int	msg_bytes;
-			uint8_t tag_msgs[2];
+	scb->io_ctx = cmd;
+	scb->platform_data->dev = dev;
+	hscb = scb->hscb;
+	cmd->host_scribble = (char *)scb;
+
+	/*
+	 * Fill out basics of the HSCB.
+	 */
+	hscb->control = 0;
+	hscb->scsiid = BUILD_SCSIID(ahc, cmd);
+	hscb->lun = cmd->device->lun;
+	mask = SCB_GET_TARGET_MASK(ahc, scb);
+	tinfo = ahc_fetch_transinfo(ahc, SCB_GET_CHANNEL(ahc, scb),
+				    SCB_GET_OUR_ID(scb),
+				    SCB_GET_TARGET(ahc, scb), &tstate);
+	hscb->scsirate = tinfo->scsirate;
+	hscb->scsioffset = tinfo->curr.offset;
+	if ((tstate->ultraenb & mask) != 0)
+		hscb->control |= ULTRAENB;
+	
+	if ((ahc->user_discenable & mask) != 0)
+		hscb->control |= DISCENB;
+	
+	if ((tstate->auto_negotiate & mask) != 0) {
+		scb->flags |= SCB_AUTO_NEGOTIATE;
+		scb->hscb->control |= MK_MESSAGE;
+	}
 
-			msg_bytes = scsi_populate_tag_msg(cmd, tag_msgs);
-			if (msg_bytes && tag_msgs[0] != MSG_SIMPLE_TASK) {
-				hscb->control |= tag_msgs[0];
-				if (tag_msgs[0] == MSG_ORDERED_TASK)
-					dev->commands_since_idle_or_otag = 0;
-			} else
-#endif
-			if (dev->commands_since_idle_or_otag == AHC_OTAG_THRESH
-			 && (dev->flags & AHC_DEV_Q_TAGGED) != 0) {
-				hscb->control |= MSG_ORDERED_TASK;
+	if ((dev->flags & (AHC_DEV_Q_TAGGED|AHC_DEV_Q_BASIC)) != 0) {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+		int	msg_bytes;
+		uint8_t tag_msgs[2];
+		
+		msg_bytes = scsi_populate_tag_msg(cmd, tag_msgs);
+		if (msg_bytes && tag_msgs[0] != MSG_SIMPLE_TASK) {
+			hscb->control |= tag_msgs[0];
+			if (tag_msgs[0] == MSG_ORDERED_TASK)
 				dev->commands_since_idle_or_otag = 0;
-			} else {
-				hscb->control |= MSG_SIMPLE_TASK;
-			}
-		}
-
-		hscb->cdb_len = cmd->cmd_len;
-		if (hscb->cdb_len <= 12) {
-			memcpy(hscb->shared_data.cdb, cmd->cmnd, hscb->cdb_len);
+		} else
+#endif
+		if (dev->commands_since_idle_or_otag == AHC_OTAG_THRESH
+		    && (dev->flags & AHC_DEV_Q_TAGGED) != 0) {
+			hscb->control |= MSG_ORDERED_TASK;
+			dev->commands_since_idle_or_otag = 0;
 		} else {
-			memcpy(hscb->cdb32, cmd->cmnd, hscb->cdb_len);
-			scb->flags |= SCB_CDB32_PTR;
+			hscb->control |= MSG_SIMPLE_TASK;
 		}
+	}
 
-		scb->platform_data->xfer_len = 0;
-		ahc_set_residual(scb, 0);
-		ahc_set_sense_residual(scb, 0);
-		scb->sg_count = 0;
-		if (cmd->use_sg != 0) {
-			struct	ahc_dma_seg *sg;
-			struct	scatterlist *cur_seg;
-			struct	scatterlist *end_seg;
-			int	nseg;
-
-			cur_seg = (struct scatterlist *)cmd->request_buffer;
-			nseg = pci_map_sg(ahc->dev_softc, cur_seg, cmd->use_sg,
-			    cmd->sc_data_direction);
-			end_seg = cur_seg + nseg;
-			/* Copy the segments into the SG list. */
-			sg = scb->sg_list;
-			/*
-			 * The sg_count may be larger than nseg if
-			 * a transfer crosses a 32bit page.
-			 */ 
-			while (cur_seg < end_seg) {
-				dma_addr_t addr;
-				bus_size_t len;
-				int consumed;
-
-				addr = sg_dma_address(cur_seg);
-				len = sg_dma_len(cur_seg);
-				consumed = ahc_linux_map_seg(ahc, scb,
-							     sg, addr, len);
-				sg += consumed;
-				scb->sg_count += consumed;
-				cur_seg++;
-			}
-			sg--;
-			sg->len |= ahc_htole32(AHC_DMA_LAST_SEG);
-
-			/*
-			 * Reset the sg list pointer.
-			 */
-			scb->hscb->sgptr =
-			    ahc_htole32(scb->sg_list_phys | SG_FULL_RESID);
+	hscb->cdb_len = cmd->cmd_len;
+	if (hscb->cdb_len <= 12) {
+		memcpy(hscb->shared_data.cdb, cmd->cmnd, hscb->cdb_len);
+	} else {
+		memcpy(hscb->cdb32, cmd->cmnd, hscb->cdb_len);
+		scb->flags |= SCB_CDB32_PTR;
+	}
 
-			/*
-			 * Copy the first SG into the "current"
-			 * data pointer area.
-			 */
-			scb->hscb->dataptr = scb->sg_list->addr;
-			scb->hscb->datacnt = scb->sg_list->len;
-		} else if (cmd->request_bufflen != 0) {
-			struct	 ahc_dma_seg *sg;
+	scb->platform_data->xfer_len = 0;
+	ahc_set_residual(scb, 0);
+	ahc_set_sense_residual(scb, 0);
+	scb->sg_count = 0;
+	if (cmd->use_sg != 0) {
+		struct	ahc_dma_seg *sg;
+		struct	scatterlist *cur_seg;
+		struct	scatterlist *end_seg;
+		int	nseg;
+
+		cur_seg = (struct scatterlist *)cmd->request_buffer;
+		nseg = pci_map_sg(ahc->dev_softc, cur_seg, cmd->use_sg,
+				  cmd->sc_data_direction);
+		end_seg = cur_seg + nseg;
+		/* Copy the segments into the SG list. */
+		sg = scb->sg_list;
+		/*
+		 * The sg_count may be larger than nseg if
+		 * a transfer crosses a 32bit page.
+		 */ 
+		while (cur_seg < end_seg) {
 			dma_addr_t addr;
+			bus_size_t len;
+			int consumed;
 
-			sg = scb->sg_list;
-			addr = pci_map_single(ahc->dev_softc,
-			       cmd->request_buffer,
-			       cmd->request_bufflen,
-			       cmd->sc_data_direction);
-			scb->platform_data->buf_busaddr = addr;
-			scb->sg_count = ahc_linux_map_seg(ahc, scb,
-							  sg, addr,
-							  cmd->request_bufflen);
-			sg->len |= ahc_htole32(AHC_DMA_LAST_SEG);
+			addr = sg_dma_address(cur_seg);
+			len = sg_dma_len(cur_seg);
+			consumed = ahc_linux_map_seg(ahc, scb,
+						     sg, addr, len);
+			sg += consumed;
+			scb->sg_count += consumed;
+			cur_seg++;
+		}
+		sg--;
+		sg->len |= ahc_htole32(AHC_DMA_LAST_SEG);
 
-			/*
-			 * Reset the sg list pointer.
-			 */
-			scb->hscb->sgptr =
-			    ahc_htole32(scb->sg_list_phys | SG_FULL_RESID);
+		/*
+		 * Reset the sg list pointer.
+		 */
+		scb->hscb->sgptr =
+			ahc_htole32(scb->sg_list_phys | SG_FULL_RESID);
+		
+		/*
+		 * Copy the first SG into the "current"
+		 * data pointer area.
+		 */
+		scb->hscb->dataptr = scb->sg_list->addr;
+		scb->hscb->datacnt = scb->sg_list->len;
+	} else if (cmd->request_bufflen != 0) {
+		struct	 ahc_dma_seg *sg;
+		dma_addr_t addr;
 
-			/*
-			 * Copy the first SG into the "current"
-			 * data pointer area.
-			 */
-			scb->hscb->dataptr = sg->addr;
-			scb->hscb->datacnt = sg->len;
-		} else {
-			scb->hscb->sgptr = ahc_htole32(SG_LIST_NULL);
-			scb->hscb->dataptr = 0;
-			scb->hscb->datacnt = 0;
-			scb->sg_count = 0;
-		}
-
-		ahc_sync_sglist(ahc, scb, BUS_DMASYNC_PREWRITE);
-		LIST_INSERT_HEAD(&ahc->pending_scbs, scb, pending_links);
-		dev->openings--;
-		dev->active++;
-		dev->commands_issued++;
-		if ((dev->flags & AHC_DEV_PERIODIC_OTAG) != 0)
-			dev->commands_since_idle_or_otag++;
-
-		/*
-		 * We only allow one untagged transaction
-		 * per target in the initiator role unless
-		 * we are storing a full busy target *lun*
-		 * table in SCB space.
-		 */
-		if ((scb->hscb->control & (TARGET_SCB|TAG_ENB)) == 0
-		 && (ahc->features & AHC_SCB_BTT) == 0) {
-			struct scb_tailq *untagged_q;
-			int target_offset;
-
-			target_offset = SCB_GET_TARGET_OFFSET(ahc, scb);
-			untagged_q = &(ahc->untagged_queues[target_offset]);
-			TAILQ_INSERT_TAIL(untagged_q, scb, links.tqe);
-			scb->flags |= SCB_UNTAGGEDQ;
-			if (TAILQ_FIRST(untagged_q) != scb)
-				continue;
-		}
-		scb->flags |= SCB_ACTIVE;
-		ahc_queue_scb(ahc, scb);
+		sg = scb->sg_list;
+		addr = pci_map_single(ahc->dev_softc,
+				      cmd->request_buffer,
+				      cmd->request_bufflen,
+				      cmd->sc_data_direction);
+		scb->platform_data->buf_busaddr = addr;
+		scb->sg_count = ahc_linux_map_seg(ahc, scb,
+						  sg, addr,
+						  cmd->request_bufflen);
+		sg->len |= ahc_htole32(AHC_DMA_LAST_SEG);
+
+		/*
+		 * Reset the sg list pointer.
+		 */
+		scb->hscb->sgptr =
+			ahc_htole32(scb->sg_list_phys | SG_FULL_RESID);
+
+		/*
+		 * Copy the first SG into the "current"
+		 * data pointer area.
+		 */
+		scb->hscb->dataptr = sg->addr;
+		scb->hscb->datacnt = sg->len;
+	} else {
+		scb->hscb->sgptr = ahc_htole32(SG_LIST_NULL);
+		scb->hscb->dataptr = 0;
+		scb->hscb->datacnt = 0;
+		scb->sg_count = 0;
 	}
+
+	LIST_INSERT_HEAD(&ahc->pending_scbs, scb, pending_links);
+	dev->openings--;
+	dev->active++;
+	dev->commands_issued++;
+	if ((dev->flags & AHC_DEV_PERIODIC_OTAG) != 0)
+		dev->commands_since_idle_or_otag++;
+	
+	scb->flags |= SCB_ACTIVE;
+	if (untagged_q) {
+		TAILQ_INSERT_TAIL(untagged_q, scb, links.tqe);
+		scb->flags |= SCB_UNTAGGEDQ;
+	}
+	ahc_queue_scb(ahc, scb);
+	return 0;
 }
 
 /*
@@ -2267,8 +2087,6 @@ ahc_linux_isr(int irq, void *dev_id, str
 	ahc = (struct ahc_softc *) dev_id;
 	ahc_lock(ahc, &flags); 
 	ours = ahc_intr(ahc);
-	if (ahc_linux_next_device_to_run(ahc) != NULL)
-		ahc_schedule_runq(ahc);
 	ahc_linux_run_complete_queue(ahc);
 	ahc_unlock(ahc, &flags);
 	return IRQ_RETVAL(ours);
@@ -2349,7 +2167,6 @@ ahc_linux_alloc_device(struct ahc_softc 
 		return (NULL);
 	memset(dev, 0, sizeof(*dev));
 	init_timer(&dev->timer);
-	TAILQ_INIT(&dev->busyq);
 	dev->flags = AHC_DEV_UNCONFIGURED;
 	dev->lun = lun;
 	dev->target = targ;
@@ -2515,7 +2332,7 @@ ahc_done(struct ahc_softc *ahc, struct s
 		target_offset = SCB_GET_TARGET_OFFSET(ahc, scb);
 		untagged_q = &(ahc->untagged_queues[target_offset]);
 		TAILQ_REMOVE(untagged_q, scb, links.tqe);
-		ahc_run_untagged_queue(ahc, untagged_q);
+		BUG_ON(!TAILQ_EMPTY(untagged_q));
 	}
 
 	if ((scb->flags & SCB_ACTIVE) == 0) {
@@ -2606,12 +2423,11 @@ ahc_done(struct ahc_softc *ahc, struct s
 	if (dev->active == 0)
 		dev->commands_since_idle_or_otag = 0;
 
-	if (TAILQ_EMPTY(&dev->busyq)) {
-		if ((dev->flags & AHC_DEV_UNCONFIGURED) != 0
-		 && dev->active == 0
-	 	 && (dev->flags & AHC_DEV_TIMER_ACTIVE) == 0)
-			ahc_linux_free_device(ahc, dev);
-	} else if ((dev->flags & AHC_DEV_ON_RUN_LIST) == 0) {
+	if ((dev->flags & AHC_DEV_UNCONFIGURED) != 0
+	    && dev->active == 0
+	    && (dev->flags & AHC_DEV_TIMER_ACTIVE) == 0)
+		ahc_linux_free_device(ahc, dev);
+	else if ((dev->flags & AHC_DEV_ON_RUN_LIST) == 0) {
 		TAILQ_INSERT_TAIL(&ahc->platform_data->device_runq, dev, links);
 		dev->flags |= AHC_DEV_ON_RUN_LIST;
 	}
@@ -2940,7 +2756,6 @@ ahc_linux_release_simq(u_long arg)
 		ahc->platform_data->qfrozen--;
 	if (ahc->platform_data->qfrozen == 0)
 		unblock_reqs = 1;
-	ahc_schedule_runq(ahc);
 	ahc_unlock(ahc, &s);
 	/*
 	 * There is still a race here.  The mid-layer
@@ -2965,11 +2780,7 @@ ahc_linux_dev_timed_unfreeze(u_long arg)
 	dev->flags &= ~AHC_DEV_TIMER_ACTIVE;
 	if (dev->qfrozen > 0)
 		dev->qfrozen--;
-	if (dev->qfrozen == 0
-	 && (dev->flags & AHC_DEV_ON_RUN_LIST) == 0)
-		ahc_linux_run_device_queue(ahc, dev);
-	if (TAILQ_EMPTY(&dev->busyq)
-	 && dev->active == 0)
+	if (dev->active == 0)
 		__ahc_linux_free_device(ahc, dev);
 	ahc_unlock(ahc, &s);
 }
@@ -2978,8 +2789,6 @@ static int
 ahc_linux_queue_recovery_cmd(Scsi_Cmnd *cmd, scb_flag flag)
 {
 	struct ahc_softc *ahc;
-	struct ahc_cmd *acmd;
-	struct ahc_cmd *list_acmd;
 	struct ahc_linux_device *dev;
 	struct scb *pending_scb;
 	u_long s;
@@ -2998,7 +2807,6 @@ ahc_linux_queue_recovery_cmd(Scsi_Cmnd *
 	paused = FALSE;
 	wait = FALSE;
 	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
-	acmd = (struct ahc_cmd *)cmd;
 
 	printf("%s:%d:%d:%d: Attempting to queue a%s message\n",
 	       ahc_name(ahc), cmd->device->channel,
@@ -3048,24 +2856,6 @@ ahc_linux_queue_recovery_cmd(Scsi_Cmnd *
 		goto no_cmd;
 	}
 
-	TAILQ_FOREACH(list_acmd, &dev->busyq, acmd_links.tqe) {
-		if (list_acmd == acmd)
-			break;
-	}
-
-	if (list_acmd != NULL) {
-		printf("%s:%d:%d:%d: Command found on device queue\n",
-		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
-		if (flag == SCB_ABORT) {
-			TAILQ_REMOVE(&dev->busyq, list_acmd, acmd_links.tqe);
-			cmd->result = DID_ABORT << 16;
-			ahc_linux_queue_cmd_complete(ahc, cmd);
-			retval = SUCCESS;
-			goto done;
-		}
-	}
-
 	if ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED)) == 0
 	 && ahc_search_untagged_queues(ahc, cmd, cmd->device->id,
 				       cmd->device->channel + 'A',
@@ -3299,7 +3089,6 @@ done:
 		}
 		spin_lock_irq(&ahc->platform_data->spin_lock);
 	}
-	ahc_schedule_runq(ahc);
 	ahc_linux_run_complete_queue(ahc);
 	ahc_midlayer_entrypoint_unlock(ahc, &s);
 	return (retval);
@@ -3308,40 +3097,6 @@ done:
 void
 ahc_platform_dump_card_state(struct ahc_softc *ahc)
 {
-	struct ahc_linux_device *dev;
-	int channel;
-	int maxchannel;
-	int target;
-	int maxtarget;
-	int lun;
-	int i;
-
-	maxchannel = (ahc->features & AHC_TWIN) ? 1 : 0;
-	maxtarget = (ahc->features & AHC_WIDE) ? 15 : 7;
-	for (channel = 0; channel <= maxchannel; channel++) {
-
-		for (target = 0; target <=maxtarget; target++) {
-
-			for (lun = 0; lun < AHC_NUM_LUNS; lun++) {
-				struct ahc_cmd *acmd;
-
-				dev = ahc_linux_get_device(ahc, channel, target,
-							   lun, /*alloc*/FALSE);
-				if (dev == NULL)
-					continue;
-
-				printf("DevQ(%d:%d:%d): ",
-				       channel, target, lun);
-				i = 0;
-				TAILQ_FOREACH(acmd, &dev->busyq,
-					      acmd_links.tqe) {
-					if (i++ > AHC_SCB_MAX)
-						break;
-				}
-				printf("%d waiting\n", i);
-			}
-		}
-	}
 }
 
 static void ahc_linux_exit(void);
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -66,11 +66,11 @@
 #include <linux/pci.h>
 #include <linux/smp_lock.h>
 #include <linux/version.h>
+#include <linux/interrupt.h>
 #include <linux/module.h>
 #include <asm/byteorder.h>
 #include <asm/io.h>
 
-#include <linux/interrupt.h> /* For tasklet support. */
 #include <linux/config.h>
 #include <linux/slab.h>
 
@@ -341,7 +341,6 @@ typedef enum {
 struct ahc_linux_target;
 struct ahc_linux_device {
 	TAILQ_ENTRY(ahc_linux_device) links;
-	struct		ahc_busyq busyq;
 
 	/*
 	 * The number of transactions currently
@@ -488,7 +487,6 @@ struct ahc_platform_data {
 	struct ahc_completeq	 completeq;
 
 	spinlock_t		 spin_lock;
-	struct tasklet_struct	 runq_tasklet;
 	u_int			 qfrozen;
 	pid_t			 dv_pid;
 	struct timer_list	 completeq_timer;


