Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 707C2C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Apr 2022 17:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240067AbiDJRjc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Apr 2022 13:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240052AbiDJRjR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Apr 2022 13:39:17 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E51328E21
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 10:37:02 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 83F422041BB;
        Sun, 10 Apr 2022 19:37:01 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gqWjptU-f8OI; Sun, 10 Apr 2022 19:36:57 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        by smtp.infotech.no (Postfix) with ESMTPA id D9B8F2041B2;
        Sun, 10 Apr 2022 19:36:56 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, hch@lst.de
Subject: [PATCH v2 1/6] scsi_cmnd: reinstate support for cmd_len > 32
Date:   Sun, 10 Apr 2022 13:36:47 -0400
Message-Id: <20220410173652.313016-2-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220410173652.313016-1-dgilbert@interlog.com>
References: <20220410173652.313016-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A patch titled "scsi: core: Remove the cmd field from struct
scsi_request" [ce70fd9a551af] limited the size of a SCSI
CDB (command descriptor block) to 32 bytes. While this covers
the current requirements of the sd driver, OSD users and
those sending long vendor specific cdb_s via the sg or bsg
drivers will be disappointed by this regression.

This patch adds back that support without increasing the size
of the newly renovated struct scsi_cmnd. Three accessor functions
are added to encourage kernel coders not to access
scsi_cmnd::cmnd[] directly. The fix is performed by a union with
some defensive code (i.e. a relatively harmless Test Unit Ready
SCSI command) if that union is incorrectly accessed.

If the SCSI_MAX_COMPILE_TIME_CDB_LEN define is set to 16 as
proposed by one reviewer (rather than 32 in the first revision),
then struct scsi_cmnd will 16 bytes shorter than before.

The end of include/scsi/scsi_cmnd.h contains the declaration for
the construction of a scsi_cmnd sub-object. It is a "sub-object"
because what is actually constructed is a struct request object
with the scsi_cmnd sub-object tacked onto the end of it. In a
similar fashion add an inline function for the destruction of a
scsi_cmnd sub-object (and the struct request object that
precedes it).

Various files in the scsi mid-level that used scsi_cmnd::cmnd
directly are modified to use the new accessor functions. Also
use scsi_free_cmnd() where appropriate.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debugfs.c |   3 +-
 drivers/scsi/scsi_error.c   |  76 ++++++++++++++---------
 drivers/scsi/scsi_ioctl.c   |  21 ++++---
 drivers/scsi/scsi_lib.c     |  75 +++++++++++++++++++----
 drivers/scsi/scsi_logging.c |  11 ++--
 include/scsi/scsi_cmnd.h    | 116 +++++++++++++++++++++++++++++++-----
 include/scsi/scsi_eh.h      |   6 +-
 7 files changed, 240 insertions(+), 68 deletions(-)

diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index 217b70c678c3..6fe9507c0ecb 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -10,6 +10,7 @@ static const char *const scsi_cmd_flags[] = {
 	SCSI_CMD_FLAG_NAME(TAGGED),
 	SCSI_CMD_FLAG_NAME(INITIALIZED),
 	SCSI_CMD_FLAG_NAME(LAST),
+	SCSI_CMD_FLAG_NAME(LONG_CDB),
 };
 #undef SCSI_CMD_FLAG_NAME
 
@@ -38,7 +39,7 @@ void scsi_show_rq(struct seq_file *m, struct request *rq)
 	int timeout_ms = jiffies_to_msecs(rq->timeout);
 	char buf[80] = "(?)";
 
-	__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
+	__scsi_format_command(buf, sizeof(buf), scsi_cmnd_get_cdb(cmd), cmd->cmd_len);
 	seq_printf(m, ", .cmd=%s, .retries=%d, .result = %#x, .flags=", buf,
 		   cmd->retries, cmd->result);
 	scsi_flags_show(m, cmd->flags, scsi_cmd_flags,
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index cdaca13ac1f1..6fe0aeaf8837 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -530,6 +530,7 @@ static void scsi_report_sense(struct scsi_device *sdev,
 enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 {
 	struct scsi_device *sdev = scmd->device;
+	const u8 *cdb = scsi_cmnd_get_cdb(scmd);
 	struct scsi_sense_hdr sshdr;
 
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
@@ -549,7 +550,7 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		/* handler does not care. Drop down to default handling */
 	}
 
-	if (scmd->cmnd[0] == TEST_UNIT_READY &&
+	if (cdb[0] == TEST_UNIT_READY &&
 	    scmd->submitter != SUBMITTED_BY_SCSI_ERROR_HANDLER)
 		/*
 		 * nasty: for mid-layer issued TURs, we need to return the
@@ -755,6 +756,8 @@ static void scsi_handle_queue_full(struct scsi_device *sdev)
  */
 static enum scsi_disposition scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 {
+	const u8 *cdb = scsi_cmnd_get_cdb(scmd);
+
 	/*
 	 * first check the host byte, to see if there is anything in there
 	 * that would indicate what we need to do.
@@ -791,7 +794,7 @@ static enum scsi_disposition scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 		 */
 		return SUCCESS;
 	case SAM_STAT_RESERVATION_CONFLICT:
-		if (scmd->cmnd[0] == TEST_UNIT_READY)
+		if (cdb[0] == TEST_UNIT_READY)
 			/* it is a success, we probed the device and
 			 * found it */
 			return SUCCESS;
@@ -985,7 +988,7 @@ static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
  * @scmd:       SCSI command structure to hijack
  * @ses:        structure to save restore information
  * @cmnd:       CDB to send. Can be NULL if no new cmnd is needed
- * @cmnd_size:  size in bytes of @cmnd (must be <= MAX_COMMAND_SIZE)
+ * @cmnd_size:  size in bytes of @cmnd (must be <= SCSI_MAX_COMPILE_TIME_CDB_LEN)
  * @sense_bytes: size of sense data to copy. or 0 (if != 0 @cmnd is ignored)
  *
  * This function is used to save a scsi command information before re-execution
@@ -998,6 +1001,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 			unsigned char *cmnd, int cmnd_size, unsigned sense_bytes)
 {
 	struct scsi_device *sdev = scmd->device;
+	u8 *cdb;
 
 	/*
 	 * We need saved copies of a number of fields - this is because
@@ -1013,12 +1017,21 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	ses->resid_len = scmd->resid_len;
 	ses->underflow = scmd->underflow;
 	ses->prot_op = scmd->prot_op;
+	ses->flags = scmd->flags;
 	ses->eh_eflags = scmd->eh_eflags;
 
+	if (unlikely(scmd->flags & SCMD_LONG_CDB)) {
+		ses->l_cdb.cdbp = scmd->l_cdb.cdbp;
+		scmd->l_cdb.cdbp = NULL;
+		ses->l_cdb.dummy_tur = 0;
+		scmd->flags &= ~SCMD_LONG_CDB;
+	} else {
+		memcpy(ses->cmnd, scmd->cmnd, scmd->cmd_len);
+		memset(scmd->cmnd, 0, scmd->cmd_len);
+	}
+	cdb = scmd->cmnd;
 	scmd->prot_op = SCSI_PROT_NORMAL;
 	scmd->eh_eflags = 0;
-	memcpy(ses->cmnd, scmd->cmnd, sizeof(ses->cmnd));
-	memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 	scmd->result = 0;
 	scmd->resid_len = 0;
@@ -1031,23 +1044,22 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 		scmd->sdb.table.sgl = &ses->sense_sgl;
 		scmd->sc_data_direction = DMA_FROM_DEVICE;
 		scmd->sdb.table.nents = scmd->sdb.table.orig_nents = 1;
-		scmd->cmnd[0] = REQUEST_SENSE;
-		scmd->cmnd[4] = scmd->sdb.length;
-		scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
+		scmd->cmd_len = 6;	/* bytes in REQUEST SENSE command */
+		cdb[0] = REQUEST_SENSE;
+		cdb[4] = scmd->sdb.length;
 	} else {
 		scmd->sc_data_direction = DMA_NONE;
 		if (cmnd) {
-			BUG_ON(cmnd_size > sizeof(scmd->cmnd));
-			memcpy(scmd->cmnd, cmnd, cmnd_size);
-			scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
+			BUG_ON(cmnd_size > SCSI_MAX_RUN_TIME_CDB_LEN);
+			scmd->cmd_len = (cmnd_size > 0) ? cmnd_size : COMMAND_SIZE(cmnd[0]);
+			cdb = scsi_cmnd_set_cdb(scmd, cmnd, scmd->cmd_len);
 		}
 	}
 
 	scmd->underflow = 0;
 
 	if (sdev->scsi_level <= SCSI_2 && sdev->scsi_level != SCSI_UNKNOWN)
-		scmd->cmnd[1] = (scmd->cmnd[1] & 0x1f) |
-			(sdev->lun << 5 & 0xe0);
+		cdb[1] = (cdb[1] & 0x1f) | (sdev->lun << 5 & 0xe0);
 
 	/*
 	 * Zero the sense buffer.  The scsi spec mandates that any
@@ -1069,8 +1081,19 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	/*
 	 * Restore original data
 	 */
+	if (unlikely(scmd->flags & SCMD_LONG_CDB))
+		kfree(scmd->l_cdb.cdbp);
 	scmd->cmd_len = ses->cmd_len;
-	memcpy(scmd->cmnd, ses->cmnd, sizeof(ses->cmnd));
+	scmd->flags = ses->flags;
+	if (unlikely(ses->flags & SCMD_LONG_CDB)) {
+		scmd->l_cdb.cdbp = ses->l_cdb.cdbp;
+		ses->l_cdb.cdbp = NULL;
+		scmd->l_cdb.dummy_tur = 0;
+		ses->flags &= ~SCMD_LONG_CDB;
+	} else {
+		memcpy(scmd->cmnd, ses->cmnd, ses->cmd_len);
+		memset(ses->cmnd, 0, ses->cmd_len);
+	}
 	scmd->sc_data_direction = ses->data_direction;
 	scmd->sdb = ses->sdb;
 	scmd->result = ses->result;
@@ -1340,13 +1363,12 @@ EXPORT_SYMBOL_GPL(scsi_eh_get_sense);
  */
 static int scsi_eh_tur(struct scsi_cmnd *scmd)
 {
-	static unsigned char tur_command[6] = {TEST_UNIT_READY, 0, 0, 0, 0, 0};
+	static const u8 tur_command[6] = {TEST_UNIT_READY, 0, 0, 0, 0, 0};
 	int retry_cnt = 1;
 	enum scsi_disposition rtn;
 
 retry_tur:
-	rtn = scsi_send_eh_cmnd(scmd, tur_command, 6,
-				scmd->device->eh_timeout, 0);
+	rtn = scsi_send_eh_cmnd(scmd, (u8 *)tur_command, 6, scmd->device->eh_timeout, 0);
 
 	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
 		"%s return: %x\n", __func__, rtn));
@@ -1831,6 +1853,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 {
 	enum scsi_disposition rtn;
+	const u8 *cdb = scsi_cmnd_get_cdb(scmd);
 
 	/*
 	 * if the device is offline, then we clearly just pass the result back
@@ -1924,8 +1947,7 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * these commands if there is no device available.
 		 * other hosts report did_no_connect for the same thing.
 		 */
-		if ((scmd->cmnd[0] == TEST_UNIT_READY ||
-		     scmd->cmnd[0] == INQUIRY)) {
+		if (cdb[0] == TEST_UNIT_READY || cdb[0] == INQUIRY) {
 			return SUCCESS;
 		} else {
 			return FAILED;
@@ -1956,7 +1978,7 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 */
 		return ADD_TO_MLQUEUE;
 	case SAM_STAT_GOOD:
-		if (scmd->cmnd[0] == REPORT_LUNS)
+		if (cdb[0] == REPORT_LUNS)
 			scmd->device->sdev_target->expecting_lun_change = 0;
 		scsi_handle_queue_ramp_up(scmd->device);
 		fallthrough;
@@ -2008,7 +2030,7 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 
 static void eh_lock_door_done(struct request *req, blk_status_t status)
 {
-	blk_mq_free_request(req);
+	scsi_free_cmnd(blk_mq_rq_to_pdu(req));
 }
 
 /**
@@ -2026,19 +2048,17 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 {
 	struct scsi_cmnd *scmd;
 	struct request *req;
+	u8 *cdb;
+	static const int amr_cdb_len = 6;
 
 	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, 0);
 	if (IS_ERR(req))
 		return;
 	scmd = blk_mq_rq_to_pdu(req);
 
-	scmd->cmnd[0] = ALLOW_MEDIUM_REMOVAL;
-	scmd->cmnd[1] = 0;
-	scmd->cmnd[2] = 0;
-	scmd->cmnd[3] = 0;
-	scmd->cmnd[4] = SCSI_REMOVAL_PREVENT;
-	scmd->cmnd[5] = 0;
-	scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
+	cdb = scsi_cmnd_set_cdb(scmd, NULL, amr_cdb_len);
+	cdb[0] = ALLOW_MEDIUM_REMOVAL;
+	cdb[4] = SCSI_REMOVAL_PREVENT;
 
 	req->rq_flags |= RQF_QUIET;
 	req->timeout = 10 * HZ;
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index a480c4d589f5..10b6b8a89c15 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -245,7 +245,7 @@ static int scsi_send_start_stop(struct scsi_device *sdev, int data)
  * Only a subset of commands are allowed for unprivileged users. Commands used
  * to format the media, update the firmware, etc. are not permitted.
  */
-bool scsi_cmd_allowed(unsigned char *cmd, fmode_t mode)
+bool scsi_cmd_allowed(/* const */ unsigned char *cmd, fmode_t mode)
 {
 	/* root can do any command. */
 	if (capable(CAP_SYS_RAWIO))
@@ -346,14 +346,15 @@ static int scsi_fill_sghdr_rq(struct scsi_device *sdev, struct request *rq,
 		struct sg_io_hdr *hdr, fmode_t mode)
 {
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
+	u8 *cdb;
 
 	if (hdr->cmd_len < 6)
 		return -EMSGSIZE;
-	if (copy_from_user(scmd->cmnd, hdr->cmdp, hdr->cmd_len))
+	cdb = scsi_cmnd_set_cdb(scmd, NULL, hdr->cmd_len);
+	if (copy_from_user(cdb, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
-	if (!scsi_cmd_allowed(scmd->cmnd, mode))
+	if (unlikely(!scsi_cmd_allowed(cdb, mode)))
 		return -EPERM;
-	scmd->cmd_len = hdr->cmd_len;
 
 	rq->timeout = msecs_to_jiffies(hdr->timeout);
 	if (!rq->timeout)
@@ -440,7 +441,7 @@ static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
 		return PTR_ERR(rq);
 	scmd = blk_mq_rq_to_pdu(rq);
 
-	if (hdr->cmd_len > sizeof(scmd->cmnd)) {
+	if (unlikely(hdr->cmd_len > SCSI_MAX_RUN_TIME_8BIT_CDB_LEN)) {
 		ret = -EINVAL;
 		goto out_put_request;
 	}
@@ -483,7 +484,7 @@ static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
 	ret = scsi_complete_sghdr_rq(rq, hdr, bio);
 
 out_put_request:
-	blk_mq_free_request(rq);
+	scsi_free_cmnd(scmd);
 	return ret;
 }
 
@@ -521,6 +522,7 @@ static int sg_scsi_ioctl(struct request_queue *q, fmode_t mode,
 	int err;
 	unsigned int in_len, out_len, bytes, opcode, cmdlen;
 	struct scsi_cmnd *scmd;
+	u8 *cdb;
 	char *buffer = NULL;
 
 	if (!sic)
@@ -560,14 +562,15 @@ static int sg_scsi_ioctl(struct request_queue *q, fmode_t mode,
 	 */
 	err = -EFAULT;
 	scmd->cmd_len = cmdlen;
-	if (copy_from_user(scmd->cmnd, sic->data, cmdlen))
+	cdb = scsi_cmnd_set_cdb(scmd, NULL, cmdlen);
+	if (copy_from_user(cdb, sic->data, cmdlen))
 		goto error;
 
 	if (in_len && copy_from_user(buffer, sic->data + cmdlen, in_len))
 		goto error;
 
 	err = -EPERM;
-	if (!scsi_cmd_allowed(scmd->cmnd, mode))
+	if (unlikely(!scsi_cmd_allowed(cdb, mode)))
 		goto error;
 
 	/* default.  possible overridden later */
@@ -619,7 +622,7 @@ static int sg_scsi_ioctl(struct request_queue *q, fmode_t mode,
 	}
 
 error:
-	blk_mq_free_request(rq);
+	scsi_free_cmnd(scmd);
 
 error_free_buffer:
 	kfree(buffer);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8d18cc7e510e..e06c5556fa9e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -223,15 +223,18 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
+	scmd = blk_mq_rq_to_pdu(req);
 	if (bufflen) {
 		ret = blk_rq_map_kern(sdev->request_queue, req,
 				      buffer, bufflen, GFP_NOIO);
 		if (ret)
 			goto out;
 	}
-	scmd = blk_mq_rq_to_pdu(req);
 	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
-	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
+	if (unlikely(!scsi_cmnd_set_cdb(scmd, cmd, scmd->cmd_len))) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	scmd->allowed = retries;
 	req->timeout = timeout;
 	req->cmd_flags |= flags;
@@ -260,7 +263,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 				     sshdr);
 	ret = scmd->result;
  out:
-	blk_mq_free_request(req);
+	scsi_free_cmnd(scmd);
 
 	return ret;
 }
@@ -688,6 +691,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 {
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = scsi_cmd_to_rq(cmd);
+	const u8 *cdb = scsi_cmnd_get_cdb(cmd);
 	int level = 0;
 	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
 	      ACTION_DELAYED_RETRY} action;
@@ -737,8 +741,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 			 */
 			if ((cmd->device->use_10_for_rw &&
 			    sshdr.asc == 0x20 && sshdr.ascq == 0x00) &&
-			    (cmd->cmnd[0] == READ_10 ||
-			     cmd->cmnd[0] == WRITE_10)) {
+			    (cdb[0] == READ_10 || cdb[0] == WRITE_10)) {
 				/* This will issue a new 6-byte command. */
 				cmd->device->use_10_for_rw = 0;
 				action = ACTION_REPREP;
@@ -1117,8 +1120,7 @@ static void scsi_initialize_rq(struct request *rq)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
-	memset(cmd->cmnd, 0, sizeof(cmd->cmnd));
-	cmd->cmd_len = MAX_COMMAND_SIZE;
+	scsi_cmnd_set_cdb(cmd, NULL, SCSI_TEST_UNIT_READY_CDB_LEN);
 	cmd->sense_len = 0;
 	init_rcu_head(&cmd->rcu);
 	cmd->jiffies_at_alloc = jiffies;
@@ -1460,6 +1462,7 @@ static void scsi_complete(struct request *rq)
 static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
+	u8 *cdb = scsi_cmnd_get_changeable_cdb(cmd);
 	int rtn = 0;
 
 	atomic_inc(&cmd->device->iorequest_cnt);
@@ -1489,8 +1492,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 
 	/* Store the LUN value in cmnd, if needed. */
 	if (cmd->device->lun_in_cdb)
-		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
-			       (cmd->device->lun << 5 & 0xe0);
+		cdb[1] = (cdb[1] & 0x1f) | (cmd->device->lun << 5 & 0xe0);
 
 	scsi_log_send(cmd);
 
@@ -1600,7 +1602,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 			return ret;
 	}
 
-	memset(cmd->cmnd, 0, sizeof(cmd->cmnd));
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
 
@@ -3314,3 +3315,57 @@ void scsi_build_sense(struct scsi_cmnd *scmd, int desc, u8 key, u8 asc, u8 ascq)
 	scmd->result = SAM_STAT_CHECK_CONDITION;
 }
 EXPORT_SYMBOL_GPL(scsi_build_sense);
+
+/**
+ * __scsi_cmnd_set_cdb - build buffer for SCSI command (cdb) in *scmd
+ * @scmd:	pointer to scsi command for which a CDB is, or will be, set
+ * @cdb:	if non-NULL it is a pointer to start of SCSI CDB that is
+ *              copied into *scmd . If NULL then no copy occurs.
+ * @cdb_len:	number of bytes in SCSI CDB to be held in *scmd
+ *              N.B. If cdb_len==0, then if *scmd holds some heap
+ *              due to a long CDB, then that heap is freed.
+ *
+ * Returns a (writable) pointer to the start of a buffer, owned by *scmd,
+ * where 'cdb' has been written to, or if 'cdb' is NULL, where cdb_len
+ * bytes of a SCSI CDB may be written. If 'cdb' is NULL then the returned
+ * buffer will be zero-ed. In the rare case of a long cdb where the
+ * kzalloc() allocating the additional buffer fails, NULL is returned.
+ **/
+u8 *__scsi_cmnd_set_cdb(struct scsi_cmnd *scmd, const u8 *cdb, u16 cdb_len)
+{
+	if (unlikely(scmd->flags & SCMD_LONG_CDB)) {
+		if (unlikely(cdb_len > SCSI_MAX_COMPILE_TIME_CDB_LEN &&
+			     cdb_len <= scmd->cmd_len)) {
+			if (cdb)
+				memcpy(scmd->l_cdb.cdbp, cdb, cdb_len);
+			else
+				memset(scmd->l_cdb.cdbp, 0, cdb_len);
+			scmd->cmd_len = cdb_len;
+			return scmd->l_cdb.cdbp;
+		}
+		kfree(scmd->l_cdb.cdbp);
+		scmd->l_cdb.cdbp = NULL;
+		scmd->flags &= ~SCMD_LONG_CDB;
+	}
+	scmd->cmd_len = cdb_len;
+	if (likely(cdb_len <= SCSI_MAX_COMPILE_TIME_CDB_LEN)) {
+		if (cdb_len > 0) {
+			if (cdb)
+				memcpy(scmd->cmnd, cdb, cdb_len);
+			else
+				memset(scmd->cmnd, 0, cdb_len);
+		}
+		return scmd->cmnd;
+	}
+	scmd->l_cdb.cdbp = kzalloc(cdb_len, GFP_KERNEL);
+	if (unlikely(!scmd->l_cdb.cdbp)) {
+		scmd->cmd_len = 0;
+		return NULL;
+	}
+	scmd->flags |= SCMD_LONG_CDB;
+	scmd->l_cdb.dummy_tur = 0;  /* defensive: cheap aid when testing */
+	if (cdb)
+		memcpy(scmd->l_cdb.cdbp, cdb, cdb_len);
+	return scmd->l_cdb.cdbp;
+}
+EXPORT_SYMBOL_GPL(__scsi_cmnd_set_cdb);
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index ff89de86545d..0c388e47406e 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -181,6 +181,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 {
 	int k;
 	char *logbuf;
+	const u8 *cdb = scsi_cmnd_get_cdb(cmd);
 	size_t off, logbuf_len;
 
 	logbuf = scsi_log_reserve_buffer(&logbuf_len);
@@ -195,8 +196,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 	if (WARN_ON(off >= logbuf_len))
 		goto out_printk;
 
-	off += scsi_format_opcode_name(logbuf + off, logbuf_len - off,
-				       cmd->cmnd);
+	off += scsi_format_opcode_name(logbuf + off, logbuf_len - off, cdb);
 	if (off >= logbuf_len)
 		goto out_printk;
 
@@ -213,8 +213,9 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 						 scsi_cmd_to_rq(cmd)->tag);
 			if (!WARN_ON(off > logbuf_len - 58)) {
 				off += scnprintf(logbuf + off, logbuf_len - off,
-						 "CDB[%02x]: ", k);
-				hex_dump_to_buffer(&cmd->cmnd[k], linelen,
+						 "CDB[%s%02x]: ",
+						 (k > 15 ? "0x" : ""), k);
+				hex_dump_to_buffer(&cdb[k], linelen,
 						   16, 1, logbuf + off,
 						   logbuf_len - off, false);
 			}
@@ -225,7 +226,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 	}
 	if (!WARN_ON(off > logbuf_len - 49)) {
 		off += scnprintf(logbuf + off, logbuf_len - off, " ");
-		hex_dump_to_buffer(cmd->cmnd, cmd->cmd_len, 16, 1,
+		hex_dump_to_buffer(cdb, cmd->cmd_len, 16, 1,
 				   logbuf + off, logbuf_len - off,
 				   false);
 	}
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 1e80e70dfa92..ac04245ab8e6 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -15,23 +15,33 @@ struct Scsi_Host;
 
 /*
  * MAX_COMMAND_SIZE is:
- * The longest fixed-length SCSI CDB as per the SCSI standard.
- * fixed-length means: commands that their size can be determined
- * by their opcode and the CDB does not carry a length specifier, (unlike
- * the VARIABLE_LENGTH_CMD(0x7f) command). This is actually not exactly
- * true and the SCSI standard also defines extended commands and
- * vendor specific commands that can be bigger than 16 bytes. The kernel
- * will support these using the same infrastructure used for VARLEN CDB's.
- * So in effect MAX_COMMAND_SIZE means the maximum size command scsi-ml
- * supports without specifying a cmd_len by ULD's
+ * an old define that is deprecated. Firstly it refers to a SCSI CDB
+ * (command descriptor block) that is no longer the maximum value. Plus
+ * using "command" is too general when there is a precise acronym: CDB .
+ * Please use one of the more precise defines that follow,
  */
-#define MAX_COMMAND_SIZE 16
+#define MAX_COMMAND_SIZE 16	/* old constant, should be removed */
+
+/* This value is used to size a C array sufficient to hold most cdb_s */
+#define SCSI_MAX_COMPILE_TIME_CDB_LEN 16
+
+/* Relatively safe SCSI command whose CDB is 6 zero bytes */
+#define SCSI_TEST_UNIT_READY_CDB_LEN 6
+
+/* Following used to guard against wild cmd_len values */
+#define SCSI_MAX_RUN_TIME_CDB_LEN (8 + 252)
+#define SCSI_MAX_RUN_TIME_8BIT_CDB_LEN 252
 
 struct scsi_data_buffer {
 	struct sg_table table;
 	unsigned length;
 };
 
+struct scsi_long_cdb {
+	u64 dummy_tur;	/* when zero first 6 bytes are Test Unit Ready cdb */
+	u8 *cdbp;	/* byte length in scsi_cmnd::cmd_len */
+};
+
 /* embedded in scsi_cmnd */
 struct scsi_pointer {
 	char *ptr;		/* data pointer */
@@ -48,12 +58,17 @@ struct scsi_pointer {
 	volatile int phase;
 };
 
-/* for scmd->flags */
+/*
+ * For scmd->flags . To maintain flag value for lifetime of scsi_cmnd
+ * sub-object, make sure flag is OR-ed into SCMD_PRESERVED_FLAGS .
+ */
 #define SCMD_TAGGED		(1 << 0)
 #define SCMD_INITIALIZED	(1 << 1)
 #define SCMD_LAST		(1 << 2)
+#define SCMD_LONG_CDB		(1 << 3)   /* indicates CDB separately on heap */
+
 /* flags preserved across unprep / reprep */
-#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED)
+#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_LONG_CDB)
 
 /* for scmd->state */
 #define SCMD_STATE_COMPLETE	0
@@ -65,6 +80,18 @@ enum scsi_cmnd_submitter {
 	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
 } __packed;
 
+/*
+ * The scsi_cmnd structure is fundamental to the operation of the SCSI
+ * subsystem. An object (or sub-object) of this type is created paired with
+ * a struct request (sub-)object (see include/linux/blk-mq.h). The struct
+ * request sub-object always has the lower address in memory. This is why the
+ * constructor for a scsi_cmnd object [see scsi_alloc_request() below] returns
+ * a pointer to a struct request object. The blk_mq_rq_from_pdu() and
+ * blk_mq_rq_to_pdu() inline functions are supplied by the block layer to move
+ * from a pointer to one of these sub-objects to the other.
+ * Users are encouraged to destroy this paired object with scsi_free_cmnd()
+ * function (destructor) defined below so that other clean-up can be hooked in.
+ */
 struct scsi_cmnd {
 	struct scsi_device *device;
 	struct list_head eh_entry; /* entry for the host eh_abort_list/eh_cmd_q */
@@ -72,7 +99,7 @@ struct scsi_cmnd {
 
 	struct rcu_head rcu;
 
-	int eh_eflags;		/* Used by error handlr */
+	int eh_eflags;		/* Used by error handler */
 
 	int budget_token;
 
@@ -94,7 +121,18 @@ struct scsi_cmnd {
 	unsigned short cmd_len;
 	enum dma_data_direction sc_data_direction;
 
-	unsigned char cmnd[32]; /* SCSI CDB */
+	/*
+	 * Access to a SCSI command (cdb) should be via the provided functions:
+	 *     scsi_cmnd_set_cdb(struct scsi_cmnd *scmd, const u8 * cdb, u16 cdb_len), or
+	 *     scsi_cmnd_get_cdb(const struct scsi_cmnd *scmd), or
+	 *     scsi_cmnd_get_changeable_cdb(struct scsi_cmnd *scmd)
+	 * If a LLD doesn't support cdb_len > SCSI_MAX_COMPILE_TIME_CDB_LEN then
+	 * it is safe to access cmnd[] directly.
+	 */
+	union {		/* selected via (scsi_cmnd::flags & SCMD_LONG_CDB) */
+		u8 cmnd[SCSI_MAX_COMPILE_TIME_CDB_LEN]; /* CDB when selector 0 */
+		struct scsi_long_cdb l_cdb;		/* when selector != 0 */
+	};
 
 	/* These elements define the operation we ultimately want to perform */
 	struct scsi_data_buffer sdb;
@@ -152,6 +190,47 @@ static inline void *scsi_cmd_priv(struct scsi_cmnd *cmd)
 	return cmd + 1;
 }
 
+/* Read only access function for SCSI CDB held in a scsi_cmnd object */
+static inline const u8 *scsi_cmnd_get_cdb(const struct scsi_cmnd *scmd)
+{
+	return (scmd->flags & SCMD_LONG_CDB) ? scmd->l_cdb.cdbp : scmd->cmnd;
+}
+
+/*
+ * Writable access function to an existing SCSI CDB held in a scsi_cmnd
+ * object. Must not increase the size if the pre-existing CDB .
+ */
+static inline u8 *scsi_cmnd_get_changeable_cdb(struct scsi_cmnd *scmd)
+{
+	return (scmd->flags & SCMD_LONG_CDB) ? scmd->l_cdb.cdbp : scmd->cmnd;
+}
+
+/* Helper function for following inline function: scsi_cmnd_set_cdb() */
+u8 *__scsi_cmnd_set_cdb(struct scsi_cmnd *scmd, const u8 *cdb, u16 cdb_len);
+
+/*
+ * If 'cdb' non-NULL then cdb_len bytes starting at cdb are copied into
+ * *scmd . Irrespective of that, the return value points to the start
+ * of a buffer owned by *scmd that has, or can receive, cdb_len bytes
+ * representing a SCSI CDB. If 'cdb' is NULL then the returned buffer
+ * is zero-ed for at least cdb_len bytes. Sets scsi_cmnd::cmd_len .
+ */
+static inline u8 *scsi_cmnd_set_cdb(struct scsi_cmnd *scmd, const u8 *cdb,
+				    u16 cdb_len)
+{
+	if ((scmd->flags & SCMD_LONG_CDB) ||
+	    cdb_len > SCSI_MAX_COMPILE_TIME_CDB_LEN)
+		return __scsi_cmnd_set_cdb(scmd, cdb, cdb_len);
+	scmd->cmd_len = cdb_len;
+	if (cdb_len > 0) {
+		if (cdb)
+			memcpy(scmd->cmnd, cdb, cdb_len);
+		else
+			memset(scmd->cmnd, 0, cdb_len);
+	}
+	return scmd->cmnd;
+}
+
 void scsi_done(struct scsi_cmnd *cmd);
 void scsi_done_direct(struct scsi_cmnd *cmd);
 
@@ -386,7 +465,16 @@ static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
 extern void scsi_build_sense(struct scsi_cmnd *scmd, int desc,
 			     u8 key, u8 asc, u8 ascq);
 
+/* Constructor for request object containing scsi_cmnd sub-object */
 struct request *scsi_alloc_request(struct request_queue *q,
 		unsigned int op, blk_mq_req_flags_t flags);
 
+/* Destructor for request object via pointer to scsi_cmnd sub-object */
+static inline void scsi_free_cmnd(struct scsi_cmnd *scmd)
+{
+	if (unlikely(scmd->flags & SCMD_LONG_CDB))
+		kfree(scmd->l_cdb.cdbp);
+	blk_mq_free_request(blk_mq_rq_from_pdu(scmd));
+}
+
 #endif /* _SCSI_SCSI_CMND_H */
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 1ae08e81339f..3278d3cb5a18 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -34,11 +34,15 @@ struct scsi_eh_save {
 	int result;
 	unsigned int resid_len;
 	int eh_eflags;
+	int flags;
 	enum dma_data_direction data_direction;
 	unsigned underflow;
 	unsigned char cmd_len;
 	unsigned char prot_op;
-	unsigned char cmnd[32];
+	union {		/* selected via (scsi_cmnd::flags & SCMD_LONG_CDB) */
+		u8 cmnd[SCSI_MAX_COMPILE_TIME_CDB_LEN]; /* CDB when selector 0 */
+		struct scsi_long_cdb l_cdb;             /* when selector != 0 */
+	};
 	struct scsi_data_buffer sdb;
 	struct scatterlist sense_sgl;
 };
-- 
2.25.1

