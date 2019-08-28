Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F7E8C41514
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 19:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA2C3233A1
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 19:18:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AFwFkCbw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfH1TSO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Aug 2019 15:18:14 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44198 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbfH1TSE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2019 15:18:04 -0400
Received: by mail-pl1-f193.google.com with SMTP id t14so397176plr.11
        for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2019 12:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=peYkc8bpnDp6jFbXtkwKHOUEOwA9yyWEoa4Q9aEgSqo=;
        b=AFwFkCbwz63sJkbk32teOrITW/PxPxz4IF3E60WGCC6OIkYgPjzJSp1x7aiVGloV89
         A4uKhTR4+72TgIhhMk3aWziPHvzqP0HeYcmoHdfilhX66Y1mMr9h8pFru1N4BoVW+TI3
         0bTriWTQ9pTYyp4T40Ovwi8X0YboAI2w8vwO3wVWVR2ZmNP1uTjxRccGoZGnvCOI1tQN
         N184XnZqBtgT/eO0a37h7hSBchxRf+7/0PDYYjjmHqzqGjtfC8/8HN6mpqOE9jpA3smd
         5X1x8XQLUJXnd8RDqF7+6RztHUb74CDvTbltYi6eRQjdu2uciJ+H5xMQqgc26X9PQt2d
         79pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=peYkc8bpnDp6jFbXtkwKHOUEOwA9yyWEoa4Q9aEgSqo=;
        b=W/2SHUZmQ3qeXad+qQMB5jEbueGq84RRHtvX4gFccDvB7CwRkKWWQALFC8EHxIFOCB
         E7dVDKE/2IJ+J24JDHxCZQjTWpsRtZ0dY0HchZwSnNDM1nRVGhM/qo+kSM7pJsEAjrN7
         6cd/JPL2SvsWppJbGOCRfRsNNioqZN7k3XQ9ZMCTf+uzxxIDAplzf9aiuWqbbYtVDirS
         kVZJObaFslJUFRFLqrGR02F5+povTf5ZjKEzP+Es4ga93UV+FZoIkUbTBiYKtSFoAt1N
         9D3WiAXRIpF48lKAOMSsr1PTox8aNpo/5iFMOuUefkG1k5L9QxDsaiZ5bdqbK6WU2WQ0
         cuyw==
X-Gm-Message-State: APjAAAWNipmWpvr2rsYTV9DuTd6hKE1feBbhp+qxbZh+n3+ekqwfW8SY
        BMuT5L9KVsAVaAvxZy2EpfzCiw==
X-Google-Smtp-Source: APXvYqybIMSlWnXZB7dwowyvH/Nncyh1fSLknh4G6/YETH495I0ZI/Wu7VCVHUtdSGq+TuI+zjgunA==
X-Received: by 2002:a17:902:96a:: with SMTP id 97mr5909479plm.264.1567019883819;
        Wed, 28 Aug 2019 12:18:03 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id n128sm122717pfn.46.2019.08.28.12.18.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 12:18:03 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Andy Gross <agross@kernel.org>, Bean Huo <beanhuo@micron.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v4 2/3] scsi: ufs-qcom: Implement device_reset vops
Date:   Wed, 28 Aug 2019 12:17:55 -0700
Message-Id: <20190828191756.24312-3-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190828191756.24312-1-bjorn.andersson@linaro.org>
References: <20190828191756.24312-1-bjorn.andersson@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The UFS_RESET pin on Qualcomm SoCs are controlled by TLMM and exposed
through the GPIO framework. Acquire the device-reset GPIO and use this
to implement the device_reset vops, to allow resetting the attached
memory.

Based on downstream support implemented by Subhash Jadavani
<subhashj@codeaurora.org>.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v3:
- Renamed device-reset-gpios to just reset-gpios.
- Explicitly bail on !host->device_reset, to not rely on passing NULL to
  gpiod_set_value_cansleep()

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt |  2 ++
 drivers/scsi/ufs/ufs-qcom.c                   | 36 +++++++++++++++++++
 drivers/scsi/ufs/ufs-qcom.h                   |  4 +++
 3 files changed, 42 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index a74720486ee2..d78ef63935f9 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -54,6 +54,8 @@ Optional properties:
 			  PHY reset from the UFS controller.
 - resets            : reset node register
 - reset-names       : describe reset node register, the "rst" corresponds to reset the whole UFS IP.
+- reset-gpios       : A phandle and gpio specifier denoting the GPIO connected
+		      to the RESET pin of the UFS memory device.
 
 Note: If above properties are not defined it can be assumed that the supply
 regulators or clocks are always on.
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 4473f339cbc0..2200c8434ef3 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -8,6 +8,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/phy/phy.h>
+#include <linux/gpio/consumer.h>
 #include <linux/reset-controller.h>
 
 #include "ufshcd.h"
@@ -1140,6 +1141,15 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 		}
 	}
 
+	host->device_reset = devm_gpiod_get_optional(dev, "reset",
+						     GPIOD_OUT_HIGH);
+	if (IS_ERR(host->device_reset)) {
+		err = PTR_ERR(host->device_reset);
+		if (err != -EPROBE_DEFER)
+			dev_err(dev, "failed to acquire reset gpio: %d\n", err);
+		goto out_variant_clear;
+	}
+
 	err = ufs_qcom_bus_register(host);
 	if (err)
 		goto out_variant_clear;
@@ -1545,6 +1555,31 @@ static void ufs_qcom_dump_dbg_regs(struct ufs_hba *hba)
 	usleep_range(1000, 1100);
 }
 
+/**
+ * ufs_qcom_device_reset() - toggle the (optional) device reset line
+ * @hba: per-adapter instance
+ *
+ * Toggles the (optional) reset line to reset the attached device.
+ */
+static void ufs_qcom_device_reset(struct ufs_hba *hba)
+{
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	/* reset gpio is optional */
+	if (!host->device_reset)
+		return;
+
+	/*
+	 * The UFS device shall detect reset pulses of 1us, sleep for 10us to
+	 * be on the safe side.
+	 */
+	gpiod_set_value_cansleep(host->device_reset, 1);
+	usleep_range(10, 15);
+
+	gpiod_set_value_cansleep(host->device_reset, 0);
+	usleep_range(10, 15);
+}
+
 /**
  * struct ufs_hba_qcom_vops - UFS QCOM specific variant operations
  *
@@ -1565,6 +1600,7 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.suspend		= ufs_qcom_suspend,
 	.resume			= ufs_qcom_resume,
 	.dbg_register_dump	= ufs_qcom_dump_dbg_regs,
+	.device_reset		= ufs_qcom_device_reset,
 };
 
 /**
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index 001915d1e0e4..d401f174bb70 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -195,6 +195,8 @@ struct ufs_qcom_testbus {
 	u8 select_minor;
 };
 
+struct gpio_desc;
+
 struct ufs_qcom_host {
 	/*
 	 * Set this capability if host controller supports the QUniPro mode
@@ -232,6 +234,8 @@ struct ufs_qcom_host {
 	struct ufs_qcom_testbus testbus;
 
 	struct reset_controller_dev rcdev;
+
+	struct gpio_desc *device_reset;
 };
 
 static inline u32
-- 
2.18.0

