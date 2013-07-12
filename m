From: Cosmin Stanescu <cosmin90stanescu@gmail.com>
Subject: [PATCH] ic7xxx_osm: use kzalloc instead of kmalloc + memset
Date: Fri, 12 Jul 2013 10:17:05 +0300
Message-ID: <1373613425-30725-1-git-send-email-cosmin90stanescu@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.de
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Cosmin Stanescu <cosmin90stanescu@gmail.com>
List-Id: linux-scsi@vger.kernel.org

found using coccinelle.

Signed-off-by: Cosmin Stanescu <cosmin90stanescu@gmail.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index c0c6258..7167cfe 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1223,10 +1223,9 @@ ahc_platform_alloc(struct ahc_softc *ahc, void *platform_arg)
 {
 
 	ahc->platform_data =
-	    kmalloc(sizeof(struct ahc_platform_data), GFP_ATOMIC);
+	    kzalloc(sizeof(struct ahc_platform_data), GFP_ATOMIC);
 	if (ahc->platform_data == NULL)
 		return (ENOMEM);
-	memset(ahc->platform_data, 0, sizeof(struct ahc_platform_data));
 	ahc->platform_data->irq = AHC_LINUX_NOIRQ;
 	ahc_lockinit(ahc);
 	ahc->seltime = (aic7xxx_seltime & 0x3) << 4;
-- 
1.7.10.4
