From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] libiscsi: add lock around task lists to fix list corruption regression
Date: Mon, 27 Feb 2017 16:58:36 -0800
Message-ID: <20170228005836.12444-1-cleech@redhat.com>
References: <20170221173536.32024-1-cleech@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBCYMVIPVXQMBBLMX2PCQKGQEEEJCOQA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20170221173536.32024-1-cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, lduncan-IBi9RG/b67k@public.gmane.org
Cc: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, ilkka-/1wQRMveznE@public.gmane.org, gpiccoli-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, "# v3 . 15+" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

There's a rather long standing regression from the commit
"libiscsi: Reduce locking contention in fast path"

Depending on iSCSI target behavior, it's possible to hit the case in
iscsi_complete_task where the task is still on a pending list
(!list_empty(&task->running)).  When that happens the task is removed
from the list while holding the session back_lock, but other task list
modification occur under the frwd_lock.  That leads to linked list
corruption and eventually a panicked system.

Rather than back out the session lock split entirely, in order to try
and keep some of the performance gains this patch adds another lock to
maintain the task lists integrity.

Major enterprise supported kernels have been backing out the lock split
for while now, thanks to the efforts at IBM where a lab setup has the
most reliable reproducer I've seen on this issue.  This patch has been
tested there successfully.

v2: changed WARN_ONCE to pr_debug_once

Signed-off-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Fixes: 659743b02c41 ("[SCSI] libiscsi: Reduce locking contention in fast path")
Reported-by: Prashantha Subbarao <psubbara-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Guilherme G. Piccoli <gpiccoli-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v3.15+
---
 drivers/scsi/libiscsi.c | 26 +++++++++++++++++++++++++-
 include/scsi/libiscsi.h |  1 +
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 834d1212b6d5..3fca34a675af 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -560,8 +560,12 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
 	WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
 	task->state = state;
 
-	if (!list_empty(&task->running))
+	spin_lock_bh(&conn->taskqueuelock);
+	if (!list_empty(&task->running)) {
+		pr_debug_once("%s while task on list", __func__);
 		list_del_init(&task->running);
+	}
+	spin_unlock_bh(&conn->taskqueuelock);
 
 	if (conn->task == task)
 		conn->task = NULL;
@@ -783,7 +787,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		if (session->tt->xmit_task(task))
 			goto free_task;
 	} else {
+		spin_lock_bh(&conn->taskqueuelock);
 		list_add_tail(&task->running, &conn->mgmtqueue);
+		spin_unlock_bh(&conn->taskqueuelock);
 		iscsi_conn_queue_work(conn);
 	}
 
@@ -1474,8 +1480,10 @@ void iscsi_requeue_task(struct iscsi_task *task)
 	 * this may be on the requeue list already if the xmit_task callout
 	 * is handling the r2ts while we are adding new ones
 	 */
+	spin_lock_bh(&conn->taskqueuelock);
 	if (list_empty(&task->running))
 		list_add_tail(&task->running, &conn->requeue);
+	spin_unlock_bh(&conn->taskqueuelock);
 	iscsi_conn_queue_work(conn);
 }
 EXPORT_SYMBOL_GPL(iscsi_requeue_task);
@@ -1512,22 +1520,26 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	 * only have one nop-out as a ping from us and targets should not
 	 * overflow us with nop-ins
 	 */
+	spin_lock_bh(&conn->taskqueuelock);
 check_mgmt:
 	while (!list_empty(&conn->mgmtqueue)) {
 		conn->task = list_entry(conn->mgmtqueue.next,
 					 struct iscsi_task, running);
 		list_del_init(&conn->task->running);
+		spin_unlock_bh(&conn->taskqueuelock);
 		if (iscsi_prep_mgmt_task(conn, conn->task)) {
 			/* regular RX path uses back_lock */
 			spin_lock_bh(&conn->session->back_lock);
 			__iscsi_put_task(conn->task);
 			spin_unlock_bh(&conn->session->back_lock);
 			conn->task = NULL;
+			spin_lock_bh(&conn->taskqueuelock);
 			continue;
 		}
 		rc = iscsi_xmit_task(conn);
 		if (rc)
 			goto done;
+		spin_lock_bh(&conn->taskqueuelock);
 	}
 
 	/* process pending command queue */
@@ -1535,19 +1547,24 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		conn->task = list_entry(conn->cmdqueue.next, struct iscsi_task,
 					running);
 		list_del_init(&conn->task->running);
+		spin_unlock_bh(&conn->taskqueuelock);
 		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
 			fail_scsi_task(conn->task, DID_IMM_RETRY);
+			spin_lock_bh(&conn->taskqueuelock);
 			continue;
 		}
 		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
 		if (rc) {
 			if (rc == -ENOMEM || rc == -EACCES) {
+				spin_lock_bh(&conn->taskqueuelock);
 				list_add_tail(&conn->task->running,
 					      &conn->cmdqueue);
 				conn->task = NULL;
+				spin_unlock_bh(&conn->taskqueuelock);
 				goto done;
 			} else
 				fail_scsi_task(conn->task, DID_ABORT);
+			spin_lock_bh(&conn->taskqueuelock);
 			continue;
 		}
 		rc = iscsi_xmit_task(conn);
@@ -1558,6 +1575,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		 * we need to check the mgmt queue for nops that need to
 		 * be sent to aviod starvation
 		 */
+		spin_lock_bh(&conn->taskqueuelock);
 		if (!list_empty(&conn->mgmtqueue))
 			goto check_mgmt;
 	}
@@ -1577,12 +1595,15 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		conn->task = task;
 		list_del_init(&conn->task->running);
 		conn->task->state = ISCSI_TASK_RUNNING;
+		spin_unlock_bh(&conn->taskqueuelock);
 		rc = iscsi_xmit_task(conn);
 		if (rc)
 			goto done;
+		spin_lock_bh(&conn->taskqueuelock);
 		if (!list_empty(&conn->mgmtqueue))
 			goto check_mgmt;
 	}
+	spin_unlock_bh(&conn->taskqueuelock);
 	spin_unlock_bh(&conn->session->frwd_lock);
 	return -ENODATA;
 
@@ -1738,7 +1759,9 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 			goto prepd_reject;
 		}
 	} else {
+		spin_lock_bh(&conn->taskqueuelock);
 		list_add_tail(&task->running, &conn->cmdqueue);
+		spin_unlock_bh(&conn->taskqueuelock);
 		iscsi_conn_queue_work(conn);
 	}
 
@@ -2896,6 +2919,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	INIT_LIST_HEAD(&conn->mgmtqueue);
 	INIT_LIST_HEAD(&conn->cmdqueue);
 	INIT_LIST_HEAD(&conn->requeue);
+	spin_lock_init(&conn->taskqueuelock);
 	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
 
 	/* allocate login_task used for the login/text sequences */
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index b0e275de6dec..583875ea136a 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -196,6 +196,7 @@ struct iscsi_conn {
 	struct iscsi_task	*task;		/* xmit task in progress */
 
 	/* xmit */
+	spinlock_t		taskqueuelock;  /* protects the next three lists */
 	struct list_head	mgmtqueue;	/* mgmt (control) xmit queue */
 	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
-- 
2.9.3

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
