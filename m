From: akpm@osdl.org
Subject: [patch 1/1] Cleanup namespace collision with ktimers in drivers/scsi/*53c8xx.*
Date: Tue, 25 Oct 2005 10:55:12 -0700
Message-ID: <200510251755.j9PHtd8n021013@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:14807 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932271AbVJYRz6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Oct 2005 13:55:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: willy@debian.org
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, tglx@linutronix.de, James.Bottomley@steeleye.com, mingo@elte.hu


From: Thomas Gleixner <tglx@linutronix.de>

Rename the time related macros in *53c8xx.* to cleanup the namespace
collision introduced by the ktimers patch.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/ncr53c8xx.c      |   22 +++++++++++-----------
 drivers/scsi/sym53c8xx_defs.h |   10 +++++-----
 2 files changed, 16 insertions(+), 16 deletions(-)

diff -puN drivers/scsi/ncr53c8xx.c~cleanup-namespace-collision-with-ktimers-in drivers/scsi/ncr53c8xx.c
--- 25/drivers/scsi/ncr53c8xx.c~cleanup-namespace-collision-with-ktimers-in	Mon Oct 24 15:29:36 2005
+++ 25-akpm/drivers/scsi/ncr53c8xx.c	Mon Oct 24 15:29:36 2005
@@ -3481,8 +3481,8 @@ static int ncr_queue_command (struct ncb
 	**----------------------------------------------------
 	*/
 	if (np->settle_time && cmd->timeout_per_command >= HZ) {
-		u_long tlimit = ktime_get(cmd->timeout_per_command - HZ);
-		if (ktime_dif(np->settle_time, tlimit) > 0)
+		u_long tlimit = Ktime_get(cmd->timeout_per_command - HZ);
+		if (Ktime_dif(np->settle_time, tlimit) > 0)
 			np->settle_time = tlimit;
 	}
 
@@ -3516,7 +3516,7 @@ static int ncr_queue_command (struct ncb
 		**	Force ordered tag if necessary to avoid timeouts 
 		**	and to preserve interactivity.
 		*/
-		if (lp && ktime_exp(lp->tags_stime)) {
+		if (lp && Ktime_exp(lp->tags_stime)) {
 			if (lp->tags_smap) {
 				order = M_ORDERED_TAG;
 				if ((DEBUG_FLAGS & DEBUG_TAGS)||bootverbose>2){ 
@@ -3524,7 +3524,7 @@ static int ncr_queue_command (struct ncb
 						"ordered tag forced.\n");
 				}
 			}
-			lp->tags_stime = ktime_get(3*HZ);
+			lp->tags_stime = Ktime_get(3*HZ);
 			lp->tags_smap = lp->tags_umap;
 		}
 
@@ -3792,7 +3792,7 @@ static int ncr_reset_scsi_bus(struct ncb
 	u32 term;
 	int retv = 0;
 
-	np->settle_time	= ktime_get(settle_delay * HZ);
+	np->settle_time	= Ktime_get(settle_delay * HZ);
 
 	if (bootverbose > 1)
 		printk("%s: resetting, "
@@ -5044,7 +5044,7 @@ static void ncr_setup_tags (struct ncb *
 
 static void ncr_timeout (struct ncb *np)
 {
-	u_long	thistime = ktime_get(0);
+	u_long	thistime = Ktime_get(0);
 
 	/*
 	**	If release process in progress, let's go
@@ -5057,7 +5057,7 @@ static void ncr_timeout (struct ncb *np)
 		return;
 	}
 
-	np->timer.expires = ktime_get(SCSI_NCR_TIMER_INTERVAL);
+	np->timer.expires = Ktime_get(SCSI_NCR_TIMER_INTERVAL);
 	add_timer(&np->timer);
 
 	/*
@@ -5336,8 +5336,8 @@ void ncr_exception (struct ncb *np)
 	**=========================================================
 	*/
 
-	if (ktime_exp(np->regtime)) {
-		np->regtime = ktime_get(10*HZ);
+	if (Ktime_exp(np->regtime)) {
+		np->regtime = Ktime_get(10*HZ);
 		for (i = 0; i<sizeof(np->regdump); i++)
 			((char*)&np->regdump)[i] = INB_OFF(i);
 		np->regdump.nc_dstat = dstat;
@@ -5453,7 +5453,7 @@ static int ncr_int_sbmc (struct ncb *np)
 		**	Suspend command processing for 1 second and 
 		**	reinitialize all except the chip.
 		*/
-		np->settle_time	= ktime_get(1*HZ);
+		np->settle_time	= Ktime_get(1*HZ);
 		ncr_init (np, 0, bootverbose ? "scsi mode change" : NULL, HS_RESET);
 		return 1;
 	}
@@ -6923,7 +6923,7 @@ static struct lcb *ncr_setup_lcb (struct
 		for (i = 0 ; i < MAX_TAGS ; i++)
 			lp->cb_tags[i] = i;
 		lp->maxnxs = MAX_TAGS;
-		lp->tags_stime = ktime_get(3*HZ);
+		lp->tags_stime = Ktime_get(3*HZ);
 		ncr_setup_tags (np, sdev);
 	}
 
diff -puN drivers/scsi/sym53c8xx_defs.h~cleanup-namespace-collision-with-ktimers-in drivers/scsi/sym53c8xx_defs.h
--- 25/drivers/scsi/sym53c8xx_defs.h~cleanup-namespace-collision-with-ktimers-in	Mon Oct 24 15:29:36 2005
+++ 25-akpm/drivers/scsi/sym53c8xx_defs.h	Mon Oct 24 15:29:36 2005
@@ -285,12 +285,12 @@
 **	kernel time values (jiffies) to some that have 
 **	chance not to be too much incorrect. :-)
 */
-#define ktime_get(o)		(jiffies + (u_long) o)
-#define ktime_exp(b)		((long)(jiffies) - (long)(b) >= 0)
-#define ktime_dif(a, b)		((long)(a) - (long)(b))
+#define Ktime_get(o)		(jiffies + (u_long) o)
+#define Ktime_exp(b)		((long)(jiffies) - (long)(b) >= 0)
+#define Ktime_dif(a, b)		((long)(a) - (long)(b))
 /* These ones are not used in this driver */
-#define ktime_add(a, o)		((a) + (u_long)(o))
-#define ktime_sub(a, o)		((a) - (u_long)(o))
+#define Ktime_add(a, o)		((a) + (u_long)(o))
+#define Ktime_sub(a, o)		((a) - (u_long)(o))
 
 
 /*
_
