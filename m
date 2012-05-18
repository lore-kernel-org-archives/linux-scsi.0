From: michaelc@cs.wisc.edu
Subject: [PATCH 1/4] SCSI: add new SDEV_TRANSPORT_OFFLINE state
Date: Thu, 17 May 2012 23:56:56 -0500
Message-ID: <1337317019-12001-2-git-send-email-michaelc@cs.wisc.edu>
References: <1337317019-12001-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab2ERE5I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 May 2012 00:57:08 -0400
In-Reply-To: <1337317019-12001-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds a new state SDEV_TRANSPORT_OFFLINE. It will
be used by transport classes to offline devices for cases like
when the fast_io_fail/recovery_tmo fires. In those cases we
want all IO to fail, and we have not yet escalated to dev_loss_tmo
behavior where we are removing the devices.

Currently to handle this state, transport classes are setting
the scsi_device's state to running, setting their internal
session/port structs state to something that indicates failed,
and then failing IO from some transport check in the queuecommand.

The reason for the new value is so that users can distinguish
between a device failure that is a result of a transport problem
vs the wide range of errors that devices get offlined for
when a scsi command times out and we offline the devices there.
It also fixes the confusion as to why the transport class is
failing IO, but has set the device state from blocked to running.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_lib.c    |    8 +++++++-
 drivers/scsi/scsi_sysfs.c  |    1 +
 include/scsi/scsi_device.h |    2 ++
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index dbe4392..7a3bb74 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1173,6 +1173,7 @@ int scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 	if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
 		switch (sdev->sdev_state) {
 		case SDEV_OFFLINE:
+		case SDEV_TRANSPORT_OFFLINE:
 			/*
 			 * If the device is offline we refuse to process any
 			 * commands.  The device must be brought online
@@ -2076,10 +2077,11 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 			
 	case SDEV_RUNNING:
 		switch (oldstate) {
-		case SDEV_CREATED:
 		case SDEV_OFFLINE:
+		case SDEV_TRANSPORT_OFFLINE:
 		case SDEV_QUIESCE:
 		case SDEV_BLOCK:
+		case SDEV_CREATED:
 			break;
 		default:
 			goto illegal;
@@ -2090,6 +2092,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		switch (oldstate) {
 		case SDEV_RUNNING:
 		case SDEV_OFFLINE:
+		case SDEV_TRANSPORT_OFFLINE:
 			break;
 		default:
 			goto illegal;
@@ -2097,6 +2100,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		break;
 
 	case SDEV_OFFLINE:
+	case SDEV_TRANSPORT_OFFLINE:
 		switch (oldstate) {
 		case SDEV_CREATED:
 		case SDEV_RUNNING:
@@ -2133,6 +2137,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_RUNNING:
 		case SDEV_QUIESCE:
 		case SDEV_OFFLINE:
+		case SDEV_TRANSPORT_OFFLINE:
 		case SDEV_BLOCK:
 			break;
 		default:
@@ -2145,6 +2150,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_CREATED:
 		case SDEV_RUNNING:
 		case SDEV_OFFLINE:
+		case SDEV_TRANSPORT_OFFLINE:
 		case SDEV_CANCEL:
 			break;
 		default:
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 04c2a27..5747478 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -35,6 +35,7 @@ static const struct {
 	{ SDEV_DEL, "deleted" },
 	{ SDEV_QUIESCE, "quiesce" },
 	{ SDEV_OFFLINE,	"offline" },
+	{ SDEV_TRANSPORT_OFFLINE, "transport-offline" },
 	{ SDEV_BLOCK,	"blocked" },
 	{ SDEV_CREATED_BLOCK, "created-blocked" },
 };
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6efb2e1..4acc1c3 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -42,6 +42,7 @@ enum scsi_device_state {
 				 * originate in the mid-layer) */
 	SDEV_OFFLINE,		/* Device offlined (by error handling or
 				 * user request */
+	SDEV_TRANSPORT_OFFLINE,	/* Offlined by transport class error handler */
 	SDEV_BLOCK,		/* Device blocked by scsi lld.  No
 				 * scsi commands from user or midlayer
 				 * should be issued to the scsi
@@ -420,6 +421,7 @@ static inline unsigned int sdev_id(struct scsi_device *sdev)
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return (sdev->sdev_state != SDEV_OFFLINE &&
+		sdev->sdev_state != SDEV_TRANSPORT_OFFLINE &&
 		sdev->sdev_state != SDEV_DEL);
 }
 static inline int scsi_device_blocked(struct scsi_device *sdev)
-- 
1.7.7.6

