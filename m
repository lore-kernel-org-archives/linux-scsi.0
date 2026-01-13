Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FAA3624DD
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 08:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768291287; cv=none; b=PO/RMqrnh78y41/7dibdytiLGcatftpWua3nGdG4QZGF/G9mrmrsjQMZbx3q70G40BB449R2AaVLb/o8TOXoeyzwixjke0REuQKna42IlKR2CMQDzFfIeo3ug9N3qChyXQEqmA3ivqdV26D2YjjAiteL9/rfCvoDWkQGNrLoGP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768291287; c=relaxed/simple;
	bh=8pPIKnJcI5Mf+HjhRpi0stuvWU4pMxlGix40vfOJ/gw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=bbdKXAzBgQUpXEUHTTergr1rBuAOGzNfgXj/oJPk+fIXaE5Jj+2fomzxxnRMDkbkDGe0BqbdE6XqMWKCe/sFkz4ueB354jqPQk9th9i8v/jCxXvm9YxZqPm5ViytjueCRY/m6z9OIFWfPzFiI9OB460XVlyKLjHiPyHuw+kHO+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dcZbl769; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RIbzLaoT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dcZbl769";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RIbzLaoT"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60D5nRcN3735049
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 08:01:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Gc3rkkafnnxjPSIOAIrhhn
	X/jj1SiI4kU3VTMma0oWU=; b=dcZbl769RtsVbRO+Dbs+8B+bYcqfZA/sx11Z0c
	AaxpJ5qVxc59dTFWdm1H3E0aGWrCosGW3lm8L0VdxwSZEWkRRXXm/aXpLS9I9cJ9
	4JAmkx5VffXg8dqRXKtB/jko2jcivkaS/0y+gP01GsDhpX8oGfnw56txiMuraG7T
	MUNv5ZvIBGPLzpzWCyLe8Zf/3SfM0aMLhEqMwa2fnrOJNgVyYaea5S+CYIypK+IU
	5Bk/EWYnq/HX/Bx2ak9dGmlHgbWc8PnlphFBQTlpneXjkP9t2wssjpYPHEHIZM5D
	vJ8Tm8XbLMj3YeMjKuvrT+oGdT6WlYfjRS69tUKl8aHq+1PQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bng878bdf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 08:01:05 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a0e9e0fd49so53325205ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 00:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1768291264; x=1768896064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Gc3rkkafnnxjPSIOAIrhhnX/jj1SiI4kU3VTMma0oWU=;
        b=RIbzLaoT/cKOdsp7T5bvii49sARsbQZOMziAOuFsdaJjY392Qy2RfjGA0mR1gVEiZE
         CpSOTm1bDZKzgJ6Xj7X2GG7hpLzrvvQYBnMYVh7wDiRR8SxNm6Q62hoArvFyojJikJjV
         L6hPEIj72wPO0zd0FusovtBviKo1VmI9IHu1vb7G0AYvEDBlPSDoT6tY1mxvmY27oajn
         DV4xFG2237WkIpDMAoxZ8Tl5hhbKJIR/WJyVfg42XDIcbC15zBjcYioDB5av6klQ8AwP
         +WVl0kfL+YDA15Tn+FoD7cw3o0ya3FAeyRqiS3kuBguKPMpsBMIgFXa1TOyK00p5Got5
         tfPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768291264; x=1768896064;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gc3rkkafnnxjPSIOAIrhhnX/jj1SiI4kU3VTMma0oWU=;
        b=MBndGZO84foXpXAEBXCofmZMKNcONgWEZq84V26NXLiPS0U6klnz8GozaJanQGbW5C
         KljhklZFv+EFvUEtSbB2OzZCycNp2X7pHI8uFGsXWW+od4F1sw5okkhKU6CU1CcDfMSD
         r2zA+7DSAEd1g6kWJGPpG6j7LPysiqfAkWQbkmxNc37mKE4i69sv5Q946QkxQzJWPmou
         AZfi7J/oq0CAyle86ks6LFujPNgSYDFUrSDKBixI7NRaOvjnTjEKpnRXb/2IccLmeBUX
         j8roZy94X77k1FY8+cnbWvKjZlE98RJC6+8yXKCgv0QFFrrIrv7WbMQuSMbq3WL9SNOF
         S6zQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+po2KlqPyd+dzcI11Flm9MZ3QcbHAOOXhOmyoG4qFTPTm63iqu7QRFiXk/upwULz4fPaprMQjAO+D@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/fXnxabrZF84vHu5aT33OpUFPfhSDUMIlt9+CNUu3sg7BeRiT
	4G+bzzAn5d0k72LjbGBmFllImsdCrl4Hc1RASIsNXgQBAssBfDn+hEWon2Rl3mJRDY+rN8coJuY
	p3zCYiKpY4fjRKQomKFD84CjwjWlGkfP9RG9TiohWrlYz36Ny1Nh06O1/Jda6mDDv
X-Gm-Gg: AY/fxX5MwtuPBK9H7WMMPojYpwPWLxKO/SopDzMxK4XV2wALvrKLcxtv8zhdw1AfmLz
	Z+LzTkSbdWbZhP804sPKIMjnU81P4dbQIRsiRuIaIkvUepGmJRQDwNDdCIVMLJG58jlY71booGg
	7ZpI/c63ZE8XdHyXAkEKKxNEOzWREWN23kdVm7lYUQ7IjtX8AyxDU6fOjKH3KYqgeWVUrpQyBte
	uhE7nTEwCQQsJrVcRMdPFCOCZCL3bowZOBpDzpcVLHhKosl7aYFj2CX1ec9u7WVhDLx0ri6AnMJ
	jWT794FqdcU4807EqDvMJ/SjQLg+Xh273ypm2AiB2csBbCNHQilzhmdMFKkI5dhDDUj/5jBQvuj
	mzy/qb2AizPnfUlE0XwBDFsAGZ+EDZULzQyR9TU8D
X-Received: by 2002:a17:902:fc84:b0:295:592f:9496 with SMTP id d9443c01a7336-2a58b5015afmr17274695ad.20.1768291264449;
        Tue, 13 Jan 2026 00:01:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IERSW7Yb+/5CobzFAzu+FgCJlw8ZLQmnluW6ph/hOL/hrNL+RvpgwJ1qbt0YkWHtnX3dd/lKA==
X-Received: by 2002:a17:902:fc84:b0:295:592f:9496 with SMTP id d9443c01a7336-2a58b5015afmr17274125ad.20.1768291263603;
        Tue, 13 Jan 2026 00:01:03 -0800 (PST)
Received: from hu-rdwivedi-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c48c15sm191132725ad.27.2026.01.13.00.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 00:01:03 -0800 (PST)
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
To: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, ram.dwivedi@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V5 0/4] ufs: ufs-qcom: Add support firmware managed platforms
Date: Tue, 13 Jan 2026 13:30:42 +0530
Message-Id: <20260113080046.284089-1-ram.dwivedi@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDA2NiBTYWx0ZWRfX5YcIzb9MZswf
 bBm/Lwp3Qpva4cwI74sFJLQWQnaDgr/ywABsML648CVCzfDjHbPBOuV0iYt2C12tNH/FvacOxSp
 xo88li6mFCY8nk9PjCzyFIwskY6rMyRi4GfU2cOSwiUlEv4s81uYV70H47283GFE8oY6zYBnlYK
 e1JZSiGVfdONZME3djqUXHdyIDGnW18t7cN1MiHC2ggthhq+5OVmDr67fEzZH7RY3kZ7Yplcz+w
 M10xH5+3W/6nUl1HuAoGCtXQg+Zsmw9k0vh+sCaizs1oRnyPgEcp1PQ4Jf+zhtHoZY6D48x2eDz
 DyVvN/16yxVL5jSNDMW3NyJWcE3B571P8TfVC3J9h8CrbrWVu5VHhEkr8eE/fvps28or4YtZZo0
 qJLlyDOGvv+8UHIHR10eYC7paTRSwVMsC8rjh26Vxuzkb2U/i7eKnQlKDfuqzxrEOc8noOvZbZB
 pmenXR7MKEMKh7eY/sA==
X-Proofpoint-ORIG-GUID: fZlw0EZk53Bag6G92peISDheRLWT1gld
X-Authority-Analysis: v=2.4 cv=IOEPywvG c=1 sm=1 tr=0 ts=6965fbc1 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VSDEYizg4LtL04GxL0gA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: fZlw0EZk53Bag6G92peISDheRLWT1gld
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_01,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601130066

On Qualcomm automotive SoC SA8255P, platform resource like clocks,
interconnect, resets, regulators and PHY are configured remotely by
firmware.

Logical power domain is used to abstract these resources in firmware
and SCMI power protocol is used to request resource operations by using
runtime PM framework APIs such as pm_runtime_get/put_sync to invoke
power_on/_off calls from kernel respectively.

Changes from V1:
1. Updated "dma-coherent" property type from boolean to just true.
2. Switched from QUIC mail ID to OSS mail ID. 
3. Added Acknowledged by tag from Dmitry for patch 1/3 
4. Added Reviewed-by tag from Manivannan for patch 1/3 

Changes from V2:
1. Added new patch "scsi: ufs: core Enforce minimum pm level for sysfs
   configuration" to prevent users from selecting unsupported power
   levels via sysfs.
2. Set minimum power level (UFS_PM_LVL_5) for SA8255P platforms.
3. Changed DT example in qcom,sa8255p-ufshc.yaml to use single-cell
   addressing instead of dual-cell addressing.

Changes from V3:
1. Removed address-cells and size-cells from example DT in
   qcom,sa8255p-ufshc.yaml.

Changes from V4:
1. Fixed indentation in example DT in qcom,sa8255p-ufshc.yaml.
2. Added missing kernel-doc description for pm_lvl_min in ufshcd.h.
3. Removed redundant spm_lvl check.
4. Consolidated spm_lvl, rpm_lvl, and pm_lvl_min assignments into
   a single line.

Ram Kumar Dwivedi (4):
  MAINTAINERS: broaden UFS Qualcomm binding file pattern
  dt-bindings: ufs: Document bindings for SA8255P UFS Host Controller
  scsi: ufs: core Enforce minimum pm level for sysfs configuration
  ufs: ufs-qcom: Add support for firmware-managed resource abstraction

 .../bindings/ufs/qcom,sa8255p-ufshc.yaml      |  56 +++++++
 MAINTAINERS                                   |   2 +-
 drivers/ufs/core/ufs-sysfs.c                  |   2 +-
 drivers/ufs/host/ufs-qcom.c                   | 156 +++++++++++++++++-
 drivers/ufs/host/ufs-qcom.h                   |   1 +
 include/ufs/ufshcd.h                          |   2 +
 6 files changed, 216 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml

-- 
2.34.1

