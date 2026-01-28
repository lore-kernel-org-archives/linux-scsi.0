Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C1033A9F9
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 08:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769590031; cv=none; b=PLgZeGYOB5b7xAELt9wLxZpHJ7yXKZYa6r7l0gQkakXb80n91KO1bTyDMgxNMzRZDcMA9hKK91JPRKLCMWElYc8OlR4bXUgOpzIBDEhh24kHje8/G9PHN1BF7R2J0OM4cBCs5EE+j8But5OpGV3Cx+Ccd4QDepDNdqGcxHjecc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769590031; c=relaxed/simple;
	bh=ylcz5FSDejXLscrAzKaX9+cbwcLqyVwvsZ++Oq1bUtE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XNKrblT3dUe5FuNKf2+P/lvM+GbwbSGg+PkN/qGYtFllzABmhUGz8TJ9VLOejVeFw/bwanHbSUR7dF4UhYx7gkpQL0lF2XKOkipDQpH51Yi/v+2ezqqREOiretsyj+7w7T/P6p8L7ObK9/9Pu7Bau/nOLHF6Zr6R/5chuj9eadQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fkaihsyy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LD3FMtPz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fkaihsyy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LD3FMtPz"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60S1MTfb1714661
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 08:47:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MPGRifHCQwcqLRDHjnRCAFVn4y3dD4oL+zZhUOGVvhI=; b=fkaihsyyXn6cSOWg
	HvofXbDd8+zxLp+NKwQRTAI51shtN1eoItzJpU9+a1Eja53xJButEQu3iAG4PB3M
	C3+eqsFTy1hMTkHwqDpF88GmEeD+UFEd8Qd9/UuqDxRADwVNOZnqsTcTcKnM6bdV
	GbOahVf27EFYvJLp7wSd1gqJ35gcCiqi88Khs93lEHnNvXCaTH0r29MVqgcI2ai0
	3scenD0ISffObqO0ZPW22s2m/tYFbPtiNKRGKxdjboIY3rsbOhTs1sU9Wn/vxZMR
	gwfc5lJTQpZxDbr0fzXvdgwMwBZxXaOk9Nob4ciCDu/Sj0ulUjWDCJCe3t0LLapq
	SF7EqQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4by0g0b0ts-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 08:47:09 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a77040ede0so65458455ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 00:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769590028; x=1770194828; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MPGRifHCQwcqLRDHjnRCAFVn4y3dD4oL+zZhUOGVvhI=;
        b=LD3FMtPzabhyrp6UW/o1Vmhp0n1+SuQl3cx/x13Ww4KxzUq/I56yyRbRYLdcUV6GFK
         3D5agtmk6LXZ9lCZj8Jnk/0JcmvhlnCu/Q9SXq+GEXas9djQJcm+w1NnCPtFg9rvY2Oz
         sDLKUasadGN+MTZJoDiT/ZedpV5r4sv1rsz7PA/3xDXcYgPO9S62z4LL6o9OP5Up7ojL
         iFvwEbVocKqv+W82wNqNk+bEshl4zj6hCY5FcvMSeQ5KcqPmCxkO4i3Ttik4kKToBEn+
         s7YXmfcTB/WrY6WOCDiUQMTktxEayuYuvIysP02tjhGJtONvhH2u7Ndd/MaylegoiSXX
         I+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769590028; x=1770194828;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MPGRifHCQwcqLRDHjnRCAFVn4y3dD4oL+zZhUOGVvhI=;
        b=GtCGfJx/t+ZL8q11DMrkQdcD1V6JE4XPBNozp1PeZdrSyXm4gUZnKDKPobKk9WyLvd
         /iKdoIeysCWU+2raM6Yaux1OFdQznHbaLDdG3ufXdy/FHxZ5HaxfVdsdbZ3PVRBw3HQd
         krguxHnGNCojHVpkLBlmH7tX7HafyqGOcc7f1YbzKNRNvaegtCD07Y3bALY4RWTMYVrm
         JS2AWyu6aZotAcksZqi7txq4MKo3lEWgG8wJj/EuljclaiI5otzake17ww9jfk+DbJ39
         uags7aIg5cQY6GZ2fd2rby0KRLItk9+tDWuwKrHzkqH36TaNnlC+p9056qOkMDmTjwy1
         fKwA==
X-Forwarded-Encrypted: i=1; AJvYcCVkK+UIQma+jodSuDXZ4ELcHcbjuKA5whWRGhVczP/KuDLKfsQj5ZvhZba9975RPTaOJrKYjFQMzgVV@vger.kernel.org
X-Gm-Message-State: AOJu0YyXLYZCfj5DkTZoJE/ljrQ6KiJPkgjNzQvx0WX99473Tbhsl3du
	zArqEWzcBI6tdY/jzjw/zkuGIuYGJosTfckmyXwTDyG8RHA8W7Jkr4q+q4TOt1jRyhSoEn7e2Sk
	XhqXZv2vgNvWNV44YGZ1HVVDWtcuB4fInYTQ1Mcubq6RSPP13C7wHX51r4qSVbnWP
X-Gm-Gg: AZuq6aLEgmKg9eonEPx3ZLVrWY0/L7ZFxnYkn0ewKo4NKDKHJdhADj6n4MaGD5c69qL
	iE7jzd0nkpDpwjyvX8Y3cirtjB0oNWCcEyfBwQNSWF8U8x49/zoxAXHmV/5CZBo2iMuJ32OndHw
	ZOira+kIk441RS6KBpFZqrRMKmftoRbyZvH32d+tLt2URn8e2Yu38yDJN7A4ECga4WV7myrJokL
	6B0GR9kkD53QjiJ5o0fRFR1NmRetuhPw71cW2CGNvkG7OrCyhEivcFQtrpGiGvKdvg5P5Os8HJ8
	pRqbqgiO78JZfaAbiFh5l9r8izxUqokJYvSxzYn9iZ1PwsyClPiIzi0qUZBS4yI+jP4lPBah/sR
	medfqAEj2/f/TDup5QUNWlyUWtUxw8W6q2/ocK/KGKLsCn9U=
X-Received: by 2002:a17:903:2f87:b0:2a7:ca82:c198 with SMTP id d9443c01a7336-2a870d2cf70mr42149055ad.6.1769590028048;
        Wed, 28 Jan 2026 00:47:08 -0800 (PST)
X-Received: by 2002:a17:903:2f87:b0:2a7:ca82:c198 with SMTP id d9443c01a7336-2a870d2cf70mr42148815ad.6.1769590027578;
        Wed, 28 Jan 2026 00:47:07 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b4c3b1esm16263075ad.63.2026.01.28.00.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 00:47:07 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Wed, 28 Jan 2026 14:16:43 +0530
Subject: [PATCH v4 4/4] soc: qcom: ice: Set ICE clk to TURBO on probe
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-enable-ufs-ice-clock-scaling-v4-4-260141e8fce6@oss.qualcomm.com>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
In-Reply-To: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: DHDRMlIsssczKHjvcZaGt92WgCYJcZnb
X-Proofpoint-GUID: DHDRMlIsssczKHjvcZaGt92WgCYJcZnb
X-Authority-Analysis: v=2.4 cv=UPXQ3Sfy c=1 sm=1 tr=0 ts=6979cd0d cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=u1bwIIJuvd_SIhYoViIA:9
 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDA3MCBTYWx0ZWRfX+IpqWRjRBWSw
 G+2UbDyMZNyEnywv2ycVgLhvzo+W4GbL/4z4b0WBUdAtnOOcm+MR5J/4Kke1RfkAuRSJWZ2WO+8
 q5zXS+oiYRIWllmwAaA+BbsKAMupiLMt851sgtwALstCXgP8zIjMsr1zPXhyX+5WF5UrpHkOBo6
 8C6C0NKwJ15iyIM2RmhAvNZQzzUFPrk4+UWeDLH7agoG4sCIUHL0n9xWInRsIbKva2yMat72SaI
 4aMrI1bRA0JcOMBk+67gpE68bM0XWbnsdZUsgGz1glutaueLGJPYJtsv8MsDlRWKNzVng/WDkdg
 XGEl/PSqkMoSBrGR03Sdss2MCx7SQNuhua3XqZstI1u5tVTgdih/qByQdu59g/XFkyEsoUcUCIS
 m6LP6oYkrwt2wIWCQijTogsRQvu3cQpDe1oYpO6bwkUVoGaHs+nT/Q0MOz6Gz6NKsDo+HMcAmF1
 JD63ybCTF/GcMXWTwLQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-28_01,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 spamscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601280070

MMC controller lacks a clock scaling mechanism, unlike the UFS
controller. By default, the MMC controller is set to TURBO mode
during probe, but the ICE clock remains at XO frequency,
leading to read/write performance degradation on eMMC.

To address this, set the ICE clock to TURBO during probe to
align it with the controller clock. This ensures consistent
performance and avoids mismatches between the controller
and ICE clock frequencies.

For platforms where ICE is represented as a separate device,
use the OPP framework to vote for TURBO mode, maintaining
proper voltage and power domain constraints.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 90106186c15e644527fdf75a186a2e8adeb299a3..2b0e577fb4c9ed9b746fe70ebccb45da9c52b006 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -689,6 +689,11 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 			engine->max_freq = rate;
 			dev_pm_opp_put(opp);
 		}
+
+		/* Vote for maximum clock rate for maximum performance */
+		err = dev_pm_opp_set_rate(dev, INT_MAX);
+		if (err)
+			dev_warn(dev, "Failed boosting the ICE clk to TURBO\n");
 	}
 
 	if (!qcom_ice_check_supported(engine))

-- 
2.34.1

