From: Liviu Gheorghisan <livghs@gmail.com>
Subject: [PATCH] scsi: use kzalloc instead of kmalloc/memset
Date: Tue, 27 Jan 2015 23:14:12 +0200
Message-ID: <1422393252-9744-1-git-send-email-livghs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.de, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Liviu Gheorghisan <livghs@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hint given by Coccinelle.

Signed-off-by: Liviu Gheorghisan <livghs@gmail.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 8836011..a2f2c77 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1214,10 +1214,9 @@ ahc_platform_alloc(struct ahc_softc *ahc, void *platform_arg)
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
1.9.1
