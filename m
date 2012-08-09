From: vikas.chaudhary@qlogic.com
Subject: [PATCH] scsi_lib: Set the device state from transport-offline to running
Date: Thu,  9 Aug 2012 04:51:30 -0400
Message-ID: <1344502290-30332-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:17717 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750986Ab2HIJJk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Aug 2012 05:09:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

FC and iSCSI class set SCSI devices to transport-offline state after
fast_io_fail/replacement_timeout has fired, but after relogin, function
scsi_internal_device_unblock() is not setting scsi device state to running.
Due to this the devices even after being relogged in remain offline.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/scsi_lib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ffd7773..4ba3719 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2470,7 +2470,8 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
 	 * Try to transition the scsi device to SDEV_RUNNING or one of the
 	 * offlined states and goose the device queue if successful.
 	 */
-	if (sdev->sdev_state == SDEV_BLOCK)
+	if ((sdev->sdev_state == SDEV_BLOCK) ||
+	    (sdev->sdev_state == SDEV_TRANSPORT_OFFLINE))
 		sdev->sdev_state = new_state;
 	else if (sdev->sdev_state == SDEV_CREATED_BLOCK) {
 		if (new_state == SDEV_TRANSPORT_OFFLINE ||
-- 
1.7.8.GIT

