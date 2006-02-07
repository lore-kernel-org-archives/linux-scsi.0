From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] aic79xx: convert qfrozen to atomic_t
Date: Tue, 07 Feb 2006 08:52:50 +0100
Message-ID: <43E851D2.1060306@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030901090204080203000908"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:13491 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S965003AbWBGHwv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 02:52:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: "emmanuel.fuste" <emmanuel.fuste@laposte.net>

This is a multi-part message in MIME format.
--------------030901090204080203000908
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

This patch converts platform_data->qfrozen to atomic_t.
This way we can get rid of ahd_lock / ahd_unlock for the
accessor functions; it also fixes some deadlocks in the
recovery code (again).

Signed-off-by: Hannes Reinecke <hare@suse.de>

--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------030901090204080203000908
Content-Type: text/plain;
 name="0001-aic79xx-convert-qfrozen-to-atomic_t.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-aic79xx-convert-qfrozen-to-atomic_t.txt"

Subject: [PATCH 1/3] aic79xx: convert qfrozen to atomic_t

This patch converts platform_data->qfrozen to atomic_t.
This way we can get rid of ahd_lock / ahd_unlock for the
accessor functions; it also fixes some deadlocks in the
recovery code (again).

Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 drivers/scsi/aic7xxx/aic79xx_osm.c |   42 +++++++++---------------------------
 drivers/scsi/aic7xxx/aic79xx_osm.h |    2 +-
 2 files changed, 11 insertions(+), 33 deletions(-)

872e277a460c57d74bfb478fdbc86aae02f37198
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 78c8338..bd2be6a 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -453,18 +453,15 @@ ahd_linux_queue(struct scsi_cmnd * cmd, 
 	struct	 ahd_softc *ahd;
 	struct	 ahd_linux_device *dev = scsi_transport_device_data(cmd->device);
 	int rtn = SCSI_MLQUEUE_HOST_BUSY;
-	unsigned long flags;
 
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
-	ahd_lock(ahd, &flags);
-	if (ahd->platform_data->qfrozen == 0) {
+	if (!atomic_read(&ahd->platform_data->qfrozen)) {
 		cmd->scsi_done = scsi_done;
 		cmd->result = CAM_REQ_INPROG << 16;
 		rtn = ahd_linux_run_command(ahd, dev, cmd);
 
 	}
-	ahd_unlock(ahd, &flags);
 	return rtn;
 }
 
@@ -691,10 +688,8 @@ ahd_linux_bus_reset(struct scsi_cmnd *cm
 		printf("%s: Bus reset called for cmd %p\n",
 		       ahd_name(ahd), cmd);
 #endif
-	ahd_lock(ahd, &s);
 	found = ahd_reset_channel(ahd, scmd_channel(cmd) + 'A',
 				  /*initiate reset*/TRUE);
-	ahd_unlock(ahd, &s);
 
 	if (bootverbose)
 		printf("%s: SCSI bus reset delivered. "
@@ -1194,6 +1189,7 @@ ahd_platform_alloc(struct ahd_softc *ahd
 	memset(ahd->platform_data, 0, sizeof(struct ahd_platform_data));
 	ahd->platform_data->irq = AHD_LINUX_NOIRQ;
 	ahd_lockinit(ahd);
+	atomic_set(&ahd->platform_data->qfrozen, 0);
 	init_MUTEX_LOCKED(&ahd->platform_data->eh_sem);
 	ahd->seltime = (aic79xx_seltime & 0x3) << 4;
 	return (0);
@@ -1443,6 +1439,9 @@ ahd_linux_run_command(struct ahd_softc *
 	struct	 ahd_tmode_tstate *tstate;
 	u_int	 col_idx;
 	uint16_t mask;
+	unsigned long flags;
+
+	ahd_lock(ahd, &flags);
 
 	/*
 	 * Get an scb to use.
@@ -1458,6 +1457,7 @@ ahd_linux_run_command(struct ahd_softc *
 	}
 	if ((scb = ahd_get_scb(ahd, col_idx)) == NULL) {
 		ahd->flags |= AHD_RESOURCE_SHORTAGE;
+		ahd_unlock(ahd, &flags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -1583,6 +1583,8 @@ ahd_linux_run_command(struct ahd_softc *
 	scb->flags |= SCB_ACTIVE;
 	ahd_queue_scb(ahd, scb);
 
+	ahd_unlock(ahd, &flags);
+
 	return 0;
 }
 
@@ -2051,38 +2053,14 @@ ahd_freeze_simq(struct ahd_softc *ahd)
 {
 	unsigned long s;
 
-	ahd_lock(ahd, &s);
-	ahd->platform_data->qfrozen++;
-	if (ahd->platform_data->qfrozen == 1) {
+	if (!atomic_inc_and_test(&ahd->platform_data->qfrozen))
 		scsi_block_requests(ahd->platform_data->host);
-		ahd_platform_abort_scbs(ahd, CAM_TARGET_WILDCARD, ALL_CHANNELS,
-					CAM_LUN_WILDCARD, SCB_LIST_NULL,
-					ROLE_INITIATOR, CAM_REQUEUE_REQ);
-	}
-	ahd_unlock(ahd, &s);
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
+	if (atomic_dec_and_test(&ahd->platform_data->qfrozen))
 		scsi_unblock_requests(ahd->platform_data->host);
 }
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
index 9cb1013..1f60590 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -381,7 +381,7 @@ struct ahd_platform_data {
 	struct scsi_target *starget[AHD_NUM_TARGETS]; 
 
 	spinlock_t		 spin_lock;
-	u_int			 qfrozen;
+	atomic_t		 qfrozen;
 	struct semaphore	 eh_sem;
 	struct Scsi_Host        *host;		/* pointer to scsi host */
 #define AHD_LINUX_NOIRQ	((uint32_t)~0)
-- 
1.1.3

--------------030901090204080203000908--
