From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] [tgt]: Add proper STGT LUN backstore passthrough support (rev 3)
Date: Sun,  6 Jun 2010 20:50:25 -0700
Message-ID: <1275882625-5376-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:48107 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756244Ab0FGDtW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2010 23:49:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stgt-devel <stgt@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike
Cc: James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds two new queueing and completion function pointers to struct scsi_lu called ->cmd_perform()
and ->cmd_done() for handling existing internal STGT port emulation and the struct scsi_cmd
passthrough with bs_sg.c.  It retains the struct device_type_template->cmd_passthrough()
from the original patches, which still appears to be necessary for a device type to perform passthrough.
Also as before we modify the struct device_type_template sbc_template->cmd_passthrough() for sbc.c /
TYPE_DISK that we want to use passthrough for bs_sg LUNs.

For the setup path, we update tgt_device_create() to check if lu->cmd_perform() and lu->cmd_done()
have been set by struct backingstore_template->bs_init().  We expect bs_sg to setup these
pointers for us using the new target_cmd_perform_passthrough() and __cmd_done_passthrough() (see below).
Otherwise we setup the pointers following existing logic with target_cmd_perform() (also below) and
__cmd_done() for the non bs_sg case.

For the queue path and struct scsi_lu->cmd_perform() it made sense to split up target_cmd_queue()
into two functions, the original code at the tail of target_cmd_queue() now becomes
target_cmd_perform() and calls existing STGT port emulation code via cmd_enabled() -> scsi_cmd_perform().
A new function for passthrough has been added called target_cmd_perform_passthrough() that will do
struct scsi_lu->dev_type_template.cmd_passthrough() into the device type for bs_sg LUNs.

For the completion path and struct scsi_lu->cmd_done(), a new __cmd_done_passthrough()
has been added minus the original cmd_hlist_remove() and SCSI TASK attr checking in
__cmd_done().  __cmd_done() is used for the existing port emulation case, and modify the
two original users target_cmd_lookup() and abort_cmd() to call cmd->dev->cmd_done() instead.

Finally, it adds the passthrough case to tgt_device_create() in order to locate the
struct device_type_template * using device_type_passthrough().

This patch has been tested with STGT/iSCSI and TCM_Loop SPC-4 iSCSI Target Port emulation.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 usr/target.c |  113 ++++++++++++++++++++++++++++++++++++++++++++++++++++------
 usr/tgtd.h   |   16 ++++++++
 2 files changed, 118 insertions(+), 11 deletions(-)

diff --git a/usr/target.c b/usr/target.c
index c848757..3e2aa2b 100644
--- a/usr/target.c
+++ b/usr/target.c
@@ -48,11 +48,27 @@ int device_type_register(struct device_type_template *t)
 	return 0;
 }
 
-static struct device_type_template *device_type_lookup(int type)
+static struct device_type_template *device_type_passthrough(void)
 {
 	struct device_type_template *t;
 
 	list_for_each_entry(t, &device_type_list, device_type_siblings) {
+		if (t->cmd_passthrough != NULL)
+			return t;
+	}
+	return NULL;
+}
+
+static struct device_type_template *device_type_lookup(int type, int passthrough)
+{
+	struct device_type_template *t;
+
+	if (passthrough)
+		return device_type_passthrough();
+
+	list_for_each_entry(t, &device_type_list, device_type_siblings) {
+		if (t->cmd_passthrough != NULL)
+			continue;
 		if (t->type == type)
 			return t;
 	}
@@ -425,11 +441,13 @@ static match_table_t device_tokens = {
 	{Opt_err, NULL},
 };
 
+static void __cmd_done(struct target *, struct scsi_cmd *);
+
 int tgt_device_create(int tid, int dev_type, uint64_t lun, char *params,
 		      int backing)
 {
 	char *p, *path = NULL, *bstype = NULL;
-	int ret = 0;
+	int ret = 0, passthrough = 0;
 	struct target *target;
 	struct scsi_lu *lu, *pos;
 	struct device_type_template *t;
@@ -479,10 +497,11 @@ int tgt_device_create(int tid, int dev_type, uint64_t lun, char *params,
 				ret = TGTADM_INVALID_REQUEST;
 				goto out;
 			}
+			passthrough = bst->bs_passthrough;
 		}
 	}
 
-	t = device_type_lookup(dev_type);
+	t = device_type_lookup(dev_type, passthrough);
 	if (!t) {
 		eprintf("Unknown device type %d\n", dev_type);
 		ret = TGTADM_INVALID_REQUEST;
@@ -515,6 +534,26 @@ int tgt_device_create(int tid, int dev_type, uint64_t lun, char *params,
 		if (ret)
 			goto fail_lu_init;
 	}
+	/*
+	 * Check if struct scsi_lu->cmd_perform() has been filled in
+	 * by the SG_IO backstore for passthrough (SG_IO) in ->bs_init() call.
+	 * If the function pointer does not exist, use the default internal
+	 * target_cmd_perform() and __cmd_done() calls.
+	 */
+	if (!(lu->cmd_perform)) {
+		lu->cmd_perform = &target_cmd_perform;
+		lu->cmd_done = &__cmd_done;
+	} else if (!(lu->cmd_done)) {
+		eprintf("Unable to locate struct scsi_lu->cmd_done() with"
+				" valid ->cmd_perform()\n");
+		ret = TGTADM_INVALID_REQUEST;
+		goto fail_bs_init;
+	} else if (!(lu->dev_type_template.cmd_passthrough)) {
+		eprintf("Unable to locate ->cmd_passthrough() handler"
+				" for device type template\n");
+		ret = TGTADM_INVALID_REQUEST;
+		goto fail_bs_init;
+	}
 
 	if (backing && !path && !lu->attrs.removable) {
 		ret = TGTADM_INVALID_REQUEST;
@@ -828,9 +867,7 @@ static struct it_nexus_lu_info *it_nexus_lu_info_lookup(struct it_nexus *itn,
 int target_cmd_queue(int tid, struct scsi_cmd *cmd)
 {
 	struct target *target;
-	struct tgt_cmd_queue *q;
 	struct it_nexus *itn;
-	int result, enabled = 0;
 	uint64_t dev_id, itn_id = cmd->cmd_itn_id;
 
 	itn = it_nexus_lookup(tid, itn_id);
@@ -857,16 +894,28 @@ int target_cmd_queue(int tid, struct scsi_cmd *cmd)
 	/* service delivery or target failure */
 	if (target->target_state != SCSI_TARGET_READY)
 		return -EBUSY;
+	/*
+	 * Call struct scsi_lu->cmd_perform() that will either be setup for
+	 * internal or passthrough CDB processing using 2 functions below.
+	 */
+	return cmd->dev->cmd_perform(tid, cmd);
+}
 
-	cmd_hlist_insert(itn, cmd);
+/*
+ * Used by all non bs_sg backstores for internal STGT port emulation
+ */
+int target_cmd_perform(int tid, struct scsi_cmd *cmd)
+{
+	struct tgt_cmd_queue *q = &cmd->dev->cmd_queue;
+	int result, enabled = 0;
 
-	q = &cmd->dev->cmd_queue;
+	cmd_hlist_insert(cmd->it_nexus, cmd);
 
 	enabled = cmd_enabled(q, cmd);
-	dprintf("%p %x %" PRIx64 " %d\n", cmd, cmd->scb[0], dev_id, enabled);
+	dprintf("%p %x %" PRIx64 " %d\n", cmd, cmd->scb[0], cmd->dev_id, enabled);
 
 	if (enabled) {
-		result = scsi_cmd_perform(itn->host_no, cmd);
+		result = scsi_cmd_perform(cmd->it_nexus->host_no, cmd);
 
 		cmd_post_perform(q, cmd);
 
@@ -890,6 +939,30 @@ int target_cmd_queue(int tid, struct scsi_cmd *cmd)
 	return 0;
 }
 
+/*
+ * Used by bs_sg for CDB passthrough to STGT LUNs
+ */
+int target_cmd_perform_passthrough(int tid, struct scsi_cmd *cmd)
+{
+	int result;
+
+	dprintf("%p %x %" PRIx64 " PT \n", cmd, cmd->scb[0], cmd->dev_id);
+
+	result = cmd->dev->dev_type_template.cmd_passthrough(tid, cmd);
+
+	dprintf("%" PRIx64 " %x %p %p %" PRIu64 " %u %u %d %d\n",
+		cmd->tag, cmd->scb[0], scsi_get_out_buffer(cmd),
+		scsi_get_in_buffer(cmd), cmd->offset,
+		scsi_get_out_length(cmd), scsi_get_in_length(cmd),
+		result, cmd_async(cmd));
+
+	set_cmd_processed(cmd);
+	if (!cmd_async(cmd))
+		target_cmd_io_done(cmd, result);
+
+	return 0;
+}
+
 void target_cmd_io_done(struct scsi_cmd *cmd, int result)
 {
 	scsi_set_result(cmd, result);
@@ -924,6 +997,10 @@ static void post_cmd_done(struct tgt_cmd_queue *q)
 	}
 }
 
+/*
+ * Used by struct scsi_lu->cmd_done() for normal internal completion
+ * (non passthrough)
+ */
 static void __cmd_done(struct target *target, struct scsi_cmd *cmd)
 {
 	struct tgt_cmd_queue *q;
@@ -949,6 +1026,20 @@ static void __cmd_done(struct target *target, struct scsi_cmd *cmd)
 	post_cmd_done(q);
 }
 
+/*
+ * Used by struct scsi_lu->cmd_done() for bs_sg (passthrough) completion
+ */
+void __cmd_done_passthrough(struct target *target, struct scsi_cmd *cmd)
+{
+	int err;
+
+	err = target->bst->bs_cmd_done(cmd);
+
+	dprintf("%d %p %p %u %u %d\n", cmd_mmapio(cmd), scsi_get_out_buffer(cmd),
+		scsi_get_in_buffer(cmd), scsi_get_out_length(cmd),
+		scsi_get_in_length(cmd), err);
+}
+
 struct scsi_cmd *target_cmd_lookup(int tid, uint64_t itn_id, uint64_t tag)
 {
 	struct scsi_cmd *cmd;
@@ -973,7 +1064,7 @@ void target_cmd_done(struct scsi_cmd *cmd)
 		free(mreq);
 	}
 
-	__cmd_done(cmd->c_target, cmd);
+	cmd->dev->cmd_done(cmd->c_target, cmd);
 }
 
 static int abort_cmd(struct target* target, struct mgmt_req *mreq,
@@ -992,7 +1083,7 @@ static int abort_cmd(struct target* target, struct mgmt_req *mreq,
 		cmd->mreq = mreq;
 		err = -EBUSY;
 	} else {
-		__cmd_done(target, cmd);
+		cmd->dev->cmd_done(target, cmd);
 		target_cmd_io_done(cmd, TASK_ABORTED);
 	}
 	return err;
diff --git a/usr/tgtd.h b/usr/tgtd.h
index 3323a9b..f17fa15 100644
--- a/usr/tgtd.h
+++ b/usr/tgtd.h
@@ -108,6 +108,7 @@ struct device_type_template {
 	int (*lu_config)(struct scsi_lu *lu, char *args);
 	int (*lu_online)(struct scsi_lu *lu);
 	int (*lu_offline)(struct scsi_lu *lu);
+	int (*cmd_passthrough)(int, struct scsi_cmd *);
 
 	struct device_type_operations ops[256];
 
@@ -117,6 +118,7 @@ struct device_type_template {
 struct backingstore_template {
 	const char *bs_name;
 	int bs_datasize;
+	int bs_passthrough;
 	int (*bs_open)(struct scsi_lu *dev, char *path, int *fd, uint64_t *size);
 	void (*bs_close)(struct scsi_lu *dev);
 	int (*bs_init)(struct scsi_lu *dev);
@@ -178,6 +180,17 @@ struct scsi_lu {
 	 * Currently used by ssc, smc and mmc modules.
 	 */
 	void *xxc_p;
+	/*
+	 * Used internally for usr/target.c:target_cmd_perform() and with
+	 * passthrough CMD processing with
+	 * struct device_type_template->cmd_passthrough().
+	 */
+	int (*cmd_perform)(int, struct scsi_cmd *);
+	/*
+	 * Used internally for usr/target.c:__cmd_done() and with
+	 * passthrough CMD processing with __cmd_done_passthrough()
+	 */
+	void (*cmd_done)(struct target *, struct scsi_cmd *);
 };
 
 struct mgmt_req {
@@ -250,7 +263,10 @@ extern void tgt_remove_sched_event(struct event_data *evt);
 
 extern int tgt_event_modify(int fd, int events);
 extern int target_cmd_queue(int tid, struct scsi_cmd *cmd);
+extern int target_cmd_perform(int tid, struct scsi_cmd *cmd);
+extern int target_cmd_perform_passthrough(int tid, struct scsi_cmd *cmd);
 extern void target_cmd_done(struct scsi_cmd *cmd);
+extern void __cmd_done_passthrough(struct target *target, struct scsi_cmd *cmd);
 struct scsi_cmd *target_cmd_lookup(int tid, uint64_t itn_id, uint64_t tag);
 
 extern enum mgmt_req_result target_mgmt_request(int tid, uint64_t itn_id,
-- 
1.5.6.5

