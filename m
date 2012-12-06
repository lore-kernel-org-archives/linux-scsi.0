From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v7 5/9] Disallow changing the device state via sysfs into
 "deleted"
Date: Thu, 06 Dec 2012 16:56:54 +0100
Message-ID: <50C0C046.2060903@acm.org>
References: <50C0BEEE.4040907@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:50984 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab2LFP44 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2012 10:56:56 -0500
In-Reply-To: <50C0BEEE.4040907@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Changing the state of a SCSI device via sysfs into "cancel" or
"deleted" prevents scsi_remove_host() to remove these devices.
Hence do not allow this.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 4348f12..b319c20 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -591,13 +591,15 @@ sdev_store_delete(struct device *dev, struct device_attribute *attr,
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
 
+#define INVALID_SDEV_STATE 0
+
 static ssize_t
 store_state_field(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
 	int i;
 	struct scsi_device *sdev = to_scsi_device(dev);
-	enum scsi_device_state state = 0;
+	enum scsi_device_state state = INVALID_SDEV_STATE;
 
 	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
 		const int len = strlen(sdev_states[i].name);
@@ -607,7 +609,8 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 			break;
 		}
 	}
-	if (!state)
+	if (state == INVALID_SDEV_STATE || state == SDEV_CANCEL ||
+	    state == SDEV_DEL)
 		return -EINVAL;
 
 	if (scsi_device_set_state(sdev, state))
-- 
1.7.10.4

