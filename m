Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8883B79E
	for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 11:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707823345; cv=none; b=IYc+4/9n95orz1rTxJ+mMHSWbdPbKEccuYlUMLRjk0zF38EozvLUOmDtVY+Ufg4TQaWHcvTl4JXiBzFfy0asnaXGZtg6SQ6rr/pD60FhsBfAmcAAm0E0Q/wqahaFCvaZan1X8p+Xlz8JBhzBnU5hgNyUzVa73FJcYZbTJ/IrGE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707823345; c=relaxed/simple;
	bh=U5NHcti9mGlzzsInbBW5rutmFws8SfG+NrSfi+LiWxw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gNSrcxz8QwrilygG1yFgOn+cxfxB6Rlojp3qwMhk5gCcclhIax/TkUKQdgPr1j3XMZs2CPmEfb73TAH8qUgI6M4/CdIrgW/ofepdSgnPeBllgfst0zS+7AgnVDOHLPJJl5dufxsQ7m78jhGv1sBQoMFdl3gapI617eDrQXy5VnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ea9IYf7V; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ea9IYf7V"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2d10ad20955so4877631fa.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 03:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707823342; x=1708428142; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DtzkxHXqpMKNfnl3k5UmVCm3Y3oEdaOx30g9CKBxxQk=;
        b=Ea9IYf7VOim9Y938BoP0JSeOBj2QQdzeGZb0Za3aoTUgNA6mo1t5NnwTjM4UC1DS2w
         Lc5N7AGQA3oV2153EaQS8FewmIGV+nsG/PRd0ei2XzOAFj7AEnW3LgJFdSWBAQW0A3jP
         IWkiB+Z30Ag7LdIuRoplUP7Ux6sirvhmKWV2jqhgwCUamDN1XdGBTKNL+EROi148D04Z
         mb52KKqiEWUI0jaqZc8s2a/1M0q/VrUflvW7TgWrJ2VOTiRace23vp34y4yHqL3HgFBG
         8CN8FwuzYPe4zLmyGsJkYBIu0qjX9r+ax6XK7asKLZeghg222e2C5MYHzttqaactVT9L
         PwVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707823342; x=1708428142;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DtzkxHXqpMKNfnl3k5UmVCm3Y3oEdaOx30g9CKBxxQk=;
        b=X5Jet7YWhzeDOQs3og5oKTO0zywhi+LwFFoE0kqSXQ6V+WJsam+JgEhC+caGCww6JC
         a51ndlT8ILXIWm2ohSEaUk6tBTrqYqNlwIp4Gne/uevd2f/PUViznQdzRtvQHwlB4nKj
         UbYAKAJY/GbJT+miPty+SgCn0p/UbsOvlaQ0MIIgHVvcpLas+nmal0ZethGJjl3lwluM
         ZXIYx/EScTZ/6W/N9KhhAJ9iOQ88fVhy5eRlVpI4tkMHUtUeJrvA+H9DvUluSAkghzkE
         o2hRZSDv8bYnIlkQvhaUObfcMxm6xQD5uifqj2+ld3n3NCk//Pcwjn0CnKX+AO5usMtH
         HZjw==
X-Gm-Message-State: AOJu0YwCaCQGccMaC0Eugm92rnk3vdREYmdoxPWKuUde9O8g1BG/Vbrc
	y/UL8TGLCEXQyKHPLXgPW8Ah7B1i94N/g4XjOUsvm4BL9awYklv8S17v3c/Wfz8=
X-Google-Smtp-Source: AGHT+IGZigQVah8pP9ZrHFZfK+bhcqYzpjer6XsZp9CAhwTcqUbph6+BKZtga6aiLelyZOby6qTZfg==
X-Received: by 2002:a2e:9889:0:b0:2d0:fd0b:2cde with SMTP id b9-20020a2e9889000000b002d0fd0b2cdemr3008333ljj.25.1707823341714;
        Tue, 13 Feb 2024 03:22:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVvCK900RwGVm3a532Z6aPVKLm5dtAdmMYsxqPMayAvEvuSk9u8oSnrJGp75N2gTZGnOqpBcxcta7EO2nK4jZbPTJhikJYpzsqqsj2oi1OhWOTSgGVwfATBNWbsGuNvIeS1fOP9PauGlIQDk8EztIqr0NPxA90AxT5m1o5/sd2n0y0noxrMEGEuDnCDqaKuYp7AMjqMbm+/gG3DTlJIWxnN4i13eZyMfFncveggoonwGIJqd/uVSdDr8QuoPXVEdOL4aVFeWC+8XxfIYhLtCAeVZOCzndofUFpW2EvbZpKgqZbEw5ika+El6843oZRuMAKop7ZFvCObhHUqSgpGEeuZJsysJEThgIJFO+j/P78Cr7zYVRRUKfhXZl3L8YLxti1UkftIqE5rObdDpYquud6fHMtt2KAgWxQcVKtgoFktUFxvgfKTp4Vo5GHmY7jYAvWWsKldWEBwbVu4m5QIfPBptkU2nEPthqRM8OG5QZZoV4xlf8fPRZChzuOt22HnqGBxaDVWU3qjA2I8Q/NHdC7uGi0/w9ikvmb5ECqDu7W2p/2UEm+U9hJnwUpjTEEfVDzD
Received: from umbar.lan ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id z11-20020a2e964b000000b002ce04e9d944sm451107ljh.69.2024.02.13.03.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 03:22:21 -0800 (PST)
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Tue, 13 Feb 2024 13:22:18 +0200
Subject: [PATCH v2 2/6] arm64: dts: qcom: msm8996: unbreak UFS HCD support
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240213-msm8996-fix-ufs-v2-2-650758c26458@linaro.org>
References: <20240213-msm8996-fix-ufs-v2-0-650758c26458@linaro.org>
In-Reply-To: <20240213-msm8996-fix-ufs-v2-0-650758c26458@linaro.org>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Nitin Rawat <quic_nitirawa@quicinc.com>, Can Guo <quic_cang@quicinc.com>, 
 Naveen Kumar Goud Arepalli <quic_narepall@quicinc.com>, 
 Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Conor Dooley <conor+dt@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Andy Gross <agross@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org
X-Mailer: b4 0.12.4
X-Developer-Signature: v=1; a=openpgp-sha256; l=1151;
 i=dmitry.baryshkov@linaro.org; h=from:subject:message-id;
 bh=U5NHcti9mGlzzsInbBW5rutmFws8SfG+NrSfi+LiWxw=;
 b=owEBbQGS/pANAwAKAYs8ij4CKSjVAcsmYgBly1DqZ1EBhLzbYq+xAKMyIjzFue0guaOYriXFV
 S3GAa4n5gaJATMEAAEKAB0WIQRMcISVXLJjVvC4lX+LPIo+Aiko1QUCZctQ6gAKCRCLPIo+Aiko
 1RVOCACeoLiLwq0/8j3orEZkIkqlj6Fgl8Cxp7OCiDQ0IAFFWC3CQzwvEtEVoruLp8drDGRXZAc
 5Bw3NjWKN208B2r7SJltlUH2NZT2kKmTP65ycluIHbGY3DYvSEk914BmoPF0noSHRooxlPp9qu7
 nCeN5PQZmMkwmAaSdiLIDVJzUrUvGSklsjsoyviOJBna6mfWDsw0iIf7z2H4/WxgtmU0+Grp0tZ
 sd0A+Bkix7HztHewzpaI7PD/0+jhVxZWbtcs0GRXPkAU+sMcAsACrwxqJwbpOGhzQeeLFo2CDjF
 QE2rk86jo4l1hLYjwHEAe5J2NxY1gHTyu+/2E4A4q7Uvw9oD
X-Developer-Key: i=dmitry.baryshkov@linaro.org; a=openpgp;
 fpr=8F88381DD5C873E4AE487DA5199BF1243632046A

Since the commit b4e13e1ae95e ("scsi: ufs: qcom: Add multiple frequency
support for MAX_CORE_CLK_1US_CYCLES") the Qualcomm UFS driver uses
core_clk_unipro values from frequency table to calculate cycles_in_1us.
The DT file for MSM8996  passed 0 HZ frequencies there, resulting in
broken UFS support on that platform. Fix the corresponding clock values
in the frequency table.

Suggested-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Fixes: 57fc67ef0d35 ("arm64: dts: qcom: msm8996: Add ufs related nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index f6b6fdc12f44..80d83e01bb4d 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -2077,7 +2077,7 @@ ufshc: ufshc@624000 {
 				<0 0>,
 				<0 0>,
 				<150000000 300000000>,
-				<0 0>,
+				<75000000 150000000>,
 				<0 0>,
 				<0 0>,
 				<0 0>,

-- 
2.39.2

