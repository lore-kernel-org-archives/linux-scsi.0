From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: ipr: Convert timers to use timer_setup()
Date: Wed, 25 Oct 2017 03:06:15 -0700
Message-ID: <20171025100615.GA145041@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Brian King <brking@us.ibm.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/ipr.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index f838bd73befa..d53429371127 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -694,7 +694,7 @@ static void ipr_init_ipr_cmnd(struct ipr_cmnd *ipr_cmd,
 	ipr_cmd->sibling = NULL;
 	ipr_cmd->eh_comp = NULL;
 	ipr_cmd->fast_done = fast_done;
-	init_timer(&ipr_cmd->timer);
+	timer_setup(&ipr_cmd->timer, NULL, 0);
 }
 
 /**
@@ -990,15 +990,14 @@ static void ipr_send_command(struct ipr_cmnd *ipr_cmd)
  **/
 static void ipr_do_req(struct ipr_cmnd *ipr_cmd,
 		       void (*done) (struct ipr_cmnd *),
-		       void (*timeout_func) (struct ipr_cmnd *), u32 timeout)
+		       void (*timeout_func) (struct timer_list *), u32 timeout)
 {
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_pending_q);
 
 	ipr_cmd->done = done;
 
-	ipr_cmd->timer.data = (unsigned long) ipr_cmd;
 	ipr_cmd->timer.expires = jiffies + timeout;
-	ipr_cmd->timer.function = (void (*)(unsigned long))timeout_func;
+	ipr_cmd->timer.function = (TIMER_FUNC_TYPE)timeout_func;
 
 	add_timer(&ipr_cmd->timer);
 
@@ -1080,7 +1079,7 @@ static void ipr_init_ioadl(struct ipr_cmnd *ipr_cmd, dma_addr_t dma_addr,
  * 	none
  **/
 static void ipr_send_blocking_cmd(struct ipr_cmnd *ipr_cmd,
-				  void (*timeout_func) (struct ipr_cmnd *ipr_cmd),
+				  void (*timeout_func) (struct timer_list *),
 				  u32 timeout)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
@@ -2664,8 +2663,9 @@ static void ipr_process_error(struct ipr_cmnd *ipr_cmd)
  * Return value:
  * 	none
  **/
-static void ipr_timeout(struct ipr_cmnd *ipr_cmd)
+static void ipr_timeout(struct timer_list *t)
 {
+	struct ipr_cmnd *ipr_cmd = from_timer(ipr_cmd, t, timer);
 	unsigned long lock_flags = 0;
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
@@ -2696,8 +2696,9 @@ static void ipr_timeout(struct ipr_cmnd *ipr_cmd)
  * Return value:
  * 	none
  **/
-static void ipr_oper_timeout(struct ipr_cmnd *ipr_cmd)
+static void ipr_oper_timeout(struct timer_list *t)
 {
+	struct ipr_cmnd *ipr_cmd = from_timer(ipr_cmd, t, timer);
 	unsigned long lock_flags = 0;
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
@@ -5449,8 +5450,9 @@ static void ipr_bus_reset_done(struct ipr_cmnd *ipr_cmd)
  * Return value:
  *	none
  **/
-static void ipr_abort_timeout(struct ipr_cmnd *ipr_cmd)
+static void ipr_abort_timeout(struct timer_list *t)
 {
+	struct ipr_cmnd *ipr_cmd = from_timer(ipr_cmd, t, timer);
 	struct ipr_cmnd *reset_cmd;
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	struct ipr_cmd_pkt *cmd_pkt;
@@ -8271,8 +8273,9 @@ static int ipr_ioafp_identify_hrrq(struct ipr_cmnd *ipr_cmd)
  * Return value:
  * 	none
  **/
-static void ipr_reset_timer_done(struct ipr_cmnd *ipr_cmd)
+static void ipr_reset_timer_done(struct timer_list *t)
 {
+	struct ipr_cmnd *ipr_cmd = from_timer(ipr_cmd, t, timer);
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	unsigned long lock_flags = 0;
 
@@ -8308,9 +8311,8 @@ static void ipr_reset_start_timer(struct ipr_cmnd *ipr_cmd,
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_pending_q);
 	ipr_cmd->done = ipr_reset_ioa_job;
 
-	ipr_cmd->timer.data = (unsigned long) ipr_cmd;
 	ipr_cmd->timer.expires = jiffies + timeout;
-	ipr_cmd->timer.function = (void (*)(unsigned long))ipr_reset_timer_done;
+	ipr_cmd->timer.function = (TIMER_FUNC_TYPE)ipr_reset_timer_done;
 	add_timer(&ipr_cmd->timer);
 }
 
@@ -8394,9 +8396,8 @@ static int ipr_reset_next_stage(struct ipr_cmnd *ipr_cmd)
 		}
 	}
 
-	ipr_cmd->timer.data = (unsigned long) ipr_cmd;
 	ipr_cmd->timer.expires = jiffies + stage_time * HZ;
-	ipr_cmd->timer.function = (void (*)(unsigned long))ipr_oper_timeout;
+	ipr_cmd->timer.function = (TIMER_FUNC_TYPE)ipr_oper_timeout;
 	ipr_cmd->done = ipr_reset_ioa_job;
 	add_timer(&ipr_cmd->timer);
 
@@ -8466,9 +8467,8 @@ static int ipr_reset_enable_ioa(struct ipr_cmnd *ipr_cmd)
 		return IPR_RC_JOB_CONTINUE;
 	}
 
-	ipr_cmd->timer.data = (unsigned long) ipr_cmd;
 	ipr_cmd->timer.expires = jiffies + (ioa_cfg->transop_timeout * HZ);
-	ipr_cmd->timer.function = (void (*)(unsigned long))ipr_oper_timeout;
+	ipr_cmd->timer.function = (TIMER_FUNC_TYPE)ipr_oper_timeout;
 	ipr_cmd->done = ipr_reset_ioa_job;
 	add_timer(&ipr_cmd->timer);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_pending_q);
-- 
2.7.4


-- 
Kees Cook
Pixel Security
