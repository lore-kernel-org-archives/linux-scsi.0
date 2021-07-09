Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71EAAC07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55BD9613BE
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhGIUax (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:30:53 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:36641 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhGIUax (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:30:53 -0400
Received: by mail-pg1-f174.google.com with SMTP id f5so11093304pgv.3
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:28:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4wZdH0yp9otSrfTPJ24LQileMhqPTyuhfvX8YzPYX7k=;
        b=ahcrNOWVnZJURBtugc7sebFaE8kFMmXxG3xTjUIypJ1TidC88RuKCO+GL63nbuxqEI
         0z34t3DXfwxPCnuULfcEAtQgldvefBPo9ZIlgA3yjsqg9D0AyvoQ6D00Ib0gKgMqn0+F
         kElvmP4Ku3AhSvXRCHQk6z0nOebQTeKO8jU+DCVyTXDXgEUf7I0Alncwg0ty9b1IgBb7
         UFJx6yQ10RfHnHoePBj2ciLk78PhDAhyl8+9H6xi40jJuUTg9bLC4my3PBsb+SqX095R
         66TI8w3UvhofOz4GtyDNrZSq8rwkn5A3YIKFWvyLflgEtQkZ8qFrzpn2P7E6vt1EV1yj
         BJ2A==
X-Gm-Message-State: AOAM530r1JhKW2+ZxjNLe7TXxoWgaDZiFbpfWVW4fq/wSxwfTC0Cmm5E
        HvzOZ1nz28HgWt56ViPByak=
X-Google-Smtp-Source: ABdhPJz5T+/cYOJPBgWXmdSUTWM8MMijWSxgaiwLOAGLjL98d4sEGPG93WgGZ3rfNCGJjpXKUyLnyA==
X-Received: by 2002:a63:eb04:: with SMTP id t4mr40876455pgh.84.1625862489340;
        Fri, 09 Jul 2021 13:28:09 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:28:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Eric Biggers <ebiggers@google.com>,
        Avri Altman <avri.altman@wdc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 19/19] scsi: ufs: Add fault injection support
Date:   Fri,  9 Jul 2021 13:26:38 -0700
Message-Id: <20210709202638.9480-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it easier to test the UFS error and abort handlers.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/Kconfig               |  7 +++
 drivers/scsi/ufs/Makefile              |  1 +
 drivers/scsi/ufs/ufs-fault-injection.c | 67 ++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-fault-injection.h | 24 +++++++++
 drivers/scsi/ufs/ufshcd.c              |  8 +++
 5 files changed, 107 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufs-fault-injection.c
 create mode 100644 drivers/scsi/ufs/ufs-fault-injection.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 2d137953e7b4..4272d7365595 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -183,3 +183,10 @@ config SCSI_UFS_CRYPTO
 	  Enabling this makes it possible for the kernel to use the crypto
 	  capabilities of the UFS device (if present) to perform crypto
 	  operations on data being transferred to/from the device.
+
+config SCSI_UFS_FAULT_INJECTION
+       bool "UFS Fault Injection Support"
+       depends on SCSI_UFSHCD && FAULT_INJECTION
+       help
+         Enable fault injection support in the UFS driver. This makes it easier
+	 to test the UFS error handler and abort handler.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 06f3a3fe4a44..006d50236079 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -8,6 +8,7 @@ ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
 ufshcd-core-$(CONFIG_DEBUG_FS)		+= ufs-debugfs.o
 ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
 ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)	+= ufshcd-crypto.o
+ufshcd-core-$(CONFIG_SCSI_UFS_FAULT_INJECTION) += ufs-fault-injection.o
 
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
diff --git a/drivers/scsi/ufs/ufs-fault-injection.c b/drivers/scsi/ufs/ufs-fault-injection.c
new file mode 100644
index 000000000000..f1e126a70019
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-fault-injection.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/kconfig.h>
+#include <linux/module.h>
+#include <linux/fault-inject.h>
+#include "ufs-fault-injection.h"
+
+static int ufs_fault_get(char *buffer, const struct kernel_param *kp);
+static int ufs_fault_set(const char *val, const struct kernel_param *kp);
+
+static const struct kernel_param_ops ufs_fault_ops = {
+	.get = ufs_fault_get,
+	.set = ufs_fault_set,
+};
+
+enum { FAULT_ATTR_SIZE = 80 };
+
+/*
+ * For more details about fault injection, please refer to
+ * Documentation/fault-injection/fault-injection.rst.
+ */
+#define UFS_FAULT_ATTR(storage_class, name)				\
+storage_class char g_##name##_str[FAULT_ATTR_SIZE];			\
+module_param_cb(name, &ufs_fault_ops, g_##name##_str, 0644);		\
+MODULE_PARM_DESC(name,							\
+"Fault injection. " #name "=<interval>,<probability>,<space>,<times>");	\
+storage_class DECLARE_FAULT_ATTR(ufs_##name##_attr)
+
+UFS_FAULT_ATTR(static, trigger_eh);
+UFS_FAULT_ATTR(static, timeout);
+
+static int ufs_fault_get(char *buffer, const struct kernel_param *kp)
+{
+	const char *fault_str = kp->arg;
+
+	return sysfs_emit(buffer, "%s\n", fault_str);
+}
+
+static int ufs_fault_set(const char *val, const struct kernel_param *kp)
+{
+	struct fault_attr *attr = NULL;
+
+	if (kp->arg == g_trigger_eh_str)
+		attr = &ufs_trigger_eh_attr;
+	else if (kp->arg == g_timeout_str)
+		attr = &ufs_timeout_attr;
+
+	if (WARN_ON_ONCE(!attr))
+		return -EINVAL;
+
+	if (!setup_fault_attr(attr, (char *)val))
+		return -EINVAL;
+
+	strlcpy(kp->arg, val, FAULT_ATTR_SIZE);
+
+	return 0;
+}
+
+bool ufs_trigger_eh(void)
+{
+	return should_fail(&ufs_trigger_eh_attr, 1);
+}
+
+bool ufs_fail_completion(void)
+{
+	return should_fail(&ufs_timeout_attr, 1);
+}
diff --git a/drivers/scsi/ufs/ufs-fault-injection.h b/drivers/scsi/ufs/ufs-fault-injection.h
new file mode 100644
index 000000000000..6d0cd8e10c87
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-fault-injection.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _UFS_FAULT_INJECTION_H
+#define _UFS_FAULT_INJECTION_H
+
+#include <linux/kconfig.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_SCSI_UFS_FAULT_INJECTION
+bool ufs_trigger_eh(void);
+bool ufs_fail_completion(void);
+#else
+static inline bool ufs_trigger_eh(void)
+{
+	return false;
+}
+
+static inline bool ufs_fail_completion(void)
+{
+	return false;
+}
+#endif
+
+#endif /* _UFS_FAULT_INJECTION_H */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 46126964669d..686486c25412 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -24,6 +24,7 @@
 #include "unipro.h"
 #include "ufs-sysfs.h"
 #include "ufs-debugfs.h"
+#include "ufs-fault-injection.h"
 #include "ufs_bsg.h"
 #include "ufshcd-crypto.h"
 #include <asm/unaligned.h>
@@ -2750,6 +2751,10 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	ufshcd_send_command(hba, tag);
 out:
 	up_read(&hba->clk_scaling_lock);
+
+	if (ufs_trigger_eh())
+		scsi_schedule_eh(hba->host);
+
 	return err;
 }
 
@@ -5274,6 +5279,9 @@ static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool retry_requests,
 	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
+	if (ufs_fail_completion())
+		return IRQ_HANDLED;
+
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (use_utrlcnr) {
 		completed_reqs = ufshcd_readl(hba,
