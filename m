From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v12 3/6] Restrict device state changes allowed via sysfs
Date: Thu, 27 Jun 2013 16:54:34 +0200
Message-ID: <51CC522A.4010805@acm.org>
References: <51CC5176.90609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:55945 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab3F0Oyf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jun 2013 10:54:35 -0400
In-Reply-To: <51CC5176.90609@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Tejun Heo <tj@kernel.org>

Restrict the SCSI device state changes allowd via sysfs to the
OFFLINE<>RUNNING transitions. Other transitions may confuse
the SCSI mid-layer. As an example, changing the state of a SCSI
device via sysfs into "cancel" or "deleted" prevents removal of
a SCSI device by scsi_remove_host().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
Cc: David Milburn <dmilburn@redhat.com>
---
 drivers/scsi/scsi_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 931a7d9..013c6de 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -605,7 +605,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 			break;
 		}
 	}
-	if (!state)
+	if (state != SDEV_OFFLINE && state != SDEV_RUNNING)
 		return -EINVAL;
 
 	if (scsi_device_set_state(sdev, state))
-- 
1.7.10.4

