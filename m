From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 2/3] zfcp: purely mechanical update using timer API, plus blank lines
Date: Wed,  8 Nov 2017 15:17:08 +0100
Message-ID: <20171108141709.79074-3-maier@linux.vnet.ibm.com>
References: <20171108141709.79074-1-maier@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171108141709.79074-1-maier@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Kees Cook <keescook@chromium.org>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

erp_memwait only occurs in seldom memory pressure situations.
The typical case never uses the associated timer and thus also
does not need to initialize the timer.
Also, we don't want to re-initialize the timer each time we re-use an
erp_action in zfcp_erp_setup_act() [see also v4.14-rc7 commit ab31fd0ce65e
("scsi: zfcp: fix erp_action use-before-initialize in REC action trace")
for erp_action life cycle].
Hence, retain the lazy inintialization of zfcp_erp_action.timer
in zfcp_erp_strategy_memwait().

Add an empty line after declarations in zfcp_erp_timeout_handler()
and zfcp_fsf_request_timeout_handler() even though it was also missing
before the timer conversion.

Fix checkpatch warning:
WARNING: function definition argument 'struct timer_list *' should also have an identifier name
+extern void zfcp_erp_timeout_handler(struct timer_list *);

Depends-on: v4.14-rc3 commit 686fef928bba ("timer: Prepare to change timer callback argument type")
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_erp.c | 5 ++---
 drivers/s390/scsi/zfcp_ext.h | 2 +-
 drivers/s390/scsi/zfcp_fsf.c | 1 +
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 822a852d578e..1d91a32db08e 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -56,8 +56,6 @@ enum zfcp_erp_act_result {
 	ZFCP_ERP_NOMEM     = 5,
 };
 
-static void zfcp_erp_memwait_handler(struct timer_list *t);
-
 static void zfcp_erp_adapter_block(struct zfcp_adapter *adapter, int mask)
 {
 	zfcp_erp_clear_adapter_status(adapter,
@@ -239,7 +237,6 @@ static struct zfcp_erp_action *zfcp_erp_setup_act(int need, u32 act_status,
 	erp_action->fsf_req_id = 0;
 	erp_action->action = need;
 	erp_action->status = act_status;
-	timer_setup(&erp_action->timer, zfcp_erp_memwait_handler, 0);
 
 	return erp_action;
 }
@@ -571,6 +568,7 @@ void zfcp_erp_timeout_handler(struct timer_list *t)
 {
 	struct zfcp_fsf_req *fsf_req = from_timer(fsf_req, t, timer);
 	struct zfcp_erp_action *act = fsf_req->erp_action;
+
 	zfcp_erp_notify(act, ZFCP_STATUS_ERP_TIMEDOUT);
 }
 
@@ -583,6 +581,7 @@ static void zfcp_erp_memwait_handler(struct timer_list *t)
 
 static void zfcp_erp_strategy_memwait(struct zfcp_erp_action *erp_action)
 {
+	timer_setup(&erp_action->timer, zfcp_erp_memwait_handler, 0);
 	erp_action->timer.expires = jiffies + HZ;
 	add_timer(&erp_action->timer);
 }
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 978a0d596f68..bf8ea4df2bb8 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -69,7 +69,7 @@ extern int  zfcp_erp_thread_setup(struct zfcp_adapter *);
 extern void zfcp_erp_thread_kill(struct zfcp_adapter *);
 extern void zfcp_erp_wait(struct zfcp_adapter *);
 extern void zfcp_erp_notify(struct zfcp_erp_action *, unsigned long);
-extern void zfcp_erp_timeout_handler(struct timer_list *);
+extern void zfcp_erp_timeout_handler(struct timer_list *t);
 
 /* zfcp_fc.c */
 extern struct kmem_cache *zfcp_fc_req_cache;
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 6f437df1995f..51b81c0a0652 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -25,6 +25,7 @@ static void zfcp_fsf_request_timeout_handler(struct timer_list *t)
 {
 	struct zfcp_fsf_req *fsf_req = from_timer(fsf_req, t, timer);
 	struct zfcp_adapter *adapter = fsf_req->adapter;
+
 	zfcp_qdio_siosl(adapter);
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
 				"fsrth_1");
-- 
2.13.5
