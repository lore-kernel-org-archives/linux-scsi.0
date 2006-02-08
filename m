From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] ncr53c8xx: implement full slave_alloc and slave_destroy methods
Date: Wed, 8 Feb 2006 17:18:41 +0100
Message-ID: <20060208161841.GA19199@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:61316 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1161092AbWBHQSp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2006 11:18:45 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org

 - allocate all per-lun data in slave alloc and free it in slave_destroy.
 - move the bios first boot lun scanning disable flag to slave_alloc.
 - remove lots now superflous checks


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/ncr53c8xx.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ncr53c8xx.c	2006-01-05 16:43:19.000000000 +0100
+++ linux-2.6/drivers/scsi/ncr53c8xx.c	2006-02-08 16:30:10.000000000 +0100
@@ -1947,8 +1947,6 @@
 static	void	ncr_free_ccb	(struct ncb *np, struct ccb *cp);
 static	void	ncr_init_ccb	(struct ncb *np, struct ccb *cp);
 static	void	ncr_init_tcb	(struct ncb *np, u_char tn);
-static	struct lcb *	ncr_alloc_lcb	(struct ncb *np, u_char tn, u_char ln);
-static	struct lcb *	ncr_setup_lcb	(struct ncb *np, struct scsi_device *sdev);
 static	void	ncr_getclock	(struct ncb *np, int mult);
 static	void	ncr_selectclock	(struct ncb *np, u_char scntl3);
 static	struct ccb *ncr_get_ccb	(struct ncb *np, struct scsi_cmnd *cmd);
@@ -4160,33 +4158,6 @@
 	int	direction;
 	u32	lastp, goalp;
 
-	/*---------------------------------------------
-	**
-	**      Some shortcuts ...
-	**
-	**---------------------------------------------
-	*/
-	if ((sdev->id == np->myaddr	  ) ||
-		(sdev->id >= MAX_TARGET) ||
-		(sdev->lun    >= MAX_LUN   )) {
-		return(DID_BAD_TARGET);
-	}
-
-	/*---------------------------------------------
-	**
-	**	Complete the 1st TEST UNIT READY command
-	**	with error condition if the device is 
-	**	flagged NOSCAN, in order to speed up 
-	**	the boot.
-	**
-	**---------------------------------------------
-	*/
-	if ((cmd->cmnd[0] == 0 || cmd->cmnd[0] == 0x12) && 
-	    (tp->usrflag & UF_NOSCAN)) {
-		tp->usrflag &= ~UF_NOSCAN;
-		return DID_BAD_TARGET;
-	}
-
 	if (DEBUG_FLAGS & DEBUG_TINY) {
 		PRINT_ADDR(cmd, "CMD=%x ", cmd->cmnd[0]);
 	}
@@ -4237,7 +4208,7 @@
 		**	Force ordered tag if necessary to avoid timeouts 
 		**	and to preserve interactivity.
 		*/
-		if (lp && time_after(jiffies, lp->tags_stime)) {
+		if (time_after(jiffies, lp->tags_stime)) {
 			if (lp->tags_smap) {
 				order = M_ORDERED_TAG;
 				if ((DEBUG_FLAGS & DEBUG_TAGS)||bootverbose>2){ 
@@ -4303,7 +4274,7 @@
 
 	cp->nego_status = 0;
 
-	if ((!tp->widedone || !tp->period) && !tp->nego_cp && lp) {
+	if ((!tp->widedone || !tp->period) && !tp->nego_cp) {
 		msglen += ncr_prepare_nego (np, cp, msgptr + msglen);
 	}
 
@@ -4435,13 +4406,9 @@
 	**	2 max at a time is enough to flush the CCB wait queue.
 	*/
 	cp->auto_sense = 0;
-	if (lp)
-		ncr_start_next_ccb(np, lp, 2);
-	else
-		ncr_put_start_queue(np, cp);
+	ncr_start_next_ccb(np, lp, 2);
 
 	/* Command is successfully queued.  */
-
 	return DID_OK;
 }
 
@@ -4735,9 +4702,6 @@
 static void ncr_detach(struct ncb *np)
 {
 	struct ccb *cp;
-	struct tcb *tp;
-	struct lcb *lp;
-	int target, lun;
 	int i;
 	char inst_name[16];
 
@@ -4806,23 +4770,6 @@
 		m_free_dma(cp, sizeof(*cp), "CCB");
 	}
 
-	/* Free allocated tp(s) */
-
-	for (target = 0; target < MAX_TARGET ; target++) {
-		tp=&np->target[target];
-		for (lun = 0 ; lun < MAX_LUN ; lun++) {
-			lp = tp->lp[lun];
-			if (lp) {
-#ifdef DEBUG_NCR53C8XX
-	printk("%s: freeing lp (%lx)\n", ncr_name(np), (u_long) lp);
-#endif
-				if (lp->jump_ccb != &lp->jump_ccb_0)
-					m_free_dma(lp->jump_ccb,256,"JUMP_CCB");
-				m_free_dma(lp, sizeof(*lp), "LCB");
-			}
-		}
-	}
-
 	if (np->scripth0)
 		m_free_dma(np->scripth0, sizeof(struct scripth), "SCRIPTH");
 	if (np->script0)
@@ -4895,7 +4842,7 @@
 	**	auto-sense, requeue skipped CCBs to the wait queue.
 	*/
 
-	if (lp && lp->held_ccb) {
+	if (lp->held_ccb) {
 		if (cp == lp->held_ccb) {
 			list_splice_init(&lp->skip_ccbq, &lp->wait_ccbq);
 			lp->held_ccb = NULL;
@@ -4962,12 +4909,6 @@
 		*/
 		/* if (cp->phys.header.lastp != cp->phys.header.goalp) */
 
-		/*
-		**	Allocate the lcb if not yet.
-		*/
-		if (!lp)
-			ncr_alloc_lcb (np, cmd->device->id, cmd->device->lun);
-
 		tp->bytes     += cp->data_len;
 		tp->transfers ++;
 
@@ -4975,7 +4916,7 @@
 		**	If tags was reduced due to queue full,
 		**	increase tags if 1000 good status received.
 		*/
-		if (lp && lp->usetags && lp->numtags < lp->maxtags) {
+		if (lp->usetags && lp->numtags < lp->maxtags) {
 			++lp->num_good;
 			if (lp->num_good >= 1000) {
 				lp->num_good = 0;
@@ -5090,7 +5031,7 @@
 	/*
 	**	requeue awaiting scsi commands for this lun.
 	*/
-	if (lp && lp->queuedccbs < lp->queuedepth &&
+	if (lp->queuedccbs < lp->queuedepth &&
 	    !list_empty(&lp->wait_ccbq))
 		ncr_start_next_ccb(np, lp, 2);
 
@@ -7529,17 +7470,11 @@
 static struct lcb *ncr_alloc_lcb (struct ncb *np, u_char tn, u_char ln)
 {
 	struct tcb *tp = &np->target[tn];
-	struct lcb *lp = tp->lp[ln];
+	struct lcb *lp;
 	ncrcmd copy_4 = np->features & FE_PFEN ? SCR_COPY(4) : SCR_COPY_F(4);
 	int lh = ln & 3;
 
 	/*
-	**	Already done, return.
-	*/
-	if (lp)
-		return lp;
-
-	/*
 	**	Allocate the lcb.
 	*/
 	lp = m_calloc_dma(sizeof(struct lcb), "LCB");
@@ -7607,52 +7542,6 @@
 	return lp;
 }
 
-
-/*------------------------------------------------------------------------
-**	Lun control block setup on INQUIRY data received.
-**------------------------------------------------------------------------
-**	We only support WIDE, SYNC for targets and CMDQ for logical units.
-**	This setup is done on each INQUIRY since we are expecting user 
-**	will play with CHANGE DEFINITION commands. :-)
-**------------------------------------------------------------------------
-*/
-static struct lcb *ncr_setup_lcb (struct ncb *np, struct scsi_device *sdev)
-{
-	unsigned char tn = sdev->id, ln = sdev->lun;
-	struct tcb *tp = &np->target[tn];
-	struct lcb *lp = tp->lp[ln];
-
-	/* If no lcb, try to allocate it.  */
-	if (!lp && !(lp = ncr_alloc_lcb(np, tn, ln)))
-		goto fail;
-
-	/*
-	**	If unit supports tagged commands, allocate the 
-	**	CCB JUMP table if not yet.
-	*/
-	if (sdev->tagged_supported && lp->jump_ccb == &lp->jump_ccb_0) {
-		int i;
-		lp->jump_ccb = m_calloc_dma(256, "JUMP_CCB");
-		if (!lp->jump_ccb) {
-			lp->jump_ccb = &lp->jump_ccb_0;
-			goto fail;
-		}
-		lp->p_jump_ccb = cpu_to_scr(vtobus(lp->jump_ccb));
-		for (i = 0 ; i < 64 ; i++)
-			lp->jump_ccb[i] =
-				cpu_to_scr(NCB_SCRIPTH_PHYS (np, bad_i_t_l_q));
-		for (i = 0 ; i < MAX_TAGS ; i++)
-			lp->cb_tags[i] = i;
-		lp->maxnxs = MAX_TAGS;
-		lp->tags_stime = jiffies + 3*HZ;
-		ncr_setup_tags (np, sdev);
-	}
-
-
-fail:
-	return lp;
-}
-
 /*==========================================================
 **
 **
@@ -8027,31 +7916,62 @@
 	struct Scsi_Host *host = device->host;
 	struct ncb *np = ((struct host_data *) host->hostdata)->ncb;
 	struct tcb *tp = &np->target[device->id];
-	tp->starget = device->sdev_target;
 
+	if (tp->usrflag & UF_NOSCAN) {
+		tp->usrflag &= ~UF_NOSCAN;
+		return -ENXIO;
+	}
+
+	tp->lp[device->lun] = ncr_alloc_lcb(np, device->id, device->lun);
+	if (!tp->lp[device->lun])
+		return -ENOMEM;
+
+	tp->starget = device->sdev_target;
 	return 0;
 }
 
-static int ncr53c8xx_slave_configure(struct scsi_device *device)
+static int ncr53c8xx_slave_configure(struct scsi_device *sdev)
 {
-	struct Scsi_Host *host = device->host;
+	struct Scsi_Host *host = sdev->host;
 	struct ncb *np = ((struct host_data *) host->hostdata)->ncb;
-	struct tcb *tp = &np->target[device->id];
-	struct lcb *lp = tp->lp[device->lun];
+	struct tcb *tp = &np->target[sdev->id];
+	struct lcb *lp = tp->lp[sdev->lun];
 	int numtags, depth_to_use;
 
-	ncr_setup_lcb(np, device);
+	/*
+	**	If unit supports tagged commands, allocate the
+	**	CCB JUMP table if not yet.
+	*/
+	if (sdev->tagged_supported && lp->jump_ccb == &lp->jump_ccb_0) {
+		int i;
+		lp->jump_ccb = m_calloc_dma(256, "JUMP_CCB");
+		if (!lp->jump_ccb) {
+			lp->jump_ccb = &lp->jump_ccb_0;
+			goto skip_tags;
+		}
+		lp->p_jump_ccb = cpu_to_scr(vtobus(lp->jump_ccb));
+		for (i = 0 ; i < 64 ; i++)
+			lp->jump_ccb[i] =
+				cpu_to_scr(NCB_SCRIPTH_PHYS (np, bad_i_t_l_q));
+		for (i = 0 ; i < MAX_TAGS ; i++)
+			lp->cb_tags[i] = i;
+		lp->maxnxs = MAX_TAGS;
+		lp->tags_stime = jiffies + 3*HZ;
+		ncr_setup_tags(np, sdev);
+	}
+
 
+ skip_tags:
 	/*
 	**	Select queue depth from driver setup.
 	**	Donnot use more than configured by user.
 	**	Use at least 2.
 	**	Donnot use more than our maximum.
 	*/
-	numtags = device_queue_depth(np->unit, device->id, device->lun);
+	numtags = device_queue_depth(np->unit, sdev->id, sdev->lun);
 	if (numtags > tp->usrtags)
 		numtags = tp->usrtags;
-	if (!device->tagged_supported)
+	if (!sdev->tagged_supported)
 		numtags = 1;
 	depth_to_use = numtags;
 	if (depth_to_use < 2)
@@ -8059,37 +7979,33 @@
 	if (depth_to_use > MAX_TAGS)
 		depth_to_use = MAX_TAGS;
 
-	scsi_adjust_queue_depth(device,
-				(device->tagged_supported ?
+	scsi_adjust_queue_depth(sdev,
+				(sdev->tagged_supported ?
 				 MSG_SIMPLE_TAG : 0),
 				depth_to_use);
 
-	/*
-	**	Since the queue depth is not tunable under Linux,
-	**	we need to know this value in order not to 
-	**	announce stupid things to user.
-	**
-	**	XXX(hch): As of Linux 2.6 it certainly _is_ tunable..
-	**		  In fact we just tuned it, or did I miss
-	**		  something important? :)
-	*/
-	if (lp) {
-		lp->numtags = lp->maxtags = numtags;
-		lp->scdev_depth = depth_to_use;
-	}
-	ncr_setup_tags (np, device);
+	lp->numtags = lp->maxtags = numtags;
+	lp->scdev_depth = depth_to_use;
 
-#ifdef DEBUG_NCR53C8XX
-	printk("ncr53c8xx_select_queue_depth: host=%d, id=%d, lun=%d, depth=%d\n",
-	       np->unit, device->id, device->lun, depth_to_use);
-#endif
+	ncr_setup_tags (np, sdev);
 
-	if (spi_support_sync(device->sdev_target) &&
-	    !spi_initial_dv(device->sdev_target))
-		spi_dv_device(device);
+	if (spi_support_sync(sdev->sdev_target) &&
+	    !spi_initial_dv(sdev->sdev_target))
+		spi_dv_device(sdev);
 	return 0;
 }
 
+static void ncr53c8xx_slave_destroy(struct scsi_device *sdev)
+{
+	struct Scsi_Host *host = sdev->host;
+	struct ncb *np = ((struct host_data *) host->hostdata)->ncb;
+	struct lcb *lp = np->target[sdev->id].lp[sdev->lun];
+
+	if (lp->jump_ccb != &lp->jump_ccb_0)
+		m_free_dma(lp->jump_ccb, 256, "JUMP_CCB");
+	m_free_dma(lp, sizeof(*lp), "LCB");
+}
+
 static int ncr53c8xx_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 {
      struct ncb *np = ((struct host_data *) cmd->device->host->hostdata)->ncb;
@@ -8373,8 +8289,9 @@
 		tpnt->shost_attrs = ncr53c8xx_host_attrs;
 
 	tpnt->queuecommand	= ncr53c8xx_queue_command;
-	tpnt->slave_configure	= ncr53c8xx_slave_configure;
 	tpnt->slave_alloc	= ncr53c8xx_slave_alloc;
+	tpnt->slave_configure	= ncr53c8xx_slave_configure;
+	tpnt->slave_destroy	= ncr53c8xx_slave_destroy;
 	tpnt->eh_bus_reset_handler = ncr53c8xx_bus_reset;
 	tpnt->can_queue		= SCSI_NCR_CAN_QUEUE;
 	tpnt->this_id		= 7;
