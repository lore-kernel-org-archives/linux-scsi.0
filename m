Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EF0127B6A
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 12:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712233588; cv=none; b=kFr5xjgDzpkDNoP2MdRoDwe5CtDE3f5MIFCR5DbVKtjmkLKkdndsSItJyv8QpHQMZW7/lwLtQWTAi904SHZzd8vJ+rFuoYQBvCHuFNmhkE/4Iu52QDjUZdP8LhpRMLezKI6x7/2LZAIgsuST0yZHAw1S64xiXF8hk2T4HMihUsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712233588; c=relaxed/simple;
	bh=hmBS3wUHO0mONt4FlN4wFgGGwPzu6YR45Hg+n9iZFDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6VAxNiMYuFoHaZm2u+qLEybDiyVmjnaKsHtwvhF5L+xRSH+3hTZRaKRYaQ2ONiNpzYa6zvTDOGfJ0z+s605Df2zq+gU6/nf07DDZPoiXl+4ixsOPUbvvuETpbSYUkjq3bgqnaus1Qp+SJdYHjAlR3LdR3IUrOXPp1qnkUcQF6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gMVIZZWi; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gMVIZZWi"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3437efea0ecso657132f8f.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Apr 2024 05:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712233584; x=1712838384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXMXdhzuoLCLynIjoXzQvanMKsFRKu7E/3G3H+50quM=;
        b=gMVIZZWi1z2FkhN00xQ+9vw0OIo8cysxMi1K7veW43FyRARjY0LAKrwqdvWOL0ACmQ
         h87Vk9Z67FyZAJ7ooIL1l95eXG7TZxG29nqqc3NHBOte/N/rn2VKTT58WkEsLPq4UjoP
         tbKqE2eNEF8UGuTfN+R7d80PcLP0d2tP8CTApvdkXUEbKGyLFuG8LyiMp7I7C6ZAfsOZ
         fmZ+pwXoB/TW14/ree+87TxWxgAY4U6jCEOTYu7e7aqmE2nc92+brfKiEwCHbgyJLQhf
         LdqplzbB2SiIi6COgJNg4zBIesqMqEV32VxyjW10sBS801e6atOE9FHCgcxmP7fxRUHP
         purQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712233584; x=1712838384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cXMXdhzuoLCLynIjoXzQvanMKsFRKu7E/3G3H+50quM=;
        b=s6zZ7RMZP98eyOO1acFT4zWj9sOf6CiIyjwySOvQKjTkz5oENUvhTPpKbvlw4p6IZI
         ItPe63oLMpXjVV/wmHZsuV3pHV120CKaec3QAwG4DUmpCH1EpmEihsQSr+wKLwuXv+mE
         HQCLXjRo2VccBU/icP0ekpmhWnaAqKXPqwxeVfLOFshjAqh37A54tWS8sWb429wk85Ze
         g/jNNhGRrrTGmtdiIOV/M6WFmD657iv8nMqaVj9ItPmfS8SyDo6qyvpsVvhzhYkiYGYY
         PwYP2LY7guhs+bkouIqvLQFZULutJ1Cvt1TjZ4+tovnu0+6CfNnprOLcpz1GQBRJulSb
         t47w==
X-Gm-Message-State: AOJu0YwfL1EfQrf7JmeO6/daLWDws43tPSNM471IdB2RBanub9kDURvn
	7zAf/FbDIzTdzYkmJmSVRq61pKLpRqzGt7C8B+NfQZuNsSCncTbY3f0ToyuE/J0=
X-Google-Smtp-Source: AGHT+IEApEjUKboR0OBWLDTAS6Jxlk1eQTEdQEi/Xza6SHa5181j+IZCoUEpXbG45sbONQ13Dr267A==
X-Received: by 2002:a5d:60ce:0:b0:343:9189:e685 with SMTP id x14-20020a5d60ce000000b003439189e685mr1644596wrt.48.1712233584399;
        Thu, 04 Apr 2024 05:26:24 -0700 (PDT)
Received: from gpeter-l.roam.corp.google.com ([148.252.128.204])
        by smtp.gmail.com with ESMTPSA id bu14-20020a056000078e00b003434b41c83fsm12106303wrb.81.2024.04.04.05.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 05:26:23 -0700 (PDT)
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
Subject: [PATCH 02/17] dt-bindings: soc: google: exynos-sysreg: add dedicated hsi2 sysreg compatible
Date: Thu,  4 Apr 2024 13:25:44 +0100
Message-ID: <20240404122559.898930-3-peter.griffin@linaro.org>
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

Update dt schema to include the gs101 hsi2 sysreg compatible.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 .../devicetree/bindings/soc/samsung/samsung,exynos-sysreg.yaml  | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/soc/samsung/samsung,exynos-sysreg.yaml b/Documentation/devicetree/bindings/soc/samsung/samsung,exynos-sysreg.yaml
index c0c6ce8fc786..3ca220582897 100644
--- a/Documentation/devicetree/bindings/soc/samsung/samsung,exynos-sysreg.yaml
+++ b/Documentation/devicetree/bindings/soc/samsung/samsung,exynos-sysreg.yaml
@@ -15,6 +15,7 @@ properties:
       - items:
           - enum:
               - google,gs101-apm-sysreg
+              - google,gs101-hsi2-sysreg
               - google,gs101-peric0-sysreg
               - google,gs101-peric1-sysreg
               - samsung,exynos3-sysreg
@@ -72,6 +73,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - google,gs101-hsi2-sysreg
               - google,gs101-peric0-sysreg
               - google,gs101-peric1-sysreg
               - samsung,exynos850-cmgp-sysreg
-- 
2.44.0.478.gd926399ef9-goog

