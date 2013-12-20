From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/16] scsi_dh_alua: multipath failover fails with error 15
Date: Fri, 20 Dec 2013 13:13:36 +0100
Message-ID: <1387541621-54967-12-git-send-email-hare@suse.de>
References: <1387541621-54967-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880Ab3LTMNp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 07:13:45 -0500
In-Reply-To: <1387541621-54967-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, Hannes Reinecke <hare@suse.de>

When a path is already optimized multipath failover will fail
with the message
Could not failover device X:Y: Handler scsi_dh_alua Error 15

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 51f4a31..dc77ce4 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -851,6 +851,8 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		return SCSI_DH_RETRY;
 	}
 	switch (pg->state) {
+	case TPGS_STATE_OPTIMIZED:
+		return SCSI_DH_OK;
 	case TPGS_STATE_NONOPTIMIZED:
 		if ((pg->flags & ALUA_OPTIMIZE_STPG) &&
 		    (!pg->pref) &&
@@ -865,10 +867,11 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		break;
 	case TPGS_STATE_TRANSITIONING:
 		return SCSI_DH_RETRY;
-		break;
 	default:
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: stpg failed, unhandled TPGS state %d",
+			    ALUA_DH_NAME, pg->state);
 		return SCSI_DH_NOSYS;
-		break;
 	}
 	/* Set state to transitioning */
 	pg->state = TPGS_STATE_TRANSITIONING;
-- 
1.7.12.4

