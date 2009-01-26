From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][SCST]: Checkpatch and sparse fixes
Date: Mon, 26 Jan 2009 20:39:22 +0300
Message-ID: <497DF54A.5040607@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:49967 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZAZRjY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2009 12:39:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>

The patch below fixes most checkpatch and sparse issues that are reported by
the most recent versions (checkpatch 2.6.28 / latest sparse git version) and
that were not reported by previous versions (checkpatch 2.6.27 / sparse 0.4.1).
The patch below fixes the following issues:
* Removed trailing space in iscsi-scst/README_in-tree.
* Fixed sparse complaints about functions that were not declared static.
* Fixed sparse complaints about casts between address spaces: such casts are
   now either fixed or explicit (via the __force keyword).

The patch below has been verified by checking the output produced by:
scripts/run-regression-tests -k 2.6.28.1

Please review.

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>

 iscsi-scst/README_in-tree         |    2 +-
 iscsi-scst/kernel/nthread.c       |    7 ++++---
 scst/src/dev_handlers/scst_user.c |    2 +-
 scst/src/scst_lib.c               |   14 +++++++-------
 scst/src/scst_targ.c              |    5 +++--
 5 files changed, 16 insertions(+), 14 deletions(-)

Index: iscsi-scst/kernel/nthread.c
===================================================================
--- iscsi-scst/kernel/nthread.c	(revision 637)
+++ iscsi-scst/kernel/nthread.c	(working copy)
@@ -1040,7 +1040,9 @@ static int write_data(struct iscsi_conn 
  retry:
 			oldfs = get_fs();
 			set_fs(KERNEL_DS);
-			res = vfs_writev(file, iop, count, &off);
+			res = vfs_writev(file,
+					 (struct iovec __force __user *)iop,
+					 count, &off);
 			set_fs(oldfs);
 			TRACE_WRITE("%#Lx:%u: %d(%ld)",
 				    (long long unsigned int)conn->session->sid,
@@ -1272,8 +1274,7 @@ static int tx_ddigest(struct iscsi_cmnd 
 
 	TRACE_DBG("Sending data digest %x (cmd %p)", cmnd->ddigest, cmnd);
 
-	iov.iov_base =
-		(char __force __user *) (&cmnd->ddigest) + (sizeof(u32) - rest);
+	iov.iov_base = (char *)(&cmnd->ddigest) + (sizeof(u32) - rest);
 	iov.iov_len = rest;
 
 	res = kernel_sendmsg(cmnd->conn->sock, &msg, &iov, 1, rest);
Index: iscsi-scst/README_in-tree
===================================================================
--- iscsi-scst/README_in-tree	(revision 637)
+++ iscsi-scst/README_in-tree	(working copy)
@@ -81,7 +81,7 @@ Work if target's backstorage or link is 
 In some cases you can experience I/O stalls or see in the kernel log
 abort or reset messages. It can happen under high I/O load, when your
 target's backstorage gets overloaded, or working over a slow link, when
-the link can't serve all the queued commands on time, 
+the link can't serve all the queued commands on time,
 
 To workaround it you can reduce QueuedCommands parameter in
 iscsi-scstd.conf file for the corresponding target to some lower value,
Index: scst/src/scst_lib.c
===================================================================
--- scst/src/scst_lib.c	(revision 637)
+++ scst/src/scst_lib.c	(working copy)
@@ -736,7 +736,7 @@ out_free:
  * scst_mutex supposed to be held, there must not be parallel activity in this
  * session.
  */
-void scst_sess_free_tgt_devs(struct scst_session *sess)
+static void scst_sess_free_tgt_devs(struct scst_session *sess)
 {
 	int i;
 	struct scst_tgt_dev *tgt_dev, *t;
@@ -1711,7 +1711,7 @@ out_sg_free:
 	goto out;
 }
 
-void scst_release_space(struct scst_cmd *cmd)
+static void scst_release_space(struct scst_cmd *cmd)
 {
 	TRACE_ENTRY();
 
@@ -2844,7 +2844,7 @@ out_unlock:
 }
 
 /* Called under tgt_dev_lock and BH off */
-void scst_alloc_set_UA(struct scst_tgt_dev *tgt_dev,
+static void scst_alloc_set_UA(struct scst_tgt_dev *tgt_dev,
 	const uint8_t *sense, int sense_len, int head)
 {
 	struct scst_tgt_dev_UA *UA_entry = NULL;
@@ -2950,7 +2950,7 @@ void __scst_dev_check_set_UA(struct scst
 }
 
 /* Called under tgt_dev_lock or when tgt_dev is unused */
-void scst_free_all_UA(struct scst_tgt_dev *tgt_dev)
+static void scst_free_all_UA(struct scst_tgt_dev *tgt_dev)
 {
 	struct scst_tgt_dev_UA *UA_entry, *t;
 
@@ -3259,7 +3259,7 @@ out_unlock:
 }
 
 /* Called under dev_lock */
-void scst_unblock_cmds(struct scst_device *dev)
+static void scst_unblock_cmds(struct scst_device *dev)
 {
 #ifdef CONFIG_SCST_STRICT_SERIALIZING
 	struct scst_cmd *cmd, *t;
@@ -3515,7 +3515,7 @@ static wait_queue_head_t *tm_dbg_p_cmd_l
 
 static const int tm_dbg_on_state_num_passes[] = { 5, 1, 0x7ffffff };
 
-void tm_dbg_init_tgt_dev(struct scst_tgt_dev *tgt_dev,
+static void tm_dbg_init_tgt_dev(struct scst_tgt_dev *tgt_dev,
 	struct scst_acg_dev *acg_dev)
 {
 	if ((acg_dev->acg == scst_default_acg) && (acg_dev->lun == 0)) {
@@ -3534,7 +3534,7 @@ void tm_dbg_init_tgt_dev(struct scst_tgt
 	}
 }
 
-void tm_dbg_deinit_tgt_dev(struct scst_tgt_dev *tgt_dev)
+static void tm_dbg_deinit_tgt_dev(struct scst_tgt_dev *tgt_dev)
 {
 	if (test_bit(SCST_TGT_DEV_UNDER_TM_DBG, &tgt_dev->tgt_dev_flags)) {
 		unsigned long flags;
Index: scst/src/scst_targ.c
===================================================================
--- scst/src/scst_targ.c	(revision 637)
+++ scst/src/scst_targ.c	(working copy)
@@ -1012,7 +1012,7 @@ out_dev_done:
 }
 
 /* No locks, but might be in IRQ */
-void scst_proccess_redirect_cmd(struct scst_cmd *cmd,
+static void scst_proccess_redirect_cmd(struct scst_cmd *cmd,
 	enum scst_exec_context context, int check_retries)
 {
 	unsigned long flags;
@@ -5454,7 +5454,8 @@ int scst_mgmt_thread(void *arg)
 }
 
 /* Called under sess->sess_list_lock */
-struct scst_cmd *__scst_find_cmd_by_tag(struct scst_session *sess, uint64_t tag)
+static struct scst_cmd *__scst_find_cmd_by_tag(struct scst_session *sess,
+	uint64_t tag)
 {
 	struct scst_cmd *cmd = NULL;
 
Index: scst/src/dev_handlers/scst_user.c
===================================================================
--- scst/src/dev_handlers/scst_user.c	(revision 637)
+++ scst/src/dev_handlers/scst_user.c	(working copy)
@@ -1690,7 +1690,7 @@ static int dev_user_reply_get_cmd(struct
 
 	/* get_user() can't be used with 64-bit values on x86_32 */
 	res = copy_from_user(&ureply, (uint64_t __user *)
-		&((struct scst_user_get_cmd *)arg)->preply,
+		&((struct scst_user_get_cmd __user *)arg)->preply,
 		sizeof(ureply));
 	if (unlikely(res < 0))
 		goto out_up;

