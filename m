From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH] megaraid: Downgrade two success messages to info
Date: Tue,  3 May 2016 10:06:06 -0700
Message-ID: <7dcbc4070b55d25c767568c7f197e49882b7826a.1462295116.git.luto@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42969 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933407AbcECRGM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 May 2016 13:06:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, Andy Lutomirski <luto@kernel.org>

I actually read the error messages in my logs, and successful
initialization is not an error.

Arguably these log lines could be deleted entirely.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 include/uapi/linux/signal.h                 | 2 +-
 tools/testing/selftests/sigaltstack/sas.c   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

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
 
diff --git a/include/uapi/linux/signal.h b/include/uapi/linux/signal.h
index 738826048af2..cd0804b6bfa2 100644
--- a/include/uapi/linux/signal.h
+++ b/include/uapi/linux/signal.h
@@ -8,7 +8,7 @@
 #define SS_DISABLE	2
 
 /* bit-flags */
-#define SS_AUTODISARM	(1 << 4)	/* disable sas during sighandling */
+#define SS_AUTODISARM	(1U << 31)	/* disable sas during sighandling */
 /* mask for all SS_xxx flags */
 #define SS_FLAG_BITS	SS_AUTODISARM
 
diff --git a/tools/testing/selftests/sigaltstack/sas.c b/tools/testing/selftests/sigaltstack/sas.c
index ec6c99fac303..bbd0f22704b7 100644
--- a/tools/testing/selftests/sigaltstack/sas.c
+++ b/tools/testing/selftests/sigaltstack/sas.c
@@ -169,7 +169,7 @@ int main(void)
 				stk.ss_flags);
 		exit(EXIT_FAILURE);
 	}
-	printf("[OK]\tsigaltstack is enabled after signal\n");
+	printf("[OK]\tsigaltstack is still SS_AUTODISARM after signal\n");
 
 	printf("[OK]\tTest passed\n");
 	return 0;
-- 
2.5.5

