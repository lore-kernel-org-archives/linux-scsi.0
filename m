From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] use spi_transport_class for aic79xx
Date: Thu, 09 Jun 2005 09:08:26 +0200
Message-ID: <42A7EAEA.3060302@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030004080908050903080804"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58072 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S262314AbVFIHIe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2005 03:08:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------030004080908050903080804
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi James,

you asked for it :-)
This patch updates aic79xx to use the spi transport class.
Wasn't even too hard.
Patch is relative to 2.6.12-rc6 + scsi-misc fixes.

Comments etc. welcome.
Otherwise please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------030004080908050903080804
Content-Type: text/plain;
 name="aic7xxx_spi_update"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic7xxx_spi_update"

--- linux-2.6.11.orig/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-03-02 08:37:48.000000000 +0100
+++ linux-2.6.12-rc4/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-05-07 07:20:31.000000000 +0200
@@ -122,6 +122,10 @@
 #include "aic79xx_osm.h"
 #include "aic79xx_inline.h"
 #include <scsi/scsicam.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
+
+static struct scsi_transport_template *ahd_linux_transport_template = NULL;
 
 /*
  * Include aiclib.c as part of our
@@ -271,39 +275,6 @@ static adapter_tag_info_t aic79xx_tag_in
 };
 
 /*
- * DV option:
- *
- * positive value = DV Enabled
- * zero		  = DV Disabled
- * negative value = DV Default for adapter type/seeprom
- */
-#ifdef CONFIG_AIC79XX_DV_SETTING
-#define AIC79XX_CONFIGED_DV CONFIG_AIC79XX_DV_SETTING
-#else
-#define AIC79XX_CONFIGED_DV -1
-#endif
-
-static int8_t aic79xx_dv_settings[] =
-{
-	AIC79XX_CONFIGED_DV,
-	AIC79XX_CONFIGED_DV,
-	AIC79XX_CONFIGED_DV,
-	AIC79XX_CONFIGED_DV,
-	AIC79XX_CONFIGED_DV,
-	AIC79XX_CONFIGED_DV,
-	AIC79XX_CONFIGED_DV,
-	AIC79XX_CONFIGED_DV,
-	AIC79XX_CONFIGED_DV,
-	AIC79XX_CONFIGED_DV,
-	AIC79XX_CONFIGED_DV,
-	AIC79XX_CONFIGED_DV,
-	AIC79XX_CONFIGED_DV,
-	AIC79XX_CONFIGED_DV,
-	AIC79XX_CONFIGED_DV,
-	AIC79XX_CONFIGED_DV
-};
-
-/*
  * The I/O cell on the chip is very configurable in respect to its analog
  * characteristics.  Set the defaults here; they can be overriden with
  * the proper insmod parameters.
@@ -450,7 +421,6 @@ MODULE_PARM_DESC(aic79xx,
 "	global_tag_depth:<int>	Global tag depth for every target\n"
 "				on every bus\n"
 "	rd_strm:<rd_strm_masks> Set per-target read streaming setting.\n"
-"	dv:<dv_settings>	Set per-controller Domain Validation Setting.\n"
 "	slewrate:<slewrate_list>Set the signal slew rate (0-15).\n"
 "	precomp:<pcomp_list>	Set the signal precompensation (0-7).\n"
 "	amplitude:<int>		Set the signal amplitude (0-7).\n"
@@ -467,8 +437,6 @@ static void ahd_linux_handle_scsi_status
 					 struct scb *);
 static void ahd_linux_queue_cmd_complete(struct ahd_softc *ahd,
 					  Scsi_Cmnd *cmd);
-static void ahd_linux_filter_inquiry(struct ahd_softc*,
-				      struct ahd_devinfo*);
 static void ahd_linux_sem_timeout(u_long arg);
 static void ahd_linux_freeze_simq(struct ahd_softc *ahd);
 static void ahd_linux_release_simq(u_long arg);
@@ -476,49 +445,8 @@ static int  ahd_linux_queue_recovery_cmd
 static void ahd_linux_initialize_scsi_bus(struct ahd_softc *ahd);
 static void ahd_linux_size_nseg(void);
 static void ahd_linux_thread_run_complete_queue(struct ahd_softc *ahd);
-static void ahd_linux_start_dv(struct ahd_softc *ahd);
-static void ahd_linux_dv_timeout(struct scsi_cmnd *cmd);
-static int  ahd_linux_dv_thread(void *data);
-static void ahd_linux_kill_dv_thread(struct ahd_softc *ahd);
-static void ahd_linux_dv_target(struct ahd_softc *ahd, u_int target);
-static void ahd_linux_dv_transition(struct ahd_softc *ahd,
-				    struct scsi_cmnd *cmd,
-				    struct ahd_devinfo *devinfo,
-				    struct ahd_linux_target *targ);
-static void ahd_linux_dv_fill_cmd(struct ahd_softc *ahd,
-				  struct scsi_cmnd *cmd,
-				  struct ahd_devinfo *devinfo);
-static void ahd_linux_dv_inq(struct ahd_softc *ahd,
-			     struct scsi_cmnd *cmd,
-			     struct ahd_devinfo *devinfo,
-			     struct ahd_linux_target *targ,
-			     u_int request_length);
-static void ahd_linux_dv_tur(struct ahd_softc *ahd,
-			     struct scsi_cmnd *cmd,
-			     struct ahd_devinfo *devinfo);
-static void ahd_linux_dv_rebd(struct ahd_softc *ahd,
-			      struct scsi_cmnd *cmd,
-			      struct ahd_devinfo *devinfo,
-			      struct ahd_linux_target *targ);
-static void ahd_linux_dv_web(struct ahd_softc *ahd,
-			     struct scsi_cmnd *cmd,
-			     struct ahd_devinfo *devinfo,
-			     struct ahd_linux_target *targ);
-static void ahd_linux_dv_reb(struct ahd_softc *ahd,
-			     struct scsi_cmnd *cmd,
-			     struct ahd_devinfo *devinfo,
-			     struct ahd_linux_target *targ);
-static void ahd_linux_dv_su(struct ahd_softc *ahd,
-			    struct scsi_cmnd *cmd,
-			    struct ahd_devinfo *devinfo,
-			    struct ahd_linux_target *targ);
-static __inline int ahd_linux_fallback(struct ahd_softc *ahd,
-				       struct ahd_devinfo *devinfo);
-static void ahd_linux_dv_complete(Scsi_Cmnd *cmd);
-static void ahd_linux_generate_dv_pattern(struct ahd_linux_target *targ);
 static u_int ahd_linux_user_tagdepth(struct ahd_softc *ahd,
 				     struct ahd_devinfo *devinfo);
-static u_int ahd_linux_user_dv_setting(struct ahd_softc *ahd);
 static void ahd_linux_device_queue_depth(struct ahd_softc *ahd,
 					 struct ahd_linux_device *dev);
 static struct ahd_linux_target* ahd_linux_alloc_target(struct ahd_softc*,
@@ -534,7 +462,6 @@ static void ahd_linux_run_device_queue(s
 				       struct ahd_linux_device*);
 static void ahd_linux_setup_tag_info_global(char *p);
 static aic_option_callback_t ahd_linux_setup_tag_info;
-static aic_option_callback_t ahd_linux_setup_dv;
 static int  aic7xxx_setup(char *s);
 static int  ahd_linux_next_unit(void);
 static void ahd_runq_tasklet(unsigned long data);
@@ -663,8 +590,7 @@ ahd_linux_next_device_to_run(struct ahd_
 {
 	
 	if ((ahd->flags & AHD_RESOURCE_SHORTAGE) != 0
-	 || (ahd->platform_data->qfrozen != 0
-	  && AHD_DV_SIMQ_FROZEN(ahd) == 0))
+	    || (ahd->platform_data->qfrozen != 0))
 		return (NULL);
 	return (TAILQ_FIRST(&ahd->platform_data->device_runq));
 }
@@ -962,8 +888,7 @@ ahd_linux_queue(Scsi_Cmnd * cmd, void (*
 	 * DV commands through so long as we are only frozen to
 	 * perform DV.
 	 */
-	if (ahd->platform_data->qfrozen != 0
-	 && AHD_DV_CMD(cmd) == 0) {
+	if (ahd->platform_data->qfrozen != 0) {
 
 		ahd_cmd_set_transaction_status(cmd, CAM_REQUEUE_REQ);
 		ahd_linux_queue_cmd_complete(ahd, cmd);
@@ -1030,6 +955,11 @@ ahd_linux_slave_configure(Scsi_Device *d
 		ahd_linux_device_queue_depth(ahd, dev);
 	}
 	ahd_midlayer_entrypoint_unlock(ahd, &flags);
+
+	/* Initial Domain Validation */
+	if (!spi_initial_dv(device->sdev_target))
+		spi_dv_device(device);
+
 	return (0);
 }
 
@@ -1846,18 +1475,6 @@ ahd_linux_setup_tag_info(u_long arg, int
 	}
 }
 
-static void
-ahd_linux_setup_dv(u_long arg, int instance, int targ, int32_t value)
-{
-
-	if ((instance >= 0)
-	 && (instance < NUM_ELEMENTS(aic79xx_dv_settings))) {
-		aic79xx_dv_settings[instance] = value;
-		if (bootverbose)
-			printf("dv[%d] = %d\n", instance, value);
-	}
-}
-
 static void
 ahd_linux_setup_iocell_info(u_long index, int instance, int targ, int32_t value)
 {
@@ -1616,9 +1534,6 @@ aic79xx_setup(char *s)
 		} else if (strncmp(p, "rd_strm", n) == 0) {
 			s = aic_parse_brace_option("rd_strm", p + n, end,
 			    1, ahd_linux_setup_rd_strm_info, 0);
-		} else if (strncmp(p, "dv", n) == 0) {
-			s = aic_parse_brace_option("dv", p + n, end, 1,
-			    ahd_linux_setup_dv, 0);
 		} else if (strncmp(p, "slewrate", n) == 0) {
 			s = aic_parse_brace_option("slewrate",
 			    p + n, end, 1, ahd_linux_setup_iocell_info,
@@ -1641,7 +1556,6 @@ ahd_linux_register_host(struct ahd_softc
 	struct	 Scsi_Host *host;
 	char	*new_name;
 	u_long	 s;
-	u_long	 targ_offset;
 
 	template->name = ahd->description;
 	host = scsi_host_alloc(template, sizeof(struct ahd_softc *));
@@ -1677,45 +1591,11 @@ ahd_linux_register_host(struct ahd_softc
 #endif
 	ahd_linux_setup_user_rd_strm_settings(ahd);
 	ahd_linux_initialize_scsi_bus(ahd);
-	ahd_unlock(ahd, &s);
-	ahd->platform_data->dv_pid = kernel_thread(ahd_linux_dv_thread, ahd, 0);
-	ahd_lock(ahd, &s);
-	if (ahd->platform_data->dv_pid < 0) {
-		printf("%s: Failed to create DV thread, error= %d\n",
-		       ahd_name(ahd), ahd->platform_data->dv_pid);
-		return (-ahd->platform_data->dv_pid);
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
-	for (target = 0; target < host->max_id; target++) {
-
-		/*
-		 * Skip our own ID.  Some Compaq/HP storage devices
-		 * have enclosure management devices that respond to
-		 * single bit selection (i.e. selecting ourselves).
-		 * It is expected that either an external application
-		 * or a modified kernel will be used to probe this
-		 * ID if it is appropriate.  To accommodate these
-		 * installations, ahd_linux_alloc_target() will allocate
-		 * for our ID if asked to do so.
-		 */
-		if (target == ahd->our_id)
-			continue;
-
-		ahd_linux_alloc_target(ahd, channel, target);
-	}
 	ahd_intr_enable(ahd, TRUE);
-	ahd_linux_start_dv(ahd);
 	ahd_unlock(ahd, &s);
 
+	host->transportt = ahd_linux_transport_template;
+
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	scsi_add_host(host, &ahd->dev_softc->dev); /* XXX handle failure */
 	scsi_scan_host(host);
@@ -1860,8 +1728,6 @@ ahd_platform_alloc(struct ahd_softc *ahd
 	ahd->platform_data->completeq_timer.function =
 	    (ahd_linux_callback_t *)ahd_linux_thread_run_complete_queue;
 	init_MUTEX_LOCKED(&ahd->platform_data->eh_sem);
-	init_MUTEX_LOCKED(&ahd->platform_data->dv_sem);
-	init_MUTEX_LOCKED(&ahd->platform_data->dv_cmd_sem);
 	ahd_setup_runq_tasklet(ahd);
 	ahd->seltime = (aic79xx_seltime & 0x3) << 4;
	return (0);
@@ -1881,7 +1747,6 @@ ahd_platform_free(struct ahd_softc *ahd)
 
 	if (ahd->platform_data != NULL) {
 		del_timer_sync(&ahd->platform_data->completeq_timer);
-		ahd_linux_kill_dv_thread(ahd);
 		ahd_teardown_runq_tasklet(ahd);
 		if (ahd->platform_data->host != NULL) {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
@@ -2120,1571 +1985,200 @@ ahd_linux_thread_run_complete_queue(stru
 	ahd_unlock(ahd, &flags);
 }
 
-static void
-ahd_linux_start_dv(struct ahd_softc *ahd)
+static u_int
+ahd_linux_user_tagdepth(struct ahd_softc *ahd, struct ahd_devinfo *devinfo)
 {
+	static int warned_user;
+	u_int tags;
 
-	/*
-	 * Freeze the simq and signal ahd_linux_queue to not let any
-	 * more commands through.
-	 */
-	if ((ahd->platform_data->flags & AHD_DV_ACTIVE) == 0) {
-#ifdef AHD_DEBUG
-		if (ahd_debug & AHD_SHOW_DV)
-			printf("%s: Waking DV thread\n", ahd_name(ahd));
-#endif
+	tags = 0;
+	if ((ahd->user_discenable & devinfo->target_mask) != 0) {
+		if (ahd->unit >= NUM_ELEMENTS(aic79xx_tag_info)) {
+			if (warned_user == 0) {
 
-		ahd->platform_data->flags |= AHD_DV_ACTIVE;
-		ahd_linux_freeze_simq(ahd);
+				printf(KERN_WARNING
+"aic79xx: WARNING: Insufficient tag_info instances\n"
+"aic79xx: for installed controllers. Using defaults\n"
+"aic79xx: Please update the aic79xx_tag_info array in\n"
+"aic79xx: the aic79xx_osm..c source file.\n");
+				warned_user++;
+			}
+			tags = AHD_MAX_QUEUE;
+		} else {
+			adapter_tag_info_t *tag_info;
 
-		/* Wake up the DV kthread */
-		up(&ahd->platform_data->dv_sem);
+			tag_info = &aic79xx_tag_info[ahd->unit];
+			tags = tag_info->tag_commands[devinfo->target_offset];
+			if (tags > AHD_MAX_QUEUE)
+				tags = AHD_MAX_QUEUE;
+		}
 	}
+	return (tags);
 }
 
+/*
+ * Determines the queue depth for a given device.
+ */
 static void
-ahd_linux_kill_dv_thread(struct ahd_softc *ahd)
+ahd_linux_device_queue_depth(struct ahd_softc *ahd,
+			     struct ahd_linux_device *dev)
 {
-	u_long s;
-
-	ahd_lock(ahd, &s);
-	if (ahd->platform_data->dv_pid != 0) {
-		ahd->platform_data->flags |= AHD_DV_SHUTDOWN;
-		ahd_unlock(ahd, &s);
-		up(&ahd->platform_data->dv_sem);
+	struct	ahd_devinfo devinfo;
+	u_int	tags;
 
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
-		down(&ahd->platform_data->eh_sem);
+	ahd_compile_devinfo(&devinfo,
+			    dev->target->channel == 0
+			  ? ahd->our_id : ahd->our_id_b,
+			    dev->target->target, dev->lun,
+			    dev->target->channel == 0 ? 'A' : 'B',
+			    ROLE_INITIATOR);
+	tags = ahd_linux_user_tagdepth(ahd, &devinfo);
+	if (tags != 0
+	 && dev->scsi_device != NULL
+	 && dev->scsi_device->tagged_supported != 0) {
 
-		/*
-		 * Mark the dv thread as already dead.  This
-		 * avoids attempting to kill it a second time.
-		 * This is necessary because we must kill the
-		 * DV thread before calling ahd_free() in the
-		 * module shutdown case to avoid bogus locking
-		 * in the SCSI mid-layer, but we ahd_free() is
-		 * called without killing the DV thread in the
-		 * instance detach case, so ahd_platform_free()
-		 * calls us again to verify that the DV thread
-		 * is dead.
-		 */
-		ahd->platform_data->dv_pid = 0;
+		ahd_set_tags(ahd, &devinfo, AHD_QUEUE_TAGGED);
+		ahd_print_devinfo(ahd, &devinfo);
+		printf("Tagged Queuing enabled.  Depth %d\n", tags);
 	} else {
-		ahd_unlock(ahd, &s);
+		ahd_set_tags(ahd, &devinfo, AHD_QUEUE_NONE);
 	}
 }
 
-static int
-ahd_linux_dv_thread(void *data)
+static void
+ahd_linux_run_device_queue(struct ahd_softc *ahd, struct ahd_linux_device *dev)
 {
-	struct	ahd_softc *ahd;
-	int	target;
-	u_long	s;
-
-	ahd = (struct ahd_softc *)data;
-
-#ifdef AHD_DEBUG
-	if (ahd_debug & AHD_SHOW_DV)
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
-	sprintf(current->comm, "ahd_dv_%d", ahd->unit);
-#else
-	daemonize("ahd_dv_%d", ahd->unit);
-	current->flags |= PF_FREEZE;
-#endif
-	unlock_kernel();
-
-	while (1) {
-		/*
-		 * Use down_interruptible() rather than down() to
-		 * avoid inclusion in the load average.
-		 */
-		down_interruptible(&ahd->platform_data->dv_sem);
+	struct	 ahd_cmd *acmd;
+	struct	 scsi_cmnd *cmd;
+	struct	 scb *scb;
+	struct	 hardware_scb *hscb;
+	struct	 ahd_initiator_tinfo *tinfo;
+	struct	 ahd_tmode_tstate *tstate;
+	uint16_t mask;
 
-		/* Check to see if we've been signaled to exit */
-		ahd_lock(ahd, &s);
-		if ((ahd->platform_data->flags & AHD_DV_SHUTDOWN) != 0) {
-			ahd_unlock(ahd, &s);
-			break;
-		}
-		ahd_unlock(ahd, &s);
+	if ((dev->flags & AHD_DEV_ON_RUN_LIST) != 0)
+		panic("running device on run list");
 
-#ifdef AHD_DEBUG
-		if (ahd_debug & AHD_SHOW_DV)
-			printf("%s: Beginning Domain Validation\n",
-			       ahd_name(ahd));
-#endif
+	while ((acmd = TAILQ_FIRST(&dev->busyq)) != NULL
+	    && dev->openings > 0 && dev->qfrozen == 0) {
 
 		/*
-		 * Wait for any pending commands to drain before proceeding.
+		 * Schedule us to run later.  The only reason we are not
+		 * running is because the whole controller Q is frozen.
 		 */
-		ahd_lock(ahd, &s);
-		while (LIST_FIRST(&ahd->pending_scbs) != NULL) {
-			ahd->platform_data->flags |= AHD_DV_WAIT_SIMQ_EMPTY;
-			ahd_unlock(ahd, &s);
-			down_interruptible(&ahd->platform_data->dv_sem);
-			ahd_lock(ahd, &s);
+		if (ahd->platform_data->qfrozen != 0) {
+			TAILQ_INSERT_TAIL(&ahd->platform_data->device_runq,
+					  dev, links);
+			dev->flags |= AHD_DEV_ON_RUN_LIST;
+			return;
 		}
-
 		/*
-		 * Wait for the SIMQ to be released so that DV is the
-		 * only reason the queue is frozen.
+		 * Get an scb to use.
 		 */
-		while (AHD_DV_SIMQ_FROZEN(ahd) == 0) {
-			ahd->platform_data->flags |= AHD_DV_WAIT_SIMQ_RELEASE;
-			ahd_unlock(ahd, &s);
-			down_interruptible(&ahd->platform_data->dv_sem);
-			ahd_lock(ahd, &s);
+		if ((scb = ahd_get_scb(ahd)) == NULL) {
+			TAILQ_INSERT_TAIL(&ahd->platform_data->device_runq,
+					 dev, links);
+			dev->flags |= AHD_DEV_ON_RUN_LIST;
+			ahd->flags |= AHD_RESOURCE_SHORTAGE;
+			return;
 		}
-		ahd_unlock(ahd, &s);
-
-		for (target = 0; target < AHD_NUM_TARGETS; target++)
-			ahd_linux_dv_target(ahd, target);
-
-		ahd_lock(ahd, &s);
-		ahd->platform_data->flags &= ~AHD_DV_ACTIVE;
-		ahd_unlock(ahd, &s);
+		TAILQ_REMOVE(&dev->busyq, acmd, acmd_links.tqe);
+		cmd = &acmd_scsi_cmd(acmd);
+		scb->io_ctx = cmd;
+		scb->platform_data->dev = dev;
+		hscb = scb->hscb;
+		cmd->host_scribble = (char *)scb;
 
 		/*
-		 * Release the SIMQ so that normal commands are
-		 * allowed to continue on the bus.
+		 * Fill out basics of the HSCB.
 		 */
-		ahd_linux_release_simq((u_long)ahd);
-	}
-	up(&ahd->platform_data->eh_sem);
-	return (0);
-}
+		hscb->control = 0;
+		hscb->scsiid = BUILD_SCSIID(ahd, cmd);
+		hscb->lun = cmd->device->lun;
+		mask = SCB_GET_TARGET_MASK(ahd, scb);
+		tinfo = ahd_fetch_transinfo(ahd, SCB_GET_CHANNEL(ahd, scb),
+					    SCB_GET_OUR_ID(scb),
+					    SCB_GET_TARGET(ahd, scb), &tstate);
+		hscb->scsirate = tinfo->scsirate;
+		hscb->scsioffset = tinfo->curr.offset;
+		if ((tstate->ultraenb & mask) != 0)
+			hscb->control |= ULTRAENB;
 
-#define AHD_LINUX_DV_INQ_SHORT_LEN	36
-#define AHD_LINUX_DV_INQ_LEN		256
-#define AHD_LINUX_DV_TIMEOUT		(HZ / 4)
+		if ((ahd->user_discenable & mask) != 0)
+			hscb->control |= DISCENB;
 
-#define AHD_SET_DV_STATE(ahd, targ, newstate) \
-	ahd_set_dv_state(ahd, targ, newstate, __LINE__)
+		if ((tstate->auto_negotiate & mask) != 0) {
+			scb->flags |= SCB_AUTO_NEGOTIATE;
+			scb->hscb->control |= MK_MESSAGE;
+		}
 
-static __inline void
-ahd_set_dv_state(struct ahd_softc *ahd, struct ahd_linux_target *targ,
-		 ahd_dv_state newstate, u_int line)
-{
-	ahd_dv_state oldstate;
+		if ((dev->flags & (AHD_DEV_Q_TAGGED|AHD_DEV_Q_BASIC)) != 0) {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+			int	msg_bytes;
+			uint8_t tag_msgs[2];
 
-	oldstate = targ->dv_state;
-#ifdef AHD_DEBUG
-	if (ahd_debug & AHD_SHOW_DV)
-		printf("%s:%d: Going from state %d to state %d\n",
-		       ahd_name(ahd), line, oldstate, newstate);
+			msg_bytes = scsi_populate_tag_msg(cmd, tag_msgs);
+			if (msg_bytes && tag_msgs[0] != MSG_SIMPLE_TASK) {
+				hscb->control |= tag_msgs[0];
+				if (tag_msgs[0] == MSG_ORDERED_TASK)
+					dev->commands_since_idle_or_otag = 0;
+			} else
 #endif
+			if (dev->commands_since_idle_or_otag == AHD_OTAG_THRESH
+			 && (dev->flags & AHD_DEV_Q_TAGGED) != 0) {
+				hscb->control |= MSG_ORDERED_TASK;
+				dev->commands_since_idle_or_otag = 0;
+			} else {
+				hscb->control |= MSG_SIMPLE_TASK;
+			}
+		}
 
-	if (oldstate == newstate)
-		targ->dv_state_retry++;
-	else
-		targ->dv_state_retry = 0;
-	targ->dv_state = newstate;
-}
+		hscb->cdb_len = cmd->cmd_len;
+		if (hscb->cdb_len <= 12) {
+			memcpy(hscb->shared_data.cdb, cmd->cmnd, hscb->cdb_len);
+		} else {
+			memcpy(hscb->cdb32, cmd->cmnd, hscb->cdb_len);
+			scb->flags |= SCB_CDB32_PTR;
+		}
 
-static void
-ahd_linux_dv_target(struct ahd_softc *ahd, u_int target_offset)
-{
-	struct	 ahd_devinfo devinfo;
-	struct	 ahd_linux_target *targ;
-	struct	 scsi_cmnd *cmd;
-	struct	 scsi_device *scsi_dev;
-	struct	 scsi_sense_data *sense;
-	uint8_t *buffer;
-	u_long	 s;
-	u_int	 timeout;
-	int	 echo_size;
+		scb->platform_data->xfer_len = 0;
+		ahd_set_residual(scb, 0);
+		ahd_set_sense_residual(scb, 0);
+		scb->sg_count = 0;
+		if (cmd->use_sg != 0) {
+			struct	ahd_dma_seg *sg;
+			struct	scatterlist *cur_seg;
+			struct	scatterlist *end_seg;
+			int	nseg;
 
-	sense = NULL;
-	buffer = NULL;
-	echo_size = 0;
-	ahd_lock(ahd, &s);
-	targ = ahd->platform_data->targets[target_offset];
-	if (targ == NULL || (targ->flags & AHD_DV_REQUIRED) == 0) {
-		ahd_unlock(ahd, &s);
-		return;
-	}
-	ahd_compile_devinfo(&devinfo,
-			    targ->channel == 0 ? ahd->our_id : ahd->our_id_b,
-			    targ->target, /*lun*/0, targ->channel + 'A',
-			    ROLE_INITIATOR);
-#ifdef AHD_DEBUG
-	if (ahd_debug & AHD_SHOW_DV) {
-		ahd_print_devinfo(ahd, &devinfo);
-		printf("Performing DV\n");
-	}
-#endif
+			cur_seg = (struct scatterlist *)cmd->request_buffer;
+			nseg = pci_map_sg(ahd->dev_softc, cur_seg, cmd->use_sg,
+			    cmd->sc_data_direction);
+			end_seg = cur_seg + nseg;
+			/* Copy the segments into the SG list. */
+			sg = scb->sg_list;
+			/*
+			 * The sg_count may be larger than nseg if
+			 * a transfer crosses a 32bit page.
+			 */ 
+			while (cur_seg < end_seg) {
+				dma_addr_t addr;
+				bus_size_t len;
+				int consumed;
 
-	ahd_unlock(ahd, &s);
+				addr = sg_dma_address(cur_seg);
+				len = sg_dma_len(cur_seg);
+				consumed = ahd_linux_map_seg(ahd, scb,
+							     sg, addr, len);
+				sg += consumed;
+				scb->sg_count += consumed;
+				cur_seg++;
+			}
+			sg--;
+			sg->len |= ahd_htole32(AHD_DMA_LAST_SEG);
 
-	cmd = malloc(sizeof(struct scsi_cmnd), M_DEVBUF, M_WAITOK);
-	scsi_dev = malloc(sizeof(struct scsi_device), M_DEVBUF, M_WAITOK);
-	scsi_dev->host = ahd->platform_data->host;
-	scsi_dev->id = devinfo.target;
-	scsi_dev->lun = devinfo.lun;
-	scsi_dev->channel = devinfo.channel - 'A';
-	ahd->platform_data->dv_scsi_dev = scsi_dev;
-
-	AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_INQ_SHORT_ASYNC);
-
-	while (targ->dv_state != AHD_DV_STATE_EXIT) {
-		timeout = AHD_LINUX_DV_TIMEOUT;
-		switch (targ->dv_state) {
-		case AHD_DV_STATE_INQ_SHORT_ASYNC:
-		case AHD_DV_STATE_INQ_ASYNC:
-		case AHD_DV_STATE_INQ_ASYNC_VERIFY:
 			/*
-			 * Set things to async narrow to reduce the
-			 * chance that the INQ will fail.
-			 */
-			ahd_lock(ahd, &s);
-			ahd_set_syncrate(ahd, &devinfo, NULL, 0, 0, 0,
-					 AHD_TRANS_GOAL, /*paused*/FALSE);
-			ahd_set_width(ahd, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
-				      AHD_TRANS_GOAL, /*paused*/FALSE);
-			ahd_unlock(ahd, &s);
-			timeout = 10 * HZ;
-			targ->flags &= ~AHD_INQ_VALID;
-			/* FALLTHROUGH */
-		case AHD_DV_STATE_INQ_VERIFY:
-		{
-			u_int inq_len;
-
-			if (targ->dv_state == AHD_DV_STATE_INQ_SHORT_ASYNC)
-				inq_len = AHD_LINUX_DV_INQ_SHORT_LEN;
-			else
-				inq_len = targ->inq_data->additional_length + 5;
-			ahd_linux_dv_inq(ahd, cmd, &devinfo, targ, inq_len);
-			break;
-		}
-		case AHD_DV_STATE_TUR:
-		case AHD_DV_STATE_BUSY:
-			timeout = 5 * HZ;
-			ahd_linux_dv_tur(ahd, cmd, &devinfo);
-			break;
-		case AHD_DV_STATE_REBD:
-			ahd_linux_dv_rebd(ahd, cmd, &devinfo, targ);
-			break;
-		case AHD_DV_STATE_WEB:
-			ahd_linux_dv_web(ahd, cmd, &devinfo, targ);
-			break;
-
-		case AHD_DV_STATE_REB:
-			ahd_linux_dv_reb(ahd, cmd, &devinfo, targ);
-			break;
-
-		case AHD_DV_STATE_SU:
-			ahd_linux_dv_su(ahd, cmd, &devinfo, targ);
-			timeout = 50 * HZ;
-			break;
-
-		default:
-			ahd_print_devinfo(ahd, &devinfo);
-			printf("Unknown DV state %d\n", targ->dv_state);
-			goto out;
-		}
-
-		/* Queue the command and wait for it to complete */
-		/* Abuse eh_timeout in the scsi_cmnd struct for our purposes */
-		init_timer(&cmd->eh_timeout);
-#ifdef AHD_DEBUG
-		if ((ahd_debug & AHD_SHOW_MESSAGES) != 0)
-			/*
-			 * All of the printfs during negotiation
-			 * really slow down the negotiation.
-			 * Add a bit of time just to be safe.
-			 */
-			timeout += HZ;
-#endif
-		scsi_add_timer(cmd, timeout, ahd_linux_dv_timeout);
-		/*
-		 * In 2.5.X, it is assumed that all calls from the
-		 * "midlayer" (which we are emulating) will have the
-		 * ahd host lock held.  For other kernels, the
-		 * io_request_lock must be held.
-		 */
-#if AHD_SCSI_HAS_HOST_LOCK != 0
-		ahd_lock(ahd, &s);
-#else
-		spin_lock_irqsave(&io_request_lock, s);
-#endif
-		ahd_linux_queue(cmd, ahd_linux_dv_complete);
-#if AHD_SCSI_HAS_HOST_LOCK != 0
-		ahd_unlock(ahd, &s);
-#else
-		spin_unlock_irqrestore(&io_request_lock, s);
-#endif
-		down_interruptible(&ahd->platform_data->dv_cmd_sem);
-		/*
-		 * Wait for the SIMQ to be released so that DV is the
-		 * only reason the queue is frozen.
-		 */
-		ahd_lock(ahd, &s);
-		while (AHD_DV_SIMQ_FROZEN(ahd) == 0) {
-			ahd->platform_data->flags |= AHD_DV_WAIT_SIMQ_RELEASE;
-			ahd_unlock(ahd, &s);
-			down_interruptible(&ahd->platform_data->dv_sem);
-			ahd_lock(ahd, &s);
-		}
-		ahd_unlock(ahd, &s);
-
-		ahd_linux_dv_transition(ahd, cmd, &devinfo, targ);
-	}
-
-out:
-	if ((targ->flags & AHD_INQ_VALID) != 0
-	 && ahd_linux_get_device(ahd, devinfo.channel - 'A',
-				 devinfo.target, devinfo.lun,
-				 /*alloc*/FALSE) == NULL) {
-		/*
-		 * The DV state machine failed to configure this device.  
-		 * This is normal if DV is disabled.  Since we have inquiry
-		 * data, filter it and use the "optimistic" negotiation
-		 * parameters found in the inquiry string.
-		 */
-		ahd_linux_filter_inquiry(ahd, &devinfo);
-		if ((targ->flags & (AHD_BASIC_DV|AHD_ENHANCED_DV)) != 0) {
-			ahd_print_devinfo(ahd, &devinfo);
-			printf("DV failed to configure device.  "
-			       "Please file a bug report against "
-			       "this driver.\n");
-		}
-	}
-
-	if (cmd != NULL)
-		free(cmd, M_DEVBUF);
-
-	if (ahd->platform_data->dv_scsi_dev != NULL) {
-		free(ahd->platform_data->dv_scsi_dev, M_DEVBUF);
-		ahd->platform_data->dv_scsi_dev = NULL;
-	}
-
-	ahd_lock(ahd, &s);
-	if (targ->dv_buffer != NULL) {
-		free(targ->dv_buffer, M_DEVBUF);
-		targ->dv_buffer = NULL;
-	}
-	if (targ->dv_buffer1 != NULL) {
-		free(targ->dv_buffer1, M_DEVBUF);
-		targ->dv_buffer1 = NULL;
-	}
-	targ->flags &= ~AHD_DV_REQUIRED;
-	if (targ->refcount == 0)
-		ahd_linux_free_target(ahd, targ);
-	ahd_unlock(ahd, &s);
-}
-
-static void
-ahd_linux_dv_transition(struct ahd_softc *ahd, struct scsi_cmnd *cmd,
-			struct ahd_devinfo *devinfo,
-			struct ahd_linux_target *targ)
-{
-	u_int32_t status;
-
-	status = aic_error_action(cmd, targ->inq_data,
-				  ahd_cmd_get_transaction_status(cmd),
-				  ahd_cmd_get_scsi_status(cmd));
-	
-#ifdef AHD_DEBUG
-	if (ahd_debug & AHD_SHOW_DV) {
-		ahd_print_devinfo(ahd, devinfo);
-		printf("Entering ahd_linux_dv_transition, state= %d, "
-		       "status= 0x%x, cmd->result= 0x%x\n", targ->dv_state,
-		       status, cmd->result);
-	}
-#endif
-
-	switch (targ->dv_state) {
-	case AHD_DV_STATE_INQ_SHORT_ASYNC:
-	case AHD_DV_STATE_INQ_ASYNC:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-		{
-			AHD_SET_DV_STATE(ahd, targ, targ->dv_state+1);
-			break;
-		}
-		case SS_INQ_REFRESH:
-			AHD_SET_DV_STATE(ahd, targ,
-					 AHD_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		case SS_TUR:
-		case SS_RETRY:
-			AHD_SET_DV_STATE(ahd, targ, targ->dv_state);
-			if (ahd_cmd_get_transaction_status(cmd)
-			 == CAM_REQUEUE_REQ)
-				targ->dv_state_retry--;
-			if ((status & SS_ERRMASK) == EBUSY)
-				AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_BUSY);
-			if (targ->dv_state_retry < 10)
-				break;
-			/* FALLTHROUGH */
-		default:
-			AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_EXIT);
-#ifdef AHD_DEBUG
-			if (ahd_debug & AHD_SHOW_DV) {
-				ahd_print_devinfo(ahd, devinfo);
-				printf("Failed DV inquiry, skipping\n");
-			}
-#endif
-			break;
-		}
-		break;
-	case AHD_DV_STATE_INQ_ASYNC_VERIFY:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-		{
-			u_int xportflags;
-			u_int spi3data;
-
-			if (memcmp(targ->inq_data, targ->dv_buffer,
-				   AHD_LINUX_DV_INQ_LEN) != 0) {
-				/*
-				 * Inquiry data must have changed.
-				 * Try from the top again.
-				 */
-				AHD_SET_DV_STATE(ahd, targ,
-						 AHD_DV_STATE_INQ_SHORT_ASYNC);
-				break;
-			}
-
-			AHD_SET_DV_STATE(ahd, targ, targ->dv_state+1);
-			targ->flags |= AHD_INQ_VALID;
-			if (ahd_linux_user_dv_setting(ahd) == 0)
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
-				targ->flags |= AHD_BASIC_DV;
-				break;
-			case SID_SPI_CLOCK_DT:
-			case SID_SPI_CLOCK_DT_ST:
-				targ->flags |= AHD_ENHANCED_DV;
-				break;
-			}
-			break;
-		}
-		case SS_INQ_REFRESH:
-			AHD_SET_DV_STATE(ahd, targ,
-					 AHD_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		case SS_TUR:
-		case SS_RETRY:
-			AHD_SET_DV_STATE(ahd, targ, targ->dv_state);
-			if (ahd_cmd_get_transaction_status(cmd)
-			 == CAM_REQUEUE_REQ)
-				targ->dv_state_retry--;
-
-			if ((status & SS_ERRMASK) == EBUSY)
-				AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_BUSY);
-			if (targ->dv_state_retry < 10)
-				break;
-			/* FALLTHROUGH */
-		default:
-			AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_EXIT);
-#ifdef AHD_DEBUG
-			if (ahd_debug & AHD_SHOW_DV) {
-				ahd_print_devinfo(ahd, devinfo);
-				printf("Failed DV inquiry, skipping\n");
-			}
-#endif
-			break;
-		}
-		break;
-	case AHD_DV_STATE_INQ_VERIFY:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-		{
-
-			if (memcmp(targ->inq_data, targ->dv_buffer,
-				   AHD_LINUX_DV_INQ_LEN) == 0) {
-				AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_EXIT);
-				break;
-			}
-#ifdef AHD_DEBUG
-			if (ahd_debug & AHD_SHOW_DV) {
-				int i;
-
-				ahd_print_devinfo(ahd, devinfo);
-				printf("Inquiry buffer mismatch:");
-				for (i = 0; i < AHD_LINUX_DV_INQ_LEN; i++) {
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
-			if (ahd_linux_fallback(ahd, devinfo) != 0) {
-				AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_EXIT);
-				break;
-			}
-			/*
-			 * Do not count "falling back"
-			 * against our retries.
-			 */
-			targ->dv_state_retry = 0;
-			AHD_SET_DV_STATE(ahd, targ, targ->dv_state);
-			break;
-		}
-		case SS_INQ_REFRESH:
-			AHD_SET_DV_STATE(ahd, targ,
-					 AHD_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		case SS_TUR:
-		case SS_RETRY:
-			AHD_SET_DV_STATE(ahd, targ, targ->dv_state);
-			if (ahd_cmd_get_transaction_status(cmd)
-			 == CAM_REQUEUE_REQ) {
-				targ->dv_state_retry--;
-			} else if ((status & SSQ_FALLBACK) != 0) {
-				if (ahd_linux_fallback(ahd, devinfo) != 0) {
-					AHD_SET_DV_STATE(ahd, targ,
-							 AHD_DV_STATE_EXIT);
-					break;
-				}
-				/*
-				 * Do not count "falling back"
-				 * against our retries.
-				 */
-				targ->dv_state_retry = 0;
-			} else if ((status & SS_ERRMASK) == EBUSY)
-				AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_BUSY);
-			if (targ->dv_state_retry < 10)
-				break;
-			/* FALLTHROUGH */
-		default:
-			AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_EXIT);
-#ifdef AHD_DEBUG
-			if (ahd_debug & AHD_SHOW_DV) {
-				ahd_print_devinfo(ahd, devinfo);
-				printf("Failed DV inquiry, skipping\n");
-			}
-#endif
-			break;
-		}
-		break;
-
-	case AHD_DV_STATE_TUR:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-			if ((targ->flags & AHD_BASIC_DV) != 0) {
-				ahd_linux_filter_inquiry(ahd, devinfo);
-				AHD_SET_DV_STATE(ahd, targ,
-						 AHD_DV_STATE_INQ_VERIFY);
-			} else if ((targ->flags & AHD_ENHANCED_DV) != 0) {
-				AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_REBD);
-			} else {
-				AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_EXIT);
-			}
-			break;
-		case SS_RETRY:
-		case SS_TUR:
-			if ((status & SS_ERRMASK) == EBUSY) {
-				AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_BUSY);
-				break;
-			}
-			AHD_SET_DV_STATE(ahd, targ, targ->dv_state);
-			if (ahd_cmd_get_transaction_status(cmd)
-			 == CAM_REQUEUE_REQ) {
-				targ->dv_state_retry--;
-			} else if ((status & SSQ_FALLBACK) != 0) {
-				if (ahd_linux_fallback(ahd, devinfo) != 0) {
-					AHD_SET_DV_STATE(ahd, targ,
-							 AHD_DV_STATE_EXIT);
-					break;
-				}
-				/*
-				 * Do not count "falling back"
-				 * against our retries.
-				 */
-				targ->dv_state_retry = 0;
-			}
-			if (targ->dv_state_retry >= 10) {
-#ifdef AHD_DEBUG
-				if (ahd_debug & AHD_SHOW_DV) {
-					ahd_print_devinfo(ahd, devinfo);
-					printf("DV TUR reties exhausted\n");
-				}
-#endif
-				AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_EXIT);
-				break;
-			}
-			if (status & SSQ_DELAY)
-				ssleep(1);
-
-			break;
-		case SS_START:
-			AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_SU);
-			break;
-		case SS_INQ_REFRESH:
-			AHD_SET_DV_STATE(ahd, targ,
-					 AHD_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		default:
-			AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_EXIT);
-			break;
-		}
-		break;
-
-	case AHD_DV_STATE_REBD:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-		{
-			uint32_t echo_size;
-
-			AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_WEB);
-			echo_size = scsi_3btoul(&targ->dv_buffer[1]);
-			echo_size &= 0x1FFF;
-#ifdef AHD_DEBUG
-			if (ahd_debug & AHD_SHOW_DV) {
-				ahd_print_devinfo(ahd, devinfo);
-				printf("Echo buffer size= %d\n", echo_size);
-			}
-#endif
-			if (echo_size == 0) {
-				AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_EXIT);
-				break;
-			}
-
-			/* Generate the buffer pattern */
-			targ->dv_echo_size = echo_size;
-			ahd_linux_generate_dv_pattern(targ);
-			/*
-			 * Setup initial negotiation values.
-			 */
-			ahd_linux_filter_inquiry(ahd, devinfo);
-			break;
-		}
-		case SS_INQ_REFRESH:
-			AHD_SET_DV_STATE(ahd, targ,
-					 AHD_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		case SS_RETRY:
-			AHD_SET_DV_STATE(ahd, targ, targ->dv_state);
-			if (ahd_cmd_get_transaction_status(cmd)
-			 == CAM_REQUEUE_REQ)
-				targ->dv_state_retry--;
-			if (targ->dv_state_retry <= 10)
-				break;
-#ifdef AHD_DEBUG
-			if (ahd_debug & AHD_SHOW_DV) {
-				ahd_print_devinfo(ahd, devinfo);
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
-			ahd_linux_filter_inquiry(ahd, devinfo);
-			AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_INQ_VERIFY);
-			targ->dv_echo_size = 0;
-			break;
-		}
-		break;
-
-	case AHD_DV_STATE_WEB:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-			AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_REB);
-			break;
-		case SS_INQ_REFRESH:
-			AHD_SET_DV_STATE(ahd, targ,
-					 AHD_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		case SS_RETRY:
-			AHD_SET_DV_STATE(ahd, targ, targ->dv_state);
-			if (ahd_cmd_get_transaction_status(cmd)
-			 == CAM_REQUEUE_REQ) {
-				targ->dv_state_retry--;
-			} else if ((status & SSQ_FALLBACK) != 0) {
-				if (ahd_linux_fallback(ahd, devinfo) != 0) {
-					AHD_SET_DV_STATE(ahd, targ,
-							 AHD_DV_STATE_EXIT);
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
-#ifdef AHD_DEBUG
-			if (ahd_debug & AHD_SHOW_DV) {
-				ahd_print_devinfo(ahd, devinfo);
-				printf("DV WEB reties exhausted\n");
-			}
-#endif
-		default:
-			AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_EXIT);
-			break;
-		}
-		break;
-
-	case AHD_DV_STATE_REB:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-			if (memcmp(targ->dv_buffer, targ->dv_buffer1,
-				   targ->dv_echo_size) != 0) {
-				if (ahd_linux_fallback(ahd, devinfo) != 0)
-					AHD_SET_DV_STATE(ahd, targ,
-							 AHD_DV_STATE_EXIT);
-				else
-					AHD_SET_DV_STATE(ahd, targ,
-							 AHD_DV_STATE_WEB);
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
-			AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_EXIT);
-			break;
-		case SS_INQ_REFRESH:
-			AHD_SET_DV_STATE(ahd, targ,
-					 AHD_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		case SS_RETRY:
-			AHD_SET_DV_STATE(ahd, targ, targ->dv_state);
-			if (ahd_cmd_get_transaction_status(cmd)
-			 == CAM_REQUEUE_REQ) {
-				targ->dv_state_retry--;
-			} else if ((status & SSQ_FALLBACK) != 0) {
-				if (ahd_linux_fallback(ahd, devinfo) != 0) {
-					AHD_SET_DV_STATE(ahd, targ,
-							 AHD_DV_STATE_EXIT);
-					break;
-				}
-				AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_WEB);
-			}
-			if (targ->dv_state_retry <= 10) {
-				if ((status & (SSQ_DELAY_RANDOM|SSQ_DELAY))!= 0)
-					msleep(ahd->our_id*1000/10);
-				break;
-			}
-#ifdef AHD_DEBUG
-			if (ahd_debug & AHD_SHOW_DV) {
-				ahd_print_devinfo(ahd, devinfo);
-				printf("DV REB reties exhausted\n");
-			}
-#endif
-			/* FALLTHROUGH */
-		default:
-			AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_EXIT);
-			break;
-		}
-		break;
-
-	case AHD_DV_STATE_SU:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-		case SS_INQ_REFRESH:
-			AHD_SET_DV_STATE(ahd, targ,
-					 AHD_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		default:
-			AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_EXIT);
-			break;
-		}
-		break;
-
-	case AHD_DV_STATE_BUSY:
-		switch (status & SS_MASK) {
-		case SS_NOP:
-		case SS_INQ_REFRESH:
-			AHD_SET_DV_STATE(ahd, targ,
-					 AHD_DV_STATE_INQ_SHORT_ASYNC);
-			break;
-		case SS_TUR:
-		case SS_RETRY:
-			AHD_SET_DV_STATE(ahd, targ, targ->dv_state);
-			if (ahd_cmd_get_transaction_status(cmd)
-			 == CAM_REQUEUE_REQ) {
-				targ->dv_state_retry--;
-			} else if (targ->dv_state_retry < 60) {
-				if ((status & SSQ_DELAY) != 0)
-					ssleep(1);
-			} else {
-#ifdef AHD_DEBUG
-				if (ahd_debug & AHD_SHOW_DV) {
-					ahd_print_devinfo(ahd, devinfo);
-					printf("DV BUSY reties exhausted\n");
-				}
-#endif
-				AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_EXIT);
-			}
-			break;
-		default:
-			AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_EXIT);
-			break;
-		}
-		break;
-
-	default:
-		printf("%s: Invalid DV completion state %d\n", ahd_name(ahd),
-		       targ->dv_state);
-		AHD_SET_DV_STATE(ahd, targ, AHD_DV_STATE_EXIT);
-		break;
-	}
-}
-
-static void
-ahd_linux_dv_fill_cmd(struct ahd_softc *ahd, struct scsi_cmnd *cmd,
-		      struct ahd_devinfo *devinfo)
-{
-	memset(cmd, 0, sizeof(struct scsi_cmnd));
-	cmd->device = ahd->platform_data->dv_scsi_dev;
-	cmd->scsi_done = ahd_linux_dv_complete;
-}
-
-/*
- * Synthesize an inquiry command.  On the return trip, it'll be
- * sniffed and the device transfer settings set for us.
- */
-static void
-ahd_linux_dv_inq(struct ahd_softc *ahd, struct scsi_cmnd *cmd,
-		 struct ahd_devinfo *devinfo, struct ahd_linux_target *targ,
-		 u_int request_length)
-{
-
-#ifdef AHD_DEBUG
-	if (ahd_debug & AHD_SHOW_DV) {
-		ahd_print_devinfo(ahd, devinfo);
-		printf("Sending INQ\n");
-	}
-#endif
-	if (targ->inq_data == NULL)
-		targ->inq_data = malloc(AHD_LINUX_DV_INQ_LEN,
-					M_DEVBUF, M_WAITOK);
-	if (targ->dv_state > AHD_DV_STATE_INQ_ASYNC) {
-		if (targ->dv_buffer != NULL)
-			free(targ->dv_buffer, M_DEVBUF);
-		targ->dv_buffer = malloc(AHD_LINUX_DV_INQ_LEN,
-					 M_DEVBUF, M_WAITOK);
-	}
-
-	ahd_linux_dv_fill_cmd(ahd, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_READ;
-	cmd->cmd_len = 6;
-	cmd->cmnd[0] = INQUIRY;
-	cmd->cmnd[4] = request_length;
-	cmd->request_bufflen = request_length;
-	if (targ->dv_state > AHD_DV_STATE_INQ_ASYNC)
-		cmd->request_buffer = targ->dv_buffer;
-	else
-		cmd->request_buffer = targ->inq_data;
-	memset(cmd->request_buffer, 0, AHD_LINUX_DV_INQ_LEN);
-}
-
-static void
-ahd_linux_dv_tur(struct ahd_softc *ahd, struct scsi_cmnd *cmd,
-		 struct ahd_devinfo *devinfo)
-{
-
-#ifdef AHD_DEBUG
-	if (ahd_debug & AHD_SHOW_DV) {
-		ahd_print_devinfo(ahd, devinfo);
-		printf("Sending TUR\n");
-	}
-#endif
-	/* Do a TUR to clear out any non-fatal transitional state */
-	ahd_linux_dv_fill_cmd(ahd, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_NONE;
-	cmd->cmd_len = 6;
-	cmd->cmnd[0] = TEST_UNIT_READY;
-}
-
-#define AHD_REBD_LEN 4
-
-static void
-ahd_linux_dv_rebd(struct ahd_softc *ahd, struct scsi_cmnd *cmd,
-		 struct ahd_devinfo *devinfo, struct ahd_linux_target *targ)
-{
-
-#ifdef AHD_DEBUG
-	if (ahd_debug & AHD_SHOW_DV) {
-		ahd_print_devinfo(ahd, devinfo);
-		printf("Sending REBD\n");
-	}
-#endif
-	if (targ->dv_buffer != NULL)
-		free(targ->dv_buffer, M_DEVBUF);
-	targ->dv_buffer = malloc(AHD_REBD_LEN, M_DEVBUF, M_WAITOK);
-	ahd_linux_dv_fill_cmd(ahd, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_READ;
-	cmd->cmd_len = 10;
-	cmd->cmnd[0] = READ_BUFFER;
-	cmd->cmnd[1] = 0x0b;
-	scsi_ulto3b(AHD_REBD_LEN, &cmd->cmnd[6]);
-	cmd->request_bufflen = AHD_REBD_LEN;
-	cmd->underflow = cmd->request_bufflen;
-	cmd->request_buffer = targ->dv_buffer;
-}
-
-static void
-ahd_linux_dv_web(struct ahd_softc *ahd, struct scsi_cmnd *cmd,
-		 struct ahd_devinfo *devinfo, struct ahd_linux_target *targ)
-{
-
-#ifdef AHD_DEBUG
-	if (ahd_debug & AHD_SHOW_DV) {
-		ahd_print_devinfo(ahd, devinfo);
-		printf("Sending WEB\n");
-	}
-#endif
-	ahd_linux_dv_fill_cmd(ahd, cmd, devinfo);
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
-ahd_linux_dv_reb(struct ahd_softc *ahd, struct scsi_cmnd *cmd,
-		 struct ahd_devinfo *devinfo, struct ahd_linux_target *targ)
-{
-
-#ifdef AHD_DEBUG
-	if (ahd_debug & AHD_SHOW_DV) {
-		ahd_print_devinfo(ahd, devinfo);
-		printf("Sending REB\n");
-	}
-#endif
-	ahd_linux_dv_fill_cmd(ahd, cmd, devinfo);
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
-ahd_linux_dv_su(struct ahd_softc *ahd, struct scsi_cmnd *cmd,
-		struct ahd_devinfo *devinfo,
-		struct ahd_linux_target *targ)
-{
-	u_int le;
-
-	le = SID_IS_REMOVABLE(targ->inq_data) ? SSS_LOEJ : 0;
-
-#ifdef AHD_DEBUG
-	if (ahd_debug & AHD_SHOW_DV) {
-		ahd_print_devinfo(ahd, devinfo);
-		printf("Sending SU\n");
-	}
-#endif
-	ahd_linux_dv_fill_cmd(ahd, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_NONE;
-	cmd->cmd_len = 6;
-	cmd->cmnd[0] = START_STOP_UNIT;
-	cmd->cmnd[4] = le | SSS_START;
-}
-
-static int
-ahd_linux_fallback(struct ahd_softc *ahd, struct ahd_devinfo *devinfo)
-{
-	struct	ahd_linux_target *targ;
-	struct	ahd_initiator_tinfo *tinfo;
-	struct	ahd_transinfo *goal;
-	struct	ahd_tmode_tstate *tstate;
-	struct	ahd_syncrate *syncrate;
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
-#ifdef AHD_DEBUG
-	if (ahd_debug & AHD_SHOW_DV) {
-		ahd_print_devinfo(ahd, devinfo);
-		printf("Trying to fallback\n");
-	}
-#endif
-	ahd_lock(ahd, &s);
-	targ = ahd->platform_data->targets[devinfo->target_offset];
-	tinfo = ahd_fetch_transinfo(ahd, devinfo->channel,
-				    devinfo->our_scsiid,
-				    devinfo->target, &tstate);
-	goal = &tinfo->goal;
-	width = goal->width;
-	period = goal->period;
-	offset = goal->offset;
-	ppr_options = goal->ppr_options;
-	if (offset == 0)
-		period = AHD_ASYNC_XFER_PERIOD;
-	if (targ->dv_next_narrow_period == 0)
-		targ->dv_next_narrow_period = MAX(period, AHD_SYNCRATE_ULTRA2);
-	if (targ->dv_next_wide_period == 0)
-		targ->dv_next_wide_period = period;
-	if (targ->dv_max_width == 0)
-		targ->dv_max_width = width;
-	if (targ->dv_max_ppr_options == 0)
-		targ->dv_max_ppr_options = ppr_options;
-	if (targ->dv_last_ppr_options == 0)
-		targ->dv_last_ppr_options = ppr_options;
-
-	cur_speed = aic_calc_speed(width, period, offset, AHD_SYNCRATE_MIN);
-	wide_speed = aic_calc_speed(MSG_EXT_WDTR_BUS_16_BIT,
-					  targ->dv_next_wide_period,
-					  MAX_OFFSET,
-					  AHD_SYNCRATE_MIN);
-	narrow_speed = aic_calc_speed(MSG_EXT_WDTR_BUS_8_BIT,
-					    targ->dv_next_narrow_period,
-					    MAX_OFFSET,
-					    AHD_SYNCRATE_MIN);
-	fallback_speed = aic_calc_speed(width, period+1, offset,
-					AHD_SYNCRATE_MIN);
-#ifdef AHD_DEBUG
-	if (ahd_debug & AHD_SHOW_DV) {
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
-			 || period >= AHD_ASYNC_XFER_PERIOD) {
-				targ->dv_next_wide_period = period+1;
-				width = MSG_EXT_WDTR_BUS_8_BIT;
-				period = targ->dv_next_narrow_period;
-			} else {
-				period++;
-			}
-		} else if ((ahd->features & AHD_WIDE) != 0
-			&& targ->dv_max_width != 0
-			&& wide_speed >= fallback_speed
-			&& (targ->dv_next_wide_period <= AHD_ASYNC_XFER_PERIOD
-			 || period >= AHD_ASYNC_XFER_PERIOD)) {
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
-		ahd_unlock(ahd, &s);
-		return (-1);
-	}
-	offset = MAX_OFFSET;
-	syncrate = ahd_find_syncrate(ahd, &period, &ppr_options,
-				     AHD_SYNCRATE_DT);
-	ahd_set_width(ahd, devinfo, width, AHD_TRANS_GOAL, FALSE);
-	if (period == 0) {
-		period = 0;
-		offset = 0;
-		ppr_options = 0;
-		if (width == MSG_EXT_WDTR_BUS_8_BIT)
-			targ->dv_next_narrow_period = AHD_ASYNC_XFER_PERIOD;
-		else
-			targ->dv_next_wide_period = AHD_ASYNC_XFER_PERIOD;
-	}
-	ahd_set_syncrate(ahd, devinfo, syncrate, period, offset,
-			 ppr_options, AHD_TRANS_GOAL, FALSE);
-	targ->dv_last_ppr_options = ppr_options;
-	ahd_unlock(ahd, &s);
-	return (0);
-}
-
-static void
-ahd_linux_dv_timeout(struct scsi_cmnd *cmd)
-{
-	struct	ahd_softc *ahd;
-	struct	scb *scb;
-	u_long	flags;
-
-	ahd = *((struct ahd_softc **)cmd->device->host->hostdata);
-	ahd_lock(ahd, &flags);
-
-#ifdef AHD_DEBUG
-	if (ahd_debug & AHD_SHOW_DV) {
-		printf("%s: Timeout while doing DV command %x.\n",
-		       ahd_name(ahd), cmd->cmnd[0]);
-		ahd_dump_card_state(ahd);
-	}
-#endif
-	
-	/*
-	 * Guard against "done race".  No action is
-	 * required if we just completed.
-	 */
-	if ((scb = (struct scb *)cmd->host_scribble) == NULL) {
-		ahd_unlock(ahd, &flags);
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
-		ahd_set_transaction_status(scb, CAM_AUTOSENSE_FAIL);
-	else
-		ahd_set_transaction_status(scb, CAM_CMD_TIMEOUT);
-	ahd_reset_channel(ahd, cmd->device->channel + 'A', /*initiate*/TRUE);
-
-	/*
-	 * Add a minimal bus settle delay for devices that are slow to
-	 * respond after bus resets.
-	 */
-	ahd_linux_freeze_simq(ahd);
-	init_timer(&ahd->platform_data->reset_timer);
-	ahd->platform_data->reset_timer.data = (u_long)ahd;
-	ahd->platform_data->reset_timer.expires = jiffies + HZ / 2;
-	ahd->platform_data->reset_timer.function =
-	    (ahd_linux_callback_t *)ahd_linux_release_simq;
-	add_timer(&ahd->platform_data->reset_timer);
-	if (ahd_linux_next_device_to_run(ahd) != NULL)
-		ahd_schedule_runq(ahd);
-	ahd_linux_run_complete_queue(ahd);
-	ahd_unlock(ahd, &flags);
-}
-
-static void
-ahd_linux_dv_complete(struct scsi_cmnd *cmd)
-{
-	struct ahd_softc *ahd;
-
-	ahd = *((struct ahd_softc **)cmd->device->host->hostdata);
-
-	/* Delete the DV timer before it goes off! */
-	scsi_delete_timer(cmd);
-
-#ifdef AHD_DEBUG
-	if (ahd_debug & AHD_SHOW_DV)
-		printf("%s:%d:%d: Command completed, status= 0x%x\n",
-		       ahd_name(ahd), cmd->device->channel,
-		       cmd->device->id, cmd->result);
-#endif
-
-	/* Wake up the state machine */
-	up(&ahd->platform_data->dv_cmd_sem);
-}
-
-static void
-ahd_linux_generate_dv_pattern(struct ahd_linux_target *targ)
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
-static u_int
-ahd_linux_user_tagdepth(struct ahd_softc *ahd, struct ahd_devinfo *devinfo)
-{
-	static int warned_user;
-	u_int tags;
-
-	tags = 0;
-	if ((ahd->user_discenable & devinfo->target_mask) != 0) {
-		if (ahd->unit >= NUM_ELEMENTS(aic79xx_tag_info)) {
-			if (warned_user == 0) {
-
-				printf(KERN_WARNING
-"aic79xx: WARNING: Insufficient tag_info instances\n"
-"aic79xx: for installed controllers. Using defaults\n"
-"aic79xx: Please update the aic79xx_tag_info array in\n"
-"aic79xx: the aic79xx_osm..c source file.\n");
-				warned_user++;
-			}
-			tags = AHD_MAX_QUEUE;
-		} else {
-			adapter_tag_info_t *tag_info;
-
-			tag_info = &aic79xx_tag_info[ahd->unit];
-			tags = tag_info->tag_commands[devinfo->target_offset];
-			if (tags > AHD_MAX_QUEUE)
-				tags = AHD_MAX_QUEUE;
-		}
-	}
-	return (tags);
-}
-
-static u_int
-ahd_linux_user_dv_setting(struct ahd_softc *ahd)
-{
-	static int warned_user;
-	int dv;
-
-	if (ahd->unit >= NUM_ELEMENTS(aic79xx_dv_settings)) {
-		if (warned_user == 0) {
-
-			printf(KERN_WARNING
-"aic79xx: WARNING: Insufficient dv settings instances\n"
-"aic79xx: for installed controllers. Using defaults\n"
-"aic79xx: Please update the aic79xx_dv_settings array\n"
-"aic79xx: in the aic79xx_osm.c source file.\n");
-			warned_user++;
-		}
-		dv = -1;
-	} else {
-
-		dv = aic79xx_dv_settings[ahd->unit];
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
-		ahd_lock(ahd, &s);
-		dv = (ahd->features & AHD_DT);
-		if (ahd->seep_config != 0
-		 && ahd->seep_config->signature >= CFSIGNATURE2)
-			dv = (ahd->seep_config->adapter_control & CFENABLEDV);
-		ahd_unlock(ahd, &s);
-	}
-	return (dv);
-}
-
-/*
- * Determines the queue depth for a given device.
- */
-static void
-ahd_linux_device_queue_depth(struct ahd_softc *ahd,
-			     struct ahd_linux_device *dev)
-{
-	struct	ahd_devinfo devinfo;
-	u_int	tags;
-
-	ahd_compile_devinfo(&devinfo,
-			    dev->target->channel == 0
-			  ? ahd->our_id : ahd->our_id_b,
-			    dev->target->target, dev->lun,
-			    dev->target->channel == 0 ? 'A' : 'B',
-			    ROLE_INITIATOR);
-	tags = ahd_linux_user_tagdepth(ahd, &devinfo);
-	if (tags != 0
-	 && dev->scsi_device != NULL
-	 && dev->scsi_device->tagged_supported != 0) {
-
-		ahd_set_tags(ahd, &devinfo, AHD_QUEUE_TAGGED);
-		ahd_print_devinfo(ahd, &devinfo);
-		printf("Tagged Queuing enabled.  Depth %d\n", tags);
-	} else {
-		ahd_set_tags(ahd, &devinfo, AHD_QUEUE_NONE);
-	}
-}
-
-static void
-ahd_linux_run_device_queue(struct ahd_softc *ahd, struct ahd_linux_device *dev)
-{
-	struct	 ahd_cmd *acmd;
-	struct	 scsi_cmnd *cmd;
-	struct	 scb *scb;
-	struct	 hardware_scb *hscb;
-	struct	 ahd_initiator_tinfo *tinfo;
-	struct	 ahd_tmode_tstate *tstate;
-	uint16_t mask;
-
-	if ((dev->flags & AHD_DEV_ON_RUN_LIST) != 0)
-		panic("running device on run list");
-
-	while ((acmd = TAILQ_FIRST(&dev->busyq)) != NULL
-	    && dev->openings > 0 && dev->qfrozen == 0) {
-
-		/*
-		 * Schedule us to run later.  The only reason we are not
-		 * running is because the whole controller Q is frozen.
-		 */
-		if (ahd->platform_data->qfrozen != 0
-	 	 && AHD_DV_SIMQ_FROZEN(ahd) == 0) {
-			TAILQ_INSERT_TAIL(&ahd->platform_data->device_runq,
-					  dev, links);
-			dev->flags |= AHD_DEV_ON_RUN_LIST;
-			return;
-		}
-		/*
-		 * Get an scb to use.
-		 */
-		if ((scb = ahd_get_scb(ahd)) == NULL) {
-			TAILQ_INSERT_TAIL(&ahd->platform_data->device_runq,
-					 dev, links);
-			dev->flags |= AHD_DEV_ON_RUN_LIST;
-			ahd->flags |= AHD_RESOURCE_SHORTAGE;
-			return;
-		}
-		TAILQ_REMOVE(&dev->busyq, acmd, acmd_links.tqe);
-		cmd = &acmd_scsi_cmd(acmd);
-		scb->io_ctx = cmd;
-		scb->platform_data->dev = dev;
-		hscb = scb->hscb;
-		cmd->host_scribble = (char *)scb;
-
-		/*
-		 * Fill out basics of the HSCB.
-		 */
-		hscb->control = 0;
-		hscb->scsiid = BUILD_SCSIID(ahd, cmd);
-		hscb->lun = cmd->device->lun;
-		mask = SCB_GET_TARGET_MASK(ahd, scb);
-		tinfo = ahd_fetch_transinfo(ahd, SCB_GET_CHANNEL(ahd, scb),
-					    SCB_GET_OUR_ID(scb),
-					    SCB_GET_TARGET(ahd, scb), &tstate);
-		hscb->scsirate = tinfo->scsirate;
-		hscb->scsioffset = tinfo->curr.offset;
-		if ((tstate->ultraenb & mask) != 0)
-			hscb->control |= ULTRAENB;
-
-		if ((ahd->user_discenable & mask) != 0)
-			hscb->control |= DISCENB;
-
-	 	if (AHD_DV_CMD(cmd) != 0)
-			scb->flags |= SCB_SILENT;
-
-		if ((tstate->auto_negotiate & mask) != 0) {
-			scb->flags |= SCB_AUTO_NEGOTIATE;
-			scb->hscb->control |= MK_MESSAGE;
-		}
-
-		if ((dev->flags & (AHD_DEV_Q_TAGGED|AHD_DEV_Q_BASIC)) != 0) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-			int	msg_bytes;
-			uint8_t tag_msgs[2];
-
-			msg_bytes = scsi_populate_tag_msg(cmd, tag_msgs);
-			if (msg_bytes && tag_msgs[0] != MSG_SIMPLE_TASK) {
-				hscb->control |= tag_msgs[0];
-				if (tag_msgs[0] == MSG_ORDERED_TASK)
-					dev->commands_since_idle_or_otag = 0;
-			} else
-#endif
-			if (dev->commands_since_idle_or_otag == AHD_OTAG_THRESH
-			 && (dev->flags & AHD_DEV_Q_TAGGED) != 0) {
-				hscb->control |= MSG_ORDERED_TASK;
-				dev->commands_since_idle_or_otag = 0;
-			} else {
-				hscb->control |= MSG_SIMPLE_TASK;
-			}
-		}
-
-		hscb->cdb_len = cmd->cmd_len;
-		if (hscb->cdb_len <= 12) {
-			memcpy(hscb->shared_data.cdb, cmd->cmnd, hscb->cdb_len);
-		} else {
-			memcpy(hscb->cdb32, cmd->cmnd, hscb->cdb_len);
-			scb->flags |= SCB_CDB32_PTR;
-		}
-
-		scb->platform_data->xfer_len = 0;
-		ahd_set_residual(scb, 0);
-		ahd_set_sense_residual(scb, 0);
-		scb->sg_count = 0;
-		if (cmd->use_sg != 0) {
-			struct	ahd_dma_seg *sg;
-			struct	scatterlist *cur_seg;
-			struct	scatterlist *end_seg;
-			int	nseg;
-
-			cur_seg = (struct scatterlist *)cmd->request_buffer;
-			nseg = pci_map_sg(ahd->dev_softc, cur_seg, cmd->use_sg,
-			    scsi_to_pci_dma_dir(cmd->sc_data_direction));
-			end_seg = cur_seg + nseg;
-			/* Copy the segments into the SG list. */
-			sg = scb->sg_list;
-			/*
-			 * The sg_count may be larger than nseg if
-			 * a transfer crosses a 32bit page.
-			 */ 
-			while (cur_seg < end_seg) {
-				dma_addr_t addr;
-				bus_size_t len;
-				int consumed;
-
-				addr = sg_dma_address(cur_seg);
-				len = sg_dma_len(cur_seg);
-				consumed = ahd_linux_map_seg(ahd, scb,
-							     sg, addr, len);
-				sg += consumed;
-				scb->sg_count += consumed;
-				cur_seg++;
-			}
-			sg--;
-			sg->len |= ahd_htole32(AHD_DMA_LAST_SEG);
-
-			/*
-			 * Reset the sg list pointer.
+			 * Reset the sg list pointer.
 			 */
 			scb->hscb->sgptr =
 			    ahd_htole32(scb->sg_list_phys | SG_FULL_RESID);
@@ -3805,7 +2299,6 @@ ahd_linux_alloc_target(struct ahd_softc 
 	targ->channel = channel;
 	targ->target = target;
 	targ->ahd = ahd;
-	targ->flags = AHD_DV_REQUIRED;
 	ahd->platform_data->targets[target_offset] = targ;
 	return (targ);
 }
@@ -3842,12 +2335,6 @@ ahd_linux_free_target(struct ahd_softc *
 		      AHD_TRANS_GOAL, /*paused*/FALSE);
 	ahd_update_neg_request(ahd, &devinfo, tstate, tinfo, AHD_NEG_ALWAYS);
 	ahd->platform_data->targets[target_offset] = NULL;
-	if (targ->inq_data != NULL)
-		free(targ->inq_data, M_DEVBUF);
-	if (targ->dv_buffer != NULL)
-		free(targ->dv_buffer, M_DEVBUF);
-	if (targ->dv_buffer1 != NULL)
-		free(targ->dv_buffer1, M_DEVBUF);
 	free(targ, M_DEVBUF);
 }
 
@@ -3894,8 +2381,7 @@ __ahd_linux_free_device(struct ahd_softc
 	targ->devices[dev->lun] = NULL;
 	free(dev, M_DEVBUF);
 	targ->refcount--;
-	if (targ->refcount == 0
-	 && (targ->flags & AHD_DV_REQUIRED) == 0)
+	if (targ->refcount == 0)
 		ahd_linux_free_target(ahd, targ);
 }
 
@@ -4099,16 +2585,7 @@ ahd_done(struct ahd_softc *ahd, struct s
 		ahd_linux_handle_scsi_status(ahd, dev, scb);
 	} else if (ahd_get_transaction_status(scb) == CAM_SEL_TIMEOUT) {
 		dev->flags |= AHD_DEV_UNCONFIGURED;
-		if (AHD_DV_CMD(cmd) == FALSE)
-			dev->target->flags &= ~AHD_DV_REQUIRED;
 	}
-	/*
-	 * Start DV for devices that require it assuming the first command
-	 * sent does not result in a selection timeout.
-	 */
-	if (ahd_get_transaction_status(scb) != CAM_SEL_TIMEOUT
-	 && (dev->target->flags & AHD_DV_REQUIRED) != 0)
-		ahd_linux_start_dv(ahd);
 
 	if (dev->openings == 1
 	 && ahd_get_transaction_status(scb) == CAM_REQ_CMP
@@ -4152,13 +2629,6 @@ ahd_done(struct ahd_softc *ahd, struct s
 
 	ahd_free_scb(ahd, scb);
 	ahd_linux_queue_cmd_complete(ahd, cmd);
-
-	if ((ahd->platform_data->flags & AHD_DV_WAIT_SIMQ_EMPTY) != 0
-	 && LIST_FIRST(&ahd->pending_scbs) == NULL) {
-		ahd->platform_data->flags &= ~AHD_DV_WAIT_SIMQ_EMPTY;
-		up(&ahd->platform_data->dv_sem);
-	}
-		
 }
 
 static void
@@ -4335,7 +2805,7 @@ ahd_linux_queue_cmd_complete(struct ahd_
 	 * full error information available when making
 	 * state change decisions.
 	 */
-	if (AHD_DV_CMD(cmd) == FALSE) {
+	{
 		uint32_t status;
 		u_int new_status;
 
@@ -4426,106 +2896,6 @@ ahd_linux_queue_cmd_complete(struct ahd_
 }
 
 static void
-ahd_linux_filter_inquiry(struct ahd_softc *ahd, struct ahd_devinfo *devinfo)
-{
-	struct	scsi_inquiry_data *sid;
-	struct	ahd_initiator_tinfo *tinfo;
-	struct	ahd_transinfo *user;
-	struct	ahd_transinfo *goal;
-	struct	ahd_transinfo *curr;
-	struct	ahd_tmode_tstate *tstate;
-	struct	ahd_syncrate *syncrate;
-	struct	ahd_linux_device *dev;
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
-	dev = ahd_linux_get_device(ahd, devinfo->channel - 'A',
-				   devinfo->target, devinfo->lun,
-				   /*alloc*/TRUE);
-
-	sid = (struct scsi_inquiry_data *)dev->target->inq_data;
-	if (SID_QUAL(sid) == SID_QUAL_LU_CONNECTED) {
-
-		dev->flags &= ~AHD_DEV_UNCONFIGURED;
-	} else {
-		dev->flags |= AHD_DEV_UNCONFIGURED;
-		return;
-	}
-
-	/*
-	 * Update our notion of this device's transfer
-	 * negotiation capabilities.
-	 */
-	tinfo = ahd_fetch_transinfo(ahd, devinfo->channel,
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
-	ahd_validate_width(ahd, /*tinfo limit*/NULL, &width, ROLE_UNKNOWN);
-	syncrate = ahd_find_syncrate(ahd, &period, &ppr_options, maxsync);
-	ahd_validate_offset(ahd, /*tinfo limit*/NULL, syncrate,
-			    &offset, width, ROLE_UNKNOWN);
-	if (offset == 0 || period == 0) {
-		period = 0;
-		offset = 0;
-		ppr_options = 0;
-	}
-	/* Apply our filtered user settings. */
-	curr->transport_version = trans_version;
-	curr->protocol_version = prot_version;
-	ahd_set_width(ahd, devinfo, width, AHD_TRANS_GOAL, /*paused*/FALSE);
-	ahd_set_syncrate(ahd, devinfo, syncrate, period, offset, ppr_options,
-			 AHD_TRANS_GOAL, /*paused*/FALSE);
-}
-
-static void
 ahd_freeze_simq(struct ahd_softc *ahd)
 {
 	ahd->platform_data->qfrozen++;
@@ -4579,11 +2940,6 @@ ahd_linux_release_simq(u_long arg)
 		ahd->platform_data->qfrozen--;
 	if (ahd->platform_data->qfrozen == 0)
 		unblock_reqs = 1;
-	if (AHD_DV_SIMQ_FROZEN(ahd)
-	 && ((ahd->platform_data->flags & AHD_DV_WAIT_SIMQ_RELEASE) != 0)) {
-		ahd->platform_data->flags &= ~AHD_DV_WAIT_SIMQ_RELEASE;
-		up(&ahd->platform_data->dv_sem);
-	}
 	ahd_schedule_runq(ahd);
 	ahd_unlock(ahd, &s);
 	/*
@@ -4990,11 +3346,266 @@ ahd_platform_dump_card_state(struct ahd_
 	}
 }
 
+static void ahd_linux_get_period(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahd_softc *ahd = *((struct ahd_softc **)shost->hostdata);
+	struct ahd_tmode_tstate *tstate;
+	struct ahd_initiator_tinfo *tinfo 
+		= ahd_fetch_transinfo(ahd,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	spi_period(starget) = tinfo->curr.period;
+}
+
+static void ahd_linux_set_period(struct scsi_target *starget, int period)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahd_softc *ahd = *((struct ahd_softc **)shost->hostdata);
+	struct ahd_tmode_tstate *tstate;
+	struct ahd_initiator_tinfo *tinfo 
+		= ahd_fetch_transinfo(ahd,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	struct ahd_devinfo devinfo;
+	unsigned int ppr_options = tinfo->curr.ppr_options;
+	unsigned long flags;
+	unsigned long offset = tinfo->curr.offset;
+	struct ahd_syncrate *syncrate;
+
+	if (offset == 0)
+		offset = MAX_OFFSET;
+
+	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
+			    starget->channel + 'A', ROLE_INITIATOR);
+	syncrate = ahd_find_syncrate(ahd, &period, &ppr_options, AHD_SYNCRATE_DT);
+	ahd_lock(ahd, &flags);
+	ahd_set_syncrate(ahd, &devinfo, syncrate, period, offset,
+			 ppr_options, AHD_TRANS_GOAL, FALSE);
+	ahd_unlock(ahd, &flags);
+}
+
+static void ahd_linux_get_offset(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahd_softc *ahd = *((struct ahd_softc **)shost->hostdata);
+	struct ahd_tmode_tstate *tstate;
+	struct ahd_initiator_tinfo *tinfo 
+		= ahd_fetch_transinfo(ahd,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	spi_offset(starget) = tinfo->curr.offset;
+}
+
+static void ahd_linux_set_offset(struct scsi_target *starget, int offset)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahd_softc *ahd = *((struct ahd_softc **)shost->hostdata);
+	struct ahd_tmode_tstate *tstate;
+	struct ahd_initiator_tinfo *tinfo 
+		= ahd_fetch_transinfo(ahd,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	struct ahd_devinfo devinfo;
+	unsigned int ppr_options = 0;
+	unsigned int period = 0;
+	unsigned long flags;
+	struct ahd_syncrate *syncrate = NULL;
+
+	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
+			    starget->channel + 'A', ROLE_INITIATOR);
+	if (offset != 0) {
+		syncrate = ahd_find_syncrate(ahd, &period, &ppr_options, AHD_SYNCRATE_DT);
+		period = tinfo->curr.period;
+		ppr_options = tinfo->curr.ppr_options;
+	}
+	ahd_lock(ahd, &flags);
+	ahd_set_syncrate(ahd, &devinfo, syncrate, period, offset,
+			 ppr_options, AHD_TRANS_GOAL, FALSE);
+	ahd_unlock(ahd, &flags);
+}
+
+static void ahd_linux_get_width(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahd_softc *ahd = *((struct ahd_softc **)shost->hostdata);
+	struct ahd_tmode_tstate *tstate;
+	struct ahd_initiator_tinfo *tinfo 
+		= ahd_fetch_transinfo(ahd,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	spi_width(starget) = tinfo->curr.width;
+}
+
+static void ahd_linux_set_width(struct scsi_target *starget, int width)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahd_softc *ahd = *((struct ahd_softc **)shost->hostdata);
+	struct ahd_devinfo devinfo;
+	unsigned long flags;
+
+	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
+			    starget->channel + 'A', ROLE_INITIATOR);
+	ahd_lock(ahd, &flags);
+	ahd_set_width(ahd, &devinfo, width, AHD_TRANS_GOAL, FALSE);
+	ahd_unlock(ahd, &flags);
+}
+
+static void ahd_linux_get_dt(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahd_softc *ahd = *((struct ahd_softc **)shost->hostdata);
+	struct ahd_tmode_tstate *tstate;
+	struct ahd_initiator_tinfo *tinfo 
+		= ahd_fetch_transinfo(ahd,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	spi_dt(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_DT_REQ;
+}
+
+static void ahd_linux_set_dt(struct scsi_target *starget, int dt)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahd_softc *ahd = *((struct ahd_softc **)shost->hostdata);
+	struct ahd_tmode_tstate *tstate;
+	struct ahd_initiator_tinfo *tinfo 
+		= ahd_fetch_transinfo(ahd,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	struct ahd_devinfo devinfo;
+	unsigned int ppr_options = tinfo->curr.ppr_options
+		& ~MSG_EXT_PPR_DT_REQ;
+	unsigned int period = tinfo->curr.period;
+	unsigned long flags;
+	struct ahd_syncrate *syncrate;
+
+	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
+			    starget->channel + 'A', ROLE_INITIATOR);
+	syncrate = ahd_find_syncrate(ahd, &period, &ppr_options,
+				     dt ? AHD_SYNCRATE_DT : AHD_SYNCRATE_ULTRA2);
+	ahd_lock(ahd, &flags);
+	ahd_set_syncrate(ahd, &devinfo, syncrate, period, tinfo->curr.offset,
+			 ppr_options, AHD_TRANS_GOAL, FALSE);
+	ahd_unlock(ahd, &flags);
+}
+
+static void ahd_linux_get_qas(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahd_softc *ahd = *((struct ahd_softc **)shost->hostdata);
+	struct ahd_tmode_tstate *tstate;
+	struct ahd_initiator_tinfo *tinfo 
+		= ahd_fetch_transinfo(ahd,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	spi_dt(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_QAS_REQ;
+}
+
+static void ahd_linux_set_qas(struct scsi_target *starget, int qas)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahd_softc *ahd = *((struct ahd_softc **)shost->hostdata);
+	struct ahd_tmode_tstate *tstate;
+	struct ahd_initiator_tinfo *tinfo 
+		= ahd_fetch_transinfo(ahd,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	struct ahd_devinfo devinfo;
+	unsigned int ppr_options = tinfo->curr.ppr_options
+		& ~MSG_EXT_PPR_QAS_REQ;
+	unsigned int period = tinfo->curr.period;
+	unsigned int dt = ppr_options & MSG_EXT_PPR_DT_REQ;
+	unsigned long flags;
+	struct ahd_syncrate *syncrate;
+
+	if (qas)
+		ppr_options |= MSG_EXT_PPR_QAS_REQ;
+
+	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
+			    starget->channel + 'A', ROLE_INITIATOR);
+	syncrate = ahd_find_syncrate(ahd, &period, &ppr_options,
+				     dt ? AHD_SYNCRATE_DT : AHD_SYNCRATE_ULTRA2);
+	ahd_lock(ahd, &flags);
+	ahd_set_syncrate(ahd, &devinfo, syncrate, period, tinfo->curr.offset,
+			 ppr_options, AHD_TRANS_GOAL, FALSE);
+	ahd_unlock(ahd, &flags);
+}
+
+static void ahd_linux_get_iu(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahd_softc *ahd = *((struct ahd_softc **)shost->hostdata);
+	struct ahd_tmode_tstate *tstate;
+	struct ahd_initiator_tinfo *tinfo 
+		= ahd_fetch_transinfo(ahd,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	spi_dt(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ;
+}
+
+static void ahd_linux_set_iu(struct scsi_target *starget, int iu)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahd_softc *ahd = *((struct ahd_softc **)shost->hostdata);
+	struct ahd_tmode_tstate *tstate;
+	struct ahd_initiator_tinfo *tinfo 
+		= ahd_fetch_transinfo(ahd,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	struct ahd_devinfo devinfo;
+	unsigned int ppr_options = tinfo->curr.ppr_options
+		& ~MSG_EXT_PPR_IU_REQ;
+	unsigned int period = tinfo->curr.period;
+	unsigned int dt = ppr_options & MSG_EXT_PPR_DT_REQ;
+	unsigned long flags;
+	struct ahd_syncrate *syncrate;
+
+	if (iu)
+		ppr_options |= MSG_EXT_PPR_IU_REQ;
+
+	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
+			    starget->channel + 'A', ROLE_INITIATOR);
+	syncrate = ahd_find_syncrate(ahd, &period, &ppr_options,
+				     dt ? AHD_SYNCRATE_DT : AHD_SYNCRATE_ULTRA2);
+	ahd_lock(ahd, &flags);
+	ahd_set_syncrate(ahd, &devinfo, syncrate, period, tinfo->curr.offset,
+			 ppr_options, AHD_TRANS_GOAL, FALSE);
+	ahd_unlock(ahd, &flags);
+}
+
+static struct spi_function_template ahd_linux_transport_functions = {
+	.get_offset	= ahd_linux_get_offset,
+	.set_offset	= ahd_linux_set_offset,
+	.show_offset	= 1,
+	.get_period	= ahd_linux_get_period,
+	.set_period	= ahd_linux_set_period,
+	.show_period	= 1,
+	.get_width	= ahd_linux_get_width,
+	.set_width	= ahd_linux_set_width,
+	.show_width	= 1,
+	.get_dt		= ahd_linux_get_dt,
+	.set_dt		= ahd_linux_set_dt,
+	.show_dt	= 1,
+	.get_iu		= ahd_linux_get_iu,
+	.set_iu		= ahd_linux_set_iu,
+	.show_iu	= 1,
+	.get_qas	= ahd_linux_get_qas,
+	.set_qas	= ahd_linux_set_qas,
+	.show_qas	= 1,
+};
+
+
+
 static int __init
 ahd_linux_init(void)
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	return ahd_linux_detect(&aic79xx_driver_template);
+	ahd_linux_transport_template = spi_attach_transport(&ahd_linux_transport_functions);
+	if (!ahd_linux_transport_template)
+		return -ENODEV;
+	if (ahd_linux_detect(&aic79xx_driver_template))
+		return 0;
+	spi_release_transport(ahd_linux_transport_template);
 #else
 	scsi_register_module(MODULE_SCSI_HA, &aic79xx_driver_template);
 	if (aic79xx_driver_template.present == 0) {
@@ -5014,19 +3623,6 @@ ahd_linux_init(void)
 static void
 ahd_linux_exit(void)
 {
-	struct ahd_softc *ahd;
-
-	/*
-	 * Shutdown DV threads before going into the SCSI mid-layer.
-	 * This avoids situations where the mid-layer locks the entire
-	 * kernel so that waiting for our DV threads to exit leads
-	 * to deadlock.
-	 */
-	TAILQ_FOREACH(ahd, &ahd_tailq, links) {
-
-		ahd_linux_kill_dv_thread(ahd);
-	}
-
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	/*
 	 * In 2.4 we have to unregister from the PCI core _after_
@@ -5037,6 +3633,7 @@ ahd_linux_exit(void)
 	scsi_unregister_module(MODULE_SCSI_HA, &aic79xx_driver_template);
 #endif
 	ahd_linux_pci_exit();
+	spi_release_transport(ahd_linux_transport_template);
 }
 
 module_init(ahd_linux_init);

--------------030004080908050903080804--
