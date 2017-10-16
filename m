From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi/bnx2i: Convert timers to use timer_setup()
Date: Mon, 16 Oct 2017 16:54:16 -0700
Message-ID: <20171016235416.GA102521@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
Cc: QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

There was a seemingly missing call to initialize the timer in one handler,
so this was added to remove the open-coded initialization.

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/bnx2i/bnx2i.h       |  2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c   |  4 ++--
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 15 ++++-----------
 3 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 89ef1a1678d1..663a63d4dae4 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -858,7 +858,7 @@ extern int bnx2i_alloc_qp_resc(struct bnx2i_hba *hba,
 			       struct bnx2i_endpoint *ep);
 extern void bnx2i_free_qp_resc(struct bnx2i_hba *hba,
 			       struct bnx2i_endpoint *ep);
-extern void bnx2i_ep_ofld_timer(unsigned long data);
+extern void bnx2i_ep_ofld_timer(struct timer_list *t);
 extern struct bnx2i_endpoint *bnx2i_find_ep_in_ofld_list(
 		struct bnx2i_hba *hba, u32 iscsi_cid);
 extern struct bnx2i_endpoint *bnx2i_find_ep_in_destroy_list(
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index e3f22cb4f7fa..e0640e0f259f 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -688,9 +688,9 @@ void bnx2i_update_iscsi_conn(struct iscsi_conn *conn)
  *
  * routine to handle connection offload/destroy request timeout
  */
-void bnx2i_ep_ofld_timer(unsigned long data)
+void bnx2i_ep_ofld_timer(struct timer_list *t)
 {
-	struct bnx2i_endpoint *ep = (struct bnx2i_endpoint *) data;
+	struct bnx2i_endpoint *ep = from_timer(ep, t, ofld_timer);
 
 	if (ep->state == EP_STATE_OFLD_START) {
 		printk(KERN_ALERT "ofld_timer: CONN_OFLD timeout\n");
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 03c104b47f31..de0a507577ef 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1611,9 +1611,8 @@ static int bnx2i_conn_start(struct iscsi_cls_conn *cls_conn)
 	 * this should normally not sleep for a long time so it should
 	 * not disrupt the caller.
 	 */
+	timer_setup(&bnx2i_conn->ep->ofld_timer, bnx2i_ep_ofld_timer, 0);
 	bnx2i_conn->ep->ofld_timer.expires = 1 * HZ + jiffies;
-	bnx2i_conn->ep->ofld_timer.function = bnx2i_ep_ofld_timer;
-	bnx2i_conn->ep->ofld_timer.data = (unsigned long) bnx2i_conn->ep;
 	add_timer(&bnx2i_conn->ep->ofld_timer);
 	/* update iSCSI context for this conn, wait for CNIC to complete */
 	wait_event_interruptible(bnx2i_conn->ep->ofld_wait,
@@ -1729,10 +1728,8 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
 	}
 
 	ep->state = EP_STATE_CLEANUP_START;
-	init_timer(&ep->ofld_timer);
+	timer_setup(&ep->ofld_timer, bnx2i_ep_ofld_timer, 0);
 	ep->ofld_timer.expires = hba->conn_ctx_destroy_tmo + jiffies;
-	ep->ofld_timer.function = bnx2i_ep_ofld_timer;
-	ep->ofld_timer.data = (unsigned long) ep;
 	add_timer(&ep->ofld_timer);
 
 	bnx2i_ep_destroy_list_add(hba, ep);
@@ -1835,10 +1832,8 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 	bnx2i_ep->state = EP_STATE_OFLD_START;
 	bnx2i_ep_ofld_list_add(hba, bnx2i_ep);
 
-	init_timer(&bnx2i_ep->ofld_timer);
+	timer_setup(&bnx2i_ep->ofld_timer, bnx2i_ep_ofld_timer, 0);
 	bnx2i_ep->ofld_timer.expires = 2 * HZ + jiffies;
-	bnx2i_ep->ofld_timer.function = bnx2i_ep_ofld_timer;
-	bnx2i_ep->ofld_timer.data = (unsigned long) bnx2i_ep;
 	add_timer(&bnx2i_ep->ofld_timer);
 
 	if (bnx2i_send_conn_ofld_req(hba, bnx2i_ep)) {
@@ -2054,10 +2049,8 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 		session = conn->session;
 	}
 
-	init_timer(&bnx2i_ep->ofld_timer);
+	timer_setup(&bnx2i_ep->ofld_timer, bnx2i_ep_ofld_timer, 0);
 	bnx2i_ep->ofld_timer.expires = hba->conn_teardown_tmo + jiffies;
-	bnx2i_ep->ofld_timer.function = bnx2i_ep_ofld_timer;
-	bnx2i_ep->ofld_timer.data = (unsigned long) bnx2i_ep;
 	add_timer(&bnx2i_ep->ofld_timer);
 
 	if (!test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic))
-- 
2.7.4


-- 
Kees Cook
Pixel Security
