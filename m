Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M/72Xi7L"
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEA4E9
	for <linux-scsi@vger.kernel.org>; Fri,  1 Dec 2023 07:14:32 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-6cdd4aab5f5so2211275b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 01 Dec 2023 07:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701443671; x=1702048471; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jvLkGXNQshvzZU680OmMrA5c7oAf7WIO0uWnCsVQkig=;
        b=M/72Xi7LtlcaLyxOdtc4W175e5smNQovEC4vDu2GqlgfWJWMjdUOx6hntqSCeQpnUq
         Xo65QX9+aNbQuQQCJRcXzv34xSD/vPTGtAPRs+9mKtGARv/XUlqPEC6J1HuepwjYD49k
         sXGv9g1kb/XoYQh1s9yv89vJnCW8XSfWiWtXtjOMWfCyyKnOxASVaVyBu9NCNB80pyk8
         mzcTxH3ic9hGqOehjaww7qhc5kuemW/bph53cg+RmEIos6BtV56jwVKWW+HyJsK5Vw44
         NQS5VgwFRFoqz7w6FrHjF0+XieN3EDCWvn4Y5H1AOWCy5P7KEa5sVpBzY5zXmAdxiHRc
         E/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701443671; x=1702048471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jvLkGXNQshvzZU680OmMrA5c7oAf7WIO0uWnCsVQkig=;
        b=a8ksDkid6ChEyh5j7X+tYkTbISPn8JvECdK8Ws8wAHqleo2gOxUx4pTLP6E8ynzTVU
         /Em1bu5cJ8UegZpssDRU1a/VrZ9wxDJvgbo4U4a+VtEViEzRJpKp+V/8KNpmRLUhpsa2
         rnNni+0e9MMCovQsY9foaWFyBinqo5lA3tZXUIi4LrcaU/s/fvIJnTDM7hPxACsBVmVd
         zjhMg2omZfiWRg1w5t8n43eGGW8bRfmC34fdY4vgwAMjCFy2TU5D9x1gIm3PX7lZ09z1
         DxasbGgTpQ5L4ubZcyF6wT9wWozLXR3WwbsA78K3q7YK/QaWfw3MIQvWij1Ue5MKVBCW
         T8RA==
X-Gm-Message-State: AOJu0YztMrcwNDwQm1OYVfCGICTuB+ImR1m0XXcvTofaDxZ6jiYV39tz
	SOHBW5nBD1E+Cbs85O+beQRj
X-Google-Smtp-Source: AGHT+IHfg55fjDOeogk5wYiCzOSIR5XBMDXPS6dtqYKnYjDL4+dYx/9pbpMpF4BYl4nFFNl2hYsOGA==
X-Received: by 2002:a05:6a20:8e26:b0:18c:abeb:b0db with SMTP id y38-20020a056a208e2600b0018cabebb0dbmr18760847pzj.49.1701443671549;
        Fri, 01 Dec 2023 07:14:31 -0800 (PST)
Received: from localhost.localdomain ([117.213.98.226])
        by smtp.gmail.com with ESMTPSA id s14-20020a65644e000000b00578afd8e012sm2765824pgv.92.2023.12.01.07.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 07:14:31 -0800 (PST)
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: martin.petersen@oracle.com,
	jejb@linux.ibm.com
Cc: andersson@kernel.org,
	konrad.dybcio@linaro.org,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	quic_cang@quicinc.com,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 01/13] scsi: ufs: qcom: Use clk_bulk APIs for managing lane clocks
Date: Fri,  1 Dec 2023 20:44:05 +0530
Message-Id: <20231201151417.65500-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
References: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Lane clock handling can be simplified by using the clk_bulk APIs. So let's
make use of them. This also get's rid of the clock validation in the driver
as kernel should just rely on the firmware (DT/ACPI) to provide the clocks
required for proper functioning.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 94 ++-----------------------------------
 drivers/ufs/host/ufs-qcom.h |  6 +--
 2 files changed, 7 insertions(+), 93 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 96cb8b5b4e66..cbb6a696cd97 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -194,52 +194,12 @@ static inline int ufs_qcom_ice_suspend(struct ufs_qcom_host *host)
 }
 #endif
 
-static int ufs_qcom_host_clk_get(struct device *dev,
-		const char *name, struct clk **clk_out, bool optional)
-{
-	struct clk *clk;
-	int err = 0;
-
-	clk = devm_clk_get(dev, name);
-	if (!IS_ERR(clk)) {
-		*clk_out = clk;
-		return 0;
-	}
-
-	err = PTR_ERR(clk);
-
-	if (optional && err == -ENOENT) {
-		*clk_out = NULL;
-		return 0;
-	}
-
-	if (err != -EPROBE_DEFER)
-		dev_err(dev, "failed to get %s err %d\n", name, err);
-
-	return err;
-}
-
-static int ufs_qcom_host_clk_enable(struct device *dev,
-		const char *name, struct clk *clk)
-{
-	int err = 0;
-
-	err = clk_prepare_enable(clk);
-	if (err)
-		dev_err(dev, "%s: %s enable failed %d\n", __func__, name, err);
-
-	return err;
-}
-
 static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
 {
 	if (!host->is_lane_clks_enabled)
 		return;
 
-	clk_disable_unprepare(host->tx_l1_sync_clk);
-	clk_disable_unprepare(host->tx_l0_sync_clk);
-	clk_disable_unprepare(host->rx_l1_sync_clk);
-	clk_disable_unprepare(host->rx_l0_sync_clk);
+	clk_bulk_disable_unprepare(host->num_clks, host->clks);
 
 	host->is_lane_clks_enabled = false;
 }
@@ -247,43 +207,14 @@ static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
 static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
 {
 	int err;
-	struct device *dev = host->hba->dev;
-
-	if (host->is_lane_clks_enabled)
-		return 0;
 
-	err = ufs_qcom_host_clk_enable(dev, "rx_lane0_sync_clk",
-		host->rx_l0_sync_clk);
+	err = clk_bulk_prepare_enable(host->num_clks, host->clks);
 	if (err)
 		return err;
 
-	err = ufs_qcom_host_clk_enable(dev, "tx_lane0_sync_clk",
-		host->tx_l0_sync_clk);
-	if (err)
-		goto disable_rx_l0;
-
-	err = ufs_qcom_host_clk_enable(dev, "rx_lane1_sync_clk",
-			host->rx_l1_sync_clk);
-	if (err)
-		goto disable_tx_l0;
-
-	err = ufs_qcom_host_clk_enable(dev, "tx_lane1_sync_clk",
-			host->tx_l1_sync_clk);
-	if (err)
-		goto disable_rx_l1;
-
 	host->is_lane_clks_enabled = true;
 
 	return 0;
-
-disable_rx_l1:
-	clk_disable_unprepare(host->rx_l1_sync_clk);
-disable_tx_l0:
-	clk_disable_unprepare(host->tx_l0_sync_clk);
-disable_rx_l0:
-	clk_disable_unprepare(host->rx_l0_sync_clk);
-
-	return err;
 }
 
 static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
@@ -294,26 +225,11 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
 	if (has_acpi_companion(dev))
 		return 0;
 
-	err = ufs_qcom_host_clk_get(dev, "rx_lane0_sync_clk",
-					&host->rx_l0_sync_clk, false);
-	if (err)
-		return err;
-
-	err = ufs_qcom_host_clk_get(dev, "tx_lane0_sync_clk",
-					&host->tx_l0_sync_clk, false);
-	if (err)
+	err = devm_clk_bulk_get_all(dev, &host->clks);
+	if (err <= 0)
 		return err;
 
-	/* In case of single lane per direction, don't read lane1 clocks */
-	if (host->hba->lanes_per_direction > 1) {
-		err = ufs_qcom_host_clk_get(dev, "rx_lane1_sync_clk",
-			&host->rx_l1_sync_clk, false);
-		if (err)
-			return err;
-
-		err = ufs_qcom_host_clk_get(dev, "tx_lane1_sync_clk",
-			&host->tx_l1_sync_clk, true);
-	}
+	host->num_clks = err;
 
 	return 0;
 }
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 9950a0089475..e2df4c528a2a 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -213,10 +213,8 @@ struct ufs_qcom_host {
 	struct phy *generic_phy;
 	struct ufs_hba *hba;
 	struct ufs_pa_layer_attr dev_req_params;
-	struct clk *rx_l0_sync_clk;
-	struct clk *tx_l0_sync_clk;
-	struct clk *rx_l1_sync_clk;
-	struct clk *tx_l1_sync_clk;
+	struct clk_bulk_data *clks;
+	u32 num_clks;
 	bool is_lane_clks_enabled;
 
 	struct icc_path *icc_ddr;
-- 
2.25.1

