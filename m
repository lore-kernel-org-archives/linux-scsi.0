Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36CE7C636C8
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E6FF61261
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhGVCzi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:55:38 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:52778 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhGVCzi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 22:55:38 -0400
Received: by mail-pj1-f48.google.com with SMTP id bt15so4298206pjb.2
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2021 20:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4jRpmjo1mcwSOAGbFKBbQswise4fcTTbg/9WuySUfxA=;
        b=I77tnh1aO8rK7yVjA7ytYFK+lBWDiCCb70arApEUhfjSd0SppIfbmudssAZZgMHIeS
         NOsf3RLZFRDEf6UHN3ffxi5B+Z6N0HRclKa/tFYolN4X+ggaUScf5ZuidWcGFSufk9+v
         7bU8lRsXzrOMoTJ+KsZqE/vDLlfgTj4Ug7VZfOkFOGP0aHTkCfpPOX0et0LfcT5KMF3i
         FIvm5oXIQm7BBTcnwceUfqfQnPNcBTEyD6lOb/Ra1D0M6oMuMydBCzRN/j0hoXNVqhFR
         swZOH6xvjDl6FZ7OGbs/aXXiNlNoZgHjdPJVj1nsIgzB1zo8z+hCMNfI6MncU04hyW6t
         eVXA==
X-Gm-Message-State: AOAM532eVifyxm9iZrWpSzQzlaFfAyR0GK3MrPwaNAKHELYtjl9sILUh
        sZi/MpJwVpbBCZcrj+ZkMMY=
X-Google-Smtp-Source: ABdhPJx6YpPt9HTUAyNAXutvjUXCtNrSNcCzuKMfze+vLpxwGMEe6b/o3swTu5VgUktG4CmUL+N7cg==
X-Received: by 2002:a17:90b:4a4b:: with SMTP id lb11mr38785090pjb.99.1626924972764;
        Wed, 21 Jul 2021 20:36:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:30e2:954a:f4a0:3224])
        by smtp.gmail.com with ESMTPSA id n6sm32060258pgb.60.2021.07.21.20.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 20:36:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v3 18/18] scsi: ufs: Add fault injection support
Date:   Wed, 21 Jul 2021 20:34:39 -0700
Message-Id: <20210722033439.26550-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it easier to test the UFS error handler and abort handler.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/Kconfig               |  7 +++
 drivers/scsi/ufs/Makefile              |  1 +
 drivers/scsi/ufs/ufs-fault-injection.c | 70 ++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-fault-injection.h | 24 +++++++++
 drivers/scsi/ufs/ufshcd.c              |  8 +++
 5 files changed, 110 insertions(+)
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
index 000000000000..7ac7c4e7ff83
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-fault-injection.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/kconfig.h>
+#include <linux/types.h>
+#include <linux/fault-inject.h>
+#include <linux/module.h>
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
+enum { FAULT_INJ_STR_SIZE = 80 };
+
+/*
+ * For more details about fault injection, please refer to
+ * Documentation/fault-injection/fault-injection.rst.
+ */
+static char g_trigger_eh_str[FAULT_INJ_STR_SIZE];
+module_param_cb(trigger_eh, &ufs_fault_ops, g_trigger_eh_str, 0644);
+MODULE_PARM_DESC(trigger_eh,
+	"Fault injection. trigger_eh=<interval>,<probability>,<space>,<times>");
+static DECLARE_FAULT_ATTR(ufs_trigger_eh_attr);
+
+static char g_timeout_str[FAULT_INJ_STR_SIZE];
+module_param_cb(timeout, &ufs_fault_ops, g_timeout_str, 0644);
+MODULE_PARM_DESC(timeout,
+	"Fault injection. timeout=<interval>,<probability>,<space>,<times>");
+static DECLARE_FAULT_ATTR(ufs_timeout_attr);
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
+	strlcpy(kp->arg, val, FAULT_INJ_STR_SIZE);
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
index 3cfbc467f7c0..e6ceab4563ba 100644
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
 
@@ -5278,6 +5283,9 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
+	if (ufs_fail_completion())
+		return IRQ_HANDLED;
+
 	spin_lock_irqsave(&hba->outstanding_lock, flags);
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
