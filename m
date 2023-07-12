Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A40EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 10:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjGLK6f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 06:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbjGLK6e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 06:58:34 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D082D11D
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:58:32 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-26304be177fso3450767a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689159512; x=1691751512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=9lRntyMiDXIrlEPonKFcypmd70adqqA/4SVPD5U+6Pw=;
        b=Yked1ykPK+EhbetiTWQPgUVk4gwsffYx552qbH5lTwJRGzx5Qg2l9GW7wBjVNalB5R
         lDkWxykCn6YJog38rnzN3RivmHEpcgKxRcIpwcRuPtxt5thnFoxkZJZnRQFRon8J7gXy
         B+Eg6wYLASEJGAvynwSOGuFWP3jbjyQ+dFfz9U4GiklP3Wz14jCo3yhDCk+aXUb9ciuW
         J1eFOtmULszcwwk9lc5MLpIp6e7+BEtZBwTbxI1MJW9s6YLFYsY/vNFpvybUJpW9H+7f
         T3estYdXUtq7J9L7XYI+h0NBz96SE7VANkvrVtbvRndfPOZOrd971Q8d8xbJO1GFPfkd
         zn3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689159512; x=1691751512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9lRntyMiDXIrlEPonKFcypmd70adqqA/4SVPD5U+6Pw=;
        b=NH9rS4z9ptHNeQ7yrhXrwrju8FO3DEvFQlljDjyuRQJvbJtW8ieEvySq/CLs077sYn
         AFj202KiFU3+VZijgh7o0po3UQAABrMyeeFDdHklMVthRm0PFRXzYZ7ic5chwh8DIeGi
         YxgtHPGZFrD8L2fo2UZUmbmIv3wX5lCKkfpijEX8icfmO34/BPvtGRhPMS3edAjs5yy7
         sOA0mMl7i+Y8qhRqy8ChyhgMGCtvForBgz4v+xFEyZLqmXqW2u9SQX+mWSg6r4+znns6
         feHuFB4k0Ctccy4820HM2FcjPexhN8/hooSGW3enNKXkANckYdP7TkBFL+cLG8rVvl/W
         Ms5A==
X-Gm-Message-State: ABy/qLah7dn8prBhRytRzAA/x7CKghAIzvi40vJ9SdsiWIQZ4i2UuZV5
        rqOKWOk3nnyQj2t9PxsAfSAB
X-Google-Smtp-Source: APBJJlFQojqeOd292vD611B3QjXN4nDdKe2Y8Furi1R2O+U33Ovwbt0HhiOlBohDjxabJWZZnRPz3A==
X-Received: by 2002:a17:90a:c211:b0:260:e256:27c7 with SMTP id e17-20020a17090ac21100b00260e25627c7mr14107392pjt.15.1689159512280;
        Wed, 12 Jul 2023 03:58:32 -0700 (PDT)
Received: from thinkpad ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id gw10-20020a17090b0a4a00b00262fc84b931sm9724918pjb.44.2023.07.12.03.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:58:32 -0700 (PDT)
Received: from localhost.localdomain ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id k15-20020aa790cf000000b00666b3706be6sm3247860pfk.107.2023.07.12.03.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:36:16 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, andersson@kernel.org,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com, quic_narepall@quicinc.com,
        quic_bhaskarv@quicinc.com, quic_richardp@quicinc.com,
        quic_nguyenb@quicinc.com, quic_ziqichen@quicinc.com,
        bmasney@redhat.com, krzysztof.kozlowski@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 14/14] scsi: ufs: qcom: Add support for scaling interconnects
Date:   Wed, 12 Jul 2023 16:02:13 +0530
Message-Id: <20230712103213.101770-19-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
References: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TUID: nOs3QcYXVJwn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Qcom SoCs require scaling the interconnect paths for proper working of the
peripherals connected through interconnects. Even for accessing the UFS
controller, someone should setup the interconnect paths. So far, the
bootloaders used to setup the interconnect paths before booting linux as
they need to access the UFS storage for things like fetching boot firmware.
But with the advent of multi boot options, bootloader nowadays like in
SA8540p SoC do not setup the interconnect paths at all.

So trying to configure UFS in the absence of the interconnect path
configuration, results in boot crash.

To fix this issue and also to dynamically scale the interconnects (UFS-DDR
and CPU-UFS), interconnect API support is added to the Qcom UFS driver.
With this support, the interconnect paths are scaled dynamically based on
the gear configuration.

During the early stage of ufs_qcom_init(), ufs_qcom_icc_init() will setup
the paths to max bandwidth to allow configuring the UFS registers. Touching
the registers without configuring the icc paths would result in a crash.
However, we don't really need to set max vote for the icc paths as any
minimal vote would suffice. But the max value would allow initialization to
be done faster. After init, the bandwidth will get updated using
ufs_qcom_icc_update_bw() based on the gear and lane configuration.

The bandwidth values defined in ufs_qcom_bw_table struct are taken from
Qcom downstream vendor devicetree source and are calculated as per the
UFS3.1 Spec, Section 6.4.1, HS Gear Rates. So it is fixed across platforms.

Cc: Brian Masney <bmasney@redhat.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 131 +++++++++++++++++++++++++++++++++++-
 drivers/ufs/host/ufs-qcom.h |   3 +
 2 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8d6fd4c3324f..8a3132d45a65 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -7,6 +7,7 @@
 #include <linux/time.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/interconnect.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -46,6 +47,49 @@ enum {
 	TSTBUS_MAX,
 };
 
+#define QCOM_UFS_MAX_GEAR 4
+#define QCOM_UFS_MAX_LANE 2
+
+enum {
+	MODE_MIN,
+	MODE_PWM,
+	MODE_HS_RA,
+	MODE_HS_RB,
+	MODE_MAX,
+};
+
+struct __ufs_qcom_bw_table {
+	u32 bw1;
+	u32 bw2;
+} ufs_qcom_bw_table[MODE_MAX + 1][QCOM_UFS_MAX_GEAR + 1][QCOM_UFS_MAX_LANE + 1] = {
+	[MODE_MIN][0][0] = { 0,		0 },	/* Bandwidth values are in KB/s */
+	[MODE_PWM][1][1] = { 922,	1000 },
+	[MODE_PWM][2][1] = { 1844,	1000 },
+	[MODE_PWM][3][1] = { 3688,	1000 },
+	[MODE_PWM][4][1] = { 7376,	1000 },
+	[MODE_PWM][1][2] = { 1844,	1000 },
+	[MODE_PWM][2][2] = { 3688,	1000 },
+	[MODE_PWM][3][2] = { 7376,	1000 },
+	[MODE_PWM][4][2] = { 14752,	1000 },
+	[MODE_HS_RA][1][1] = { 127796,	1000 },
+	[MODE_HS_RA][2][1] = { 255591,	1000 },
+	[MODE_HS_RA][3][1] = { 1492582,	102400 },
+	[MODE_HS_RA][4][1] = { 2915200,	204800 },
+	[MODE_HS_RA][1][2] = { 255591,	1000 },
+	[MODE_HS_RA][2][2] = { 511181,	1000 },
+	[MODE_HS_RA][3][2] = { 1492582,	204800 },
+	[MODE_HS_RA][4][2] = { 2915200,	409600 },
+	[MODE_HS_RB][1][1] = { 149422,	1000 },
+	[MODE_HS_RB][2][1] = { 298189,	1000 },
+	[MODE_HS_RB][3][1] = { 1492582,	102400 },
+	[MODE_HS_RB][4][1] = { 2915200,	204800 },
+	[MODE_HS_RB][1][2] = { 298189,	1000 },
+	[MODE_HS_RB][2][2] = { 596378,	1000 },
+	[MODE_HS_RB][3][2] = { 1492582,	204800 },
+	[MODE_HS_RB][4][2] = { 2915200,	409600 },
+	[MODE_MAX][0][0] = { 7643136, 307200 },
+};
+
 static struct ufs_qcom_host *ufs_qcom_hosts[MAX_UFS_QCOM_HOSTS];
 
 static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host);
@@ -789,6 +833,51 @@ static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
 	}
 }
 
+static int ufs_qcom_icc_set_bw(struct ufs_qcom_host *host, u32 bw1, u32 bw2)
+{
+	struct device *dev = host->hba->dev;
+	int ret;
+
+	ret = icc_set_bw(host->icc_ddr, 0, bw1);
+	if (ret < 0) {
+		dev_err(dev, "failed to set bandwidth request: %d\n", ret);
+		return ret;
+	}
+
+	ret = icc_set_bw(host->icc_cpu, 0, bw2);
+	if (ret < 0) {
+		dev_err(dev, "failed to set bandwidth request: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct __ufs_qcom_bw_table ufs_qcom_get_bw_table(struct ufs_qcom_host *host)
+{
+	struct ufs_pa_layer_attr *p = &host->dev_req_params;
+	int gear = max_t(u32, p->gear_rx, p->gear_tx);
+	int lane = max_t(u32, p->lane_rx, p->lane_tx);
+
+	if (ufshcd_is_hs_mode(p)) {
+		if (p->hs_rate == PA_HS_MODE_B)
+			return ufs_qcom_bw_table[MODE_HS_RB][gear][lane];
+		else
+			return ufs_qcom_bw_table[MODE_HS_RA][gear][lane];
+	} else {
+		return ufs_qcom_bw_table[MODE_PWM][gear][lane];
+	}
+}
+
+static int ufs_qcom_icc_update_bw(struct ufs_qcom_host *host)
+{
+	struct __ufs_qcom_bw_table bw_table;
+
+	bw_table = ufs_qcom_get_bw_table(host);
+
+	return ufs_qcom_icc_set_bw(host, bw_table.bw1, bw_table.bw2);
+}
+
 static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 				enum ufs_notify_change_status status,
 				struct ufs_pa_layer_attr *dev_max_params,
@@ -852,6 +941,8 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 		memcpy(&host->dev_req_params,
 				dev_req_params, sizeof(*dev_req_params));
 
+		ufs_qcom_icc_update_bw(host);
+
 		/* disable the device ref clock if entered PWM mode */
 		if (ufshcd_is_hs_mode(&hba->pwr_info) &&
 			!ufshcd_is_hs_mode(dev_req_params))
@@ -981,7 +1072,9 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
 
 	switch (status) {
 	case PRE_CHANGE:
-		if (!on) {
+		if (on) {
+			ufs_qcom_icc_update_bw(host);
+		} else {
 			if (!ufs_qcom_is_link_active(hba)) {
 				/* disable device ref_clk */
 				ufs_qcom_dev_ref_clk_ctrl(host, false);
@@ -993,6 +1086,9 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
 			/* enable the device ref clock for HS mode*/
 			if (ufshcd_is_hs_mode(&hba->pwr_info))
 				ufs_qcom_dev_ref_clk_ctrl(host, true);
+		} else {
+			ufs_qcom_icc_set_bw(host, ufs_qcom_bw_table[MODE_MIN][0][0].bw1,
+					    ufs_qcom_bw_table[MODE_MIN][0][0].bw2);
 		}
 		break;
 	}
@@ -1031,6 +1127,34 @@ static const struct reset_control_ops ufs_qcom_reset_ops = {
 	.deassert = ufs_qcom_reset_deassert,
 };
 
+static int ufs_qcom_icc_init(struct ufs_qcom_host *host)
+{
+	struct device *dev = host->hba->dev;
+	int ret;
+
+	host->icc_ddr = devm_of_icc_get(dev, "ufs-ddr");
+	if (IS_ERR(host->icc_ddr))
+		return dev_err_probe(dev, PTR_ERR(host->icc_ddr),
+				    "failed to acquire interconnect path\n");
+
+	host->icc_cpu = devm_of_icc_get(dev, "cpu-ufs");
+	if (IS_ERR(host->icc_cpu))
+		return dev_err_probe(dev, PTR_ERR(host->icc_cpu),
+				    "failed to acquire interconnect path\n");
+
+	/*
+	 * Set Maximum bandwidth vote before initializing the UFS controller and
+	 * device. Ideally, a minimal interconnect vote would suffice for the
+	 * initialization, but a max vote would allow faster initialization.
+	 */
+	ret = ufs_qcom_icc_set_bw(host, ufs_qcom_bw_table[MODE_MAX][0][0].bw1,
+				  ufs_qcom_bw_table[MODE_MAX][0][0].bw2);
+	if (ret < 0)
+		return dev_err_probe(dev, ret, "failed to set bandwidth request\n");
+
+	return 0;
+}
+
 /**
  * ufs_qcom_init - bind phy with controller
  * @hba: host controller instance
@@ -1085,6 +1209,10 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 		}
 	}
 
+	err = ufs_qcom_icc_init(host);
+	if (err)
+		goto out_variant_clear;
+
 	host->device_reset = devm_gpiod_get_optional(dev, "reset",
 						     GPIOD_OUT_HIGH);
 	if (IS_ERR(host->device_reset)) {
@@ -1282,6 +1410,7 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba,
 				    dev_req_params->pwr_rx,
 				    dev_req_params->hs_rate,
 				    false);
+		ufs_qcom_icc_update_bw(host);
 		ufshcd_uic_hibern8_exit(hba);
 	}
 
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 6289ad5a42d0..dc27395ecba1 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -206,6 +206,9 @@ struct ufs_qcom_host {
 	struct clk *tx_l1_sync_clk;
 	bool is_lane_clks_enabled;
 
+	struct icc_path *icc_ddr;
+	struct icc_path *icc_cpu;
+
 #ifdef CONFIG_SCSI_UFS_CRYPTO
 	struct qcom_ice *ice;
 #endif
-- 
2.25.1

