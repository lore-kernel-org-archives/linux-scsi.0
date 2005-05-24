From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Correct order for device unregistration in aic7xxx
Date: Tue, 24 May 2005 12:24:55 +0200
Message-ID: <429300F7.6010106@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050904040605060609060303"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41431 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S262072AbVEXKZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 06:25:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>

This is a multi-part message in MIME format.
--------------050904040605060609060303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi James,

calling 'rmmod aic79xx' (with my previous patch) results in an
interesting internal state dump of the adapter itself.
Problem is that at the time of calling sd_shutdown() the dv_thread for
this adapter is already stopped so that no command processing will be
done. This confuses the adapter resulting in the state dump.

Instead we should unregister any disks first and then shutting down the
adapter.

Please apply.

Btw, any plans to convert aic79xx to spi_transport?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------050904040605060609060303
Content-Type: text/plain;
 name="linux-2.6.12-rc4-aic79xx-unregister-ml-first"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.12-rc4-aic79xx-unregister-ml-first"

From: Hannes Reinecke <hare@suse.de>
Subject: Correct order for device unregistration in aic7xxx

When issuing a 'rmmod aic79xx' the driver crashes with a rather nasty
internal state dump.
Problem is that all attached devices are shutdown during a call to
ahc_platform_free after the dv_thread is already deleted. This
disables processing of any SCSI commands which any ULD might want to
send (eg SYNCHRONIZE CACHE). So any commands sent to the adaper will
not be processed but result in the state dump mentioned above.

Device unregistration from scsi-ml should be handled before the
adapter itself is disabled to allow for any commands to be handled
properly.

--- linux-2.6.12-rc4/drivers/scsi/aic7xxx/aic7xxx_osm.c.orig	2005-05-24 11:53:51.000000000 +0200
+++ linux-2.6.12-rc4/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-05-24 11:55:30.000000000 +0200
@@ -1748,12 +1748,6 @@ ahc_platform_free(struct ahc_softc *ahc)
 	if (ahc->platform_data != NULL) {
 		del_timer_sync(&ahc->platform_data->completeq_timer);
 		tasklet_kill(&ahc->platform_data->runq_tasklet);
-		if (ahc->platform_data->host != NULL) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-			scsi_remove_host(ahc->platform_data->host);
-#endif
-			scsi_host_put(ahc->platform_data->host);
-		}
 
 		/* destroy all of the device and target objects */
 		for (i = 0; i < AHC_NUM_TARGETS; i++) {
@@ -3623,6 +3617,20 @@ ahc_linux_init(void)
 static void
 ahc_linux_exit(void)
 {
+	struct ahd_softc *ahc;
+
+	/*
+	 * Tear down midlayer first
+	 */
+	TAILQ_FOREACH(ahc, &ahd_tailq, links) {
+		if (ahc->platform_data->host != NULL) {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+			scsi_remove_host(ahc->platform_data->host);
+#endif
+			scsi_host_put(ahc->platform_data->host);
+		}
+	}
+
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	/*
 	 * In 2.4 we have to unregister from the PCI core _after_
--- linux-2.6.12-rc4/drivers/scsi/aic7xxx/aic79xx_osm.c.orig	2005-05-24 11:39:39.000000000 +0200
+++ linux-2.6.12-rc4/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-05-24 11:47:05.000000000 +0200
@@ -2191,12 +2191,6 @@ ahd_platform_free(struct ahd_softc *ahd)
 		del_timer_sync(&ahd->platform_data->completeq_timer);
 		ahd_linux_kill_dv_thread(ahd);
 		ahd_teardown_runq_tasklet(ahd);
-		if (ahd->platform_data->host != NULL) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-			scsi_remove_host(ahd->platform_data->host);
-#endif
-			scsi_host_put(ahd->platform_data->host);
-		}
 
 		/* destroy all of the device and target objects */
 		for (i = 0; i < AHD_NUM_TARGETS; i++) {
@@ -4992,14 +4986,15 @@ ahd_linux_exit(void)
 	struct ahd_softc *ahd;
 
 	/*
-	 * Shutdown DV threads before going into the SCSI mid-layer.
-	 * This avoids situations where the mid-layer locks the entire
-	 * kernel so that waiting for our DV threads to exit leads
-	 * to deadlock.
+	 * Tear down midlayer first
 	 */
 	TAILQ_FOREACH(ahd, &ahd_tailq, links) {
-
-		ahd_linux_kill_dv_thread(ahd);
+		if (ahd->platform_data->host != NULL) {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+			scsi_remove_host(ahd->platform_data->host);
+#endif
+			scsi_host_put(ahd->platform_data->host);
+		}
 	}
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)

--------------050904040605060609060303--
