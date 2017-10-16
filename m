From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: dc395x: Convert timers to use timer_setup()
Date: Mon, 16 Oct 2017 16:54:53 -0700
Message-ID: <20171016235453.GA102593@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
Cc: Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, dc395x@twibble.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Oliver Neukum <oliver@neukum.org>
Cc: Ali Akcaagac <aliakc@web.de>
Cc: Jamie Lenehan <lenehan@twibble.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: dc395x@twibble.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/dc395x.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 5ee7f44cf869..60ef8df42b95 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -395,7 +395,7 @@ static void request_sense(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb);
 static void set_xfer_rate(struct AdapterCtlBlk *acb,
 		struct DeviceCtlBlk *dcb);
-static void waiting_timeout(unsigned long ptr);
+static void waiting_timeout(struct timer_list *t);
 
 
 /*---------------------------------------------------------------------------
@@ -857,9 +857,6 @@ static void waiting_set_timer(struct AdapterCtlBlk *acb, unsigned long to)
 {
 	if (timer_pending(&acb->waiting_timer))
 		return;
-	init_timer(&acb->waiting_timer);
-	acb->waiting_timer.function = waiting_timeout;
-	acb->waiting_timer.data = (unsigned long) acb;
 	if (time_before(jiffies + to, acb->last_reset - HZ / 2))
 		acb->waiting_timer.expires =
 		    acb->last_reset - HZ / 2 + 1;
@@ -936,10 +933,10 @@ static void waiting_process_next(struct AdapterCtlBlk *acb)
 
 
 /* Wake up waiting queue */
-static void waiting_timeout(unsigned long ptr)
+static void waiting_timeout(struct timer_list *t)
 {
 	unsigned long flags;
-	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)ptr;
+	struct AdapterCtlBlk *acb = from_timer(acb, t, waiting_timer);
 	dprintkdbg(DBG_1,
 		"waiting_timeout: Queue woken up by timer. acb=%p\n", acb);
 	DC395x_LOCK_IO(acb->scsi_host, flags);
@@ -4366,8 +4363,8 @@ static void adapter_init_params(struct AdapterCtlBlk *acb)
 	INIT_LIST_HEAD(&acb->srb_free_list);
 	/*  temp SRB for Q tag used or abort command used  */
 	acb->tmp_srb = &acb->srb;
-	init_timer(&acb->waiting_timer);
-	init_timer(&acb->selto_timer);
+	timer_setup(&acb->waiting_timer, waiting_timeout, 0);
+	timer_setup(&acb->selto_timer, NULL, 0);
 
 	acb->srb_count = DC395x_MAX_SRB_CNT;
 
-- 
2.7.4


-- 
Kees Cook
Pixel Security
