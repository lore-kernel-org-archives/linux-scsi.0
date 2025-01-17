Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056B542AA6
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2025 14:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737123546; cv=none; b=T+vFTK4uyzDwi/bW2JMvVWKEfefZgag/6pLuhKAQVpv0yDrleEasjZAVZBM52MorAuhT9Gdx/2zjTTHcSe05XwQDmveGsEMiNaHPZPrMNP6VkXfJKCWYOZ+x4Zy1sEPwD80nYCsBeuW5lsi38M5rJq5W3zOsK6aPl0l57ZwZ0ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737123546; c=relaxed/simple;
	bh=yG8sQ+nx9Eqw58/wd8HyjrYz0XP+TABX6QtHMArWsyc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=l0jyFbP73khyvfmkd0+EZB/OOERSXI1UB6866H5po7wUyYTmsJMeshlloO6n5ZDtxm1Qhb+ykb4i47nPSrTDelESYG9FvwS/tuhrFE02fwStWDmEDnC5PcxJzthI/VWpdMVW9igG4ur+nVugT2ZXwq5cHgqNmgSCZCkXaHC0VHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MQjFAArJ; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MQjFAArJ"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-436326dcb1cso14461505e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2025 06:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737123543; x=1737728343; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EJPpzjW5eAxwdMtWI5K0l8mGr8BTWJyLsOuy62grEjQ=;
        b=MQjFAArJ1oQ+XiFb01gGlTaIwCMUZ6/eaMswdNPVP+UdM4o40QJIZ4veg5VEDYPmQr
         rqAfDKhj6MqIX9tbOcrFqqSazHgM4yVeVSxd/EfGt6mXhtqPCfZM5R0DLPdP8yiFCZ17
         Kx9vl30rfvYaAXHn0vcf3taVGqhhTjRjDGitTyNd/hgDt4nojy7Qh/SCf+5cOAMp8CkQ
         3tt2jSRMbsKP2b05Gtt2sHxfOhBm5r+cMNjiSF2FsKE/8alqqr1SWsEgCeWPtC0ZRjmU
         Ya/WH5kkPKpvsK8gPA+iFvsDM4+IjtZWAjF+U61lLe7x8RdrIUZ9jMpak0Pgd0skveDP
         VQAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737123543; x=1737728343;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EJPpzjW5eAxwdMtWI5K0l8mGr8BTWJyLsOuy62grEjQ=;
        b=FG3ZPKVDmBoVUn5fTuJHI/u4gMiQ3douTF9YWqoHf6oN7KcuYjqESkxB+R18rVCJqB
         aEavjd+/Bt0H6BfelxkjyMDQ/NbqqeZTEz4Iz7JFNEQyslcNL/5bqASPVHNB1ovaPo6a
         WYBM8/0ZP6CcYG99RpJIaY+elK5pUUCaOSyZBcUvhZxKoGA6SxfQmozj2dYv12rqPIsX
         GKKDTkrZu86lz2KFirUzAee0Sl/CvOmrwOL7UBlknX2HmwAxeKV8iW94A+eNaLiWjuOq
         CqHHBg00zWQo4ZFYVew7uB+TTwqpyeRyt+NtF+kmBsUerVwMFjR50fEongEgZYZfRWS2
         8Fkw==
X-Forwarded-Encrypted: i=1; AJvYcCWn/f3wPY0gTS/2OrsvrDqBg6M+e/V5ZKg+DRAIDgs9J8wNdVcHmtKppMpYqARKnyY8T10z/zZ8pOQZ@vger.kernel.org
X-Gm-Message-State: AOJu0YyJXopmSqD3tED30aJcVq1aEMQNw5CCvlE0u0h8WgyLHeZLTB1A
	bmTF+/mUQiEs3RI/hmUS8zDEfsk1DuTWLXJ5WvFehrE0wIXfQeJ2D3PkbowZiMw=
X-Gm-Gg: ASbGncvFOJXZxcqcKX0rNjvGDnbNpi8DQaZcAKgD6ROomcx7qbOvU9jylcgCtLdOIuT
	z30Njh+vBlveVkks5O+o4V33FbkBXzllathDZEHgJMCnZKDUAxk447LZkRpMgLZlD/S9oi6kArC
	KB3/RZRVgCN483KyEUnE1L1VP/JOOxdv6JOUUZvNb3xO8F3jTuQ5qwzP5Ymeg6Rg6jFMMu/0mjI
	q2X/9ex9b+yiHYK3NesS/2F9xdrZ1O8+lzsMuPk7vTG8E4OLM7EX6kDH7UTVPIML5UCnLOyrXTo
	wHqlZ5oLKhOv1/LuZe2904DtDt0vxc4PuIML
X-Google-Smtp-Source: AGHT+IG5K3FNsGuzWqRixT4OiMWoWe6dLCzIRKc7oOU3K/CehjLULkM8EVMs4EBMJ03fSNI8Cqn0wA==
X-Received: by 2002:a5d:4e86:0:b0:38b:d824:df3 with SMTP id ffacd0b85a97d-38bf57890e3mr2043468f8f.24.1737123543332;
        Fri, 17 Jan 2025 06:19:03 -0800 (PST)
Received: from ta2.c.googlers.com (169.178.77.34.bc.googleusercontent.com. [34.77.178.169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c74995f6sm96764195e9.1.2025.01.17.06.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 06:19:02 -0800 (PST)
From: Tudor Ambarus <tudor.ambarus@linaro.org>
Date: Fri, 17 Jan 2025 14:18:50 +0000
Subject: [PATCH v2 1/4] soc: qcom: ice: introduce devm_of_qcom_ice_get
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250117-qcom-ice-fix-dev-leak-v2-1-1ffa5b6884cb@linaro.org>
References: <20250117-qcom-ice-fix-dev-leak-v2-0-1ffa5b6884cb@linaro.org>
In-Reply-To: <20250117-qcom-ice-fix-dev-leak-v2-0-1ffa5b6884cb@linaro.org>
To: Krzysztof Kozlowski <krzk@kernel.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Ulf Hansson <ulf.hansson@linaro.org>, Abel Vesa <abel.vesa@linaro.org>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Eric Biggers <ebiggers@google.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 andre.draszik@linaro.org, peter.griffin@linaro.org, willmcvicker@google.com, 
 kernel-team@android.com, Tudor Ambarus <tudor.ambarus@linaro.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737123541; l=2995;
 i=tudor.ambarus@linaro.org; s=20241212; h=from:subject:message-id;
 bh=yG8sQ+nx9Eqw58/wd8HyjrYz0XP+TABX6QtHMArWsyc=;
 b=XYQFpfWRMZlFbEbuuaOCZ4aYKbikkwMh7NOh050v6RV5pq7o3U3s8DytNgIi/EzzIkR8kxinl
 Olkd6PT8mK+CLzSZcBzMMXEmMb1XtCif7d7l2h9XI0JbH14ZTKpkBWo
X-Developer-Key: i=tudor.ambarus@linaro.org; a=ed25519;
 pk=uQzE0NXo3dIjeowMTOPCpIiPHEz12IA/MbyzrZVh9WI=

Callers of of_qcom_ice_get() leak the device reference taken by
of_find_device_by_node(). Introduce devm variant for of_qcom_ice_get().
Existing consumers need the ICE instance for the entire life of their
device, thus exporting qcom_ice_put() is not required.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 drivers/soc/qcom/ice.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/soc/qcom/ice.h |  2 ++
 2 files changed, 50 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 393d2d1d275f..79e04bff3e33 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -11,6 +11,7 @@
 #include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/device.h>
 #include <linux/iopoll.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
@@ -324,6 +325,53 @@ struct qcom_ice *of_qcom_ice_get(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(of_qcom_ice_get);
 
+static void qcom_ice_put(const struct qcom_ice *ice)
+{
+	struct platform_device *pdev = to_platform_device(ice->dev);
+
+	if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice"))
+		platform_device_put(pdev);
+}
+
+static void devm_of_qcom_ice_put(struct device *dev, void *res)
+{
+	qcom_ice_put(*(struct qcom_ice **)res);
+}
+
+/**
+ * devm_of_qcom_ice_get() - Devres managed helper to get an ICE instance from
+ * a DT node.
+ * @dev: device pointer for the consumer device.
+ *
+ * This function will provide an ICE instance either by creating one for the
+ * consumer device if its DT node provides the 'ice' reg range and the 'ice'
+ * clock (for legacy DT style). On the other hand, if consumer provides a
+ * phandle via 'qcom,ice' property to an ICE DT, the ICE instance will already
+ * be created and so this function will return that instead.
+ *
+ * Return: ICE pointer on success, NULL if there is no ICE data provided by the
+ * consumer or ERR_PTR() on error.
+ */
+struct qcom_ice *devm_of_qcom_ice_get(struct device *dev)
+{
+	struct qcom_ice *ice, **dr;
+
+	dr = devres_alloc(devm_of_qcom_ice_put, sizeof(*dr), GFP_KERNEL);
+	if (!dr)
+		return ERR_PTR(-ENOMEM);
+
+	ice = of_qcom_ice_get(dev);
+	if (!IS_ERR_OR_NULL(ice)) {
+		*dr = ice;
+		devres_add(dev, dr);
+	} else {
+		devres_free(dr);
+	}
+
+	return ice;
+}
+EXPORT_SYMBOL_GPL(devm_of_qcom_ice_get);
+
 static int qcom_ice_probe(struct platform_device *pdev)
 {
 	struct qcom_ice *engine;
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index 5870a94599a2..d5f6a228df65 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -34,4 +34,6 @@ int qcom_ice_program_key(struct qcom_ice *ice,
 			 int slot);
 int qcom_ice_evict_key(struct qcom_ice *ice, int slot);
 struct qcom_ice *of_qcom_ice_get(struct device *dev);
+struct qcom_ice *devm_of_qcom_ice_get(struct device *dev);
+
 #endif /* __QCOM_ICE_H__ */

-- 
2.48.0.rc2.279.g1de40edade-goog

