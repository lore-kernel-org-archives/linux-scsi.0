From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 1/2] cxlflash: Verify problem state area is mapped before notifying shutdown
Date: Thu, 21 Jul 2016 15:44:04 -0500
Message-ID: <1469133844-8629-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1469133772-14953-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58021 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753877AbcGUUo1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2016 16:44:27 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6LKdCWW050761
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 16:44:26 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24aeh5pfxm-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 16:44:26 -0400
Received: from localhost
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Thu, 21 Jul 2016 14:44:25 -0600
In-Reply-To: <1469133772-14953-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

If an EEH or some other hard error occurs while the
adapter instance was being initialized, on the subsequent
shutdown of the device, the system could crash with:

[c000000f1da03b60] c0000000005eccfc pci_device_shutdown+0x6c/0x100
[c000000f1da03ba0] c0000000006d67d4 device_shutdown+0x1b4/0x2c0
[c000000f1da03c40] c0000000000ea30c kernel_restart_prepare+0x5c/0x80
[c000000f1da03c70] c0000000000ea48c kernel_restart+0x2c/0xc0
[c000000f1da03ce0] c0000000000ea970 SyS_reboot+0x1c0/0x2d0
[c000000f1da03e30] c000000000009204 system_call+0x38/0xb4

This crash is due to the AFU not being mapped when the shutdown
notification routine is called and is a regression that was inserted
recently with Commit 704c4b0ddc03 ("cxlflash: Shutdown notify support
for CXL Flash cards").

As a fix, shutdown notification should only occur when the AFU is mapped.

Fixes: 704c4b0ddc03 ("cxlflash: Shutdown notify support for CXL Flash cards")
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 860008d..661bb94 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -778,7 +778,7 @@ static void notify_shutdown(struct cxlflash_cfg *cfg, bool wait)
 {
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
-	struct sisl_global_map __iomem *global = &afu->afu_map->global;
+	struct sisl_global_map __iomem *global;
 	struct dev_dependent_vals *ddv;
 	u64 reg, status;
 	int i, retry_cnt = 0;
@@ -787,6 +787,14 @@ static void notify_shutdown(struct cxlflash_cfg *cfg, bool wait)
 	if (!(ddv->flags & CXLFLASH_NOTIFY_SHUTDOWN))
 		return;
 
+	if (!afu || !afu->afu_map) {
+		dev_dbg(dev, "%s: The problem state area is not mapped\n",
+			__func__);
+		return;
+	}
+
+	global = &afu->afu_map->global;
+
 	/* Notify AFU */
 	for (i = 0; i < NUM_FC_PORTS; i++) {
 		reg = readq_be(&global->fc_regs[i][FC_CONFIG2 / 8]);
-- 
2.1.0

