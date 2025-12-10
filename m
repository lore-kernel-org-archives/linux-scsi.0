Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F548240604
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765381848; cv=none; b=B27lmJoH5SN6bq93JQI13NuWM5EAHuJQ/gch82cCa6Bas1n+tl6PxYidLxY8MUBc/g8haOJiDOPYRJMeK+UV7KCclaIJI49j1x5snx53WNfmR11yUtC/yCf7TNSuieCb4JCfGSx/ifEXi6BM9bJLGkbzKhZMeIYGjL+7SFiUCds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765381848; c=relaxed/simple;
	bh=CJC+DROpqAY4QNQLhqjy50fvpKfrxA/OYyGOujEXapE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=XswQ34N+D0N60RF+xDOqhgJGWO1CzQzg4VAjd5qwU5NIYNRRTtJohwMWDJ2BwENz2qoW5jDcKskt/3rI6QHz2eL9+1kzFZ6f7HlhHbieG7nExsAMwke8YFBHfRltdkcTlQ7SxMduWk7ryK0Hk+4Uo+SptrW+ngtC7fK93yTms5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TRFis1JM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZQv3Mkdd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TRFis1JM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZQv3Mkdd"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA8e2eo1934095
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:50:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=NulxUS44q4FBpIRfW4Izyq
	Bq6K6Z/xTMYm+Fsi6EhJ0=; b=TRFis1JMuMahG2Hl5jQPYLG55r+f8IJlvE4fL1
	tqu+xd557fAczCjPJ7cx3nVeSREsds44EWlYHRT43aPxAduRq5O6bRGWo0ulitDp
	ga5PZ385yBcklLbBDdzbP7L6j9+2LVx6L1X+fkBKTfYdddvjRrB/N+TWWxjoswg7
	qHxn6p6sVG9ejGfiOiOsJQwBveW1lCPgPs7Tgs+sssu59LBpw5256HxmerAeLoTr
	ilRqp5pxUzzbo/k98blqNBAW3IpuTQzM5Ye5rV3IgWkyUj5zwoUPdGvp/kHBUiha
	LUHfEg592gHYY/JB3ctMirC0pI3M5kruCvsk0gHtEqHLZSxg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ay505hemc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:50:46 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-29ea258c1d8so44791085ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 07:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765381846; x=1765986646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NulxUS44q4FBpIRfW4IzyqBq6K6Z/xTMYm+Fsi6EhJ0=;
        b=ZQv3Mkdd7OVeVco/q2GjpZ3Q2Z8nm6guM1ri7YAVoqYp+cAr9viRKS/U4VHWQXEnyC
         Ox0XYU219oZWQmZof48/6jIqEVSjlXVtYhB3iPxVbeZijcgD78WoabFOa1oBEoDoThFp
         DcX3hRXcs4PUnV8w+RDJF7aJHNAzDBpXUqrDstaDmybWG5vi3hFu9v+t0aPRc3VkY8Hf
         b2JcbJ2kgZPlKEoenElTs7ZJcm1Gn9QJBtQAErwkFZRu50GM4Ifv8m43nh4bTNMK71Py
         OwjGZOgRze7YjHraqdpm8M1guu/KmxCxkHuxLk+FEQ9vbShlSSoThKLO4L8Lku7u3hRC
         epxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765381846; x=1765986646;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NulxUS44q4FBpIRfW4IzyqBq6K6Z/xTMYm+Fsi6EhJ0=;
        b=R+Z61i0zicJROWQvvhMJLb1Yj1vWcWIVST6rcygNIKOWPCaMnLC4vTlJfwm1UEUSGk
         5g57KTSe0hFEZzS3PocClCTkOBh/xTQ3pZsyznFFi8WFTX22XR2URChsdff+WJ7qCV9C
         qKXls4Tr7i3CpU2Z8kjponuKBF+2cTTI5ZIIdCjBrwo6i/DiIcKM9vFDCVSQyqDyOM4f
         y62L8sb7OBf0u/p50BiJXcD41PdCCkq4C5BXYlPVQ8uzAWckJqNvPoiMgQjO1Pc8b0Uu
         KOZ7PixHPLRmft8BaAjG9wCQ+qn7OcQuoRWYYwtTn/mAP8I8SV/NdCAFKNYqmgNxA6JV
         akZg==
X-Forwarded-Encrypted: i=1; AJvYcCVU+FOUI1Q97fE3kLEvb7zjsB9WvO5jQgd8DLrmcPEBPgzKRTIqnWe7YNtNpycv/WTfUfWd/ENf6Zb2@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2F1KkNOTzoU24u1Q8hULb35qGjHhWCSVUn28K3uCozh5xmP9p
	36CDzOpGTwu9NVhDQiglNXMfci9KYIioWod0Dk/g8lm4oI3Kg34fw5rk2rWlmRZC9Ky2NuGXwq/
	pUUwsW7wB9UOZZymbcdFcCsG0sJmwhdf6fLH3jRz0tJrNOj2j6ZyMIiUWTK4aQ/Bm
X-Gm-Gg: AY/fxX4wOTg35eBr7QujQB0tNGmq+VU9iS19SwVpj8kgR3cP/MXY/KTj9JzsS1EjnKV
	AWA6QRSeGmu+I8Jq+w9ifK963KpzDQwLMmhG5ohxhD1XXiIwel4Lm3E93LY7oFzWS1VRYY4YjOX
	Jioq7EAnI5DiPJTorEBpf2LTxd+mmc6Md44x70ReJy65OcKePGdM/kpedXZAiFqGEGEPMDxMLtW
	Lao+A3iI/G8D1fJ4HJ3ybiHnsBnb4rrW8mXCPMMbEL9/y8/85mT6050dE4iuVQjFZkXH/P95vay
	m3pabMK9vUQzrsl3JyTwAqVkB84+w8Ze7KdUJS0EkYzRVKIap2xd4RaIcTjbK7N+cfQVRBwb32c
	pzk9DiFETWaUQT9yx9CcmKGY7a9mWLTZWzHM19GsL
X-Received: by 2002:a17:903:2392:b0:27e:ed58:25e5 with SMTP id d9443c01a7336-29ec2336e12mr25888255ad.24.1765381845671;
        Wed, 10 Dec 2025 07:50:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG3gH+i/zHIlcdt8+wxcqRZ+TZJ5GPY3sj88E5SWloC3HC6s6uzsDjv2kRl44b/Cx/Ft4XdOw==
X-Received: by 2002:a17:903:2392:b0:27e:ed58:25e5 with SMTP id d9443c01a7336-29ec2336e12mr25887885ad.24.1765381845124;
        Wed, 10 Dec 2025 07:50:45 -0800 (PST)
Received: from hu-rdwivedi-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ed93e470fsm7780175ad.41.2025.12.10.07.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 07:50:44 -0800 (PST)
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
To: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, ram.dwivedi@oss.qualcomm.com,
        anjana.hari@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/3] ufs: ufs-qcom: Add support firmware managed platforms
Date: Wed, 10 Dec 2025 21:20:30 +0530
Message-Id: <20251210155033.229051-1-ram.dwivedi@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 4vXDloiI57JX58Sz6JfFyCjWe03lHBni
X-Authority-Analysis: v=2.4 cv=Bu2QAIX5 c=1 sm=1 tr=0 ts=693996d6 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=fUx3pPj6L392ZWVjOsMA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: 4vXDloiI57JX58Sz6JfFyCjWe03lHBni
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDEyOSBTYWx0ZWRfX8km3f7LCytEt
 GcXJyz+8tC0jD7kycuMvQxITFG3cdmbOsyt1687YpKZagMvEr1ckp5OTJAd7Pw0m8OIaenk3FCU
 YHyzsf2o24mjVzIp+4HVaNiaLIp4k1ahHkB0/BZ7/nD838NMzT+hqeciO+sE+ZC4/F8ln0Dgn+I
 bqoAV97FSGASv4RoqruTVpezKie94ZE7uc/IyBa1h5yh4CbudaOdg8Itz9iNWBNLD/J7HqZXaRA
 5gQRmvQiNLOXPfkYU2dSZHAfhGYb6VPXlMNf2VoK5Fmyy/8FSO1Iw+slxPSvNuxJHyHuaI1xsqI
 w+X3/OQm2If7JA5rkig3RuuqnuSqCb3yLOxV0kzDRHSKEu6B8GTbpxuUwFNusbfb9XJV2FdT1cG
 vgk5ODp78GIS4VI1RVvKUhG4+iTRGA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-10_01,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 phishscore=0 bulkscore=0 impostorscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512100129

On Qualcomm automotive SoC SA8255P, platform resource like clocks,
interconnect, resets, regulators and PHY are configured remotely by
firmware.

Logical power domain is used to abstract these resources in firmware
and SCMI power protocol is used to request resource operations by using
runtime PM framework APIs such as pm_runtime_get/put_sync to invoke
power_on/_off calls from kernel respectively.

Changes from V1
1. Updated "dma-coherent" property type from boolean to just true.
2. Switched from QUIC mail ID to OSS mail ID.
3. Added Acknowledged by tag from Dmitry for patch 1/3 
4. Added Reviewed-by tag from Manivannan for patch 1/3

Ram Kumar Dwivedi (3):
  MAINTAINERS: broaden UFS Qualcomm binding file pattern
  dt-bindings: ufs: Document bindings for SA8255P UFS Host Controller
  ufs: ufs-qcom: Add support for firmware-managed resource abstraction

 .../bindings/ufs/qcom,sa8255p-ufshc.yaml      |  62 +++++++
 MAINTAINERS                                   |   2 +-
 drivers/ufs/host/ufs-qcom.c                   | 161 +++++++++++++++++-
 drivers/ufs/host/ufs-qcom.h                   |   1 +
 4 files changed, 224 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml

-- 
2.34.1

