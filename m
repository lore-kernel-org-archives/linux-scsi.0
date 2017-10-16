From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: libiscsi: Convert timers to use timer_setup()
Date: Mon, 16 Oct 2017 16:54:24 -0700
Message-ID: <20171016235424.GA102550@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
Cc: Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Lee Duncan <lduncan@suse.com>
Cc: Chris Leech <cleech@redhat.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: open-iscsi@googlegroups.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/libiscsi.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f8dc1601efd5..9c50d2d9f27c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1805,9 +1805,9 @@ int iscsi_target_alloc(struct scsi_target *starget)
 }
 EXPORT_SYMBOL_GPL(iscsi_target_alloc);
 
-static void iscsi_tmf_timedout(unsigned long data)
+static void iscsi_tmf_timedout(struct timer_list *t)
 {
-	struct iscsi_conn *conn = (struct iscsi_conn *)data;
+	struct iscsi_conn *conn = from_timer(conn, t, tmf_timer);
 	struct iscsi_session *session = conn->session;
 
 	spin_lock(&session->frwd_lock);
@@ -1838,8 +1838,6 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	}
 	conn->tmfcmd_pdus_cnt++;
 	conn->tmf_timer.expires = timeout * HZ + jiffies;
-	conn->tmf_timer.function = iscsi_tmf_timedout;
-	conn->tmf_timer.data = (unsigned long)conn;
 	add_timer(&conn->tmf_timer);
 	ISCSI_DBG_EH(session, "tmf set timeout\n");
 
@@ -2089,9 +2087,9 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 }
 EXPORT_SYMBOL_GPL(iscsi_eh_cmd_timed_out);
 
-static void iscsi_check_transport_timeouts(unsigned long data)
+static void iscsi_check_transport_timeouts(struct timer_list *t)
 {
-	struct iscsi_conn *conn = (struct iscsi_conn *)data;
+	struct iscsi_conn *conn = from_timer(conn, t, transport_timer);
 	struct iscsi_session *session = conn->session;
 	unsigned long recv_timeout, next_timeout = 0, last_recv;
 
@@ -2913,9 +2911,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	conn->exp_statsn = 0;
 	conn->tmf_state = TMF_INITIAL;
 
-	init_timer(&conn->transport_timer);
-	conn->transport_timer.data = (unsigned long)conn;
-	conn->transport_timer.function = iscsi_check_transport_timeouts;
+	timer_setup(&conn->transport_timer, iscsi_check_transport_timeouts, 0);
 
 	INIT_LIST_HEAD(&conn->mgmtqueue);
 	INIT_LIST_HEAD(&conn->cmdqueue);
@@ -2939,7 +2935,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 		goto login_task_data_alloc_fail;
 	conn->login_task->data = conn->data = data;
 
-	init_timer(&conn->tmf_timer);
+	timer_setup(&conn->tmf_timer, iscsi_tmf_timedout, 0);
 	init_waitqueue_head(&conn->ehwait);
 
 	return cls_conn;
-- 
2.7.4


-- 
Kees Cook
Pixel Security
