From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] drivers/scsi/aic7xxx/aic79xx_core.c: replace
 kmalloc/memset 0 by kzalloc
Date: Wed, 28 May 2014 21:10:41 +0200
Message-ID: <20140528211041.7a56264dd29b704beb85fcd4@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:6082 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755079AbaE1TKn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2014 15:10:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Hannes Reinecke <hare@suse.de>


Cc: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 0bcacf7..9ce383c 100644
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
-- 
1.9.1

