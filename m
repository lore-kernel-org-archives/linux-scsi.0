From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [PATCH] Fix sleeping while holding a lock on host removal and on
 killing the DV thread
Date: Wed, 13 Oct 2004 16:23:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416D8EBA.7060904@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:36814 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S269806AbUJMUXe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 16:23:34 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>

Fix sleeping while holding a lock on host removal and on
killing the DV thread.

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/13 15:55:49-04:00 luben@lion.adaptec.com
#   Fix sleeping while holding a lock on host removal and
#   on killing the DV thread.
#
# drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
#   2004/10/13 15:55:36-04:00 luben@lion.adaptec.com +4 -2
#   Fix sleeping while holding a lock on host removal.
#
# drivers/scsi/aic7xxx/aic7xxx_osm.c
#   2004/10/13 15:55:35-04:00 luben@lion.adaptec.com +0 -3
#   Fix sleeping while holding a lock on killing the DV thread.
#
# drivers/scsi/aic7xxx/aic7xxx_core.c
#   2004/10/13 15:55:35-04:00 luben@lion.adaptec.com +0 -1
#   Fix sleeping while holding a lock on host removal.
#
# drivers/scsi/aic7xxx/aic79xx_osm_pci.c
#   2004/10/13 15:55:35-04:00 luben@lion.adaptec.com +4 -2
#   Fix sleeping while holding a lock on host removal.
#
# drivers/scsi/aic7xxx/aic79xx_osm.c
#   2004/10/13 15:55:35-04:00 luben@lion.adaptec.com +1 -3
#   Fix sleeping while holding a lock on killing the DV thread.
#
# drivers/scsi/aic7xxx/aic79xx_core.c
#   2004/10/13 15:55:35-04:00 luben@lion.adaptec.com +0 -1
#   Fix sleeping while holding a lock on host removal.
#
diff -Nru a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c	2004-10-13 15:58:23 -04:00
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c	2004-10-13 15:58:23 -04:00
@@ -5270,7 +5270,6 @@
  	default:
  	case 5:
  		ahd_shutdown(ahd);
-		TAILQ_REMOVE(&ahd_tailq, ahd, links);
  		/* FALLTHROUGH */
  	case 4:
  		ahd_dmamap_unload(ahd, ahd->shared_data_dmat,
diff -Nru a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-10-13 15:58:23 -04:00
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-10-13 15:58:23 -04:00
@@ -5032,7 +5032,6 @@
  ahd_linux_exit(void)
  {
  	struct ahd_softc *ahd;
-	u_long l;

  	/*
  	 * Shutdown DV threads before going into the SCSI mid-layer.
@@ -5040,12 +5039,11 @@
  	 * kernel so that waiting for our DV threads to exit leads
  	 * to deadlock.
  	 */
-	ahd_list_lock(&l);
  	TAILQ_FOREACH(ahd, &ahd_tailq, links) {

  		ahd_linux_kill_dv_thread(ahd);
  	}
-	ahd_list_unlock(&l);
+
  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
  	/*
  	 * In 2.4 we have to unregister from the PCI core _after_
diff -Nru a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2004-10-13 15:58:23 -04:00
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2004-10-13 15:58:23 -04:00
@@ -105,12 +105,14 @@
  	if (ahd != NULL) {
  		u_long s;

+		TAILQ_REMOVE(&ahd_tailq, ahd, links);
+		ahd_list_unlock(&l);
  		ahd_lock(ahd, &s);
  		ahd_intr_enable(ahd, FALSE);
  		ahd_unlock(ahd, &s);
  		ahd_free(ahd);
-	}
-	ahd_list_unlock(&l);
+	} else
+		ahd_list_unlock(&l);
  }

  static int
diff -Nru a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c	2004-10-13 15:58:23 -04:00
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c	2004-10-13 15:58:23 -04:00
@@ -3973,7 +3973,6 @@
  	default:
  	case 5:
  		ahc_shutdown(ahc);
-		TAILQ_REMOVE(&ahc_tailq, ahc, links);
  		/* FALLTHROUGH */
  	case 4:
  		ahc_dmamap_unload(ahc, ahc->shared_data_dmat,
diff -Nru a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-10-13 15:58:23 -04:00
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-10-13 15:58:23 -04:00
@@ -5033,7 +5033,6 @@
  ahc_linux_exit(void)
  {
  	struct ahc_softc *ahc;
-	u_long l;

  	/*
  	 * Shutdown DV threads before going into the SCSI mid-layer.
@@ -5041,12 +5040,10 @@
  	 * kernel so that waiting for our DV threads to exit leads
  	 * to deadlock.
  	 */
-	ahc_list_lock(&l);
  	TAILQ_FOREACH(ahc, &ahc_tailq, links) {

  		ahc_linux_kill_dv_thread(ahc);
  	}
-	ahc_list_unlock(&l);

  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
  	/*
diff -Nru a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2004-10-13 15:58:23 -04:00
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2004-10-13 15:58:23 -04:00
@@ -160,12 +160,14 @@
  	if (ahc != NULL) {
  		u_long s;

+		TAILQ_REMOVE(&ahc_tailq, ahc, links);
+		ahc_list_unlock(&l);
  		ahc_lock(ahc, &s);
  		ahc_intr_enable(ahc, FALSE);
  		ahc_unlock(ahc, &s);
  		ahc_free(ahc);
-	}
-	ahc_list_unlock(&l);
+	} else
+		ahc_list_unlock(&l);
  }
  #endif /* !LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0) */


