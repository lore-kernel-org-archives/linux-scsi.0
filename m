Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AF536AE3
	for <linux-scsi@vger.kernel.org>; Fri,  9 Feb 2024 21:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707515442; cv=none; b=mVYOIlz6BnOoJ4T1VHrl3X7KFqhZr0cR9FkVQc120mPzSMuPRGH6fIhEtVNtSXcfdCaZd9wSotn1YJfwveWQfE9jCSIOhsnSbuLS53WvvqVpAYVyw60WyoXcQbW938lq6Q9W6jab5LvMOO23DMmUXnCfLNRtQpqBh8/712nBxt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707515442; c=relaxed/simple;
	bh=Yu/LzOcQdCwZAyJpUXbklqudqrQ3EIxx4vsAwegkqbc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=d5OkLV0WlWhFjo9TbchVq4kJuJKng2M2Jfi3j8+EoP5hyps7DFnpgyKMV9brIEgCElrYq2O7QndAsvH0AkVKWnEVNz1QCpdXXdOouVo/koCyI6n3pbYURGj8eQXW82lZMiixWsQeqAszB2LeoflzrbksnIphFhiFqT1mue3IpA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=M35PNE2r; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M35PNE2r"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2d0e521de4eso1710621fa.2
        for <linux-scsi@vger.kernel.org>; Fri, 09 Feb 2024 13:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707515437; x=1708120237; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bb+Sg+PuMfej4JlBw0WjutTwckzrP3l1xV8RqoQLreY=;
        b=M35PNE2r8xjdK/dz3wynIYnPwqe+MYHyO8IEoKSuSQHvqqYllxun7lYGX1Eq9490RG
         7AN6rSnE3tVRCWT33tpJcCOMKen+A2HtSCNsZ1B/NtsKPq1ySDjFA466qvfOEAR7B1uR
         Q7t2Kj/dwTVr2qMVCRhhN7g4ijCo37/SfkDRx9aG6/dhZyTJlzv4+erh2VqrNC//dQ5s
         WPQpMOrMRgLcFt8LWjiMnWTDf7oE8oQL6wChkPTucV8hOQTapuoNF0A+OqfE72zuoJtU
         gvKncCSk6dG1sQWJsJruKPE97Fl1OKEEvPTK5MLCpvXztVH2THPnalLtKMzqUYtap3n/
         am0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707515437; x=1708120237;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bb+Sg+PuMfej4JlBw0WjutTwckzrP3l1xV8RqoQLreY=;
        b=WT6FYbgpJq+6gQI7jvQn4HfJYH/hJ1ztloO7CQgmIAVcL20+LCcoib76GdmOL8Wptu
         p8B+XAs0KXhnKMqC3zgM1gfic7853piWzQUKOPIiYiSKvYetV9XH8UPLc7iVJPHeIVEt
         DAuKlWjg2d5i9H5z3luBADS8tbcPE1p6PiOJS0omIAWlLA5s9oTjIcPEDQBSA3RjgK2r
         gf4LXED3HdwQx8MRAdbx44LahzZbTR0GiVRp96PYFqqLGpSnng2uSuxmwip3iFRQKT0p
         +QLqk+dHFlyDBPsRsHnA1Qr0Darj+yD7O7+iKptCOVymiruBT+2xU+Gs+D2GzzZOc27G
         ghmw==
X-Forwarded-Encrypted: i=1; AJvYcCXXvgflC9nfuvDw51XA+rgnxw7b0ppkt3D8IMwNOnSF/9q+Pv4XNmhQf8YHBEuwHxVJ85klQ8lO6SFDyKQckdnhlrxW1aPFe151ug==
X-Gm-Message-State: AOJu0YySLXfpx3e48vUArVn3f27WbvuihZEokVUHFBVd51/CuQ3BPHgW
	EDmplOchy6Nzpsj3XeeR9kbId4ltBDXwP0nKz9Ay8sWlZbFK4MuTmikIz2EAfx8=
X-Google-Smtp-Source: AGHT+IFF4APdxejo3krhK98jJDEbNv7Q1pmG1j5+LIhk9UntOHNiQq20JhOvuzyyqMJR8uROmcsYtg==
X-Received: by 2002:a2e:3806:0:b0:2d0:a71f:5eab with SMTP id f6-20020a2e3806000000b002d0a71f5eabmr210385lja.23.1707515437558;
        Fri, 09 Feb 2024 13:50:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW43uGcUmlYEa7r8C65VOJ40b6JybqNWwfDRdHJLlqoqRDFTzTFQgma8bIHjq3hv9E3QJdjAcgkdRrtgFpcbDBSfXSerbEj60fLCjhechlkITjTqXk5YO1UAIb/aYKo7Cmtk7FFHLimieDNZl0W8qdrutBUT6JUXK195tZ+RyMScFRYOkdiSCqa4GwgE8sbX1MswW2XfSu7uMZi3fd1/9tQpkceusLhwvjvVAfG0t8KwilirkMk4r/Yg4W11/Ed4b0i/4U8sxLIBLQ106QckYzzu/gslhwOKCpb5qPZc6RIUOPi5buixQhqUMk3/kavFaWPiIMMGr1Nl7P9mY4ZE9zu6/Q9wmKmjGuL3hOXKqbjaN73lZByupkS3NgG+80je8sxeRhnCm9igC3vRCtUyIfXW4V9p1GbR7myxkU6sXhI1bBhwHnO9qXq6wuJadOTLf/J33gnQhJckP+iMXXlzod/cOGDxOIjn+eySTW53aOoWbwI8kE8YopI5EV07nZ6EOIh/z7QJYJuNSacL04U9SlmQEJAKHN8KjP0/I7DVF5UKT+/EEROBK4+cw3i1zR3KIkw3JwRXDCGi3netcWhEis7siP0KCFAdAE=
Received: from umbar.lan ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id t1-20020a2e2d01000000b002d0ac71862csm391162ljt.9.2024.02.09.13.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 13:50:37 -0800 (PST)
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Fri, 09 Feb 2024 23:50:34 +0200
Subject: [PATCH 4/8] arm64: dts: qcom: msm8996: specify UFS core_clk
 frequencies
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240209-msm8996-fix-ufs-v1-4-107b52e57420@linaro.org>
References: <20240209-msm8996-fix-ufs-v1-0-107b52e57420@linaro.org>
In-Reply-To: <20240209-msm8996-fix-ufs-v1-0-107b52e57420@linaro.org>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Nitin Rawat <quic_nitirawa@quicinc.com>, Can Guo <quic_cang@quicinc.com>, 
 Naveen Kumar Goud Arepalli <quic_narepall@quicinc.com>, 
 Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Conor Dooley <conor+dt@kernel.org>, Andy Gross <andy.gross@linaro.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>, Andy Gross <agross@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org
X-Mailer: b4 0.12.4
X-Developer-Signature: v=1; a=openpgp-sha256; l=975;
 i=dmitry.baryshkov@linaro.org; h=from:subject:message-id;
 bh=Yu/LzOcQdCwZAyJpUXbklqudqrQ3EIxx4vsAwegkqbc=;
 b=owEBbAGT/pANAwAKAYs8ij4CKSjVAcsmYgBlxp4oPisjdMAjttGDKMVPpDmlZqu7GPwM7Nd5H
 MqTPgqlgz6JATIEAAEKAB0WIQRMcISVXLJjVvC4lX+LPIo+Aiko1QUCZcaeKAAKCRCLPIo+Aiko
 1ciFB/ib4ZE+Qk5EBi+qpqjvxVXZjDd/Haa7IBdbqcSY5lkPH3lhVep03A1QtYcGtCzQACbKlmD
 TUaijeU5T2l4Kjz3OvlvinaAVUsWpdkSBDVFHmHQl5k3uVGlblvu4+KEvOono83JMIh7LAEOUOl
 gzZlWSGN9ovjd0+ZeVnlRncNq59y6bBmA26c9/+nhmnlndYuGuliry/311qFBz5i/eo5dNNn2qN
 ud51qCkweLTgkYzlGWIFGbGn+n97eIfSdwkDoaUSiXhfqaHepjX7Uvahc7R//LZ2sua04lxcnxq
 4jOaUSk7dnBPb/Bo+5YoMyF4vhO6itXVz24wcbUta8xjI50=
X-Developer-Key: i=dmitry.baryshkov@linaro.org; a=openpgp;
 fpr=8F88381DD5C873E4AE487DA5199BF1243632046A

Follow the example of other platforms and specify core_clk frequencies
in the frequency table in addition to the core_clk_src frequencies. The
driver should be setting the leaf frequency instead of some interim
clock freq.

Suggested-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Fixes: 57fc67ef0d35 ("arm64: dts: qcom: msm8996: Add ufs related nodes")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 80d83e01bb4d..401c6cce9fec 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -2072,7 +2072,7 @@ ufshc: ufshc@624000 {
 				<&gcc GCC_UFS_RX_SYMBOL_0_CLK>;
 			freq-table-hz =
 				<100000000 200000000>,
-				<0 0>,
+				<100000000 200000000>,
 				<0 0>,
 				<0 0>,
 				<0 0>,

-- 
2.39.2

