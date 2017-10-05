From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi/pmcraid: Convert timers to use timer_setup()
Date: Wed, 4 Oct 2017 17:47:49 -0700
Message-ID: <20171005004749.GA22898@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This requires commit 686fef928bba ("timer: Prepare to change timer
callback argument type") in v4.14-rc3, but should be otherwise
stand-alone.
---
 drivers/scsi/pmcraid.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index b4d6cd8cd1ad..4f9f115fb6a0 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -348,7 +348,7 @@ static void pmcraid_init_cmdblk(struct pmcraid_cmd *cmd, int index)
 	cmd->sense_buffer = NULL;
 	cmd->sense_buffer_dma = 0;
 	cmd->dma_handle = 0;
-	init_timer(&cmd->timer);
+	timer_setup(&cmd->timer, NULL, 0);
 }
 
 /**
@@ -557,8 +557,9 @@ static void pmcraid_reset_type(struct pmcraid_instance *pinstance)
 
 static void pmcraid_ioa_reset(struct pmcraid_cmd *);
 
-static void pmcraid_bist_done(struct pmcraid_cmd *cmd)
+static void pmcraid_bist_done(struct timer_list *t)
 {
+	struct pmcraid_cmd *cmd = from_timer(cmd, t, timer);
 	struct pmcraid_instance *pinstance = cmd->drv_inst;
 	unsigned long lock_flags;
 	int rc;
@@ -572,9 +573,6 @@ static void pmcraid_bist_done(struct pmcraid_cmd *cmd)
 		pmcraid_info("BIST not complete, waiting another 2 secs\n");
 		cmd->timer.expires = jiffies + cmd->time_left;
 		cmd->time_left = 0;
-		cmd->timer.data = (unsigned long)cmd;
-		cmd->timer.function =
-			(void (*)(unsigned long))pmcraid_bist_done;
 		add_timer(&cmd->timer);
 	} else {
 		cmd->time_left = 0;
@@ -605,9 +603,8 @@ static void pmcraid_start_bist(struct pmcraid_cmd *cmd)
 		      doorbells, intrs);
 
 	cmd->time_left = msecs_to_jiffies(PMCRAID_BIST_TIMEOUT);
-	cmd->timer.data = (unsigned long)cmd;
 	cmd->timer.expires = jiffies + msecs_to_jiffies(PMCRAID_BIST_TIMEOUT);
-	cmd->timer.function = (void (*)(unsigned long))pmcraid_bist_done;
+	cmd->timer.function = (TIMER_FUNC_TYPE)pmcraid_bist_done;
 	add_timer(&cmd->timer);
 }
 
@@ -617,8 +614,9 @@ static void pmcraid_start_bist(struct pmcraid_cmd *cmd)
  * Return value
  *  None
  */
-static void pmcraid_reset_alert_done(struct pmcraid_cmd *cmd)
+static void pmcraid_reset_alert_done(struct timer_list *t)
 {
+	struct pmcraid_cmd *cmd = from_timer(cmd, t, timer);
 	struct pmcraid_instance *pinstance = cmd->drv_inst;
 	u32 status = ioread32(pinstance->ioa_status);
 	unsigned long lock_flags;
@@ -637,10 +635,8 @@ static void pmcraid_reset_alert_done(struct pmcraid_cmd *cmd)
 		pmcraid_info("critical op is not yet reset waiting again\n");
 		/* restart timer if some more time is available to wait */
 		cmd->time_left -= PMCRAID_CHECK_FOR_RESET_TIMEOUT;
-		cmd->timer.data = (unsigned long)cmd;
 		cmd->timer.expires = jiffies + PMCRAID_CHECK_FOR_RESET_TIMEOUT;
-		cmd->timer.function =
-			(void (*)(unsigned long))pmcraid_reset_alert_done;
+		cmd->timer.function = (TIMER_FUNC_TYPE)pmcraid_reset_alert_done;
 		add_timer(&cmd->timer);
 	}
 }
@@ -676,10 +672,8 @@ static void pmcraid_reset_alert(struct pmcraid_cmd *cmd)
 		 * bit to be reset.
 		 */
 		cmd->time_left = PMCRAID_RESET_TIMEOUT;
-		cmd->timer.data = (unsigned long)cmd;
 		cmd->timer.expires = jiffies + PMCRAID_CHECK_FOR_RESET_TIMEOUT;
-		cmd->timer.function =
-			(void (*)(unsigned long))pmcraid_reset_alert_done;
+		cmd->timer.function = (TIMER_FUNC_TYPE)pmcraid_reset_alert_done;
 		add_timer(&cmd->timer);
 
 		iowrite32(DOORBELL_IOA_RESET_ALERT,
@@ -704,8 +698,9 @@ static void pmcraid_reset_alert(struct pmcraid_cmd *cmd)
  * Return value:
  *   None
  */
-static void pmcraid_timeout_handler(struct pmcraid_cmd *cmd)
+static void pmcraid_timeout_handler(struct timer_list *t)
 {
+	struct pmcraid_cmd *cmd = from_timer(cmd, t, timer);
 	struct pmcraid_instance *pinstance = cmd->drv_inst;
 	unsigned long lock_flags;
 
@@ -919,7 +914,7 @@ static void pmcraid_send_cmd(
 	struct pmcraid_cmd *cmd,
 	void (*cmd_done) (struct pmcraid_cmd *),
 	unsigned long timeout,
-	void (*timeout_func) (struct pmcraid_cmd *)
+	void (*timeout_func) (struct timer_list *)
 )
 {
 	/* initialize done function */
@@ -927,9 +922,8 @@ static void pmcraid_send_cmd(
 
 	if (timeout_func) {
 		/* setup timeout handler */
-		cmd->timer.data = (unsigned long)cmd;
 		cmd->timer.expires = jiffies + timeout;
-		cmd->timer.function = (void (*)(unsigned long))timeout_func;
+		cmd->timer.function = (TIMER_FUNC_TYPE)timeout_func;
 		add_timer(&cmd->timer);
 	}
 
@@ -1955,10 +1949,9 @@ static void pmcraid_soft_reset(struct pmcraid_cmd *cmd)
 	 * would re-initiate a reset
 	 */
 	cmd->cmd_done = pmcraid_ioa_reset;
-	cmd->timer.data = (unsigned long)cmd;
 	cmd->timer.expires = jiffies +
 			     msecs_to_jiffies(PMCRAID_TRANSOP_TIMEOUT);
-	cmd->timer.function = (void (*)(unsigned long))pmcraid_timeout_handler;
+	cmd->timer.function = (TIMER_FUNC_TYPE)pmcraid_timeout_handler;
 
 	if (!timer_pending(&cmd->timer))
 		add_timer(&cmd->timer);
-- 
2.7.4


-- 
Kees Cook
Pixel Security
