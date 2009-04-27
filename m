From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC][PATCH] limit state change to SDEV_BLOCK devices in scsi_internal_device_unblock
Date: Mon, 27 Apr 2009 13:09:57 -0400
Message-ID: <49F5E6E5.20904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47183 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbZD0RJq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Apr 2009 13:09:46 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n3RH9k3M000735
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 13:09:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, mbarrow@redhat.com

Hi,

This is a patch to fix SCSI timeout error recovery issue which
I posted about one week ago.

  [RFC] SCSI timeout error recovery issue
  http://marc.info/?l=linux-scsi&m=124042136915970&w=2

scsi timeout on two or more devices may cause extremely long execution
time for user applications because SDEV_OFFLINE state is changed to
SDEV_RUNNING state during scsi error recovery procedures triggered by
a bus reset or a host reset of LLD, and scsi timeout can happens on
the same devices many times.

This happens because scsi_internal_device_unblock() changes device's state
to SDEV_RUNNING even if a device in other states than SDEV_BLOCK, but
scsi_internal_device_block() is a pair with scsi_internal_device_unblock()
and only devices in SDEV_BLOCK state are needed to be changed. This patch
adds a check of the current device state so that state change and queue
activation is not executed for devices in SDEV_BLOCK state.

This patch is based on the idea that devices in SDEV_OFFLINE state need to
stay in SDEV_OFFLINE because SDEV_OFFLINE state is done by:

 - All recovery procedures, bus reset and host reset, has already failed
   for devices in SDEV_OFFLINE state.
   (There is no (or rare?) chance to be recovered.)

 - A user has changed the device's state to SDEV_OFFLINE intentionally
   by an interface such as sysfs.
   (A user needs to enable devices in SDEV_OFFLINE state before using
    them again.)

I appreciate any comments and suggestions on this patch.

Regards,
---
Takahiro Yasui
Hitachi Computer Products (America), Inc.


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/scsi/scsi_lib.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.29/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6.29/drivers/scsi/scsi_lib.c
@@ -2633,9 +2633,12 @@ scsi_internal_device_unblock(struct scsi
 	unsigned long flags;
 	
 	/* 
-	 * Try to transition the scsi device to SDEV_RUNNING
-	 * and goose the device queue if successful.  
+	 * Try to transition the scsi device to SDEV_RUNNING if it is
+	 * SDEV_BLOCK and goose the device queue if successful.
 	 */
+	if (sdev->sdev_state != SDEV_BLOCK)
+		return 0;
+
 	err = scsi_device_set_state(sdev, SDEV_RUNNING);
 	if (err) {
 		err = scsi_device_set_state(sdev, SDEV_CREATED);




