From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/16] scsi_dh_alua: Clarify logging message
Date: Fri, 31 Jan 2014 10:29:57 +0100
Message-ID: <1391160600-19652-14-git-send-email-hare@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbaAaJaL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jan 2014 04:30:11 -0500
In-Reply-To: <1391160600-19652-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

We should be diffentiating between an invalid TPGS setting
and unsupported.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 8ea35a9..7f03417 100644
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

