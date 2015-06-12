From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: Add ALUA state change UA handling
Date: Fri, 12 Jun 2015 12:55:10 -0400
Message-ID: <1434128110.22842.99.camel@localhost.localdomain>
References: <1434118333-100476-1-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbbFLQzM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2015 12:55:12 -0400
In-Reply-To: <1434118333-100476-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Nic Bellinger <nab@daterainc.com>

Looking at this closely, I didn't get the SDEV_UA text
right in my previous review comment, and I think that
additional enum values really ought to be added to the
end, after existing ones, and code that handles them
should follow suit.  So, here's an adjusted patch...

-Ewan

--------
[PATCH] scsi: Add ALUA state change UA handling

Log the ALUA state change unit attention correctly with
the message log and emit an event to allow user-space
tools to react to it.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c  |    4 ++++
 drivers/scsi/scsi_lib.c    |    4 ++++
 include/scsi/scsi_device.h |    3 ++-
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4cdaffc..bf7065c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -420,6 +420,10 @@ static void scsi_report_sense(struct scsi_device *sdev,
 			evt_type = SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED;
 			sdev_printk(KERN_WARNING, sdev,
 				    "Mode parameters changed");
+		} else if (sshdr->asc == 0x2a && sshdr->ascq == 0x06) {
+			evt_type = SDEV_EVT_ALUA_STATE_CHANGE_REPORTED;
+			sdev_printk(KERN_WARNING, sdev,
+				    "Asymmetic access state changed");
 		} else if (sshdr->asc == 0x2a && sshdr->ascq == 0x09) {
 			evt_type = SDEV_EVT_CAPACITY_CHANGE_REPORTED;
 			sdev_printk(KERN_WARNING, sdev,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6d5c0b8..62259eb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2693,6 +2693,9 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 	case SDEV_EVT_LUN_CHANGE_REPORTED:
 		envp[idx++] = "SDEV_UA=REPORTED_LUNS_DATA_HAS_CHANGED";
 		break;
+	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
+		envp[idx++] = "SDEV_UA=ASYMMETRIC_ACCESS_STATE_CHANGED";
+		break;
 	default:
 		/* do nothing */
 		break;
@@ -2796,6 +2799,7 @@ struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
 	case SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED:
 	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
 	case SDEV_EVT_LUN_CHANGE_REPORTED:
+	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
 	default:
 		/* do nothing */
 		break;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2e0281e..0c82aaa 100644
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
1.7.1



