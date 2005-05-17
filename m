From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic7xxx: remove the completeq
Date: Mon, 16 May 2005 19:06:08 -0500
Message-ID: <1116288369.5040.51.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:3253 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261316AbVEQAGK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 20:06:10 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j4H069A31892
	for <linux-scsi@vger.kernel.org>; Mon, 16 May 2005 20:06:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This should finish the spurious queue removal from aic7xxx (there are
other queues that are probably unnecessary, but at least the major and
obviously unnecessary ones are done with).

James

--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -433,7 +433,6 @@ static void ahc_linux_release_simq(u_lon
 static void ahc_linux_dev_timed_unfreeze(u_long arg);
 static int  ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag);
 static void ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc);
-static void ahc_linux_thread_run_complete_queue(struct ahc_softc *ahc);
 static u_int ahc_linux_user_tagdepth(struct ahc_softc *ahc,
 				     struct ahc_devinfo *devinfo);
 static void ahc_linux_device_queue_depth(struct ahc_softc *ahc,
@@ -454,29 +453,17 @@ static void ahc_linux_setup_tag_info_glo
 static aic_option_callback_t ahc_linux_setup_tag_info;
 static int  aic7xxx_setup(char *s);
 static int  ahc_linux_next_unit(void);
-static struct ahc_cmd *ahc_linux_run_complete_queue(struct ahc_softc *ahc);
 
 /********************************* Inlines ************************************/
 static __inline struct ahc_linux_device*
 		     ahc_linux_get_device(struct ahc_softc *ahc, u_int channel,
 					  u_int target, u_int lun, int alloc);
-static __inline void ahc_schedule_completeq(struct ahc_softc *ahc);
 static __inline void ahc_linux_unmap_scb(struct ahc_softc*, struct scb*);
 
 static __inline int ahc_linux_map_seg(struct ahc_softc *ahc, struct scb *scb,
 		 		      struct ahc_dma_seg *sg,
 				      dma_addr_t addr, bus_size_t len);
 
-static __inline void
-ahc_schedule_completeq(struct ahc_softc *ahc)
-{
-	if ((ahc->platform_data->flags & AHC_RUN_CMPLT_Q_TIMER) == 0) {
-		ahc->platform_data->flags |= AHC_RUN_CMPLT_Q_TIMER;
-		ahc->platform_data->completeq_timer.expires = jiffies;
-		add_timer(&ahc->platform_data->completeq_timer);
-	}
-}
-
 static __inline struct ahc_linux_device*
 ahc_linux_get_device(struct ahc_softc *ahc, u_int channel, u_int target,
 		     u_int lun, int alloc)
@@ -503,42 +490,6 @@ ahc_linux_get_device(struct ahc_softc *a
 	return (dev);
 }
 
-#define AHC_LINUX_MAX_RETURNED_ERRORS 4
-static struct ahc_cmd *
-ahc_linux_run_complete_queue(struct ahc_softc *ahc)
-{
-	struct	ahc_cmd *acmd;
-	int	with_errors;
-
-	with_errors = 0;
-	while ((acmd = TAILQ_FIRST(&ahc->platform_data->completeq)) != NULL) {
-		struct scsi_cmnd *cmd;
-
-		if (with_errors > AHC_LINUX_MAX_RETURNED_ERRORS) {
-			/*
-			 * Linux uses stack recursion to requeue
-			 * commands that need to be retried.  Avoid
-			 * blowing out the stack by "spoon feeding"
-			 * commands that completed with error back
-			 * the operating system in case they are going
-			 * to be retried. "ick"
-			 */
-			ahc_schedule_completeq(ahc);
-			break;
-		}
-		TAILQ_REMOVE(&ahc->platform_data->completeq,
-			     acmd, acmd_links.tqe);
-		cmd = &acmd_scsi_cmd(acmd);
-		cmd->host_scribble = NULL;
-		if (ahc_cmd_get_transaction_status(cmd) != DID_OK
-		 || (cmd->result & 0xFF) != SCSI_STATUS_OK)
-			with_errors++;
-
-		cmd->scsi_done(cmd);
-	}
-	return (acmd);
-}
-
 static __inline void
 ahc_linux_unmap_scb(struct ahc_softc *ahc, struct scb *scb)
 {
@@ -856,7 +807,6 @@ ahc_linux_bus_reset(struct scsi_cmnd *cm
 	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
 	found = ahc_reset_channel(ahc, cmd->device->channel + 'A',
 				  /*initiate reset*/TRUE);
-	ahc_linux_run_complete_queue(ahc);
 
 	if (bootverbose)
 		printf("%s: SCSI bus reset delivered. "
@@ -1331,13 +1281,8 @@ ahc_platform_alloc(struct ahc_softc *ahc
 	if (ahc->platform_data == NULL)
 		return (ENOMEM);
 	memset(ahc->platform_data, 0, sizeof(struct ahc_platform_data));
-	TAILQ_INIT(&ahc->platform_data->completeq);
 	ahc->platform_data->irq = AHC_LINUX_NOIRQ;
 	ahc_lockinit(ahc);
-	init_timer(&ahc->platform_data->completeq_timer);
-	ahc->platform_data->completeq_timer.data = (u_long)ahc;
-	ahc->platform_data->completeq_timer.function =
-	    (ahc_linux_callback_t *)ahc_linux_thread_run_complete_queue;
 	init_MUTEX_LOCKED(&ahc->platform_data->eh_sem);
 	ahc->seltime = (aic7xxx_seltime & 0x3) << 4;
 	ahc->seltime_b = (aic7xxx_seltime & 0x3) << 4;
@@ -1355,7 +1300,6 @@ ahc_platform_free(struct ahc_softc *ahc)
 	int i, j;
 
 	if (ahc->platform_data != NULL) {
-		del_timer_sync(&ahc->platform_data->completeq_timer);
 		if (ahc->platform_data->host != NULL) {
 			scsi_remove_host(ahc->platform_data->host);
 			scsi_host_put(ahc->platform_data->host);
@@ -1504,18 +1448,6 @@ ahc_platform_abort_scbs(struct ahc_softc
 	return 0;
 }
 
-static void
-ahc_linux_thread_run_complete_queue(struct ahc_softc *ahc)
-{
-	u_long flags;
-
-	ahc_lock(ahc, &flags);
-	del_timer(&ahc->platform_data->completeq_timer);
-	ahc->platform_data->flags &= ~AHC_RUN_CMPLT_Q_TIMER;
-	ahc_linux_run_complete_queue(ahc);
-	ahc_unlock(ahc, &flags);
-}
-
 static u_int
 ahc_linux_user_tagdepth(struct ahc_softc *ahc, struct ahc_devinfo *devinfo)
 {
@@ -1785,7 +1717,6 @@ ahc_linux_isr(int irq, void *dev_id, str
 	ahc = (struct ahc_softc *) dev_id;
 	ahc_lock(ahc, &flags); 
 	ours = ahc_intr(ahc);
-	ahc_linux_run_complete_queue(ahc);
 	ahc_unlock(ahc, &flags);
 	return IRQ_RETVAL(ours);
 }
@@ -1794,8 +1725,6 @@ void
 ahc_platform_flushwork(struct ahc_softc *ahc)
 {
 
-	while (ahc_linux_run_complete_queue(ahc) != NULL)
-		;
 }
 
 static struct ahc_linux_target*
@@ -2275,22 +2204,6 @@ static void
 ahc_linux_queue_cmd_complete(struct ahc_softc *ahc, struct scsi_cmnd *cmd)
 {
 	/*
-	 * Typically, the complete queue has very few entries
-	 * queued to it before the queue is emptied by
-	 * ahc_linux_run_complete_queue, so sorting the entries
-	 * by generation number should be inexpensive.
-	 * We perform the sort so that commands that complete
-	 * with an error are retuned in the order origionally
-	 * queued to the controller so that any subsequent retries
-	 * are performed in order.  The underlying ahc routines do
-	 * not guarantee the order that aborted commands will be
-	 * returned to us.
-	 */
-	struct ahc_completeq *completeq;
-	struct ahc_cmd *list_cmd;
-	struct ahc_cmd *acmd;
-
-	/*
 	 * Map CAM error codes into Linux Error codes.  We
 	 * avoid the conversion so that the DV code has the
 	 * full error information available when making
@@ -2343,26 +2256,7 @@ ahc_linux_queue_cmd_complete(struct ahc_
 			new_status = DID_ERROR;
 			break;
 		case CAM_REQUEUE_REQ:
-			/*
-			 * If we want the request requeued, make sure there
-			 * are sufficent retries.  In the old scsi error code,
-			 * we used to be able to specify a result code that
-			 * bypassed the retry count.  Now we must use this
-			 * hack.  We also "fake" a check condition with
-			 * a sense code of ABORTED COMMAND.  This seems to
-			 * evoke a retry even if this command is being sent
-			 * via the eh thread.  Ick!  Ick!  Ick!
-			 */
-			if (cmd->retries > 0)
-				cmd->retries--;
-			new_status = DID_OK;
-			ahc_cmd_set_scsi_status(cmd, SCSI_STATUS_CHECK_COND);
-			cmd->result |= (DRIVER_SENSE << 24);
-			memset(cmd->sense_buffer, 0,
-			       sizeof(cmd->sense_buffer));
-			cmd->sense_buffer[0] = SSD_ERRCODE_VALID
-					     | SSD_CURRENT_ERROR;
-			cmd->sense_buffer[2] = SSD_KEY_ABORTED_COMMAND;
+			new_status = DID_REQUEUE;
 			break;
 		default:
 			/* We should never get here */
@@ -2373,17 +2267,7 @@ ahc_linux_queue_cmd_complete(struct ahc_
 		ahc_cmd_set_transaction_status(cmd, new_status);
 	}
 
-	completeq = &ahc->platform_data->completeq;
-	list_cmd = TAILQ_FIRST(completeq);
-	acmd = (struct ahc_cmd *)cmd;
-	while (list_cmd != NULL
-	    && acmd_scsi_cmd(list_cmd).serial_number
-	     < acmd_scsi_cmd(acmd).serial_number)
-		list_cmd = TAILQ_NEXT(list_cmd, acmd_links.tqe);
-	if (list_cmd != NULL)
-		TAILQ_INSERT_BEFORE(list_cmd, acmd, acmd_links.tqe);
-	else
-		TAILQ_INSERT_TAIL(completeq, acmd, acmd_links.tqe);
+	cmd->scsi_done(cmd);
 }
 
 static void
@@ -2747,7 +2631,6 @@ done:
 		}
 		spin_lock_irq(&ahc->platform_data->spin_lock);
 	}
-	ahc_linux_run_complete_queue(ahc);
 	return (retval);
 }
 
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -436,16 +436,11 @@ struct ahc_linux_target {
 /*
  * Per-SCB OSM storage.
  */
-typedef enum {
-	AHC_UP_EH_SEMAPHORE = 0x1
-} ahc_linux_scb_flags;
-
 struct scb_platform_data {
 	struct ahc_linux_device	*dev;
 	dma_addr_t		 buf_busaddr;
 	uint32_t		 xfer_len;
 	uint32_t		 sense_resid;	/* Auto-Sense residual */
-	ahc_linux_scb_flags	 flags;
 };
 
 /*
@@ -454,22 +449,14 @@ struct scb_platform_data {
  * alignment restrictions of the various platforms supported by
  * this driver.
  */
-typedef enum {
-	AHC_RUN_CMPLT_Q_TIMER	 = 0x10
-} ahc_linux_softc_flags;
-
-TAILQ_HEAD(ahc_completeq, ahc_cmd);
-
 struct ahc_platform_data {
 	/*
 	 * Fields accessed from interrupt context.
 	 */
 	struct ahc_linux_target *targets[AHC_NUM_TARGETS]; 
-	struct ahc_completeq	 completeq;
 
 	spinlock_t		 spin_lock;
 	u_int			 qfrozen;
-	struct timer_list	 completeq_timer;
 	struct timer_list	 reset_timer;
 	struct semaphore	 eh_sem;
 	struct Scsi_Host        *host;		/* pointer to scsi host */
@@ -477,7 +464,9 @@ struct ahc_platform_data {
 	uint32_t		 irq;		/* IRQ for this adapter */
 	uint32_t		 bios_address;
 	uint32_t		 mem_busaddr;	/* Mem Base Addr */
-	ahc_linux_softc_flags	 flags;
+
+#define	AHC_UP_EH_SEMAPHORE	 0x1
+	uint32_t		 flags;
 };
 
 /************************** OS Utility Wrappers *******************************/


