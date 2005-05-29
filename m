From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 3/4] aic79xx: remove busyq
Date: Sun, 29 May 2005 03:41:07 -0400
Message-ID: <20050529074107.GA25993@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlmail.prod.rxgsys.com ([69.61.70.25]:24457 "EHLO
	bastet.signetmail.com") by vger.kernel.org with ESMTP
	id S261268AbVE2HlQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 May 2005 03:41:16 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by bastet.signetmail.com (RXG Elite Mail Server) with ESMTP id 3FA9BA883F
	for <linux-scsi@vger.kernel.org>; Sun, 29 May 2005 02:20:29 -0400 (EDT)
Received: from bastet.signetmail.com ([127.0.0.1])
 by localhost (atlmail.prod.rxgsys.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 30283-08 for <linux-scsi@vger.kernel.org>;
 Sun, 29 May 2005 02:20:21 -0400 (EDT)
Received: from havoc.gtf.org (havoc.gtf.org [63.115.148.101])
	by bastet.signetmail.com (RXG Elite Mail Server) with ESMTP id 294ABA8818
	for <linux-scsi@vger.kernel.org>; Sun, 29 May 2005 02:20:21 -0400 (EDT)
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 4B57B1C1E97D
	for <linux-scsi@vger.kernel.org>; Sun, 29 May 2005 03:41:07 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j4T7f7Go026006
	for linux-scsi@vger.kernel.org; Sun, 29 May 2005 03:41:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



[note:  just for review...  do not apply, will be submitted later via git]

author Jeff Garzik <jgarzik@pobox.com> Sun, 29 May 2005 11:34:17 -0400
committer Jeff Garzik <jgarzik@pobox.com> Sun, 29 May 2005 11:34:17 -0400

[SCSI] aic79xx: remove busyq

The aic79xx driver has two spurious queues in it's linux glue code: the
busyq which queues incoming commands to the driver and the completeq
which queues finished commands before sending them back to the mid-layer

This patch just removes the busyq and makes the aic finally return the
correct status to get the mid-layer to manage its queueing, so a command
is either committed to the sequencer or returned to the midlayer for
requeue.

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -9039,7 +9039,6 @@ ahd_dump_card_state(struct ahd_softc *ah
 		ahd_outb(ahd, STACK, (ahd->saved_stack[i] >> 8) & 0xFF);
 	}
 	printf("\n<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>\n");
-	ahd_platform_dump_card_state(ahd);
 	ahd_restore_modes(ahd, saved_modes);
 	if (paused == 0)
 		ahd_unpause(ahd);
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -505,31 +505,23 @@ static struct ahd_linux_device*	ahd_linu
 						       u_int);
 static void			ahd_linux_free_device(struct ahd_softc*,
 						      struct ahd_linux_device*);
-static void ahd_linux_run_device_queue(struct ahd_softc*,
-				       struct ahd_linux_device*);
+static int ahd_linux_run_command(struct ahd_softc*,
+				 struct ahd_linux_device*,
+				 struct scsi_cmnd *);
 static void ahd_linux_setup_tag_info_global(char *p);
 static aic_option_callback_t ahd_linux_setup_tag_info;
 static aic_option_callback_t ahd_linux_setup_rd_strm_info;
 static aic_option_callback_t ahd_linux_setup_dv;
 static aic_option_callback_t ahd_linux_setup_iocell_info;
 static int ahd_linux_next_unit(void);
-static void ahd_runq_tasklet(unsigned long data);
 static int aic79xx_setup(char *c);
 
 /****************************** Inlines ***************************************/
 static __inline void ahd_schedule_completeq(struct ahd_softc *ahd);
-static __inline void ahd_schedule_runq(struct ahd_softc *ahd);
-static __inline void ahd_setup_runq_tasklet(struct ahd_softc *ahd);
-static __inline void ahd_teardown_runq_tasklet(struct ahd_softc *ahd);
 static __inline struct ahd_linux_device*
 		     ahd_linux_get_device(struct ahd_softc *ahd, u_int channel,
 					  u_int target, u_int lun, int alloc);
 static struct ahd_cmd *ahd_linux_run_complete_queue(struct ahd_softc *ahd);
-static __inline void ahd_linux_check_device_queue(struct ahd_softc *ahd,
-						  struct ahd_linux_device *dev);
-static __inline struct ahd_linux_device *
-		     ahd_linux_next_device_to_run(struct ahd_softc *ahd);
-static __inline void ahd_linux_run_device_queues(struct ahd_softc *ahd);
 static __inline void ahd_linux_unmap_scb(struct ahd_softc*, struct scb*);
 
 static __inline void
@@ -542,28 +534,6 @@ ahd_schedule_completeq(struct ahd_softc 
 	}
 }
 
-/*
- * Must be called with our lock held.
- */
-static __inline void
-ahd_schedule_runq(struct ahd_softc *ahd)
-{
-	tasklet_schedule(&ahd->platform_data->runq_tasklet);
-}
-
-static __inline
-void ahd_setup_runq_tasklet(struct ahd_softc *ahd)
-{
-	tasklet_init(&ahd->platform_data->runq_tasklet, ahd_runq_tasklet,
-		     (unsigned long)ahd);
-}
-
-static __inline void
-ahd_teardown_runq_tasklet(struct ahd_softc *ahd)
-{
-	tasklet_kill(&ahd->platform_data->runq_tasklet);
-}
-
 static __inline struct ahd_linux_device*
 ahd_linux_get_device(struct ahd_softc *ahd, u_int channel, u_int target,
 		     u_int lun, int alloc)
@@ -630,46 +600,6 @@ ahd_linux_run_complete_queue(struct ahd_
 }
 
 static __inline void
-ahd_linux_check_device_queue(struct ahd_softc *ahd,
-			     struct ahd_linux_device *dev)
-{
-	if ((dev->flags & AHD_DEV_FREEZE_TIL_EMPTY) != 0
-	 && dev->active == 0) {
-		dev->flags &= ~AHD_DEV_FREEZE_TIL_EMPTY;
-		dev->qfrozen--;
-	}
-
-	if (TAILQ_FIRST(&dev->busyq) == NULL
-	 || dev->openings == 0 || dev->qfrozen != 0)
-		return;
-
-	ahd_linux_run_device_queue(ahd, dev);
-}
-
-static __inline struct ahd_linux_device *
-ahd_linux_next_device_to_run(struct ahd_softc *ahd)
-{
-	
-	if ((ahd->flags & AHD_RESOURCE_SHORTAGE) != 0
-	 || (ahd->platform_data->qfrozen != 0
-	  && AHD_DV_SIMQ_FROZEN(ahd) == 0))
-		return (NULL);
-	return (TAILQ_FIRST(&ahd->platform_data->device_runq));
-}
-
-static __inline void
-ahd_linux_run_device_queues(struct ahd_softc *ahd)
-{
-	struct ahd_linux_device *dev;
-
-	while ((dev = ahd_linux_next_device_to_run(ahd)) != NULL) {
-		TAILQ_REMOVE(&ahd->platform_data->device_runq, dev, links);
-		dev->flags &= ~AHD_DEV_ON_RUN_LIST;
-		ahd_linux_check_device_queue(ahd, dev);
-	}
-}
-
-static __inline void
 ahd_linux_unmap_scb(struct ahd_softc *ahd, struct scb *scb)
 {
 	Scsi_Cmnd *cmd;
@@ -804,7 +734,6 @@ ahd_linux_queue(Scsi_Cmnd * cmd, void (*
 {
 	struct	 ahd_softc *ahd;
 	struct	 ahd_linux_device *dev;
-	u_long	 flags;
 
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
@@ -813,46 +742,23 @@ ahd_linux_queue(Scsi_Cmnd * cmd, void (*
 	 */
 	cmd->scsi_done = scsi_done;
 
-	ahd_midlayer_entrypoint_lock(ahd, &flags);
-
 	/*
 	 * Close the race of a command that was in the process of
 	 * being queued to us just as our simq was frozen.  Let
 	 * DV commands through so long as we are only frozen to
 	 * perform DV.
 	 */
-	if (ahd->platform_data->qfrozen != 0
-	 && AHD_DV_CMD(cmd) == 0) {
+	if (ahd->platform_data->qfrozen != 0)
+		return SCSI_MLQUEUE_HOST_BUSY;
 
-		ahd_cmd_set_transaction_status(cmd, CAM_REQUEUE_REQ);
-		ahd_linux_queue_cmd_complete(ahd, cmd);
-		ahd_schedule_completeq(ahd);
-		ahd_midlayer_entrypoint_unlock(ahd, &flags);
-		return (0);
-	}
 	dev = ahd_linux_get_device(ahd, cmd->device->channel,
 				   cmd->device->id, cmd->device->lun,
 				   /*alloc*/TRUE);
-	if (dev == NULL) {
-		ahd_cmd_set_transaction_status(cmd, CAM_RESRC_UNAVAIL);
-		ahd_linux_queue_cmd_complete(ahd, cmd);
-		ahd_schedule_completeq(ahd);
-		ahd_midlayer_entrypoint_unlock(ahd, &flags);
-		printf("%s: aic79xx_linux_queue - Unable to allocate device!\n",
-		       ahd_name(ahd));
-		return (0);
-	}
-	if (cmd->cmd_len > MAX_CDB_LEN)
-		return (-EINVAL);
+	BUG_ON(dev == NULL);
+
 	cmd->result = CAM_REQ_INPROG << 16;
-	TAILQ_INSERT_TAIL(&dev->busyq, (struct ahd_cmd *)cmd, acmd_links.tqe);
-	if ((dev->flags & AHD_DEV_ON_RUN_LIST) == 0) {
-		TAILQ_INSERT_TAIL(&ahd->platform_data->device_runq, dev, links);
-		dev->flags |= AHD_DEV_ON_RUN_LIST;
-		ahd_linux_run_device_queues(ahd);
-	}
-	ahd_midlayer_entrypoint_unlock(ahd, &flags);
-	return (0);
+
+	return ahd_linux_run_command(ahd, dev, cmd);
 }
 
 static int
@@ -920,8 +826,7 @@ ahd_linux_slave_destroy(Scsi_Device *dev
 	if (dev != NULL
 	 && (dev->flags & AHD_DEV_SLAVE_CONFIGURED) != 0) {
 		dev->flags |= AHD_DEV_UNCONFIGURED;
-		if (TAILQ_EMPTY(&dev->busyq)
-		 && dev->active == 0
+		if (dev->active == 0
 		 && (dev->flags & AHD_DEV_TIMER_ACTIVE) == 0)
 			ahd_linux_free_device(ahd, dev);
 	}
@@ -982,7 +887,6 @@ ahd_linux_abort(Scsi_Cmnd *cmd)
 {
 	struct ahd_softc *ahd;
 	struct ahd_cmd *acmd;
-	struct ahd_cmd *list_acmd;
 	struct ahd_linux_device *dev;
 	struct scb *pending_scb;
 	u_long s;
@@ -1049,22 +953,6 @@ ahd_linux_abort(Scsi_Cmnd *cmd)
 		goto no_cmd;
 	}
 
-	TAILQ_FOREACH(list_acmd, &dev->busyq, acmd_links.tqe) {
-		if (list_acmd == acmd)
-			break;
-	}
-
-	if (list_acmd != NULL) {
-		printf("%s:%d:%d:%d: Command found on device queue\n",
-		       ahd_name(ahd), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
-		TAILQ_REMOVE(&dev->busyq, list_acmd, acmd_links.tqe);
-		cmd->result = DID_ABORT << 16;
-		ahd_linux_queue_cmd_complete(ahd, cmd);
-		retval = SUCCESS;
-		goto done;
-	}
-
 	/*
 	 * See if we can find a matching cmd in the pending list.
 	 */
@@ -1252,7 +1140,6 @@ done:
 		}
 		spin_lock_irq(&ahd->platform_data->spin_lock);
 	}
-	ahd_schedule_runq(ahd);
 	ahd_linux_run_complete_queue(ahd);
 	ahd_midlayer_entrypoint_unlock(ahd, &s);
 	return (retval);
@@ -1352,7 +1239,6 @@ ahd_linux_dev_reset(Scsi_Cmnd *cmd)
 		retval = FAILED;
 	}
 	spin_lock_irq(&ahd->platform_data->spin_lock);
-	ahd_schedule_runq(ahd);
 	ahd_linux_run_complete_queue(ahd);
 	ahd_midlayer_entrypoint_unlock(ahd, &s);
 	printf("%s: Device reset returning 0x%x\n", ahd_name(ahd), retval);
@@ -1409,35 +1295,6 @@ Scsi_Host_Template aic79xx_driver_templa
 	.slave_destroy		= ahd_linux_slave_destroy,
 };
 
-/**************************** Tasklet Handler *********************************/
-
-/*
- * In 2.4.X and above, this routine is called from a tasklet,
- * so we must re-acquire our lock prior to executing this code.
- * In all prior kernels, ahd_schedule_runq() calls this routine
- * directly and ahd_schedule_runq() is called with our lock held.
- */
-static void
-ahd_runq_tasklet(unsigned long data)
-{
-	struct ahd_softc* ahd;
-	struct ahd_linux_device *dev;
-	u_long flags;
-
-	ahd = (struct ahd_softc *)data;
-	ahd_lock(ahd, &flags);
-	while ((dev = ahd_linux_next_device_to_run(ahd)) != NULL) {
-	
-		TAILQ_REMOVE(&ahd->platform_data->device_runq, dev, links);
-		dev->flags &= ~AHD_DEV_ON_RUN_LIST;
-		ahd_linux_check_device_queue(ahd, dev);
-		/* Yeild to our interrupt handler */
-		ahd_unlock(ahd, &flags);
-		ahd_lock(ahd, &flags);
-	}
-	ahd_unlock(ahd, &flags);
-}
-
 /******************************** Bus DMA *************************************/
 int
 ahd_dma_tag_create(struct ahd_softc *ahd, bus_dma_tag_t parent,
@@ -1951,7 +1808,6 @@ ahd_platform_alloc(struct ahd_softc *ahd
 	init_MUTEX_LOCKED(&ahd->platform_data->eh_sem);
 	init_MUTEX_LOCKED(&ahd->platform_data->dv_sem);
 	init_MUTEX_LOCKED(&ahd->platform_data->dv_cmd_sem);
-	ahd_setup_runq_tasklet(ahd);
 	ahd->seltime = (aic79xx_seltime & 0x3) << 4;
 	return (0);
 }
@@ -1966,7 +1822,6 @@ ahd_platform_free(struct ahd_softc *ahd)
 	if (ahd->platform_data != NULL) {
 		del_timer_sync(&ahd->platform_data->completeq_timer);
 		ahd_linux_kill_dv_thread(ahd);
-		ahd_teardown_runq_tasklet(ahd);
 		if (ahd->platform_data->host != NULL) {
 			scsi_remove_host(ahd->platform_data->host);
 			scsi_host_put(ahd->platform_data->host);
@@ -2135,58 +1990,7 @@ int
 ahd_platform_abort_scbs(struct ahd_softc *ahd, int target, char channel,
 			int lun, u_int tag, role_t role, uint32_t status)
 {
-	int targ;
-	int maxtarg;
-	int maxlun;
-	int clun;
-	int count;
-
-	if (tag != SCB_LIST_NULL)
-		return (0);
-
-	targ = 0;
-	if (target != CAM_TARGET_WILDCARD) {
-		targ = target;
-		maxtarg = targ + 1;
-	} else {
-		maxtarg = (ahd->features & AHD_WIDE) ? 16 : 8;
-	}
-	clun = 0;
-	if (lun != CAM_LUN_WILDCARD) {
-		clun = lun;
-		maxlun = clun + 1;
-	} else {
-		maxlun = AHD_NUM_LUNS;
-	}
-
-	count = 0;
-	for (; targ < maxtarg; targ++) {
-
-		for (; clun < maxlun; clun++) {
-			struct ahd_linux_device *dev;
-			struct ahd_busyq *busyq;
-			struct ahd_cmd *acmd;
-
-			dev = ahd_linux_get_device(ahd, /*chan*/0, targ,
-						   clun, /*alloc*/FALSE);
-			if (dev == NULL)
-				continue;
-
-			busyq = &dev->busyq;
-			while ((acmd = TAILQ_FIRST(busyq)) != NULL) {
-				Scsi_Cmnd *cmd;
-
-				cmd = &acmd_scsi_cmd(acmd);
-				TAILQ_REMOVE(busyq, acmd,
-					     acmd_links.tqe);
-				count++;
-				cmd->result = status << 16;
-				ahd_linux_queue_cmd_complete(ahd, cmd);
-			}
-		}
-	}
-
-	return (count);
+	return 0;
 }
 
 static void
@@ -3440,8 +3244,6 @@ ahd_linux_dv_timeout(struct scsi_cmnd *c
 	ahd->platform_data->reset_timer.function =
 	    (ahd_linux_callback_t *)ahd_release_simq;
 	add_timer(&ahd->platform_data->reset_timer);
-	if (ahd_linux_next_device_to_run(ahd) != NULL)
-		ahd_schedule_runq(ahd);
 	ahd_linux_run_complete_queue(ahd);
 	ahd_unlock(ahd, &flags);
 }
@@ -3658,11 +3460,10 @@ ahd_linux_device_queue_depth(struct ahd_
 	}
 }
 
-static void
-ahd_linux_run_device_queue(struct ahd_softc *ahd, struct ahd_linux_device *dev)
+static int
+ahd_linux_run_command(struct ahd_softc *ahd, struct ahd_linux_device *dev,
+		      struct scsi_cmnd *cmd)
 {
-	struct	 ahd_cmd *acmd;
-	struct	 scsi_cmnd *cmd;
 	struct	 scb *scb;
 	struct	 hardware_scb *hscb;
 	struct	 ahd_initiator_tinfo *tinfo;
@@ -3670,155 +3471,136 @@ ahd_linux_run_device_queue(struct ahd_so
 	u_int	 col_idx;
 	uint16_t mask;
 
-	if ((dev->flags & AHD_DEV_ON_RUN_LIST) != 0)
-		panic("running device on run list");
+	if (ahd->platform_data->qfrozen != 0)
+		return SCSI_MLQUEUE_HOST_BUSY;
 
-	while ((acmd = TAILQ_FIRST(&dev->busyq)) != NULL
-	    && dev->openings > 0 && dev->qfrozen == 0) {
+	/*
+	 * Get an scb to use.
+	 */
+	tinfo = ahd_fetch_transinfo(ahd, 'A', ahd->our_id,
+				    cmd->device->id, &tstate);
+	if (!blk_rq_tagged(cmd->request)
+	 || (dev->flags & (AHD_DEV_Q_TAGGED|AHD_DEV_Q_BASIC)) == 0
+	 || (tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ) != 0) {
+		col_idx = AHD_NEVER_COL_IDX;
+	} else {
+		col_idx = AHD_BUILD_COL_IDX(cmd->device->id,
+					    cmd->device->lun);
+	}
+	if ((scb = ahd_get_scb(ahd, col_idx)) == NULL) {
+		ahd->flags |= AHD_RESOURCE_SHORTAGE;
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
-		/*
-		 * Schedule us to run later.  The only reason we are not
-		 * running is because the whole controller Q is frozen.
-		 */
-		if (ahd->platform_data->qfrozen != 0
-		 && AHD_DV_SIMQ_FROZEN(ahd) == 0) {
+	scb->io_ctx = cmd;
+	scb->platform_data->dev = dev;
+	hscb = scb->hscb;
+	cmd->host_scribble = (char *)scb;
 
-			TAILQ_INSERT_TAIL(&ahd->platform_data->device_runq,
-					  dev, links);
-			dev->flags |= AHD_DEV_ON_RUN_LIST;
-			return;
-		}
+	/*
+	 * Fill out basics of the HSCB.
+	 */
+	hscb->control = 0;
+	hscb->scsiid = BUILD_SCSIID(ahd, cmd);
+	hscb->lun = cmd->device->lun;
+	scb->hscb->task_management = 0;
+	mask = SCB_GET_TARGET_MASK(ahd, scb);
 
-		cmd = &acmd_scsi_cmd(acmd);
+	if ((ahd->user_discenable & mask) != 0)
+		hscb->control |= DISCENB;
 
-		/*
-		 * Get an scb to use.
-		 */
-		tinfo = ahd_fetch_transinfo(ahd, 'A', ahd->our_id,
-					    cmd->device->id, &tstate);
-		if ((dev->flags & (AHD_DEV_Q_TAGGED|AHD_DEV_Q_BASIC)) == 0
-		 || (tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ) != 0) {
-			col_idx = AHD_NEVER_COL_IDX;
-		} else {
-			col_idx = AHD_BUILD_COL_IDX(cmd->device->id,
-						    cmd->device->lun);
-		}
-		if ((scb = ahd_get_scb(ahd, col_idx)) == NULL) {
-			TAILQ_INSERT_TAIL(&ahd->platform_data->device_runq,
-					 dev, links);
-			dev->flags |= AHD_DEV_ON_RUN_LIST;
-			ahd->flags |= AHD_RESOURCE_SHORTAGE;
-			return;
-		}
-		TAILQ_REMOVE(&dev->busyq, acmd, acmd_links.tqe);
-		scb->io_ctx = cmd;
-		scb->platform_data->dev = dev;
-		hscb = scb->hscb;
-		cmd->host_scribble = (char *)scb;
+ 	if (AHD_DV_CMD(cmd) != 0)
+		scb->flags |= SCB_SILENT;
 
-		/*
-		 * Fill out basics of the HSCB.
-		 */
-		hscb->control = 0;
-		hscb->scsiid = BUILD_SCSIID(ahd, cmd);
-		hscb->lun = cmd->device->lun;
-		scb->hscb->task_management = 0;
-		mask = SCB_GET_TARGET_MASK(ahd, scb);
-
-		if ((ahd->user_discenable & mask) != 0)
-			hscb->control |= DISCENB;
-
-	 	if (AHD_DV_CMD(cmd) != 0)
-			scb->flags |= SCB_SILENT;
-
-		if ((tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ) != 0)
-			scb->flags |= SCB_PACKETIZED;
-
-		if ((tstate->auto_negotiate & mask) != 0) {
-			scb->flags |= SCB_AUTO_NEGOTIATE;
-			scb->hscb->control |= MK_MESSAGE;
-		}
-
-		if ((dev->flags & (AHD_DEV_Q_TAGGED|AHD_DEV_Q_BASIC)) != 0) {
-			int	msg_bytes;
-			uint8_t tag_msgs[2];
-
-			msg_bytes = scsi_populate_tag_msg(cmd, tag_msgs);
-			if (msg_bytes && tag_msgs[0] != MSG_SIMPLE_TASK) {
-				hscb->control |= tag_msgs[0];
-				if (tag_msgs[0] == MSG_ORDERED_TASK)
-					dev->commands_since_idle_or_otag = 0;
-			} else
-			if (dev->commands_since_idle_or_otag == AHD_OTAG_THRESH
-			 && (dev->flags & AHD_DEV_Q_TAGGED) != 0) {
-				hscb->control |= MSG_ORDERED_TASK;
+	if ((tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ) != 0)
+		scb->flags |= SCB_PACKETIZED;
+
+	if ((tstate->auto_negotiate & mask) != 0) {
+		scb->flags |= SCB_AUTO_NEGOTIATE;
+		scb->hscb->control |= MK_MESSAGE;
+	}
+
+	if ((dev->flags & (AHD_DEV_Q_TAGGED|AHD_DEV_Q_BASIC)) != 0) {
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
+		} else
+		if (dev->commands_since_idle_or_otag == AHD_OTAG_THRESH
+		 && (dev->flags & AHD_DEV_Q_TAGGED) != 0) {
+			hscb->control |= MSG_ORDERED_TASK;
+			dev->commands_since_idle_or_otag = 0;
+		} else {
+			hscb->control |= MSG_SIMPLE_TASK;
 		}
+	}
 
-		hscb->cdb_len = cmd->cmd_len;
-		memcpy(hscb->shared_data.idata.cdb, cmd->cmnd, hscb->cdb_len);
+	hscb->cdb_len = cmd->cmd_len;
+	memcpy(hscb->shared_data.idata.cdb, cmd->cmnd, hscb->cdb_len);
 
-		scb->sg_count = 0;
-		ahd_set_residual(scb, 0);
-		ahd_set_sense_residual(scb, 0);
-		if (cmd->use_sg != 0) {
-			void	*sg;
-			struct	 scatterlist *cur_seg;
-			u_int	 nseg;
-			int	 dir;
-
-			cur_seg = (struct scatterlist *)cmd->request_buffer;
-			dir = cmd->sc_data_direction;
-			nseg = pci_map_sg(ahd->dev_softc, cur_seg,
-					  cmd->use_sg, dir);
-			scb->platform_data->xfer_len = 0;
-			for (sg = scb->sg_list; nseg > 0; nseg--, cur_seg++) {
-				dma_addr_t addr;
-				bus_size_t len;
-
-				addr = sg_dma_address(cur_seg);
-				len = sg_dma_len(cur_seg);
-				scb->platform_data->xfer_len += len;
-				sg = ahd_sg_setup(ahd, scb, sg, addr, len,
-						  /*last*/nseg == 1);
-			}
-		} else if (cmd->request_bufflen != 0) {
-			void *sg;
+	scb->sg_count = 0;
+	ahd_set_residual(scb, 0);
+	ahd_set_sense_residual(scb, 0);
+	if (cmd->use_sg != 0) {
+		void	*sg;
+		struct	 scatterlist *cur_seg;
+		u_int	 nseg;
+		int	 dir;
+
+		cur_seg = (struct scatterlist *)cmd->request_buffer;
+		dir = cmd->sc_data_direction;
+		nseg = pci_map_sg(ahd->dev_softc, cur_seg,
+				  cmd->use_sg, dir);
+		scb->platform_data->xfer_len = 0;
+		for (sg = scb->sg_list; nseg > 0; nseg--, cur_seg++) {
 			dma_addr_t addr;
-			int dir;
+			bus_size_t len;
 
-			sg = scb->sg_list;
-			dir = cmd->sc_data_direction;
-			addr = pci_map_single(ahd->dev_softc,
-					      cmd->request_buffer,
-					      cmd->request_bufflen, dir);
-			scb->platform_data->xfer_len = cmd->request_bufflen;
-			scb->platform_data->buf_busaddr = addr;
-			sg = ahd_sg_setup(ahd, scb, sg, addr,
-					  cmd->request_bufflen, /*last*/TRUE);
-		}
-
-		LIST_INSERT_HEAD(&ahd->pending_scbs, scb, pending_links);
-		dev->openings--;
-		dev->active++;
-		dev->commands_issued++;
-
-		/* Update the error counting bucket and dump if needed */
-		if (dev->target->cmds_since_error) {
-			dev->target->cmds_since_error++;
-			if (dev->target->cmds_since_error >
-			    AHD_LINUX_ERR_THRESH)
-				dev->target->cmds_since_error = 0;
-		}
-
-		if ((dev->flags & AHD_DEV_PERIODIC_OTAG) != 0)
-			dev->commands_since_idle_or_otag++;
-		scb->flags |= SCB_ACTIVE;
-		ahd_queue_scb(ahd, scb);
+			addr = sg_dma_address(cur_seg);
+			len = sg_dma_len(cur_seg);
+			scb->platform_data->xfer_len += len;
+			sg = ahd_sg_setup(ahd, scb, sg, addr, len,
+					  /*last*/nseg == 1);
+		}
+	} else if (cmd->request_bufflen != 0) {
+		void *sg;
+		dma_addr_t addr;
+		int dir;
+
+		sg = scb->sg_list;
+		dir = cmd->sc_data_direction;
+		addr = pci_map_single(ahd->dev_softc,
+				      cmd->request_buffer,
+				      cmd->request_bufflen, dir);
+		scb->platform_data->xfer_len = cmd->request_bufflen;
+		scb->platform_data->buf_busaddr = addr;
+		sg = ahd_sg_setup(ahd, scb, sg, addr,
+				  cmd->request_bufflen, /*last*/TRUE);
+	}
+
+	LIST_INSERT_HEAD(&ahd->pending_scbs, scb, pending_links);
+	dev->openings--;
+	dev->active++;
+	dev->commands_issued++;
+
+	/* Update the error counting bucket and dump if needed */
+	if (dev->target->cmds_since_error) {
+		dev->target->cmds_since_error++;
+		if (dev->target->cmds_since_error >
+		    AHD_LINUX_ERR_THRESH)
+			dev->target->cmds_since_error = 0;
 	}
+
+	if ((dev->flags & AHD_DEV_PERIODIC_OTAG) != 0)
+		dev->commands_since_idle_or_otag++;
+	scb->flags |= SCB_ACTIVE;
+	ahd_queue_scb(ahd, scb);
+
+	return 0;
 }
 
 /*
@@ -3834,8 +3616,6 @@ ahd_linux_isr(int irq, void *dev_id, str
 	ahd = (struct ahd_softc *) dev_id;
 	ahd_lock(ahd, &flags); 
 	ours = ahd_intr(ahd);
-	if (ahd_linux_next_device_to_run(ahd) != NULL)
-		ahd_schedule_runq(ahd);
 	ahd_linux_run_complete_queue(ahd);
 	ahd_unlock(ahd, &flags);
 	return IRQ_RETVAL(ours);
@@ -3914,7 +3694,6 @@ ahd_linux_alloc_device(struct ahd_softc 
 		return (NULL);
 	memset(dev, 0, sizeof(*dev));
 	init_timer(&dev->timer);
-	TAILQ_INIT(&dev->busyq);
 	dev->flags = AHD_DEV_UNCONFIGURED;
 	dev->lun = lun;
 	dev->target = targ;
@@ -4140,12 +3919,11 @@ ahd_done(struct ahd_softc *ahd, struct s
 	if (dev->active == 0)
 		dev->commands_since_idle_or_otag = 0;
 
-	if (TAILQ_EMPTY(&dev->busyq)) {
-		if ((dev->flags & AHD_DEV_UNCONFIGURED) != 0
-		 && dev->active == 0
-		 && (dev->flags & AHD_DEV_TIMER_ACTIVE) == 0)
-			ahd_linux_free_device(ahd, dev);
-	} else if ((dev->flags & AHD_DEV_ON_RUN_LIST) == 0) {
+	if ((dev->flags & AHD_DEV_UNCONFIGURED) != 0
+	    && dev->active == 0
+	    && (dev->flags & AHD_DEV_TIMER_ACTIVE) == 0)
+		ahd_linux_free_device(ahd, dev);
+	else if ((dev->flags & AHD_DEV_ON_RUN_LIST) == 0) {
 		TAILQ_INSERT_TAIL(&ahd->platform_data->device_runq, dev, links);
 		dev->flags |= AHD_DEV_ON_RUN_LIST;
 	}
@@ -4621,7 +4399,6 @@ ahd_release_simq(struct ahd_softc *ahd)
 		ahd->platform_data->flags &= ~AHD_DV_WAIT_SIMQ_RELEASE;
 		up(&ahd->platform_data->dv_sem);
 	}
-	ahd_schedule_runq(ahd);
 	ahd_unlock(ahd, &s);
 	/*
 	 * There is still a race here.  The mid-layer
@@ -4663,46 +4440,12 @@ ahd_linux_dev_timed_unfreeze(u_long arg)
 	dev->flags &= ~AHD_DEV_TIMER_ACTIVE;
 	if (dev->qfrozen > 0)
 		dev->qfrozen--;
-	if (dev->qfrozen == 0
-	 && (dev->flags & AHD_DEV_ON_RUN_LIST) == 0)
-		ahd_linux_run_device_queue(ahd, dev);
 	if ((dev->flags & AHD_DEV_UNCONFIGURED) != 0
 	 && dev->active == 0)
 		ahd_linux_free_device(ahd, dev);
 	ahd_unlock(ahd, &s);
 }
 
-void
-ahd_platform_dump_card_state(struct ahd_softc *ahd)
-{
-	struct ahd_linux_device *dev;
-	int target;
-	int maxtarget;
-	int lun;
-	int i;
-
-	maxtarget = (ahd->features & AHD_WIDE) ? 15 : 7;
-	for (target = 0; target <=maxtarget; target++) {
-
-		for (lun = 0; lun < AHD_NUM_LUNS; lun++) {
-			struct ahd_cmd *acmd;
-
-			dev = ahd_linux_get_device(ahd, 0, target,
-						   lun, /*alloc*/FALSE);
-			if (dev == NULL)
-				continue;
-
-			printf("DevQ(%d:%d:%d): ", 0, target, lun);
-			i = 0;
-			TAILQ_FOREACH(acmd, &dev->busyq, acmd_links.tqe) {
-				if (i++ > AHD_SCB_MAX)
-					break;
-			}
-			printf("%d waiting\n", i);
-		}
-	}
-}
-
 static int __init
 ahd_linux_init(void)
 {
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -310,7 +310,7 @@ struct ahd_cmd {
  * after a successfully completed inquiry command to the target when
  * that inquiry data indicates a lun is present.
  */
-TAILQ_HEAD(ahd_busyq, ahd_cmd);
+
 typedef enum {
 	AHD_DEV_UNCONFIGURED	 = 0x01,
 	AHD_DEV_FREEZE_TIL_EMPTY = 0x02, /* Freeze queue until active == 0 */
@@ -325,7 +325,6 @@ typedef enum {
 struct ahd_linux_target;
 struct ahd_linux_device {
 	TAILQ_ENTRY(ahd_linux_device) links;
-	struct			ahd_busyq busyq;
 
 	/*
 	 * The number of transactions currently
@@ -508,7 +507,6 @@ struct ahd_platform_data {
 	struct ahd_completeq	 completeq;
 
 	spinlock_t		 spin_lock;
-	struct tasklet_struct	 runq_tasklet;
 	u_int			 qfrozen;
 	pid_t			 dv_pid;
 	struct timer_list	 completeq_timer;
@@ -1115,7 +1113,6 @@ void	ahd_done(struct ahd_softc*, struct 
 void	ahd_send_async(struct ahd_softc *, char channel,
 		       u_int target, u_int lun, ac_code, void *);
 void	ahd_print_path(struct ahd_softc *, struct scb *);
-void	ahd_platform_dump_card_state(struct ahd_softc *ahd);
 
 #ifdef CONFIG_PCI
 #define AHD_PCI_CONFIG 1
