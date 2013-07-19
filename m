From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] scsi: replace strict_strtoul() with kstrtoul()
Date: Fri, 19 Jul 2013 15:54:59 +0900
Message-ID: <000801ce844c$e2afb530$a80f1f90$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:43693 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759549Ab3GSGzB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jul 2013 02:55:01 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MQ6006QF8JOE0J0@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Fri, 19 Jul 2013 15:55:00 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/pmcraid.c    |    6 ++++--
 drivers/scsi/scsi_sysfs.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 1eb7b028..8cd98e6 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4203,9 +4203,11 @@ static ssize_t pmcraid_store_log_level(
 	struct Scsi_Host *shost;
 	struct pmcraid_instance *pinstance;
 	unsigned long val;
+	int ret;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
 	/* log-level should be from 0 to 2 */
 	if (val > 2)
 		return -EINVAL;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 7e50061..a876e9b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -819,9 +819,11 @@ sdev_store_queue_ramp_up_period(struct device *dev,
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	unsigned long period;
+	int ret;
 
-	if (strict_strtoul(buf, 10, &period))
-		return -EINVAL;
+	ret = kstrtoul(buf, 10, &period);
+	if (ret)
+		return ret;
 
 	sdev->queue_ramp_up_period = msecs_to_jiffies(period);
 	return period;
-- 
1.7.10.4


