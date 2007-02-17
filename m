From: Elias Oltmanns <eo@nebensachen.de>
Subject: [RFC] How to implement linux_block commands in scsi midlayer
Date: Sat, 17 Feb 2007 23:51:57 +0100
Message-ID: <87abzcxur6.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.225.107.202]:60563 "EHLO
	mail.nebensachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992869AbXBQX1I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Feb 2007 18:27:08 -0500
Received: from pd9e84a1b.dip.t-dialin.net ([217.232.74.27] helo=denkblock.local)
	by mail.nebensachen.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.50)
	id 1HIYPR-0004bU-U5
	for linux-scsi@vger.kernel.org; Sat, 17 Feb 2007 23:52:03 +0100
Received: from eo by denkblock.local with local (Exim 4.62)
	(envelope-from <eo@denkblock.local>)
	id 1HIYPN-0007ZB-2v
	for linux-scsi@vger.kernel.org; Sat, 17 Feb 2007 23:51:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi there,

in 2.6.19 the request type REQ_TYPE_LINUX_BLOCK has been introduced.
This is meant for generic block layer commands to the lower level
drivers. I'd like to use this mechanism for a generic queue freezing
and disk parking facility. The idea is to issue a command like
REQ_LB_OP_PROTECT to the device driver associated to the queue so it
can do about it what ever it sees fit. On command completion, the
block layer then stops the queue until the unfreeze command is passed
in. The IDLE IMMEDIATE command in recent ATA specs provides an unload
disk heads feature which I'd like to use when the generic block layer
command is issued to an ATA device.

Since ATA is implemented as a subsystem of the scsi subsystem, I
thought it would be best to add an scsi_cmnd opcode LINUX_BLOCK_CMD to
include/scsi/scsi.h and deal with commands of this type very much like
block_pc commands. The difference between these two types is that when
LINUX_BLOCK_CMD commands are taken off the queue, it is dealt with by
a special function of the midlayer to see if there is something to be
done about it regardless of the lld associated with the device in
question, and then the very same command is passed on to the low level
driver to give it a chance to do the more specific stuff.

In my particular case of a generic disk protect command, the midlayer
would be responsible for setting sdev_state to SDEV_BLOCK and the ATA
subsystem would issue the actual park command.

The patch attached is a first attempt of a generic implementation of
LINUX_BLOCK commands into the scsi midlayer. It probably doesn't apply
cleanly to 2.6.19 as I've just extracted it from my disk parking
branch, so it mainly serves as an example to comment on. Please let me
know what you think about this approach and whether I should post a
seperate patch for official integration into main line or whether it
would be sufficient to leave it a part of the disk parking patch to be
submitted later on.

Regards,

Elias
-----------------------
 drivers/ata/libata-scsi.c |   39 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_lib.c   |   50 +++++++++++++++++++++++++++++++++++++++++----
 include/linux/blkdev.h    |    1 +
 include/scsi/scsi.h       |    1 +
 4 files changed, 86 insertions(+), 5 deletions(-)
 drivers/scsi/scsi.c       |    3 ++-

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a8acf71..6f1c351 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2558,6 +2558,41 @@ static struct ata_device * ata_find_dev(
 	return NULL;
 }
 
+/**
+ *	ata_scsi_linux_block - handling of generic block layer commands
+ *	@dev: ATA device to which the command is addressed
+ *	@cmd: SCSI command to execute
+ *	@done: SCSI command completion function
+ *
+ *	This function checks to see if we recognise the generic block layer
+ *	command and should do anything about it. If we don't know the command,
+ *	we indicate this in a sense response. However, we should fail
+ *	gracefully since the midlayer might handle this command appropriately
+ *	anyway, even without low level intervention.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ *	RETURNS:
+ *	Zero on success, non-zero on failure.
+ */
+
+static int ata_scsi_linux_block(struct ata_device *dev, struct scsi_cmnd *cmd,
+				void (*done)(struct scsi_cmnd *))
+{
+	struct request *req = cmd->request;
+	int ret = 0;
+
+	switch (req->cmd[0]) {
+	default:
+		ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, 0x20, 0x0);
+		/* "Invalid command operation code" */
+		done(cmd);
+		break;
+	}
+	return ret;
+}
+
 static struct ata_device * __ata_scsi_find_dev(struct ata_port *ap,
 					const struct scsi_device *scsidev)
 {
@@ -2856,7 +2891,9 @@ static inline int __ata_scsi_queuecmd(st
 {
 	int rc = 0;
 
-	if (dev->class == ATA_DEV_ATA) {
+	if (cmd->cmnd[0] == LINUX_BLOCK_CMD)
+		rc = ata_scsi_linux_block(dev, cmd, done);
+	else if (dev->class == ATA_DEV_ATA) {
 		ata_xlat_func_t xlat_func = ata_get_xlat_func(dev,
 							      cmd->cmnd[0]);
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cbb274d..d8e0be4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -832,7 +832,8 @@ void scsi_io_completion(struct scsi_cmnd
 			sense_deferred = scsi_sense_is_deferred(&sshdr);
 	}
 
-	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
+	if (blk_pc_request(req) /* SG_IO ioctl from block level */
+	    || blk_lb_request(req)) {
 		req->errors = result;
 		if (result) {
 			clear_errors = 0;
@@ -998,7 +999,7 @@ static int scsi_init_io(struct scsi_cmnd
 	/*
 	 * if this is a rq->data based REQ_BLOCK_PC, setup for a non-sg xfer
 	 */
-	if (blk_pc_request(req) && !req->bio) {
+	if ((blk_pc_request(req) || blk_lb_request(req)) && !req->bio) {
 		cmd->request_bufflen = req->data_len;
 		cmd->request_buffer = req->data;
 		req->buffer = req->data;
@@ -1101,6 +1102,32 @@ static void scsi_setup_blk_pc_cmnd(struc
 	cmd->done = scsi_blk_pc_done;
 }
 
+static void scsi_blk_lb_done(struct scsi_cmnd *cmd)
+{
+	BUG_ON(!blk_lb_request(cmd->request));
+	scsi_io_completion(cmd, cmd->request_bufflen);
+}
+
+static void scsi_setup_blk_lb_cmnd(struct scsi_cmnd *cmd)
+{
+	struct request *req = cmd->request;
+
+	BUILD_BUG_ON(sizeof(req->cmd) > sizeof(cmd->cmnd));
+	cmd->cmnd[0] = LINUX_BLOCK_CMD;
+	cmd->cmd_len = COMMAND_SIZE(cmd->cmnd[0]);
+	if (!req->data_len)
+		cmd->sc_data_direction = DMA_NONE;
+	else if (rq_data_dir(req) == WRITE)
+		cmd->sc_data_direction = DMA_TO_DEVICE;
+	else
+		cmd->sc_data_direction = DMA_FROM_DEVICE;
+
+	cmd->transfersize = req->data_len;
+	cmd->allowed = req->retries;
+	cmd->timeout_per_command = req->timeout;
+	cmd->done = scsi_blk_lb_done;
+}
+
 static int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
 	struct scsi_device *sdev = q->queuedata;
@@ -1144,7 +1171,8 @@ static int scsi_prep_fn(struct request_q
 	 */
 	if (blk_special_request(req) && req->special)
 		cmd = req->special;
-	else if (blk_pc_request(req) || blk_fs_request(req)) {
+	else if (blk_pc_request(req) || blk_fs_request(req)
+		 || blk_lb_request(req)) {
 		if (unlikely(specials_only) && !(req->cmd_flags & REQ_PREEMPT)){
 			if (specials_only == SDEV_QUIESCE ||
 			    specials_only == SDEV_BLOCK)
@@ -1185,7 +1213,8 @@ static int scsi_prep_fn(struct request_q
 	 * lock.  We hope REQ_STARTED prevents anything untoward from
 	 * happening now.
 	 */
-	if (blk_fs_request(req) || blk_pc_request(req)) {
+	if (blk_fs_request(req) || blk_pc_request(req)
+	    || blk_lb_request(req)) {
 		int ret;
 
 		/*
@@ -1219,6 +1248,8 @@ static int scsi_prep_fn(struct request_q
 		 */
 		if (blk_pc_request(req)) {
 			scsi_setup_blk_pc_cmnd(cmd);
+		} else if (blk_lb_request(req)) {
+			scsi_setup_blk_lb_cmnd(cmd);
 		} else if (req->rq_disk) {
 			struct scsi_driver *drv;
 
@@ -1355,6 +1386,12 @@ static void scsi_kill_request(struct req
 	__scsi_done(cmd);
 }
 
+static void scsi_lb_handler(struct request *req)
+{
+	switch (req->cmd[0]) {
+	}
+}
+
 static void scsi_softirq_done(struct request *rq)
 {
 	struct scsi_cmnd *cmd = rq->completion_data;
@@ -1483,6 +1520,11 @@ static void scsi_request_fn(struct reque
 		 * the timers for timeouts.
 		 */
 		scsi_init_cmd_errh(cmd);
+		/* Have a look at LINUX_BLOCK requests and see what midlayer
+		 * can do before llds take action as implemented
+		 */
+		if (blk_lb_request(req))
+			scsi_lb_handler(req);
 
 		/*
 		 * Dispatch the command to the low-level driver.
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 838e7b0..ece9a89 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -552,6 +552,7 @@ #define blk_fs_request(rq)	((rq)->cmd_ty
 #define blk_pc_request(rq)	((rq)->cmd_type == REQ_TYPE_BLOCK_PC)
 #define blk_special_request(rq)	((rq)->cmd_type == REQ_TYPE_SPECIAL)
 #define blk_sense_request(rq)	((rq)->cmd_type == REQ_TYPE_SENSE)
+#define blk_lb_request(rq)	((rq)->cmd_type == REQ_TYPE_LINUX_BLOCK)
 
 #define blk_noretry_request(rq)	((rq)->cmd_flags & REQ_FAILFAST)
 #define blk_rq_started(rq)	((rq)->cmd_flags & REQ_STARTED)
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 5c0e979..b36fa4e 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -112,6 +112,7 @@ #define WRITE_LONG_2          0xea
 #define READ_16               0x88
 #define WRITE_16              0x8a
 #define VERIFY_16	      0x8f
+#define LINUX_BLOCK_CMD	      0xf0
 #define SERVICE_ACTION_IN     0x9e
 /* values for service action in */
 #define	SAI_READ_CAPACITY_16  0x10
