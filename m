From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [patch 3/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:04:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4159615D.9070604@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:8394 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267701AbUI1NEh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:04:37 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD4aW02295
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:04:36 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD4am30753
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:04:36 -0700
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Sync up drivers/scsi/aic7xxx/. (2239-2241)

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#171 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c ====
--- /tmp/tmp.26128.0	2004-09-27 12:45:29.333237928 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c	2003-08-05 16:13:18.000000000 -0400
@@ -1,7 +1,7 @@
/*
  * Adaptec AIC79xx device driver for Linux.
  *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#171 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#172 $
  *
  * --------------------------------------------------------------------------
  * Copyright (c) 1994-2000 Justin T. Gibbs.
@@ -473,6 +473,7 @@
static void ahd_linux_filter_inquiry(struct ahd_softc *ahd,
				     struct ahd_devinfo *devinfo);
static void ahd_linux_dev_timed_unfreeze(u_long arg);
+static void ahd_release_simq_locked(struct ahd_softc *ahd);
static void ahd_linux_sem_timeout(u_long arg);
static void ahd_linux_initialize_scsi_bus(struct ahd_softc *ahd);
static void ahd_linux_size_nseg(void);
@@ -848,6 +849,156 @@
#endif
}

+/************************** Error Recovery ************************************/
+static int ahd_linux_recovery_thread(void *arg);
+
+static int
+ahd_linux_recovery_thread(void *arg)
+{
+	struct ahd_softc *ahd;
+	u_long s;
+
+	ahd = (struct ahd_softc *)arg;
+
+	/*
+	 * Complete thread creation.
+	 */
+	lock_kernel();
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,60)
+	/*
+	 * Don't care about any signals.
+	 */
+	siginitsetinv(&current->blocked, 0);
+
+	daemonize();
+	sprintf(current->comm, "ahd_dv_%d", ahd->unit);
+#else
+	daemonize("ahd_recovery_%d", ahd->unit);
+#endif
+	unlock_kernel();
+
+	while (1) {
+
+		/*
+		 * Use down_interruptible() rather than down() to
+		 * avoid inclusion in the load average.
+		 */
+		down_interruptible(&ahd->platform_data->recovery_sem);
+
+		ahd_lock(ahd, &s);
+		if ((ahd->flags & AHD_SHUTDOWN_RECOVERY) != 0) {
+			ahd_unlock(ahd, &s);
+			break;
+		}
+		ahd_unlock(ahd, &s);
+		ahd_recover_commands(ahd);
+	}
+	up(&ahd->platform_data->recovery_ending_sem);
+	return(0);
+}
+
+int
+ahd_spawn_recovery_thread(struct ahd_softc *ahd)
+{
+	ahd->platform_data->recovery_pid =
+	    kernel_thread(ahd_linux_recovery_thread, ahd, 0);
+	return (0);
+}
+
+void
+ahd_terminate_recovery_thread(struct ahd_softc *ahd)
+{
+	u_long s;
+
+	ahd_lock(ahd, &s);
+	if (ahd->platform_data->recovery_pid != 0) {
+		ahd->flags |= AHD_SHUTDOWN_RECOVERY;
+		ahd_unlock(ahd, &s);
+		up(&ahd->platform_data->recovery_sem);
+
+		/*
+		 * Use the recovery_ending_sem as an indicator that
+		 * the dv thread is exiting.  Note that the dv
+		 * thread must still return after performing
+		 * the up on our semaphore before it has
+		 * completely exited this module.  Unfortunately,
+		 * there seems to be no easy way to wait for the
+		 * exit of a thread for which you are not the
+		 * parent (dv threads are parented by init).
+		 * Cross your fingers...
+		 */
+		down(&ahd->platform_data->recovery_ending_sem);
+
+		/*
+		 * Mark the recovery thread as already dead.  This
+		 * avoids attempting to kill it a second time.
+		 * This is necessary because we must kill the
+		 * our threads before calling ahd_free() in the
+		 * module shutdown case to avoid bogus locking
+		 * in the SCSI mid-layer, but when ahd_free() is
+		 * called without killing the DV thread in the
+		 * instance detach case, so ahd_platform_free()
+		 * calls us again to verify that the DV thread
+		 * is dead.
+		 */
+		ahd->platform_data->recovery_pid = 0;
+	} else {
+		ahd_unlock(ahd, &s);
+	}
+}
+
+void
+ahd_set_recoveryscb(struct ahd_softc *ahd, struct scb *scb)
+{
+	if ((scb->flags & SCB_RECOVERY_SCB) == 0) {
+		struct scb *list_scb;
+
+		scb->flags |= SCB_RECOVERY_SCB;
+
+		/*
+		 * Take all queued, but not sent SCBs out of the equation.
+		 * Also ensure that no new commands are queued to us while we
+		 * try to fix this problem.
+		 */
+		if ((scb->platform_data->flags & AHD_RELEASE_SIMQ) == 0) {
+			ahd_freeze_simq(ahd);
+			scb->platform_data->flags |= AHD_RELEASE_SIMQ;
+		}
+
+		/*
+		 * Go through all of our pending SCBs and remove
+		 * any scheduled timeouts for them.  We will reschedule
+		 * them after we've successfully fixed this problem.
+		 */
+		LIST_FOREACH(list_scb, &ahd->pending_scbs, pending_links) {
+
+			scsi_delete_timer(list_scb->io_ctx);
+			scb->platform_data->flags &= ~AHD_TIMEOUT_ACTIVE;
+		}
+	}
+}
+
+void
+ahd_platform_timeout(struct scsi_cmnd *cmd)
+{
+
+	if (AHD_DV_CMD(cmd) == 0) {
+
+		ahd_linux_dv_timeout(cmd);
+	} else {
+		struct	scb *scb;
+
+		scb = (struct scb *)cmd->host_scribble;
+		scb->platform_data->flags &= ~AHD_TIMEOUT_ACTIVE;
+		ahd_timeout(scb);
+	}
+}
+
+void
+ahd_linux_midlayer_timeout(struct scsi_cmnd *cmd)
+{
+}
+/********************** Host Template Entry Points ****************************/
/*
  * Try to detect an Adaptec 79XX controller.
  */
@@ -1027,6 +1178,7 @@
				   cmd->device->id, cmd->device->lun,
				   /*alloc*/TRUE);
	if (dev == NULL) {
+
		ahd_cmd_set_transaction_status(cmd, CAM_RESRC_UNAVAIL);
		ahd_linux_queue_cmd_complete(ahd, cmd);
		ahd_schedule_completeq(ahd);
@@ -1035,8 +1187,23 @@
		       ahd_name(ahd));
		return (0);
	}
-	if (cmd->cmd_len > MAX_CDB_LEN)
-		return (-EINVAL);
+
+	if (cmd->cmd_len > MAX_CDB_LEN) {
+
+		ahd_cmd_set_transaction_status(cmd, CAM_REQ_INVALID);
+		ahd_linux_queue_cmd_complete(ahd, cmd);
+		ahd_schedule_completeq(ahd);
+		ahd_midlayer_entrypoint_unlock(ahd, &flags);
+		printf("%s: aic79xx_linux_queue -"
+		       "CDB length of %d exceeds max!\n",
+		       ahd_name(ahd), cmd->cmd_len);
+	}
+
+	/*
+	 * We perform our own timeout handling.
+	 */
+	scsi_delete_timer(cmd);
+
	cmd->result = CAM_REQ_INPROG << 16;
	TAILQ_INSERT_TAIL(&dev->busyq, (struct ahd_cmd *)cmd, acmd_links.tqe);
	if ((dev->flags & AHD_DEV_ON_RUN_LIST) == 0) {
@@ -1341,6 +1508,17 @@
		       cmd->device->lun);
		TAILQ_REMOVE(&dev->busyq, list_acmd, acmd_links.tqe);
		cmd->result = DID_ABORT << 16;
+		/*
+		 * The completion handler believes that
+		 * commands without active timers running
+		 * have lost the race of completing before
+		 * their timer expires.  Since commands in
+		 * our busy queues do not have timers running,
+		 * appease the mid-layer by adding a timer
+		 * now.  This timer will be immediately
+		 * canceled by the midlayer.
+		 */
+		scsi_add_timer(cmd, 60*HZ, ahd_linux_midlayer_timeout);
		ahd_linux_queue_cmd_complete(ahd, cmd);
		retval = SUCCESS;
		goto done;
@@ -1592,6 +1770,7 @@
	recovery_cmd->host_scribble = (char *)scb;
	scb->io_ctx = recovery_cmd;
	scb->platform_data->dev = dev;
+	scb->platform_data->flags = 0;
	scb->sg_count = 0;
	ahd_set_residual(scb, 0);
	ahd_set_sense_residual(scb, 0);
@@ -2160,7 +2339,7 @@
		 * It is expected that either an external application
		 * or a modified kernel will be used to probe this
		 * ID if it is appropriate.  To accommodate these
-		 * installations, ahc_linux_alloc_target() will allocate
+		 * installations, ahd_linux_alloc_target() will allocate
		 * for our ID if asked to do so.
		 */
		if (target == ahd->our_id)
@@ -2283,10 +2462,14 @@
	init_MUTEX_LOCKED(&ahd->platform_data->eh_sem);
	init_MUTEX_LOCKED(&ahd->platform_data->dv_sem);
	init_MUTEX_LOCKED(&ahd->platform_data->dv_cmd_sem);
+	init_MUTEX_LOCKED(&ahd->platform_data->recovery_sem);
+	init_MUTEX_LOCKED(&ahd->platform_data->recovery_ending_sem);
#else
	ahd->platform_data->eh_sem = MUTEX_LOCKED;
	ahd->platform_data->dv_sem = MUTEX_LOCKED;
	ahd->platform_data->dv_cmd_sem = MUTEX_LOCKED;
+	ahd->platform_data->recovery_sem = MUTEX_LOCKED;
+	ahd->platform_data->recovery_ending_sem = MUTEX_LOCKED;
#endif
	ahd_setup_runq_tasklet(ahd);
	ahd->seltime = (aic79xx_seltime & 0x3) << 4;
@@ -2538,6 +2721,18 @@
					     acmd_links.tqe);
				count++;
				cmd->result = status << 16;
+				/*
+				 * The completion handler believes that
+				 * commands without active timers running
+				 * have lost the race of completing before
+				 * their timer expires.  Since commands in
+				 * our busy queues do not have timers running,
+				 * appease the mid-layer by adding a timer
+				 * now.  This timer will be immediately
+				 * canceled by the midlayer.
+				 */
+				scsi_add_timer(cmd, 60*HZ,
+					       ahd_linux_midlayer_timeout);
				ahd_linux_queue_cmd_complete(ahd, cmd);
			}
		}
@@ -2573,7 +2768,16 @@
#endif

		ahd->platform_data->flags |= AHD_DV_ACTIVE;
+
+		/*
+		 * Prevent upper layer from sending any
+		 * commands to us.
+		 */
		ahd_freeze_simq(ahd);
+		scsi_block_requests(ahd->platform_data->host);
+		ahd_platform_abort_scbs(ahd, CAM_TARGET_WILDCARD, ALL_CHANNELS,
+					CAM_LUN_WILDCARD, SCB_LIST_NULL,
+					ROLE_INITIATOR, CAM_REQUEUE_REQ);

		/* Wake up the DV kthread */
		up(&ahd->platform_data->dv_sem);
@@ -2612,6 +2816,7 @@
	unlock_kernel();

	while (1) {
+
		/*
		 * Use down_interruptible() rather than down() to
		 * avoid inclusion in the load average.
@@ -2660,13 +2865,16 @@

		ahd_lock(ahd, &s);
		ahd->platform_data->flags &= ~AHD_DV_ACTIVE;
-		ahd_unlock(ahd, &s);

		/*
		 * Release the SIMQ so that normal commands are
		 * allowed to continue on the bus.
		 */
-		ahd_release_simq(ahd);
+		ahd_release_simq_locked(ahd);
+
+		ahd_unlock(ahd, &s);
+
+		scsi_unblock_requests(ahd->platform_data->host);
	}
	up(&ahd->platform_data->eh_sem);
	return (0);
@@ -2699,10 +2907,10 @@
		/*
		 * Mark the dv thread as already dead.  This
		 * avoids attempting to kill it a second time.
-		 * This is necessary because we must kill the
-		 * DV thread before calling ahd_free() in the
+		 * This is necessary because we must kill our
+		 * threads before calling ahd_free() in the
		 * module shutdown case to avoid bogus locking
-		 * in the SCSI mid-layer, but we ahd_free() is
+		 * in the SCSI mid-layer, but when ahd_free() is
		 * called without killing the DV thread in the
		 * instance detach case, so ahd_platform_free()
		 * calls us again to verify that the DV thread
@@ -2842,8 +3050,6 @@
		}

		/* Queue the command and wait for it to complete */
-		/* Abuse eh_timeout in the scsi_cmnd struct for our purposes */
-		init_timer(&cmd->eh_timeout);
#ifdef AHD_DEBUG
		if ((ahd_debug & AHD_SHOW_MESSAGES) != 0)
			/*
@@ -2853,7 +3059,9 @@
			 */
			timeout += HZ;
#endif
-		scsi_add_timer(cmd, timeout, ahd_linux_dv_timeout);
+		init_timer(&cmd->eh_timeout);
+		cmd->timeout_per_command = timeout;
+
		/*
		 * In 2.5.X, it is assumed that all calls from the
		 * "midlayer" (which we are emulating) will have the
@@ -4183,6 +4391,7 @@
		if ((dev->flags & AHD_DEV_PERIODIC_OTAG) != 0)
			dev->commands_since_idle_or_otag++;
		scb->flags |= SCB_ACTIVE;
+		ahd_scb_timer_start(scb);
		ahd_queue_scb(ahd, scb);
	}
}
@@ -4545,9 +4754,39 @@
		if ((scb->platform_data->flags & AHD_SCB_UP_EH_SEM) != 0) {
			scb->platform_data->flags &= ~AHD_SCB_UP_EH_SEM;
			up(&ahd->platform_data->eh_sem);
+		} else {
+			struct  scb *list_scb;
+
+			/*
+			 * We were able to complete the command successfully,
+			 * so reinstate the timeouts for all other pending
+			 * commands.
+			 */
+			LIST_FOREACH(list_scb,
+				     &ahd->pending_scbs, pending_links) {
+
+				ahd_scb_timer_start(list_scb);
+                	}
		}
	}

+	if ((scb->platform_data->flags & AHD_TIMEOUT_ACTIVE) == 0) {
+		/*
+		 * The completion handler believes that
+		 * commands without active timers running
+		 * have lost the race of completing before
+		 * their timer expires.  Since commands in
+		 * our busy queues do not have timers running,
+		 * appease the mid-layer by adding a timer
+		 * now.  This timer will be immediately
+		 * canceled by the midlayer.
+		 */
+		scsi_add_timer(cmd, 60*HZ, ahd_linux_midlayer_timeout);
+	}
+
+	if ((scb->platform_data->flags & AHD_RELEASE_SIMQ) != 0)
+		ahd_release_simq_locked(ahd);
+
	ahd_free_scb(ahd, scb);
	ahd_linux_queue_cmd_complete(ahd, cmd);

@@ -4982,42 +5221,31 @@
ahd_freeze_simq(struct ahd_softc *ahd)
{
	ahd->platform_data->qfrozen++;
-	if (ahd->platform_data->qfrozen == 1) {
-		scsi_block_requests(ahd->platform_data->host);
-		ahd_platform_abort_scbs(ahd, CAM_TARGET_WILDCARD, ALL_CHANNELS,
-					CAM_LUN_WILDCARD, SCB_LIST_NULL,
-					ROLE_INITIATOR, CAM_REQUEUE_REQ);
-	}
}

void
ahd_release_simq(struct ahd_softc *ahd)
{
	u_long s;
-	int    unblock_reqs;

-	unblock_reqs = 0;
	ahd_lock(ahd, &s);
+	ahd_release_simq_locked(ahd);
+	ahd_unlock(ahd, &s);
+}
+
+static void
+ahd_release_simq_locked(struct ahd_softc *ahd)
+{
+
	if (ahd->platform_data->qfrozen > 0)
		ahd->platform_data->qfrozen--;
-	if (ahd->platform_data->qfrozen == 0) {
-		unblock_reqs = 1;
-	}
	if (AHD_DV_SIMQ_FROZEN(ahd)
	 && ((ahd->platform_data->flags & AHD_DV_WAIT_SIMQ_RELEASE) != 0)) {
		ahd->platform_data->flags &= ~AHD_DV_WAIT_SIMQ_RELEASE;
		up(&ahd->platform_data->dv_sem);
	}
-	ahd_schedule_runq(ahd);
-	ahd_unlock(ahd, &s);
-	/*
-	 * There is still a race here.  The mid-layer
-	 * should keep its own freeze count and use
-	 * a bottom half handler to run the queues
-	 * so we can unblock with our own lock held.
-	 */
-	if (unblock_reqs)
-		scsi_unblock_requests(ahd->platform_data->host);
+	if (ahd->platform_data->qfrozen == 0)
+		ahd_schedule_runq(ahd);
}

static void
@@ -5111,20 +5339,18 @@
ahd_linux_exit(void)
{
	struct ahd_softc *ahd;
-	u_long l;

	/*
-	 * Shutdown DV threads before going into the SCSI mid-layer.
+	 * Shutdown our threads before going into the SCSI mid-layer.
	 * This avoids situations where the mid-layer locks the entire
	 * kernel so that waiting for our DV threads to exit leads
	 * to deadlock.
	 */
-	ahd_list_lock(&l);
	TAILQ_FOREACH(ahd, &ahd_tailq, links) {

		ahd_linux_kill_dv_thread(ahd);
+		ahd_terminate_recovery_thread(ahd);
	}
-	ahd_list_unlock(&l);
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
	/*
	 * In 2.4 we have to unregister from the PCI core _after_
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#137 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h ====
--- /tmp/tmp.26128.1	2004-09-27 12:45:29.583199928 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h	2003-08-05 16:04:49.000000000 -0400
@@ -36,7 +36,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#137 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#138 $
  *
  */
#ifndef _AIC79XX_LINUX_H_
@@ -253,33 +253,6 @@
#endif
#include "aic79xx.h"

-/***************************** Timer Facilities *******************************/
-#define ahd_timer_init init_timer
-#define ahd_timer_stop del_timer_sync
-typedef void ahd_linux_callback_t (u_long);
-static __inline void ahd_timer_reset(ahd_timer_t *timer, u_int usec,
-				     ahd_callback_t *func, void *arg);
-static __inline void ahd_scb_timer_reset(struct scb *scb, u_int usec);
-
-static __inline void
-ahd_timer_reset(ahd_timer_t *timer, u_int usec, ahd_callback_t *func, void *arg)
-{
-	struct ahd_softc *ahd;
-
-	ahd = (struct ahd_softc *)arg;
-	del_timer(timer);
-	timer->data = (u_long)arg;
-	timer->expires = jiffies + (usec * HZ)/1000000;
-	timer->function = (ahd_linux_callback_t*)func;
-	add_timer(timer);
-}
-
-static __inline void
-ahd_scb_timer_reset(struct scb *scb, u_int usec)
-{
-	mod_timer(&scb->io_ctx->eh_timeout, jiffies + (usec * HZ)/1000000);
-}
-
/***************************** SMP support ************************************/
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,17)
#include <linux/spinlock.h>
@@ -505,7 +478,9 @@
  * Per-SCB OSM storage.
  */
typedef enum {
-	AHD_SCB_UP_EH_SEM = 0x1
+	AHD_SCB_UP_EH_SEM	= 0x1,
+	AHD_TIMEOUT_ACTIVE	= 0x2,
+	AHD_RELEASE_SIMQ	= 0x4
} ahd_linux_scb_flags;

struct scb_platform_data {
@@ -549,14 +524,15 @@
#endif
	u_int			 qfrozen;
	pid_t			 dv_pid;
+	pid_t			 recovery_pid;
	struct timer_list	 completeq_timer;
	struct timer_list	 reset_timer;
	struct timer_list	 stats_timer;
	struct semaphore	 eh_sem;
	struct semaphore	 dv_sem;
-	struct semaphore	 dv_cmd_sem;	/* XXX This needs to be in
-						 * the target struct
-						 */
+	struct semaphore	 dv_cmd_sem;
+	struct semaphore	 recovery_sem;
+	struct semaphore	 recovery_ending_sem;
	struct scsi_device	*dv_scsi_dev;
	struct Scsi_Host        *host;		/* pointer to scsi host */
#define AHD_LINUX_NOIRQ	((uint32_t)~0)
@@ -567,6 +543,72 @@
	ahd_linux_softc_flags	 flags;
};

+/***************************** Timer Facilities *******************************/
+void ahd_platform_timeout(struct scsi_cmnd *);
+void ahd_linux_midlayer_timeout(struct scsi_cmnd *);
+
+#define ahd_timer_init init_timer
+#define ahd_timer_stop del_timer_sync
+typedef void ahd_linux_callback_t (u_long);
+static __inline void ahd_timer_reset(ahd_timer_t *timer, uint32_t usec,
+				     ahd_callback_t *func, void *arg);
+static __inline uint32_t ahd_get_timeout(struct scb *);
+static __inline void ahd_scb_timer_start(struct scb *scb);
+static __inline void ahd_scb_timer_reset(struct scb *scb, uint32_t usec);
+
+static __inline void
+ahd_timer_reset(ahd_timer_t *timer, uint32_t usec,
+		ahd_callback_t *func, void *arg)
+{
+	struct ahd_softc *ahd;
+
+	ahd = (struct ahd_softc *)arg;
+	del_timer(timer);
+	timer->data = (u_long)arg;
+	timer->expires = jiffies + (usec * HZ)/1000000;
+	timer->function = (ahd_linux_callback_t*)func;
+	add_timer(timer);
+}
+
+static __inline uint32_t
+ahd_get_timeout(struct scb *scb)
+{
+
+	/*
+	 * Convert from jiffies to usec.
+	 */
+	return (scb->io_ctx->timeout_per_command * (1000000/HZ));
+}
+
+static __inline void
+ahd_scb_timer_start(struct scb *scb)
+{
+	scb->platform_data->flags |= AHD_TIMEOUT_ACTIVE;
+	scsi_add_timer(scb->io_ctx, scb->io_ctx->timeout_per_command,
+		       ahd_platform_timeout);
+}
+
+static __inline void
+ahd_scb_timer_reset(struct scb *scb, uint32_t usec)
+{
+	scb->platform_data->flags |= AHD_TIMEOUT_ACTIVE;
+	mod_timer(&scb->io_ctx->eh_timeout, jiffies + (usec * HZ)/1000000);
+}
+
+/************************** Error Recovery ************************************/
+static __inline void	ahd_wakeup_recovery_thread(struct ahd_softc *ahd);
+
+static __inline void
+ahd_wakeup_recovery_thread(struct ahd_softc *ahd)
+{
+	up(&ahd->platform_data->recovery_sem);
+}
+
+int			ahd_spawn_recovery_thread(struct ahd_softc *ahd);
+void			ahd_terminate_recovery_thread(struct ahd_softc *ahd);
+void			ahd_set_recoveryscb(struct ahd_softc *ahd,
+					    struct scb *scb);
+
/************************** OS Utility Wrappers *******************************/
#define printf printk
#define M_NOWAIT GFP_ATOMIC
==== //depot/aic7xxx/aic7xxx/aic7xxx.h#81 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx.h ====
--- /tmp/tmp.26128.2	2004-09-27 12:45:29.897152200 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx.h	2003-08-05 16:02:51.000000000 -0400
@@ -37,7 +37,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.h#81 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.h#82 $
  *
  * $FreeBSD$
  */
@@ -412,6 +412,7 @@
	uint8_t  initiator_tag;		/* Initiator's transaction tag */
};

+#define MAX_CDB_LEN 16
struct hardware_scb {
/*0*/	union {
		/*
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#235 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c ====
--- /tmp/tmp.26128.3	2004-09-27 12:45:30.859005976 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c	2003-08-05 16:10:56.000000000 -0400
@@ -1,7 +1,7 @@
/*
  * Adaptec AIC7xxx device driver for Linux.
  *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#235 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#236 $
  *
  * Copyright (c) 1994 John Aycock
  *   The University of Calgary Department of Computer Science.
@@ -490,6 +490,7 @@
static void ahc_linux_sem_timeout(u_long arg);
static void ahc_linux_freeze_simq(struct ahc_softc *ahc);
static void ahc_linux_release_simq(u_long arg);
+static void ahc_linux_release_simq_locked(struct ahc_softc *ahc);
static void ahc_linux_dev_timed_unfreeze(u_long arg);
static int  ahc_linux_queue_recovery_cmd(Scsi_Cmnd *cmd, scb_flag flag);
static void ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc);
@@ -836,6 +837,156 @@
#endif
}

+/************************** Error Recovery ************************************/
+static int ahc_linux_recovery_thread(void *arg);
+
+static int
+ahc_linux_recovery_thread(void *arg)
+{
+	struct ahc_softc *ahc;
+	u_long s;
+
+	ahc = (struct ahc_softc *)arg;
+
+	/*
+	 * Complete thread creation.
+	 */
+	lock_kernel();
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,60)
+	/*
+	 * Don't care about any signals.
+	 */
+	siginitsetinv(&current->blocked, 0);
+
+	daemonize();
+	sprintf(current->comm, "ahc_dv_%d", ahc->unit);
+#else
+	daemonize("ahc_recovery_%d", ahc->unit);
+#endif
+	unlock_kernel();
+
+	while (1) {
+
+		/*
+		 * Use down_interruptible() rather than down() to
+		 * avoid inclusion in the load average.
+		 */
+		down_interruptible(&ahc->platform_data->recovery_sem);
+
+		ahc_lock(ahc, &s);
+		if ((ahc->flags & AHC_SHUTDOWN_RECOVERY) != 0) {
+			ahc_unlock(ahc, &s);
+			break;
+		}
+		ahc_unlock(ahc, &s);
+		ahc_recover_commands(ahc);
+	}
+	up(&ahc->platform_data->recovery_ending_sem);
+	return(0);
+}
+
+int
+ahc_spawn_recovery_thread(struct ahc_softc *ahc)
+{
+	ahc->platform_data->recovery_pid =
+	    kernel_thread(ahc_linux_recovery_thread, ahc, 0);
+	return (0);
+}
+
+void
+ahc_terminate_recovery_thread(struct ahc_softc *ahc)
+{
+	u_long s;
+
+	ahc_lock(ahc, &s);
+	if (ahc->platform_data->recovery_pid != 0) {
+		ahc->flags |= AHC_SHUTDOWN_RECOVERY;
+		ahc_unlock(ahc, &s);
+		up(&ahc->platform_data->recovery_sem);
+
+		/*
+		 * Use the recovery_ending_sem as an indicator that
+		 * the dv thread is exiting.  Note that the dv
+		 * thread must still return after performing
+		 * the up on our semaphore before it has
+		 * completely exited this module.  Unfortunately,
+		 * there seems to be no easy way to wait for the
+		 * exit of a thread for which you are not the
+		 * parent (dv threads are parented by init).
+		 * Cross your fingers...
+		 */
+		down(&ahc->platform_data->recovery_ending_sem);
+
+		/*
+		 * Mark the recovery thread as already dead.  This
+		 * avoids attempting to kill it a second time.
+		 * This is necessary because we must kill the
+		 * our threads before calling ahc_free() in the
+		 * module shutdown case to avoid bogus locking
+		 * in the SCSI mid-layer, but when ahc_free() is
+		 * called without killing the DV thread in the
+		 * instance detach case, so ahc_platform_free()
+		 * calls us again to verify that the DV thread
+		 * is dead.
+		 */
+		ahc->platform_data->recovery_pid = 0;
+	} else {
+		ahc_unlock(ahc, &s);
+	}
+}
+
+void
+ahc_set_recoveryscb(struct ahc_softc *ahc, struct scb *scb)
+{
+	if ((scb->flags & SCB_RECOVERY_SCB) == 0) {
+		struct scb *list_scb;
+
+		scb->flags |= SCB_RECOVERY_SCB;
+
+		/*
+		 * Take all queued, but not sent SCBs out of the equation.
+		 * Also ensure that no new commands are queued to us while we
+		 * try to fix this problem.
+		 */
+		if ((scb->platform_data->flags & AHC_RELEASE_SIMQ) == 0) {
+			ahc_linux_freeze_simq(ahc);
+			scb->platform_data->flags |= AHC_RELEASE_SIMQ;
+		}
+
+		/*
+		 * Go through all of our pending SCBs and remove
+		 * any scheduled timeouts for them.  We will reschedule
+		 * them after we've successfully fixed this problem.
+		 */
+		LIST_FOREACH(list_scb, &ahc->pending_scbs, pending_links) {
+
+			scsi_delete_timer(list_scb->io_ctx);
+			scb->platform_data->flags &= ~AHC_TIMEOUT_ACTIVE;
+		}
+	}
+}
+
+void
+ahc_platform_timeout(struct scsi_cmnd *cmd)
+{
+
+	if (AHC_DV_CMD(cmd) == 0) {
+
+		ahc_linux_dv_timeout(cmd);
+	} else {
+		struct	scb *scb;
+
+		scb = (struct scb *)cmd->host_scribble;
+		scb->platform_data->flags &= ~AHC_TIMEOUT_ACTIVE;
+		ahc_timeout(scb);
+	}
+}
+
+void
+ahc_linux_midlayer_timeout(struct scsi_cmnd *cmd)
+{
+}
+/************************ Linux Entry Points **********************************/
/*
  * Try to detect an Adaptec 7XXX controller.
  */
@@ -1015,6 +1166,7 @@
	dev = ahc_linux_get_device(ahc, cmd->device->channel, cmd->device->id,
				   cmd->device->lun, /*alloc*/TRUE);
	if (dev == NULL) {
+
		ahc_cmd_set_transaction_status(cmd, CAM_RESRC_UNAVAIL);
		ahc_linux_queue_cmd_complete(ahc, cmd);
		ahc_schedule_completeq(ahc);
@@ -1023,6 +1175,23 @@
		       ahc_name(ahc));
		return (0);
	}
+
+	if (cmd->cmd_len > MAX_CDB_LEN) {
+
+		ahc_cmd_set_transaction_status(cmd, CAM_REQ_INVALID);
+		ahc_linux_queue_cmd_complete(ahc, cmd);
+		ahc_schedule_completeq(ahc);
+		ahc_midlayer_entrypoint_unlock(ahc, &flags);
+		printf("%s: aic7xxx_linux_queue -"
+		       "CDB length of %d exceeds max!\n",
+		       ahc_name(ahc), cmd->cmd_len);
+	}
+
+	/*
+	 * We perform our own timeout handling.
+	 */
+	scsi_delete_timer(cmd);
+
	cmd->result = CAM_REQ_INPROG << 16;
	TAILQ_INSERT_TAIL(&dev->busyq, (struct ahc_cmd *)cmd, acmd_links.tqe);
	if ((dev->flags & AHC_DEV_ON_RUN_LIST) == 0) {
@@ -1947,10 +2116,14 @@
	init_MUTEX_LOCKED(&ahc->platform_data->eh_sem);
	init_MUTEX_LOCKED(&ahc->platform_data->dv_sem);
	init_MUTEX_LOCKED(&ahc->platform_data->dv_cmd_sem);
+	init_MUTEX_LOCKED(&ahc->platform_data->recovery_sem);
+	init_MUTEX_LOCKED(&ahc->platform_data->recovery_ending_sem);
#else
	ahc->platform_data->eh_sem = MUTEX_LOCKED;
	ahc->platform_data->dv_sem = MUTEX_LOCKED;
	ahc->platform_data->dv_cmd_sem = MUTEX_LOCKED;
+	ahc->platform_data->recovery_sem = MUTEX_LOCKED;
+	ahc->platform_data->recovery_ending_sem = MUTEX_LOCKED;
#endif
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
	tasklet_init(&ahc->platform_data->runq_tasklet, ahc_runq_tasklet,
@@ -2200,6 +2373,20 @@
						     acmd_links.tqe);
					count++;
					cmd->result = status << 16;
+					/*
+					 * The completion handler believes that
+					 * commands without active timers
+					 * running have lost the race of
+					 * completing before their timer
+					 * expires.  Since commands in our
+					 * busy queues do not have timers
+					 * running, appease the mid-layer by
+					 * adding a timer now.  This timer will
+					 * be immediately canceled by the
+					 * midlayer.
+					 */
+					scsi_add_timer(cmd, 60*HZ,
+					    ahc_linux_midlayer_timeout);
					ahc_linux_queue_cmd_complete(ahc, cmd);
				}
			}
@@ -2236,7 +2423,16 @@
#endif

		ahc->platform_data->flags |= AHC_DV_ACTIVE;
+
+		/*
+		 * Prevent upper layer from sending any
+		 * commands to us.
+		 */
		ahc_linux_freeze_simq(ahc);
+		scsi_block_requests(ahc->platform_data->host);
+		ahc_platform_abort_scbs(ahc, CAM_TARGET_WILDCARD, ALL_CHANNELS,
+					CAM_LUN_WILDCARD, SCB_LIST_NULL,
+					ROLE_INITIATOR, CAM_REQUEUE_REQ);

		/* Wake up the DV kthread */
		up(&ahc->platform_data->dv_sem);
@@ -2365,13 +2561,15 @@

		ahc_lock(ahc, &s);
		ahc->platform_data->flags &= ~AHC_DV_ACTIVE;
-		ahc_unlock(ahc, &s);

		/*
		 * Release the SIMQ so that normal commands are
		 * allowed to continue on the bus.
		 */
-		ahc_linux_release_simq((u_long)ahc);
+		ahc_linux_release_simq_locked(ahc);
+		ahc_unlock(ahc, &s);
+
+		scsi_unblock_requests(ahc->platform_data->host);
	}
	up(&ahc->platform_data->eh_sem);
	return (0);
@@ -2507,8 +2705,6 @@
		}

		/* Queue the command and wait for it to complete */
-		/* Abuse eh_timeout in the scsi_cmnd struct for our purposes */
-		init_timer(&cmd->eh_timeout);
#ifdef AHC_DEBUG
		if ((ahc_debug & AHC_SHOW_MESSAGES) != 0)
			/*
@@ -2518,7 +2714,9 @@
			 */
			timeout += HZ;
#endif
-		scsi_add_timer(cmd, timeout, ahc_linux_dv_timeout);
+		init_timer(&cmd->eh_timeout);
+		cmd->timeout_per_command = timeout;
+
		/*
		 * In 2.5.X, it is assumed that all calls from the
		 * "midlayer" (which we are emulating) will have the
@@ -3689,6 +3887,7 @@
		cmd = &acmd_scsi_cmd(acmd);
		scb->io_ctx = cmd;
		scb->platform_data->dev = dev;
+		scb->platform_data->flags = 0;
		hscb = scb->hscb;
		cmd->host_scribble = (char *)scb;

@@ -3856,6 +4055,7 @@
				continue;
		}
		scb->flags |= SCB_ACTIVE;
+		ahc_scb_timer_start(scb);
		ahc_queue_scb(ahc, scb);
	}
}
@@ -4243,9 +4443,39 @@
		if ((ahc->platform_data->flags & AHC_UP_EH_SEMAPHORE) != 0) {
			ahc->platform_data->flags &= ~AHC_UP_EH_SEMAPHORE;
			up(&ahc->platform_data->eh_sem);
+		} else {
+			struct  scb *list_scb;
+
+			/*
+			 * We were able to complete the command successfully,
+			 * so reinstate the timeouts for all other pending
+			 * commands.
+			 */
+			LIST_FOREACH(list_scb,
+				     &ahc->pending_scbs, pending_links) {
+
+				ahc_scb_timer_start(list_scb);
+                	}
		}
	}

+	if ((scb->platform_data->flags & AHC_TIMEOUT_ACTIVE) == 0) {
+		/*
+		 * The completion handler believes that
+		 * commands without active timers running
+		 * have lost the race of completing before
+		 * their timer expires.  Since commands in
+		 * our busy queues do not have timers running,
+		 * appease the mid-layer by adding a timer
+		 * now.  This timer will be immediately
+		 * canceled by the midlayer.
+		 */
+		scsi_add_timer(cmd, 60*HZ, ahc_linux_midlayer_timeout);
+	}
+
+	if ((scb->platform_data->flags & AHC_RELEASE_SIMQ) != 0)
+		ahc_linux_release_simq_locked(ahc);
+
	ahc_free_scb(ahc, scb);
	ahc_linux_queue_cmd_complete(ahc, cmd);

@@ -4650,14 +4880,6 @@
ahc_linux_freeze_simq(struct ahc_softc *ahc)
{
	ahc->platform_data->qfrozen++;
-	if (ahc->platform_data->qfrozen == 1) {
-		scsi_block_requests(ahc->platform_data->host);
-
-		/* XXX What about Twin channels? */
-		ahc_platform_abort_scbs(ahc, CAM_TARGET_WILDCARD, ALL_CHANNELS,
-					CAM_LUN_WILDCARD, SCB_LIST_NULL,
-					ROLE_INITIATOR, CAM_REQUEUE_REQ);
-	}
}

static void
@@ -4665,31 +4887,27 @@
{
	struct ahc_softc *ahc;
	u_long s;
-	int    unblock_reqs;

	ahc = (struct ahc_softc *)arg;

-	unblock_reqs = 0;
	ahc_lock(ahc, &s);
+	ahc_linux_release_simq_locked(ahc);
+	ahc_unlock(ahc, &s);
+}
+
+static void
+ahc_linux_release_simq_locked(struct ahc_softc *ahc)
+{
+
	if (ahc->platform_data->qfrozen > 0)
		ahc->platform_data->qfrozen--;
-	if (ahc->platform_data->qfrozen == 0)
-		unblock_reqs = 1;
	if (AHC_DV_SIMQ_FROZEN(ahc)
	 && ((ahc->platform_data->flags & AHC_DV_WAIT_SIMQ_RELEASE) != 0)) {
		ahc->platform_data->flags &= ~AHC_DV_WAIT_SIMQ_RELEASE;
		up(&ahc->platform_data->dv_sem);
	}
-	ahc_schedule_runq(ahc);
-	ahc_unlock(ahc, &s);
-	/*
-	 * There is still a race here.  The mid-layer
-	 * should keep its own freeze count and use
-	 * a bottom half handler to run the queues
-	 * so we can unblock with our own lock held.
-	 */
-	if (unblock_reqs)
-		scsi_unblock_requests(ahc->platform_data->host);
+	if (ahc->platform_data->qfrozen == 0)
+		ahc_schedule_runq(ahc);
}

static void
@@ -4800,6 +5018,17 @@
		if (flag == SCB_ABORT) {
			TAILQ_REMOVE(&dev->busyq, list_acmd, acmd_links.tqe);
			cmd->result = DID_ABORT << 16;
+			/*
+			 * The completion handler believes that
+			 * commands without active timers running
+			 * have lost the race of completing before
+			 * their timer expires.  Since commands in our
+			 * busy queues do not have timers running,
+			 * appease the mid-layer by adding a timer
+			 * now.  This timer will be immediately
+			 * canceled by the midlayer.
+			 */
+			scsi_add_timer(cmd, 60*HZ, ahc_linux_midlayer_timeout);
			ahc_linux_queue_cmd_complete(ahc, cmd);
			retval = SUCCESS;
			goto done;
@@ -5105,20 +5334,18 @@
ahc_linux_exit(void)
{
	struct ahc_softc *ahc;
-	u_long l;

	/*
-	 * Shutdown DV threads before going into the SCSI mid-layer.
+	 * Shutdown our threads before going into the SCSI mid-layer.
	 * This avoids situations where the mid-layer locks the entire
	 * kernel so that waiting for our DV threads to exit leads
	 * to deadlock.
	 */
-	ahc_list_lock(&l);
	TAILQ_FOREACH(ahc, &ahc_tailq, links) {

		ahc_linux_kill_dv_thread(ahc);
+		ahc_terminate_recovery_thread(ahc);
	}
-	ahc_list_unlock(&l);

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
	/*
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#151 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h ====
--- /tmp/tmp.26128.4	2004-09-27 12:45:31.150961592 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h	2003-08-05 16:05:49.000000000 -0400
@@ -53,7 +53,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#151 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#152 $
  *
  */
#ifndef _AIC7XXX_LINUX_H_
@@ -265,33 +265,6 @@
#endif
#include "aic7xxx.h"

-/***************************** Timer Facilities *******************************/
-#define ahc_timer_init init_timer
-#define ahc_timer_stop del_timer_sync
-typedef void ahc_linux_callback_t (u_long);
-static __inline void ahc_timer_reset(ahc_timer_t *timer, int usec,
-				     ahc_callback_t *func, void *arg);
-static __inline void ahc_scb_timer_reset(struct scb *scb, u_int usec);
-
-static __inline void
-ahc_timer_reset(ahc_timer_t *timer, int usec, ahc_callback_t *func, void *arg)
-{
-	struct ahc_softc *ahc;
-
-	ahc = (struct ahc_softc *)arg;
-	del_timer(timer);
-	timer->data = (u_long)arg;
-	timer->expires = jiffies + (usec * HZ)/1000000;
-	timer->function = (ahc_linux_callback_t*)func;
-	add_timer(timer);
-}
-
-static __inline void
-ahc_scb_timer_reset(struct scb *scb, u_int usec)
-{
-	mod_timer(&scb->io_ctx->eh_timeout, jiffies + (usec * HZ)/1000000);
-}
-
/***************************** SMP support ************************************/
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,17)
#include <linux/spinlock.h>
@@ -511,7 +484,9 @@
  * Per-SCB OSM storage.
  */
typedef enum {
-	AHC_UP_EH_SEMAPHORE = 0x1
+	AHC_UP_EH_SEMAPHORE	= 0x1,
+	AHC_TIMEOUT_ACTIVE	= 0x2,
+	AHC_RELEASE_SIMQ	= 0x4
} ahc_linux_scb_flags;

struct scb_platform_data {
@@ -555,13 +530,14 @@
#endif
	u_int			 qfrozen;
	pid_t			 dv_pid;
+	pid_t			 recovery_pid;
	struct timer_list	 completeq_timer;
	struct timer_list	 reset_timer;
	struct semaphore	 eh_sem;
	struct semaphore	 dv_sem;
-	struct semaphore	 dv_cmd_sem;	/* XXX This needs to be in
-						 * the target struct
-						 */
+	struct semaphore	 dv_cmd_sem;
+	struct semaphore	 recovery_sem;
+	struct semaphore	 recovery_ending_sem;
	struct scsi_device	*dv_scsi_dev;
	struct Scsi_Host        *host;		/* pointer to scsi host */
#define AHC_LINUX_NOIRQ	((uint32_t)~0)
@@ -572,6 +548,73 @@
	ahc_linux_softc_flags	 flags;
};

+/***************************** Timer Facilities *******************************/
+void ahc_platform_timeout(struct scsi_cmnd *);
+void ahc_linux_midlayer_timeout(struct scsi_cmnd *);
+
+#define ahc_timer_init init_timer
+#define ahc_timer_stop del_timer_sync
+typedef void ahc_linux_callback_t (u_long);
+static __inline void ahc_timer_reset(ahc_timer_t *timer, uint32_t usec,
+				     ahc_callback_t *func, void *arg);
+static __inline uint32_t ahc_get_timeout(struct scb *);
+static __inline void ahc_scb_timer_start(struct scb *scb);
+static __inline void ahc_scb_timer_reset(struct scb *scb, uint32_t usec);
+
+static __inline void
+ahc_timer_reset(ahc_timer_t *timer, uint32_t usec,
+		ahc_callback_t *func, void *arg)
+{
+	struct ahc_softc *ahc;
+
+	ahc = (struct ahc_softc *)arg;
+	del_timer(timer);
+	timer->data = (u_long)arg;
+	timer->expires = jiffies + (usec * HZ)/1000000;
+	timer->function = (ahc_linux_callback_t*)func;
+	add_timer(timer);
+}
+
+static __inline uint32_t
+ahc_get_timeout(struct scb *scb)
+{
+
+	/*
+	 * Convert from jiffies to usec avoiding
+	 * overflow and truncation.
+	 */
+	return (scb->io_ctx->timeout_per_command * (1000000/HZ));
+}
+
+static __inline void
+ahc_scb_timer_start(struct scb *scb)
+{
+	scb->platform_data->flags |= AHC_TIMEOUT_ACTIVE;
+	scsi_add_timer(scb->io_ctx, scb->io_ctx->timeout_per_command,
+		       ahc_platform_timeout);
+}
+
+static __inline void
+ahc_scb_timer_reset(struct scb *scb, uint32_t usec)
+{
+	scb->platform_data->flags |= AHC_TIMEOUT_ACTIVE;
+	mod_timer(&scb->io_ctx->eh_timeout, jiffies + (usec * HZ)/1000000);
+}
+
+/************************** Error Recovery ************************************/
+static __inline void	ahc_wakeup_recovery_thread(struct ahc_softc *ahc);
+
+static __inline void
+ahc_wakeup_recovery_thread(struct ahc_softc *ahc)
+{
+	up(&ahc->platform_data->recovery_sem);
+}
+
+int			ahc_spawn_recovery_thread(struct ahc_softc *ahc);
+void			ahc_terminate_recovery_thread(struct ahc_softc *ahc);
+void			ahc_set_recoveryscb(struct ahc_softc *ahc,
+					    struct scb *scb);
+
/************************** OS Utility Wrappers *******************************/
#define printf printk
#define M_NOWAIT GFP_ATOMIC



