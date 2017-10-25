From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: cxgbi: Convert timers to use timer_setup()
Date: Wed, 25 Oct 2017 03:05:47 -0700
Message-ID: <20171025100547.GA144998@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Karen Xie <kxie@chelsio.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Karen Xie <kxie@chelsio.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c | 8 ++++----
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 8 ++++----
 drivers/scsi/cxgbi/libcxgbi.c      | 2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 7b09e7ddf35e..babd79361a46 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -545,10 +545,10 @@ static int act_open_rpl_status_to_errno(int status)
 	}
 }
 
-static void act_open_retry_timer(unsigned long data)
+static void act_open_retry_timer(struct timer_list *t)
 {
+	struct cxgbi_sock *csk = from_timer(csk, t, retry_timer);
 	struct sk_buff *skb;
-	struct cxgbi_sock *csk = (struct cxgbi_sock *)data;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
 		"csk 0x%p,%u,0x%lx,%u.\n",
@@ -586,8 +586,8 @@ static int do_act_open_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	cxgbi_sock_get(csk);
 	spin_lock_bh(&csk->lock);
 	if (rpl->status == CPL_ERR_CONN_EXIST &&
-	    csk->retry_timer.function != act_open_retry_timer) {
-		csk->retry_timer.function = act_open_retry_timer;
+	    csk->retry_timer.function != (TIMER_FUNC_TYPE)act_open_retry_timer) {
+		csk->retry_timer.function = (TIMER_FUNC_TYPE)act_open_retry_timer;
 		mod_timer(&csk->retry_timer, jiffies + HZ / 2);
 	} else
 		cxgbi_sock_fail_act_open(csk,
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 30d5f0ef29bb..266eddf17a99 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -872,10 +872,10 @@ static int act_open_rpl_status_to_errno(int status)
 	}
 }
 
-static void csk_act_open_retry_timer(unsigned long data)
+static void csk_act_open_retry_timer(struct timer_list *t)
 {
 	struct sk_buff *skb = NULL;
-	struct cxgbi_sock *csk = (struct cxgbi_sock *)data;
+	struct cxgbi_sock *csk = from_timer(csk, t, retry_timer);
 	struct cxgb4_lld_info *lldi = cxgbi_cdev_priv(csk->cdev);
 	void (*send_act_open_func)(struct cxgbi_sock *, struct sk_buff *,
 				   struct l2t_entry *);
@@ -963,8 +963,8 @@ static void do_act_open_rpl(struct cxgbi_device *cdev, struct sk_buff *skb)
 	spin_lock_bh(&csk->lock);
 
 	if (status == CPL_ERR_CONN_EXIST &&
-	    csk->retry_timer.function != csk_act_open_retry_timer) {
-		csk->retry_timer.function = csk_act_open_retry_timer;
+	    csk->retry_timer.function != (TIMER_FUNC_TYPE)csk_act_open_retry_timer) {
+		csk->retry_timer.function = (TIMER_FUNC_TYPE)csk_act_open_retry_timer;
 		mod_timer(&csk->retry_timer, jiffies + HZ / 2);
 	} else
 		cxgbi_sock_fail_act_open(csk,
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 858e32e8ad2d..ce1336414e0a 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -572,7 +572,7 @@ static struct cxgbi_sock *cxgbi_sock_create(struct cxgbi_device *cdev)
 	kref_init(&csk->refcnt);
 	skb_queue_head_init(&csk->receive_queue);
 	skb_queue_head_init(&csk->write_queue);
-	setup_timer(&csk->retry_timer, NULL, (unsigned long)csk);
+	timer_setup(&csk->retry_timer, NULL, 0);
 	rwlock_init(&csk->callback_lock);
 	csk->cdev = cdev;
 	csk->flags = 0;
-- 
2.7.4


-- 
Kees Cook
Pixel Security
