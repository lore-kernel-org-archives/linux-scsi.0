From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi/aic7xxx: Convert timers to use timer_setup()
Date: Mon, 9 Oct 2017 17:15:46 -0700
Message-ID: <20171010001546.GA120288@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

stat_timer only ever assigns the same function and data, so consolidate
to using timer_setup(), adjust callback, drop everything else used
to pass things around, and remove needless typedefs.

reset_timer is unused; remove it.

Cc: Hannes Reinecke <hare@suse.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This requires commit 686fef928bba ("timer: Prepare to change timer
callback argument type") in v4.14-rc3, but should be otherwise
stand-alone.
---
 drivers/scsi/aic7xxx/aic79xx.h      |  5 +----
 drivers/scsi/aic7xxx/aic79xx_core.c | 29 ++++++++---------------------
 drivers/scsi/aic7xxx/aic79xx_osm.h  |  7 -------
 3 files changed, 9 insertions(+), 32 deletions(-)

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
index 95d8f25cbcca..b560f396ee99 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -207,7 +207,7 @@ static void		ahd_add_scb_to_free_list(struct ahd_softc *ahd,
 static u_int		ahd_rem_wscb(struct ahd_softc *ahd, u_int scbid,
 				     u_int prev, u_int next, u_int tid);
 static void		ahd_reset_current_bus(struct ahd_softc *ahd);
-static ahd_callback_t	ahd_stat_timer;
+static void		ahd_stat_timer(struct timer_list *t);
 #ifdef AHD_DUMP_SEQ
 static void		ahd_dumpseq(struct ahd_softc *ahd);
 #endif
@@ -6104,8 +6104,7 @@ ahd_alloc(void *platform_arg, char *name)
 	ahd->bugs = AHD_BUGNONE;
 	ahd->flags = AHD_SPCHK_ENB_A|AHD_RESET_BUS_A|AHD_TERM_ENB_A
 		   | AHD_EXTENDED_TRANS_A|AHD_STPWLEVEL_A;
-	ahd_timer_init(&ahd->reset_timer);
-	ahd_timer_init(&ahd->stat_timer);
+	timer_setup(&ahd->stat_timer, ahd_stat_timer, 0);
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
+ahd_timer_reset(struct timer_list *timer, int usec)
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
+ahd_stat_timer(struct timer_list *t)
 {
-	struct	ahd_softc *ahd = arg;
+	struct	ahd_softc *ahd = from_timer(ahd, t, stat_timer);
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
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
index 728193a42e6e..8a8b7ae7aed3 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -203,9 +203,6 @@ int	ahd_dmamap_unload(struct ahd_softc *, bus_dma_tag_t, bus_dmamap_t);
  */
 #define ahd_dmamap_sync(ahd, dma_tag, dmamap, offset, len, op)
 
-/************************** Timer DataStructures ******************************/
-typedef struct timer_list ahd_timer_t;
-
 /********************************** Includes **********************************/
 #ifdef CONFIG_AIC79XX_REG_PRETTY_PRINT
 #define AIC_DEBUG_REGISTERS 1
@@ -214,10 +211,6 @@ typedef struct timer_list ahd_timer_t;
 #endif
 #include "aic79xx.h"
 
-/***************************** Timer Facilities *******************************/
-#define ahd_timer_init init_timer
-#define ahd_timer_stop del_timer_sync
-
 /***************************** SMP support ************************************/
 #include <linux/spinlock.h>
 
-- 
2.7.4


-- 
Kees Cook
Pixel Security
