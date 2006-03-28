From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 05/10] Disable sym2 driver queueing
Date: Tue, 28 Mar 2006 11:03:44 -0500
Message-ID: <11435618244044-git-send-email-matthew@wil.cx>
Reply-To: Matthew Wilcox <matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.magma.ca ([206.191.0.250]:35254 "EHLO mx2.magma.ca")
	by vger.kernel.org with ESMTP id S1751197AbWC1QDa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 11:03:30 -0500
In-Reply-To: 20060328160156.GJ3486@parisc-linux.org
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Undef SYM_OPT_HANDLE_DEVICE_QUEUEING.
Call sym_put_start_queue instead of sym_start_next_ccbs.
Turn asserts into checks that we can send the command to the adapter,
and return busy from queuecommand if we can't.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_glue.c |    9 ++-------
 drivers/scsi/sym53c8xx_2/sym_glue.h |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    8 +++++---
 drivers/scsi/sym53c8xx_2/sym_hipd.h |    2 ++
 4 files changed, 10 insertions(+), 11 deletions(-)

13704a642bed748fb0f6c9999bc8c6fdfba917d5
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 052ce11..a27dd66 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -475,8 +475,6 @@ static inline int sym_setup_cdb(struct s
  */
 int sym_setup_data_and_start(struct sym_hcb *np, struct scsi_cmnd *cmd, struct sym_ccb *cp)
 {
-	struct sym_tcb *tp = &np->target[cp->target];
-	struct sym_lcb *lp = sym_lp(tp, cp->lun);
 	u32 lastp, goalp;
 	int dir;
 
@@ -557,7 +555,7 @@ int sym_setup_data_and_start(struct sym_
 	/*
 	 *	activate this job.
 	 */
-	sym_start_next_ccbs(np, lp, 2);
+	sym_put_start_queue(np, cp);
 	return 0;
 
 out_abort:
@@ -871,15 +869,12 @@ static void sym_tune_dev_queuing(struct 
 	if (reqtags > lp->s.scdev_depth)
 		reqtags = lp->s.scdev_depth;
 
-	lp->started_limit = reqtags ? reqtags : 2;
-	lp->started_max   = 1;
 	lp->s.reqtags     = reqtags;
 
 	if (reqtags != oldtags) {
 		dev_info(&tp->starget->dev,
 		         "tagged command queuing %s, command queue depth %d.\n",
-		          lp->s.reqtags ? "enabled" : "disabled",
- 		          lp->started_limit);
+		          lp->s.reqtags ? "enabled" : "disabled", reqtags);
 	}
 }
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
index cc92d0c..a446cda 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -68,7 +68,7 @@
  */
 #define	SYM_CONF_TIMER_INTERVAL		((HZ+1)/2)
 
-#define SYM_OPT_HANDLE_DEVICE_QUEUEING
+#undef SYM_OPT_HANDLE_DEVICE_QUEUEING
 #define SYM_OPT_LIMIT_COMMAND_REORDERING
 
 /*
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index b2ac482..a6cbb90 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -1469,7 +1469,7 @@ static int sym_prepare_nego(struct sym_h
 /*
  *  Insert a job into the start queue.
  */
-static void sym_put_start_queue(struct sym_hcb *np, struct sym_ccb *cp)
+void sym_put_start_queue(struct sym_hcb *np, struct sym_ccb *cp)
 {
 	u_short	qidx;
 
@@ -4602,7 +4602,8 @@ struct sym_ccb *sym_get_ccb (struct sym_
 			 *  Debugging purpose.
 			 */
 #ifndef SYM_OPT_HANDLE_DEVICE_QUEUEING
-			assert(lp->busy_itl == 0);
+			if (lp->busy_itl != 0)
+				goto out_free;
 #endif
 			/*
 			 *  Allocate resources for tags if not yet.
@@ -4647,7 +4648,8 @@ struct sym_ccb *sym_get_ccb (struct sym_
 			 *  Debugging purpose.
 			 */
 #ifndef SYM_OPT_HANDLE_DEVICE_QUEUEING
-			assert(lp->busy_itl == 0 && lp->busy_itlq == 0);
+			if (lp->busy_itl != 0 || lp->busy_itlq != 0)
+				goto out_free;
 #endif
 			/*
 			 *  Count this nexus for this LUN.
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 2456090..79ab6a1 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -1049,6 +1049,8 @@ int sym_reset_scsi_bus(struct sym_hcb *n
 struct sym_chip *sym_lookup_chip_table(u_short device_id, u_char revision);
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 void sym_start_next_ccbs(struct sym_hcb *np, struct sym_lcb *lp, int maxn);
+#else
+void sym_put_start_queue(struct sym_hcb *np, struct sym_ccb *cp);
 #endif
 void sym_start_up(struct sym_hcb *np, int reason);
 void sym_interrupt(struct sym_hcb *np);
-- 
1.2.4.g375a5


