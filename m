Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D2228726A
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 08:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767773197; cv=none; b=kG76OhtUGYYsxiA50XLOwGjeUpmQfDPNVgPURjo0nLmngFbMQC7dpxBR/2dRm+g9CINRsOAuUEd7btfewJWPdCm1WnG5Xef0CoTLsdvtWiYknLvgue5xiQx7KqQpDuigB0Q/ch0+fkvfdLxER6HdOwvWo8gP7DNgUSpT/XYBRFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767773197; c=relaxed/simple;
	bh=0ExZVYfM/y4rcjDL5laO5mxUp+YApKspdR42MpTi6T0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ubvgifPIYWKNHTQiXvLBQjvPsEUmH313MI/D5c3IuZMGlk7Xmjc7+fnuJmHGH3oH2MxEvq7tcSENi7AZxmu3PBiTIlcT2p1QAdTzDWHXy1LWdRmaEi9OH/dHXJp4Ar40YJzgnEWUw9AXcc5xR9QsIsO/2g898MhM/H1Xc0Dw75E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=JFD6WeeV; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="JFD6WeeV"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64b921d9e67so2930459a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 00:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1767773193; x=1768377993; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/i8ATthAaWuqmGUIVSIUdUu3CIf2MrTEFPyEW8I+YrY=;
        b=JFD6WeeVsFMBOGz7dNWZffHEu9YeEdCbhr8+r+9/XMya77+zQxQJPftHbue7TRHe3T
         2A2UEkbV0aCs76MspJywpM2hmQKRFs4ECoCB/YGTMZ8gd/5GR5+h9vU+blUgnz9ZO+qe
         /W9zqCTKSnbS4VhMCdePv3kx5tz/den15GnzKfZaCw7dchw8q3GcBAPXGc2BZmyaQ69g
         cvZuQzR6XNI4ITKLNI9aXjoGj7yFuj1qfb5MH2TYt14z7c5RYTpM0+m7yzwoPvPa+BBa
         lHuLTYjowkCckedrFJEobiUp9lD9Z7FvMvZlU5KmrH+MxXCdKd5O+JygiwU14kXyIG6M
         WH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767773193; x=1768377993;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/i8ATthAaWuqmGUIVSIUdUu3CIf2MrTEFPyEW8I+YrY=;
        b=IbONDWakWBJHU4cThrcjPq+XCiw0dRaLeQY5TjpEoM5mSqcsCemALy/oTIVtd+HPbL
         bTV1qhceJ36TTTWHeX8tJCNFDrgNFlmyQ/22dnwAnIcc3OWzHl998WfcuqwM9m7hAu7W
         43TCL/WHJtHD1O66I8pk09tuYkEWDY8TJZNEZjDvPStrvpE3VS2M6vpuR3nWmJwH30SW
         o+BIAmKSrffM6no2yGmhC4JcnMVKQot5Pe24qckksEXaTHSd7sazNW8YYPX9sQHvukfk
         eINT9lkxa/UsInSV8glgaBQC0KvJ+/AMvZ4LAzLHI8703hiiP0IfEUAN3spudSNAZFrS
         jdcA==
X-Forwarded-Encrypted: i=1; AJvYcCWUQYZtH0gJlP/AeuXd2kV02GhpWaz9Xcp+4Uzi0WNMDOrRJzfLwqWNRqJkIqcL9s3Tz0WluYWkdnUH@vger.kernel.org
X-Gm-Message-State: AOJu0YxU6KKlNWHKoZ1A/WJWaQ4cs9FyFcpir8egCwZXND+WwW4GURLW
	y/gRBBsMuGf6Y3myZ1E3AOar/Btnvevoojg7NoCEBvMBcXzm35jV+Kx1/8JzrlI02Ok=
X-Gm-Gg: AY/fxX5W50zz4oNxZiaqr2pQqD0pYqwKPJWDe9QDqKtWu0tTdWpl2pTcYVy2ya/Bcbq
	8cjQHlcisIo5FcpKbCTk6nwsD8Lr5M36HOWPlnJcN/0g0IAAzHMzq9CLIIODUo8FObe1YglhrLb
	YWrJ3Yz9Sh/XzZ0EmCnBFnG99abNSunD+03kxCDxlYZZlwFlTR7Rr37QYchEJvxpcgPExcMWa2P
	8fneRwPUtLlRfXvDS1ln5skmSiXyCuZOnN46wTAu2Xt202toH6Ubu0/Qx9BWH9Z1NYN+PcKqLVR
	1cQxPl95WHc8TU3cX1G2ev7Qsqa9qjR+XEUdDaohotq/iB9GUshas+55JTk25s7E9VunpHDCnIh
	8BjIVr7/EkcTIZZiHdanzIj6NqpS1s/e4gqFB12vFY3QA7PCvyYaJ+PtpVI1JJnyhdwtFlp3ywd
	Nj0fyh8luR2YGu7M0OqoNcKeOmVA==
X-Google-Smtp-Source: AGHT+IHJ+kf1Owv26cSF28vuEM1MMU6N6BChtOdWOK1Y0tMkxyy7by9CzZtm/qgGX2Td8KERFqr5yw==
X-Received: by 2002:a05:6402:2554:b0:64b:946a:4a3a with SMTP id 4fb4d7f45d1cf-65097e75079mr1338292a12.31.1767773193114;
        Wed, 07 Jan 2026 00:06:33 -0800 (PST)
Received: from [192.168.224.78] ([213.208.157.247])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf6d5absm3941299a12.33.2026.01.07.00.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 00:06:32 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Wed, 07 Jan 2026 09:05:56 +0100
Subject: [PATCH 6/6] arm64: dts: qcom: milos-fairphone-fp6: Enable UFS
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260107-milos-ufs-v1-6-6982ab20d0ac@fairphone.com>
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
In-Reply-To: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, 
 Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1767773155; l=971;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=0ExZVYfM/y4rcjDL5laO5mxUp+YApKspdR42MpTi6T0=;
 b=OuUeeB9WBtMh0NzBeD2CtxzVjBzIAGe/EJcU8G/bdiV/SxKNG4rjbhcWGJctZTKikNOCzM2jj
 leav4MG9O16CTfjnQYITZkPwM5W6n1oQkcroJQw5KKq7O3xx2gAleXB
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Configure and enable the nodes for UFS, so that we can access the
internal storage.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts b/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts
index 3a7f2f2b3a59..7629ceddde2a 100644
--- a/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts
+++ b/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts
@@ -819,6 +819,24 @@ &uart5 {
 	status = "okay";
 };
 
+&ufs_mem_hc {
+	reset-gpios = <&tlmm 167 GPIO_ACTIVE_LOW>;
+
+	vcc-supply = <&vreg_l12b>;
+	vcc-max-microamp = <800000>;
+	vccq-supply = <&vreg_l5f>;
+	vccq-max-microamp = <750000>;
+
+	status = "okay";
+};
+
+&ufs_mem_phy {
+	vdda-phy-supply = <&vreg_l2b>;
+	vdda-pll-supply = <&vreg_l4b>;
+
+	status = "okay";
+};
+
 &usb_1 {
 	dr_mode = "otg";
 

-- 
2.52.0

