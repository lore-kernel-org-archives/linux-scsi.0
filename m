Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E20AD32
	for <linux-scsi@vger.kernel.org>; Mon,  8 Apr 2024 00:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712534677; cv=none; b=gfBrhQQ/3gZ5EwRGZmaPN+2uI5vWcGqlkllzNTbXe3M4hub1ywHuO60yrIvU6o6cYiFm66oQA1/u5PKjJfX67KLDz8pJ/i9HnsVkLP+W2VNrgrLdfuYiJz5hm+EINz3MlnKPYvYiQbrNdWg1H39Ma5AuNnAdr/VyGlIZWFsy9VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712534677; c=relaxed/simple;
	bh=4uJRDTqomRDGI6+FwBgmpcca266Nn8+WZpUZNQ2q9OE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UHtmRDtFH7YVjmoE7XhaXfBjcC1OqCiSqVtd0DHTC4TQujH10EqkUvEDAr0asZTkNZ2KVxHM2S0NeVTu5jBakS1m8ojzIM0MVw4NA/NMbK8jOuKLTRdaMgJUVJXh0IWovYnkf4v2aVXveULa/WNbAXnODlxQ31MfswXCrvzYApc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tI+bLgJr; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tI+bLgJr"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2d8129797fcso51367241fa.1
        for <linux-scsi@vger.kernel.org>; Sun, 07 Apr 2024 17:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712534674; x=1713139474; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QLVDlCqxm2w8y5sxQgQ4xPnx/VTicbelMsxwHzT78bY=;
        b=tI+bLgJrkDmsTew0RwbdqOfQnJ8xz1SV4rQBgBAo4V+zdpNWGX4IEqpChGcF6sstVn
         Uc8vd8RfmtJoDgC2s9kkYGUsLRx+zeND1BZoEACMXTKtgC+CqOAIh/GvA6dMUA7DMBIe
         wlNXmVqNd1rnnbvc9FF9DxkV87eUFwLO7QDOplUXy0L0QA9NRaVhq14B8XZznH9AxGyW
         ZpgPgDGFbamf+ehgY63zwNRwtKYICsNUhRk5ajaOiTKDxXOvM3+/6DXDg8PylGvQjQk4
         wVq5jJT7o/6mIyw9/0ivN7Q43VgwRc+b0bAvIC2vwLkoK597i5baW+AmzTinHiQ5TR2t
         /osA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712534674; x=1713139474;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QLVDlCqxm2w8y5sxQgQ4xPnx/VTicbelMsxwHzT78bY=;
        b=Ksv99BKRG/BzeAMM4II4k/KBusnUDG/FGuYC1I/1wGJlq7Z0EHHUxPqRqnn2uACUuD
         yc+1gK+8rZEbBw9BHViU7vQ7EnOM3SFOpRreh+dq9pEysCPmoH/iqa2M0Danc9Rzx/eh
         uTvKou49cm2+TKua23V24MPDatLvw0WIqEEwSIeRSsGBreU+Yg+GniqzzOb4xqWF0EdM
         mfonozV9FJ2zgisgYQn1hpNfJzejx6Xc39iiriedqI9vUVU/dLMx2NRQxTMV3WfyKsal
         mdCrOWF+jPVkwrafSaA1l73qif6zwojv86pjByghQ/fXlwMuXwKDDSsaJw/NufJwanpR
         065Q==
X-Forwarded-Encrypted: i=1; AJvYcCVSAXrGfg0uHxKZVkqQjIjgUMdvnf1dHfUaKWw1K4CPnI8S4RFM7xfrbdJxUCsoW62VjarVAUujunMebMIz98rIg/dIlkJb8KKzPA==
X-Gm-Message-State: AOJu0YzDyE2vD/tdcZA408eUsX6VGrJB/G0hVQKz2ATDZQXZeVx+vJiF
	LRA1sC1Mz6Gt4ZecoJVoiBVa0Ae6EWqkBcQT2kNz/axrbKX37h1rH5rUEtKK45s=
X-Google-Smtp-Source: AGHT+IHW3sdJ6TUbTTll+xXKNsdF875DFyKpTcnrTzv2BMPtff7wbojcshPy2RGOFoHJT3wMwyaDiw==
X-Received: by 2002:a2e:9b8e:0:b0:2d8:58ca:39ff with SMTP id z14-20020a2e9b8e000000b002d858ca39ffmr5455039lji.9.1712534674282;
        Sun, 07 Apr 2024 17:04:34 -0700 (PDT)
Received: from umbar.lan ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id n9-20020a2e86c9000000b002d2191e20e1sm947077ljj.92.2024.04.07.17.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 17:04:33 -0700 (PDT)
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Mon, 08 Apr 2024 03:04:31 +0300
Subject: [PATCH v4 1/4] arm64: dts: qcom: msm8996: specify UFS core_clk
 frequencies
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240408-msm8996-fix-ufs-v4-1-ee1a28bf8579@linaro.org>
References: <20240408-msm8996-fix-ufs-v4-0-ee1a28bf8579@linaro.org>
In-Reply-To: <20240408-msm8996-fix-ufs-v4-0-ee1a28bf8579@linaro.org>
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
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1101;
 i=dmitry.baryshkov@linaro.org; h=from:subject:message-id;
 bh=4uJRDTqomRDGI6+FwBgmpcca266Nn8+WZpUZNQ2q9OE=;
 b=owEBbQGS/pANAwAKAYs8ij4CKSjVAcsmYgBmEzSQIK6fMWhogvncnT3r0gvhh6Q4N2FAMxz/f
 hTNsKTo5DSJATMEAAEKAB0WIQRMcISVXLJjVvC4lX+LPIo+Aiko1QUCZhM0kAAKCRCLPIo+Aiko
 1b95B/9bDJ/aYI/5iyuzUbZIznl3vuhJ0MUupGmy6mU8PZtPz/bXXqReevRONuIzovVVqOamvof
 40QgDbH/KKdYz2Nt/qdndxg3HmXowhS9jEKSVSFqXumDSawT4QREyKBdfI+qfHPt9WIBJf6+ufR
 H93JT6XKDss1PaSnOfWqkEwePjvtOU51PaQdrz87ZVp1hQXRafsal3IL2/AV99unhWscypS/z9L
 J050x4QKLw7j2+xE72112TOcgQisFTcyP5K6G+WFpsN6pTKlpy2iKqlvJFUUAy6W8MoQ5x30XAR
 F4vlI0Vrm9smGkYVo6e/pe06gdah04VW9HwyQ0s33Bw8+cax
X-Developer-Key: i=dmitry.baryshkov@linaro.org; a=openpgp;
 fpr=8F88381DD5C873E4AE487DA5199BF1243632046A

Follow the example of other platforms and specify core_clk frequencies
in the frequency table in addition to the core_clk_src frequencies. The
driver should be setting the leaf frequency instead of some interim
clock freq.

Suggested-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Fixes: 57fc67ef0d35 ("arm64: dts: qcom: msm8996: Add ufs related nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 1601e46549e7..42ad4872f94d 100644
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

