From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Handle power-on reset unit attention
Date: Tue, 17 Oct 2017 09:11:24 +0200
Message-ID: <1508224284-130390-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60454 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932521AbdJQHL0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Oct 2017 03:11:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

As per SAM there is a status precedence, with any sense code 29/XX
taking second place just after an ACA ACTIVE status.
Additionally, each target might prefer to not queue any unit
attention conditions, but just report one.
Due to the above this will be that one with the highest precedence.
This results in the sense code 29/XX effectively overwriting any
other unit attention.
Hence we should report the power-on reset to userland so that
it can take appropriate action.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c  | 6 ++++++
 drivers/scsi/scsi_lib.c    | 4 ++++
 include/scsi/scsi_device.h | 3 ++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 5722c2e..f49710a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -403,6 +403,12 @@ static void scsi_report_sense(struct scsi_device *sdev,
 				    "threshold.\n");
 		}
 
+		if (sshdr->asc == 0x29) {
+			evt_type = SDEV_EVT_POWER_ON_RESET_OCCURRED;
+			sdev_printk(KERN_WARNING, sdev,
+				    "Power-on or device reset occurred\n");
+		}
+
 		if (sshdr->asc == 0x2a && sshdr->ascq == 0x01) {
 			evt_type = SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED;
 			sdev_printk(KERN_WARNING, sdev,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c72b97a..e5fcfa8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2743,6 +2743,9 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
 		envp[idx++] = "SDEV_UA=ASYMMETRIC_ACCESS_STATE_CHANGED";
 		break;
+	case SDEV_EVT_POWER_ON_RESET_OCCURRED:
+		envp[idx++] = "SDEV_UA=POWER_ON_RESET_OCCURRED";
+		break;
 	default:
 		/* do nothing */
 		break;
@@ -2847,6 +2850,7 @@ struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
 	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
 	case SDEV_EVT_LUN_CHANGE_REPORTED:
 	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
+	case SDEV_EVT_POWER_ON_RESET_OCCURRED:
 	default:
 		/* do nothing */
 		break;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 82e93ee..d68985c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -64,9 +64,10 @@ enum scsi_device_event {
 	SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED,	/* 2A 01  UA reported */
 	SDEV_EVT_LUN_CHANGE_REPORTED,			/* 3F 0E  UA reported */
 	SDEV_EVT_ALUA_STATE_CHANGE_REPORTED,		/* 2A 06  UA reported */
+	SDEV_EVT_POWER_ON_RESET_OCCURRED,		/* 29 00  UA reported */
 
 	SDEV_EVT_FIRST		= SDEV_EVT_MEDIA_CHANGE,
-	SDEV_EVT_LAST		= SDEV_EVT_ALUA_STATE_CHANGE_REPORTED,
+	SDEV_EVT_LAST		= SDEV_EVT_POWER_ON_RESET_OCCURRED,
 
 	SDEV_EVT_MAXBITS	= SDEV_EVT_LAST + 1
 };
-- 
1.8.5.6
