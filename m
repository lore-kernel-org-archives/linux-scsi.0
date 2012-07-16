From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 5/7] target: Check sess_tearing_down in target_get_sess_cmd()
Date: Mon, 16 Jul 2012 11:04:40 -0700
Message-ID: <1342461882-5848-6-git-send-email-roland@kernel.org>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1342461882-5848-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Target core code assumes that target_splice_sess_cmd_list() has set
sess_tearing_down and moved the list of pending commands to
sess_wait_list, no more commands will be added to the session; if any
are added, nothing keeps the se_session from being freed while the
command is still in flight, which e.g. leads to use-after-free of
se_cmd->se_sess in target_release_cmd_kref().

To enforce this invariant, put a check of sess_tearing_down inside of
sess_cmd_lock in target_get_sess_cmd(); any checks before this are
racy and can lead to the use-after-free described above.  For example,
the qla_target check in qlt_do_work() checks sess_tearing_down from
work thread context but then drops all locks before calling
target_submit_cmd() (as it must, since that is a sleeping function).

However, since no locks are held, anything can happen with respect to
the session it has looked up -- although it does correctly get
sess_kref within its lock, so the memory won't be freed while
target_submit_cmd() is actually running, nothing stops eg an ACL from
being dropped and calling ->shutdown_session() (which calls into
target_splice_sess_cmd_list()) before we get to target_get_sess_cmd().
Once this happens, the se_session memory can be freed as soon as
target_submit_cmd() returns and qlt_do_work() drops its reference,
even though we've just added a command to sess_cmd_list.

To prevent this use-after-free, check sess_tearing_down inside of
sess_cmd_lock right before target_get_sess_cmd() adds a command to
sess_cmd_list; this is synchronized with target_splice_sess_cmd_list()
so that every command is either waited for or not added to the queue.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_transport.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 34ca821..23e6e2d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -73,7 +73,7 @@ static void transport_complete_task_attr(struct se_cmd *cmd);
 static void transport_handle_queue_full(struct se_cmd *cmd,
 		struct se_device *dev);
 static int transport_generic_get_mem(struct se_cmd *cmd);
-static void target_get_sess_cmd(struct se_session *, struct se_cmd *, bool);
+static int target_get_sess_cmd(struct se_session *, struct se_cmd *, bool);
 static void transport_put_cmd(struct se_cmd *cmd);
 static void transport_remove_cmd_from_queue(struct se_cmd *cmd);
 static int transport_set_sense_codes(struct se_cmd *cmd, u8 asc, u8 ascq);
@@ -1570,7 +1570,9 @@ int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * for fabrics using TARGET_SCF_ACK_KREF that expect a second
 	 * kref_put() to happen during fabric packet acknowledgement.
 	 */
-	target_get_sess_cmd(se_sess, se_cmd, (flags & TARGET_SCF_ACK_KREF));
+	rc = target_get_sess_cmd(se_sess, se_cmd, (flags & TARGET_SCF_ACK_KREF));
+	if (rc)
+		return rc;
 	/*
 	 * Signal bidirectional data payloads to target-core
 	 */
@@ -1664,7 +1666,11 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		se_cmd->se_tmr_req->ref_task_tag = tag;
 
 	/* See target_submit_cmd for commentary */
-	target_get_sess_cmd(se_sess, se_cmd, (flags & TARGET_SCF_ACK_KREF));
+	ret = target_get_sess_cmd(se_sess, se_cmd, (flags & TARGET_SCF_ACK_KREF));
+	if (ret) {
+		core_tmr_release_req(se_cmd->se_tmr_req);
+		return ret;
+	}
 
 	ret = transport_lookup_tmr_lun(se_cmd, unpacked_lun);
 	if (ret) {
@@ -3650,10 +3656,11 @@ EXPORT_SYMBOL(transport_generic_free_cmd);
  * @se_cmd:	command descriptor to add
  * @ack_kref:	Signal that fabric will perform an ack target_put_sess_cmd()
  */
-static void target_get_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd,
-				bool ack_kref)
+static int target_get_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd,
+			       bool ack_kref)
 {
 	unsigned long flags;
+	int ret = 0;
 
 	kref_init(&se_cmd->cmd_kref);
 	/*
@@ -3667,9 +3674,16 @@ static void target_get_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cm
 	}
 
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
+	if (se_sess->sess_tearing_down) {
+		ret = -ESHUTDOWN;
+		goto out;
+	}
 	list_add_tail(&se_cmd->se_cmd_list, &se_sess->sess_cmd_list);
 	se_cmd->check_release = 1;
+
+out:
 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
+	return ret;
 }
 
 static void target_release_cmd_kref(struct kref *kref)
-- 
1.7.10.4
