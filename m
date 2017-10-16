From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: libfc: Convert timers to use timer_setup()
Date: Mon, 16 Oct 2017 16:54:10 -0700
Message-ID: <20171016235410.GA102502@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
Cc: Johannes Thumshirn <jth@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly. This removes several redundant setup
calls in favor of just changing the timer function directly.

Cc: Johannes Thumshirn <jth@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: fcoe-devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/libfc/fc_fcp.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 772c35a5c49e..1a4e701a8449 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -97,7 +97,7 @@ static void fc_fcp_complete_locked(struct fc_fcp_pkt *);
 static void fc_tm_done(struct fc_seq *, struct fc_frame *, void *);
 static void fc_fcp_error(struct fc_fcp_pkt *, struct fc_frame *);
 static void fc_fcp_recovery(struct fc_fcp_pkt *, u8 code);
-static void fc_fcp_timeout(unsigned long);
+static void fc_fcp_timeout(struct timer_list *);
 static void fc_fcp_rec(struct fc_fcp_pkt *);
 static void fc_fcp_rec_error(struct fc_fcp_pkt *, struct fc_frame *);
 static void fc_fcp_rec_resp(struct fc_seq *, struct fc_frame *, void *);
@@ -155,8 +155,7 @@ static struct fc_fcp_pkt *fc_fcp_pkt_alloc(struct fc_lport *lport, gfp_t gfp)
 		fsp->lp = lport;
 		fsp->xfer_ddp = FC_XID_UNKNOWN;
 		refcount_set(&fsp->ref_cnt, 1);
-		init_timer(&fsp->timer);
-		fsp->timer.data = (unsigned long)fsp;
+		timer_setup(&fsp->timer, NULL, 0);
 		INIT_LIST_HEAD(&fsp->list);
 		spin_lock_init(&fsp->scsi_pkt_lock);
 	} else {
@@ -1215,7 +1214,7 @@ static int fc_fcp_cmd_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 	fsp->seq_ptr = seq;
 	fc_fcp_pkt_hold(fsp);	/* hold for fc_fcp_pkt_destroy */
 
-	setup_timer(&fsp->timer, fc_fcp_timeout, (unsigned long)fsp);
+	fsp->timer.function = (TIMER_FUNC_TYPE)fc_fcp_timeout;
 	if (rpriv->flags & FC_RP_FLAGS_REC_SUPPORTED)
 		fc_fcp_timer_set(fsp, get_fsp_rec_tov(fsp));
 
@@ -1298,9 +1297,9 @@ static int fc_fcp_pkt_abort(struct fc_fcp_pkt *fsp)
  * fc_lun_reset_send() - Send LUN reset command
  * @data: The FCP packet that identifies the LUN to be reset
  */
-static void fc_lun_reset_send(unsigned long data)
+static void fc_lun_reset_send(struct timer_list *t)
 {
-	struct fc_fcp_pkt *fsp = (struct fc_fcp_pkt *)data;
+	struct fc_fcp_pkt *fsp = from_timer(fsp, t, timer);
 	struct fc_lport *lport = fsp->lp;
 
 	if (lport->tt.fcp_cmd_send(lport, fsp, fc_tm_done)) {
@@ -1308,7 +1307,7 @@ static void fc_lun_reset_send(unsigned long data)
 			return;
 		if (fc_fcp_lock_pkt(fsp))
 			return;
-		setup_timer(&fsp->timer, fc_lun_reset_send, (unsigned long)fsp);
+		fsp->timer.function = (TIMER_FUNC_TYPE)fc_lun_reset_send;
 		fc_fcp_timer_set(fsp, get_fsp_rec_tov(fsp));
 		fc_fcp_unlock_pkt(fsp);
 	}
@@ -1334,7 +1333,7 @@ static int fc_lun_reset(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 	fsp->wait_for_comp = 1;
 	init_completion(&fsp->tm_done);
 
-	fc_lun_reset_send((unsigned long)fsp);
+	fc_lun_reset_send(&fsp->timer);
 
 	/*
 	 * wait for completion of reset
@@ -1431,9 +1430,9 @@ static void fc_fcp_cleanup(struct fc_lport *lport)
  * received we see if data was received recently. If it has been then we
  * continue waiting, otherwise, we abort the command.
  */
-static void fc_fcp_timeout(unsigned long data)
+static void fc_fcp_timeout(struct timer_list *t)
 {
-	struct fc_fcp_pkt *fsp = (struct fc_fcp_pkt *)data;
+	struct fc_fcp_pkt *fsp = from_timer(fsp, t, timer);
 	struct fc_rport *rport = fsp->rport;
 	struct fc_rport_libfc_priv *rpriv = rport->dd_data;
 
@@ -1446,7 +1445,7 @@ static void fc_fcp_timeout(unsigned long data)
 	if (fsp->lp->qfull) {
 		FC_FCP_DBG(fsp, "fcp timeout, resetting timer delay %d\n",
 			   fsp->timer_delay);
-		setup_timer(&fsp->timer, fc_fcp_timeout, (unsigned long)fsp);
+		fsp->timer.function = (TIMER_FUNC_TYPE)fc_fcp_timeout;
 		fc_fcp_timer_set(fsp, fsp->timer_delay);
 		goto unlock;
 	}
-- 
2.7.4


-- 
Kees Cook
Pixel Security
