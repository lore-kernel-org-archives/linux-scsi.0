From: Ken Xue <Ken.Xue@amd.com>
Subject: [PATCH 1/1] SCSI:Fix  rpm_status of request_queue  in S3 resume of
 SCSI device
Date: Wed, 9 Sep 2015 18:09:29 +0800
Message-ID: <1441793369.5845.87.camel@kxue-X58A-UD3R>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0065.outbound.protection.outlook.com ([207.46.100.65]:30400
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752694AbbIIK1s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Sep 2015 06:27:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: Shane.Huang@amd.com, Xiangliang.Yu@amd.com, linux-scsi@vger.kernel.org, aaron.lu@intel.com, SPG_Linux_Kernel@amd.com

>From d0b7698dda596831aa6a7efca1075a231f1ac5db Mon Sep 17 00:00:00 2001
From: Ken Xue <Ken.Xue@amd.com>
Date: Wed, 9 Sep 2015 17:36:59 +0800
Subject: [PATCH] SCSI:Fix rpm_status of request_queue in S3 resume
 of SCSI device

rpm_status of the request_queue is set to be RPM_SUSPENDED in
runtime suspend before S3. But there is a chance that rpm_status
is not recovered to be RPM_ACTIVE after S3 resume even the power
status of device already became active.

This leads to new request in request_queue cannot be handled and
device cannot goto runtime suspend anymore.

So, if device is suspended, keep this status until status of
request_queue and device all can be updated.

Signed-off-by: Ken Xue <Ken.Xue@amd.com>
---
 drivers/scsi/scsi_pm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index e4b7998..cfda027 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -110,7 +110,8 @@ scsi_bus_suspend_common(struct device *dev,
 
 static void async_sdev_resume(void *dev, async_cookie_t cookie)
 {
-	scsi_dev_type_resume(dev, do_scsi_resume);
+	if (!pm_runtime_suspended(dev))
+		scsi_dev_type_resume(dev, do_scsi_resume);
 }
 
 static void async_sdev_thaw(void *dev, async_cookie_t cookie)
-- 
1.9.1



