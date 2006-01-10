From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic7xxx timer handling bug
Date: Tue, 10 Jan 2006 12:11:42 -0600
Message-ID: <1136916702.3509.29.camel@mulgrave>
References: <20060109040606.118a0d33.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:63152 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932414AbWAJSLx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 13:11:53 -0500
In-Reply-To: <20060109040606.118a0d33.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-01-09 at 04:06 -0800, Andrew Morton wrote:
> While doing a binary search for a buggy patch (it was
> gregkh-pci-x86-pci-domain-support-the-meat.patch, reported on
> linux-kernel), I hit the below.

OK, try this; it should pull out all of the aic7xxx timer handling and
replace it with proper mechanisms (I had to rework the locking a bit to
get this to happen correctly, so caveat emptor).

Unfortunately, aic79xx also needs something like this ... and the patch
there will be much larger.

James
diff --git a/drivers/scsi/aic7xxx/Kconfig.aic7xxx b/drivers/scsi/aic7xxx/Kconfig.aic7xxx
--- a/drivers/scsi/aic7xxx/Kconfig.aic7xxx
+++ b/drivers/scsi/aic7xxx/Kconfig.aic7xxx
@@ -42,13 +42,13 @@ config AIC7XXX_CMDS_PER_DEVICE
 config AIC7XXX_RESET_DELAY_MS
 	int "Initial bus reset delay in milli-seconds"
 	depends on SCSI_AIC7XXX
-	default "15000"
+	default "5000"
 	---help---
 	The number of milliseconds to delay after an initial bus reset.
 	The bus settle delay following all error recovery actions is
 	dictated by the SCSI layer and is not affected by this value.
 
-	Default: 15000 (15 seconds)
+	Default: 5000 (5 seconds)
 
 config AIC7XXX_PROBE_EISA_VL
 	bool "Probe for EISA and VL AIC7XXX Adapters"
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -375,7 +375,7 @@ static void ahc_linux_queue_cmd_complete
 					 struct scsi_cmnd *cmd);
 static void ahc_linux_sem_timeout(u_long arg);
 static void ahc_linux_freeze_simq(struct ahc_softc *ahc);
-static void ahc_linux_release_simq(u_long arg);
+static void ahc_linux_release_simq(struct ahc_softc *ahc);
 static int  ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag);
 static void ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc);
 static u_int ahc_linux_user_tagdepth(struct ahc_softc *ahc,
@@ -1073,7 +1073,6 @@ ahc_linux_register_host(struct ahc_softc
 		return (ENOMEM);
 
 	*((struct ahc_softc **)host->hostdata) = ahc;
-	ahc_lock(ahc, &s);
 	ahc->platform_data->host = host;
 	host->can_queue = AHC_MAX_QUEUE;
 	host->cmd_per_lun = 2;
@@ -1084,7 +1083,9 @@ ahc_linux_register_host(struct ahc_softc
 	host->max_lun = AHC_NUM_LUNS;
 	host->max_channel = (ahc->features & AHC_TWIN) ? 1 : 0;
 	host->sg_tablesize = AHC_NSEG;
+	ahc_lock(ahc, &s);
 	ahc_set_unit(ahc, ahc_linux_unit++);
+	ahc_unlock(ahc, &s);
 	sprintf(buf, "scsi%d", host->host_no);
 	new_name = malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
 	if (new_name != NULL) {
@@ -1094,7 +1095,6 @@ ahc_linux_register_host(struct ahc_softc
 	host->unique_id = ahc->unit;
 	ahc_linux_initialize_scsi_bus(ahc);
 	ahc_intr_enable(ahc, TRUE);
-	ahc_unlock(ahc, &s);
 
 	host->transportt = ahc_linux_transport_template;
 
@@ -1120,10 +1120,13 @@ ahc_linux_initialize_scsi_bus(struct ahc
 {
 	int i;
 	int numtarg;
+	unsigned long s;
 
 	i = 0;
 	numtarg = 0;
 
+	ahc_lock(ahc, &s);
+
 	if (aic7xxx_no_reset != 0)
 		ahc->flags &= ~(AHC_RESET_BUS_A|AHC_RESET_BUS_B);
 
@@ -1170,16 +1173,12 @@ ahc_linux_initialize_scsi_bus(struct ahc
 		ahc_update_neg_request(ahc, &devinfo, tstate,
 				       tinfo, AHC_NEG_ALWAYS);
 	}
+	ahc_unlock(ahc, &s);
 	/* Give the bus some time to recover */
 	if ((ahc->flags & (AHC_RESET_BUS_A|AHC_RESET_BUS_B)) != 0) {
 		ahc_linux_freeze_simq(ahc);
-		init_timer(&ahc->platform_data->reset_timer);
-		ahc->platform_data->reset_timer.data = (u_long)ahc;
-		ahc->platform_data->reset_timer.expires =
-		    jiffies + (AIC7XXX_RESET_DELAY * HZ)/1000;
-		ahc->platform_data->reset_timer.function =
-		    ahc_linux_release_simq;
-		add_timer(&ahc->platform_data->reset_timer);
+		msleep(AIC7XXX_RESET_DELAY);
+		ahc_linux_release_simq(ahc);
 	}
 }
 
@@ -2059,6 +2058,9 @@ ahc_linux_sem_timeout(u_long arg)
 static void
 ahc_linux_freeze_simq(struct ahc_softc *ahc)
 {
+	unsigned long s;
+
+	ahc_lock(ahc, &s);
 	ahc->platform_data->qfrozen++;
 	if (ahc->platform_data->qfrozen == 1) {
 		scsi_block_requests(ahc->platform_data->host);
@@ -2068,17 +2070,15 @@ ahc_linux_freeze_simq(struct ahc_softc *
 					CAM_LUN_WILDCARD, SCB_LIST_NULL,
 					ROLE_INITIATOR, CAM_REQUEUE_REQ);
 	}
+	ahc_unlock(ahc, &s);
 }
 
 static void
-ahc_linux_release_simq(u_long arg)
+ahc_linux_release_simq(struct ahc_softc *ahc)
 {
-	struct ahc_softc *ahc;
 	u_long s;
 	int    unblock_reqs;
 
-	ahc = (struct ahc_softc *)arg;
-
 	unblock_reqs = 0;
 	ahc_lock(ahc, &s);
 	if (ahc->platform_data->qfrozen > 0)
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.h b/drivers/scsi/aic7xxx/aic7xxx_osm.h
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -223,9 +223,6 @@ int	ahc_dmamap_unload(struct ahc_softc *
  */
 #define ahc_dmamap_sync(ahc, dma_tag, dmamap, offset, len, op)
 
-/************************** Timer DataStructures ******************************/
-typedef struct timer_list ahc_timer_t;
-
 /********************************** Includes **********************************/
 #ifdef CONFIG_AIC7XXX_REG_PRETTY_PRINT
 #define AIC_DEBUG_REGISTERS 1
@@ -235,30 +232,9 @@ typedef struct timer_list ahc_timer_t;
 #include "aic7xxx.h"
 
 /***************************** Timer Facilities *******************************/
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
 static __inline void
 ahc_scb_timer_reset(struct scb *scb, u_int usec)
 {
-	mod_timer(&scb->io_ctx->eh_timeout, jiffies + (usec * HZ)/1000000);
 }
 
 /***************************** SMP support ************************************/
@@ -393,7 +369,6 @@ struct ahc_platform_data {
 
 	spinlock_t		 spin_lock;
 	u_int			 qfrozen;
-	struct timer_list	 reset_timer;
 	struct semaphore	 eh_sem;
 	struct Scsi_Host        *host;		/* pointer to scsi host */
 #define AHC_LINUX_NOIRQ	((uint32_t)~0)



