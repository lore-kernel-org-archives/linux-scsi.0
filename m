From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 18/31] scsi/aic7xxx: Clean up timer usage
Date: Wed, 20 Sep 2017 16:27:42 -0700
Message-ID: <1505950075-50223-19-git-send-email-keescook@chromium.org>
References: <1505950075-50223-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505950075-50223-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

stat_timer only ever assigns the same function and data, so consolidate to
a setup_timer() call and drop everything else used to pass things around.

reset_timer is unused; remove it.

Cc: Hannes Reinecke <hare@suse.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/aic7xxx/aic79xx.h      |  5 +----
 drivers/scsi/aic7xxx/aic79xx_core.c | 29 ++++++++---------------------
 2 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index d47b527b25dd..31f2bb9d7146 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -1046,8 +1046,6 @@ typedef enum {
 
 typedef uint8_t ahd_mode_state;
 
-typedef void ahd_callback_t (void *);
-
 struct ahd_completion
 {
 	uint16_t	tag;
@@ -1122,8 +1120,7 @@ struct ahd_softc {
 	/*
 	 * Timer handles for timer driven callbacks.
 	 */
-	ahd_timer_t		  reset_timer;
-	ahd_timer_t		  stat_timer;
+	struct timer_list	stat_timer;
 
 	/*
 	 * Statistics.
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 95d8f25cbcca..a9fcc40eabcc 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -207,7 +207,7 @@ static void		ahd_add_scb_to_free_list(struct ahd_softc *ahd,
 static u_int		ahd_rem_wscb(struct ahd_softc *ahd, u_int scbid,
 				     u_int prev, u_int next, u_int tid);
 static void		ahd_reset_current_bus(struct ahd_softc *ahd);
-static ahd_callback_t	ahd_stat_timer;
+static void		ahd_stat_timer(unsigned long data);
 #ifdef AHD_DUMP_SEQ
 static void		ahd_dumpseq(struct ahd_softc *ahd);
 #endif
@@ -6104,8 +6104,7 @@ ahd_alloc(void *platform_arg, char *name)
 	ahd->bugs = AHD_BUGNONE;
 	ahd->flags = AHD_SPCHK_ENB_A|AHD_RESET_BUS_A|AHD_TERM_ENB_A
 		   | AHD_EXTENDED_TRANS_A|AHD_STPWLEVEL_A;
-	ahd_timer_init(&ahd->reset_timer);
-	ahd_timer_init(&ahd->stat_timer);
+	setup_timer(&ahd->stat_timer, ahd_stat_timer, (unsigned long)ahd);
 	ahd->int_coalescing_timer = AHD_INT_COALESCING_TIMER_DEFAULT;
 	ahd->int_coalescing_maxcmds = AHD_INT_COALESCING_MAXCMDS_DEFAULT;
 	ahd->int_coalescing_mincmds = AHD_INT_COALESCING_MINCMDS_DEFAULT;
@@ -6235,8 +6234,7 @@ ahd_shutdown(void *arg)
 	/*
 	 * Stop periodic timer callbacks.
 	 */
-	ahd_timer_stop(&ahd->reset_timer);
-	ahd_timer_stop(&ahd->stat_timer);
+	del_timer_sync(&ahd->stat_timer);
 
 	/* This will reset most registers to 0, but not all */
 	ahd_reset(ahd, /*reinit*/FALSE);
@@ -7039,20 +7037,11 @@ static const char *termstat_strings[] = {
 };
 
 /***************************** Timer Facilities *******************************/
-#define ahd_timer_init init_timer
-#define ahd_timer_stop del_timer_sync
-typedef void ahd_linux_callback_t (u_long);
-
 static void
-ahd_timer_reset(ahd_timer_t *timer, int usec, ahd_callback_t *func, void *arg)
+ahd_timer_reset(ahd_timer_t *timer, int usec)
 {
-	struct ahd_softc *ahd;
-
-	ahd = (struct ahd_softc *)arg;
 	del_timer(timer);
-	timer->data = (u_long)arg;
 	timer->expires = jiffies + (usec * HZ)/1000000;
-	timer->function = (ahd_linux_callback_t*)func;
 	add_timer(timer);
 }
 
@@ -7279,8 +7268,7 @@ ahd_init(struct ahd_softc *ahd)
 	}
 init_done:
 	ahd_restart(ahd);
-	ahd_timer_reset(&ahd->stat_timer, AHD_STAT_UPDATE_US,
-			ahd_stat_timer, ahd);
+	ahd_timer_reset(&ahd->stat_timer, AHD_STAT_UPDATE_US);
 	return (0);
 }
 
@@ -8878,9 +8866,9 @@ ahd_reset_channel(struct ahd_softc *ahd, char channel, int initiate_reset)
 
 /**************************** Statistics Processing ***************************/
 static void
-ahd_stat_timer(void *arg)
+ahd_stat_timer(unsigned long data)
 {
-	struct	ahd_softc *ahd = arg;
+	struct	ahd_softc *ahd = (struct ahd_softc *)data;
 	u_long	s;
 	int	enint_coal;
 	
@@ -8907,8 +8895,7 @@ ahd_stat_timer(void *arg)
 	ahd->cmdcmplt_bucket = (ahd->cmdcmplt_bucket+1) & (AHD_STAT_BUCKETS-1);
 	ahd->cmdcmplt_total -= ahd->cmdcmplt_counts[ahd->cmdcmplt_bucket];
 	ahd->cmdcmplt_counts[ahd->cmdcmplt_bucket] = 0;
-	ahd_timer_reset(&ahd->stat_timer, AHD_STAT_UPDATE_US,
-			ahd_stat_timer, ahd);
+	ahd_timer_reset(&ahd->stat_timer, AHD_STAT_UPDATE_US);
 	ahd_unlock(ahd, &s);
 }
 
-- 
2.7.4
