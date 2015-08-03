From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v3 1/4] cxlflash: Updates to legacy I/O
Date: Sun,  2 Aug 2015 23:32:44 -0500
Message-ID: <1438576364-32896-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:33379 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbbHCEdk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2015 00:33:40 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Sun, 2 Aug 2015 22:33:40 -0600
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id ABA0FC90042
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2015 00:24:43 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t734Xc7Q49348732
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2015 04:33:38 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t734Xaf4004947
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2015 00:33:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, shane.seymour@hp.com
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

This patch addresses several issues found since originally submitting
support for legacy I/O on the IBM CXLflash adapter.

These include:
 - proper TMF handling
 - reworking sysfs attributes/handler as suggested by Shane Seymour
 - fixing cleanup bugs and potential memory leaks
 - spelling fixes
 - parameter/comment updates
 - making functions static
 - supporting host rescan
 - refining prints, using dev_* prints

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h  |    9 +-
 drivers/scsi/cxlflash/main.c    | 1329 ++++++++++++++++++++-------------------
 drivers/scsi/cxlflash/main.h    |    1 +
 drivers/scsi/cxlflash/sislite.h |    6 +-
 4 files changed, 684 insertions(+), 661 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index fe86bfe..ba070a5 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -97,13 +97,13 @@ struct cxlflash_cfg {
 	enum cxlflash_init_state init_state;
 	enum cxlflash_lr_state lr_state;
 	int lr_port;
+	atomic_t scan_host_needed;
 
 	struct cxl_afu *cxl_afu;
-
-	struct pci_pool *cxlflash_cmd_pool;
 	struct pci_dev *parent_dev;
 
 	wait_queue_head_t tmf_waitq;
+	spinlock_t tmf_slock;
 	bool tmf_active;
 	u8 err_recovery_active:1;
 };
@@ -171,11 +171,6 @@ static inline u64 lun_to_lunid(u64 lun)
 	return swab64(lun_id);
 }
 
-int cxlflash_send_cmd(struct afu *, struct afu_cmd *);
-void cxlflash_wait_resp(struct afu *, struct afu_cmd *);
-int cxlflash_afu_reset(struct cxlflash_cfg *);
-struct afu_cmd *cxlflash_cmd_checkout(struct afu *);
-void cxlflash_cmd_checkin(struct afu_cmd *);
 int cxlflash_afu_sync(struct afu *, ctx_hndl_t, res_hndl_t, u8);
 #endif /* ifndef _CXLFLASH_COMMON_H */
 
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 76a7286..ae2351a 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -33,9 +33,8 @@ MODULE_AUTHOR("Manoj N. Kumar <manoj@linux.vnet.ibm.com>");
 MODULE_AUTHOR("Matthew R. Ochs <mrochs@linux.vnet.ibm.com>");
 MODULE_LICENSE("GPL");
 
-
 /**
- * cxlflash_cmd_checkout() - checks out an AFU command
+ * cmd_checkout() - checks out an AFU command
  * @afu:	AFU to checkout from.
  *
  * Commands are checked out in a round-robin fashion. Note that since
@@ -46,7 +45,7 @@ MODULE_LICENSE("GPL");
  *
  * Return: The checked out command or NULL when command pool is empty.
  */
-struct afu_cmd *cxlflash_cmd_checkout(struct afu *afu)
+static struct afu_cmd *cmd_checkout(struct afu *afu)
 {
 	int k, dec = CXLFLASH_NUM_CMDS;
 	struct afu_cmd *cmd;
@@ -57,8 +56,8 @@ struct afu_cmd *cxlflash_cmd_checkout(struct afu *afu)
 		cmd = &afu->cmd[k];
 
 		if (!atomic_dec_if_positive(&cmd->free)) {
-			pr_debug("%s: returning found index=%d\n",
-				 __func__, cmd->slot);
+			pr_devel("%s: returning found index=%d cmd=%p\n",
+				 __func__, cmd->slot, cmd);
 			memset(cmd->buf, 0, CMD_BUFSIZE);
 			memset(cmd->rcb.cdb, 0, sizeof(cmd->rcb.cdb));
 			return cmd;
@@ -69,7 +68,7 @@ struct afu_cmd *cxlflash_cmd_checkout(struct afu *afu)
 }
 
 /**
- * cxlflash_cmd_checkin() - checks in an AFU command
+ * cmd_checkin() - checks in an AFU command
  * @cmd:	AFU command to checkin.
  *
  * Safe to pass commands that have already been checked in. Several
@@ -78,7 +77,7 @@ struct afu_cmd *cxlflash_cmd_checkout(struct afu *afu)
  * to avoid clobbering values in the event that the command is checked
  * out right away.
  */
-void cxlflash_cmd_checkin(struct afu_cmd *cmd)
+static void cmd_checkin(struct afu_cmd *cmd)
 {
 	cmd->rcb.scp = NULL;
 	cmd->rcb.timeout = 0;
@@ -92,7 +91,7 @@ void cxlflash_cmd_checkin(struct afu_cmd *cmd)
 		return;
 	}
 
-	pr_debug("%s: released cmd %p index=%d\n", __func__, cmd, cmd->slot);
+	pr_devel("%s: released cmd %p index=%d\n", __func__, cmd, cmd->slot);
 }
 
 /**
@@ -106,6 +105,7 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 {
 	struct sisl_ioarcb *ioarcb;
 	struct sisl_ioasa *ioasa;
+	u32 resid;
 
 	if (unlikely(!cmd))
 		return;
@@ -114,9 +114,10 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 	ioasa = &(cmd->sa);
 
 	if (ioasa->rc.flags & SISL_RC_FLAGS_UNDERRUN) {
-		pr_debug("%s: cmd underrun cmd = %p scp = %p\n",
-			 __func__, cmd, scp);
-		scp->result = (DID_ERROR << 16);
+		resid = ioasa->resid;
+		scsi_set_resid(scp, resid);
+		pr_debug("%s: cmd underrun cmd = %p scp = %p, resid = %d\n",
+			 __func__, cmd, scp, resid);
 	}
 
 	if (ioasa->rc.flags & SISL_RC_FLAGS_OVERRUN) {
@@ -157,8 +158,7 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 				/* If the SISL_RC_FLAGS_OVERRUN flag was set,
 				 * then we will handle this error else where.
 				 * If not then we must handle it here.
-				 * This is probably an AFU bug. We will
-				 * attempt a retry to see if that resolves it.
+				 * This is probably an AFU bug.
 				 */
 				scp->result = (DID_ERROR << 16);
 			}
@@ -182,7 +182,7 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 		/* We have an AFU error */
 		switch (ioasa->rc.afu_rc) {
 		case SISL_AFU_RC_NO_CHANNELS:
-			scp->result = (DID_MEDIUM_ERROR << 16);
+			scp->result = (DID_NO_CONNECT << 16);
 			break;
 		case SISL_AFU_RC_DATA_DMA_ERR:
 			switch (ioasa->afu_extra) {
@@ -216,7 +216,6 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 static void cmd_complete(struct afu_cmd *cmd)
 {
 	struct scsi_cmnd *scp;
-	u32 resid;
 	ulong lock_flags;
 	struct afu *afu = cmd->parent;
 	struct cxlflash_cfg *cfg = afu->parent;
@@ -228,45 +227,179 @@ static void cmd_complete(struct afu_cmd *cmd)
 
 	if (cmd->rcb.scp) {
 		scp = cmd->rcb.scp;
-		if (unlikely(cmd->sa.rc.afu_rc ||
-			     cmd->sa.rc.scsi_rc ||
-			     cmd->sa.rc.fc_rc))
+		if (unlikely(cmd->sa.ioasc))
 			process_cmd_err(cmd, scp);
 		else
 			scp->result = (DID_OK << 16);
 
-		resid = cmd->sa.resid;
 		cmd_is_tmf = cmd->cmd_tmf;
-		cxlflash_cmd_checkin(cmd); /* Don't use cmd after here */
+		cmd_checkin(cmd); /* Don't use cmd after here */
 
-		pr_debug("%s: calling scsi_set_resid, scp=%p "
-			 "result=%X resid=%d\n", __func__,
-			 scp, scp->result, resid);
+		pr_debug_ratelimited("%s: calling scsi_done scp=%p result=%X "
+				     "ioasc=%d\n", __func__, scp, scp->result,
+				     cmd->sa.ioasc);
 
-		scsi_set_resid(scp, resid);
 		scsi_dma_unmap(scp);
 		scp->scsi_done(scp);
 
 		if (cmd_is_tmf) {
-			spin_lock_irqsave(&cfg->tmf_waitq.lock, lock_flags);
+			spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
 			cfg->tmf_active = false;
 			wake_up_all_locked(&cfg->tmf_waitq);
-			spin_unlock_irqrestore(&cfg->tmf_waitq.lock,
-					       lock_flags);
+			spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 		}
 	} else
 		complete(&cmd->cevent);
 }
 
 /**
+ * context_reset() - timeout handler for AFU commands
+ * @cmd:	AFU command that timed out.
+ *
+ * Sends a reset to the AFU.
+ */
+static void context_reset(struct afu_cmd *cmd)
+{
+	int nretry = 0;
+	u64 rrin = 0x1;
+	u64 room = 0;
+	struct afu *afu = cmd->parent;
+	ulong lock_flags;
+
+	pr_debug("%s: cmd=%p\n", __func__, cmd);
+
+	spin_lock_irqsave(&cmd->slock, lock_flags);
+
+	/* Already completed? */
+	if (cmd->sa.host_use_b[0] & B_DONE) {
+		spin_unlock_irqrestore(&cmd->slock, lock_flags);
+		return;
+	}
+
+	cmd->sa.host_use_b[0] |= (B_DONE | B_ERROR | B_TIMEOUT);
+	spin_unlock_irqrestore(&cmd->slock, lock_flags);
+
+	/*
+	 * We really want to send this reset at all costs, so spread
+	 * out wait time on successive retries for available room.
+	 */
+	do {
+		room = readq_be(&afu->host_map->cmd_room);
+		atomic64_set(&afu->room, room);
+		if (room)
+			goto write_rrin;
+		udelay(nretry);
+	} while (nretry++ < MC_ROOM_RETRY_CNT);
+
+	pr_err("%s: no cmd_room to send reset\n", __func__);
+	return;
+
+write_rrin:
+	nretry = 0;
+	writeq_be(rrin, &afu->host_map->ioarrin);
+	do {
+		rrin = readq_be(&afu->host_map->ioarrin);
+		if (rrin != 0x1)
+			break;
+		/* Double delay each time */
+		udelay(2 ^ nretry);
+	} while (nretry++ < MC_ROOM_RETRY_CNT);
+}
+
+/**
+ * send_cmd() - sends an AFU command
+ * @afu:	AFU associated with the host.
+ * @cmd:	AFU command to send.
+ *
+ * Return:
+ *	0 on success or SCSI_MLQUEUE_HOST_BUSY
+ */
+static int send_cmd(struct afu *afu, struct afu_cmd *cmd)
+{
+	struct cxlflash_cfg *cfg = afu->parent;
+	struct device *dev = &cfg->dev->dev;
+	int nretry = 0;
+	int rc = 0;
+	u64 room;
+	long newval;
+
+	/*
+	 * This routine is used by critical users such an AFU sync and to
+	 * send a task management function (TMF). Thus we want to retry a
+	 * bit before returning an error. To avoid the performance penalty
+	 * of MMIO, we spread the update of 'room' over multiple commands.
+	 */
+retry:
+	newval = atomic64_dec_if_positive(&afu->room);
+	if (!newval) {
+		do {
+			room = readq_be(&afu->host_map->cmd_room);
+			atomic64_set(&afu->room, room);
+			if (room)
+				goto write_ioarrin;
+			udelay(nretry);
+		} while (nretry++ < MC_ROOM_RETRY_CNT);
+
+		dev_err(dev, "%s: no cmd_room to send 0x%X\n",
+		       __func__, cmd->rcb.cdb[0]);
+
+		goto no_room;
+	} else if (unlikely(newval < 0)) {
+		/* This should be rare. i.e. Only if two threads race and
+		 * decrement before the MMIO read is done. In this case
+		 * just benefit from the other thread having updated
+		 * afu->room.
+		 */
+		if (nretry++ < MC_ROOM_RETRY_CNT) {
+			udelay(nretry);
+			goto retry;
+		}
+
+		goto no_room;
+	}
+
+write_ioarrin:
+	writeq_be((u64)&cmd->rcb, &afu->host_map->ioarrin);
+out:
+	pr_devel("%s: cmd=%p len=%d ea=%p rc=%d\n", __func__, cmd,
+		 cmd->rcb.data_len, (void *)cmd->rcb.data_ea, rc);
+	return rc;
+
+no_room:
+	afu->read_room = true;
+	schedule_work(&cfg->work_q);
+	rc = SCSI_MLQUEUE_HOST_BUSY;
+	goto out;
+}
+
+/**
+ * wait_resp() - polls for a response or timeout to a sent AFU command
+ * @afu:	AFU associated with the host.
+ * @cmd:	AFU command that was sent.
+ */
+static void wait_resp(struct afu *afu, struct afu_cmd *cmd)
+{
+	ulong timeout = msecs_to_jiffies(cmd->rcb.timeout * 2 * 1000);
+
+	timeout = wait_for_completion_timeout(&cmd->cevent, timeout);
+	if (!timeout)
+		context_reset(cmd);
+
+	if (unlikely(cmd->sa.ioasc != 0))
+		pr_err("%s: CMD 0x%X failed, IOASC: flags 0x%X, afu_rc 0x%X, "
+		       "scsi_rc 0x%X, fc_rc 0x%X\n", __func__, cmd->rcb.cdb[0],
+		       cmd->sa.rc.flags, cmd->sa.rc.afu_rc, cmd->sa.rc.scsi_rc,
+		       cmd->sa.rc.fc_rc);
+}
+
+/**
  * send_tmf() - sends a Task Management Function (TMF)
  * @afu:	AFU to checkout from.
  * @scp:	SCSI command from stack.
  * @tmfcmd:	TMF command to send.
  *
  * Return:
- *	0 on success
- *	SCSI_MLQUEUE_HOST_BUSY when host is busy
+ *	0 on success or SCSI_MLQUEUE_HOST_BUSY
  */
 static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 {
@@ -276,25 +409,27 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	short lflag = 0;
 	struct Scsi_Host *host = scp->device->host;
 	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
+	struct device *dev = &cfg->dev->dev;
 	ulong lock_flags;
 	int rc = 0;
+	ulong to;
 
-	cmd = cxlflash_cmd_checkout(afu);
+	cmd = cmd_checkout(afu);
 	if (unlikely(!cmd)) {
-		pr_err("%s: could not get a free command\n", __func__);
+		dev_err(dev, "%s: could not get a free command\n", __func__);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	}
 
-	/* If a Task Management Function is active, do not send one more.
-	 */
-	spin_lock_irqsave(&cfg->tmf_waitq.lock, lock_flags);
+	/* When Task Management Function is active do not send another */
+	spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
 	if (cfg->tmf_active)
-		wait_event_interruptible_locked_irq(cfg->tmf_waitq,
-						    !cfg->tmf_active);
+		wait_event_interruptible_lock_irq(cfg->tmf_waitq,
+						  !cfg->tmf_active,
+						  cfg->tmf_slock);
 	cfg->tmf_active = true;
 	cmd->cmd_tmf = true;
-	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
+	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 
 	cmd->rcb.ctx_id = afu->ctx_hndl;
 	cmd->rcb.port_sel = port_sel;
@@ -312,18 +447,27 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	memcpy(cmd->rcb.cdb, &tmfcmd, sizeof(tmfcmd));
 
 	/* Send the command */
-	rc = cxlflash_send_cmd(afu, cmd);
+	rc = send_cmd(afu, cmd);
 	if (unlikely(rc)) {
-		cxlflash_cmd_checkin(cmd);
-		spin_lock_irqsave(&cfg->tmf_waitq.lock, lock_flags);
+		cmd_checkin(cmd);
+		spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
 		cfg->tmf_active = false;
-		spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
+		spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 		goto out;
 	}
 
-	spin_lock_irqsave(&cfg->tmf_waitq.lock, lock_flags);
-	wait_event_interruptible_locked_irq(cfg->tmf_waitq, !cfg->tmf_active);
-	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
+	spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
+	to = msecs_to_jiffies(5000);
+	to = wait_event_interruptible_lock_irq_timeout(cfg->tmf_waitq,
+						       !cfg->tmf_active,
+						       cfg->tmf_slock,
+						       to);
+	if (!to) {
+		cfg->tmf_active = false;
+		dev_err(dev, "%s: TMF timed out!\n", __func__);
+		rc = -1;
+	}
+	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 out:
 	return rc;
 }
@@ -344,15 +488,13 @@ static const char *cxlflash_driver_info(struct Scsi_Host *host)
  * @host:	SCSI host associated with device.
  * @scp:	SCSI command to send.
  *
- * Return:
- *	0 on success
- *	SCSI_MLQUEUE_HOST_BUSY when host is busy
+ * Return: 0 on success or SCSI_MLQUEUE_HOST_BUSY
  */
 static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 {
 	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
 	struct afu *afu = cfg->afu;
-	struct pci_dev *pdev = cfg->dev;
+	struct device *dev = &cfg->dev->dev;
 	struct afu_cmd *cmd;
 	u32 port_sel = scp->device->channel + 1;
 	int nseg, i, ncount;
@@ -361,28 +503,30 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	short lflag = 0;
 	int rc = 0;
 
-	pr_debug("%s: (scp=%p) %d/%d/%d/%llu cdb=(%08X-%08X-%08X-%08X)\n",
-		 __func__, scp, host->host_no, scp->device->channel,
-		 scp->device->id, scp->device->lun,
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
+	pr_debug_ratelimited("%s: (scp=%p) %d/%d/%d/%llu "
+			     "cdb=(%08X-%08X-%08X-%08X)\n",
+			     __func__, scp, host->host_no, scp->device->channel,
+			     scp->device->id, scp->device->lun,
+			     get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
+			     get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
+			     get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
+			     get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
 
-	/* If a Task Management Function is active, wait for it to complete
+	/*
+	 * If a Task Management Function is active, wait for it to complete
 	 * before continuing with regular commands.
 	 */
-	spin_lock_irqsave(&cfg->tmf_waitq.lock, lock_flags);
+	spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
 	if (cfg->tmf_active) {
-		spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
+		spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	}
-	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
+	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 
-	cmd = cxlflash_cmd_checkout(afu);
+	cmd = cmd_checkout(afu);
 	if (unlikely(!cmd)) {
-		pr_err("%s: could not get a free command\n", __func__);
+		dev_err(dev, "%s: could not get a free command\n", __func__);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	}
@@ -404,7 +548,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 
 	nseg = scsi_dma_map(scp);
 	if (unlikely(nseg < 0)) {
-		dev_err(&pdev->dev, "%s: Fail DMA map! nseg=%d\n",
+		dev_err(dev, "%s: Fail DMA map! nseg=%d\n",
 			__func__, nseg);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
@@ -420,9 +564,9 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	memcpy(cmd->rcb.cdb, scp->cmnd, sizeof(cmd->rcb.cdb));
 
 	/* Send the command */
-	rc = cxlflash_send_cmd(afu, cmd);
+	rc = send_cmd(afu, cmd);
 	if (unlikely(rc)) {
-		cxlflash_cmd_checkin(cmd);
+		cmd_checkin(cmd);
 		scsi_dma_unmap(scp);
 	}
 
@@ -431,332 +575,66 @@ out:
 }
 
 /**
- * cxlflash_eh_device_reset_handler() - reset a single LUN
- * @scp:	SCSI command to send.
- *
- * Return:
- *	SUCCESS as defined in scsi/scsi.h
- *	FAILED as defined in scsi/scsi.h
+ * cxlflash_wait_for_pci_err_recovery() - wait for error recovery during probe
+ * @cfg:	Internal structure associated with the host.
  */
-static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
+static void cxlflash_wait_for_pci_err_recovery(struct cxlflash_cfg *cfg)
 {
-	int rc = SUCCESS;
-	struct Scsi_Host *host = scp->device->host;
-	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
-	struct afu *afu = cfg->afu;
-	int rcr = 0;
-
-	pr_debug("%s: (scp=%p) %d/%d/%d/%llu "
-		 "cdb=(%08X-%08X-%08X-%08X)\n", __func__, scp,
-		 host->host_no, scp->device->channel,
-		 scp->device->id, scp->device->lun,
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
-
-	rcr = send_tmf(afu, scp, TMF_LUN_RESET);
-	if (unlikely(rcr))
-		rc = FAILED;
+	struct pci_dev *pdev = cfg->dev;
 
-	pr_debug("%s: returning rc=%d\n", __func__, rc);
-	return rc;
+	if (pci_channel_offline(pdev))
+		wait_event_timeout(cfg->eeh_waitq,
+				   !pci_channel_offline(pdev),
+				   CXLFLASH_PCI_ERROR_RECOVERY_TIMEOUT);
 }
 
 /**
- * cxlflash_eh_host_reset_handler() - reset the host adapter
- * @scp:	SCSI command from stack identifying host.
- *
- * Return:
- *	SUCCESS as defined in scsi/scsi.h
- *	FAILED as defined in scsi/scsi.h
+ * free_mem() - free memory associated with the AFU
+ * @cfg:	Internal structure associated with the host.
  */
-static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
+static void free_mem(struct cxlflash_cfg *cfg)
 {
-	int rc = SUCCESS;
-	int rcr = 0;
-	struct Scsi_Host *host = scp->device->host;
-	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
-
-	pr_debug("%s: (scp=%p) %d/%d/%d/%llu "
-		 "cdb=(%08X-%08X-%08X-%08X)\n", __func__, scp,
-		 host->host_no, scp->device->channel,
-		 scp->device->id, scp->device->lun,
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
+	int i;
+	char *buf = NULL;
+	struct afu *afu = cfg->afu;
 
-	rcr = cxlflash_afu_reset(cfg);
-	if (rcr == 0)
-		rc = SUCCESS;
-	else
-		rc = FAILED;
+	if (cfg->afu) {
+		for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
+			buf = afu->cmd[i].buf;
+			if (!((u64)buf & (PAGE_SIZE - 1)))
+				free_page((ulong)buf);
+		}
 
-	pr_debug("%s: returning rc=%d\n", __func__, rc);
-	return rc;
+		free_pages((ulong)afu, get_order(sizeof(struct afu)));
+		cfg->afu = NULL;
+	}
 }
 
 /**
- * cxlflash_change_queue_depth() - change the queue depth for the device
- * @sdev:	SCSI device destined for queue depth change.
- * @qdepth:	Requested queue depth value to set.
- *
- * The requested queue depth is capped to the maximum supported value.
+ * stop_afu() - stops the AFU command timers and unmaps the MMIO space
+ * @cfg:	Internal structure associated with the host.
  *
- * Return: The actual queue depth set.
+ * Safe to call with AFU in a partially allocated/initialized state.
  */
-static int cxlflash_change_queue_depth(struct scsi_device *sdev, int qdepth)
+static void stop_afu(struct cxlflash_cfg *cfg)
 {
+	int i;
+	struct afu *afu = cfg->afu;
 
-	if (qdepth > CXLFLASH_MAX_CMDS_PER_LUN)
-		qdepth = CXLFLASH_MAX_CMDS_PER_LUN;
+	if (likely(afu)) {
+		for (i = 0; i < CXLFLASH_NUM_CMDS; i++)
+			complete(&afu->cmd[i].cevent);
 
-	scsi_change_queue_depth(sdev, qdepth);
-	return sdev->queue_depth;
-}
-
-/**
- * cxlflash_show_port_status() - queries and presents the current port status
- * @dev:	Generic device associated with the host owning the port.
- * @attr:	Device attribute representing the port.
- * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
- *
- * Return: The size of the ASCII string returned in @buf.
- */
-static ssize_t cxlflash_show_port_status(struct device *dev,
-					 struct device_attribute *attr,
-					 char *buf)
-{
-	struct Scsi_Host *shost = class_to_shost(dev);
-	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)shost->hostdata;
-	struct afu *afu = cfg->afu;
-
-	char *disp_status;
-	int rc;
-	u32 port;
-	u64 status;
-	u64 *fc_regs;
-
-	rc = kstrtouint((attr->attr.name + 4), 10, &port);
-	if (rc || (port > NUM_FC_PORTS))
-		return 0;
-
-	fc_regs = &afu->afu_map->global.fc_regs[port][0];
-	status =
-	    (readq_be(&fc_regs[FC_MTIP_STATUS / 8]) & FC_MTIP_STATUS_MASK);
-
-	if (status == FC_MTIP_STATUS_ONLINE)
-		disp_status = "online";
-	else if (status == FC_MTIP_STATUS_OFFLINE)
-		disp_status = "offline";
-	else
-		disp_status = "unknown";
-
-	return snprintf(buf, PAGE_SIZE, "%s\n", disp_status);
-}
-
-/**
- * cxlflash_show_lun_mode() - presents the current LUN mode of the host
- * @dev:	Generic device associated with the host.
- * @attr:	Device attribute representing the lun mode.
- * @buf:	Buffer of length PAGE_SIZE to report back the LUN mode in ASCII.
- *
- * Return: The size of the ASCII string returned in @buf.
- */
-static ssize_t cxlflash_show_lun_mode(struct device *dev,
-				      struct device_attribute *attr, char *buf)
-{
-	struct Scsi_Host *shost = class_to_shost(dev);
-	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)shost->hostdata;
-	struct afu *afu = cfg->afu;
-
-	return snprintf(buf, PAGE_SIZE, "%u\n", afu->internal_lun);
-}
-
-/**
- * cxlflash_store_lun_mode() - sets the LUN mode of the host
- * @dev:	Generic device associated with the host.
- * @attr:	Device attribute representing the lun mode.
- * @buf:	Buffer of length PAGE_SIZE containing the LUN mode in ASCII.
- * @count:	Length of data resizing in @buf.
- *
- * The CXL Flash AFU supports a dummy LUN mode where the external
- * links and storage are not required. Space on the FPGA is used
- * to create 1 or 2 small LUNs which are presented to the system
- * as if they were a normal storage device. This feature is useful
- * during development and also provides manufacturing with a way
- * to test the AFU without an actual device.
- *
- * 0 = external LUN[s] (default)
- * 1 = internal LUN (1 x 64K, 512B blocks, id 0)
- * 2 = internal LUN (1 x 64K, 4K blocks, id 0)
- * 3 = internal LUN (2 x 32K, 512B blocks, ids 0,1)
- * 4 = internal LUN (2 x 32K, 4K blocks, ids 0,1)
- *
- * Return: The size of the ASCII string returned in @buf.
- */
-static ssize_t cxlflash_store_lun_mode(struct device *dev,
-				       struct device_attribute *attr,
-				       const char *buf, size_t count)
-{
-	struct Scsi_Host *shost = class_to_shost(dev);
-	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)shost->hostdata;
-	struct afu *afu = cfg->afu;
-	int rc;
-	u32 lun_mode;
-
-	rc = kstrtouint(buf, 10, &lun_mode);
-	if (!rc && (lun_mode < 5) && (lun_mode != afu->internal_lun)) {
-		afu->internal_lun = lun_mode;
-		cxlflash_afu_reset(cfg);
-		scsi_scan_host(cfg->host);
-	}
-
-	return count;
-}
-
-/**
- * cxlflash_show_dev_mode() - presents the current mode of the device
- * @dev:	Generic device associated with the device.
- * @attr:	Device attribute representing the device mode.
- * @buf:	Buffer of length PAGE_SIZE to report back the dev mode in ASCII.
- *
- * Return: The size of the ASCII string returned in @buf.
- */
-static ssize_t cxlflash_show_dev_mode(struct device *dev,
-				      struct device_attribute *attr, char *buf)
-{
-	struct scsi_device *sdev = to_scsi_device(dev);
-
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-			sdev->hostdata ? "superpipe" : "legacy");
-}
-
-/**
- * cxlflash_wait_for_pci_err_recovery() - wait for error recovery during probe
- * @cxlflash:	Internal structure associated with the host.
- */
-static void cxlflash_wait_for_pci_err_recovery(struct cxlflash_cfg *cfg)
-{
-	struct pci_dev *pdev = cfg->dev;
-
-	if (pci_channel_offline(pdev))
-		wait_event_timeout(cfg->eeh_waitq,
-				   !pci_channel_offline(pdev),
-				   CXLFLASH_PCI_ERROR_RECOVERY_TIMEOUT);
-}
-
-/*
- * Host attributes
- */
-static DEVICE_ATTR(port0, S_IRUGO, cxlflash_show_port_status, NULL);
-static DEVICE_ATTR(port1, S_IRUGO, cxlflash_show_port_status, NULL);
-static DEVICE_ATTR(lun_mode, S_IRUGO | S_IWUSR, cxlflash_show_lun_mode,
-		   cxlflash_store_lun_mode);
-
-static struct device_attribute *cxlflash_host_attrs[] = {
-	&dev_attr_port0,
-	&dev_attr_port1,
-	&dev_attr_lun_mode,
-	NULL
-};
-
-/*
- * Device attributes
- */
-static DEVICE_ATTR(mode, S_IRUGO, cxlflash_show_dev_mode, NULL);
-
-static struct device_attribute *cxlflash_dev_attrs[] = {
-	&dev_attr_mode,
-	NULL
-};
-
-/*
- * Host template
- */
-static struct scsi_host_template driver_template = {
-	.module = THIS_MODULE,
-	.name = CXLFLASH_ADAPTER_NAME,
-	.info = cxlflash_driver_info,
-	.proc_name = CXLFLASH_NAME,
-	.queuecommand = cxlflash_queuecommand,
-	.eh_device_reset_handler = cxlflash_eh_device_reset_handler,
-	.eh_host_reset_handler = cxlflash_eh_host_reset_handler,
-	.change_queue_depth = cxlflash_change_queue_depth,
-	.cmd_per_lun = 16,
-	.can_queue = CXLFLASH_MAX_CMDS,
-	.this_id = -1,
-	.sg_tablesize = SG_NONE,	/* No scatter gather support. */
-	.max_sectors = CXLFLASH_MAX_SECTORS,
-	.use_clustering = ENABLE_CLUSTERING,
-	.shost_attrs = cxlflash_host_attrs,
-	.sdev_attrs = cxlflash_dev_attrs,
-};
-
-/*
- * Device dependent values
- */
-static struct dev_dependent_vals dev_corsa_vals = { CXLFLASH_MAX_SECTORS };
-
-/*
- * PCI device binding table
- */
-static struct pci_device_id cxlflash_pci_table[] = {
-	{PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CORSA,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, (kernel_ulong_t)&dev_corsa_vals},
-	{}
-};
-
-MODULE_DEVICE_TABLE(pci, cxlflash_pci_table);
-
-/**
- * free_mem() - free memory associated with the AFU
- * @cxlflash:	Internal structure associated with the host.
- */
-static void free_mem(struct cxlflash_cfg *cfg)
-{
-	int i;
-	char *buf = NULL;
-	struct afu *afu = cfg->afu;
-
-	if (cfg->afu) {
-		for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
-			buf = afu->cmd[i].buf;
-			if (!((u64)buf & (PAGE_SIZE - 1)))
-				free_page((ulong)buf);
-		}
-
-		free_pages((ulong)afu, get_order(sizeof(struct afu)));
-		cfg->afu = NULL;
-	}
-}
-
-/**
- * stop_afu() - stops the AFU command timers and unmaps the MMIO space
- * @cxlflash:	Internal structure associated with the host.
- *
- * Safe to call with AFU in a partially allocated/initialized state.
- */
-static void stop_afu(struct cxlflash_cfg *cfg)
-{
-	int i;
-	struct afu *afu = cfg->afu;
-
-	if (likely(afu)) {
-		for (i = 0; i < CXLFLASH_NUM_CMDS; i++)
-			complete(&afu->cmd[i].cevent);
-
-		if (likely(afu->afu_map)) {
-			cxl_psa_unmap((void *)afu->afu_map);
-			afu->afu_map = NULL;
-		}
-	}
+		if (likely(afu->afu_map)) {
+			cxl_psa_unmap((void *)afu->afu_map);
+			afu->afu_map = NULL;
+		}
+	}
 }
 
 /**
  * term_mc() - terminates the master context
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  * @level:	Depth of allocation, where to begin waterfall tear down.
  *
  * Safe to call with AFU/MC in partially allocated/initialized state.
@@ -765,9 +643,10 @@ static void term_mc(struct cxlflash_cfg *cfg, enum undo_level level)
 {
 	int rc = 0;
 	struct afu *afu = cfg->afu;
+	struct device *dev = &cfg->dev->dev;
 
 	if (!afu || !cfg->mcctx) {
-		pr_err("%s: returning from term_mc with NULL afu or MC\n",
+		dev_err(dev, "%s: returning from term_mc with NULL afu or MC\n",
 		       __func__);
 		return;
 	}
@@ -791,7 +670,7 @@ static void term_mc(struct cxlflash_cfg *cfg, enum undo_level level)
 
 /**
  * term_afu() - terminates the AFU
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  *
  * Safe to call with AFU/MC in partially allocated/initialized state.
  */
@@ -819,25 +698,27 @@ static void cxlflash_remove(struct pci_dev *pdev)
 	/* If a Task Management Function is active, wait for it to complete
 	 * before continuing with remove.
 	 */
-	spin_lock_irqsave(&cfg->tmf_waitq.lock, lock_flags);
+	spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
 	if (cfg->tmf_active)
-		wait_event_interruptible_locked_irq(cfg->tmf_waitq,
-						    !cfg->tmf_active);
-	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
+		wait_event_interruptible_lock_irq(cfg->tmf_waitq,
+						  !cfg->tmf_active,
+						  cfg->tmf_slock);
+	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
+
 
 	switch (cfg->init_state) {
 	case INIT_STATE_SCSI:
 		scsi_remove_host(cfg->host);
-		scsi_host_put(cfg->host);
-		/* Fall through */
+		/* fall through */
 	case INIT_STATE_AFU:
+		cancel_work_sync(&cfg->work_q);
 		term_afu(cfg);
 	case INIT_STATE_PCI:
 		pci_release_regions(cfg->dev);
 		pci_disable_device(pdev);
 	case INIT_STATE_NONE:
-		flush_work(&cfg->work_q);
 		free_mem(cfg);
+		scsi_host_put(cfg->host);
 		break;
 	}
 
@@ -846,7 +727,7 @@ static void cxlflash_remove(struct pci_dev *pdev)
 
 /**
  * alloc_mem() - allocates the AFU and its command pool
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  *
  * A partially allocated state remains on failure.
  *
@@ -859,15 +740,14 @@ static int alloc_mem(struct cxlflash_cfg *cfg)
 	int rc = 0;
 	int i;
 	char *buf = NULL;
+	struct device *dev = &cfg->dev->dev;
 
-	/* This allocation is about 12K, i.e. only 1 64k page
-	 * and upto 4 4k pages
-	 */
+	/* AFU is ~12k, i.e. only one 64k page or up to four 4k pages */
 	cfg->afu = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 					    get_order(sizeof(struct afu)));
 	if (unlikely(!cfg->afu)) {
-		pr_err("%s: cannot get %d free pages\n",
-		       __func__, get_order(sizeof(struct afu)));
+		dev_err(dev, "%s: cannot get %d free pages\n",
+			__func__, get_order(sizeof(struct afu)));
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -878,7 +758,8 @@ static int alloc_mem(struct cxlflash_cfg *cfg)
 		if (!((u64)buf & (PAGE_SIZE - 1))) {
 			buf = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 			if (unlikely(!buf)) {
-				pr_err("%s: Allocate command buffers fail!\n",
+				dev_err(dev,
+					"%s: Allocate command buffers fail!\n",
 				       __func__);
 				rc = -ENOMEM;
 				free_mem(cfg);
@@ -897,12 +778,9 @@ out:
 
 /**
  * init_pci() - initializes the host as a PCI device
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  *
- * Return:
- *	0 on success
- *	-EIO on unable to communicate with device
- *	A return code from the PCI sub-routines
+ * Return: 0 on success, -errno on failure
  */
 static int init_pci(struct cxlflash_cfg *cfg)
 {
@@ -982,11 +860,9 @@ out_release_regions:
 
 /**
  * init_scsi() - adds the host to the SCSI stack and kicks off host scan
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  *
- * Return:
- *	0 on success
- *	A return code from adding the host
+ * Return: 0 on success, -errno on failure
  */
 static int init_scsi(struct cxlflash_cfg *cfg)
 {
@@ -1123,7 +999,7 @@ static int wait_port_offline(u64 *fc_regs, u32 delay_us, u32 nretry)
  */
 static int afu_set_wwpn(struct afu *afu, int port, u64 *fc_regs, u64 wwpn)
 {
-	int ret = 0;
+	int rc = 0;
 
 	set_port_offline(fc_regs);
 
@@ -1131,33 +1007,26 @@ static int afu_set_wwpn(struct afu *afu, int port, u64 *fc_regs, u64 wwpn)
 			       FC_PORT_STATUS_RETRY_CNT)) {
 		pr_debug("%s: wait on port %d to go offline timed out\n",
 			 __func__, port);
-		ret = -1; /* but continue on to leave the port back online */
+		rc = -1; /* but continue on to leave the port back online */
 	}
 
-	if (ret == 0)
+	if (rc == 0)
 		writeq_be(wwpn, &fc_regs[FC_PNAME / 8]);
 
+	/* Always return success after programming WWPN */
+	rc = 0;
+
 	set_port_online(fc_regs);
 
 	if (!wait_port_online(fc_regs, FC_PORT_STATUS_RETRY_INTERVAL_US,
 			      FC_PORT_STATUS_RETRY_CNT)) {
 		pr_debug("%s: wait on port %d to go online timed out\n",
 			 __func__, port);
-		ret = -1;
-
-		/*
-		 * Override for internal lun!!!
-		 */
-		if (afu->internal_lun) {
-			pr_debug("%s: Overriding port %d online timeout!!!\n",
-				 __func__, port);
-			ret = 0;
-		}
 	}
 
-	pr_debug("%s: returning rc=%d\n", __func__, ret);
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
 
-	return ret;
+	return rc;
 }
 
 /**
@@ -1212,17 +1081,17 @@ static const struct asyc_intr_info ainfo[] = {
 	{SISL_ASTATUS_FC0_CRC_T, "CRC threshold exceeded", 0, LINK_RESET},
 	{SISL_ASTATUS_FC0_LOGI_R, "login timed out, retrying", 0, 0},
 	{SISL_ASTATUS_FC0_LOGI_F, "login failed", 0, CLR_FC_ERROR},
-	{SISL_ASTATUS_FC0_LOGI_S, "login succeeded", 0, 0},
+	{SISL_ASTATUS_FC0_LOGI_S, "login succeeded", 0, SCAN_HOST},
 	{SISL_ASTATUS_FC0_LINK_DN, "link down", 0, 0},
-	{SISL_ASTATUS_FC0_LINK_UP, "link up", 0, 0},
+	{SISL_ASTATUS_FC0_LINK_UP, "link up", 0, SCAN_HOST},
 	{SISL_ASTATUS_FC1_OTHER, "other error", 1, CLR_FC_ERROR | LINK_RESET},
 	{SISL_ASTATUS_FC1_LOGO, "target initiated LOGO", 1, 0},
 	{SISL_ASTATUS_FC1_CRC_T, "CRC threshold exceeded", 1, LINK_RESET},
 	{SISL_ASTATUS_FC1_LOGI_R, "login timed out, retrying", 1, 0},
 	{SISL_ASTATUS_FC1_LOGI_F, "login failed", 1, CLR_FC_ERROR},
-	{SISL_ASTATUS_FC1_LOGI_S, "login succeeded", 1, 0},
+	{SISL_ASTATUS_FC1_LOGI_S, "login succeeded", 1, SCAN_HOST},
 	{SISL_ASTATUS_FC1_LINK_DN, "link down", 1, 0},
-	{SISL_ASTATUS_FC1_LINK_UP, "link up", 1, 0},
+	{SISL_ASTATUS_FC1_LINK_UP, "link up", 1, SCAN_HOST},
 	{0x0, "", 0, 0}		/* terminator */
 };
 
@@ -1384,7 +1253,8 @@ static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
 static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 {
 	struct afu *afu = (struct afu *)data;
-	struct cxlflash_cfg *cfg;
+	struct cxlflash_cfg *cfg = afu->parent;
+	struct device *dev = &cfg->dev->dev;
 	u64 reg_unmasked;
 	const struct asyc_intr_info *info;
 	struct sisl_global_map *global = &afu->afu_map->global;
@@ -1392,39 +1262,37 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 	u8 port;
 	int i;
 
-	cfg = afu->parent;
-
 	reg = readq_be(&global->regs.aintr_status);
 	reg_unmasked = (reg & SISL_ASTATUS_UNMASK);
 
 	if (reg_unmasked == 0) {
-		pr_err("%s: spurious interrupt, aintr_status 0x%016llX\n",
-		       __func__, reg);
+		dev_err(dev, "%s: spurious interrupt, aintr_status 0x%016llX\n",
+			__func__, reg);
 		goto out;
 	}
 
-	/* it is OK to clear AFU status before FC_ERROR */
+	/* FYI, it is 'okay' to clear AFU status before FC_ERROR */
 	writeq_be(reg_unmasked, &global->regs.aintr_clear);
 
-	/* check each bit that is on */
+	/* Check each bit that is on */
 	for (i = 0; reg_unmasked; i++, reg_unmasked = (reg_unmasked >> 1)) {
 		info = find_ainfo(1ULL << i);
-		if ((reg_unmasked & 0x1) || !info)
+		if (((reg_unmasked & 0x1) == 0) || !info)
 			continue;
 
 		port = info->port;
 
-		pr_err("%s: FC Port %d -> %s, fc_status 0x%08llX\n",
-		       __func__, port, info->desc,
+		dev_err(dev, "%s: FC Port %d -> %s, fc_status 0x%08llX\n",
+			__func__, port, info->desc,
 		       readq_be(&global->fc_regs[port][FC_STATUS / 8]));
 
 		/*
-		 * do link reset first, some OTHER errors will set FC_ERROR
+		 * Do link reset first, some OTHER errors will set FC_ERROR
 		 * again if cleared before or w/o a reset
 		 */
 		if (info->action & LINK_RESET) {
-			pr_err("%s: FC Port %d: resetting link\n",
-			       __func__, port);
+			dev_err(dev, "%s: FC Port %d: resetting link\n",
+				__func__, port);
 			cfg->lr_state = LINK_RESET_REQUIRED;
 			cfg->lr_port = port;
 			schedule_work(&cfg->work_q);
@@ -1434,26 +1302,31 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 			reg = readq_be(&global->fc_regs[port][FC_ERROR / 8]);
 
 			/*
-			 * since all errors are unmasked, FC_ERROR and FC_ERRCAP
+			 * Since all errors are unmasked, FC_ERROR and FC_ERRCAP
 			 * should be the same and tracing one is sufficient.
 			 */
 
-			pr_err("%s: fc %d: clearing fc_error 0x%08llX\n",
-			       __func__, port, reg);
+			dev_err(dev, "%s: fc %d: clearing fc_error 0x%08llX\n",
+				__func__, port, reg);
 
 			writeq_be(reg, &global->fc_regs[port][FC_ERROR / 8]);
 			writeq_be(0, &global->fc_regs[port][FC_ERRCAP / 8]);
 		}
+
+		if (info->action & SCAN_HOST) {
+			atomic_inc(&cfg->scan_host_needed);
+			schedule_work(&cfg->work_q);
+		}
 	}
 
 out:
-	pr_debug("%s: returning rc=%d, afu=%p\n", __func__, IRQ_HANDLED, afu);
+	dev_dbg(dev, "%s: returning IRQ_HANDLED, afu=%p\n", __func__, afu);
 	return IRQ_HANDLED;
 }
 
 /**
  * start_context() - starts the master context
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  *
  * Return: A success or failure value from CXL services.
  */
@@ -1471,12 +1344,10 @@ static int start_context(struct cxlflash_cfg *cfg)
 
 /**
  * read_vpd() - obtains the WWPNs from VPD
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  * @wwpn:	Array of size NUM_FC_PORTS to pass back WWPNs
  *
- * Return:
- *	0 on success
- *	-ENODEV when VPD or WWPN keywords not found
+ * Return: 0 on success, -errno on failure
  */
 static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 {
@@ -1491,7 +1362,7 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 	/* Get the VPD data from the device */
 	vpd_size = pci_read_vpd(dev, 0, sizeof(vpd_data), vpd_data);
 	if (unlikely(vpd_size <= 0)) {
-		pr_err("%s: Unable to read VPD (size = %ld)\n",
+		dev_err(&dev->dev, "%s: Unable to read VPD (size = %ld)\n",
 		       __func__, vpd_size);
 		rc = -ENODEV;
 		goto out;
@@ -1501,7 +1372,8 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 	ro_start = pci_vpd_find_tag(vpd_data, 0, vpd_size,
 				    PCI_VPD_LRDT_RO_DATA);
 	if (unlikely(ro_start < 0)) {
-		pr_err("%s: VPD Read-only data not found\n", __func__);
+		dev_err(&dev->dev, "%s: VPD Read-only data not found\n",
+			__func__);
 		rc = -ENODEV;
 		goto out;
 	}
@@ -1530,8 +1402,8 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 
 		i = pci_vpd_find_info_keyword(vpd_data, i, j, wwpn_vpd_tags[k]);
 		if (unlikely(i < 0)) {
-			pr_err("%s: Port %d WWPN not found in VPD\n",
-			       __func__, k);
+			dev_err(&dev->dev, "%s: Port %d WWPN not found "
+				"in VPD\n", __func__, k);
 			rc = -ENODEV;
 			goto out;
 		}
@@ -1539,7 +1411,8 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 		j = pci_vpd_info_field_size(&vpd_data[i]);
 		i += PCI_VPD_INFO_FLD_HDR_SIZE;
 		if (unlikely((i + j > vpd_size) || (j != WWPN_LEN))) {
-			pr_err("%s: Port %d WWPN incomplete or VPD corrupt\n",
+			dev_err(&dev->dev, "%s: Port %d WWPN incomplete or "
+				"VPD corrupt\n",
 			       __func__, k);
 			rc = -ENODEV;
 			goto out;
@@ -1548,8 +1421,8 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 		memcpy(tmp_buf, &vpd_data[i], WWPN_LEN);
 		rc = kstrtoul(tmp_buf, WWPN_LEN, (ulong *)&wwpn[k]);
 		if (unlikely(rc)) {
-			pr_err("%s: Fail to convert port %d WWPN to integer\n",
-			       __func__, k);
+			dev_err(&dev->dev, "%s: Fail to convert port %d WWPN "
+				"to integer\n", __func__, k);
 			rc = -ENODEV;
 			goto out;
 		}
@@ -1561,91 +1434,36 @@ out:
 }
 
 /**
- * cxlflash_context_reset() - timeout handler for AFU commands
- * @cmd:	AFU command that timed out.
+ * init_pcr() - initialize the provisioning and control registers
+ * @cfg:	Internal structure associated with the host.
  *
- * Sends a reset to the AFU.
+ * Also sets up fast access to the mapped registers and initializes AFU
+ * command fields that never change.
  */
-void cxlflash_context_reset(struct afu_cmd *cmd)
+static void init_pcr(struct cxlflash_cfg *cfg)
 {
-	int nretry = 0;
-	u64 rrin = 0x1;
-	u64 room = 0;
-	struct afu *afu = cmd->parent;
-	ulong lock_flags;
-
-	pr_debug("%s: cmd=%p\n", __func__, cmd);
+	struct afu *afu = cfg->afu;
+	struct sisl_ctrl_map *ctrl_map;
+	int i;
 
-	spin_lock_irqsave(&cmd->slock, lock_flags);
+	for (i = 0; i < MAX_CONTEXT; i++) {
+		ctrl_map = &afu->afu_map->ctrls[i].ctrl;
+		/* Disrupt any clients that could be running */
+		/* e. g. clients that survived a master restart */
+		writeq_be(0, &ctrl_map->rht_start);
+		writeq_be(0, &ctrl_map->rht_cnt_id);
+		writeq_be(0, &ctrl_map->ctx_cap);
+	}
 
-	/* Already completed? */
-	if (cmd->sa.host_use_b[0] & B_DONE) {
-		spin_unlock_irqrestore(&cmd->slock, lock_flags);
-		return;
-	}
-
-	cmd->sa.host_use_b[0] |= (B_DONE | B_ERROR | B_TIMEOUT);
-	spin_unlock_irqrestore(&cmd->slock, lock_flags);
-
-	/*
-	 * We really want to send this reset at all costs, so spread
-	 * out wait time on successive retries for available room.
-	 */
-	do {
-		room = readq_be(&afu->host_map->cmd_room);
-		atomic64_set(&afu->room, room);
-		if (room)
-			goto write_rrin;
-		udelay(nretry);
-	} while (nretry++ < MC_ROOM_RETRY_CNT);
-
-	pr_err("%s: no cmd_room to send reset\n", __func__);
-	return;
-
-write_rrin:
-	nretry = 0;
-	writeq_be(rrin, &afu->host_map->ioarrin);
-	do {
-		rrin = readq_be(&afu->host_map->ioarrin);
-		if (rrin != 0x1)
-			break;
-		/* Double delay each time */
-		udelay(2 ^ nretry);
-	} while (nretry++ < MC_ROOM_RETRY_CNT);
-}
-
-/**
- * init_pcr() - initialize the provisioning and control registers
- * @cxlflash:	Internal structure associated with the host.
- *
- * Also sets up fast access to the mapped registers and initializes AFU
- * command fields that never change.
- */
-void init_pcr(struct cxlflash_cfg *cfg)
-{
-	struct afu *afu = cfg->afu;
-	struct sisl_ctrl_map *ctrl_map;
-	int i;
-
-	for (i = 0; i < MAX_CONTEXT; i++) {
-		ctrl_map = &afu->afu_map->ctrls[i].ctrl;
-		/* disrupt any clients that could be running */
-		/* e. g. clients that survived a master restart */
-		writeq_be(0, &ctrl_map->rht_start);
-		writeq_be(0, &ctrl_map->rht_cnt_id);
-		writeq_be(0, &ctrl_map->ctx_cap);
-	}
-
-	/* copy frequently used fields into afu */
+	/* Copy frequently used fields into afu */
 	afu->ctx_hndl = (u16) cxl_process_element(cfg->mcctx);
-	/* ctx_hndl is 16 bits in CAIA */
 	afu->host_map = &afu->afu_map->hosts[afu->ctx_hndl].host;
 	afu->ctrl_map = &afu->afu_map->ctrls[afu->ctx_hndl].ctrl;
 
 	/* Program the Endian Control for the master context */
 	writeq_be(SISL_ENDIAN_CTRL, &afu->host_map->endian_ctrl);
 
-	/* initialize cmd fields that never change */
+	/* Initialize cmd fields that never change */
 	for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
 		afu->cmd[i].rcb.ctx_id = afu->ctx_hndl;
 		afu->cmd[i].rcb.msi = SISL_MSI_RRQ_UPDATED;
@@ -1655,11 +1473,12 @@ void init_pcr(struct cxlflash_cfg *cfg)
 
 /**
  * init_global() - initialize AFU global registers
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  */
-int init_global(struct cxlflash_cfg *cfg)
+static int init_global(struct cxlflash_cfg *cfg)
 {
 	struct afu *afu = cfg->afu;
+	struct device *dev = &cfg->dev->dev;
 	u64 wwpn[NUM_FC_PORTS];	/* wwpn of AFU ports */
 	int i = 0, num_ports = 0;
 	int rc = 0;
@@ -1667,13 +1486,13 @@ int init_global(struct cxlflash_cfg *cfg)
 
 	rc = read_vpd(cfg, &wwpn[0]);
 	if (rc) {
-		pr_err("%s: could not read vpd rc=%d\n", __func__, rc);
+		dev_err(dev, "%s: could not read vpd rc=%d\n", __func__, rc);
 		goto out;
 	}
 
 	pr_debug("%s: wwpn0=0x%llX wwpn1=0x%llX\n", __func__, wwpn[0], wwpn[1]);
 
-	/* set up RRQ in AFU for master issued cmds */
+	/* Set up RRQ in AFU for master issued cmds */
 	writeq_be((u64) afu->hrrq_start, &afu->host_map->rrq_start);
 	writeq_be((u64) afu->hrrq_end, &afu->host_map->rrq_end);
 
@@ -1686,9 +1505,9 @@ int init_global(struct cxlflash_cfg *cfg)
 	/* checker on if dual afu */
 	writeq_be(reg, &afu->afu_map->global.regs.afu_config);
 
-	/* global port select: select either port */
+	/* Global port select: select either port */
 	if (afu->internal_lun) {
-		/* only use port 0 */
+		/* Only use port 0 */
 		writeq_be(PORT0, &afu->afu_map->global.regs.afu_port_sel);
 		num_ports = NUM_FC_PORTS - 1;
 	} else {
@@ -1697,20 +1516,20 @@ int init_global(struct cxlflash_cfg *cfg)
 	}
 
 	for (i = 0; i < num_ports; i++) {
-		/* unmask all errors (but they are still masked at AFU) */
+		/* Unmask all errors (but they are still masked at AFU) */
 		writeq_be(0, &afu->afu_map->global.fc_regs[i][FC_ERRMSK / 8]);
-		/* clear CRC error cnt & set a threshold */
+		/* Clear CRC error cnt & set a threshold */
 		(void)readq_be(&afu->afu_map->global.
 			       fc_regs[i][FC_CNT_CRCERR / 8]);
 		writeq_be(MC_CRC_THRESH, &afu->afu_map->global.fc_regs[i]
 			  [FC_CRC_THRESH / 8]);
 
-		/* set WWPNs. If already programmed, wwpn[i] is 0 */
+		/* Set WWPNs. If already programmed, wwpn[i] is 0 */
 		if (wwpn[i] != 0 &&
 		    afu_set_wwpn(afu, i,
 				 &afu->afu_map->global.fc_regs[i][0],
 				 wwpn[i])) {
-			pr_err("%s: failed to set WWPN on port %d\n",
+			dev_err(dev, "%s: failed to set WWPN on port %d\n",
 			       __func__, i);
 			rc = -EIO;
 			goto out;
@@ -1719,10 +1538,9 @@ int init_global(struct cxlflash_cfg *cfg)
 		 * offline/online transitions and a PLOGI
 		 */
 		msleep(100);
-
 	}
 
-	/* set up master's own CTX_CAP to allow real mode, host translation */
+	/* Set up master's own CTX_CAP to allow real mode, host translation */
 	/* tbls, afu cmds and read/write GSCSI cmds. */
 	/* First, unlock ctx_cap write by reading mbox */
 	(void)readq_be(&afu->ctrl_map->mbox_r);	/* unlock ctx_cap */
@@ -1730,7 +1548,7 @@ int init_global(struct cxlflash_cfg *cfg)
 		   SISL_CTX_CAP_READ_CMD | SISL_CTX_CAP_WRITE_CMD |
 		   SISL_CTX_CAP_AFU_CMD | SISL_CTX_CAP_GSCSI_CMD),
 		  &afu->ctrl_map->ctx_cap);
-	/* init heartbeat */
+	/* Initialize heartbeat */
 	afu->hb = readq_be(&afu->afu_map->global.regs.afu_hb);
 
 out:
@@ -1739,7 +1557,7 @@ out:
 
 /**
  * start_afu() - initializes and starts the AFU
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  */
 static int start_afu(struct cxlflash_cfg *cfg)
 {
@@ -1759,7 +1577,10 @@ static int start_afu(struct cxlflash_cfg *cfg)
 
 	init_pcr(cfg);
 
-	/* initialize RRQ pointers */
+	/* After an AFU reset, RRQ entries are stale, clear them */
+	memset(&afu->rrq_entry, 0, sizeof(afu->rrq_entry));
+
+	/* Initialize RRQ pointers */
 	afu->hrrq_start = &afu->rrq_entry[0];
 	afu->hrrq_end = &afu->rrq_entry[NUM_RRQ_ENTRY - 1];
 	afu->hrrq_curr = afu->hrrq_start;
@@ -1773,12 +1594,9 @@ static int start_afu(struct cxlflash_cfg *cfg)
 
 /**
  * init_mc() - create and register as the master context
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  *
- * Return:
- *	0 on success
- *	-ENOMEM when unable to obtain a context from CXL services
- *	A failure value from CXL services.
+ * Return: 0 on success, -errno on failure
  */
 static int init_mc(struct cxlflash_cfg *cfg)
 {
@@ -1862,15 +1680,12 @@ out:
 
 /**
  * init_afu() - setup as master context and start AFU
- * @cxlflash:	Internal structure associated with the host.
+ * @cfg:	Internal structure associated with the host.
  *
  * This routine is a higher level of control for configuring the
  * AFU on probe and reset paths.
  *
- * Return:
- *	0 on success
- *	-ENOMEM when unable to map the AFU MMIO space
- *	A failure value from internal services.
+ * Return: 0 on success, -errno on failure
  */
 static int init_afu(struct cxlflash_cfg *cfg)
 {
@@ -1886,8 +1701,7 @@ static int init_afu(struct cxlflash_cfg *cfg)
 		goto err1;
 	}
 
-	/* Map the entire MMIO space of the AFU.
-	 */
+	/* Map the entire MMIO space of the AFU */
 	afu->afu_map = cxl_psa_map(cfg->mcctx);
 	if (!afu->afu_map) {
 		rc = -ENOMEM;
@@ -1896,8 +1710,7 @@ static int init_afu(struct cxlflash_cfg *cfg)
 		goto err1;
 	}
 
-	/* don't byte reverse on reading afu_version, else the string form */
-	/*     will be backwards */
+	/* No byte reverse on reading afu_version or string will be backwards */
 	reg = afu->afu_map->global.regs.afu_version;
 	memcpy(afu->version, &reg, 8);
 	afu->interface_version =
@@ -1924,92 +1737,6 @@ err1:
 }
 
 /**
- * cxlflash_send_cmd() - sends an AFU command
- * @afu:	AFU associated with the host.
- * @cmd:	AFU command to send.
- *
- * Return:
- *	0 on success
- *	-1 on failure
- */
-int cxlflash_send_cmd(struct afu *afu, struct afu_cmd *cmd)
-{
-	struct cxlflash_cfg *cfg = afu->parent;
-	int nretry = 0;
-	int rc = 0;
-	u64 room;
-	long newval;
-
-	/*
-	 * This routine is used by critical users such an AFU sync and to
-	 * send a task management function (TMF). Thus we want to retry a
-	 * bit before returning an error. To avoid the performance penalty
-	 * of MMIO, we spread the update of 'room' over multiple commands.
-	 */
-retry:
-	newval = atomic64_dec_if_positive(&afu->room);
-	if (!newval) {
-		do {
-			room = readq_be(&afu->host_map->cmd_room);
-			atomic64_set(&afu->room, room);
-			if (room)
-				goto write_ioarrin;
-			udelay(nretry);
-		} while (nretry++ < MC_ROOM_RETRY_CNT);
-
-		pr_err("%s: no cmd_room to send 0x%X\n",
-		       __func__, cmd->rcb.cdb[0]);
-
-		goto no_room;
-	} else if (unlikely(newval < 0)) {
-		/* This should be rare. i.e. Only if two threads race and
-		 * decrement before the MMIO read is done. In this case
-		 * just benefit from the other thread having updated 
-		 * afu->room.
-		 */
-		if (nretry++ < MC_ROOM_RETRY_CNT) {
-			udelay(nretry);
-			goto retry;
-		}
-
-		goto no_room;
-	}
-
-write_ioarrin:
-	writeq_be((u64)&cmd->rcb, &afu->host_map->ioarrin);
-out:
-	pr_debug("%s: cmd=%p len=%d ea=%p rc=%d\n", __func__, cmd,
-		 cmd->rcb.data_len, (void *)cmd->rcb.data_ea, rc);
-	return rc;
-
-no_room:
-	afu->read_room = true;
-	schedule_work(&cfg->work_q);
-	rc = SCSI_MLQUEUE_HOST_BUSY;
-	goto out;
-}
-
-/**
- * cxlflash_wait_resp() - polls for a response or timeout to a sent AFU command
- * @afu:	AFU associated with the host.
- * @cmd:	AFU command that was sent.
- */
-void cxlflash_wait_resp(struct afu *afu, struct afu_cmd *cmd)
-{
-	ulong timeout = jiffies + (cmd->rcb.timeout * 2 * HZ);
-
-	timeout = wait_for_completion_timeout(&cmd->cevent, timeout);
-	if (!timeout)
-		cxlflash_context_reset(cmd);
-
-	if (unlikely(cmd->sa.ioasc != 0))
-		pr_err("%s: CMD 0x%X failed, IOASC: flags 0x%X, afu_rc 0x%X, "
-		       "scsi_rc 0x%X, fc_rc 0x%X\n", __func__, cmd->rcb.cdb[0],
-		       cmd->sa.rc.flags, cmd->sa.rc.afu_rc, cmd->sa.rc.scsi_rc,
-		       cmd->sa.rc.fc_rc);
-}
-
-/**
  * cxlflash_afu_sync() - builds and sends an AFU sync command
  * @afu:	AFU associated with the host.
  * @ctx_hndl_u:	Identifies context requesting sync.
@@ -2028,6 +1755,8 @@ void cxlflash_wait_resp(struct afu *afu, struct afu_cmd *cmd)
 int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 		      res_hndl_t res_hndl_u, u8 mode)
 {
+	struct cxlflash_cfg *cfg = afu->parent;
+	struct device *dev = &cfg->dev->dev;
 	struct afu_cmd *cmd = NULL;
 	int rc = 0;
 	int retry_cnt = 0;
@@ -2035,13 +1764,13 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 
 	mutex_lock(&sync_active);
 retry:
-	cmd = cxlflash_cmd_checkout(afu);
+	cmd = cmd_checkout(afu);
 	if (unlikely(!cmd)) {
 		retry_cnt++;
 		udelay(1000 * retry_cnt);
 		if (retry_cnt < MC_RETRY_CNT)
 			goto retry;
-		pr_err("%s: could not get a free command\n", __func__);
+		dev_err(dev, "%s: could not get a free command\n", __func__);
 		rc = -1;
 		goto out;
 	}
@@ -2064,33 +1793,31 @@ retry:
 	*((u16 *)&cmd->rcb.cdb[2]) = swab16(ctx_hndl_u);
 	*((u32 *)&cmd->rcb.cdb[4]) = swab32(res_hndl_u);
 
-	rc = cxlflash_send_cmd(afu, cmd);
+	rc = send_cmd(afu, cmd);
 	if (unlikely(rc))
 		goto out;
 
-	cxlflash_wait_resp(afu, cmd);
+	wait_resp(afu, cmd);
 
-	/* set on timeout */
+	/* Set on timeout */
 	if (unlikely((cmd->sa.ioasc != 0) ||
 		     (cmd->sa.host_use_b[0] & B_ERROR)))
 		rc = -1;
 out:
 	mutex_unlock(&sync_active);
 	if (cmd)
-		cxlflash_cmd_checkin(cmd);
+		cmd_checkin(cmd);
 	pr_debug("%s: returning rc=%d\n", __func__, rc);
 	return rc;
 }
 
 /**
- * cxlflash_afu_reset() - resets the AFU
- * @cxlflash:	Internal structure associated with the host.
+ * afu_reset() - resets the AFU
+ * @cfg:	Internal structure associated with the host.
  *
- * Return:
- *	0 on success
- *	A failure value from internal services.
+ * Return: 0 on success, -errno on failure
  */
-int cxlflash_afu_reset(struct cxlflash_cfg *cfg)
+static int afu_reset(struct cxlflash_cfg *cfg)
 {
 	int rc = 0;
 	/* Stop the context before the reset. Since the context is
@@ -2106,6 +1833,300 @@ int cxlflash_afu_reset(struct cxlflash_cfg *cfg)
 }
 
 /**
+ * cxlflash_eh_device_reset_handler() - reset a single LUN
+ * @scp:	SCSI command to send.
+ *
+ * Return:
+ *	SUCCESS as defined in scsi/scsi.h
+ *	FAILED as defined in scsi/scsi.h
+ */
+static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
+{
+	int rc = SUCCESS;
+	struct Scsi_Host *host = scp->device->host;
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
+	struct afu *afu = cfg->afu;
+	int rcr = 0;
+
+	pr_debug("%s: (scp=%p) %d/%d/%d/%llu "
+		 "cdb=(%08X-%08X-%08X-%08X)\n", __func__, scp,
+		 host->host_no, scp->device->channel,
+		 scp->device->id, scp->device->lun,
+		 get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
+		 get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
+		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
+		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
+
+	rcr = send_tmf(afu, scp, TMF_LUN_RESET);
+	if (unlikely(rcr))
+		rc = FAILED;
+
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
+	return rc;
+}
+
+/**
+ * cxlflash_eh_host_reset_handler() - reset the host adapter
+ * @scp:	SCSI command from stack identifying host.
+ *
+ * Return:
+ *	SUCCESS as defined in scsi/scsi.h
+ *	FAILED as defined in scsi/scsi.h
+ */
+static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
+{
+	int rc = SUCCESS;
+	int rcr = 0;
+	struct Scsi_Host *host = scp->device->host;
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
+
+	pr_debug("%s: (scp=%p) %d/%d/%d/%llu "
+		 "cdb=(%08X-%08X-%08X-%08X)\n", __func__, scp,
+		 host->host_no, scp->device->channel,
+		 scp->device->id, scp->device->lun,
+		 get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
+		 get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
+		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
+		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
+
+	rcr = afu_reset(cfg);
+	if (rcr == 0)
+		rc = SUCCESS;
+	else
+		rc = FAILED;
+
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
+	return rc;
+}
+
+/**
+ * cxlflash_change_queue_depth() - change the queue depth for the device
+ * @sdev:	SCSI device destined for queue depth change.
+ * @qdepth:	Requested queue depth value to set.
+ *
+ * The requested queue depth is capped to the maximum supported value.
+ *
+ * Return: The actual queue depth set.
+ */
+static int cxlflash_change_queue_depth(struct scsi_device *sdev, int qdepth)
+{
+
+	if (qdepth > CXLFLASH_MAX_CMDS_PER_LUN)
+		qdepth = CXLFLASH_MAX_CMDS_PER_LUN;
+
+	scsi_change_queue_depth(sdev, qdepth);
+	return sdev->queue_depth;
+}
+
+/**
+ * cxlflash_show_port_status() - queries and presents the current port status
+ * @port:	Desired port for status reporting.
+ * @afu:	AFU owning the specified port.
+ * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t cxlflash_show_port_status(u32 port, struct afu *afu, char *buf)
+{
+	char *disp_status;
+	u64 status;
+	u64 *fc_regs;
+
+	if (port > NUM_FC_PORTS)
+		return 0;
+
+	fc_regs = &afu->afu_map->global.fc_regs[port][0];
+	status = readq_be(&fc_regs[FC_MTIP_STATUS / 8]);
+	status &= FC_MTIP_STATUS_MASK;
+
+	if (status == FC_MTIP_STATUS_ONLINE)
+		disp_status = "online";
+	else if (status == FC_MTIP_STATUS_OFFLINE)
+		disp_status = "offline";
+	else
+		disp_status = "unknown";
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n", disp_status);
+}
+
+/**
+ * port0_show() - queries and presents the current status of port 0
+ * @dev:	Generic device associated with the host owning the port.
+ * @attr:	Device attribute representing the port.
+ * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t port0_show(struct device *dev,
+			  struct device_attribute *attr,
+			  char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)shost->hostdata;
+	struct afu *afu = cfg->afu;
+
+	return cxlflash_show_port_status(0, afu, buf);
+}
+
+/**
+ * port1_show() - queries and presents the current status of port 1
+ * @dev:	Generic device associated with the host owning the port.
+ * @attr:	Device attribute representing the port.
+ * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t port1_show(struct device *dev,
+			  struct device_attribute *attr,
+			  char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)shost->hostdata;
+	struct afu *afu = cfg->afu;
+
+	return cxlflash_show_port_status(1, afu, buf);
+}
+
+/**
+ * lun_mode_show() - presents the current LUN mode of the host
+ * @dev:	Generic device associated with the host.
+ * @attr:	Device attribute representing the lun mode.
+ * @buf:	Buffer of length PAGE_SIZE to report back the LUN mode in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t lun_mode_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)shost->hostdata;
+	struct afu *afu = cfg->afu;
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", afu->internal_lun);
+}
+
+/**
+ * lun_mode_store() - sets the LUN mode of the host
+ * @dev:	Generic device associated with the host.
+ * @attr:	Device attribute representing the lun mode.
+ * @buf:	Buffer of length PAGE_SIZE containing the LUN mode in ASCII.
+ * @count:	Length of data resizing in @buf.
+ *
+ * The CXL Flash AFU supports a dummy LUN mode where the external
+ * links and storage are not required. Space on the FPGA is used
+ * to create 1 or 2 small LUNs which are presented to the system
+ * as if they were a normal storage device. This feature is useful
+ * during development and also provides manufacturing with a way
+ * to test the AFU without an actual device.
+ *
+ * 0 = external LUN[s] (default)
+ * 1 = internal LUN (1 x 64K, 512B blocks, id 0)
+ * 2 = internal LUN (1 x 64K, 4K blocks, id 0)
+ * 3 = internal LUN (2 x 32K, 512B blocks, ids 0,1)
+ * 4 = internal LUN (2 x 32K, 4K blocks, ids 0,1)
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t lun_mode_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)shost->hostdata;
+	struct afu *afu = cfg->afu;
+	int rc;
+	u32 lun_mode;
+
+	rc = kstrtouint(buf, 10, &lun_mode);
+	if (!rc && (lun_mode < 5) && (lun_mode != afu->internal_lun)) {
+		afu->internal_lun = lun_mode;
+		afu_reset(cfg);
+		scsi_scan_host(cfg->host);
+	}
+
+	return count;
+}
+
+/**
+ * mode_show() - presents the current mode of the device
+ * @dev:	Generic device associated with the device.
+ * @attr:	Device attribute representing the device mode.
+ * @buf:	Buffer of length PAGE_SIZE to report back the dev mode in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t mode_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n",
+			 sdev->hostdata ? "superpipe" : "legacy");
+}
+
+/*
+ * Host attributes
+ */
+static DEVICE_ATTR_RO(port0);
+static DEVICE_ATTR_RO(port1);
+static DEVICE_ATTR_RW(lun_mode);
+
+static struct device_attribute *cxlflash_host_attrs[] = {
+	&dev_attr_port0,
+	&dev_attr_port1,
+	&dev_attr_lun_mode,
+	NULL
+};
+
+/*
+ * Device attributes
+ */
+static DEVICE_ATTR_RO(mode);
+
+static struct device_attribute *cxlflash_dev_attrs[] = {
+	&dev_attr_mode,
+	NULL
+};
+
+/*
+ * Host template
+ */
+static struct scsi_host_template driver_template = {
+	.module = THIS_MODULE,
+	.name = CXLFLASH_ADAPTER_NAME,
+	.info = cxlflash_driver_info,
+	.proc_name = CXLFLASH_NAME,
+	.queuecommand = cxlflash_queuecommand,
+	.eh_device_reset_handler = cxlflash_eh_device_reset_handler,
+	.eh_host_reset_handler = cxlflash_eh_host_reset_handler,
+	.change_queue_depth = cxlflash_change_queue_depth,
+	.cmd_per_lun = 16,
+	.can_queue = CXLFLASH_MAX_CMDS,
+	.this_id = -1,
+	.sg_tablesize = SG_NONE,	/* No scatter gather support */
+	.max_sectors = CXLFLASH_MAX_SECTORS,
+	.use_clustering = ENABLE_CLUSTERING,
+	.shost_attrs = cxlflash_host_attrs,
+	.sdev_attrs = cxlflash_dev_attrs,
+};
+
+/*
+ * Device dependent values
+ */
+static struct dev_dependent_vals dev_corsa_vals = { CXLFLASH_MAX_SECTORS };
+
+/*
+ * PCI device binding table
+ */
+static struct pci_device_id cxlflash_pci_table[] = {
+	{PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CORSA,
+	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, (kernel_ulong_t)&dev_corsa_vals},
+	{}
+};
+
+MODULE_DEVICE_TABLE(pci, cxlflash_pci_table);
+
+/**
  * cxlflash_worker_thread() - work thread handler for the AFU
  * @work:	Work structure contained within cxlflash associated with host.
  *
@@ -2113,12 +2134,14 @@ int cxlflash_afu_reset(struct cxlflash_cfg *cfg)
  * - Link reset which cannot be performed on interrupt context due to
  * blocking up to a few seconds
  * - Read AFU command room
+ * - Rescan the host
  */
 static void cxlflash_worker_thread(struct work_struct *work)
 {
-	struct cxlflash_cfg *cfg =
-	    container_of(work, struct cxlflash_cfg, work_q);
+	struct cxlflash_cfg *cfg = container_of(work, struct cxlflash_cfg,
+						work_q);
 	struct afu *afu = cfg->afu;
+	struct device *dev = &cfg->dev->dev;
 	int port;
 	ulong lock_flags;
 
@@ -2127,7 +2150,8 @@ static void cxlflash_worker_thread(struct work_struct *work)
 	if (cfg->lr_state == LINK_RESET_REQUIRED) {
 		port = cfg->lr_port;
 		if (port < 0)
-			pr_err("%s: invalid port index %d\n", __func__, port);
+			dev_err(dev, "%s: invalid port index %d\n",
+				__func__, port);
 		else {
 			spin_unlock_irqrestore(cfg->host->host_lock,
 					       lock_flags);
@@ -2148,6 +2172,9 @@ static void cxlflash_worker_thread(struct work_struct *work)
 	}
 
 	spin_unlock_irqrestore(cfg->host->host_lock, lock_flags);
+
+	if (atomic_dec_if_positive(&cfg->scan_host_needed) >= 0)
+		scsi_scan_host(cfg->host);
 }
 
 /**
@@ -2155,7 +2182,7 @@ static void cxlflash_worker_thread(struct work_struct *work)
  * @pdev:	PCI device associated with the host.
  * @dev_id:	PCI device id associated with device.
  *
- * Return: 0 on success / non-zero on failure
+ * Return: 0 on success, -errno on failure
  */
 static int cxlflash_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *dev_id)
@@ -2193,14 +2220,14 @@ static int cxlflash_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "%s: call to scsi_host_alloc failed!\n",
 			__func__);
 		rc = -ENOMEM;
+		scsi_host_put(cfg->host);
 		goto out;
 	}
 
 	cfg->init_state = INIT_STATE_NONE;
 	cfg->dev = pdev;
 	cfg->dev_id = (struct pci_device_id *)dev_id;
-	cfg->mcctx = NULL;
-	cfg->err_recovery_active = 0;
+
 
 	init_waitqueue_head(&cfg->tmf_waitq);
 	init_waitqueue_head(&cfg->eeh_waitq);
@@ -2211,13 +2238,14 @@ static int cxlflash_probe(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, cfg);
 
-	/* Use the special service provided to look up the physical
+	/*
+	 * Use the special service provided to look up the physical
 	 * PCI device, since we are called on the probe of the virtual
 	 * PCI host bus (vphb)
 	 */
 	phys_dev = cxl_get_phys_dev(pdev);
 	if (!dev_is_pci(phys_dev)) {
-		pr_err("%s: not a pci dev\n", __func__);
+		dev_err(&pdev->dev, "%s: not a pci dev\n", __func__);
 		rc = -ENODEV;
 		goto out_remove;
 	}
@@ -2241,7 +2269,6 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	}
 	cfg->init_state = INIT_STATE_AFU;
 
-
 	rc = init_scsi(cfg);
 	if (rc) {
 		dev_err(&pdev->dev, "%s: call to init_scsi "
@@ -2272,7 +2299,7 @@ static struct pci_driver cxlflash_driver = {
 /**
  * init_cxlflash() - module entry point
  *
- * Return: 0 on success / non-zero on failure
+ * Return: 0 on success, -errno on failure
  */
 static int __init init_cxlflash(void)
 {
diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
index 7f890cc..7d728ef 100644
--- a/drivers/scsi/cxlflash/main.h
+++ b/drivers/scsi/cxlflash/main.h
@@ -99,6 +99,7 @@ struct asyc_intr_info {
 	u8 action;
 #define CLR_FC_ERROR	0x01
 #define LINK_RESET	0x02
+#define SCAN_HOST	0x04
 };
 
 #endif /* _CXLFLASH_MAIN_H */
diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
index bf5d399..deee5e7 100644
--- a/drivers/scsi/cxlflash/sislite.h
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -146,7 +146,7 @@ struct sisl_rc {
 #define SISL_FC_RC_ABORTFAIL	0x59	/* pending abort completed w/fail */
 #define SISL_FC_RC_RESID	0x5A	/* ioasa underrun/overrun flags set */
 #define SISL_FC_RC_RESIDERR	0x5B	/* actual data len does not match SCSI
-					   reported len, possbly due to dropped
+					   reported len, possibly due to dropped
 					   frames */
 #define SISL_FC_RC_TGTABORT	0x5C	/* command aborted by target */
 };
@@ -258,7 +258,7 @@ struct sisl_host_map {
 	__be64 rrq_start;	/* start & end are both inclusive */
 	__be64 rrq_end;		/* write sequence: start followed by end */
 	__be64 cmd_room;
-	__be64 ctx_ctrl;	/* least signiifcant byte or b56:63 is LISN# */
+	__be64 ctx_ctrl;	/* least significant byte or b56:63 is LISN# */
 	__be64 mbox_w;		/* restricted use */
 };
 
@@ -290,7 +290,7 @@ struct sisl_global_regs {
 #define SISL_ASTATUS_FC0_LOGO    0x4000ULL /* b49, target sent FLOGI/PLOGI/LOGO
 						   while logged in */
 #define SISL_ASTATUS_FC0_CRC_T   0x2000ULL /* b50, CRC threshold exceeded */
-#define SISL_ASTATUS_FC0_LOGI_R  0x1000ULL /* b51, login state mechine timed out
+#define SISL_ASTATUS_FC0_LOGI_R  0x1000ULL /* b51, login state machine timed out
 						   and retrying */
 #define SISL_ASTATUS_FC0_LOGI_F  0x0800ULL /* b52, login failed,
 					      FC_ERROR[19:0] */
-- 
2.1.0

