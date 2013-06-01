From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] scsi: replace strict_strtoul() with kstrtoul()
Date: Sat, 01 Jun 2013 16:29:06 +0900
Message-ID: <001201ce5e99$b2ea7480$18bf5d80$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:61088 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3FAH3I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Jun 2013 03:29:08 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MNP006DWE4IT2B0@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Sat, 01 Jun 2013 16:29:06 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>, 'Anil Ravindranath' <anil_ravindranath@pmc-sierra.com>

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/pmcraid.c    |    2 +-
 drivers/scsi/scsi_sysfs.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 8e1b737..948232a 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4204,7 +4204,7 @@ static ssize_t pmcraid_store_log_level(
 	struct pmcraid_instance *pinstance;
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val))
+	if (kstrtoul(buf, 10, &val))
 		return -EINVAL;
 	/* log-level should be from 0 to 2 */
 	if (val > 2)
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 931a7d9..bf36b45 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -790,7 +790,7 @@ sdev_store_queue_ramp_up_period(struct device *dev,
 	struct scsi_device *sdev = to_scsi_device(dev);
 	unsigned long period;
 
-	if (strict_strtoul(buf, 10, &period))
+	if (kstrtoul(buf, 10, &period))
 		return -EINVAL;
 
 	sdev->queue_ramp_up_period = msecs_to_jiffies(period);
-- 
1.7.10.4


