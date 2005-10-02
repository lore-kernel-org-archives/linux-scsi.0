From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic79xx: fix module removal path not to panic
Date: Sun, 02 Oct 2005 10:08:00 -0500
Message-ID: <1128265680.4810.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:41944 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751106AbVJBPIC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Oct 2005 11:08:02 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j92F81A11893
	for <linux-scsi@vger.kernel.org>; Sun, 2 Oct 2005 11:08:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Naturally, if aic7xxx has a bug, aic79xx has it too...

This applies the same fix to the aic79xx driver (call scsi_host_remove()
before you shut down the sequencer).

James

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1192,11 +1192,6 @@ ahd_platform_free(struct ahd_softc *ahd)
 	int i, j;
 
 	if (ahd->platform_data != NULL) {
-		if (ahd->platform_data->host != NULL) {
-			scsi_remove_host(ahd->platform_data->host);
-			scsi_host_put(ahd->platform_data->host);
-		}
-
 		/* destroy all of the device and target objects */
 		for (i = 0; i < AHD_NUM_TARGETS; i++) {
 			starget = ahd->platform_data->starget[i];
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -95,6 +95,9 @@ ahd_linux_pci_dev_remove(struct pci_dev 
 	struct ahd_softc *ahd = pci_get_drvdata(pdev);
 	u_long s;
 
+	if (ahd->platform_data && ahd->platform_data->host)
+			scsi_remove_host(ahd->platform_data->host);
+
 	ahd_lock(ahd, &s);
 	ahd_intr_enable(ahd, FALSE);
 	ahd_unlock(ahd, &s);


