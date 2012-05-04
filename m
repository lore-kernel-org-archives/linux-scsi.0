From: michaelc@cs.wisc.edu
Subject: [PATCH 4/4] SCSI: send KOBJ_CHANGE when device is set to running v2
Date: Fri,  4 May 2012 05:23:24 -0500
Message-ID: <1336127004-2358-5-git-send-email-michaelc@cs.wisc.edu>
References: <1336127004-2358-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab2EDKXt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2012 06:23:49 -0400
In-Reply-To: <1336127004-2358-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If a device goes offline while the device is opened then closed
while it is still offline, udev will remove the /dev/disk/by-id
link. If the device comes back and is set to running, userspace
is not notified, and the by-id link will not get remade.

This patch has scsi-ml send a KOBJ_CHANGE event so tools like udev
will know that it can being to use the device again. With this patch
udev see the KOBJ_CHANGE event and will reprobe the device and recreate
a /dev/disk/by-id link.

v2
- Added SDEV_EVT_STATE_RUNNING evt type.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_lib.c    |    9 +++++++++
 include/scsi/scsi_device.h |    2 ++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c61ab0c..ed5bcb2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2061,6 +2061,7 @@ int
 scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 {
 	enum scsi_device_state oldstate = sdev->sdev_state;
+	int change_evt = 0;
 
 	if (state == oldstate)
 		return 0;
@@ -2079,6 +2080,11 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		switch (oldstate) {
 		case SDEV_OFFLINE:
 		case SDEV_TRANSPORT_OFFLINE:
+			/*
+			 * Notify userspace we can accept IO by sending
+			 * change event.
+			 */
+			change_evt = 1;
 		case SDEV_QUIESCE:
 		case SDEV_BLOCK:
 		case SDEV_CREATED:
@@ -2160,6 +2166,8 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 
 	}
 	sdev->sdev_state = state;
+	if (change_evt)
+		sdev_evt_send_simple(sdev, SDEV_EVT_STATE_RUNNING, GFP_ATOMIC);
 	return 0;
 
  illegal:
@@ -2283,6 +2291,7 @@ struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
 	/* evt_type-specific initialization, if any */
 	switch (evt_type) {
 	case SDEV_EVT_MEDIA_CHANGE:
+	case SDEV_EVT_STATE_RUNNING:
 	default:
 		/* do nothing */
 		break;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 5ff8180..0759433 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -52,6 +52,8 @@ enum scsi_device_state {
 
 enum scsi_device_event {
 	SDEV_EVT_MEDIA_CHANGE	= 1,	/* media has changed */
+	SDEV_EVT_STATE_RUNNING	= 2,	/* state has gone from offline to
+					 * running */
 
 	SDEV_EVT_LAST		= SDEV_EVT_MEDIA_CHANGE,
 	SDEV_EVT_MAXBITS	= SDEV_EVT_LAST + 1
-- 
1.7.7.6

