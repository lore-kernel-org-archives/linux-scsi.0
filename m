Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04D01B423B
	for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2025 15:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742398242; cv=none; b=RPU0nwLE7+GTgm+A3UzLs462I+BQOZCsihsJ5ZN1OLg4VDAye93flQlJEMTBmvIAnNkubIszAHZP4747tGBOZFUYn8rgLv+5jL/ef1eT31Q/6A73woEq50g0d9aXcU5xNplU3mZqoWdtGoyJh/BPzBao1SRS2O2SZJa4EO2VuSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742398242; c=relaxed/simple;
	bh=yJnKhyDbjuMSM1Ff1EJun3ay62EPsTJc6TdUJCfxORQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=F13A6OeNETCj2xNu54ux79Pkx1Ee4znmR/9KVmJXja2bcn+c8N4/+SH5YtnMutTHBBQWB2bKUuqSxFxSzT0FhTCRwRezPfDdXHeZzRZwdmnXwGiRPzJkHFWyVYhqumQWYpMLiejGRranaLW4aqciQZiG1haWIyfUSYW9Q9jNZlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ksiAIyL9; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ksiAIyL9"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43cfebc343dso34330575e9.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2025 08:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742398239; x=1743003039; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PbHlg80z6jqmhLLd1L66LTBtWxEQiwbO7Uhwer7oAeU=;
        b=ksiAIyL9YSVTVGHtzrvp7irdvR7lW564chAoJu9ZSVU/Kv4HtaidPmdmO5TShuUEiX
         AJ3TG7/zQ3Q8WZoMcwO3lU9qUGtdG/oAtp8gNg+52O33mxl164uzQAJJYfgHjkVSuBqM
         NWEN3twW4qZ0z9cbp7+P48h4lSxiTuNUjmox/j2my6Q7axeI1T1sFojL7StuUWNQEIvh
         XmyfVOGUIKtABTHB5ybBVljMx2By5nw9o99SmaVvj6HfGi72x9TEcyVGeVN7wP2dyzvL
         q14i7D2k9pDW4E05Fgglc0LQ4zxdzIIWESZT035174AMDlBjlyoNugBBn97qYAFqanxY
         z7+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742398239; x=1743003039;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PbHlg80z6jqmhLLd1L66LTBtWxEQiwbO7Uhwer7oAeU=;
        b=T2ndh2PBjqhprm8AlZFbLWtjYAwLxx9e28K8FHj5G30d9yGuxMDfy134/yEDEqbFve
         QBpkPwocd5fqMS8E0Quqjhyo546ug98K70EXvuPPzwtmrFP9K4HWPbiKAORQ16VIWNa7
         PGEOGMt0N2NmjACmXQmiKgsOTz1GujnnU2cyVmBgUdGXrvOqiyCo4gjhqZpJYSs6e01g
         yQwh5BNtokGkQ2NcdwAkLtkj9y5ZGxPJGzuNI1rI9x0EqS+iHDA75xH1j1aQDf6RpXi2
         OdIa8W4Je7EPNXlDD9CuyHUFJIB6dYgVet13lRm01/G4obI23qRG9OqvZNNItWMBAIIB
         oBpA==
X-Gm-Message-State: AOJu0YzuAIWuEeZIG+yLa60kYPnm3HcRATcWdrCKL3YIbhaGz7ckug0h
	uKWwIH0MO0gTqQE7t23KSblUkcdeVxrADhxS35Yi6MOukmS4muIW0c5JvnGCLoo=
X-Gm-Gg: ASbGncuRDL8fBCNyW+VJOqmQV7NyCBpo3qjbNOBdRxbihKQmIdDhbDbfW7/Hfgddslm
	B6Tofcvh5y+/eMkGkltiRk18sZhJgWZdzhke9VLrU+FOfgfFewTmzkZciNj31F3x54Ns5mzKKl7
	l/+wW+ZWd/Y7dmEai3PaEVcRcwVCxAvrqnahcx1meSLm1yOzv3yKRVCuJt79frUspmNu4VuiW/X
	voFZ3pzjsKFqXVEB3kKUJ3l1+Pdk+cBpCpZlzGV2niwYc56VD0x1uEqnCDKaxGGMNBy2eu0CKxe
	PTTC8/yqnQeNN7EOohbPWzv7PwzfuC1kXKQXb3cWb8ktgxwyYHipIVEgfCaMmcIpPa+YrbX3chR
	Z
X-Google-Smtp-Source: AGHT+IFH6HDxs5aq0bCI3BQSvyCek2NUloG5zCiL2aSkRDxgyBByvj1TpypZ0XveUFi/4iUswd0wtg==
X-Received: by 2002:a05:600c:b95:b0:43c:fe15:41e1 with SMTP id 5b1f17b1804b1-43d437801e2mr30519805e9.4.1742398239241;
        Wed, 19 Mar 2025 08:30:39 -0700 (PDT)
Received: from gpeter-l.roam.corp.google.com ([212.105.145.136])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43fdaca8sm22590635e9.28.2025.03.19.08.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 08:30:38 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
Date: Wed, 19 Mar 2025 15:30:24 +0000
Subject: [PATCH v2 7/7] scsi: ufs: exynos: gs101: put ufs device in reset
 on .suspend()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250319-exynos-ufs-stability-fixes-v2-7-96722cc2ba1b@linaro.org>
References: <20250319-exynos-ufs-stability-fixes-v2-0-96722cc2ba1b@linaro.org>
In-Reply-To: <20250319-exynos-ufs-stability-fixes-v2-0-96722cc2ba1b@linaro.org>
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Krzysztof Kozlowski <krzk@kernel.org>, 
 Chanho Park <chanho61.park@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, 
 Eric Biggers <ebiggers@kernel.org>, Bart Van Assche <bvanassche@acm.org>, 
 willmcvicker@google.com, kernel-team@android.com, tudor.ambarus@linaro.org, 
 andre.draszik@linaro.org, Peter Griffin <peter.griffin@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2297;
 i=peter.griffin@linaro.org; h=from:subject:message-id;
 bh=yJnKhyDbjuMSM1Ff1EJun3ay62EPsTJc6TdUJCfxORQ=;
 b=owEBbQKS/ZANAwAKAc7ouNYCNHK6AcsmYgBn2uMSwowE0bRT4zvqbxBWw9dUeVGZZKu4Ym7xN
 +fcA14VK/2JAjMEAAEKAB0WIQQO/I5vVXh1DVa1SfzO6LjWAjRyugUCZ9rjEgAKCRDO6LjWAjRy
 unRwEACNFynmoh/Od8OsSL+v+R3VOZ5EhLQWh/zEalRrVfSznj7xGHHOO+QGYWXTh9SBvPi39Lh
 /ixcq4t1wpzvy+7dTB2YncN1A41ca+Uc1qRAU1d3ClP9dINkx2Z3CEViuynkL89pmfIXlg17eOa
 1ZHC+8L924hsjNI9wd0bZZ6QYfE6z/ga2jKUtE84/ZCtGLA04ceOiYMVrzosqjAsQYxM01iTKEt
 sF7z65HxIPtt0Ap/ZOa6b6Q+QlTpOi1ViVHWnyelTmsHUrbOHDCmd/+HaiI6KPiVEUOXVpjiyu/
 c3NLTuPpQWuoAK5/J1uQUF/xM4vmGK1peAkGACze4eDJYKDilAJyPEe6yPbXGrcIuDWYW16ivhO
 U+qf1zDabJw3EBU86Dr6p4OWJjyX1EaNULwwKRS+z6AVHyxmeUL2G5S90/7lLJwxo2iJy7qxKF4
 GED2oZxQxxGUSlFsLCUZ2OJgp887kZIEde5HCP5Fpccz8qwihbrCKi2q0HXqZ12VqEtMltfXk0R
 e/EwXltRRYJeguCopXeJtSkUsFShyOAm6jbpggId+H7NiGvcqw5mqfG8RHbP/kIm0y2jlgr/Ip7
 IAj/USYA+81iCutxZJ+fmVYvl5qZ/vSX1N19HtcFHVXjnxHImUwYLCxDr2K7ETIqw2CN8psTenQ
 1pAbZohC7qCMHpw==
X-Developer-Key: i=peter.griffin@linaro.org; a=openpgp;
 fpr=0EFC8E6F5578750D56B549FCCEE8B8D6023472BA

GPIO_OUT[0] is connected to the reset pin of embedded UFS device.
Before powering off the phy assert the reset signal.

This is added as a gs101 specific suspend hook so as not to
have any unintended consequences for other SoCs supported by
this driver.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
Changes since v1:
 * Add a gs101 specific suspend hook (Bart)
 * Drop asserting GPIO_OUT in .exit (Peter)
---
 drivers/ufs/host/ufs-exynos.c | 10 ++++++++++
 drivers/ufs/host/ufs-exynos.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 81a1f04411c0426d6fae931e75db5f4c8693daca..3e545af536e53e06b66c624ed0dc6dc7de13549f 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1701,6 +1701,12 @@ static void exynos_ufs_hibern8_notify(struct ufs_hba *hba,
 	}
 }
 
+static int gs101_ufs_suspend(struct exynos_ufs *ufs)
+{
+	hci_writel(ufs, 0 << 0, HCI_GPIO_OUT);
+	return 0;
+}
+
 static int exynos_ufs_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 	enum ufs_notify_change_status status)
 {
@@ -1709,6 +1715,9 @@ static int exynos_ufs_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 	if (status == PRE_CHANGE)
 		return 0;
 
+	if (ufs->drv_data->suspend)
+		ufs->drv_data->suspend(ufs);
+
 	if (!ufshcd_is_link_active(hba))
 		phy_power_off(ufs->phy);
 
@@ -2171,6 +2180,7 @@ static const struct exynos_ufs_drv_data gs101_ufs_drvs = {
 	.pre_link		= gs101_ufs_pre_link,
 	.post_link		= gs101_ufs_post_link,
 	.pre_pwr_change		= gs101_ufs_pre_pwr_change,
+	.suspend		= gs101_ufs_suspend,
 };
 
 static const struct of_device_id exynos_ufs_of_match[] = {
diff --git a/drivers/ufs/host/ufs-exynos.h b/drivers/ufs/host/ufs-exynos.h
index a345809af79dc528ad518d3572fe8be034341ee0..abe7e472759e94fef353e9a97bc9b55f6a0324c1 100644
--- a/drivers/ufs/host/ufs-exynos.h
+++ b/drivers/ufs/host/ufs-exynos.h
@@ -192,6 +192,7 @@ struct exynos_ufs_drv_data {
 			       const struct ufs_pa_layer_attr *pwr);
 	int (*pre_hce_enable)(struct exynos_ufs *ufs);
 	int (*post_hce_enable)(struct exynos_ufs *ufs);
+	int (*suspend)(struct exynos_ufs *ufs);
 };
 
 struct ufs_phy_time_cfg {

-- 
2.49.0.rc1.451.g8f38331e32-goog

