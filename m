From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Add ALUA state change UA handling
Date: Mon,  6 Jul 2015 13:41:53 +0200
Message-ID: <1436182913-85904-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361AbbGFLl4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 07:41:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

Log the ALUA state change unit attention correctly with
the message log and emit an event to allow user-space
tools to react to it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_error.c  | 4 ++++
 drivers/scsi/scsi_lib.c    | 4 ++++
 include/scsi/scsi_device.h | 3 ++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 569957d..7fe9245 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -422,6 +422,10 @@ static void scsi_report_sense(struct scsi_device *sdev,
 			evt_type = SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED;
 			sdev_printk(KERN_WARNING, sdev,
 				    "Mode parameters changed");
+		} else if (sshdr->asc == 0x2a && sshdr->ascq == 0x06) {
+			evt_type = SDEV_EVT_ALUA_STATE_CHANGE_REPORTED;
+			sdev_printk(KERN_WARNING, sdev,
+				    "Asymmetric access state changed");
 		} else if (sshdr->asc == 0x2a && sshdr->ascq == 0x09) {
 			evt_type = SDEV_EVT_CAPACITY_CHANGE_REPORTED;
 			sdev_printk(KERN_WARNING, sdev,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b4ef3ff..9a63dc3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2712,6 +2712,9 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 	case SDEV_EVT_LUN_CHANGE_REPORTED:
 		envp[idx++] = "SDEV_UA=REPORTED_LUNS_DATA_HAS_CHANGED";
 		break;
+	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
+		envp[idx++] = "SDEV_UA=ASYMMETRIC_ACCESS_STATE_CHANGED";
+		break;
 	default:
 		/* do nothing */
 		break;
@@ -2815,6 +2818,7 @@ struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
 	case SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED:
 	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
 	case SDEV_EVT_LUN_CHANGE_REPORTED:
+	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
 	default:
 		/* do nothing */
 		break;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index b6b1dc4..fe89d7c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -57,9 +57,10 @@ enum scsi_device_event {
 	SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED,	/* 38 07  UA reported */
 	SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED,	/* 2A 01  UA reported */
 	SDEV_EVT_LUN_CHANGE_REPORTED,			/* 3F 0E  UA reported */
+	SDEV_EVT_ALUA_STATE_CHANGE_REPORTED,		/* 2A 06  UA reported */
 
 	SDEV_EVT_FIRST		= SDEV_EVT_MEDIA_CHANGE,
-	SDEV_EVT_LAST		= SDEV_EVT_LUN_CHANGE_REPORTED,
+	SDEV_EVT_LAST		= SDEV_EVT_ALUA_STATE_CHANGE_REPORTED,
 
 	SDEV_EVT_MAXBITS	= SDEV_EVT_LAST + 1
 };
-- 
1.8.5.2

