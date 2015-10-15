From: sumit.saxena@avagotech.com
Subject: [PATCH 07/12] megaraid_sas : Online firmware Upgrade support for
 Secure JBOD feature
Date: Thu, 15 Oct 2015 13:40:24 +0530
Message-ID: <201510150817.t9F8HgSB029643@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rndsmtp1.avagotech.com ([202.86.248.48]:60970 "EHLO
	rndsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbbJOIUt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2015 04:20:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 6777504..3214c7e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4198,6 +4198,10 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 			ctrl_info->properties.OnOffProperties.disableOnlineCtrlReset;
 		dev_info(&instance->pdev->dev, "Online Controller Reset(OCR)\t: %s\n",
 			instance->disableOnlineCtrlReset ? "Disabled" : "Enabled");
+		instance->secure_jbod_support =
+			ctrl_info->adapterOperations3.supportSecurityonJBOD;
+		dev_info(&instance->pdev->dev, "Secure JBOD support\t: %s\n",
+			instance->secure_jbod_support ? "Yes" : "No");
 	}
 
 	pci_free_consistent(instance->pdev, sizeof(struct megasas_ctrl_info),
@@ -4851,8 +4855,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		instance->crash_dump_buf = NULL;
 	}
 
-	instance->secure_jbod_support =
-		ctrl_info->adapterOperations3.supportSecurityonJBOD;
 
 	dev_info(&instance->pdev->dev,
 		"pci id\t\t: (0x%04x)/(0x%04x)/(0x%04x)/(0x%04x)\n",
@@ -4864,8 +4866,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		instance->UnevenSpanSupport ? "yes" : "no");
 	dev_info(&instance->pdev->dev, "firmware crash dump	: %s\n",
 		instance->crash_dump_drv_support ? "yes" : "no");
-	dev_info(&instance->pdev->dev, "secure jbod		: %s\n",
-		instance->secure_jbod_support ? "yes" : "no");
 	dev_info(&instance->pdev->dev, "jbod sync map		: %s\n",
 		instance->use_seqnum_jbod_fp ? "yes" : "no");
 
-- 
1.7.1

