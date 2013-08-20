From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/7] Avoid re-enabling I/O after the transport became offline
Date: Tue, 20 Aug 2013 14:08:06 +0200
Message-ID: <52135C26.3060700@acm.org>
References: <52135B99.2000102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:55146 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3HTMII (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2013 08:08:08 -0400
In-Reply-To: <52135B99.2000102@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

Functions like sd_shutdown() use scsi_execute_req() and hence set
the REQ_PREEMPT flag. Requests for which this flag is set are
passed to the LLD queuecommand callback for devices that are in the
state SDEV_CANCEL. This means that the scsi_device_set_state(sdev,
SDEV_CANCEL) call in __scsi_remove_device() will reenable I/O
for offline devices.

Avoid this by introducing a new SCSI device state SDEV_CANCEL_OFFLINE.
This state is reached once deleting an offline device starts. Allow
the SDEV_{TRANSPORT_,}OFFLINE to SDEV_CANCEL_OFFLINE and
SDEV_CANCEL_OFFLINE to SDEV_DEL transitions. Disallow the
SDEV_{TRANSPORT_,}OFFLINE to SDEV_CANCEL transitions.

Note: this patch does not affect Fibre Channel LLD drivers since
these drivers invoke fc_remote_port_chkready() before submitting a
SCSI request to the HBA. That function already prevents commands to
be submitted to the HBA for SCSI devices in state SDEV_CANCEL if
the transport is offline.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>
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
index 7e50061..9a5cde9 100644
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
@@ -985,7 +986,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	struct device *dev = &sdev->sdev_gendev;
 
 	if (sdev->is_visible) {
-		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
+		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0 &&
+		    scsi_device_set_state(sdev, SDEV_CANCEL_OFFLINE) != 0)
 			return;
 
 		bsg_unregister_queue(sdev->request_queue);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 69540bf..f0aad47 100644
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
@@ -443,6 +445,7 @@ static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return (sdev->sdev_state != SDEV_OFFLINE &&
 		sdev->sdev_state != SDEV_TRANSPORT_OFFLINE &&
+		sdev->sdev_state != SDEV_CANCEL_OFFLINE &&
 		sdev->sdev_state != SDEV_DEL);
 }
 static inline int scsi_device_blocked(struct scsi_device *sdev)
@@ -458,6 +461,7 @@ static inline int scsi_device_created(struct scsi_device *sdev)
 static inline int scsi_device_being_removed(struct scsi_device *sdev)
 {
 	return sdev->sdev_state == SDEV_CANCEL ||
+		sdev->sdev_state == SDEV_CANCEL_OFFLINE ||
 		sdev->sdev_state == SDEV_DEL;
 }
 
-- 
1.7.10.4

