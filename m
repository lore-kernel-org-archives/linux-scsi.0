From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 4/7] Disallow changing the device state via sysfs into "deleted"
Date: Tue, 20 Aug 2013 14:08:39 +0200
Message-ID: <52135C47.4090106@acm.org>
References: <52135B99.2000102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:55146 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab3HTMIl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2013 08:08:41 -0400
In-Reply-To: <52135B99.2000102@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

Changing the state of a SCSI device via sysfs into "cancel",
"cancel-offline" or "deleted" prevents removal of these devices by
scsi_remove_host(). Hence do not allow this.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
Cc: David Milburn <dmilburn@redhat.com>
---
 drivers/scsi/scsi_sysfs.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9a5cde9..c6276ec 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -635,10 +635,9 @@ store_state_field(struct device *dev, struct device_attribute *attr,
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

