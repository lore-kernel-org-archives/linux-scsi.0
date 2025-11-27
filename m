Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BC9314D03
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 07:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764227311; cv=none; b=ZScoUlKwecdVm7WkSEWekfSMZDXwtITRolMKTsrDr6CTiZykb+NGWWzcWkwrrM3BY3S0tLWCKDPhrfLGUHSyxJsWylLIwwYxkeZjB/DMvg8NiIBEsVNnZ7kzkB5d8pc89vWABtjyPJRsTKSFWZbqF2d8f597jCDbvmDG+d13bOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764227311; c=relaxed/simple;
	bh=9jIGFNe756DLBTCNV3LfYUseaGlUrscgOO8Vzp4QJ4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=nYNRxxiOdaXKXPT0t0uZYcmQKPcygjxC2gVIxo8/Dcz3ZNeNJ986QeLCIaJWR333gLeF8jT5oki/o9n+oprX2ox5ck2IA2Rr7E1yO310weoAaEqShofFCcvFeQAa28zDueJTD0nvUl1HXGP2q5592fX3+4WES5DLMxxZD3gO5ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=t+XsVqsB; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="t+XsVqsB"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251127070827epoutp03fa9309a18b09ced4308287af0720b65d~7y2N4z_r02233822338epoutp03e
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 07:08:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251127070827epoutp03fa9309a18b09ced4308287af0720b65d~7y2N4z_r02233822338epoutp03e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1764227307;
	bh=oDPUKbi7YGPH9yI4ei3W2oFnAoGH00s14gfllw4FPiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+XsVqsBoYrLT5fGE4rEM9YbPINDcs5KfNBH/ftwauSdfXMYS+L++KSN2OJ/0H2tE
	 dyNE46RJHD15gz0L9vdVgmJEkaa1wIcENaUeHfegxeLXBE4DiivsQwShKYVEtcdVkF
	 Oc7yfEefjfqUizaqIDIGs3nKhCGhoRVlFBWYzuiU=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251127070826epcas5p313e31e3e414cbc47dcf79ca8e78ebc10~7y2NQn1cU3020430204epcas5p33;
	Thu, 27 Nov 2025 07:08:26 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.90]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dH6w926CXz2SSKf; Thu, 27 Nov
	2025 07:08:25 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20251127070724epcas5p40c7960e2a95fa94041225d691a20997e~7y1TLL4170147901479epcas5p4-;
	Thu, 27 Nov 2025 07:07:24 +0000 (GMT)
Received: from testpc12933.samsungds.net (unknown [109.105.129.33]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251127070723epsmtip20a0c98be4b41814b64eb088bb1906ef3~7y1SLrfdR2028620286epsmtip2I;
	Thu, 27 Nov 2025 07:07:22 +0000 (GMT)
From: "zheng.gong" <zheng.gong@samsung.com>
To: linux-scsi@vger.kernel.org
Cc: avri.altman@wdc.com, bvanassche@acm.org, quic_cang@quicinc.com,
	alim.akhtar@samsung.com, martin.petersen@oracle.com, ebiggers@kernel.org,
	linux-kernel@vger.kernel.org, "zheng.gong" <zheng.gong@samsung.com>
Subject: [PATCH v2 2/2] scsi: ufs: Add crypto keyslot remapping test module
Date: Thu, 27 Nov 2025 15:06:59 +0800
Message-ID: <20251127070704.2935390-3-zheng.gong@samsung.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251127070704.2935390-1-zheng.gong@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="1a2s3d4f!@"
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251127070724epcas5p40c7960e2a95fa94041225d691a20997e
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251127070724epcas5p40c7960e2a95fa94041225d691a20997e
References: <20251112031035.GA2832160@google.com>
	<20251127070704.2935390-1-zheng.gong@samsung.com>
	<CGME20251127070724epcas5p40c7960e2a95fa94041225d691a20997e@epcas5p4.samsung.com>

Add a test module (CONFIG_SCSI_UFS_CRYPTO_TEST) that demonstrates the use
of the new crypto_keyslot_remap variant operation. The module registers a
dummy variant ops that shifts the logical keyslot by a fixed offset (e.g., +8),
simulating a secondary domain in a multi-domain environment.

This is not a production driver, but serves to show that the hook is used.

Note: This patch is intended to illustrate usage. If maintainers prefer not
to include test modules in the core UFS driver, it can be dropped in a future
version.

Signed-off-by: zheng.gong <zheng.gong@samsung.com>
---
 drivers/ufs/core/Kconfig              | 17 +++++
 drivers/ufs/core/Makefile             |  1 +
 drivers/ufs/core/ufshcd-crypto-test.c | 90 +++++++++++++++++++++++++++
 3 files changed, 108 insertions(+)
 create mode 100644 drivers/ufs/core/ufshcd-crypto-test.c

diff --git a/drivers/ufs/core/Kconfig b/drivers/ufs/core/Kconfig
index 817208ee64ec..c5dfd3722365 100644
--- a/drivers/ufs/core/Kconfig
+++ b/drivers/ufs/core/Kconfig
@@ -50,3 +50,20 @@ config SCSI_UFS_HWMON
 	  a hardware monitoring device will be created for the UFS device.
 
 	  If unsure, say N.
+
+config SCSI_UFS_CRYPTO_TEST
+	bool "UFS crypto keyslot remapping test module"
+	depends on SCSI_UFS_CRYPTO
+	help
+	  This option enables a test implementation of the crypto_keyslot_remap
+	  variant operation to demonstrate how platform-specific keyslot remapping
+	  can be used for multi-domain inline encryption (e.g., VM or security
+	  domain isolation).
+
+	  The test module registers a dummy variant ops that shifts the keyslot
+	  by a fixed offset (e.g., +8), simulating a secondary domain.
+
+	  This is for testing and demonstration only. Say Y or M if you want to
+	  verify the remapping hook works end-to-end.
+
+	  If unsure, say N.
diff --git a/drivers/ufs/core/Makefile b/drivers/ufs/core/Makefile
index cf820fa09a04..cf85fee26afb 100644
--- a/drivers/ufs/core/Makefile
+++ b/drivers/ufs/core/Makefile
@@ -7,3 +7,4 @@ ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
 ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)	+= ufshcd-crypto.o
 ufshcd-core-$(CONFIG_SCSI_UFS_FAULT_INJECTION) += ufs-fault-injection.o
 ufshcd-core-$(CONFIG_SCSI_UFS_HWMON)	+= ufs-hwmon.o
+ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO_TEST) += ufshcd-crypto-test.o
diff --git a/drivers/ufs/core/ufshcd-crypto-test.c b/drivers/ufs/core/ufshcd-crypto-test.c
new file mode 100644
index 000000000000..96706a5b3b56
--- /dev/null
+++ b/drivers/ufs/core/ufshcd-crypto-test.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 Samsung Electronics Co., Ltd.
+ */
+
+#include <ufs/ufshcd.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#ifdef CONFIG_SCSI_UFS_CRYPTO_TEST
+
+static void ufs_crypto_test_keyslot_remap(struct ufs_hba *hba,
+										  struct ufshcd_lrb *lrbp)
+{
+	/*
+	 * Simulate a platform that uses non-zero keyslot base for certain domains.
+	 * For example:
+	 *   - Domain 0: keyslots [0–7]
+	 *   - Domain 1: keyslots [8–15]
+	 *
+	 * This is done by adding a fixed offset to the logical keyslot.
+	 *
+	 * In real platforms, this offset might depend on VM ID, security level,
+	 * or other runtime context.
+	 */
+	const int keyslot_offset = 8;
+
+	if (lrbp->crypto_key_slot >= 0) {
+		lrbp->crypto_key_slot += keyslot_offset;
+		pr_debug("remapped keyslot %d -> %d\n",
+				 lrbp->crypto_key_slot - keyslot_offset,
+				 lrbp->crypto_key_slot);
+	}
+}
+
+static struct ufs_hba_variant_ops ufs_crypto_test_variant_ops = {
+	.name = "ufs-crypto-test",
+	.crypto_keyslot_remap = ufs_crypto_test_keyslot_remap,
+};
+
+/* Only register if no platform ops are already set (for test purposes) */
+static int ufs_crypto_test_probe(struct platform_device *pdev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(&pdev->dev);
+
+	if (!hba) {
+		dev_err(&pdev->dev, "no UFS HBA found\n");
+		return -ENODEV;
+	}
+
+	if (hba->vops) {
+		dev_info(&pdev->dev,
+			"HBA already has variant ops (%s), not registering test ops\n",
+			hba->vops->name);
+		return -EBUSY;
+	}
+
+	hba->vops = &ufs_crypto_test_variant_ops;
+	dev_info(&pdev->dev, "registered crypto_keyslot_remap test hook\n");
+
+	return 0;
+}
+
+static void ufs_crypto_test_remove(struct platform_device *pdev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(&pdev->dev);
+
+	if (hba && hba->vops == &ufs_crypto_test_variant_ops) {
+		pr_info("unregistered crypto_keyslot_remap test hook\n");
+		hba->vops = NULL;
+	}
+}
+
+static struct platform_driver ufs_crypto_test_plat_drv = {
+	.probe = ufs_crypto_test_probe,
+	.remove = ufs_crypto_test_remove,
+	.driver = {
+		.name = "ufs-crypto-test",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_platform_driver(ufs_crypto_test_plat_drv);
+
+MODULE_AUTHOR("Zheng Gong <zheng.gong@samsung.com>");
+MODULE_DESCRIPTION("UFS Crypto Keyslot Remapping Test Module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:ufs-crypto-test");
+
+#endif /* CONFIG_SCSI_UFS_CRYPTO_TEST */
\ No newline at end of file
-- 
2.50.1

