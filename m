Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692E8146D4A
	for <linux-scsi@vger.kernel.org>; Tue, 23 Apr 2024 20:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713905436; cv=none; b=eo1ZPwIeU7nihLCvLKcI6N08jWTYiqAOzg6z74uZeSF6l/1mH58IQ0LBEhLDCmUXeTZCCoGd/lmCPt6ufSJKvODmB7N0htTmFlC9wvw5h7rvTv+H/TVIvf9XsjBLrRddV+MO1+lnKf4Cfm9sIrbi16OO/9mBGq3sBqgXD0WqVek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713905436; c=relaxed/simple;
	bh=PMGdNnxS+u6EuMG3EBK442Fl1ePQX3CaF6GlOMeIhVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFUskGWbXNec0y2c5f1A9dIfzyA7gBkZj/QH1uAwXtzkx39FdAYMJN2UuPfg1jjxFjBjdfsAzoQg+iXsfm97iR4SLOZj04h9//U5A2oJi+j9aciSXItdMTBAKVyMIEIK8ScRhIdmb5BAC1gOKW1DoKW8Kf8wOsIZtOjryOBQHNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D+ha/ERu; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D+ha/ERu"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-41a5b68ed4fso21757195e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 Apr 2024 13:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713905432; x=1714510232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s/GoVzExBpe8QxX9A9OVe1Uavi5SgYLv/AxKVNUl0KE=;
        b=D+ha/ERuZPze70axK+sIkgjvR2RQnq886MFd5toHxCObFk5521BzLv3dedKHxmIBkJ
         5o7Be0dzbDoIKoWL/mvrKwc4Hd9gsrnCmMTn29ossR1F6+TcvRx2w4KG5BGYB/rZRd3s
         +t2N2N2WB3IZpO2mOzIX7I92LUgSN6A/nJ1l7rW8FaEB8qGov03UbjZkpPEyy7q8OA63
         AlVF/xLAuWThWIRtLJo6cCAtAsRGaJP0elhUEqOEvxcaylIPLLqDvKFn/cqUavU4ZF9V
         Zu6BNQam9ZHm8ZyaKA5h5g5XN8f5LB1/gqOJVeCvO0jTcau17xvgCMnQh7zE4+OrIZQT
         yuFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713905432; x=1714510232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s/GoVzExBpe8QxX9A9OVe1Uavi5SgYLv/AxKVNUl0KE=;
        b=hgfNDH+IJ36o9CIsMKPTCFqdyp5t4ESHyt0HNyELs3boGOSOHJqcwBDz6KYc4a12tF
         4/4Hl8yBXGQjGy3YI1NIPM7IOWBsbJzzedtF0a0g0tePmmk4ROWvCLq0XVTPx20iw3qF
         583FhNSYpYKh58LFKg+htycKqPVlyrHW0/phj8+flJ7T3LWYfF9DieIguIzMsVQ1yoco
         Y5+dWZm4iyaljwqEQON3kh1L2temvNDqGOInKTHR8Tdi2v6v602lI6goeaUUxhtCvVAP
         9zaIu8T5reYCJw4968ZotyNo63aiF5dmOsWzYFUg3YaIJHi+IJKmrpIQLabUp97CQtOl
         jzxg==
X-Gm-Message-State: AOJu0YwGD1bub//MOtzIppkKEOX4CUSHkzt2hmKl563wX38pE5BPInjQ
	YYbZn06xzSwdQ2SGtWSHWOSuKI+O3YUXeip1hq1gOv82U0yM0xaciArGF4fYeEQ=
X-Google-Smtp-Source: AGHT+IH6z+0zlU25050wMvD0vuxotNnh43coyHQIMqF5YmCpBQNXBCfzRnt18Ll4b9pvC+KY+bIGQA==
X-Received: by 2002:a05:600c:4590:b0:418:f991:713f with SMTP id r16-20020a05600c459000b00418f991713fmr263623wmo.23.1713905431899;
        Tue, 23 Apr 2024 13:50:31 -0700 (PDT)
Received: from gpeter-l.lan ([2a0d:3344:2e8:8510:4269:2542:5a09:9ca1])
        by smtp.gmail.com with ESMTPSA id bg5-20020a05600c3c8500b00419f419236fsm13065443wmb.41.2024.04.23.13.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 13:50:31 -0700 (PDT)
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
	James.Bottomley@HansenPartnership.com,
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
	Peter Griffin <peter.griffin@linaro.org>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH v2 10/14] scsi: ufs: host: ufs-exynos: allow max frequencies up to 267Mhz
Date: Tue, 23 Apr 2024 21:50:02 +0100
Message-ID: <20240423205006.1785138-11-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240423205006.1785138-1-peter.griffin@linaro.org>
References: <20240423205006.1785138-1-peter.griffin@linaro.org>
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

