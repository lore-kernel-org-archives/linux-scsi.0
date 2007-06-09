From: michaelc@cs.wisc.edu
Subject: [PATCH 2/7] scsi-hw-handler: scsi handling of
	REQ_LB_OP_TRANSITION
Date: Sat, 09 Jun 2007 14:07:59 -0500
Message-ID: <1181416085774-git-send-email-michaelc@cs.wisc.edu>
References: <11814160842916-git-send-email-michaelc@cs.wisc.edu>
	<11814160853812-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu,
	device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11814160853812-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds a scsi handler for REQ_LB_OP_TRANSITION commands.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/Kconfig       |    5 ++
 drivers/scsi/scsi_error.c  |   10 ++++
 drivers/scsi/scsi_lib.c    |  113 +++++++++++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_cmnd.h   |    1 
 include/scsi/scsi_device.h |   14 +++++
 5 files changed, 141 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index aac9cd9..e4372da 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -285,6 +285,11 @@ source "drivers/scsi/libsas/Kconfig"
 
 endmenu
 
+menu "SCSI Device Info Drivers"
+	depends on SCSI
+
+endmenu
+
 menu "SCSI low-level drivers"
 	depends on SCSI!=n
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 9adb64a..99e526d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -297,6 +297,7 @@ #endif
  **/
 static int scsi_check_sense(struct scsi_cmnd *scmd)
 {
+	struct scsi_device *sdev = scmd->device;
 	struct scsi_sense_hdr sshdr;
 
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
@@ -305,6 +306,15 @@ static int scsi_check_sense(struct scsi_
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
 
+	if (sdev->sdevt && sdev->sdevt->check_sense) {
+		int rc;
+
+		rc = sdev->sdevt->check_sense(&sshdr);
+		if (rc)
+			return rc;
+		/* hw module does not care. Drop down to default handling */
+	}
+
 	/*
 	 * Previous logic looked for FILEMARK, EOM or ILI which are
 	 * mainly associated with tapes and returned SUCCESS.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 70454b4..e96a9a0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1075,6 +1075,37 @@ static struct scsi_cmnd *scsi_get_cmd_fr
 	return cmd;
 }
 
+static int scsi_setup_blk_linux_cmnd(struct scsi_device *sdev,
+				     struct request *rq)
+{
+	if (!get_device(&sdev->sdev_gendev)) {
+		rq->errors = BLKERR_DEV_OFFLINED;
+		goto kill;
+	}
+
+	switch (rq->cmd[0]) {
+	case REQ_LB_OP_TRANSITION:
+		if (!sdev->sdevt || !sdev->sdevt->transition) {
+			/* set REQ_LB_OP_TRANSITION specific error */
+			rq->errors = BLKERR_NOSYS;
+			goto kill;
+		}
+		if (!try_module_get(sdev->sdevt->module)) {
+			rq->errors = BLKERR_DEV_OFFLINED;
+			goto kill;
+		}
+
+		break;
+	default:
+		rq->errors = BLKERR_INVALID_IO;
+		goto kill;
+	}
+	return BLKPREP_OK;
+
+kill:
+	return BLKPREP_KILL;
+}
+
 static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
 {
 	BUG_ON(!blk_pc_request(cmd->request));
@@ -1233,6 +1264,8 @@ static int scsi_prep_fn(struct request_q
 	case REQ_TYPE_FS:
 		ret = scsi_setup_fs_cmnd(sdev, req);
 		break;
+	case REQ_TYPE_LINUX_BLOCK:
+		return scsi_setup_blk_linux_cmnd(sdev, req);
 	default:
 		/*
 		 * All other command types are not supported.
@@ -1376,9 +1409,24 @@ static void scsi_kill_request(struct req
 static void scsi_softirq_done(struct request *rq)
 {
 	struct scsi_cmnd *cmd = rq->completion_data;
-	unsigned long wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
+	struct request_queue *q;
+	unsigned long wait_for, flags;
 	int disposition;
 
+	if (blk_linux_request(rq)) {
+		q = rq->q;
+		spin_lock_irqsave(q->queue_lock, flags);
+		/*
+		 * we always return 1 and the caller should
+		 * check rq->errors for the complete status
+		 */
+		end_that_request_last(rq, 1);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+		return;
+	}
+
+
+	wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
 	disposition = scsi_decide_disposition(cmd);
@@ -1408,6 +1456,51 @@ static void scsi_softirq_done(struct req
 	}
 }
 
+/**
+ * scsi_blk_linux_cmd_done - Complete a REQ_TYPE_LINUX_BLOCK request.
+ * @req: REQ_TYPE_LINUX_BLOCK request being processed
+ * @err: return value
+ *
+ * This function should be called by the REQ_TYPE_LINUX_BLOCK handler
+ * to return the request to its caller. This function queues the
+ * the completion to the blk softirq so the queue lock does not have
+ * to be held here.
+ */
+void scsi_blk_linux_cmd_done(struct request *rq, int err)
+{
+	struct scsi_device *sdev = rq->q->queuedata;
+
+	switch (rq->cmd[0]) {
+	case REQ_LB_OP_TRANSITION:
+		module_put(sdev->sdevt->module);
+		break;
+	}
+
+	put_device(&sdev->sdev_gendev);
+	rq->errors = err;
+	rq->completion_data = NULL;
+	blk_complete_request(rq);
+}
+EXPORT_SYMBOL_GPL(scsi_blk_linux_cmd_done);
+
+static void scsi_execute_blk_linux_cmd(struct request *rq)
+{
+	struct request_queue *q = rq->q;
+	struct scsi_device *sdev = q->queuedata;
+
+	switch (rq->cmd[0]) {
+	case REQ_LB_OP_TRANSITION:
+		spin_unlock_irq(q->queue_lock);
+		sdev->sdevt->transition(rq);
+		spin_lock_irq(q->queue_lock);
+		break;
+	default:
+		/* should have checked in scsi_prep_fn already */
+		BUG();
+	}
+}
+
+
 /*
  * Function:    scsi_request_fn()
  *
@@ -1450,7 +1543,23 @@ static void scsi_request_fn(struct reque
 		 * accept it.
 		 */
 		req = elv_next_request(q);
-		if (!req || !scsi_dev_queue_ready(q, sdev))
+		if (!req)
+			break;
+
+		/*
+		 * We do not account for linux blk req in the device
+		 * or host busy accounting because it is not necessarily
+		 * a scsi command that is sent to some object. The lower
+		 * level can translate it into a request/scsi_cmnd, if
+		 * necessary, and then queue that up using REQ_TYPE_BLOCK_PC.
+		 */
+		if (blk_linux_request(req)) {
+			blkdev_dequeue_request(req);
+			scsi_execute_blk_linux_cmd(req);
+			continue;
+		}
+
+		if (!scsi_dev_queue_ready(q, sdev))
 			break;
 
 		if (unlikely(!scsi_device_online(sdev))) {
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 53e1705..5344b44 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -127,6 +127,7 @@ extern void __scsi_put_command(struct Sc
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 extern void scsi_req_abort_cmd(struct scsi_cmnd *cmd);
+extern void scsi_blk_linux_cmd_done(struct request *req, int err);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2f3c5b8..1db6808 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -9,6 +9,7 @@ #include <linux/blkdev.h>
 #include <asm/atomic.h>
 
 struct request_queue;
+struct request;
 struct scsi_cmnd;
 struct scsi_lun;
 struct scsi_sense_hdr;
@@ -143,9 +144,22 @@ #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
 	struct execute_work	ew; /* used to get process context on put */
 
+	struct scsi_device_template *sdevt;
+	void			*sdevt_data;
 	enum scsi_device_state sdev_state;
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
+
+#define SCSI_MAX_SDEV_TEMPLATE_NAME 16
+
+struct scsi_device_template {
+	struct module *module;
+	const char *name;
+
+	int (* check_sense)(struct scsi_sense_hdr *);
+	void (* transition)(struct request *);
+};
+
 #define	to_scsi_device(d)	\
 	container_of(d, struct scsi_device, sdev_gendev)
 #define	class_to_sdev(d)	\
-- 
1.4.1.1
