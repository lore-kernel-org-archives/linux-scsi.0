From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v14 5/6] Avoid re-enabling I/O after the transport became
 offline
Date: Fri, 05 Jul 2013 15:27:59 +0200
Message-ID: <51D6C9DF.5000807@acm.org>
References: <51D6C885.9050000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:33236 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384Ab3GEN2A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jul 2013 09:28:00 -0400
In-Reply-To: <51D6C885.9050000@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, David Milburn <dmilburn@redhat.com>

Disallow the SDEV_TRANSPORT_OFFLINE to SDEV_CANCEL transition such
that no I/O is sent to devices for which the transport is offline.
Notes:
- Functions like sd_shutdown() use scsi_execute_req() and hence
  set the REQ_PREEMPT flag. Such requests are passed to the LLD
  queuecommand callback in the SDEV_CANCEL state.
- This patch does not affect Fibre Channel LLD drivers since these
  drivers invoke fc_remote_port_chkready() before submitting a SCSI
  request to the HBA. That prevents a timeout to occur in state
  SDEV_CANCEL if the transport is offline.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c    |   12 +++++++++++-
 drivers/scsi/scsi_sysfs.c  |    4 +++-
 include/scsi/scsi_device.h |    4 ++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9eb05a7..362855d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1232,6 +1232,7 @@ int scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 		switch (sdev->sdev_state) {
 		case SDEV_OFFLINE:
 		case SDEV_TRANSPORT_OFFLINE:
+		case SDEV_CANCEL_OFFLINE:
 			/*
 			 * If the device is offline we refuse to process any
 			 * commands.  The device must be brought online
@@ -2178,9 +2179,17 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_CREATED:
 		case SDEV_RUNNING:
 		case SDEV_QUIESCE:
+		case SDEV_BLOCK:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
+
+	case SDEV_CANCEL_OFFLINE:
+		switch (oldstate) {
 		case SDEV_OFFLINE:
 		case SDEV_TRANSPORT_OFFLINE:
-		case SDEV_BLOCK:
 			break;
 		default:
 			goto illegal;
@@ -2194,6 +2203,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_OFFLINE:
 		case SDEV_TRANSPORT_OFFLINE:
 		case SDEV_CANCEL:
+		case SDEV_CANCEL_OFFLINE:
 		case SDEV_CREATED_BLOCK:
 			break;
 		default:
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 931a7d9..f6ce38e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -32,6 +32,7 @@ static const struct {
 	{ SDEV_CREATED, "created" },
 	{ SDEV_RUNNING, "running" },
 	{ SDEV_CANCEL, "cancel" },
+	{ SDEV_CANCEL_OFFLINE, "cancel-offline" },
 	{ SDEV_DEL, "deleted" },
 	{ SDEV_QUIESCE, "quiesce" },
 	{ SDEV_OFFLINE,	"offline" },
@@ -955,7 +956,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	struct device *dev = &sdev->sdev_gendev;
 
 	if (sdev->is_visible) {
-		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
+		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0 &&
+		    scsi_device_set_state(sdev, SDEV_CANCEL_OFFLINE) != 0)
 			return;
 
 		bsg_unregister_queue(sdev->request_queue);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index fead252..4ecf7ed1 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -35,6 +35,8 @@ enum scsi_device_state {
 				 * All commands allowed */
 	SDEV_CANCEL,		/* beginning to delete device
 				 * Only error handler commands allowed */
+	SDEV_CANCEL_OFFLINE,	/* beginning to delete offline device
+				 * No commands allowed */
 	SDEV_DEL,		/* device deleted 
 				 * no commands allowed */
 	SDEV_QUIESCE,		/* Device quiescent.  No block commands
@@ -442,6 +444,7 @@ static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return (sdev->sdev_state != SDEV_OFFLINE &&
 		sdev->sdev_state != SDEV_TRANSPORT_OFFLINE &&
+		sdev->sdev_state != SDEV_CANCEL_OFFLINE &&
 		sdev->sdev_state != SDEV_DEL);
 }
 static inline int scsi_device_blocked(struct scsi_device *sdev)
@@ -457,6 +460,7 @@ static inline int scsi_device_created(struct scsi_device *sdev)
 static inline int scsi_device_being_removed(struct scsi_device *sdev)
 {
 	return sdev->sdev_state == SDEV_CANCEL ||
+		sdev->sdev_state == SDEV_CANCEL_OFFLINE ||
 		sdev->sdev_state == SDEV_DEL;
 }
 
-- 
1.7.10.4

