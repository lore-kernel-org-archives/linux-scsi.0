From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 4/4] Disallow changing the device state via sysfs into "deleted"
Date: Tue, 02 Jul 2013 15:08:08 +0200
Message-ID: <51D2D0B8.9010207@acm.org>
References: <51D2CFE2.90302@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:35071 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3GBNIL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jul 2013 09:08:11 -0400
In-Reply-To: <51D2CFE2.90302@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Tejun Heo <tj@kernel.org>

Changing the state of a SCSI device via sysfs into "cancel" or
"deleted" prevents removal of these devices by scsi_remove_host().
Hence do not allow this.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
Cc: David Milburn <dmilburn@redhat.com>
---
 drivers/scsi/scsi_sysfs.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 1711617..292df85 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -605,10 +605,8 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 			break;
 		}
 	}
-	if (!state)
-		return -EINVAL;
-
-	if (scsi_device_set_state(sdev, state))
+	if (state == 0 || state == SDEV_CANCEL || state == SDEV_DEL ||
+	    scsi_device_set_state(sdev, state))
 		return -EINVAL;
 	return count;
 }
-- 
1.7.10.4

