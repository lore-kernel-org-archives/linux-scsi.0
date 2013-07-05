From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v14 6/6] Disallow changing the device state via sysfs into
 "deleted"
Date: Fri, 05 Jul 2013 15:28:47 +0200
Message-ID: <51D6CA0F.5040503@acm.org>
References: <51D6C885.9050000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:33236 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3GEN2s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jul 2013 09:28:48 -0400
In-Reply-To: <51D6C885.9050000@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, David Milburn <dmilburn@redhat.com>

Changing the state of a SCSI device via sysfs into "cancel",
"cancel-offline" or "deleted" prevents removal of these devices by
scsi_remove_host(). Hence do not allow this.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
Cc: David Milburn <dmilburn@redhat.com>
---
 drivers/scsi/scsi_sysfs.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index f6ce38e..f9db9c7 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -606,10 +606,9 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 			break;
 		}
 	}
-	if (!state)
-		return -EINVAL;
-
-	if (scsi_device_set_state(sdev, state))
+	if (state == 0 || state == SDEV_CANCEL ||
+	    state == SDEV_CANCEL_OFFLINE || state == SDEV_DEL ||
+	    scsi_device_set_state(sdev, state) != 0)
 		return -EINVAL;
 	return count;
 }
-- 
1.7.10.4

