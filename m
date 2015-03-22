From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND] aic7xxx: replace kmalloc/memset by kzalloc
Date: Sun, 22 Mar 2015 17:31:31 +0100
Message-ID: <1427041891-2694-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <94D0CD8314A33A4D9D801C0FE68B40295930E577@G4W3296.americas.hpqcorp.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295930E577@G4W3296.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.de, JBottomley@parallels.com
Cc: joe@perches.com, Elliott@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Opdenacker <michael.opdenacker@free-electrons.com>
List-Id: linux-scsi@vger.kernel.org

This replaces kmalloc + memset by a call to kzalloc
(or kcalloc when appropriate, which zeroes memory too)

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
index 97f2accd3dbb..109e2c99e6c1 100644
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
index d5c7b193d8d3..ce96a0be3282 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1326,10 +1326,9 @@ int
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
index 10172a3af1b9..2d1c86b9d7c9 100644
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
+	scb_data->scbarray = kcalloc(AHC_SCB_MAX_ALLOC, sizeof(struct scb),
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
index 88360116dbcb..a2f2c774cd6b 100644
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
2.1.0
