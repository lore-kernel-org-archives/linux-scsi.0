From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH 2/2] [SCSI] aic7xxx: Cocci spatch "kzalloc-simple"
Date: Thu, 19 Sep 2013 23:45:46 +0200
Message-ID: <1379604510864-1348855396-2-diffsplit-thomas@m3y3r.de>
References: <1379604510863-816646221-0-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1379604510863-816646221-0-diffsplit-thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.de, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use kzalloc rather than kmalloc followed by memset with 0.
Found by coccinelle spatch "api/alloc/kzalloc-simple.cocci"

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1324,11 +1324,10 @@ ahd_linux_initialize_scsi_bus(struct ahd
 int
 ahd_platform_alloc(struct ahd_softc *ahd, void *platform_arg)
 {
-	ahd->platform_data =
-	    kmalloc(sizeof(struct ahd_platform_data), GFP_ATOMIC);
+	ahd->platform_data = kzalloc(sizeof(struct ahd_platform_data),
+				     GFP_ATOMIC);
 	if (ahd->platform_data == NULL)
 		return (ENOMEM);
-	memset(ahd->platform_data, 0, sizeof(struct ahd_platform_data));
 	ahd->platform_data->irq = AHD_LINUX_NOIRQ;
 	ahd_lockinit(ahd);
 	ahd->seltime = (aic79xx_seltime & 0x3) << 4;
diff -u -p a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1222,11 +1222,10 @@ int
 ahc_platform_alloc(struct ahc_softc *ahc, void *platform_arg)
 {
 
-	ahc->platform_data =
-	    kmalloc(sizeof(struct ahc_platform_data), GFP_ATOMIC);
+	ahc->platform_data = kzalloc(sizeof(struct ahc_platform_data),
+				     GFP_ATOMIC);
 	if (ahc->platform_data == NULL)
 		return (ENOMEM);
-	memset(ahc->platform_data, 0, sizeof(struct ahc_platform_data));
 	ahc->platform_data->irq = AHC_LINUX_NOIRQ;
 	ahc_lockinit(ahc);
 	ahc->seltime = (aic7xxx_seltime & 0x3) << 4;
