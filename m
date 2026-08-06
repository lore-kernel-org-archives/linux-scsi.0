Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F62222541C
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 16:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786032794; cv=none; b=kQODcRdqR1bZgKnlEMLeJU2+IFyJolhc96V8+mMtjOu+sg/sqlNga6P7mWc0+raLv1KAzYPqmjbB9ec3n54vWd9Z9xuH9rEcTmp/Sdjveq57syNmkcvUz6vkGAJr+ejkCnu/96u6UrXYBapeqBmiRHsajv8sgyTPoXchqSsNjjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786032794; c=relaxed/simple;
	bh=xM7II/8CoN5Sya9W2Fo/+4FjhIIp2ycNWN33ZSTrQZM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FOaxoWLA1PztOBPcE1YLtiwa3Oyaho6DhIwC3BNuUqj4Dn2x3umhpzuZ5fgl5b1jwloB/cOafaocyY9uevqc630vkvZWm1T3hxhW4oNKxBAADb8O9WwKYnQMcVR2KMkqehMgVx0ICS7240ZfLD/t/BDipw6xxjCcMi2OnVIaQZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NgSgspHZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eCD+VH0e; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NgSgspHZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eCD+VH0e"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676EmOhv1553316
	for <linux-scsi@vger.kernel.org>; Thu, 6 Aug 2026 16:13:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=s6nt1Vjx1KtpZs9U6I3iMDg0ZKhLxL+ifZQ
	JTIvRzMs=; b=NgSgspHZQ1n3OZ4TnRkI/CfSyKY9VbPTpf+0K3LB0SlbZkYsii4
	8dZQR4MeeVG1FSE70O3puUuWnfmE4GIZlANk9gOFR56RdaafCJ65mYZ8G8SgaLsf
	B4XI6xIgBn7n2iAtbT1LV2tuzm+vjKrmSxmiaNFwVhglvgOsttcC/wZtjIEpHHVI
	2wLDXflrewmToPcgx28jGmTwVub5+d2qVlJdmLdt3R4ILSnNNzpewDZG1YHTvbwO
	0KO+LzvAUHDQK65Z8gq6WpyjR0OXn/VLgdxqJTy+JzMxDOB+iwTS/UwaAHqsR7cf
	A0Xrdzf7wywdPrPOEgMhBZOpn52YzZGNswQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvv5b0mgh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2026 16:13:12 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cca5e0a0c9so42467125ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2026 09:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786032791; x=1786637591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=s6nt1Vjx1KtpZs9U6I3iMDg0ZKhLxL+ifZQJTIvRzMs=;
        b=eCD+VH0emoyMoflBWD7zd9VSh+V8FMZ25K2XLo5H9DcsNiYGzBuO4Hv3MZE1QlVVe3
         7ZskaWAw0aM7Hc0oGR9eHUqKsB4NcbvebREEj+SWnC2BxDfvf4eQsPdoXJzx7TyCucBY
         pL6EdlrugArDSlR7UTwpb47Qjoo3639wmwMKqNe6fW1RKAoqjWAv3mle79cygU7TOOJ+
         shavYB61Ea6oknDdLBVt/1Pd6Hes4eZ9PxZm0KsLsLHwpF5niag9J+K0bHjstUA5aPjR
         LWzOCPSyXnbRGnztjYYoTtbDgzrngRcqmEvofxnd3rsYCg08CybVXtN68OHr4br19VQI
         8lVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786032791; x=1786637591;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s6nt1Vjx1KtpZs9U6I3iMDg0ZKhLxL+ifZQJTIvRzMs=;
        b=ljjGPWFQ5XVte9Wcs7xWFLVYlpaMkMEkjaU3pCHuS5szwVtKE2Pqq4hnt/sKY4hwTx
         FJ2q6cIbt7eXJUVRpCHHVhATOlQNf4/9VaerJxZhxZdk58Ed1ZhVM8lUGz05F9rNbFdU
         mqGofoERYwFavc4SGI8HTyTW+Fkq0zj1KDMDQh4jF27ONmt4QgaNMqwt4l2vW2nxVIvd
         /iorNv3uoBz5xJwbB6k9GxKh+92zmzL7EoImprN9DeWJ/mqUfNjtj4OipidxffrzobP/
         CMFcwcdE93Q7yohMZpJcsEVGGLlBFCugxi2YL1r84+9CPkNnWmtvU4o7PEOS8wtNH9kF
         vbKA==
X-Forwarded-Encrypted: i=1; AHgh+RpTLLxEyPdeUnGDSvSv3UL0wPPe+Zrqc7mbDLJn69NNITLz34LyMhr5l3KlN77QFNVNV4SIYyHBI5pn@vger.kernel.org
X-Gm-Message-State: AOJu0YwBaydnXdCAWUgAaX0z018o5dUfcsUE95Qw6Q/MU/XGiJ0hyklL
	Pb9lI/N02b/pIY/Z0jhIMpNuIekC2zUfo56hbYtllsn5vb85MMsrzT/gJWtDZO1NzIh0piPqL+z
	09vlFrnArG44ZL0ULJQGDpv50mpq0ZePgZqmLhG5kqnyqQ1rl3LCkI20HODjUl/4E1e9hUN9F
X-Gm-Gg: AR+sD12BFQItdW441tQCeaoUHznRhnksJwoFJAx2eTMRLxW57lRSa6pGJExl1Orvrqm
	358MSPionhgs04BEifARH4uGhZAh1I5bnsXNlgV/bQOslPRviJY0atGf4gKBIhNLCGma7DM9Zfy
	/CNiyzLOm0CZg0/e803BiGe0pAMcpjM+tQNg1hSfqSYrvB/Jg1R6tZ2rKr3EG56sXX+f8gavgRJ
	oxPGW22anV0UWMbZo/04HRlp/ngbWvjUko1q8z1lmPao4uyIKr2PAytTu74hO+FKfeXhF+CAkBZ
	TUOVGAt1h4hH61ac4pFBQykshIEP9godp4P1Lwe/epjaVU2tenYK8MYiI/HpJ206M9G12VxtHpy
	PtEOtXkBTdwz2BwbuuArslO57tI9v1UlS
X-Received: by 2002:a17:903:1986:b0:2c2:be43:39bc with SMTP id d9443c01a7336-2d0ca9feeb1mr208862475ad.22.1786032791497;
        Thu, 06 Aug 2026 09:13:11 -0700 (PDT)
X-Received: by 2002:a17:903:1986:b0:2c2:be43:39bc with SMTP id d9443c01a7336-2d0ca9feeb1mr208861555ad.22.1786032791000;
        Thu, 06 Aug 2026 09:13:11 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315863b761asm43074546eec.1.2026.08.06.09.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:13:10 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, andersson@kernel.org,
        dmitry.baryshkov@oss.qualcomm.com, abel.vesa@oss.qualcomm.com,
        luca.weiss@fairphone.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH v6 0/2] Add Hawi UFS PHY and Controller support
Date: Thu,  6 Aug 2026 21:42:59 +0530
Message-Id: <20260806161301.1010876-1-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDEyNiBTYWx0ZWRfXxvyHSmMInFBX
 lOIW4+1//yHqTlOx6hy/4cVuwuUIQQBHwZF63BMMtM+OJEftRxXW9bJlY1KahdLUdV0wpnn/u7Q
 j9XksZPE5Uay4I/Q4TzUKA4t0z2LmCFC3Gqo5hwgwgSoS90YlRdveVmF1l9OYgVijnftnNyCjq/
 ZsELg141FYl5LqC4qTAprxsMiJoLRlqT66VM8MbAW981/65xjfVgQFEjoj2nXKQg5zYQi89ZAYo
 ZcrHWKu0mHcFH3luGEdmvrlPHGkzoShQ2EPlbez8kXspdVWxt70pEGbLfuT/WDtVI+Qk8Vdo3hN
 K5GK7xyKXrcDiNhKKR2cK4bKPpXOn6Ts1DymYemKyN/CkA9BjxiyMMbtTZN38DvZzg0v48viX/T
 bm5MM1Qm9VO9tc6W6dSX24yVLzSozwYjtJsCB/KT0Bxfj1Gx/UeW92QOHF3aI6vyIbagDQLI0S8
 +hD6+5zLORvh6kCPk+Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDEyNiBTYWx0ZWRfX9HzXpO8Gzke+
 ICQepBaocGWwC6H5HuBrHvpfvJ5RE+YsaZtNDXqKtwh30ts7rJtX3UUXSHEjhSp2qvgkcxAsVLH
 taoDaNrikV3dY310w1gfIAWnwlnofyI=
X-Proofpoint-GUID: peEQm0oXrJ4akW6LEuA9HH5IST0Elt4K
X-Authority-Analysis: v=2.4 cv=W4gIkxWk c=1 sm=1 tr=0 ts=6a74b298 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=wRtOOnJjwWicnHpPwtUA:9 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: peEQm0oXrJ4akW6LEuA9HH5IST0Elt4K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-06_01,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 impostorscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060126

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

This series introduces devicetree binding documentation and PHY
initialization support required to enable UFS on this platform.

  1. Devicetree binding documentation for the QMP UFS PHY
     used on Qualcomm Hawi.
  2. Initialization sequence tables and configuration required
     for the QMP UFS PHY on Hawi SoC.

---
changes from V1
1) Addressed Dmitry's comments to fix versioning for PCS and qserdes.
2) Addressed Mani's comments and fixed missed compatible string and
   binding name correction.

changes from V2
1) Addressed Dmitry's comments to remove whitespace and stray line.

changes from V3:
1) Addressed Vinod's comment on missing macros.
2) Binding patch for UFS controller has been merged, so removed here.

changes from V4:
1) Rebased code to tip.

change from V5:
1) Addressed Vinod's comment to fix register offset formatting to 
   use lowercase hexadecimal values.

Palash Kambar (2):
  dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add Hawi UFS PHY
    compatible
  phy: qcom-qmp-ufs: Add UFS PHY support on Hawi

 .../phy/qcom,sc8280xp-qmp-ufs-phy.yaml        |   2 +
 .../phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h    |  24 +++
 .../qualcomm/phy-qcom-qmp-qserdes-com-v8.h    |  13 +-
 .../phy-qcom-qmp-qserdes-txrx-ufs-v8.h        |  37 +++++
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c       | 139 ++++++++++++++++++
 5 files changed, 214 insertions(+), 1 deletion(-)
 create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
 create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h

-- 
2.34.1

