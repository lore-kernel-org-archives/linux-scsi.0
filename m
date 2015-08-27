From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/23] scsi_dh_alua: improved logging
Date: Thu, 27 Aug 2015 14:41:01 +0200
Message-ID: <1440679281-13234-4-git-send-email-hare@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbbH0MlZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 08:41:25 -0400
In-Reply-To: <1440679281-13234-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Issue different logging messages if ALUA is not supported
or the TPGS setting is invalid.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index f15b977..a20c8bf 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -310,12 +310,18 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
 		sdev_printk(KERN_INFO, sdev, "%s: supports implicit TPGS\n",
 			    ALUA_DH_NAME);
 		break;
-	default:
-		h->tpgs = TPGS_MODE_NONE;
+	case TPGS_MODE_NONE:
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
1.8.5.6

