From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 10/37] cxlflash: Make functions static
Date: Wed, 21 Oct 2015 15:12:10 -0500
Message-ID: <1445458330-10736-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:40778 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbbJUUNf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:13:35 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 14:13:34 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id BB41C1FF0021
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 14:01:41 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKCAVB11600382
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 13:12:10 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKDSMT016689
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 14:13:29 -0600
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

Found during code inspection, that the following functions are not
being used outside of the file where they are defined. Make them static.

int cxlflash_send_cmd(struct afu *, struct afu_cmd *);
void cxlflash_wait_resp(struct afu *, struct afu_cmd *);
int cxlflash_afu_reset(struct cxlflash_cfg *);
struct afu_cmd *cxlflash_cmd_checkout(struct afu *);
void cxlflash_cmd_checkin(struct afu_cmd *);
void init_pcr(struct cxlflash_cfg *);
int init_global(struct cxlflash_cfg *);

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/cxlflash/common.h |    5 -
 drivers/scsi/cxlflash/main.c   | 1018 ++++++++++++++++++++--------------------
 2 files changed, 509 insertions(+), 514 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 11318de..b038ac7 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -192,11 +192,6 @@ static inline u64 lun_to_lunid(u64 lun)
 	return swab64(lun_id);
 }
 
-int cxlflash_send_cmd(struct afu *, struct afu_cmd *);
-void cxlflash_wait_resp(struct afu *, struct afu_cmd *);
-int cxlflash_afu_reset(struct cxlflash_cfg *);
-struct afu_cmd *cxlflash_cmd_checkout(struct afu *);
-void cxlflash_cmd_checkin(struct afu_cmd *);
 int cxlflash_afu_sync(struct afu *, ctx_hndl_t, res_hndl_t, u8);
 void cxlflash_list_init(void);
 void cxlflash_term_global_luns(void);
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 8940336..226cefe 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -36,7 +36,7 @@ MODULE_LICENSE("GPL");
 
 
 /**
- * cxlflash_cmd_checkout() - checks out an AFU command
+ * cmd_checkout() - checks out an AFU command
  * @afu:	AFU to checkout from.
  *
  * Commands are checked out in a round-robin fashion. Note that since
@@ -47,7 +47,7 @@ MODULE_LICENSE("GPL");
  *
  * Return: The checked out command or NULL when command pool is empty.
  */
-struct afu_cmd *cxlflash_cmd_checkout(struct afu *afu)
+static struct afu_cmd *cmd_checkout(struct afu *afu)
 {
 	int k, dec = CXLFLASH_NUM_CMDS;
 	struct afu_cmd *cmd;
@@ -70,7 +70,7 @@ struct afu_cmd *cxlflash_cmd_checkout(struct afu *afu)
 }
 
 /**
- * cxlflash_cmd_checkin() - checks in an AFU command
+ * cmd_checkin() - checks in an AFU command
  * @cmd:	AFU command to checkin.
  *
  * Safe to pass commands that have already been checked in. Several
@@ -79,7 +79,7 @@ struct afu_cmd *cxlflash_cmd_checkout(struct afu *afu)
  * to avoid clobbering values in the event that the command is checked
  * out right away.
  */
-void cxlflash_cmd_checkin(struct afu_cmd *cmd)
+static void cmd_checkin(struct afu_cmd *cmd)
 {
 	cmd->rcb.scp = NULL;
 	cmd->rcb.timeout = 0;
@@ -238,7 +238,7 @@ static void cmd_complete(struct afu_cmd *cmd)
 
 		resid = cmd->sa.resid;
 		cmd_is_tmf = cmd->cmd_tmf;
-		cxlflash_cmd_checkin(cmd); /* Don't use cmd after here */
+		cmd_checkin(cmd); /* Don't use cmd after here */
 
 		pr_debug("%s: calling scsi_set_resid, scp=%p "
 			 "result=%X resid=%d\n", __func__,
@@ -260,6 +260,146 @@ static void cmd_complete(struct afu_cmd *cmd)
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
@@ -280,7 +420,7 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	ulong lock_flags;
 	int rc = 0;
 
-	cmd = cxlflash_cmd_checkout(afu);
+	cmd = cmd_checkout(afu);
 	if (unlikely(!cmd)) {
 		pr_err("%s: could not get a free command\n", __func__);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
@@ -313,9 +453,9 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	memcpy(cmd->rcb.cdb, &tmfcmd, sizeof(tmfcmd));
 
 	/* Send the command */
-	rc = cxlflash_send_cmd(afu, cmd);
+	rc = send_cmd(afu, cmd);
 	if (unlikely(rc)) {
-		cxlflash_cmd_checkin(cmd);
+		cmd_checkin(cmd);
 		spin_lock_irqsave(&cfg->tmf_waitq.lock, lock_flags);
 		cfg->tmf_active = false;
 		spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
@@ -398,7 +538,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 		break;
 	}
 
-	cmd = cxlflash_cmd_checkout(afu);
+	cmd = cmd_checkout(afu);
 	if (unlikely(!cmd)) {
 		pr_err("%s: could not get a free command\n", __func__);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
@@ -438,9 +578,9 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	memcpy(cmd->rcb.cdb, scp->cmnd, sizeof(cmd->rcb.cdb));
 
 	/* Send the command */
-	rc = cxlflash_send_cmd(afu, cmd);
+	rc = send_cmd(afu, cmd);
 	if (unlikely(rc)) {
-		cxlflash_cmd_checkin(cmd);
+		cmd_checkin(cmd);
 		scsi_dma_unmap(scp);
 	}
 
@@ -449,369 +589,55 @@ out:
 }
 
 /**
- * cxlflash_eh_device_reset_handler() - reset a single LUN
- * @scp:	SCSI command to send.
- *
- * Return:
- *	SUCCESS as defined in scsi/scsi.h
- *	FAILED as defined in scsi/scsi.h
+ * cxlflash_wait_for_pci_err_recovery() - wait for error recovery during probe
+ * @cxlflash:	Internal structure associated with the host.
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
-	switch (cfg->state) {
-	case STATE_NORMAL:
-		rcr = send_tmf(afu, scp, TMF_LUN_RESET);
-		if (unlikely(rcr))
-			rc = FAILED;
-		break;
-	case STATE_RESET:
-		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
-		if (cfg->state == STATE_NORMAL)
-			break;
-		/* fall through */
-	default:
-		rc = FAILED;
-		break;
-	}
+	struct pci_dev *pdev = cfg->dev;
 
-	pr_debug("%s: returning rc=%d\n", __func__, rc);
-	return rc;
+	if (pci_channel_offline(pdev))
+		wait_event_timeout(cfg->reset_waitq,
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
+ * @cxlflash:	Internal structure associated with the host.
  */
-static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
+static void free_mem(struct cxlflash_cfg *cfg)
 {
-	int rc = SUCCESS;
-	int rcr = 0;
-	struct Scsi_Host *host = scp->device->host;
-	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
+	int i;
+	char *buf = NULL;
+	struct afu *afu = cfg->afu;
 
-	pr_debug("%s: (scp=%p) %d/%d/%d/%llu "
-		 "cdb=(%08X-%08X-%08X-%08X)\n", __func__, scp,
-		 host->host_no, scp->device->channel,
-		 scp->device->id, scp->device->lun,
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
+	if (cfg->afu) {
+		for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
+			buf = afu->cmd[i].buf;
+			if (!((u64)buf & (PAGE_SIZE - 1)))
+				free_page((ulong)buf);
+		}
 
-	switch (cfg->state) {
-	case STATE_NORMAL:
-		cfg->state = STATE_RESET;
-		scsi_block_requests(cfg->host);
-		cxlflash_mark_contexts_error(cfg);
-		rcr = cxlflash_afu_reset(cfg);
-		if (rcr) {
-			rc = FAILED;
-			cfg->state = STATE_FAILTERM;
-		} else
-			cfg->state = STATE_NORMAL;
-		wake_up_all(&cfg->reset_waitq);
-		scsi_unblock_requests(cfg->host);
-		break;
-	case STATE_RESET:
-		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
-		if (cfg->state == STATE_NORMAL)
-			break;
-		/* fall through */
-	default:
-		rc = FAILED;
-		break;
+		free_pages((ulong)afu, get_order(sizeof(struct afu)));
+		cfg->afu = NULL;
 	}
-
-	pr_debug("%s: returning rc=%d\n", __func__, rc);
-	return rc;
 }
 
 /**
- * cxlflash_change_queue_depth() - change the queue depth for the device
- * @sdev:	SCSI device destined for queue depth change.
- * @qdepth:	Requested queue depth value to set.
- *
- * The requested queue depth is capped to the maximum supported value.
+ * stop_afu() - stops the AFU command timers and unmaps the MMIO space
+ * @cxlflash:	Internal structure associated with the host.
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
-
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
-	if (rc || (port >= NUM_FC_PORTS))
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
- * cxlflash_show_ioctl_version() - presents the current ioctl version of the host
- * @dev:	Generic device associated with the host.
- * @attr:	Device attribute representing the ioctl version.
- * @buf:	Buffer of length PAGE_SIZE to report back the ioctl version.
- *
- * Return: The size of the ASCII string returned in @buf.
- */
-static ssize_t cxlflash_show_ioctl_version(struct device *dev,
-					   struct device_attribute *attr,
-					   char *buf)
-{
-	return scnprintf(buf, PAGE_SIZE, "%u\n", DK_CXLFLASH_VERSION_0);
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
-		wait_event_timeout(cfg->reset_waitq,
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
-static DEVICE_ATTR(ioctl_version, S_IRUGO, cxlflash_show_ioctl_version, NULL);
-
-static struct device_attribute *cxlflash_host_attrs[] = {
-	&dev_attr_port0,
-	&dev_attr_port1,
-	&dev_attr_lun_mode,
-	&dev_attr_ioctl_version,
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
-	.ioctl = cxlflash_ioctl,
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
+	if (likely(afu)) {
+		for (i = 0; i < CXLFLASH_NUM_CMDS; i++)
+			complete(&afu->cmd[i].cevent);
 
 		if (likely(afu->afu_map)) {
 			cxl_psa_unmap((void *)afu->afu_map);
@@ -1631,67 +1457,13 @@ out:
 }
 
 /**
- * cxlflash_context_reset() - timeout handler for AFU commands
- * @cmd:	AFU command that timed out.
+ * init_pcr() - initialize the provisioning and control registers
+ * @cxlflash:	Internal structure associated with the host.
  *
- * Sends a reset to the AFU.
+ * Also sets up fast access to the mapped registers and initializes AFU
+ * command fields that never change.
  */
-void cxlflash_context_reset(struct afu_cmd *cmd)
-{
-	int nretry = 0;
-	u64 rrin = 0x1;
-	u64 room = 0;
-	struct afu *afu = cmd->parent;
-	ulong lock_flags;
-
-	pr_debug("%s: cmd=%p\n", __func__, cmd);
-
-	spin_lock_irqsave(&cmd->slock, lock_flags);
-
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
+static void init_pcr(struct cxlflash_cfg *cfg)
 {
 	struct afu *afu = cfg->afu;
 	struct sisl_ctrl_map *ctrl_map;
@@ -1727,7 +1499,7 @@ void init_pcr(struct cxlflash_cfg *cfg)
  * init_global() - initialize AFU global registers
  * @cxlflash:	Internal structure associated with the host.
  */
-int init_global(struct cxlflash_cfg *cfg)
+static int init_global(struct cxlflash_cfg *cfg)
 {
 	struct afu *afu = cfg->afu;
 	u64 wwpn[NUM_FC_PORTS];	/* wwpn of AFU ports */
@@ -1998,92 +1770,6 @@ err1:
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
@@ -2121,7 +1807,7 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 
 	mutex_lock(&sync_active);
 retry:
-	cmd = cxlflash_cmd_checkout(afu);
+	cmd = cmd_checkout(afu);
 	if (unlikely(!cmd)) {
 		retry_cnt++;
 		udelay(1000 * retry_cnt);
@@ -2150,11 +1836,11 @@ retry:
 	*((u16 *)&cmd->rcb.cdb[2]) = swab16(ctx_hndl_u);
 	*((u32 *)&cmd->rcb.cdb[4]) = swab32(res_hndl_u);
 
-	rc = cxlflash_send_cmd(afu, cmd);
+	rc = send_cmd(afu, cmd);
 	if (unlikely(rc))
 		goto out;
 
-	cxlflash_wait_resp(afu, cmd);
+	wait_resp(afu, cmd);
 
 	/* set on timeout */
 	if (unlikely((cmd->sa.ioasc != 0) ||
@@ -2163,20 +1849,20 @@ retry:
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
  * Return:
  *	0 on success
  *	A failure value from internal services.
  */
-int cxlflash_afu_reset(struct cxlflash_cfg *cfg)
+static int afu_reset(struct cxlflash_cfg *cfg)
 {
 	int rc = 0;
 	/* Stop the context before the reset. Since the context is
@@ -2192,6 +1878,320 @@ int cxlflash_afu_reset(struct cxlflash_cfg *cfg)
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
+	switch (cfg->state) {
+	case STATE_NORMAL:
+		rcr = send_tmf(afu, scp, TMF_LUN_RESET);
+		if (unlikely(rcr))
+			rc = FAILED;
+		break;
+	case STATE_RESET:
+		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
+		if (cfg->state == STATE_NORMAL)
+			break;
+		/* fall through */
+	default:
+		rc = FAILED;
+		break;
+	}
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
+	switch (cfg->state) {
+	case STATE_NORMAL:
+		cfg->state = STATE_RESET;
+		scsi_block_requests(cfg->host);
+		cxlflash_mark_contexts_error(cfg);
+		rcr = afu_reset(cfg);
+		if (rcr) {
+			rc = FAILED;
+			cfg->state = STATE_FAILTERM;
+		} else
+			cfg->state = STATE_NORMAL;
+		wake_up_all(&cfg->reset_waitq);
+		scsi_unblock_requests(cfg->host);
+		break;
+	case STATE_RESET:
+		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
+		if (cfg->state == STATE_NORMAL)
+			break;
+		/* fall through */
+	default:
+		rc = FAILED;
+		break;
+	}
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
+ * @dev:	Generic device associated with the host owning the port.
+ * @attr:	Device attribute representing the port.
+ * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t cxlflash_show_port_status(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)shost->hostdata;
+	struct afu *afu = cfg->afu;
+
+	char *disp_status;
+	int rc;
+	u32 port;
+	u64 status;
+	u64 *fc_regs;
+
+	rc = kstrtouint((attr->attr.name + 4), 10, &port);
+	if (rc || (port >= NUM_FC_PORTS))
+		return 0;
+
+	fc_regs = &afu->afu_map->global.fc_regs[port][0];
+	status =
+	    (readq_be(&fc_regs[FC_MTIP_STATUS / 8]) & FC_MTIP_STATUS_MASK);
+
+	if (status == FC_MTIP_STATUS_ONLINE)
+		disp_status = "online";
+	else if (status == FC_MTIP_STATUS_OFFLINE)
+		disp_status = "offline";
+	else
+		disp_status = "unknown";
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", disp_status);
+}
+
+/**
+ * cxlflash_show_lun_mode() - presents the current LUN mode of the host
+ * @dev:	Generic device associated with the host.
+ * @attr:	Device attribute representing the lun mode.
+ * @buf:	Buffer of length PAGE_SIZE to report back the LUN mode in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t cxlflash_show_lun_mode(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)shost->hostdata;
+	struct afu *afu = cfg->afu;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", afu->internal_lun);
+}
+
+/**
+ * cxlflash_store_lun_mode() - sets the LUN mode of the host
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
+static ssize_t cxlflash_store_lun_mode(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
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
+ * cxlflash_show_ioctl_version() - presents the hosts current ioctl version
+ * @dev:	Generic device associated with the host.
+ * @attr:	Device attribute representing the ioctl version.
+ * @buf:	Buffer of length PAGE_SIZE to report back the ioctl version.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t cxlflash_show_ioctl_version(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%u\n", DK_CXLFLASH_VERSION_0);
+}
+
+/**
+ * cxlflash_show_dev_mode() - presents the current mode of the device
+ * @dev:	Generic device associated with the device.
+ * @attr:	Device attribute representing the device mode.
+ * @buf:	Buffer of length PAGE_SIZE to report back the dev mode in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t cxlflash_show_dev_mode(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+			sdev->hostdata ? "superpipe" : "legacy");
+}
+
+/*
+ * Host attributes
+ */
+static DEVICE_ATTR(port0, S_IRUGO, cxlflash_show_port_status, NULL);
+static DEVICE_ATTR(port1, S_IRUGO, cxlflash_show_port_status, NULL);
+static DEVICE_ATTR(lun_mode, S_IRUGO | S_IWUSR, cxlflash_show_lun_mode,
+		   cxlflash_store_lun_mode);
+static DEVICE_ATTR(ioctl_version, S_IRUGO, cxlflash_show_ioctl_version, NULL);
+
+static struct device_attribute *cxlflash_host_attrs[] = {
+	&dev_attr_port0,
+	&dev_attr_port1,
+	&dev_attr_lun_mode,
+	&dev_attr_ioctl_version,
+	NULL
+};
+
+/*
+ * Device attributes
+ */
+static DEVICE_ATTR(mode, S_IRUGO, cxlflash_show_dev_mode, NULL);
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
+	.ioctl = cxlflash_ioctl,
+	.proc_name = CXLFLASH_NAME,
+	.queuecommand = cxlflash_queuecommand,
+	.eh_device_reset_handler = cxlflash_eh_device_reset_handler,
+	.eh_host_reset_handler = cxlflash_eh_host_reset_handler,
+	.change_queue_depth = cxlflash_change_queue_depth,
+	.cmd_per_lun = 16,
+	.can_queue = CXLFLASH_MAX_CMDS,
+	.this_id = -1,
+	.sg_tablesize = SG_NONE,	/* No scatter gather support. */
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
-- 
2.1.0

