From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] scsi: Handle power-on reset unit attention
Date: Thu,  5 Jun 2014 09:26:43 +0200
Message-ID: <1401953203-103015-3-git-send-email-hare@suse.de>
References: <1401953203-103015-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbaFEH0r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2014 03:26:47 -0400
In-Reply-To: <1401953203-103015-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Robert Elliot <elliot@hp.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

As per SAM there is a status precedence, with any sense code 29/XX
taking second place just after an ACA ACTIVE status.
Additionally, each target might prefer to not queue any unit
attention conditions but just report one.
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
index 47a1ffc..65ed333 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -420,6 +420,12 @@ static void scsi_report_sense(struct scsi_device *sdev,
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
index 9f841df..ee158c1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2183,6 +2183,9 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 	case SDEV_EVT_LUN_CHANGE_REPORTED:
 		envp[idx++] = "SDEV_UA=REPORTED_LUNS_DATA_HAS_CHANGED";
 		break;
+	case SDEV_EVT_POWER_ON_RESET_OCCURRED:
+		envp[idx++] = "SDEV_UA=POWER_ON_RESET_OCCURRED";
+		break;
 	default:
 		/* do nothing */
 		break;
@@ -2286,6 +2289,7 @@ struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
 	case SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED:
 	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
 	case SDEV_EVT_LUN_CHANGE_REPORTED:
+	case SDEV_EVT_POWER_ON_RESET_OCCURRED:
 	default:
 		/* do nothing */
 		break;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 5853c91..7b9a886 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -57,9 +57,10 @@ enum scsi_device_event {
 	SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED,	/* 38 07  UA reported */
 	SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED,	/* 2A 01  UA reported */
 	SDEV_EVT_LUN_CHANGE_REPORTED,			/* 3F 0E  UA reported */
+	SDEV_EVT_POWER_ON_RESET_OCCURRED,		/* 29 00  UA reported */
 
 	SDEV_EVT_FIRST		= SDEV_EVT_MEDIA_CHANGE,
-	SDEV_EVT_LAST		= SDEV_EVT_LUN_CHANGE_REPORTED,
+	SDEV_EVT_LAST		= SDEV_EVT_POWER_ON_RESET_OCCURRED,
 
 	SDEV_EVT_MAXBITS	= SDEV_EVT_LAST + 1
 };
-- 
1.7.12.4

