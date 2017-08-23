From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 03/19] Suppress gcc 7 fall-through warnings reported with W=1
Date: Wed, 23 Aug 2017 14:39:53 -0700
Message-ID: <20170823214009.15015-4-bart.vanassche@wdc.com>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:22687 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdHWVlG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 17:41:06 -0400
In-Reply-To: <20170823214009.15015-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

The conclusion of a recent discussion about the new warnings
reported by gcc 7 is that the new warnings reported when building
with W=1 should be suppressed. However, gcc 7 still warns about
fall-through in switch statements when building with W=1. Suppress
these warnings by annotating the SCSI core properly.

See also Linus Torvalds, Lots of new warnings with gcc-7.1.1, 11
July 2017 (https://www.mail-archive.com/linux-media@vger.kernel.org/msg115428.html).

References: commit bd664f6b3e37 ("disable new gcc-7.1.1 warnings for now")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_error.c | 8 +++++++-
 drivers/scsi/scsi_ioctl.c | 4 +++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ea9f40e51f68..01b2d2055edf 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -552,6 +552,7 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
 			set_host_byte(scmd, DID_ALLOC_FAILURE);
 			return SUCCESS;
 		}
+		/* FALLTHROUGH */
 	case COPY_ABORTED:
 	case VOLUME_OVERFLOW:
 	case MISCOMPARE:
@@ -573,6 +574,7 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
 			return ADD_TO_MLQUEUE;
 		else
 			set_host_byte(scmd, DID_TARGET_FAILURE);
+		/* FALLTHROUGH */
 
 	case ILLEGAL_REQUEST:
 		if (sshdr.asc == 0x20 || /* Invalid command operation code */
@@ -683,6 +685,7 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 	switch (status_byte(scmd->result)) {
 	case GOOD:
 		scsi_handle_queue_ramp_up(scmd->device);
+		/* FALLTHROUGH */
 	case COMMAND_TERMINATED:
 		return SUCCESS;
 	case CHECK_CONDITION:
@@ -1734,6 +1737,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 			set_host_byte(scmd, DID_TIME_OUT);
 			return SUCCESS;
 		}
+		/* FALLTHROUGH */
 	case DID_NO_CONNECT:
 	case DID_BAD_TARGET:
 		/*
@@ -1819,6 +1823,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * the case of trying to send too many commands to a
 		 * tagged queueing device.
 		 */
+		/* FALLTHROUGH */
 	case BUSY:
 		/*
 		 * device can't talk to us at the moment.  Should only
@@ -1831,6 +1836,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		if (scmd->cmnd[0] == REPORT_LUNS)
 			scmd->device->sdev_target->expecting_lun_change = 0;
 		scsi_handle_queue_ramp_up(scmd->device);
+		/* FALLTHROUGH */
 	case COMMAND_TERMINATED:
 		return SUCCESS;
 	case TASK_ABORTED:
@@ -2320,8 +2326,8 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 		rtn = scsi_try_host_reset(scmd);
 		if (rtn == SUCCESS)
 			break;
-	default:
 		/* FALLTHROUGH */
+	default:
 		rtn = FAILED;
 		break;
 	}
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index b6bf3f29a12a..0a875491f5a7 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -116,13 +116,15 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 		case NOT_READY:	/* This happens if there is no disc in drive */
 			if (sdev->removable)
 				break;
+			/* FALLTHROUGH */
 		case UNIT_ATTENTION:
 			if (sdev->removable) {
 				sdev->changed = 1;
 				result = 0;	/* This is no longer considered an error */
 				break;
 			}
-		default:	/* Fall through for non-removable media */
+			/* FALLTHROUGH -- for non-removable media */
+		default:
 			sdev_printk(KERN_INFO, sdev,
 				    "ioctl_internal_command return code = %x\n",
 				    result);
-- 
2.14.0
