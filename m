From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] convert aic7xxx to the generic Domain Validation
	infrastructure
Date: Mon, 11 Apr 2005 16:43:37 -0500
Message-ID: <1113255817.8836.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:21478 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261954AbVDKVn6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2005 17:43:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

The patch is pretty boring ... just removing heaps of unused stuff.  The
diffstat is pretty interesting, though:

 aic7xxx_osm.c | 1681 ----------------------------------------------------------
 aic7xxx_osm.h |   40 -
 2 files changed, 10 insertions(+), 1711 deletions(-)

James

===== drivers/scsi/aic7xxx/aic7xxx_osm.c 1.64 vs edited =====
--- 1.64/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-04-11 13:12:25 -05:00
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-04-11 13:42:57 -05:00
@@ -275,39 +275,6 @@
 };
 
 /*
- * DV option:
- *
- * positive value = DV Enabled
- * zero		  = DV Disabled
- * negative value = DV Default for adapter type/seeprom
- */
-#ifdef CONFIG_AIC7XXX_DV_SETTING
-#define AIC7XXX_CONFIGED_DV CONFIG_AIC7XXX_DV_SETTING
-#else
-#define AIC7XXX_CONFIGED_DV -1
-#endif
-
-static int8_t aic7xxx_dv_settings[] =
-{
-	AIC7XXX_CONFIGED_DV,
-	AIC7XXX_CONFIGED_DV,
-	AIC7XXX_CONFIGED_DV,
-	AIC7XXX_CONFIGED_DV,
-	AIC7XXX_CONFIGED_DV,
-	AIC7XXX_CONFIGED_DV,
-	AIC7XXX_CONFIGED_DV,
-	AIC7XXX_CONFIGED_DV,
-	AIC7XXX_CONFIGED_DV,
-	AIC7XXX_CONFIGED_DV,
-	AIC7XXX_CONFIGED_DV,
-	AIC7XXX_CONFIGED_DV,
-	AIC7XXX_CONFIGED_DV,
-	AIC7XXX_CONFIGED_DV,
-	AIC7XXX_CONFIGED_DV,
-	AIC7XXX_CONFIGED_DV
-};
-
-/*
  * There should be a specific return value for this in scsi.h, but
  * it seems that most drivers ignore it.
  */
@@ -454,7 +421,6 @@
 "	tag_info:<tag_str>	Set per-target tag depth\n"
 "	global_tag_depth:<int>	Global tag depth for every target\n"
 "				on every bus\n"
-"	dv:<dv_settings>	Set per-controller Domain Validation Setting.\n"
 "	seltime:<int>		Selection Timeout\n"
 "				(0/256ms,1/128ms,2/64ms,3/32ms)\n"
 "\n"
@@ -471,7 +437,6 @@
 					 struct scb *);
 static void ahc_linux_queue_cmd_complete(struct ahc_softc *ahc,
 					 Scsi_Cmnd *cmd);
-static void ahc_linux_filter_inquiry(struct ahc_softc*, struct ahc_devinfo*);
 static void ahc_linux_sem_timeout(u_long arg);
 static void ahc_linux_freeze_simq(struct ahc_softc *ahc);
 static void ahc_linux_release_simq(u_long arg);
@@ -480,49 +445,8 @@
 static void ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc);
 static void ahc_linux_size_nseg(void);
 static void ahc_linux_thread_run_complete_queue(struct ahc_softc *ahc);
-static void ahc_linux_start_dv(struct ahc_softc *ahc);
-static void ahc_linux_dv_timeout(struct scsi_cmnd *cmd);
-static int  ahc_linux_dv_thread(void *data);
-static void ahc_linux_kill_dv_thread(struct ahc_softc *ahc);
-static void ahc_linux_dv_target(struct ahc_softc *ahc, u_int target);
-static void ahc_linux_dv_transition(struct ahc_softc *ahc,
-				    struct scsi_cmnd *cmd,
-				    struct ahc_devinfo *devinfo,
-				    struct ahc_linux_target *targ);
-static void ahc_linux_dv_fill_cmd(struct ahc_softc *ahc,
-				  struct scsi_cmnd *cmd,
-				  struct ahc_devinfo *devinfo);
-static void ahc_linux_dv_inq(struct ahc_softc *ahc,
-			     struct scsi_cmnd *cmd,
-			     struct ahc_devinfo *devinfo,
-			     struct ahc_linux_target *targ,
-			     u_int request_length);
-static void ahc_linux_dv_tur(struct ahc_softc *ahc,
-			     struct scsi_cmnd *cmd,
-			     struct ahc_devinfo *devinfo);
-static void ahc_linux_dv_rebd(struct ahc_softc *ahc,
-			      struct scsi_cmnd *cmd,
-			      struct ahc_devinfo *devinfo,
-			      struct ahc_linux_target *targ);
-static void ahc_linux_dv_web(struct ahc_softc *ahc,
-			     struct scsi_cmnd *cmd,
-			     struct ahc_devinfo *devinfo,
-			     struct ahc_linux_target *targ);
-static void ahc_linux_dv_reb(struct ahc_softc *ahc,
-			     struct scsi_cmnd *cmd,
-			     struct ahc_devinfo *devinfo,
-			     struct ahc_linux_target *targ);
-static void ahc_linux_dv_su(struct ahc_softc *ahc,
-			    struct scsi_cmnd *cmd,
-			    struct ahc_devinfo *devinfo,
-			    struct ahc_linux_target *targ);
-static int ahc_linux_fallback(struct ahc_softc *ahc,
-			      struct ahc_devinfo *devinfo);
-static void ahc_linux_dv_complete(Scsi_Cmnd *cmd);
-static void ahc_linux_generate_dv_pattern(struct ahc_linux_target *targ);
 static u_int ahc_linux_user_tagdepth(struct ahc_softc *ahc,
 				     struct ahc_devinfo *devinfo);
-static u_int ahc_linux_user_dv_setting(struct ahc_softc *ahc);
 static void ahc_linux_device_queue_depth(struct ahc_softc *ahc,
 					 struct ahc_linux_device *dev);
 static struct ahc_linux_target*	ahc_linux_alloc_target(struct ahc_softc*,
@@ -538,7 +462,6 @@
 				       struct ahc_linux_device*);
 static void ahc_linux_setup_tag_info_global(char *p);
 static aic_option_callback_t ahc_linux_setup_tag_info;
-static aic_option_callback_t ahc_linux_setup_dv;
 static int  aic7xxx_setup(char *s);
 static int  ahc_linux_next_unit(void);
 static void ahc_runq_tasklet(unsigned long data);
@@ -667,8 +590,7 @@
 {
 	
 	if ((ahc->flags & AHC_RESOURCE_SHORTAGE) != 0
-	 || (ahc->platform_data->qfrozen != 0
-	  && AHC_DV_SIMQ_FROZEN(ahc) == 0))
+	    || (ahc->platform_data->qfrozen != 0))
 		return (NULL);
 	return (TAILQ_FIRST(&ahc->platform_data->device_runq));
 }
@@ -966,8 +888,7 @@
 	 * DV commands through so long as we are only frozen to
 	 * perform DV.
 	 */
-	if (ahc->platform_data->qfrozen != 0
-	 && AHC_DV_CMD(cmd) == 0) {
+	if (ahc->platform_data->qfrozen != 0) {
 
 		ahc_cmd_set_transaction_status(cmd, CAM_REQUEUE_REQ);
 		ahc_linux_queue_cmd_complete(ahc, cmd);
@@ -1034,6 +955,11 @@
 		ahc_linux_device_queue_depth(ahc, dev);
 	}
 	ahc_midlayer_entrypoint_unlock(ahc, &flags);
+
+	/* Initial Domain Validation */
+	if (!spi_initial_dv(device->sdev_target))
+		spi_dv_device(device);
+
 	return (0);
 }
 
@@ -1549,18 +1475,6 @@
 	}
 }
 
-static void
-ahc_linux_setup_dv(u_long arg, int instance, int targ, int32_t value)
-{
-
-	if ((instance >= 0)
-	 && (instance < NUM_ELEMENTS(aic7xxx_dv_settings))) {
-		aic7xxx_dv_settings[instance] = value;
-		if (bootverbose)
-			printf("dv[%d] = %d\n", instance, value);
-	}
-}
-
 /*
  * Handle Linux boot parameters. This routine allows for assigning a value
  * to a parameter with a ':' between the parameter and the value.
@@ -1620,9 +1534,6 @@
 		} else if (strncmp(p, "tag_info", n) == 0) {
 			s = aic_parse_brace_option("tag_info", p + n, end,
 			    2, ahc_linux_setup_tag_info, 0);
-		} else if (strncmp(p, "dv", n) == 0) {
-			s = aic_parse_brace_option("dv", p + n, end, 1,
-			    ahc_linux_setup_dv, 0);
 		} else if (p[n] == ':') {
 			*(options[i].flag) = simple_strtoul(p + n + 1, NULL, 0);
 		} else if (strncmp(p, "verbose", n) == 0) {
@@ -1645,7 +1556,6 @@
 	struct	 Scsi_Host *host;
 	char	*new_name;
 	u_long	 s;
-	u_int	 targ_offset;
 
 	template->name = ahc->description;
 	host = scsi_host_alloc(template, sizeof(struct ahc_softc *));
@@ -1681,55 +1591,7 @@
 	scsi_set_pci_device(host, ahc->dev_softc);
 #endif
 	ahc_linux_initialize_scsi_bus(ahc);
-	ahc_unlock(ahc, &s);
-	ahc->platform_data->dv_pid = kernel_thread(ahc_linux_dv_thread, ahc, 0);
-	ahc_lock(ahc, &s);
-	if (ahc->platform_data->dv_pid < 0) {
-		printf("%s: Failed to create DV thread, error= %d\n",
-		       ahc_name(ahc), ahc->platform_data->dv_pid);
-		return (-ahc->platform_data->dv_pid);
-	}
-	/*
-	 * Initially allocate *all* of our linux target objects
-	 * so that the DV thread will scan them all in parallel
-	 * just after driver initialization.  Any device that
-	 * does not exist will have its target object destroyed
-	 * by the selection timeout handler.  In the case of a
-	 * device that appears after the initial DV scan, async
-	 * negotiation will occur for the first command, and DV
-	 * will comence should that first command be successful.
-	 */
-	for (targ_offset = 0;
-	     targ_offset < host->max_id * (host->max_channel + 1);
-	     targ_offset++) {
-		u_int channel;
-		u_int target;
-
-		channel = 0;
-		target = targ_offset;
-		if (target > 7
-		 && (ahc->features & AHC_TWIN) != 0) {
-			channel = 1;
-			target &= 0x7;
-		}
-		/*
-		 * Skip our own ID.  Some Compaq/HP storage devices
-		 * have enclosure management devices that respond to
-		 * single bit selection (i.e. selecting ourselves).
-		 * It is expected that either an external application
-		 * or a modified kernel will be used to probe this
-		 * ID if it is appropriate.  To accommodate these
-		 * installations, ahc_linux_alloc_target() will allocate
-		 * for our ID if asked to do so.
-		 */
-		if ((channel == 0 && target == ahc->our_id)
-		 || (channel == 1 && target == ahc->our_id_b))
-			continue;
-
-		ahc_linux_alloc_target(ahc, channel, target);
-	}
 	ahc_intr_enable(ahc, TRUE);
-	ahc_linux_start_dv(ahc);
 	ahc_unlock(ahc, &s);
 
 	host->transportt = ahc_linux_transport_template;
@@ -1866,8 +1728,6 @@
 	ahc->platform_data->completeq_timer.function =
 	    (ahc_linux_callback_t *)ahc_linux_thread_run_complete_queue;
 	init_MUTEX_LOCKED(&ahc->platform_data->eh_sem);
-	init_MUTEX_LOCKED(&ahc->platform_data->dv_sem);
-	init_MUTEX_LOCKED(&ahc->platform_data->dv_cmd_sem);
 	tasklet_init(&ahc->platform_data->runq_tasklet, ahc_runq_tasklet,
 		     (unsigned long)ahc);
 	ahc->seltime = (aic7xxx_seltime & 0x3) << 4;
@@ -1887,7 +1747,6 @@
 
 	if (ahc->platform_data != NULL) {
 		del_timer_sync(&ahc->platform_data->completeq_timer);
-		ahc_linux_kill_dv_thread(ahc);
 		tasklet_kill(&ahc->platform_data->runq_tasklet);
 		if (ahc->platform_data->host != NULL) {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
@@ -2126,1331 +1985,6 @@
 	ahc_unlock(ahc, &flags);
 }
 
-static void
-ahc_linux_start_dv(struct ahc_softc *ahc)
-{
-
-	/*
-	 * Freeze the simq and signal ahc_linux_queue to not let any
-	 * more commands through.
-	 */
-	if ((ahc->platform_data->flags & AHC_DV_ACTIVE) == 0) {
-#ifdef AHC_DEBUG
-		if (ahc_debug & AHC_SHOW_DV)
-			printf("%s: Waking DV thread\n", ahc_name(ahc));
-#endif
-
-		ahc->platform_data->flags |= AHC_DV_ACTIVE;
-		ahc_linux_freeze_simq(ahc);
-
-		/* Wake up the DV kthread */
-		up(&ahc->platform_data->dv_sem);
-	}
-}
-
-static void
-ahc_linux_kill_dv_thread(struct ahc_softc *ahc)
-{
-	u_long s;
-
-	ahc_lock(ahc, &s);
-	if (ahc->platform_data->dv_pid != 0) {
-		ahc->platform_data->flags |= AHC_DV_SHUTDOWN;
-		ahc_unlock(ahc, &s);
-		up(&ahc->platform_data->dv_sem);
-
-		/*
-		 * Use the eh_sem as an indicator that the
-		 * dv thread is exiting.  Note that the dv
-		 * thread must still return after performing
-		 * the up on our semaphore before it has
-		 * completely exited this module.  Unfortunately,
-		 * there seems to be no easy way to wait for the
-		 * exit of a thread for which you are not the
-		 * parent (dv threads are parented by init).
-		 * Cross your fingers...
-		 */
-		down(&ahc->platform_data->eh_sem);
-
-		/*
-		 * Mark the dv thread as already dead.  This
-		 * avoids attempting to kill it a second time.
-		 * This is necessary because we must kill the
-		 * DV thread before calling ahc_free() in the
-		 * module shutdown case to avoid bogus locking
-		 * in the SCSI mid-layer, but we ahc_free() is
-		 * called without killing the DV thread in the
-		 * instance detach case, so ahc_platform_free()
-		 * calls us again to verify that the DV thread
-		 * is dead.
-		 */
-		ahc->platform_data->dv_pid = 0;
-	} else {
-		ahc_unlock(ahc, &s);
-	}
-}
-
-static int
-ahc_linux_dv_thread(void *data)
-{
-	struct	ahc_softc *ahc;
-	int	target;
-	u_long	s;
-
-	ahc = (struct ahc_softc *)data;
-
-#ifdef AHC_DEBUG
-	if (ahc_debug & AHC_SHOW_DV)
-		printf("Launching DV Thread\n");
-#endif
-
-	/*
-	 * Complete thread creation.
-	 */
-	lock_kernel();
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	/*
-	 * Don't care about any signals.
-	 */
-	siginitsetinv(&current->blocked, 0);
-
-	daemonize();
-	sprintf(current->comm, "ahc_dv_%d", ahc->unit);
-#else
-	daemonize("ahc_dv_%d", ahc->unit);
-	current->flags |= PF_FREEZE;
-#endif
-	unlock_kernel();
-
-	while (1) {
-		/*
-		 * Use down_interruptible() rather than down() to
-		 * avoid inclusion in the load average.
-		 */
-		down_interruptible(&ahc->platform_data->dv_sem);
-
-		/* Check to see if we've been signaled to exit */
-		ahc_lock(ahc, &s);
-		if ((ahc->platform_data->flags & AHC_DV_SHUTDOWN) != 0) {
-			ahc_unlock(ahc, &s);
-			break;
-		}
-		ahc_unlock(ahc, &s);
-
-#ifdef AHC_DEBUG
-		if (ahc_debug & AHC_SHOW_DV)
-			printf("%s: Beginning Domain Validation\n",
-			       ahc_name(ahc));
-#endif
-
-		/*
-		 * Wait for any pending commands to drain before proceeding.
-		 */
-		ahc_lock(ahc, &s);
-		while (LIST_FIRST(&ahc->pending_scbs) != NULL) {
-			ahc->platform_data->flags |= AHC_DV_WAIT_SIMQ_EMPTY;
-			ahc_unlock(ahc, &s);
-			down_interruptible(&ahc->platform_data->dv_sem);
-			ahc_lock(ahc, &s);
-		}
-
-		/*
-		 * Wait for the SIMQ to be released so that DV is the
-		 * only reason the queue is frozen.
-		 */
-		while (AHC_DV_SIMQ_FROZEN(ahc) == 0) {
-			ahc->platform_data->flags |= AHC_DV_WAIT_SIMQ_RELEASE;
-			ahc_unlock(ahc, &s);
-			down_interruptible(&ahc->platform_data->dv_sem);
-			ahc_lock(ahc, &s);
-		}
-		ahc_unlock(ahc, &s);
-
-		for (target = 0; target < AHC_NUM_TARGETS; target++)
-			ahc_linux_dv_target(ahc, target);
-
-		ahc_lock(ahc, &s);
-		ahc->platform_data->flags &= ~AHC_DV_ACTIVE;
-		ahc_unlock(ahc, &s);
-
-		/*
-		 * Release the SIMQ so that normal commands are
-		 * allowed to continue on the bus.
-		 */
-		ahc_linux_release_simq((u_long)ahc);
-	}
-	up(&ahc->platform_data->eh_sem);
-	return (0);
-}
-
-#define AHC_LINUX_DV_INQ_SHORT_LEN	36
-#define AHC_LINUX_DV_INQ_LEN		256
-#define AHC_LINUX_DV_TIMEOUT		(HZ / 4)
-
-#define AHC_SET_DV_STATE(ahc, targ, newstate) \
-	ahc_set_dv_state(ahc, targ, newstate, __LINE__)
-
-static __inline void
-ahc_set_dv_state(struct ahc_softc *ahc, struct ahc_linux_target *targ,
-		 ahc_dv_state newstate, u_int line)
-{
-	ahc_dv_state oldstate;
-
-	oldstate = targ->dv_state;
-#ifdef AHC_DEBUG
-	if (ahc_debug & AHC_SHOW_DV)
-		printf("%s:%d: Going from state %d to state %d\n",
-		       ahc_name(ahc), line, oldstate, newstate);
-#endif
-
-	if (oldstate == newstate)
-		targ->dv_state_retry++;
-	else
-		targ->dv_state_retry = 0;
-	targ->dv_state = newstate;
-}
-
-static void
-ahc_linux_dv_target(struct ahc_softc *ahc, u_int target_offset)
-{
-	struct	 ahc_devinfo devinfo;
-	struct	 ahc_linux_target *targ;
-	struct	 scsi_cmnd *cmd;
-	struct	 scsi_device *scsi_dev;
-	struct	 scsi_sense_data *sense;
-	uint8_t *buffer;
-	u_long	 s;
-	u_int	 timeout;
-	int	 echo_size;
-
-	sense = NULL;
-	buffer = NULL;
-	echo_size = 0;
-	ahc_lock(ahc, &s);
-	targ = ahc->platform_data->targets[target_offset];
-	if (targ == NULL || (targ->flags & AHC_DV_REQUIRED) == 0) {
-		ahc_unlock(ahc, &s);
-		return;
-	}
-	ahc_compile_devinfo(&devinfo,
-			    targ->channel == 0 ? ahc->our_id : ahc->our_id_b,
-			    targ->target, /*lun*/0, targ->channel + 'A',
-			    ROLE_INITIATOR);
-#ifdef AHC_DEBUG
-	if (ahc_debug & AHC_SHOW_DV) {
-		ahc_print_devinfo(ahc, &devinfo);
-		printf("Performing DV\n");
-	}
-#endif
-
-	ahc_unlock(ahc, &s);
-
-	cmd = malloc(sizeof(struct scsi_cmnd), M_DEVBUF, M_WAITOK);
-	scsi_dev = malloc(sizeof(struct scsi_device), M_DEVBUF, M_WAITOK);
-	scsi_dev->host = ahc->platform_data->host;
-	scsi_dev->id = devinfo.target;
-	scsi_dev->lun = devinfo.lun;
-	scsi_dev->channel = devinfo.channel - 'A';
-	ahc->platform_data->dv_scsi_dev = scsi_dev;
-
-	AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_INQ_SHORT_ASYNC);
-
-	while (targ->dv_state != AHC_DV_STATE_EXIT) {
-		timeout = AHC_LINUX_DV_TIMEOUT;
-		switch (targ->dv_state) {
-		case AHC_DV_STATE_INQ_SHORT_ASYNC:
-		case AHC_DV_STATE_INQ_ASYNC:
-		case AHC_DV_STATE_INQ_ASYNC_VERIFY:
-			/*
-			 * Set things to async narrow to reduce the
-			 * chance that the INQ will fail.
-			 */
-			ahc_lock(ahc, &s);
-			ahc_set_syncrate(ahc, &devinfo, NULL, 0, 0, 0,
-					 AHC_TRANS_GOAL, /*paused*/FALSE);
-			ahc_set_width(ahc, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
-				      AHC_TRANS_GOAL, /*paused*/FALSE);
-			ahc_unlock(ahc, &s);
-			timeout = 10 * HZ;
-			targ->flags &= ~AHC_INQ_VALID;
-			/* FALLTHROUGH */
-		case AHC_DV_STATE_INQ_VERIFY:
-		{
-			u_int inq_len;
-
-			if (targ->dv_state == AHC_DV_STATE_INQ_SHORT_ASYNC)
-				inq_len = AHC_LINUX_DV_INQ_SHORT_LEN;
-			else
-				inq_len = targ->inq_data->additional_length + 5;
-			ahc_linux_dv_inq(ahc, cmd, &devinfo, targ, inq_len);
-			break;
-		}
-		case AHC_DV_STATE_TUR:
-		case AHC_DV_STATE_BUSY:
-			timeout = 5 * HZ;
-			ahc_linux_dv_tur(ahc, cmd, &devinfo);
-			break;
-		case AHC_DV_STATE_REBD:
-			ahc_linux_dv_rebd(ahc, cmd, &devinfo, targ);
-			break;
-		case AHC_DV_STATE_WEB:
-			ahc_linux_dv_web(ahc, cmd, &devinfo, targ);
-			break;
-
-		case AHC_DV_STATE_REB:
-			ahc_linux_dv_reb(ahc, cmd, &devinfo, targ);
-			break;
-
-		case AHC_DV_STATE_SU:
-			ahc_linux_dv_su(ahc, cmd, &devinfo, targ);
-			timeout = 50 * HZ;
-			break;
-
-		default:
-			ahc_print_devinfo(ahc, &devinfo);
-			printf("Unknown DV state %d\n", targ->dv_state);
-			goto out;
-		}
-
-		/* Queue the command and wait for it to complete */
-		/* Abuse eh_timeout in the scsi_cmnd struct for our purposes */
-		init_timer(&cmd->eh_timeout);
-#ifdef AHC_DEBUG
-		if ((ahc_debug & AHC_SHOW_MESSAGES) != 0)
-			/*
-			 * All of the printfs during negotiation
-			 * really slow down the negotiation.
-			 * Add a bit of time just to be safe.
-			 */
-			timeout += HZ;
-#endif
-		scsi_add_timer(cmd, timeout, ahc_linux_dv_timeout);
-		/*
-		 * In 2.5.X, it is assumed that all calls from the
-		 * "midlayer" (which we are emulating) will have the
-		 * ahc host lock held.  For other kernels, the
-		 * io_request_lock must be held.
-		 */
-#if AHC_SCSI_HAS_HOST_LOCK != 0
-		ahc_lock(ahc, &s);
-#else
-		spin_lock_irqsave(&io_request_lock, s);
-#endif
-		ahc_linux_queue(cmd, ahc_linux_dv_complete);
-#if AHC_SCSI_HAS_HOST_LOCK != 0
-		ahc_unlock(ahc, &s);
-#else
-		spin_unlock_irqrestore(&io_request_lock, s);
-#endif
-		down_interruptible(&ahc->platform_data->dv_cmd_sem);
-		/*
-		 * Wait for the SIMQ to be released so that DV is the
-		 * only reason the queue is frozen.
-		 */
-		ahc_lock(ahc, &s);
-		while (AHC_DV_SIMQ_FROZEN(ahc) == 0) {
-			ahc->platform_data->flags |= AHC_DV_WAIT_SIMQ_RELEASE;
-			ahc_unlock(ahc, &s);
-			down_interruptible(&ahc->platform_data->dv_sem);
-			ahc_lock(ahc, &s);
-		}
-		ahc_unlock(ahc, &s);
-
-		ahc_linux_dv_transition(ahc, cmd, &devinfo, targ);
-	}
-
-out:
-	if ((targ->flags & AHC_INQ_VALID) != 0
-	 && ahc_linux_get_device(ahc, devinfo.channel - 'A',
-				 devinfo.target, devinfo.lun,
-				 /*alloc*/FALSE) == NULL) {
-		/*
-		 * The DV state machine failed to configure this device.  
-		 * This is normal if DV is disabled.  Since we have inquiry
-		 * data, filter it and use the "optimistic" negotiation
-		 * parameters found in the inquiry string.
-		 */
-		ahc_linux_filter_inquiry(ahc, &devinfo);
-		if ((targ->flags & (AHC_BASIC_DV|AHC_ENHANCED_DV)) != 0) {
-			ahc_print_devinfo(ahc, &devinfo);
-			printf("DV failed to configure device.  "
-			       "Please file a bug report against "
-			       "this driver.\n");
-		}
-	}
-
-	if (cmd != NULL)
-		free(cmd, M_DEVBUF);
-
-	if (ahc->platform_data->dv_scsi_dev != NULL) {
-		free(ahc->platform_data->dv_scsi_dev, M_DEVBUF);
-		ahc->platform_data->dv_scsi_dev = NULL;
-	}
-
-	ahc_lock(ahc, &s);
-	if (targ->dv_buffer != NULL) {
-		free(targ->dv_buffer, M_DEVBUF);
-		targ->dv_buffer = NULL;
-	}
-	if (targ->dv_buffer1 != NULL) {
-		free(targ->dv_buffer1, M_DEVBUF);
-		targ->dv_buffer1 = NULL;
-	}
-	targ->flags &= ~AHC_DV_REQUIRED;
-	if (targ->refcount == 0)
-		ahc_linux_free_target(ahc, targ);
-	ahc_unlock(ahc, &s);
-}
-
-static void
-ahc_linux_dv_transition(struct ahc_softc *ahc, struct scsi_cmnd *cmd,
-			struct ahc_devinfo *devinfo,
-			struct ahc_linux_target *targ)
-{
-	u_int32_t status;
-
-	status = aic_error_action(cmd, targ->inq_data,
-				  ahc_cmd_get_transaction_status(cmd),
-				  ahc_cmd_get_scsi_status(cmd));
-	
-#ifdef AHC_DEBUG
-	if (ahc_debug & AHC_SHOW_DV) {
-		ahc_print_devinfo(ahc, devinfo);
-		printf("Entering ahc_linux_dv_transition, state= %d, "
-		       "status= 0x%x, cmd->result= 0x%x\n", targ->dv_state,
-		       status, cmd->result);
-	}
-#endif
-
-	switch (targ->dv_state) {
-	case AHC_DV_STATE_INQ_SHORT_ASYNC:
-	case AHC_DV_STATE_INQ_ASYNC:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-		{
-			AHC_SET_DV_STATE(ahc, targ, targ->dv_state+1);
-			break;
-		}
-		case SS_INQ_REFRESH:
-			AHC_SET_DV_STATE(ahc, targ,
-					 AHC_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		case SS_TUR:
-		case SS_RETRY:
-			AHC_SET_DV_STATE(ahc, targ, targ->dv_state);
-			if (ahc_cmd_get_transaction_status(cmd)
-			 == CAM_REQUEUE_REQ)
-				targ->dv_state_retry--;
-			if ((status & SS_ERRMASK) == EBUSY)
-				AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_BUSY);
-			if (targ->dv_state_retry < 10)
-				break;
-			/* FALLTHROUGH */
-		default:
-			AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_EXIT);
-#ifdef AHC_DEBUG
-			if (ahc_debug & AHC_SHOW_DV) {
-				ahc_print_devinfo(ahc, devinfo);
-				printf("Failed DV inquiry, skipping\n");
-			}
-#endif
-			break;
-		}
-		break;
-	case AHC_DV_STATE_INQ_ASYNC_VERIFY:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-		{
-			u_int xportflags;
-			u_int spi3data;
-
-			if (memcmp(targ->inq_data, targ->dv_buffer,
-				   AHC_LINUX_DV_INQ_LEN) != 0) {
-				/*
-				 * Inquiry data must have changed.
-				 * Try from the top again.
-				 */
-				AHC_SET_DV_STATE(ahc, targ,
-						 AHC_DV_STATE_INQ_SHORT_ASYNC);
-				break;
-			}
-
-			AHC_SET_DV_STATE(ahc, targ, targ->dv_state+1);
-			targ->flags |= AHC_INQ_VALID;
-			if (ahc_linux_user_dv_setting(ahc) == 0)
-				break;
-
-			xportflags = targ->inq_data->flags;
-			if ((xportflags & (SID_Sync|SID_WBus16)) == 0)
-				break;
-
-			spi3data = targ->inq_data->spi3data;
-			switch (spi3data & SID_SPI_CLOCK_DT_ST) {
-			default:
-			case SID_SPI_CLOCK_ST:
-				/* Assume only basic DV is supported. */
-				targ->flags |= AHC_BASIC_DV;
-				break;
-			case SID_SPI_CLOCK_DT:
-			case SID_SPI_CLOCK_DT_ST:
-				targ->flags |= AHC_ENHANCED_DV;
-				break;
-			}
-			break;
-		}
-		case SS_INQ_REFRESH:
-			AHC_SET_DV_STATE(ahc, targ,
-					 AHC_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		case SS_TUR:
-		case SS_RETRY:
-			AHC_SET_DV_STATE(ahc, targ, targ->dv_state);
-			if (ahc_cmd_get_transaction_status(cmd)
-			 == CAM_REQUEUE_REQ)
-				targ->dv_state_retry--;
-
-			if ((status & SS_ERRMASK) == EBUSY)
-				AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_BUSY);
-			if (targ->dv_state_retry < 10)
-				break;
-			/* FALLTHROUGH */
-		default:
-			AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_EXIT);
-#ifdef AHC_DEBUG
-			if (ahc_debug & AHC_SHOW_DV) {
-				ahc_print_devinfo(ahc, devinfo);
-				printf("Failed DV inquiry, skipping\n");
-			}
-#endif
-			break;
-		}
-		break;
-	case AHC_DV_STATE_INQ_VERIFY:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-		{
-
-			if (memcmp(targ->inq_data, targ->dv_buffer,
-				   AHC_LINUX_DV_INQ_LEN) == 0) {
-				AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_EXIT);
-				break;
-			}
-#ifdef AHC_DEBUG
-			if (ahc_debug & AHC_SHOW_DV) {
-				int i;
-
-				ahc_print_devinfo(ahc, devinfo);
-				printf("Inquiry buffer mismatch:");
-				for (i = 0; i < AHC_LINUX_DV_INQ_LEN; i++) {
-					if ((i & 0xF) == 0)
-						printf("\n        ");
-					printf("0x%x:0x0%x ",
-					       ((uint8_t *)targ->inq_data)[i], 
-					       targ->dv_buffer[i]);
-				}
-				printf("\n");
-			}
-#endif
-
-			if (ahc_linux_fallback(ahc, devinfo) != 0) {
-				AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_EXIT);
-				break;
-			}
-			/*
-			 * Do not count "falling back"
-			 * against our retries.
-			 */
-			targ->dv_state_retry = 0;
-			AHC_SET_DV_STATE(ahc, targ, targ->dv_state);
-			break;
-		}
-		case SS_INQ_REFRESH:
-			AHC_SET_DV_STATE(ahc, targ,
-					 AHC_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		case SS_TUR:
-		case SS_RETRY:
-			AHC_SET_DV_STATE(ahc, targ, targ->dv_state);
-			if (ahc_cmd_get_transaction_status(cmd)
-			 == CAM_REQUEUE_REQ) {
-				targ->dv_state_retry--;
-			} else if ((status & SSQ_FALLBACK) != 0) {
-				if (ahc_linux_fallback(ahc, devinfo) != 0) {
-					AHC_SET_DV_STATE(ahc, targ,
-							 AHC_DV_STATE_EXIT);
-					break;
-				}
-				/*
-				 * Do not count "falling back"
-				 * against our retries.
-				 */
-				targ->dv_state_retry = 0;
-			} else if ((status & SS_ERRMASK) == EBUSY)
-				AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_BUSY);
-			if (targ->dv_state_retry < 10)
-				break;
-			/* FALLTHROUGH */
-		default:
-			AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_EXIT);
-#ifdef AHC_DEBUG
-			if (ahc_debug & AHC_SHOW_DV) {
-				ahc_print_devinfo(ahc, devinfo);
-				printf("Failed DV inquiry, skipping\n");
-			}
-#endif
-			break;
-		}
-		break;
-
-	case AHC_DV_STATE_TUR:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-			if ((targ->flags & AHC_BASIC_DV) != 0) {
-				ahc_linux_filter_inquiry(ahc, devinfo);
-				AHC_SET_DV_STATE(ahc, targ,
-						 AHC_DV_STATE_INQ_VERIFY);
-			} else if ((targ->flags & AHC_ENHANCED_DV) != 0) {
-				AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_REBD);
-			} else {
-				AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_EXIT);
-			}
-			break;
-		case SS_RETRY:
-		case SS_TUR:
-			if ((status & SS_ERRMASK) == EBUSY) {
-				AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_BUSY);
-				break;
-			}
-			AHC_SET_DV_STATE(ahc, targ, targ->dv_state);
-			if (ahc_cmd_get_transaction_status(cmd)
-			 == CAM_REQUEUE_REQ) {
-				targ->dv_state_retry--;
-			} else if ((status & SSQ_FALLBACK) != 0) {
-				if (ahc_linux_fallback(ahc, devinfo) != 0) {
-					AHC_SET_DV_STATE(ahc, targ,
-							 AHC_DV_STATE_EXIT);
-					break;
-				}
-				/*
-				 * Do not count "falling back"
-				 * against our retries.
-				 */
-				targ->dv_state_retry = 0;
-			}
-			if (targ->dv_state_retry >= 10) {
-#ifdef AHC_DEBUG
-				if (ahc_debug & AHC_SHOW_DV) {
-					ahc_print_devinfo(ahc, devinfo);
-					printf("DV TUR reties exhausted\n");
-				}
-#endif
-				AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_EXIT);
-				break;
-			}
-			if (status & SSQ_DELAY)
-				ssleep(1);
-
-			break;
-		case SS_START:
-			AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_SU);
-			break;
-		case SS_INQ_REFRESH:
-			AHC_SET_DV_STATE(ahc, targ,
-					 AHC_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		default:
-			AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_EXIT);
-			break;
-		}
-		break;
-
-	case AHC_DV_STATE_REBD:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-		{
-			uint32_t echo_size;
-
-			AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_WEB);
-			echo_size = scsi_3btoul(&targ->dv_buffer[1]);
-			echo_size &= 0x1FFF;
-#ifdef AHC_DEBUG
-			if (ahc_debug & AHC_SHOW_DV) {
-				ahc_print_devinfo(ahc, devinfo);
-				printf("Echo buffer size= %d\n", echo_size);
-			}
-#endif
-			if (echo_size == 0) {
-				AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_EXIT);
-				break;
-			}
-
-			/* Generate the buffer pattern */
-			targ->dv_echo_size = echo_size;
-			ahc_linux_generate_dv_pattern(targ);
-			/*
-			 * Setup initial negotiation values.
-			 */
-			ahc_linux_filter_inquiry(ahc, devinfo);
-			break;
-		}
-		case SS_INQ_REFRESH:
-			AHC_SET_DV_STATE(ahc, targ,
-					 AHC_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		case SS_RETRY:
-			AHC_SET_DV_STATE(ahc, targ, targ->dv_state);
-			if (ahc_cmd_get_transaction_status(cmd)
-			 == CAM_REQUEUE_REQ)
-				targ->dv_state_retry--;
-			if (targ->dv_state_retry <= 10)
-				break;
-#ifdef AHC_DEBUG
-			if (ahc_debug & AHC_SHOW_DV) {
-				ahc_print_devinfo(ahc, devinfo);
-				printf("DV REBD reties exhausted\n");
-			}
-#endif
-			/* FALLTHROUGH */
-		case SS_FATAL:
-		default:
-			/*
-			 * Setup initial negotiation values
-			 * and try level 1 DV.
-			 */
-			ahc_linux_filter_inquiry(ahc, devinfo);
-			AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_INQ_VERIFY);
-			targ->dv_echo_size = 0;
-			break;
-		}
-		break;
-
-	case AHC_DV_STATE_WEB:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-			AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_REB);
-			break;
-		case SS_INQ_REFRESH:
-			AHC_SET_DV_STATE(ahc, targ,
-					 AHC_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		case SS_RETRY:
-			AHC_SET_DV_STATE(ahc, targ, targ->dv_state);
-			if (ahc_cmd_get_transaction_status(cmd)
-			 == CAM_REQUEUE_REQ) {
-				targ->dv_state_retry--;
-			} else if ((status & SSQ_FALLBACK) != 0) {
-				if (ahc_linux_fallback(ahc, devinfo) != 0) {
-					AHC_SET_DV_STATE(ahc, targ,
-							 AHC_DV_STATE_EXIT);
-					break;
-				}
-				/*
-				 * Do not count "falling back"
-				 * against our retries.
-				 */
-				targ->dv_state_retry = 0;
-			}
-			if (targ->dv_state_retry <= 10)
-				break;
-			/* FALLTHROUGH */
-#ifdef AHC_DEBUG
-			if (ahc_debug & AHC_SHOW_DV) {
-				ahc_print_devinfo(ahc, devinfo);
-				printf("DV WEB reties exhausted\n");
-			}
-#endif
-		default:
-			AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_EXIT);
-			break;
-		}
-		break;
-
-	case AHC_DV_STATE_REB:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-			if (memcmp(targ->dv_buffer, targ->dv_buffer1,
-				   targ->dv_echo_size) != 0) {
-				if (ahc_linux_fallback(ahc, devinfo) != 0)
-					AHC_SET_DV_STATE(ahc, targ,
-							 AHC_DV_STATE_EXIT);
-				else
-					AHC_SET_DV_STATE(ahc, targ,
-							 AHC_DV_STATE_WEB);
-				break;
-			}
-			
-			if (targ->dv_buffer != NULL) {
-				free(targ->dv_buffer, M_DEVBUF);
-				targ->dv_buffer = NULL;
-			}
-			if (targ->dv_buffer1 != NULL) {
-				free(targ->dv_buffer1, M_DEVBUF);
-				targ->dv_buffer1 = NULL;
-			}
-			AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_EXIT);
-			break;
-		case SS_INQ_REFRESH:
-			AHC_SET_DV_STATE(ahc, targ,
-					 AHC_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		case SS_RETRY:
-			AHC_SET_DV_STATE(ahc, targ, targ->dv_state);
-			if (ahc_cmd_get_transaction_status(cmd)
-			 == CAM_REQUEUE_REQ) {
-				targ->dv_state_retry--;
-			} else if ((status & SSQ_FALLBACK) != 0) {
-				if (ahc_linux_fallback(ahc, devinfo) != 0) {
-					AHC_SET_DV_STATE(ahc, targ,
-							 AHC_DV_STATE_EXIT);
-					break;
-				}
-				AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_WEB);
-			}
-			if (targ->dv_state_retry <= 10) {
-				if ((status & (SSQ_DELAY_RANDOM|SSQ_DELAY))!= 0)
-					msleep(ahc->our_id*1000/10);
-				break;
-			}
-#ifdef AHC_DEBUG
-			if (ahc_debug & AHC_SHOW_DV) {
-				ahc_print_devinfo(ahc, devinfo);
-				printf("DV REB reties exhausted\n");
-			}
-#endif
-			/* FALLTHROUGH */
-		default:
-			AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_EXIT);
-			break;
-		}
-		break;
-
-	case AHC_DV_STATE_SU:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-		case SS_INQ_REFRESH:
-			AHC_SET_DV_STATE(ahc, targ,
-					 AHC_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		default:
-			AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_EXIT);
-			break;
-		}
-		break;
-
-	case AHC_DV_STATE_BUSY:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-		case SS_INQ_REFRESH:
-			AHC_SET_DV_STATE(ahc, targ,
-					 AHC_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		case SS_TUR:
-		case SS_RETRY:
-			AHC_SET_DV_STATE(ahc, targ, targ->dv_state);
-			if (ahc_cmd_get_transaction_status(cmd)
-			 == CAM_REQUEUE_REQ) {
-				targ->dv_state_retry--;
-			} else if (targ->dv_state_retry < 60) {
-				if ((status & SSQ_DELAY) != 0)
-					ssleep(1);
-			} else {
-#ifdef AHC_DEBUG
-				if (ahc_debug & AHC_SHOW_DV) {
-					ahc_print_devinfo(ahc, devinfo);
-					printf("DV BUSY reties exhausted\n");
-				}
-#endif
-				AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_EXIT);
-			}
-			break;
-		default:
-			AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_EXIT);
-			break;
-		}
-		break;
-
-	default:
-		printf("%s: Invalid DV completion state %d\n", ahc_name(ahc),
-		       targ->dv_state);
-		AHC_SET_DV_STATE(ahc, targ, AHC_DV_STATE_EXIT);
-		break;
-	}
-}
-
-static void
-ahc_linux_dv_fill_cmd(struct ahc_softc *ahc, struct scsi_cmnd *cmd,
-		      struct ahc_devinfo *devinfo)
-{
-	memset(cmd, 0, sizeof(struct scsi_cmnd));
-	cmd->device = ahc->platform_data->dv_scsi_dev;
-	cmd->scsi_done = ahc_linux_dv_complete;
-}
-
-/*
- * Synthesize an inquiry command.  On the return trip, it'll be
- * sniffed and the device transfer settings set for us.
- */
-static void
-ahc_linux_dv_inq(struct ahc_softc *ahc, struct scsi_cmnd *cmd,
-		 struct ahc_devinfo *devinfo, struct ahc_linux_target *targ,
-		 u_int request_length)
-{
-
-#ifdef AHC_DEBUG
-	if (ahc_debug & AHC_SHOW_DV) {
-		ahc_print_devinfo(ahc, devinfo);
-		printf("Sending INQ\n");
-	}
-#endif
-	if (targ->inq_data == NULL)
-		targ->inq_data = malloc(AHC_LINUX_DV_INQ_LEN,
-					M_DEVBUF, M_WAITOK);
-	if (targ->dv_state > AHC_DV_STATE_INQ_ASYNC) {
-		if (targ->dv_buffer != NULL)
-			free(targ->dv_buffer, M_DEVBUF);
-		targ->dv_buffer = malloc(AHC_LINUX_DV_INQ_LEN,
-					 M_DEVBUF, M_WAITOK);
-	}
-
-	ahc_linux_dv_fill_cmd(ahc, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_READ;
-	cmd->cmd_len = 6;
-	cmd->cmnd[0] = INQUIRY;
-	cmd->cmnd[4] = request_length;
-	cmd->request_bufflen = request_length;
-	if (targ->dv_state > AHC_DV_STATE_INQ_ASYNC)
-		cmd->request_buffer = targ->dv_buffer;
-	else
-		cmd->request_buffer = targ->inq_data;
-	memset(cmd->request_buffer, 0, AHC_LINUX_DV_INQ_LEN);
-}
-
-static void
-ahc_linux_dv_tur(struct ahc_softc *ahc, struct scsi_cmnd *cmd,
-		 struct ahc_devinfo *devinfo)
-{
-
-#ifdef AHC_DEBUG
-	if (ahc_debug & AHC_SHOW_DV) {
-		ahc_print_devinfo(ahc, devinfo);
-		printf("Sending TUR\n");
-	}
-#endif
-	/* Do a TUR to clear out any non-fatal transitional state */
-	ahc_linux_dv_fill_cmd(ahc, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_NONE;
-	cmd->cmd_len = 6;
-	cmd->cmnd[0] = TEST_UNIT_READY;
-}
-
-#define AHC_REBD_LEN 4
-
-static void
-ahc_linux_dv_rebd(struct ahc_softc *ahc, struct scsi_cmnd *cmd,
-		 struct ahc_devinfo *devinfo, struct ahc_linux_target *targ)
-{
-
-#ifdef AHC_DEBUG
-	if (ahc_debug & AHC_SHOW_DV) {
-		ahc_print_devinfo(ahc, devinfo);
-		printf("Sending REBD\n");
-	}
-#endif
-	if (targ->dv_buffer != NULL)
-		free(targ->dv_buffer, M_DEVBUF);
-	targ->dv_buffer = malloc(AHC_REBD_LEN, M_DEVBUF, M_WAITOK);
-	ahc_linux_dv_fill_cmd(ahc, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_READ;
-	cmd->cmd_len = 10;
-	cmd->cmnd[0] = READ_BUFFER;
-	cmd->cmnd[1] = 0x0b;
-	scsi_ulto3b(AHC_REBD_LEN, &cmd->cmnd[6]);
-	cmd->request_bufflen = AHC_REBD_LEN;
-	cmd->underflow = cmd->request_bufflen;
-	cmd->request_buffer = targ->dv_buffer;
-}
-
-static void
-ahc_linux_dv_web(struct ahc_softc *ahc, struct scsi_cmnd *cmd,
-		 struct ahc_devinfo *devinfo, struct ahc_linux_target *targ)
-{
-
-#ifdef AHC_DEBUG
-	if (ahc_debug & AHC_SHOW_DV) {
-		ahc_print_devinfo(ahc, devinfo);
-		printf("Sending WEB\n");
-	}
-#endif
-	ahc_linux_dv_fill_cmd(ahc, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_WRITE;
-	cmd->cmd_len = 10;
-	cmd->cmnd[0] = WRITE_BUFFER;
-	cmd->cmnd[1] = 0x0a;
-	scsi_ulto3b(targ->dv_echo_size, &cmd->cmnd[6]);
-	cmd->request_bufflen = targ->dv_echo_size;
-	cmd->underflow = cmd->request_bufflen;
-	cmd->request_buffer = targ->dv_buffer;
-}
-
-static void
-ahc_linux_dv_reb(struct ahc_softc *ahc, struct scsi_cmnd *cmd,
-		 struct ahc_devinfo *devinfo, struct ahc_linux_target *targ)
-{
-
-#ifdef AHC_DEBUG
-	if (ahc_debug & AHC_SHOW_DV) {
-		ahc_print_devinfo(ahc, devinfo);
-		printf("Sending REB\n");
-	}
-#endif
-	ahc_linux_dv_fill_cmd(ahc, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_READ;
-	cmd->cmd_len = 10;
-	cmd->cmnd[0] = READ_BUFFER;
-	cmd->cmnd[1] = 0x0a;
-	scsi_ulto3b(targ->dv_echo_size, &cmd->cmnd[6]);
-	cmd->request_bufflen = targ->dv_echo_size;
-	cmd->underflow = cmd->request_bufflen;
-	cmd->request_buffer = targ->dv_buffer1;
-}
-
-static void
-ahc_linux_dv_su(struct ahc_softc *ahc, struct scsi_cmnd *cmd,
-		struct ahc_devinfo *devinfo,
-		struct ahc_linux_target *targ)
-{
-	u_int le;
-
-	le = SID_IS_REMOVABLE(targ->inq_data) ? SSS_LOEJ : 0;
-
-#ifdef AHC_DEBUG
-	if (ahc_debug & AHC_SHOW_DV) {
-		ahc_print_devinfo(ahc, devinfo);
-		printf("Sending SU\n");
-	}
-#endif
-	ahc_linux_dv_fill_cmd(ahc, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_NONE;
-	cmd->cmd_len = 6;
-	cmd->cmnd[0] = START_STOP_UNIT;
-	cmd->cmnd[4] = le | SSS_START;
-}
-
-static int
-ahc_linux_fallback(struct ahc_softc *ahc, struct ahc_devinfo *devinfo)
-{
-	struct	ahc_linux_target *targ;
-	struct	ahc_initiator_tinfo *tinfo;
-	struct	ahc_transinfo *goal;
-	struct	ahc_tmode_tstate *tstate;
-	struct	ahc_syncrate *syncrate;
-	u_long	s;
-	u_int	width;
-	u_int	period;
-	u_int	offset;
-	u_int	ppr_options;
-	u_int	cur_speed;
-	u_int	wide_speed;
-	u_int	narrow_speed;
-	u_int	fallback_speed;
-
-#ifdef AHC_DEBUG
-	if (ahc_debug & AHC_SHOW_DV) {
-		ahc_print_devinfo(ahc, devinfo);
-		printf("Trying to fallback\n");
-	}
-#endif
-	ahc_lock(ahc, &s);
-	targ = ahc->platform_data->targets[devinfo->target_offset];
-	tinfo = ahc_fetch_transinfo(ahc, devinfo->channel,
-				    devinfo->our_scsiid,
-				    devinfo->target, &tstate);
-	goal = &tinfo->goal;
-	width = goal->width;
-	period = goal->period;
-	offset = goal->offset;
-	ppr_options = goal->ppr_options;
-	if (offset == 0)
-		period = AHC_ASYNC_XFER_PERIOD;
-	if (targ->dv_next_narrow_period == 0)
-		targ->dv_next_narrow_period = MAX(period, AHC_SYNCRATE_ULTRA2);
-	if (targ->dv_next_wide_period == 0)
-		targ->dv_next_wide_period = period;
-	if (targ->dv_max_width == 0)
-		targ->dv_max_width = width;
-	if (targ->dv_max_ppr_options == 0)
-		targ->dv_max_ppr_options = ppr_options;
-	if (targ->dv_last_ppr_options == 0)
-		targ->dv_last_ppr_options = ppr_options;
-
-	cur_speed = aic_calc_speed(width, period, offset, AHC_SYNCRATE_MIN);
-	wide_speed = aic_calc_speed(MSG_EXT_WDTR_BUS_16_BIT,
-					  targ->dv_next_wide_period,
-					  MAX_OFFSET,
-					  AHC_SYNCRATE_MIN);
-	narrow_speed = aic_calc_speed(MSG_EXT_WDTR_BUS_8_BIT,
-					    targ->dv_next_narrow_period,
-					    MAX_OFFSET,
-					    AHC_SYNCRATE_MIN);
-	fallback_speed = aic_calc_speed(width, period+1, offset,
-					AHC_SYNCRATE_MIN);
-#ifdef AHC_DEBUG
-	if (ahc_debug & AHC_SHOW_DV) {
-		printf("cur_speed= %d, wide_speed= %d, narrow_speed= %d, "
-		       "fallback_speed= %d\n", cur_speed, wide_speed,
-		       narrow_speed, fallback_speed);
-	}
-#endif
-
-	if (cur_speed > 160000) {
-		/*
-		 * Paced/DT/IU_REQ only transfer speeds.  All we
-		 * can do is fallback in terms of syncrate.
-		 */
-		period++;
-	} else if (cur_speed > 80000) {
-		if ((ppr_options & MSG_EXT_PPR_IU_REQ) != 0) {
-			/*
-			 * Try without IU_REQ as it may be confusing
-			 * an expander.
-			 */
-			ppr_options &= ~MSG_EXT_PPR_IU_REQ;
-		} else {
-			/*
-			 * Paced/DT only transfer speeds.  All we
-			 * can do is fallback in terms of syncrate.
-			 */
-			period++;
-			ppr_options = targ->dv_max_ppr_options;
-		}
-	} else if (cur_speed > 3300) {
-
-		/*
-		 * In this range we the following
-		 * options ordered from highest to
-		 * lowest desireability:
-		 *
-		 * o Wide/DT
-		 * o Wide/non-DT
-		 * o Narrow at a potentally higher sync rate.
-		 *
-		 * All modes are tested with and without IU_REQ
-		 * set since using IUs may confuse an expander.
-		 */
-		if ((ppr_options & MSG_EXT_PPR_IU_REQ) != 0) {
-
-			ppr_options &= ~MSG_EXT_PPR_IU_REQ;
-		} else if ((ppr_options & MSG_EXT_PPR_DT_REQ) != 0) {
-			/*
-			 * Try going non-DT.
-			 */
-			ppr_options = targ->dv_max_ppr_options;
-			ppr_options &= ~MSG_EXT_PPR_DT_REQ;
-		} else if (targ->dv_last_ppr_options != 0) {
-			/*
-			 * Try without QAS or any other PPR options.
-			 * We may need a non-PPR message to work with
-			 * an expander.  We look at the "last PPR options"
-			 * so we will perform this fallback even if the
-			 * target responded to our PPR negotiation with
-			 * no option bits set.
-			 */
-			ppr_options = 0;
-		} else if (width == MSG_EXT_WDTR_BUS_16_BIT) {
-			/*
-			 * If the next narrow speed is greater than
-			 * the next wide speed, fallback to narrow.
-			 * Otherwise fallback to the next DT/Wide setting.
-			 * The narrow async speed will always be smaller
-			 * than the wide async speed, so handle this case
-			 * specifically.
-			 */
-			ppr_options = targ->dv_max_ppr_options;
-			if (narrow_speed > fallback_speed
-			 || period >= AHC_ASYNC_XFER_PERIOD) {
-				targ->dv_next_wide_period = period+1;
-				width = MSG_EXT_WDTR_BUS_8_BIT;
-				period = targ->dv_next_narrow_period;
-			} else {
-				period++;
-			}
-		} else if ((ahc->features & AHC_WIDE) != 0
-			&& targ->dv_max_width != 0
-			&& wide_speed >= fallback_speed
-			&& (targ->dv_next_wide_period <= AHC_ASYNC_XFER_PERIOD
-			 || period >= AHC_ASYNC_XFER_PERIOD)) {
-
-			/*
-			 * We are narrow.  Try falling back
-			 * to the next wide speed with 
-			 * all supported ppr options set.
-			 */
-			targ->dv_next_narrow_period = period+1;
-			width = MSG_EXT_WDTR_BUS_16_BIT;
-			period = targ->dv_next_wide_period;
-			ppr_options = targ->dv_max_ppr_options;
-		} else {
-			/* Only narrow fallback is allowed. */
-			period++;
-			ppr_options = targ->dv_max_ppr_options;
-		}
-	} else {
-		ahc_unlock(ahc, &s);
-		return (-1);
-	}
-	offset = MAX_OFFSET;
-	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options,
-				     AHC_SYNCRATE_DT);
-	ahc_set_width(ahc, devinfo, width, AHC_TRANS_GOAL, FALSE);
-	if (period == 0) {
-		period = 0;
-		offset = 0;
-		ppr_options = 0;
-		if (width == MSG_EXT_WDTR_BUS_8_BIT)
-			targ->dv_next_narrow_period = AHC_ASYNC_XFER_PERIOD;
-		else
-			targ->dv_next_wide_period = AHC_ASYNC_XFER_PERIOD;
-	}
-	ahc_set_syncrate(ahc, devinfo, syncrate, period, offset,
-			 ppr_options, AHC_TRANS_GOAL, FALSE);
-	targ->dv_last_ppr_options = ppr_options;
-	ahc_unlock(ahc, &s);
-	return (0);
-}
-
-static void
-ahc_linux_dv_timeout(struct scsi_cmnd *cmd)
-{
-	struct	ahc_softc *ahc;
-	struct	scb *scb;
-	u_long	flags;
-
-	ahc = *((struct ahc_softc **)cmd->device->host->hostdata);
-	ahc_lock(ahc, &flags);
-
-#ifdef AHC_DEBUG
-	if (ahc_debug & AHC_SHOW_DV) {
-		printf("%s: Timeout while doing DV command %x.\n",
-		       ahc_name(ahc), cmd->cmnd[0]);
-		ahc_dump_card_state(ahc);
-	}
-#endif
-	
-	/*
-	 * Guard against "done race".  No action is
-	 * required if we just completed.
-	 */
-	if ((scb = (struct scb *)cmd->host_scribble) == NULL) {
-		ahc_unlock(ahc, &flags);
-		return;
-	}
-
-	/*
-	 * Command has not completed.  Mark this
-	 * SCB as having failing status prior to
-	 * resetting the bus, so we get the correct
-	 * error code.
-	 */
-	if ((scb->flags & SCB_SENSE) != 0)
-		ahc_set_transaction_status(scb, CAM_AUTOSENSE_FAIL);
-	else
-		ahc_set_transaction_status(scb, CAM_CMD_TIMEOUT);
-	ahc_reset_channel(ahc, cmd->device->channel + 'A', /*initiate*/TRUE);
-
-	/*
-	 * Add a minimal bus settle delay for devices that are slow to
-	 * respond after bus resets.
-	 */
-	ahc_linux_freeze_simq(ahc);
-	init_timer(&ahc->platform_data->reset_timer);
-	ahc->platform_data->reset_timer.data = (u_long)ahc;
-	ahc->platform_data->reset_timer.expires = jiffies + HZ / 2;
-	ahc->platform_data->reset_timer.function =
-	    (ahc_linux_callback_t *)ahc_linux_release_simq;
-	add_timer(&ahc->platform_data->reset_timer);
-	if (ahc_linux_next_device_to_run(ahc) != NULL)
-		ahc_schedule_runq(ahc);
-	ahc_linux_run_complete_queue(ahc);
-	ahc_unlock(ahc, &flags);
-}
-
-static void
-ahc_linux_dv_complete(struct scsi_cmnd *cmd)
-{
-	struct ahc_softc *ahc;
-
-	ahc = *((struct ahc_softc **)cmd->device->host->hostdata);
-
-	/* Delete the DV timer before it goes off! */
-	scsi_delete_timer(cmd);
-
-#ifdef AHC_DEBUG
-	if (ahc_debug & AHC_SHOW_DV)
-		printf("%s:%d:%d: Command completed, status= 0x%x\n",
-		       ahc_name(ahc), cmd->device->channel,
-		       cmd->device->id, cmd->result);
-#endif
-
-	/* Wake up the state machine */
-	up(&ahc->platform_data->dv_cmd_sem);
-}
-
-static void
-ahc_linux_generate_dv_pattern(struct ahc_linux_target *targ)
-{
-	uint16_t b;
-	u_int	 i;
-	u_int	 j;
-
-	if (targ->dv_buffer != NULL)
-		free(targ->dv_buffer, M_DEVBUF);
-	targ->dv_buffer = malloc(targ->dv_echo_size, M_DEVBUF, M_WAITOK);
-	if (targ->dv_buffer1 != NULL)
-		free(targ->dv_buffer1, M_DEVBUF);
-	targ->dv_buffer1 = malloc(targ->dv_echo_size, M_DEVBUF, M_WAITOK);
-
-	i = 0;
-	b = 0x0001;
-	for (j = 0 ; i < targ->dv_echo_size; j++) {
-		if (j < 32) {
-			/*
-			 * 32bytes of sequential numbers.
-			 */
-			targ->dv_buffer[i++] = j & 0xff;
-		} else if (j < 48) {
-			/*
-			 * 32bytes of repeating 0x0000, 0xffff.
-			 */
-			targ->dv_buffer[i++] = (j & 0x02) ? 0xff : 0x00;
-		} else if (j < 64) {
-			/*
-			 * 32bytes of repeating 0x5555, 0xaaaa.
-			 */
-			targ->dv_buffer[i++] = (j & 0x02) ? 0xaa : 0x55;
-		} else {
-			/*
-			 * Remaining buffer is filled with a repeating
-			 * patter of:
-			 *
-			 *	 0xffff
-			 *	~0x0001 << shifted once in each loop.
-			 */
-			if (j & 0x02) {
-				if (j & 0x01) {
-					targ->dv_buffer[i++] = ~(b >> 8) & 0xff;
-					b <<= 1;
-					if (b == 0x0000)
-						b = 0x0001;
-				} else {
-					targ->dv_buffer[i++] = (~b & 0xff);
-				}
-			} else {
-				targ->dv_buffer[i++] = 0xff;
-			}
-		}
-	}
-}
-
 static u_int
 ahc_linux_user_tagdepth(struct ahc_softc *ahc, struct ahc_devinfo *devinfo)
 {
@@ -3482,48 +2016,6 @@
 	return (tags);
 }
 
-static u_int
-ahc_linux_user_dv_setting(struct ahc_softc *ahc)
-{
-	static int warned_user;
-	int dv;
-
-	if (ahc->unit >= NUM_ELEMENTS(aic7xxx_dv_settings)) {
-		if (warned_user == 0) {
-
-			printf(KERN_WARNING
-"aic7xxx: WARNING: Insufficient dv settings instances\n"
-"aic7xxx: for installed controllers. Using defaults\n"
-"aic7xxx: Please update the aic7xxx_dv_settings array\n"
-"aic7xxx: in the aic7xxx_osm.c source file.\n");
-			warned_user++;
-		}
-		dv = -1;
-	} else {
-
-		dv = aic7xxx_dv_settings[ahc->unit];
-	}
-
-	if (dv < 0) {
-		u_long s;
-
-		/*
-		 * Apply the default.
-		 */
-		/*
-		 * XXX - Enable DV on non-U160 controllers once it
-		 *       has been tested there.
-		 */
-		ahc_lock(ahc, &s);
-		dv = (ahc->features & AHC_DT);
-		if (ahc->seep_config != 0
-		 && ahc->seep_config->signature >= CFSIGNATURE2)
-			dv = (ahc->seep_config->adapter_control & CFENABLEDV);
-		ahc_unlock(ahc, &s);
-	}
-	return (dv);
-}
-
 /*
  * Determines the queue depth for a given device.
  */
@@ -3574,8 +2066,7 @@
 		 * Schedule us to run later.  The only reason we are not
 		 * running is because the whole controller Q is frozen.
 		 */
-		if (ahc->platform_data->qfrozen != 0
-	 	 && AHC_DV_SIMQ_FROZEN(ahc) == 0) {
+		if (ahc->platform_data->qfrozen != 0) {
 			TAILQ_INSERT_TAIL(&ahc->platform_data->device_runq,
 					  dev, links);
 			dev->flags |= AHC_DEV_ON_RUN_LIST;
@@ -3616,9 +2107,6 @@
 		if ((ahc->user_discenable & mask) != 0)
 			hscb->control |= DISCENB;
 
-	 	if (AHC_DV_CMD(cmd) != 0)
-			scb->flags |= SCB_SILENT;
-
 		if ((tstate->auto_negotiate & mask) != 0) {
 			scb->flags |= SCB_AUTO_NEGOTIATE;
 			scb->hscb->control |= MK_MESSAGE;
@@ -3811,7 +2299,6 @@
 	targ->channel = channel;
 	targ->target = target;
 	targ->ahc = ahc;
-	targ->flags = AHC_DV_REQUIRED;
 	ahc->platform_data->targets[target_offset] = targ;
 	return (targ);
 }
@@ -3850,10 +2337,6 @@
 	ahc->platform_data->targets[target_offset] = NULL;
 	if (targ->inq_data != NULL)
 		free(targ->inq_data, M_DEVBUF);
-	if (targ->dv_buffer != NULL)
-		free(targ->dv_buffer, M_DEVBUF);
-	if (targ->dv_buffer1 != NULL)
-		free(targ->dv_buffer1, M_DEVBUF);
 	free(targ, M_DEVBUF);
 }
 
@@ -3900,8 +2383,7 @@
 	targ->devices[dev->lun] = NULL;
 	free(dev, M_DEVBUF);
 	targ->refcount--;
-	if (targ->refcount == 0
-	 && (targ->flags & AHC_DV_REQUIRED) == 0)
+	if (targ->refcount == 0)
 		ahc_linux_free_target(ahc, targ);
 }
 
@@ -4105,16 +2587,7 @@
 		ahc_linux_handle_scsi_status(ahc, dev, scb);
 	} else if (ahc_get_transaction_status(scb) == CAM_SEL_TIMEOUT) {
 		dev->flags |= AHC_DEV_UNCONFIGURED;
-		if (AHC_DV_CMD(cmd) == FALSE)
-			dev->target->flags &= ~AHC_DV_REQUIRED;
 	}
-	/*
-	 * Start DV for devices that require it assuming the first command
-	 * sent does not result in a selection timeout.
-	 */
-	if (ahc_get_transaction_status(scb) != CAM_SEL_TIMEOUT
-	 && (dev->target->flags & AHC_DV_REQUIRED) != 0)
-		ahc_linux_start_dv(ahc);
 
 	if (dev->openings == 1
 	 && ahc_get_transaction_status(scb) == CAM_REQ_CMP
@@ -4158,13 +2631,6 @@
 
 	ahc_free_scb(ahc, scb);
 	ahc_linux_queue_cmd_complete(ahc, cmd);
-
-	if ((ahc->platform_data->flags & AHC_DV_WAIT_SIMQ_EMPTY) != 0
-	 && LIST_FIRST(&ahc->pending_scbs) == NULL) {
-		ahc->platform_data->flags &= ~AHC_DV_WAIT_SIMQ_EMPTY;
-		up(&ahc->platform_data->dv_sem);
-	}
-		
 }
 
 static void
@@ -4341,7 +2807,7 @@
 	 * full error information available when making
 	 * state change decisions.
 	 */
-	if (AHC_DV_CMD(cmd) == FALSE) {
+	{
 		u_int new_status;
 
 		switch (ahc_cmd_get_transaction_status(cmd)) {
@@ -4432,115 +2898,6 @@
 }
 
 static void
-ahc_linux_filter_inquiry(struct ahc_softc *ahc, struct ahc_devinfo *devinfo)
-{
-	struct	scsi_inquiry_data *sid;
-	struct	ahc_initiator_tinfo *tinfo;
-	struct	ahc_transinfo *user;
-	struct	ahc_transinfo *goal;
-	struct	ahc_transinfo *curr;
-	struct	ahc_tmode_tstate *tstate;
-	struct	ahc_syncrate *syncrate;
-	struct	ahc_linux_device *dev;
-	u_int	maxsync;
-	u_int	width;
-	u_int	period;
-	u_int	offset;
-	u_int	ppr_options;
-	u_int	trans_version;
-	u_int	prot_version;
-
-	/*
-	 * Determine if this lun actually exists.  If so,
-	 * hold on to its corresponding device structure.
-	 * If not, make sure we release the device and
-	 * don't bother processing the rest of this inquiry
-	 * command.
-	 */
-	dev = ahc_linux_get_device(ahc, devinfo->channel - 'A',
-				   devinfo->target, devinfo->lun,
-				   /*alloc*/TRUE);
-
-	sid = (struct scsi_inquiry_data *)dev->target->inq_data;
-	if (SID_QUAL(sid) == SID_QUAL_LU_CONNECTED) {
-
-		dev->flags &= ~AHC_DEV_UNCONFIGURED;
-	} else {
-		dev->flags |= AHC_DEV_UNCONFIGURED;
-		return;
-	}
-
-	/*
-	 * Update our notion of this device's transfer
-	 * negotiation capabilities.
-	 */
-	tinfo = ahc_fetch_transinfo(ahc, devinfo->channel,
-				    devinfo->our_scsiid,
-				    devinfo->target, &tstate);
-	user = &tinfo->user;
-	goal = &tinfo->goal;
-	curr = &tinfo->curr;
-	width = user->width;
-	period = user->period;
-	offset = user->offset;
-	ppr_options = user->ppr_options;
-	trans_version = user->transport_version;
-	prot_version = MIN(user->protocol_version, SID_ANSI_REV(sid));
-
-	/*
-	 * Only attempt SPI3/4 once we've verified that
-	 * the device claims to support SPI3/4 features.
-	 */
-	if (prot_version < SCSI_REV_2)
-		trans_version = SID_ANSI_REV(sid);
-	else
-		trans_version = SCSI_REV_2;
-
-	if ((sid->flags & SID_WBus16) == 0)
-		width = MSG_EXT_WDTR_BUS_8_BIT;
-	if ((sid->flags & SID_Sync) == 0) {
-		period = 0;
-		offset = 0;
-		ppr_options = 0;
-	}
-	if ((sid->spi3data & SID_SPI_QAS) == 0)
-		ppr_options &= ~MSG_EXT_PPR_QAS_REQ;
-	if ((sid->spi3data & SID_SPI_CLOCK_DT) == 0)
-		ppr_options &= MSG_EXT_PPR_QAS_REQ;
-	if ((sid->spi3data & SID_SPI_IUS) == 0)
-		ppr_options &= (MSG_EXT_PPR_DT_REQ
-			      | MSG_EXT_PPR_QAS_REQ);
-
-	if (prot_version > SCSI_REV_2
-	 && ppr_options != 0)
-		trans_version = user->transport_version;
-
-	ahc_validate_width(ahc, /*tinfo limit*/NULL, &width, ROLE_UNKNOWN);
-	if ((ahc->features & AHC_ULTRA2) != 0)
-		maxsync = AHC_SYNCRATE_DT;
-	else if ((ahc->features & AHC_ULTRA) != 0)
-		maxsync = AHC_SYNCRATE_ULTRA;
-	else
-		maxsync = AHC_SYNCRATE_FAST;
-
-	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options, maxsync);
-	ahc_validate_offset(ahc, /*tinfo limit*/NULL, syncrate,
-			    &offset, width, ROLE_UNKNOWN);
-	if (offset == 0 || period == 0) {
-		period = 0;
-		offset = 0;
-		ppr_options = 0;
-	}
-	/* Apply our filtered user settings. */
-	curr->transport_version = trans_version;
-	curr->protocol_version = prot_version;
-	ahc_set_width(ahc, devinfo, width, AHC_TRANS_GOAL, /*paused*/FALSE);
-	ahc_set_syncrate(ahc, devinfo, syncrate, period,
-			 offset, ppr_options, AHC_TRANS_GOAL,
-			 /*paused*/FALSE);
-}
-
-static void
 ahc_linux_sem_timeout(u_long arg)
 {
 	struct	ahc_softc *ahc;
@@ -4585,11 +2942,6 @@
 		ahc->platform_data->qfrozen--;
 	if (ahc->platform_data->qfrozen == 0)
 		unblock_reqs = 1;
-	if (AHC_DV_SIMQ_FROZEN(ahc)
-	 && ((ahc->platform_data->flags & AHC_DV_WAIT_SIMQ_RELEASE) != 0)) {
-		ahc->platform_data->flags &= ~AHC_DV_WAIT_SIMQ_RELEASE;
-		up(&ahc->platform_data->dv_sem);
-	}
 	ahc_schedule_runq(ahc);
 	ahc_unlock(ahc, &s);
 	/*
@@ -5274,19 +3626,6 @@
 static void
 ahc_linux_exit(void)
 {
-	struct ahc_softc *ahc;
-
-	/*
-	 * Shutdown DV threads before going into the SCSI mid-layer.
-	 * This avoids situations where the mid-layer locks the entire
-	 * kernel so that waiting for our DV threads to exit leads
-	 * to deadlock.
-	 */
-	TAILQ_FOREACH(ahc, &ahc_tailq, links) {
-
-		ahc_linux_kill_dv_thread(ahc);
-	}
-
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	/*
 	 * In 2.4 we have to unregister from the PCI core _after_
===== drivers/scsi/aic7xxx/aic7xxx_osm.h 1.59 vs edited =====
--- 1.59/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-01-10 00:47:25 -06:00
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-04-11 13:35:57 -05:00
@@ -424,27 +424,9 @@
 };
 
 typedef enum {
-	AHC_DV_REQUIRED		 = 0x01,
 	AHC_INQ_VALID		 = 0x02,
-	AHC_BASIC_DV		 = 0x04,
-	AHC_ENHANCED_DV		 = 0x08
 } ahc_linux_targ_flags;
 
-/* DV States */
-typedef enum {
-	AHC_DV_STATE_EXIT = 0,
-	AHC_DV_STATE_INQ_SHORT_ASYNC,
-	AHC_DV_STATE_INQ_ASYNC,
-	AHC_DV_STATE_INQ_ASYNC_VERIFY,
-	AHC_DV_STATE_TUR,
-	AHC_DV_STATE_REBD,
-	AHC_DV_STATE_INQ_VERIFY,
-	AHC_DV_STATE_WEB,
-	AHC_DV_STATE_REB,
-	AHC_DV_STATE_SU,
-	AHC_DV_STATE_BUSY
-} ahc_dv_state;
-
 struct ahc_linux_target {
 	struct ahc_linux_device	 *devices[AHC_NUM_LUNS];
 	int			  channel;
@@ -454,19 +436,6 @@
 	struct ahc_softc	 *ahc;
 	ahc_linux_targ_flags	  flags;
 	struct scsi_inquiry_data *inq_data;
-	/*
-	 * The next "fallback" period to use for narrow/wide transfers.
-	 */
-	uint8_t			  dv_next_narrow_period;
-	uint8_t			  dv_next_wide_period;
-	uint8_t			  dv_max_width;
-	uint8_t			  dv_max_ppr_options;
-	uint8_t			  dv_last_ppr_options;
-	u_int			  dv_echo_size;
-	ahc_dv_state		  dv_state;
-	u_int			  dv_state_retry;
-	char			 *dv_buffer;
-	char			 *dv_buffer1;
 };
 
 /********************* Definitions Required by the Core ***********************/
@@ -511,10 +480,6 @@
  * this driver.
  */
 typedef enum {
-	AHC_DV_WAIT_SIMQ_EMPTY	 = 0x01,
-	AHC_DV_WAIT_SIMQ_RELEASE = 0x02,
-	AHC_DV_ACTIVE		 = 0x04,
-	AHC_DV_SHUTDOWN		 = 0x08,
 	AHC_RUN_CMPLT_Q_TIMER	 = 0x10
 } ahc_linux_softc_flags;
 
@@ -937,11 +902,6 @@
 #endif
 
 /*************************** Domain Validation ********************************/
-#define AHC_DV_CMD(cmd) ((cmd)->scsi_done == ahc_linux_dv_complete)
-#define AHC_DV_SIMQ_FROZEN(ahc)					\
-	((((ahc)->platform_data->flags & AHC_DV_ACTIVE) != 0)	\
-	 && (ahc)->platform_data->qfrozen == 1)
-
 /*********************** Transaction Access Wrappers *************************/
 static __inline void ahc_cmd_set_transaction_status(Scsi_Cmnd *, uint32_t);
 static __inline void ahc_set_transaction_status(struct scb *, uint32_t);


