Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE99146D6A
	for <linux-scsi@vger.kernel.org>; Fri, 26 Apr 2024 12:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714134017; cv=none; b=U0Bto7JmvYms2j009UkjmiTz+jJXOa8kqKbLiIByhDkj3xlQIycsRE14Ozw1HySXY+rqtlhBC4KmT6QqlRacFHrUOaqWvZLFPVO+fJ6eZj1zwPTNjyPwJ6fFYWEVmmXa/bVh2MQfgjVFJDOPaMc17PNjBelXa/btXf7SVNlCKOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714134017; c=relaxed/simple;
	bh=PMGdNnxS+u6EuMG3EBK442Fl1ePQX3CaF6GlOMeIhVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPHbtanAhIv7wdPRmoJM09aqlTBye/8k9SwlilLFx1SQcyomfSudjiIakwOh5ObepTVxSpH/+/8vXYKgBriQNPK4cIywxeWngjurT6D+zwx2Lc8b9RCNrfBx9yKjWfNJE2ali3vOa/35DNZEdXbqsqQrECnLPmXz8x2G0K155+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yeffjaFi; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yeffjaFi"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3476dcd9c46so1545905f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Apr 2024 05:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714134014; x=1714738814; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s/GoVzExBpe8QxX9A9OVe1Uavi5SgYLv/AxKVNUl0KE=;
        b=yeffjaFiREVFnHmN/Vb4FV7l9ntI4n+q+tq7Y6J+h5mD+YvszPrVJ9yYP14q9FGmA+
         44h/1Ik3iCMVoRo1nIgK/Yop/PLC8/jYG9QbxaMfBOnIo/57tudYdcNgv9mL8avze2VF
         RaJ+rVUWo0x1XqXFB6ybbOKmkrSVgVhSv/z353m+xO60FOMLNP9I6u2VSdi4Ho23S8Ca
         ovufZhigXMWuCkceB+eAWp8LPTlgmYeFhUj6fyrdSXdxeTRCkIyn6gMroDoLWuEhhliF
         qlUAtWkm8XDXqjnQnaOfzRXvwDJtxzCzmW5Evnu9zi8IQiy7NC3dwDv3a23ChdQxAEjv
         K3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714134014; x=1714738814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s/GoVzExBpe8QxX9A9OVe1Uavi5SgYLv/AxKVNUl0KE=;
        b=eDeMuUS4IAra1+LKtQttNTYa2rNrwIqzwUo09PuMnAPn01yawE9H+ABql1XSj1LAeR
         lOl6Nv/ZqABvpi/vpmmTLHGN1ZNQFpSiJW30/A1BPwK+TShheCrShYidrSgcxTv1o6DD
         7t+HFkjabcm5PL1+a7VkCaBkPghN73g/hOSb6vsD35FQXzjQFt4uLNG5IK4V+935fx0S
         Z0H4z33kG7ft5MNGzvH2QanUpHpf0isfDBrBBsUSZ2ggF/RhGsXb3EE8dKubIeUXGmc/
         IuOSbb80pQOiQLXFUNBfDbJiRNj7kmBKXpVZFqW0JQ/G3+fsSiiNJJ004Y/KcEIzvtkG
         ZEDQ==
X-Gm-Message-State: AOJu0YwfA1lUBiGUfVc0VnpyWJYubTh7hc7ouVDC8utpE6f3CGUjLzMr
	2F4g0jWTRn64d/u4+PnGzxefdK7UNHK2Qg/kUXAiwTr2866ja/BIBxABlIsu6wo=
X-Google-Smtp-Source: AGHT+IG8i83ojCM1oXNScY2W5iBraTj3fEifxmmTUKGEf+srJSEE4C+rnvkyLZ6DswUhCabT5iITlQ==
X-Received: by 2002:a5d:6c61:0:b0:34a:5640:45e1 with SMTP id r1-20020a5d6c61000000b0034a564045e1mr2398002wrz.45.1714134014345;
        Fri, 26 Apr 2024 05:20:14 -0700 (PDT)
Received: from gpeter-l.lan ([2a0d:3344:2e8:8510:63cc:9bae:f542:50e4])
        by smtp.gmail.com with ESMTPSA id q2-20020adff942000000b00346bda84bf9sm22478146wrr.78.2024.04.26.05.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 05:20:14 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tudor.ambarus@linaro.org,
	andre.draszik@linaro.org,
	saravanak@google.com,
	willmcvicker@google.com,
	kernel-team@android.com,
	Peter Griffin <peter.griffin@linaro.org>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH v3 4/6] scsi: ufs: host: ufs-exynos: allow max frequencies up to 267Mhz
Date: Fri, 26 Apr 2024 13:20:02 +0100
Message-ID: <20240426122004.2249178-5-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426122004.2249178-1-peter.griffin@linaro.org>
References: <20240426122004.2249178-1-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Platforms such as Tensor gs101 the pclk frequency is 267Mhz.
Increase PCLK_AVAIL_MAX so we don't fail the frequency check.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Will McVicker <willmcvicker@google.com>
---
 drivers/ufs/host/ufs-exynos.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-exynos.h b/drivers/ufs/host/ufs-exynos.h
index acf07cc54684..7acc13914100 100644
--- a/drivers/ufs/host/ufs-exynos.h
+++ b/drivers/ufs/host/ufs-exynos.h
@@ -116,7 +116,7 @@ struct exynos_ufs;
 #define PA_HIBERN8TIME_VAL	0x20
 
 #define PCLK_AVAIL_MIN	70000000
-#define PCLK_AVAIL_MAX	167000000
+#define PCLK_AVAIL_MAX	267000000
 
 struct exynos_ufs_uic_attr {
 	/* TX Attributes */
-- 
2.44.0.769.g3c40516874-goog

