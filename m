From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 08/10] Simplify error handling
Date: Tue, 28 Mar 2006 11:03:44 -0500
Message-ID: <1143561824743-git-send-email-matthew@wil.cx>
Reply-To: Matthew Wilcox <matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.magmacom.com ([206.191.0.217]:61887 "EHLO mx1.magmacom.com")
	by vger.kernel.org with ESMTP id S1751206AbWC1QDb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 11:03:31 -0500
In-Reply-To: 20060328160156.GJ3486@parisc-linux.org
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Use wait_for_completion_timeout() instead of using a timer (as
Christoph Hellwig did for aic7xxx).

That lets me eliminate the sym_eh_wait structure; the struct completion,
the old_done pointer and the to_do flag can be folded into the sym_ucmd
(which overrides the scsi_pointer in scsi_cmnd).

The sym_eh_done() function becomes much simpler as the timeout handling
is done in sym_eh_handler() directly.

The host_lock can be unlocked earlier, and I cache the host in
a local variable to make accesses to it quicker.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_glue.c |   84 +++++++++--------------------------
 1 files changed, 22 insertions(+), 62 deletions(-)

af228733a867db9f4eaf37002667932a247cfc9f
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index a27dd66..e48409e 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -137,24 +137,14 @@ static void sym2_setup_params(void)
 static struct scsi_transport_template *sym2_transport_template = NULL;
 
 /*
- *  Used by the eh thread to wait for command completion.
- *  It is allocated on the eh thread stack.
- */
-struct sym_eh_wait {
-	struct completion done;
-	struct timer_list timer;
-	void (*old_done)(struct scsi_cmnd *);
-	int to_do;
-	int timed_out;
-};
-
-/*
  *  Driver private area in the SCSI command structure.
  */
 struct sym_ucmd {		/* Override the SCSI pointer structure */
+	struct completion done;
+	void (*old_done)(struct scsi_cmnd *);
 	dma_addr_t data_mapping;
-	u_char	data_mapped;
-	struct sym_eh_wait *eh_wait;
+	int to_do;
+	u_char data_mapped; /* corresponds to data_mapping above */
 };
 
 #define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)(&(cmd)->SCp))
@@ -713,55 +703,35 @@ static void sym53c8xx_timer(unsigned lon
 #define SYM_EH_DO_WAIT		2
 
 /*
- *  Our general completion handler.
+ *  scsi_done() alias when error recovery is in progress.
  */
-static void __sym_eh_done(struct scsi_cmnd *cmd, int timed_out)
+static void sym_eh_done(struct scsi_cmnd *cmd)
 {
-	struct sym_eh_wait *ep = SYM_UCMD_PTR(cmd)->eh_wait;
-	if (!ep)
-		return;
-
-	/* Try to avoid a race here (not 100% safe) */
-	if (!timed_out) {
-		ep->timed_out = 0;
-		if (ep->to_do == SYM_EH_DO_WAIT && !del_timer(&ep->timer))
-			return;
-	}
+	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
+	BUILD_BUG_ON(sizeof(struct scsi_pointer) < sizeof(struct sym_ucmd));
 
-	/* Revert everything */
-	SYM_UCMD_PTR(cmd)->eh_wait = NULL;
-	cmd->scsi_done = ep->old_done;
+	cmd->scsi_done = ucmd->old_done;
 
-	/* Wake up the eh thread if it wants to sleep */
-	if (ep->to_do == SYM_EH_DO_WAIT)
-		complete(&ep->done);
+	if (ucmd->to_do == SYM_EH_DO_WAIT)
+		complete(&ucmd->done);
 }
 
 /*
- *  scsi_done() alias when error recovery is in progress. 
- */
-static void sym_eh_done(struct scsi_cmnd *cmd) { __sym_eh_done(cmd, 0); }
-
-/*
- *  Some timeout handler to avoid waiting too long.
- */
-static void sym_eh_timeout(u_long p) { __sym_eh_done((struct scsi_cmnd *)p, 1); }
-
-/*
  *  Generic method for our eh processing.
  *  The 'op' argument tells what we have to do.
  */
 static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 {
 	struct sym_hcb *np = SYM_SOFTC_PTR(cmd);
+	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
+	struct Scsi_Host *host = cmd->device->host;
 	SYM_QUEHEAD *qp;
 	int to_do = SYM_EH_DO_IGNORE;
 	int sts = -1;
-	struct sym_eh_wait eh, *ep = &eh;
 
 	dev_warn(&cmd->device->sdev_gendev, "%s operation started.\n", opname);
 
-	spin_lock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(host->host_lock);
 	/* This one is queued in some place -> to wait for completion */
 	FOR_EACH_QUEUED_ELEMENT(&np->busy_ccbq, qp) {
 		struct sym_ccb *cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
@@ -772,10 +742,9 @@ static int sym_eh_handler(int op, char *
 	}
 
 	if (to_do == SYM_EH_DO_WAIT) {
-		init_completion(&ep->done);
-		ep->old_done = cmd->scsi_done;
+		init_completion(&ucmd->done);
+		ucmd->old_done = cmd->scsi_done;
 		cmd->scsi_done = sym_eh_done;
-		SYM_UCMD_PTR(cmd)->eh_wait = ep;
 	}
 
 	/* Try to proceed the operation we have been asked for */
@@ -802,28 +771,19 @@ static int sym_eh_handler(int op, char *
 
 	/* On error, restore everything and cross fingers :) */
 	if (sts) {
-		SYM_UCMD_PTR(cmd)->eh_wait = NULL;
-		cmd->scsi_done = ep->old_done;
+		cmd->scsi_done = ucmd->old_done;
 		to_do = SYM_EH_DO_IGNORE;
 	}
 
-	ep->to_do = to_do;
+	ucmd->to_do = to_do;
+	spin_unlock_irq(host->host_lock);
 
-	/* Wait for completion with locks released, as required by kernel */
 	if (to_do == SYM_EH_DO_WAIT) {
-		init_timer(&ep->timer);
-		ep->timer.expires = jiffies + (5*HZ);
-		ep->timer.function = sym_eh_timeout;
-		ep->timer.data = (u_long)cmd;
-		ep->timed_out = 1;	/* Be pessimistic for once :) */
-		add_timer(&ep->timer);
-		spin_unlock_irq(np->s.host->host_lock);
-		wait_for_completion(&ep->done);
-		spin_lock_irq(np->s.host->host_lock);
-		if (ep->timed_out)
+		if (!wait_for_completion_timeout(&ucmd->done, 5*HZ)) {
+			ucmd->to_do = SYM_EH_DO_IGNORE;
 			sts = -2;
+		}
 	}
-	spin_unlock_irq(cmd->device->host->host_lock);
 	dev_warn(&cmd->device->sdev_gendev, "%s operation %s.\n", opname,
 			sts==0 ? "complete" :sts==-2 ? "timed-out" : "failed");
 	return sts ? SCSI_FAILED : SCSI_SUCCESS;
-- 
1.2.4.g375a5


