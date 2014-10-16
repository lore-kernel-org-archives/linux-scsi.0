From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] aic7xxx: replace kmalloc/memset by kzalloc
Date: Thu, 16 Oct 2014 21:14:38 +0200
Message-ID: <1413486878-375-1-git-send-email-michael.opdenacker@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.de, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, julia.lawall@lip6.fr, Michael Opdenacker <michael.opdenacker@free-electrons.com>
List-Id: linux-scsi@vger.kernel.org

This replaces kmalloc + memset by a call to kzalloc.

This also fixes one checkpatch.pl issue in the process.

This improvement was suggested by "make coccicheck"

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c |  3 +--
 drivers/scsi/aic7xxx/aic79xx_osm.c  |  3 +--
 drivers/scsi/aic7xxx/aic7xxx_core.c | 10 ++++------
 drivers/scsi/aic7xxx/aic7xxx_osm.c  |  3 +--
 4 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 0bcacf71aef8..9ce383c884c0 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -10437,14 +10437,13 @@ ahd_handle_en_lun(struct ahd_softc *ahd, struct cam_sim *sim, union ccb *ccb)
 				return;
 			}
 		}
-		lstate = kmalloc(sizeof(*lstate), GFP_ATOMIC);
+		lstate = kzalloc(sizeof(*lstate), GFP_ATOMIC);
 		if (lstate == NULL) {
 			xpt_print_path(ccb->ccb_h.path);
 			printk("Couldn't allocate lstate\n");
 			ccb->ccb_h.status = CAM_RESRC_UNAVAIL;
 			return;
 		}
-		memset(lstate, 0, sizeof(*lstate));
 		status = xpt_create_path(&lstate->path, /*periph*/NULL,
 					 xpt_path_path_id(ccb->ccb_h.path),
 					 xpt_path_target_id(ccb->ccb_h.path),
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index ed333669a7dc..67a01e804195 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1325,10 +1325,9 @@ int
 ahd_platform_alloc(struct ahd_softc *ahd, void *platform_arg)
 {
 	ahd->platform_data =
-	    kmalloc(sizeof(struct ahd_platform_data), GFP_ATOMIC);
+	    kzalloc(sizeof(struct ahd_platform_data), GFP_ATOMIC);
 	if (ahd->platform_data == NULL)
 		return (ENOMEM);
-	memset(ahd->platform_data, 0, sizeof(struct ahd_platform_data));
 	ahd->platform_data->irq = AHD_LINUX_NOIRQ;
 	ahd_lockinit(ahd);
 	ahd->seltime = (aic79xx_seltime & 0x3) << 4;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 10172a3af1b9..c4829d84b335 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -4464,10 +4464,9 @@ ahc_softc_init(struct ahc_softc *ahc)
 	ahc->pause = ahc->unpause | PAUSE; 
 	/* XXX The shared scb data stuff should be deprecated */
 	if (ahc->scb_data == NULL) {
-		ahc->scb_data = kmalloc(sizeof(*ahc->scb_data), GFP_ATOMIC);
+		ahc->scb_data = kzalloc(sizeof(*ahc->scb_data), GFP_ATOMIC);
 		if (ahc->scb_data == NULL)
 			return (ENOMEM);
-		memset(ahc->scb_data, 0, sizeof(*ahc->scb_data));
 	}
 
 	return (0);
@@ -4780,10 +4779,10 @@ ahc_init_scbdata(struct ahc_softc *ahc)
 	SLIST_INIT(&scb_data->sg_maps);
 
 	/* Allocate SCB resources */
-	scb_data->scbarray = kmalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC, GFP_ATOMIC);
+	scb_data->scbarray = kzalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC,
+				GFP_ATOMIC);
 	if (scb_data->scbarray == NULL)
 		return (ENOMEM);
-	memset(scb_data->scbarray, 0, sizeof(struct scb) * AHC_SCB_MAX_ALLOC);
 
 	/* Determine the number of hardware SCBs and initialize them */
 
@@ -7558,14 +7557,13 @@ ahc_handle_en_lun(struct ahc_softc *ahc, struct cam_sim *sim, union ccb *ccb)
 				return;
 			}
 		}
-		lstate = kmalloc(sizeof(*lstate), GFP_ATOMIC);
+		lstate = kzalloc(sizeof(*lstate), GFP_ATOMIC);
 		if (lstate == NULL) {
 			xpt_print_path(ccb->ccb_h.path);
 			printk("Couldn't allocate lstate\n");
 			ccb->ccb_h.status = CAM_RESRC_UNAVAIL;
 			return;
 		}
-		memset(lstate, 0, sizeof(*lstate));
 		status = xpt_create_path(&lstate->path, /*periph*/NULL,
 					 xpt_path_path_id(ccb->ccb_h.path),
 					 xpt_path_target_id(ccb->ccb_h.path),
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index d2c9bf39033d..350701407ecd 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1213,10 +1213,9 @@ ahc_platform_alloc(struct ahc_softc *ahc, void *platform_arg)
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
