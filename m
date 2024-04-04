Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D7F130E27
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 12:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712233627; cv=none; b=idOzPBkLpK2Zkz63Ib9Y0CnLOPO/230TSAlHaf/K4a5EUuYzQmQ45KU1OdsOmFMr5EjoyzS41wz1nduFYHB85Ta1wPxsNSDE8v0kWtI0cujCuVWtXptpuyEeFw/c8Gaa4FbVyPV+vlKtCJGEtOIKUZxULb3ldvqfnEKiq0BO8cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712233627; c=relaxed/simple;
	bh=j9cqp4SjYW9U7WgZ0V/m18CHVeS7hsHpCyHSSMK1LiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0BdzHfdSY8yHn6dJqmGad8kRUACfXaTupQpTPX7IDH5LQWuMEu5GRtcBUZtPR5Zvf7a/u9wDUIODMTxy9v0Bi59clCFMRQm9Jeh43ys2r1zArf1BJQemAaZ/c7DL5vnqEfieWe35GDMChl7P02eWumhDBnlXpvhNqAghkp8hYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YPAB7fSr; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YPAB7fSr"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3438d7a05aaso544248f8f.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Apr 2024 05:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712233624; x=1712838424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j8M8yJjJuvMId3GZYZjS1l/TGkga5FhjqBUO4vnkd2U=;
        b=YPAB7fSrUcV0N8QmAbhAt5eNLqlDfqSZ/b+DA/N996tJpdVLQVxbcaksHQ6y/o0YdI
         g33VQUJZoM8JbRwy/I4nzG91j33Z/wxBWrrExjSDMFln2VPnl8WiPWdA86LtPZIQZJ7Z
         KmhYZBN8HN+WSNWoqOSEBoQ/GYh9gSmCHUd11orypQr/VrMwKxpB1G5ZjAPVoLf3L7Ym
         Uhje9iWDultzBVmIKjJLa8ESUfBoeCoyY6ooce1p+uJwgd58s/g1FNG6U9Yr7gfdVm8f
         2TT/ifpq0Vbp/L8cQB4NlKImLP/5aXcH27vsm/CPRjdQQezhxTchIG97YVM1j0pLMQr1
         wf2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712233624; x=1712838424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j8M8yJjJuvMId3GZYZjS1l/TGkga5FhjqBUO4vnkd2U=;
        b=cglXT1SsnrGqJcppcWWklirn/9TQPWEVPh/LP8WlpFtANPCwXroNC80s9h2oBi2Aiy
         p16IeYCJRwFnfYq2gQnpizjUeA/K2jEeN5C0MZZETBV9gcW2955fRFB+ZGd4rBKbXN0q
         NYNHcImaqvDl66sVIzrD70TG/eddISnvsSzLuEvUR//SZHrhEEgq8YgACC51P4RgHwxB
         SuN6kADaACXNoBWTqIBtqrNE5vaCHX3RBX754+N03SYb1qO4JH+ZYGF2Tk8E/mmTW33Y
         PTo/hEAMSzrk6bgudhKnks8wcAOL2v2qnEVTcY51i4x97wVwIhP42uraRsZaoZP54uju
         MsQA==
X-Gm-Message-State: AOJu0YzWZU2J18Dlqq0xUWwVyJMROGBMf4JjbG5IHZR9/hRG0s/8iMlv
	YCsYRB/NSKs1V/WJ9GtnWkiR2TVLA3s9znDkcT1WCVQ/+hPpd6fYHgjEQNZH7ag=
X-Google-Smtp-Source: AGHT+IEexjP4B7taUG1Uny4tFgGyVFyyDBsJMVaOWIrgfE/nQ60oagnYHJl04Il3/SGN/3eIZeAILg==
X-Received: by 2002:adf:ee90:0:b0:343:83a8:96e with SMTP id b16-20020adfee90000000b0034383a8096emr2374666wro.8.1712233624515;
        Thu, 04 Apr 2024 05:27:04 -0700 (PDT)
Received: from gpeter-l.roam.corp.google.com ([148.252.128.204])
        by smtp.gmail.com with ESMTPSA id bu14-20020a056000078e00b003434b41c83fsm12106303wrb.81.2024.04.04.05.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 05:27:03 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: mturquette@baylibre.com,
	sboyd@kernel.org,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	vkoul@kernel.org,
	kishon@kernel.org,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	s.nawrocki@samsung.com,
	cw00.choi@samsung.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	chanho61.park@samsung.com,
	ebiggers@kernel.org
Cc: linux-scsi@vger.kernel.org,
	linux-phy@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-clk@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	tudor.ambarus@linaro.org,
	andre.draszik@linaro.org,
	saravanak@google.com,
	willmcvicker@google.com,
	Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH 09/17] phy: samsung-ufs: use exynos_get_pmu_regmap_by_phandle() to obtain PMU regmap
Date: Thu,  4 Apr 2024 13:25:51 +0100
Message-ID: <20240404122559.898930-10-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
In-Reply-To: <20240404122559.898930-1-peter.griffin@linaro.org>
References: <20240404122559.898930-1-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This allows us to obtain a PMU regmap that is created by the exynos-pmu
driver. Platforms such as gs101 require exynos-pmu created regmap to
issue SMC calls for PMU register accesses. Existing platforms still get
a MMIO regmap as before.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/phy/samsung/phy-samsung-ufs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/samsung/phy-samsung-ufs.c b/drivers/phy/samsung/phy-samsung-ufs.c
index 183c88e3d1ec..c567efafc30f 100644
--- a/drivers/phy/samsung/phy-samsung-ufs.c
+++ b/drivers/phy/samsung/phy-samsung-ufs.c
@@ -18,6 +18,7 @@
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
+#include <linux/soc/samsung/exynos-pmu.h>
 
 #include "phy-samsung-ufs.h"
 
@@ -255,8 +256,8 @@ static int samsung_ufs_phy_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	phy->reg_pmu = syscon_regmap_lookup_by_phandle(
-				dev->of_node, "samsung,pmu-syscon");
+	phy->reg_pmu = exynos_get_pmu_regmap_by_phandle(dev->of_node,
+							"samsung,pmu-syscon");
 	if (IS_ERR(phy->reg_pmu)) {
 		err = PTR_ERR(phy->reg_pmu);
 		dev_err(dev, "failed syscon remap for pmu\n");
-- 
2.44.0.478.gd926399ef9-goog

