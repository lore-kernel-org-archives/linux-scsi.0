From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] aic79xx: Fix timer handling
Date: Mon, 30 Jan 2006 16:10:31 +0100
Message-ID: <43DE2C67.5050804@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060500020505010204030905"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:51347 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932308AbWA3PKd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 10:10:33 -0500
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 5C1B51CBE7
	for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2006 16:10:31 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------060500020505010204030905
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi all,

this is a cross port of James' patch re timer handling.
It fixes the timer handling in the aic79xx and also fixes a deadlock in
the error recovery handling; so anyone facing errors with ABORT command
failing should maybe apply this patch.
Oh, this is incremental to the set of aic79xx updates I've posted
earlier. Might apply without, but I would rather apply it on top.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------060500020505010204030905
Content-Type: text/plain;
 name="aic79xx-fix-timer-handling"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic79xx-fix-timer-handling"

Fix the timer handling in aic79xx to use the SCSI-ML provided handling
instead of implementing our own.
It also fixes a deadlock in the command recovery code.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/aic7xxx/Kconfig.aic79xx b/drivers/scsi/aic7xxx/Kconfig.aic79xx
index 69ed77f..7955ebe 100644
--- a/drivers/scsi/aic7xxx/Kconfig.aic79xx
+++ b/drivers/scsi/aic7xxx/Kconfig.aic79xx
@@ -37,13 +37,13 @@ config AIC79XX_CMDS_PER_DEVICE
 config AIC79XX_RESET_DELAY_MS
 	int "Initial bus reset delay in milli-seconds"
 	depends on SCSI_AIC79XX
-	default "15000"
+	default "5000"
 	---help---
 	The number of milliseconds to delay after an initial bus reset.
 	The bus settle delay following all error recovery actions is
 	dictated by the SCSI layer and is not affected by this value.
 
-	Default: 15000 (15 seconds)
+	Default: 5000 (5 seconds)
 
 config AIC79XX_BUILD_FIRMWARE
 	bool "Build Adapter Firmware with Kernel Build"
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 6114b3e..342f779 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -8273,11 +8273,6 @@ ahd_handle_scsi_status(struct ahd_softc 
 		ahd_setup_data_scb(ahd, scb);
 		scb->flags |= SCB_SENSE;
 		ahd_queue_scb(ahd, scb);
-		/*
-		 * Ensure we have enough time to actually
-		 * retrieve the sense.
-		 */
-		ahd_scb_timer_reset(scb, 5 * 1000000);
 		break;
 	}
 	case SCSI_STATUS_OK:
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 803bb96..78c8338 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1089,7 +1089,6 @@ ahd_linux_register_host(struct ahd_softc
 		return (ENOMEM);
 
 	*((struct ahd_softc **)host->hostdata) = ahd;
-	ahd_lock(ahd, &s);
 	ahd->platform_data->host = host;
 	host->can_queue = AHD_MAX_QUEUE;
 	host->cmd_per_lun = 2;
@@ -1100,7 +1099,9 @@ ahd_linux_register_host(struct ahd_softc
 	host->max_lun = AHD_NUM_LUNS;
 	host->max_channel = 0;
 	host->sg_tablesize = AHD_NSEG;
+	ahd_lock(ahd, &s);
 	ahd_set_unit(ahd, ahd_linux_unit++);
+	ahd_unlock(ahd, &s);
 	sprintf(buf, "scsi%d", host->host_no);
 	new_name = malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
 	if (new_name != NULL) {
@@ -1110,7 +1111,6 @@ ahd_linux_register_host(struct ahd_softc
 	host->unique_id = ahd->unit;
 	ahd_linux_initialize_scsi_bus(ahd);
 	ahd_intr_enable(ahd, TRUE);
-	ahd_unlock(ahd, &s);
 
 	host->transportt = ahd_linux_transport_template;
 
@@ -1144,6 +1144,7 @@ ahd_linux_initialize_scsi_bus(struct ahd
 {
 	u_int target_id;
 	u_int numtarg;
+	unsigned long s;
 
 	target_id = 0;
 	numtarg = 0;
@@ -1156,6 +1157,8 @@ ahd_linux_initialize_scsi_bus(struct ahd
 	else
 		numtarg = (ahd->features & AHD_WIDE) ? 16 : 8;
 
+	ahd_lock(ahd, &s);
+
 	/*
 	 * Force negotiation to async for all targets that
 	 * will not see an initial bus reset.
@@ -1172,16 +1175,12 @@ ahd_linux_initialize_scsi_bus(struct ahd
 		ahd_update_neg_request(ahd, &devinfo, tstate,
 				       tinfo, AHD_NEG_ALWAYS);
 	}
+	ahd_unlock(ahd, &s);
 	/* Give the bus some time to recover */
 	if ((ahd->flags & AHD_RESET_BUS_A) != 0) {
 		ahd_freeze_simq(ahd);
-		init_timer(&ahd->platform_data->reset_timer);
-		ahd->platform_data->reset_timer.data = (u_long)ahd;
-		ahd->platform_data->reset_timer.expires =
-		    jiffies + (AIC79XX_RESET_DELAY * HZ)/1000;
-		ahd->platform_data->reset_timer.function =
-		    (ahd_linux_callback_t *)ahd_release_simq;
-		add_timer(&ahd->platform_data->reset_timer);
+		msleep(AIC79XX_RESET_DELAY);
+		ahd_release_simq(ahd);
 	}
 }
 
@@ -2050,6 +2049,9 @@ ahd_linux_sem_timeout(u_long arg)
 void
 ahd_freeze_simq(struct ahd_softc *ahd)
 {
+	unsigned long s;
+
+	ahd_lock(ahd, &s);
 	ahd->platform_data->qfrozen++;
 	if (ahd->platform_data->qfrozen == 1) {
 		scsi_block_requests(ahd->platform_data->host);
@@ -2057,6 +2059,7 @@ ahd_freeze_simq(struct ahd_softc *ahd)
 					CAM_LUN_WILDCARD, SCB_LIST_NULL,
 					ROLE_INITIATOR, CAM_REQUEUE_REQ);
 	}
+	ahd_unlock(ahd, &s);
 }
 
 void
@@ -2361,8 +2364,9 @@ done:
 			       ahd_name(ahd), dev->active);
 			retval = FAILED;
 		}
-	}
-	ahd_unlock(ahd, &flags);
+	} else
+		ahd_unlock(ahd, &flags);
+
 	return (retval);
 }
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
index 854fc57..9cb1013 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -228,7 +228,6 @@ typedef struct timer_list ahd_timer_t;
 typedef void ahd_linux_callback_t (u_long);  
 static __inline void ahd_timer_reset(ahd_timer_t *timer, int usec,
 				     ahd_callback_t *func, void *arg);
-static __inline void ahd_scb_timer_reset(struct scb *scb, u_int usec);
 
 static __inline void
 ahd_timer_reset(ahd_timer_t *timer, int usec, ahd_callback_t *func, void *arg)
@@ -243,12 +242,6 @@ ahd_timer_reset(ahd_timer_t *timer, int 
 	add_timer(timer);
 }
 
-static __inline void
-ahd_scb_timer_reset(struct scb *scb, u_int usec)
-{
-	mod_timer(&scb->io_ctx->eh_timeout, jiffies + (usec * HZ)/1000000);
-}
-
 /***************************** SMP support ************************************/
 #include <linux/spinlock.h>
 
@@ -389,7 +382,6 @@ struct ahd_platform_data {
 
 	spinlock_t		 spin_lock;
 	u_int			 qfrozen;
-	struct timer_list	 reset_timer;
 	struct semaphore	 eh_sem;
 	struct Scsi_Host        *host;		/* pointer to scsi host */
 #define AHD_LINUX_NOIRQ	((uint32_t)~0)

--------------060500020505010204030905--
