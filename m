From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/16] scsi_dh_alua: Clarify logging message
Date: Fri, 20 Dec 2013 13:13:38 +0100
Message-ID: <1387541621-54967-14-git-send-email-hare@suse.de>
References: <1387541621-54967-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882Ab3LTMNp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 07:13:45 -0500
In-Reply-To: <1387541621-54967-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, Hannes Reinecke <hare@suse.de>

We should be diffentiating between an invalid TPGS setting
and unsupported.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index dc77ce4..baaae3f 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -347,12 +347,18 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
 		sdev_printk(KERN_INFO, sdev, "%s: supports implicit TPGS\n",
 			    ALUA_DH_NAME);
 		break;
-	default:
-		h->tpgs = TPGS_MODE_NONE;
+	case 0:
 		sdev_printk(KERN_INFO, sdev, "%s: not supported\n",
 			    ALUA_DH_NAME);
 		err = SCSI_DH_DEV_UNSUPP;
 		break;
+	default:
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: unsupported TPGS setting %d\n",
+			    ALUA_DH_NAME, h->tpgs);
+		h->tpgs = TPGS_MODE_NONE;
+		err = SCSI_DH_DEV_UNSUPP;
+		break;
 	}
 
 	return err;
-- 
1.7.12.4

