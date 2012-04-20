From: michaelc@cs.wisc.edu
Subject: [RFC 4/4] SCSI: send KOBJ_CHANGE when device is set to running
Date: Thu, 19 Apr 2012 20:08:56 -0500
Message-ID: <1334884136-3689-5-git-send-email-michaelc@cs.wisc.edu>
References: <1334884136-3689-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613Ab2DTBJL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Apr 2012 21:09:11 -0400
In-Reply-To: <1334884136-3689-1-git-send-email-michaelc@cs.wisc.edu>
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
udev see the KOBJ_CHANGE event and will reprobe the device and recreate a
/dev/disk/by-id link.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_lib.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1a67302..237932f 100644
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
+		sdev_evt_send_simple(sdev, 0, GFP_ATOMIC);
 	return 0;
 
  illegal:
-- 
1.7.7.6

