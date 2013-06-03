From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2] scsi: replace strict_strtoul() with kstrtoul()
Date: Mon, 03 Jun 2013 18:06:12 +0900
Message-ID: <000f01ce6039$984e6540$c8eb2fc0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:9077 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3FCJGN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jun 2013 05:06:13 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MNT00ID27XG2XV0@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 03 Jun 2013 18:06:12 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>, 'Anil Ravindranath' <anil_ravindranath@pmc-sierra.com>, 'Andy Shevchenko' <andy.shevchenko@gmail.com>

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- Used return code from kstrtoul().

 drivers/scsi/pmcraid.c    |    6 ++++--
 drivers/scsi/scsi_sysfs.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 8e1b737..39b42a4 100644
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
index 931a7d9..4a8b675 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -789,9 +789,11 @@ sdev_store_queue_ramp_up_period(struct device *dev,
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


