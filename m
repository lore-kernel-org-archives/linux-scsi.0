Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1047932ED54;
	Mon, 27 Jul 2026 10:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785146421; cv=none; b=aJxKnpgHA4pV9C9GY/izMiunU5Of5BdVDYMXkg4h3u6IGB7QsriGFzT4ImLVjmt3ovTKVUpw8fmGyI9I7ZA5DkpEzp0z7ZWbV9rp6CP0149+C59sk7cIQd5KuC7E9RrDUC5slE+mQuG8h2xeG0RGhIW3OfoQgf7zr/1ZM1V2kQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785146421; c=relaxed/simple;
	bh=N4BclUrBZuf3nhwGAo9oU+63lvzO6n8jgltahRZuo+s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fHCekHjqCbXQuO1k07sDb9bc4JEutGbw68sLMtr3ahHMO+KuoPwklKMRi+3ESnTx1a8TA1AJw1+p8wvtiOizrwm9g4WmhBGDJZLHt63eIxpLgYIn+j6sqHZgk6unZ1KvvsGgo7TjWg3eao8euIZvTjbxgISoz5mfiMGpB+BHzmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hyZlBvQQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hyZlBvQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04F51F00A3A;
	Mon, 27 Jul 2026 10:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785146419;
	bh=bZ6CrNt1h3fSjGPvsb+y6S3SjB/kGZ3lPPdIV0Hb5tc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hyZlBvQQxrFTEEcBnkYjGrMHV2oEKCcqj17nzQ3w9rEytyTd/4Uuh/7U94dFZ8NOv
	 mMETzoGTLbT33h7oKR4aOouoRqssgyT/j5gWMsGooHrkqtReHXjdZihJ4zY+ZxEadU
	 QY+hGzc1eCgAfLe+6pl+ZTtkpCLvBUj5R1NAkWNB1LOufLDBcAHoQYbb/eY7sHl4nw
	 68bLl5zeM1RqOZOpTB9PnFFapW9X9HU+NO9TMLLSpb5ivt8Q/hg3tML4h8UzG+W0DG
	 8itu+NKH4d/dDyNxq4M8U2DJHhV9q5b+66wFmXimLYDWJlFpmeGUbOU7FebPbo1oWN
	 pl2ArAlVh89rw==
From: Konrad Dybcio <konradybcio@kernel.org>
Date: Mon, 27 Jul 2026 11:59:29 +0200
Subject: [PATCH v5 3/3] soc: qcom: ubwc: Get HBB from SMEM
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-topic-smem_dramc-v5-3-66188b3e338d@oss.qualcomm.com>
References: <20260727-topic-smem_dramc-v5-0-66188b3e338d@oss.qualcomm.com>
In-Reply-To: <20260727-topic-smem_dramc-v5-0-66188b3e338d@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Kees Cook <kees@kernel.org>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, Sean Paul <sean@poorly.run>, 
 Akhil P Oommen <akhilpo@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Mike Leach <mike.leach@arm.com>, 
 James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>, 
 Mao Jinlong <jinlong.mao@oss.qualcomm.com>, 
 Jie Gan <jie.gan@oss.qualcomm.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-hardening@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 freedreno@lists.freedesktop.org, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, linux-scsi@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 coresight@lists.linaro.org, devicetree@vger.kernel.org, 
 linux-riscv@lists.infradead.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785146373; l=2414;
 i=konrad.dybcio@oss.qualcomm.com; s=20230215; h=from:subject:message-id;
 bh=3LNXtkpagxbE+R6g/oNsy+x+7/74GUn/00p/SQ/cYlM=;
 b=yYCXvrrf7qggR4qk6JjiS9Z2+iFrl+PooPtV0kAczRrNWh/Q57LN8vjkIassppHjv6qeScn0S
 WfN0WoTwFTuAEmJmP7Szvpl9QNL+0n/rjYpzMvDuovur7WRGHLePIHO
X-Developer-Key: i=konrad.dybcio@oss.qualcomm.com; a=ed25519;
 pk=iclgkYvtl2w05SSXO5EjjSYlhFKsJ+5OSZBjOkQuEms=

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

To make sure the correct settings for a given DRAM configuration get
applied, attempt to retrieve that data from SMEM (which happens to be
what the BSP kernel does, albeit with through convoluted means of the
bootloader altering the DT with this data).

Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
---
 drivers/soc/qcom/ubwc_config.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/ubwc_config.c b/drivers/soc/qcom/ubwc_config.c
index 0209a02c390f..23901a4c51f7 100644
--- a/drivers/soc/qcom/ubwc_config.c
+++ b/drivers/soc/qcom/ubwc_config.c
@@ -11,6 +11,7 @@
 #include <linux/platform_device.h>
 
 #include <linux/soc/qcom/ubwc.h>
+#include <linux/soc/qcom/smem.h>
 
 static const struct qcom_ubwc_cfg_data no_ubwc_data = {
 	/* no UBWC, no HBB */
@@ -168,9 +169,25 @@ static const struct of_device_id qcom_ubwc_configs[] __maybe_unused = {
 	{ }
 };
 
+static struct qcom_ubwc_cfg_data *cfg;
+static DEFINE_MUTEX(cfg_mutex);
+/**
+ * qcom_ubwc_config_get_data() - Retrieve UBWC data for the platform.
+ *
+ * Return: Pointer to valid struct qcom_ubwc_cfg_data on success, negative
+ * errno on failure. Note that this may return EPROBE_DEFER.
+ */
 const struct qcom_ubwc_cfg_data *qcom_ubwc_config_get_data(void)
 {
 	const struct qcom_ubwc_cfg_data *data;
+	int hbb;
+
+	guard(mutex)(&cfg_mutex);
+	if (cfg)
+		return cfg;
+
+	if (!qcom_smem_is_available())
+		return ERR_PTR(-EPROBE_DEFER);
 
 	data = of_machine_get_match_data(qcom_ubwc_configs);
 	if (!data) {
@@ -178,9 +195,30 @@ const struct qcom_ubwc_cfg_data *qcom_ubwc_config_get_data(void)
 		return ERR_PTR(-EINVAL);
 	}
 
-	return data;
+	hbb = qcom_smem_dram_get_hbb();
+	if (hbb == -ENODATA) {
+		/* Lack of HBB data is OK - it was only introduced later */
+		return data;
+	} else if (hbb < 0) {
+		pr_err("Couldn't get HBB data from SMEM: %d\n", hbb);
+		return ERR_PTR(hbb);
+	}
+
+	cfg = kmemdup(data, sizeof(*data), GFP_KERNEL);
+	if (!cfg)
+		return ERR_PTR(-ENOMEM);
+
+	cfg->highest_bank_bit = hbb;
+
+	return cfg;
 }
 EXPORT_SYMBOL_GPL(qcom_ubwc_config_get_data);
 
+static void __exit ubwc_config_exit(void)
+{
+	kfree(cfg);
+}
+module_exit(ubwc_config_exit);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("UBWC config database for QTI SoCs");

-- 
2.55.0

