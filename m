From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Subject: [PATCH] scsi_sysfs: Fix queue_ramp_up_period return code
Date: Mon, 26 Oct 2015 15:54:23 +0100
Message-ID: <562E3E9F.50600@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp09.uk.ibm.com ([195.75.94.105]:51843 "EHLO
	e06smtp09.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbbJZOy2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2015 10:54:28 -0400
Received: from localhost
	by e06smtp09.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <oberpar@linux.vnet.ibm.com>;
	Mon, 26 Oct 2015 14:54:26 -0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Writing a number to /sys/bus/scsi/devices/<sdev>/queue_ramp_up_period
returns the value of that number instead of the number of bytes written.
This behavior can confuse programs expecting POSIX write() semantics.
Fix this by returning the number of bytes written instead.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b333389..6b0f292 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -898,7 +898,7 @@ sdev_store_queue_ramp_up_period(struct device *dev,
 		return -EINVAL;

 	sdev->queue_ramp_up_period = msecs_to_jiffies(period);
-	return period;
+	return count;
 }

 static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
-- 
2.3.0

