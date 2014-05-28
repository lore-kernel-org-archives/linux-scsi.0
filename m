From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] drivers/scsi/aic7xxx/aic7xxx_core.c: replace 3
 kmalloc/memset 0 by kzalloc
Date: Wed, 28 May 2014 21:09:14 +0200
Message-ID: <20140528210914.121efa2e35abf0c57cc44657@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:64892 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbaE1TJR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2014 15:09:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Hannes Reinecke <hare@suse.de>


Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

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
1.9.1

