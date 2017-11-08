From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 1/3] zfcp: convert timers to use timer_setup()
Date: Wed,  8 Nov 2017 15:17:07 +0100
Message-ID: <20171108141709.79074-2-maier@linux.vnet.ibm.com>
References: <20171108141709.79074-1-maier@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171108141709.79074-1-maier@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Kees Cook <keescook@chromium.org>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
[maier@linux.vnet.ibm.com:
 depends on v4.14-rc3 686fef928bba ("timer: Prepare to change timer callback argument type"),
 rebased onto v4.14-rc7 ab31fd0ce65e ("scsi: zfcp: fix erp_action use-before-initialize in REC action trace")]
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_erp.c | 16 ++++++++++------
 drivers/s390/scsi/zfcp_ext.h |  2 +-
 drivers/s390/scsi/zfcp_fsf.c | 13 ++++++-------
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index cbb8156bf5e0..822a852d578e 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -56,6 +56,8 @@ enum zfcp_erp_act_result {
 	ZFCP_ERP_NOMEM     = 5,
 };
 
+static void zfcp_erp_memwait_handler(struct timer_list *t);
+
 static void zfcp_erp_adapter_block(struct zfcp_adapter *adapter, int mask)
 {
 	zfcp_erp_clear_adapter_status(adapter,
@@ -237,6 +239,7 @@ static struct zfcp_erp_action *zfcp_erp_setup_act(int need, u32 act_status,
 	erp_action->fsf_req_id = 0;
 	erp_action->action = need;
 	erp_action->status = act_status;
+	timer_setup(&erp_action->timer, zfcp_erp_memwait_handler, 0);
 
 	return erp_action;
 }
@@ -564,21 +567,22 @@ void zfcp_erp_notify(struct zfcp_erp_action *erp_action, unsigned long set_mask)
  * zfcp_erp_timeout_handler - Trigger ERP action from timed out ERP request
  * @data: ERP action (from timer data)
  */
-void zfcp_erp_timeout_handler(unsigned long data)
+void zfcp_erp_timeout_handler(struct timer_list *t)
 {
-	struct zfcp_erp_action *act = (struct zfcp_erp_action *) data;
+	struct zfcp_fsf_req *fsf_req = from_timer(fsf_req, t, timer);
+	struct zfcp_erp_action *act = fsf_req->erp_action;
 	zfcp_erp_notify(act, ZFCP_STATUS_ERP_TIMEDOUT);
 }
 
-static void zfcp_erp_memwait_handler(unsigned long data)
+static void zfcp_erp_memwait_handler(struct timer_list *t)
 {
-	zfcp_erp_notify((struct zfcp_erp_action *)data, 0);
+	struct zfcp_erp_action *act = from_timer(act, t, timer);
+
+	zfcp_erp_notify(act, 0);
 }
 
 static void zfcp_erp_strategy_memwait(struct zfcp_erp_action *erp_action)
 {
-	setup_timer(&erp_action->timer, zfcp_erp_memwait_handler,
-		    (unsigned long) erp_action);
 	erp_action->timer.expires = jiffies + HZ;
 	add_timer(&erp_action->timer);
 }
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 8ca2ab7deaa9..978a0d596f68 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -69,7 +69,7 @@ extern int  zfcp_erp_thread_setup(struct zfcp_adapter *);
 extern void zfcp_erp_thread_kill(struct zfcp_adapter *);
 extern void zfcp_erp_wait(struct zfcp_adapter *);
 extern void zfcp_erp_notify(struct zfcp_erp_action *, unsigned long);
-extern void zfcp_erp_timeout_handler(unsigned long);
+extern void zfcp_erp_timeout_handler(struct timer_list *);
 
 /* zfcp_fc.c */
 extern struct kmem_cache *zfcp_fc_req_cache;
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 00fb98f7b2cd..6f437df1995f 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -21,9 +21,10 @@
 
 struct kmem_cache *zfcp_fsf_qtcb_cache;
 
-static void zfcp_fsf_request_timeout_handler(unsigned long data)
+static void zfcp_fsf_request_timeout_handler(struct timer_list *t)
 {
-	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
+	struct zfcp_fsf_req *fsf_req = from_timer(fsf_req, t, timer);
+	struct zfcp_adapter *adapter = fsf_req->adapter;
 	zfcp_qdio_siosl(adapter);
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
 				"fsrth_1");
@@ -32,8 +33,7 @@ static void zfcp_fsf_request_timeout_handler(unsigned long data)
 static void zfcp_fsf_start_timer(struct zfcp_fsf_req *fsf_req,
 				 unsigned long timeout)
 {
-	fsf_req->timer.function = zfcp_fsf_request_timeout_handler;
-	fsf_req->timer.data = (unsigned long) fsf_req->adapter;
+	fsf_req->timer.function = (TIMER_FUNC_TYPE)zfcp_fsf_request_timeout_handler;
 	fsf_req->timer.expires = jiffies + timeout;
 	add_timer(&fsf_req->timer);
 }
@@ -41,8 +41,7 @@ static void zfcp_fsf_start_timer(struct zfcp_fsf_req *fsf_req,
 static void zfcp_fsf_start_erp_timer(struct zfcp_fsf_req *fsf_req)
 {
 	BUG_ON(!fsf_req->erp_action);
-	fsf_req->timer.function = zfcp_erp_timeout_handler;
-	fsf_req->timer.data = (unsigned long) fsf_req->erp_action;
+	fsf_req->timer.function = (TIMER_FUNC_TYPE)zfcp_erp_timeout_handler;
 	fsf_req->timer.expires = jiffies + 30 * HZ;
 	add_timer(&fsf_req->timer);
 }
@@ -692,7 +691,7 @@ static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_qdio *qdio,
 		adapter->req_no++;
 
 	INIT_LIST_HEAD(&req->list);
-	init_timer(&req->timer);
+	timer_setup(&req->timer, NULL, 0);
 	init_completion(&req->completion);
 
 	req->adapter = adapter;
-- 
2.13.5
