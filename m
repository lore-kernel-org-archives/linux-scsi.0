From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v2] megaraid: Downgrade two success messages to info
Date: Tue,  3 May 2016 10:24:31 -0700
Message-ID: <7e71f78a77208ec3f46f44e8c6dc6ebcff26c2ce.1462296213.git.luto@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44623 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932756AbcECRYf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 May 2016 13:24:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, Andy Lutomirski <luto@kernel.org>

I actually read the error messages in my logs, and successful
initialization is not an error.

Arguably these log lines could be deleted entirely.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---

Changes from v2: Remove hunk that didn't belong

drivers/scsi/megaraid/megaraid_sas_base.c   | 2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e6ebc7ae2df1..d020919e8085 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5152,7 +5152,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 	instance->instancet->enable_intr(instance);
 
-	dev_err(&instance->pdev->dev, "INIT adapter done\n");
+	dev_info(&instance->pdev->dev, "INIT adapter done\n");
 
 	megasas_setup_jbod_map(instance);
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 98a848bdfdc2..9375805670a9 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -851,7 +851,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 		ret = 1;
 		goto fail_fw_init;
 	}
-	dev_err(&instance->pdev->dev, "Init cmd success\n");
+	dev_info(&instance->pdev->dev, "Init cmd success\n");
 
 	ret = 0;
 
-- 
2.5.5

