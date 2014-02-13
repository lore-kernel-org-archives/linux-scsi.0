From: XinHong Zhu <zxh3737@163.com>
Subject: [PATCH] [SCSI] pm80xx : no need for tag allocation when issuing the  command of unregistering device
Date: Thu, 13 Feb 2014 11:59:38 +0800
Message-ID: <1392263978-216-1-git-send-email-zxh3737@163.com>
References: <y>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:49151 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaBMEAI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 23:00:08 -0500
In-Reply-To: <y>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: lindar_liu@usish.com, XinHong Zhu <zxh3737@163.com>

In function pm8001_dev_gone_notify require a tag from bitmap resource and later don't free tag resource .So tag resource will be consume fully and following request can not be execed because of lack of tags . But in the function don't need use any tag to issue command of unregistering device .

Signed-off-by: XinHong Zhu <zxh3737@163.com>
---
 drivers/scsi/pm8001/pm8001_sas.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index f50ac44..ba3088c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -865,13 +865,11 @@ ex_err:
 static void pm8001_dev_gone_notify(struct domain_device *dev)
 {
 	unsigned long flags = 0;
-	u32 tag;
 	struct pm8001_hba_info *pm8001_ha;
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
 
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
-	pm8001_tag_alloc(pm8001_ha, &tag);
 	if (pm8001_dev) {
 		u32 device_id = pm8001_dev->device_id;
 
-- 
1.7.9


