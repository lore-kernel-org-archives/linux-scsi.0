From: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
Subject: [PATCH 06/13] libfc: trivial fc_scsi cleanup
Date: Sun, 29 Jun 2008 13:23:56 -0500
Message-ID: <1214763843-5548-7-git-send-email-michaelc@cs.wisc.edu>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-2-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-3-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-4-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-5-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-6-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1214763843-5548-6-git-send-email-michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

Just mostly static stuff.

1. change allocation flag in fc_scsi_init to GFP_KERNEL since it
has process context.
2. Make functions static when only used in this file.
3. Remove unncessary function declarations - it would be nice to remove
all of them because they are such a pain in the ass to maintain.
4. rename openfc_io_compl to just fc_io_compl.

Signed-off-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
---
 drivers/scsi/libfc/fc_scsi.c |   39 ++++++++++++++++++---------------------
 1 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/libfc/fc_scsi.c b/drivers/scsi/libfc/fc_scsi.c
index ec7f3dd..b9487bf 100644
--- a/drivers/scsi/libfc/fc_scsi.c
+++ b/drivers/scsi/libfc/fc_scsi.c
@@ -163,15 +163,12 @@ static void fc_scsi_timeout(struct fc_scsi_pkt *);
 static void fc_scsi_rec(struct fc_scsi_pkt *);
 static void fc_scsi_rec_error(struct fc_scsi_pkt *, struct fc_frame *);
 static void fc_scsi_rec_resp(struct fc_seq *, struct fc_frame *, void *);
+static void fc_io_compl(struct fc_scsi_pkt *);
 
 static void fc_scsi_srr(struct fc_scsi_pkt *, enum fc_rctl, u32);
 static void fc_scsi_srr_resp(struct fc_seq *, struct fc_frame *, void *);
 static void fc_scsi_srr_error(struct fc_scsi_pkt *, struct fc_frame *);
 
-static void fc_scsi_pkt_hold(struct fc_scsi_pkt *);
-static void fc_scsi_pkt_release(struct fc_scsi_pkt *);
-static int fc_destroy_scsi_slab(struct fc_lport *);
-
 /*
  * command status codes
  */
@@ -199,8 +196,6 @@ static int fc_destroy_scsi_slab(struct fc_lport *);
 
 #define OPENFC_DFLT_QUEUE_DEPTH 32
 
-static void openfc_io_compl(struct fc_scsi_pkt *);
-
 /*
  * function prototypes
  * FC scsi I/O related functions
@@ -253,18 +248,18 @@ static int fc_scsi_pkt_free(struct fc_scsi_pkt *sp)
 	return 0;
 }
 
-void fc_scsi_pkt_hold(struct fc_scsi_pkt *sp)
+static void fc_scsi_pkt_hold(struct fc_scsi_pkt *sp)
 {
 	atomic_inc(&sp->ref_cnt);
 }
 
-void fc_scsi_pkt_release(struct fc_scsi_pkt *sp)
+static void fc_scsi_pkt_release(struct fc_scsi_pkt *sp)
 {
 	fc_scsi_pkt_free(sp);
 }
 
 
-int fc_destroy_scsi_slab(struct fc_lport *lp)
+static int fc_destroy_scsi_slab(struct fc_lport *lp)
 {
 	int rc = -1;
 	struct fc_scsi_internal *si = fc_get_scsi_internal(lp);
@@ -922,7 +917,7 @@ static void fc_scsi_abort_io(struct fc_lport *lp)
  * Context  : called from process context or timer context
  *	      must not be called holding list lock
  */
-int fc_scsi_pkt_send(struct fc_lport *lp, struct fc_scsi_pkt *fsp)
+static int fc_scsi_pkt_send(struct fc_lport *lp, struct fc_scsi_pkt *fsp)
 {
 	u32 idx, i;
 	unsigned long flags;
@@ -1057,7 +1052,7 @@ static void fc_abort_internal(struct fc_scsi_pkt *fsp)
  * Scsi abort handler- calls fcs to send an abort
  * and then wait for abort completion
  */
-int fc_scsi_pkt_abort(struct fc_lport *lp, struct fc_scsi_pkt *fsp)
+static int fc_scsi_pkt_abort(struct fc_lport *lp, struct fc_scsi_pkt *fsp)
 {
 	int rc = FAILED;
 
@@ -1218,7 +1213,7 @@ out:
  * this routine will assume that flogo has happened
  * end we are cleaning all the commands.
  */
-int fc_inf_reset(struct fc_lport *lp, struct fc_scsi_pkt *fsp)
+static int fc_inf_reset(struct fc_lport *lp, struct fc_scsi_pkt *fsp)
 {
 	int idx;
 	unsigned long flags;
@@ -1266,7 +1261,7 @@ static void fc_tm_done(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 	}
 }
 
-void fc_scsi_cleanup(struct fc_lport *lp)
+static void fc_scsi_cleanup(struct fc_lport *lp)
 {
 	int idx;
 	unsigned long flags;
@@ -1329,7 +1324,7 @@ static void fc_scsi_timeout(struct fc_scsi_pkt *fsp)
 /*
  * Send a REC ELS request
  */
-void fc_scsi_rec(struct fc_scsi_pkt *fsp)
+static void fc_scsi_rec(struct fc_scsi_pkt *fsp)
 {
 	struct fc_lport *lp;
 	struct fc_seq *sp;
@@ -1761,7 +1756,7 @@ out:
 }
 
 /**
- * fc_queuecommand: - The queuecommand function of the scsi template
+ * fc_queuecommand - The queuecommand function of the scsi template
  * @cmd:	struct scsi_cmnd to be executed
  * @done:	Callback function to be called when cmd is completed
  *
@@ -1875,7 +1870,7 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 		stats->ControlRequests++;
 	}
 
-	sp->done = openfc_io_compl;
+	sp->done = fc_io_compl;
 	sp->tgt_flags = rp->tgt_flags;
 
 	init_timer(&sp->timer);
@@ -1900,11 +1895,12 @@ out:
 EXPORT_SYMBOL(fc_queuecommand);
 
 /**
- * openfc_io_compl: -  Handle responses for completed  commands
+ * fc_io_compl -  Handle responses for completed  commands
+ * @sp:		scsi packet
  *
  * Translates a openfc error to a Linux SCSI error
  */
-static void openfc_io_compl(struct fc_scsi_pkt *sp)
+static void fc_io_compl(struct fc_scsi_pkt *sp)
 {
 	struct scsi_cmnd *sc_cmd;
 	struct fc_lport *lp;
@@ -2241,8 +2237,8 @@ EXPORT_SYMBOL(fc_change_queue_type);
 
 /**
  * fc_put_dev -	 dec the fc_lport ref count
- * @dev:      Pointer to fc_lport to dec.
- **/
+ * @lp:      Pointer to fc_lport to dec.
+ */
 void fc_put_dev(struct fc_lport *lp)
 {
 	fc_destroy_scsi_slab(lp);
@@ -2263,7 +2259,8 @@ int fc_scsi_init(struct fc_lport *lp,
 	if (!lp->tt.scsi_abort_io)
 		lp->tt.scsi_abort_io = fc_scsi_abort_io;
 	
-	si = (struct fc_scsi_internal*)kzalloc(sizeof(struct fc_scsi_internal), GFP_ATOMIC);
+	si = (struct fc_scsi_internal*)kzalloc(sizeof(struct fc_scsi_internal),
+					       GFP_KERNEL);
 	lp->scsi_priv = (void*)si;
 
 	/*
-- 
1.5.4.1
