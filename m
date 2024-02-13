Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04B6364DB
	for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 11:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707823343; cv=none; b=c2jvp4hnaH85iP0sOF4fIgOxpJH5OcWDl2Lgob35M/dO9MxrvhiJK1DNFy8wqOC56kaiqivl4/qOzTb1KxVfo/qbJgfWkqCRyIMbpOsGMpRbbS0KaHV6JDHOopdjsw36b2mSMnC8ug5pJDwtaYYoiQqqhTBjuqEQCfEf6KnomrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707823343; c=relaxed/simple;
	bh=KuWzjtFJjVZp/xi2dshIwbzK9SjPu9QyAsrTwb6vnwM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=fbaEq7YpLdoQl5rV9709cRWdXFCsQEHJQguvakW9YJDYMLrRLqQa2ooe2qf6Bjvq/P+7VOsGhPw1U2PlczKLCFAEnmpU/z67kwc/9nFu7iUvBEPZQ/+PAZtFvYb2ycd3oI37mWod5uL29as3U3DEs3jq8M+8V2q1QSDXPB4KP0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qTKGpIpr; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qTKGpIpr"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d10ad20955so4877341fa.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 03:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707823340; x=1708428140; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xZEL4+v3cRHd3xRLyx4SSiiR3ntMaqJTGNx+TD0/vGc=;
        b=qTKGpIprwTqH9WgFpedQ7ibar/sDpeIWbertRVg2g6sahbxxJhSKAFOysV4TnXaCnv
         ccFLJy4pYr9BceX34N/NhXNFRtCzKT+8ghhoJwSl9UlpbhFdd6K396r5Es90UVtW/8Qd
         edtb3Km7rOX/EP+GTlHkSHKAUcLg7uFZDkrbXIXnORIdFMBZQ6psM+V55+bZLBbCf1+4
         XWA5oWKfv8dTnu1g8u1+1Fk3C/Np0XtC7wQhXE+4tHhhfSWLxfj1eW1DcBflXuBV3arM
         mQ5YfiwXuNGbKdKJbNqUBBeiwur+CxsW1agIXzKZtddjq1/9aRnav/QYZM/K6fNVBkc0
         bdHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707823340; x=1708428140;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xZEL4+v3cRHd3xRLyx4SSiiR3ntMaqJTGNx+TD0/vGc=;
        b=ocgnP9URyfn8sh/X2p9qxbv+OWTqf2RMTdMr6yRrOENDGSBNwlEjt6rcOuf5iZg42n
         7V2MKb5FZ6J3qQO4XKUoBgHDmEFYsjiucr4ZMcXdMB5rWtgnjZ36MTFEq3Fq0tWd+YfX
         VjzscBdhI4N3SD4+CKy1g9umOX+TCdKdgI9xJAplSeTRNfKjTxEWvPsvaMt7IP/xl2EM
         ZVRX5ws0sxipvkM+yS4BBYqMriabF1msWY+7IY47Qm53SuFvEM83pCVvpfwDT81jOISL
         kIsFuunn/s6LtO8rcgDG8iyBCpIuAPGyJ86J7Oz5+zeOEzFfAXK7TXcHwjZoPicBmWOF
         rfEA==
X-Forwarded-Encrypted: i=1; AJvYcCWLYGJJfKGA3CMTIyjHnC6mrzDozM/m3+YTh4/yz/5pFONibVnoip9eaXK1S/0SR78eKcatO/2pPAjXuZ4D2kg9+5WIcpdSBMMw7w==
X-Gm-Message-State: AOJu0Yw5vz/bD8iEGB+/Gz5ghR00Uqeymp0VhZ+iTtrShwsL+8MK5GyO
	MtC6aPcSet72tgLeTtHvexsm3nJG3/y4/inn6w2dUEgBaDj+5mebtLKs7CIgbF0eybc6+Mx2mOO
	c
X-Google-Smtp-Source: AGHT+IFwmxTaSjeCr1QNAUyqSNmIUQdzqWzwxCbe7W2HS5qD0OMBOIMhWiRq9RZo/bdg8F7Cv6nZVg==
X-Received: by 2002:a2e:9d87:0:b0:2d0:c7a3:e97b with SMTP id c7-20020a2e9d87000000b002d0c7a3e97bmr5875643ljj.0.1707823339951;
        Tue, 13 Feb 2024 03:22:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWtZVDYYCkBplO/wKwc6lBnYsL0BP4UOPsU2G59nTg/I9SWDhXmoMhhjP+2klbDSHUTJHPC6VAMRvED2Z0v3xOG2Xs/mgj3i9ws6So9sqjVVFvvtsBIn7tRRHFRHwmr9e3C2mcgRJAxr22jm0K9JvWE7OxKLJzfI+gez0q8K2ggoI56syXEpMU20u36DNVR84+9JRvR9WFwhvUeOWB6RgizLSYp+Ym2toIkcHOgMeWGUjRvid1K7oXLwY9JIpCVqch8ab4Q5JdVpMy0U8O7KbZxHtqRgqj4kRUqyNW766f+sf4I0H+7MiMGSqcVj+nro2254Ia+WH7J0sU7xDXVh7L853fEoteNiw7mWZZOHZBPoZS+duTp5eK09AY6coOFuUMktLMmGOrqBIxrN9PQYyS7JQUItv+COawwc/vVRXTMgWUOu/BGSpt2iKg8Xn9pMkpLpheTUATS+CAbmlVeia0oKWi4Uzfvdy6xKLq5ex+5EmuXnbhBtWm9fX6jdFK6MICEfquoLU6v2veEaleLqL6rg2fD4GBNwXkVZv9PV6W0d1uspc/ivzR4my6/nxf9QFuL5+4Uaf/PUyLr08bPRk5mYUn++lyNYP3CSp95bUF379A=
Received: from umbar.lan ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id z11-20020a2e964b000000b002ce04e9d944sm451107ljh.69.2024.02.13.03.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 03:22:19 -0800 (PST)
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH v2 0/6] scsi: ufs: qcom: fix UFSDHCD support on MSM8996
 platform
Date: Tue, 13 Feb 2024 13:22:16 +0200
Message-Id: <20240213-msm8996-fix-ufs-v2-0-650758c26458@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOlQy2UC/3WNzQ6CMBCEX4Xs2TXbhl9PvofhgHQLm0hLWiUa0
 ne3cvf4zWS+2SFyEI5wKXYIvEkU7zLoUwHjPLiJUUxm0KRL0tThEpe262q08saXjWhbGrg2pWl
 HC3m1Bs7VYbz1mWeJTx8+x8Gmful/16aQUFFzrzRXTanp+hA3BH/2YYI+pfQFAhvm468AAAA=
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
 devicetree@vger.kernel.org, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.12.4
X-Developer-Signature: v=1; a=openpgp-sha256; l=1552;
 i=dmitry.baryshkov@linaro.org; h=from:subject:message-id;
 bh=KuWzjtFJjVZp/xi2dshIwbzK9SjPu9QyAsrTwb6vnwM=;
 b=owEBbQGS/pANAwAKAYs8ij4CKSjVAcsmYgBly1DqBXZn8ok3IZ80dskwW4JBSXSKKAHSfI95L
 WiUaR2RdMyJATMEAAEKAB0WIQRMcISVXLJjVvC4lX+LPIo+Aiko1QUCZctQ6gAKCRCLPIo+Aiko
 1R4wCACA0Wb8cT0/dYI4u8UfUuiO+jnxoFJ7CjIrd2QCqVlLnrRviUM1W5kUEs19m1o8S49c+V2
 3XGdEkZra3lL9cWvsPGjR72v0xyzDYsoyW6fppH2Pnd3voQ2x0bGmIuW06JERVGRRbPtMt1lDpg
 u3DmtGm9LYs9X6twQfzb+mr2mY6TGo19oNkrnlJvTXHppaTUAkO1E8Gp5VOsCSQYmmkHUMwvgTK
 IR09RU12hqOXwASCt2ydDMFxB0Lxmco/rzy0CFSuMvsyCaErs9ESv5LikDCp9w1ff6gjMRA0jut
 R3jstphzEktjzJ4IihBrrPXpPS5q9tZuMysSqYgjhNPKaDqL
X-Developer-Key: i=dmitry.baryshkov@linaro.org; a=openpgp;
 fpr=8F88381DD5C873E4AE487DA5199BF1243632046A

First several patches target fixing the UFS support on the Qualcomm
MSM8996 / APQ8096 platforms, broken by the commit b4e13e1ae95e ("scsi:
ufs: qcom: Add multiple frequency support for MAX_CORE_CLK_1US_CYCLES").
Last two patches clean up the UFS DT device on that platform to follow
the bindings on other MSM8969 platforms. If such breaking change is
unacceptable, they can be simply ignored, merging fixes only.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
Changes in v2:
- Dropped patches adding RX_SYMBOL_1_CLK, MSM8996 uses single lane
  (Krzysztof).
- Link to v1: https://lore.kernel.org/r/20240209-msm8996-fix-ufs-v1-0-107b52e57420@linaro.org

---
Dmitry Baryshkov (6):
      scsi: ufs: qcom: provide default cycles_in_1us value
      arm64: dts: qcom: msm8996: unbreak UFS HCD support
      arm64: dts: qcom: msm8996: specify UFS core_clk frequencies
      arm64: dts: qcom: msm8996: set GCC_UFS_ICE_CORE_CLK freq directly
      dt-bindings: ufs: qcom,ufs: drop source clock entries
      arm64: dts: qcom: msm8996: drop source clock entries from the UFS node

 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 12 +++++-------
 arch/arm64/boot/dts/qcom/msm8996.dtsi               |  8 +-------
 drivers/ufs/host/ufs-qcom.c                         |  6 ++++--
 3 files changed, 10 insertions(+), 16 deletions(-)
---
base-commit: 4c4f1563cc49472e85613c1e4875258f6ec87105
change-id: 20240209-msm8996-fix-ufs-f80ae6d4d8cf

Best regards,
-- 
Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

