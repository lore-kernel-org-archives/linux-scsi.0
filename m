From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic7xxx/aic79xx: fix module removal path not to panic
Date: Sun, 02 Oct 2005 15:22:35 -0500
Message-ID: <1128284555.4912.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:33754 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751032AbVJBUWs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Oct 2005 16:22:48 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j92KMaA24576
	for <linux-scsi@vger.kernel.org>; Sun, 2 Oct 2005 16:22:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a re-roll and consolidation of the previous patches.  This time
with the scsi_host_put() in the correct place (as opposed to missing).

James

diff --git a/drivers/scsi/aic7xxx/aic7770_osm.c b/drivers/scsi/aic7xxx/aic7770_osm.c
--- a/drivers/scsi/aic7xxx/aic7770_osm.c
+++ b/drivers/scsi/aic7xxx/aic7770_osm.c
@@ -112,6 +112,9 @@ aic7770_remove(struct device *dev)
 	struct ahc_softc *ahc = dev_get_drvdata(dev);
 	u_long s;
 
+	if (ahc->platform_data && ahc->platform_data->host)
+			scsi_remove_host(ahc->platform_data->host);
+
 	ahc_lock(ahc, &s);
 	ahc_intr_enable(ahc, FALSE);
 	ahc_unlock(ahc, &s);
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
@@ -1226,6 +1221,9 @@ ahd_platform_free(struct ahd_softc *ahd)
 			release_mem_region(ahd->platform_data->mem_busaddr,
 					   0x1000);
 		}
+		if (ahd->platform_data->host)
+			scsi_host_put(ahd->platform_data->host);
+
 		free(ahd->platform_data, M_DEVBUF);
 	}
 }
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
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1209,11 +1209,6 @@ ahc_platform_free(struct ahc_softc *ahc)
 	int i, j;
 
 	if (ahc->platform_data != NULL) {
-		if (ahc->platform_data->host != NULL) {
-			scsi_remove_host(ahc->platform_data->host);
-			scsi_host_put(ahc->platform_data->host);
-		}
-
 		/* destroy all of the device and target objects */
 		for (i = 0; i < AHC_NUM_TARGETS; i++) {
 			starget = ahc->platform_data->starget[i];
@@ -1242,6 +1237,9 @@ ahc_platform_free(struct ahc_softc *ahc)
 					   0x1000);
 		}
 
+		if (ahc->platform_data->host)
+			scsi_host_put(ahc->platform_data->host);
+
 		free(ahc->platform_data, M_DEVBUF);
 	}
 }
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -143,6 +143,9 @@ ahc_linux_pci_dev_remove(struct pci_dev 
 	struct ahc_softc *ahc = pci_get_drvdata(pdev);
 	u_long s;
 
+	if (ahc->platform_data && ahc->platform_data->host)
+			scsi_remove_host(ahc->platform_data->host);
+
 	ahc_lock(ahc, &s);
 	ahc_intr_enable(ahc, FALSE);
 	ahc_unlock(ahc, &s);


