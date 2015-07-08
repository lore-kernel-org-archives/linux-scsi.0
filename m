From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] scsi: rescan device if an invalid capacity had been reported
Date: Wed,  8 Jul 2015 09:41:07 +0200
Message-ID: <1436341268-91432-3-git-send-email-hare@suse.de>
References: <1436341268-91432-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934296AbbGHHlM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 03:41:12 -0400
In-Reply-To: <1436341268-91432-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Bart van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Device paths in ALUA state 'standby' do not necessarily support
the READ_CAPACITY command. This patch adds a new flag 'invalid_capacity'
to the scsi device, and rescans the device if an ALUA state
change occurred.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c    |  4 ++++
 drivers/scsi/sd.c          | 19 ++++++++++++++-----
 include/scsi/scsi_device.h |  1 +
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c005e42..d4245f0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2701,6 +2701,7 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 		envp[idx++] = "SDEV_UA=INQUIRY_DATA_HAS_CHANGED";
 		break;
 	case SDEV_EVT_CAPACITY_CHANGE_REPORTED:
+		scsi_rescan_device(&sdev->sdev_gendev);
 		envp[idx++] = "SDEV_UA=CAPACITY_DATA_HAS_CHANGED";
 		break;
 	case SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED:
@@ -2713,6 +2714,9 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 		envp[idx++] = "SDEV_UA=REPORTED_LUNS_DATA_HAS_CHANGED";
 		break;
 	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
+		if (sdev->invalid_capacity)
+			scsi_rescan_device(&sdev->sdev_gendev);
+
 		envp[idx++] = "SDEV_UA=ASYMMETRIC_ACCESS_STATE_CHANGED";
 		break;
 	default:
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 03fdfa9..7c0bdaa 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1983,14 +1983,18 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 					continue;
 			if (sense_valid &&
 			    sshdr.sense_key == NOT_READY &&
-			    sshdr.asc == 0x04 && sshdr.ascq == 0x0a)
+			    sshdr.asc == 0x04 && sshdr.ascq == 0x0a) {
 				/* Target port in transition */
+				sdp->invalid_capacity = 1;
 				return 0;
+			}
 			if (sense_valid &&
 			    sshdr.sense_key == NOT_READY &&
-			    sshdr.asc == 0x04 && sshdr.ascq == 0x0b)
+			    sshdr.asc == 0x04 && sshdr.ascq == 0x0b) {
 				/* Target port in standy state */
+				sdp->invalid_capacity = 1;
 				return 0;
+			}
 		}
 		retries--;
 
@@ -2075,14 +2079,18 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 					continue;
 			if (sense_valid &&
 			    sshdr.sense_key == NOT_READY &&
-			    sshdr.asc == 0x04 && sshdr.ascq == 0x0a)
+			    sshdr.asc == 0x04 && sshdr.ascq == 0x0a) {
 				/* Target port in transition */
+				sdp->invalid_capacity = 1;
 				return 0;
+			}
 			if (sense_valid &&
 			    sshdr.sense_key == NOT_READY &&
-			    sshdr.asc == 0x04 && sshdr.ascq == 0x0b)
+			    sshdr.asc == 0x04 && sshdr.ascq == 0x0b) {
 				/* Target port in standy state */
+				sdp->invalid_capacity = 1;
 				return 0;
+			}
 		}
 		retries--;
 
@@ -2199,7 +2207,8 @@ got_data:
 			  "assuming 512.\n");
 		if (!sdkp->physical_block_size)
 			sdkp->physical_block_size = sector_size;
-	}
+	} else
+		sdp->invalid_capacity = 0;
 
 	if (sector_size != 512 &&
 	    sector_size != 1024 &&
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 50c2a36..99bde5a 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -175,6 +175,7 @@ struct scsi_device {
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
 	unsigned broken_fua:1;		/* Don't set FUA bit */
 	unsigned lun_in_cdb:1;		/* Store LUN bits in CDB[1] */
+	unsigned invalid_capacity:1;	/* READ_CAPACITY not supported */
 
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
 
-- 
1.8.5.2

