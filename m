From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: [PATCH 3/4] scsi: aic7xxx: Use kzalloc instead of kmalloc/memset
Date: Wed, 28 Jan 2015 16:37:50 +0900
Message-ID: <20150128073750.GA13646@devel.8.8.4.4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.de
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 10172a3..7f34d25 100644
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
@@ -4780,10 +4779,9 @@ ahc_init_scbdata(struct ahc_softc *ahc)
 	SLIST_INIT(&scb_data->sg_maps);
 
 	/* Allocate SCB resources */
-	scb_data->scbarray = kmalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC, GFP_ATOMIC);
+	scb_data->scbarray = kzalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC, GFP_ATOMIC);
 	if (scb_data->scbarray == NULL)
 		return (ENOMEM);
-	memset(scb_data->scbarray, 0, sizeof(struct scb) * AHC_SCB_MAX_ALLOC);
 
 	/* Determine the number of hardware SCBs and initialize them */
 
@@ -7558,14 +7556,13 @@ ahc_handle_en_lun(struct ahc_softc *ahc, struct cam_sim *sim, union ccb *ccb)
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
-- 
1.7.1
