From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/07] aic79xx: remove qfrozen
Date: Wed, 08 Mar 2006 12:56:14 +0100
Message-ID: <440EC65E.9020707@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010101000409070400010904"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:60901 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1751518AbWCHL4Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 06:56:16 -0500
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 374EF1D7C4
	for <linux-scsi@vger.kernel.org>; Wed,  8 Mar 2006 12:56:14 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010101000409070400010904
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

This patch removes the need for platform_data->qfrozen.
We're now using complete() instead of semaphores thus
simplifying ahd_freeze_simq() quite a lot.
This also fixes some deadlocks in the recovery code (again).

Signed-off-by: Hannes Reinecke <hare@suse.de>

--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------010101000409070400010904
Content-Type: text/plain;
 name="01-aic79xx-remove-qfrozen.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-aic79xx-remove-qfrozen.txt"

[PATCH 01/07] aic79xx: remove qfrozen

This patch removes the need for platform_data->qfrozen.
We're now using complete() instead of semaphores thus
simplifying ahd_freeze_simq() quite a lot.
This also fixes some deadlocks in the recovery code (again).

Signed-off-by: Hannes Reinecke <hare@suse.de>

---
 aic79xx_osm.c |  104 ++++++++++++++--------------------------------------------
 aic79xx_osm.h |    5 --
 2 files changed, 27 insertions(+), 82 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 7254ea5..fc393bd 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -373,7 +373,6 @@ static void ahd_linux_handle_scsi_status
 					 struct scb *);
 static void ahd_linux_queue_cmd_complete(struct ahd_softc *ahd,
 					 struct scsi_cmnd *cmd);
-static void ahd_linux_sem_timeout(u_long arg);
 static int  ahd_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag);
 static void ahd_linux_initialize_scsi_bus(struct ahd_softc *ahd);
 static u_int ahd_linux_user_tagdepth(struct ahd_softc *ahd,
@@ -453,18 +452,13 @@ ahd_linux_queue(struct scsi_cmnd * cmd, 
 	struct	 ahd_softc *ahd;
 	struct	 ahd_linux_device *dev = scsi_transport_device_data(cmd->device);
 	int rtn = SCSI_MLQUEUE_HOST_BUSY;
-	unsigned long flags;
 
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
-	ahd_lock(ahd, &flags);
-	if (ahd->platform_data->qfrozen == 0) {
-		cmd->scsi_done = scsi_done;
-		cmd->result = CAM_REQ_INPROG << 16;
-		rtn = ahd_linux_run_command(ahd, dev, cmd);
+	cmd->scsi_done = scsi_done;
+	cmd->result = CAM_REQ_INPROG << 16;
+	rtn = ahd_linux_run_command(ahd, dev, cmd);
 
-	}
-	ahd_unlock(ahd, &flags);
 	return rtn;
 }
 
@@ -682,7 +676,6 @@ static int
 ahd_linux_bus_reset(struct scsi_cmnd *cmd)
 {
 	struct ahd_softc *ahd;
-	u_long s;
 	int    found;
 
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
@@ -691,10 +684,8 @@ ahd_linux_bus_reset(struct scsi_cmnd *cm
 		printf("%s: Bus reset called for cmd %p\n",
 		       ahd_name(ahd), cmd);
 #endif
-	ahd_lock(ahd, &s);
 	found = ahd_reset_channel(ahd, scmd_channel(cmd) + 'A',
 				  /*initiate reset*/TRUE);
-	ahd_unlock(ahd, &s);
 
 	if (bootverbose)
 		printf("%s: SCSI bus reset delivered. "
@@ -1194,7 +1185,6 @@ ahd_platform_alloc(struct ahd_softc *ahd
 	memset(ahd->platform_data, 0, sizeof(struct ahd_platform_data));
 	ahd->platform_data->irq = AHD_LINUX_NOIRQ;
 	ahd_lockinit(ahd);
-	init_MUTEX_LOCKED(&ahd->platform_data->eh_sem);
 	ahd->seltime = (aic79xx_seltime & 0x3) << 4;
 	return (0);
 }
@@ -1443,6 +1433,9 @@ ahd_linux_run_command(struct ahd_softc *
 	struct	 ahd_tmode_tstate *tstate;
 	u_int	 col_idx;
 	uint16_t mask;
+	unsigned long flags;
+
+	ahd_lock(ahd, &flags);
 
 	/*
 	 * Get an scb to use.
@@ -1458,6 +1451,7 @@ ahd_linux_run_command(struct ahd_softc *
 	}
 	if ((scb = ahd_get_scb(ahd, col_idx)) == NULL) {
 		ahd->flags |= AHD_RESOURCE_SHORTAGE;
+		ahd_unlock(ahd, &flags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -1583,6 +1577,8 @@ ahd_linux_run_command(struct ahd_softc *
 	scb->flags |= SCB_ACTIVE;
 	ahd_queue_scb(ahd, scb);
 
+	ahd_unlock(ahd, &flags);
+
 	return 0;
 }
 
@@ -1618,7 +1614,6 @@ ahd_send_async(struct ahd_softc *ahd, ch
 	{
 		char	buf[80];
 		struct  scsi_target *starget;
-		struct	ahd_linux_target *targ;
 		struct	info_str info;
 		struct	ahd_initiator_tinfo *tinfo;
 		struct	ahd_tmode_tstate *tstate;
@@ -1651,7 +1646,6 @@ ahd_send_async(struct ahd_softc *ahd, ch
 		starget = ahd->platform_data->starget[target];
 		if (starget == NULL)
 			break;
-		targ = scsi_transport_target_data(starget);
 
 		target_ppr_options =
 			(spi_dt(starget) ? MSG_EXT_PPR_DT_REQ : 0)
@@ -1803,10 +1797,9 @@ ahd_done(struct ahd_softc *ahd, struct s
 		if (ahd_get_transaction_status(scb) == CAM_BDR_SENT
 		 || ahd_get_transaction_status(scb) == CAM_REQ_ABORTED)
 			ahd_set_transaction_status(scb, CAM_CMD_TIMEOUT);
-		if ((ahd->platform_data->flags & AHD_SCB_UP_EH_SEM) != 0) {
-			ahd->platform_data->flags &= ~AHD_SCB_UP_EH_SEM;
-			up(&ahd->platform_data->eh_sem);
-		}
+
+		if (ahd->platform_data->eh_done)
+			complete(ahd->platform_data->eh_done);
 	}
 
 	ahd_free_scb(ahd, scb);
@@ -2030,60 +2023,16 @@ ahd_linux_queue_cmd_complete(struct ahd_
 	cmd->scsi_done(cmd);
 }
 
-static void
-ahd_linux_sem_timeout(u_long arg)
-{
-	struct	ahd_softc *ahd;
-	u_long	s;
-
-	ahd = (struct ahd_softc *)arg;
-
-	ahd_lock(ahd, &s);
-	if ((ahd->platform_data->flags & AHD_SCB_UP_EH_SEM) != 0) {
-		ahd->platform_data->flags &= ~AHD_SCB_UP_EH_SEM;
-		up(&ahd->platform_data->eh_sem);
-	}
-	ahd_unlock(ahd, &s);
-}
-
 void
 ahd_freeze_simq(struct ahd_softc *ahd)
 {
-	unsigned long s;
-
-	ahd_lock(ahd, &s);
-	ahd->platform_data->qfrozen++;
-	if (ahd->platform_data->qfrozen == 1) {
-		scsi_block_requests(ahd->platform_data->host);
-		ahd_platform_abort_scbs(ahd, CAM_TARGET_WILDCARD, ALL_CHANNELS,
-					CAM_LUN_WILDCARD, SCB_LIST_NULL,
-					ROLE_INITIATOR, CAM_REQUEUE_REQ);
-	}
-	ahd_unlock(ahd, &s);
+	scsi_block_requests(ahd->platform_data->host);
 }
 
 void
 ahd_release_simq(struct ahd_softc *ahd)
 {
-	u_long s;
-	int    unblock_reqs;
-
-	unblock_reqs = 0;
-	ahd_lock(ahd, &s);
-	if (ahd->platform_data->qfrozen > 0)
-		ahd->platform_data->qfrozen--;
-	if (ahd->platform_data->qfrozen == 0) {
-		unblock_reqs = 1;
-	}
-	ahd_unlock(ahd, &s);
-	/*
-	 * There is still a race here.  The mid-layer
-	 * should keep its own freeze count and use
-	 * a bottom half handler to run the queues
-	 * so we can unblock with our own lock held.
-	 */
-	if (unblock_reqs)
-		scsi_unblock_requests(ahd->platform_data->host);
+	scsi_unblock_requests(ahd->platform_data->host);
 }
 
 static int
@@ -2344,30 +2293,29 @@ done:
 	if (paused)
 		ahd_unpause(ahd);
 	if (wait) {
-		struct timer_list timer;
-		int ret;
+		DECLARE_COMPLETION(done);
 
-		ahd->platform_data->flags |= AHD_SCB_UP_EH_SEM;
+		ahd->platform_data->eh_done = &done;
 		ahd_unlock(ahd, &flags);
 
-		init_timer(&timer);
-		timer.data = (u_long)ahd;
-		timer.expires = jiffies + (5 * HZ);
-		timer.function = ahd_linux_sem_timeout;
-		add_timer(&timer);
 		printf("%s: Recovery code sleeping\n", ahd_name(ahd));
-		down(&ahd->platform_data->eh_sem);
-		printf("%s: Recovery code awake\n", ahd_name(ahd));
-        	ret = del_timer_sync(&timer);
-		if (ret == 0) {
+		if (!wait_for_completion_timeout(&done, 5 * HZ)) {
+			ahd_lock(ahd, &flags);
+			ahd->platform_data->eh_done = NULL;
+			ahd_unlock(ahd, &flags);
 			printf("%s: Timer Expired (active %d)\n",
 			       ahd_name(ahd), dev->active);
 			retval = FAILED;
 		}
+		printf("Recovery code awake\n");
 	} else
 		ahd_unlock(ahd, &flags);
 
-	return (retval);
+	if (retval != SUCCESS)
+		printf("%s: Command abort returning 0x%x\n",
+		       ahd_name(ahd), retval);
+
+	return retval;
 }
 
 static void ahd_linux_set_width(struct scsi_target *starget, int width)
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
index 9cb1013..599e394 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -381,15 +381,12 @@ struct ahd_platform_data {
 	struct scsi_target *starget[AHD_NUM_TARGETS]; 
 
 	spinlock_t		 spin_lock;
-	u_int			 qfrozen;
-	struct semaphore	 eh_sem;
+	struct completion	*eh_done;
 	struct Scsi_Host        *host;		/* pointer to scsi host */
 #define AHD_LINUX_NOIRQ	((uint32_t)~0)
 	uint32_t		 irq;		/* IRQ for this adapter */
 	uint32_t		 bios_address;
 	uint32_t		 mem_busaddr;	/* Mem Base Addr */
-#define	AHD_SCB_UP_EH_SEM 0x1
-	uint32_t		 flags;
 };
 
 /************************** OS Utility Wrappers *******************************/

--------------010101000409070400010904--
