Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA3F2FFF8D
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767156981; cv=none; b=FNASxeJg793SQbBiOJVfmwqfDLwOklVRvwZu5bwlR4yf2rmNNcEYtDfzX2MqrPmux2QoAv3p+kqgj6xs4DIQkvP8T51mLPG1ES7VwyiOz2TxxxxNqLphLO8fz/L46m20oblmxYbGOl4DpysX7PnFgN0yBdnddKhjyYLnCYO0VTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767156981; c=relaxed/simple;
	bh=2dG3MDNKrqsWAhzawNR1aoHF/S/qOVLjUclYEMWpaqw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=j+YyuSCZI+8Qb80GT7pNiqxLrZprQ0pzPfRsKf8pG4tYFuDeWGcO+b0vkepM5G1gNZ01hElP7Jl74I+QLD0mRdk/WRCppCvRpjeymG7sHGEeHW7TG9DYscUEUfr+QeeYy+3AdRpjTS+du6WwAcEF6YIqsXb51ihN4SwFdRf+6ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Id0mqPq8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GSr9X0js; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Id0mqPq8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GSr9X0js"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BV18YaV2004587
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:56:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=d7rvefi3WWPcYh3ySNgBvn
	5BaqhwKnptGAbYBu0AxzA=; b=Id0mqPq85mgCjfcRs7ruwqejhUhhsivXoke9CF
	EgPeUuqDIR6PViQzVBWBSGGjkWX09IrvlEAlw4J4zsQMxRGcBXadHLj/cgXzTvoE
	jB6qPAVGWdJGrBd8sJ+NIf33X8JNugpJ4EtBIEctnx3k6FB9wEXzKXBDhIQxHW91
	17+KvnwFP8XKhDQDZRIYV5CLwoD3TNMbkVskXbgO/0oGoQsXeGO3XbRaaOghW1Ff
	qiVF9MEcqM5AlgYEuumFobhids75Amx2OuWq34jyg1jdINR9YCIkQlvV8i+/gmcR
	pk196LT1YLglIS613FUCSYD02JG+U9Npz0ONVMdngzFX/EhA==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bc7462vg3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:56:18 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7dd05696910so15754090b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 20:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767156977; x=1767761777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d7rvefi3WWPcYh3ySNgBvn5BaqhwKnptGAbYBu0AxzA=;
        b=GSr9X0jsFX+5ukc3FHsV+P0svk04yXEDrJIkQKMn0MwdFWlsxUSX0e2S/Ft9ry5KBi
         CG2RFdv0ZaCsTCV6Q6/lrGfNg2iegX5lOPbIyUBBj93KWVUKKpruWTs6N4jphOmOnPfJ
         9IOkbVRHnxpaOm81h8rfJt8V9WKFWxaiPUuTVmAYpy/gb5jESTpKEoYzH9pbNxfpxm5l
         Y6wJdcKHS1joQJiJr9uHp++P+pbY7pTjxoGPFhDs26fnYlc7dr1+6yyI3qPOP1FBcZt+
         1ILtC7y1VDUhUwWMtHrBfPbxeTH/Cf8o8mGDecgDi2167fEhNEztth016RblAXNveiUG
         T/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767156977; x=1767761777;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7rvefi3WWPcYh3ySNgBvn5BaqhwKnptGAbYBu0AxzA=;
        b=Xf3pf9EX1DAjjde3ruY/K6cpHMN3+dWCB8X9eyUqKhZhfoCWGdJ/cTVu5IjhR+hYpq
         F3ttHhf3lsIXrN6HTuV/HtB6YSRW6wWxN2L1D0V7/jUOyjFGA9PjEPl8xs1B+o1TUjMB
         qoXK0MJ7AdAvTAhybYB1snzlhSWiKujA3tTsda1310x8BKKwUpLV+7ptiBUV8sGX+9aL
         59rfIrYooQKrl93djAYvlXhw3jpCja19I+HlPCJ8mLsK4Mn65wBQA7L1uZijCVJ0emoX
         f+K7LUg2NiOUPJBtnpULThlnURoqJQHX6awHqMHlrPT3cQarJNbqdhpy/sn63voOLqsP
         jFVA==
X-Forwarded-Encrypted: i=1; AJvYcCXYkRVqAHati0RFQjd/uMqEvUDTl/KEeNuONNOrBueiMqEC5bLGBF8hlfDs0tZRuxELP8LhN8xxzy+u@vger.kernel.org
X-Gm-Message-State: AOJu0YzXZszzcrSs5p8HS/Rvc6zdn214jcqV7HBjje2ZymNax+Kcm9ge
	xrWOUcZOYNF7inC8/Q4//zY9N5HGh7AKb+fvAE6kzY/exzPAa4MxiLN9PftNng90NVxshED065O
	BWDacLFHuWeeMVSDBID8AIbpj8ny/pD1cx5uRLk9EPadf7ooTyJ9SGx+NK/xxYuaT
X-Gm-Gg: AY/fxX5Pb+SvtpTr8XbC9GjA/a8t/bXn455VUVVAXGo2MSILaYLcchJIoUxD93BYcIi
	67t9tFtCfMXK1nD5OIgYX1V1LqglK1w1HvXw2gr6Ae6HqWjiSbiOt5WvHIGhW8FnHrk/nKqdp+M
	p+Fem2kxetHT1HbIiRQXTWxUihBmMPa7ouBeM/XtJhZLjGQ9+u6wtqwa3zz0MP7UytWnbg7VR4Z
	7uvValDGOtctZZKbzDyljho2yGVs2LGAEcAul/WM7oseNSwQsvNuGOie8G/iKAJaiSxaYTFqf+f
	F1f/e3SO9XRllE7Hgm5STAhfH7uJodWrhjb8D3y0gy+ePudcJKpCMGOCsqLJJTBLd9YjXD0l5yG
	P+6cQydP7s0lW9P8imERLPxWkq+dsPFcRgh/D+/ys
X-Received: by 2002:a05:6a20:3d05:b0:35e:3cac:858c with SMTP id adf61e73a8af0-376a8ac34f9mr34412537637.33.1767156977466;
        Tue, 30 Dec 2025 20:56:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFqLBdf6uMV8DFh0VBlMSGuSu9XN2RqAwG0fovaAX+nmtfBnoxFFDcU82fQKsczTZQJYbMk6Q==
X-Received: by 2002:a05:6a20:3d05:b0:35e:3cac:858c with SMTP id adf61e73a8af0-376a8ac34f9mr34412506637.33.1767156977011;
        Tue, 30 Dec 2025 20:56:17 -0800 (PST)
Received: from hu-rdwivedi-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70d4f7d3sm34547697a91.4.2025.12.30.20.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 20:56:16 -0800 (PST)
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
To: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, ram.dwivedi@oss.qualcomm.com,
        anjana.hari@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 0/4] ufs: ufs-qcom: Add support firmware managed platforms
Date: Wed, 31 Dec 2025 10:25:49 +0530
Message-Id: <20251231045553.622611-1-ram.dwivedi@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Do9bOW/+ c=1 sm=1 tr=0 ts=6954acf2 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Nxr8sekpfmpq4ZlREHgA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-GUID: hxT2_V6IAdi77MMgxAFgBZMnz3vGMOzt
X-Proofpoint-ORIG-GUID: hxT2_V6IAdi77MMgxAFgBZMnz3vGMOzt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMxMDAzOSBTYWx0ZWRfXzQJAh8kA+YyZ
 7VV0OezKqfYH/+avo7ha+K5ndVYcgXTDPtesokWrP9yQIoUi8+LRzNvR3xazQ0++cOcLOWV7NHX
 rE3Q6X06ZXjjNDWu7WLxSvh8SIcp9nV3ZEzU6F7P8cAMQw7hfdwmY81kjJ0YPw9+bc25O5dwfEy
 aBFDb7Cayb7TeehNXD+t4MQ2Y0/tLIF8ikhuzwzrKv9B0ZLRKZtUzehyQcbJ8PLRPjZlMifj0B7
 eNQga+pitV9Fj+tcth41iJKV412ErR9aFDd4VjJ8+JfIC4Si+wQzRgvEgzyDtaPzeJNz9a8N0YT
 ze6oVHNNB3kFXos4zD8jayl/xc0RTlGmSoCL8ZkLhzvgbQj8Mq7So6PEkZnl8yqMB7/EQ/SkzyT
 2HJ5Dx6e+jwgQE1UrddVJBtIccvnxrZUAxr+1p6YuPLV15a9BwV6PJ9ig0rCa48HPjXGKqk0xxQ
 aPUCG0NnlrgM0Fm66BA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-31_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512310039

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

Changes from V2
1. Added new patch "scsi: ufs: core Enforce minimum pm level for sysfs
   configuration" to prevent users from selecting unsupported power
   levels via sysfs.
2. Set minimum power level (UFS_PM_LVL_5) for SA8255P platforms.
3. Changed DT example in qcom,sa8255p-ufshc.yaml to use single-cell
   addressing instead of dual-cell addressing.

Ram Kumar Dwivedi (4):
  MAINTAINERS: broaden UFS Qualcomm binding file pattern
  dt-bindings: ufs: Document bindings for SA8255P UFS Host Controller
  scsi: ufs: core Enforce minimum pm level for sysfs configuration
  ufs: ufs-qcom: Add support for firmware-managed resource abstraction

 .../bindings/ufs/qcom,sa8255p-ufshc.yaml      |  62 +++++++
 MAINTAINERS                                   |   2 +-
 drivers/ufs/core/ufs-sysfs.c                  |   2 +-
 drivers/ufs/core/ufshcd.c                     |   5 +
 drivers/ufs/host/ufs-qcom.c                   | 163 +++++++++++++++++-
 drivers/ufs/host/ufs-qcom.h                   |   1 +
 include/ufs/ufshcd.h                          |   1 +
 7 files changed, 233 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml

-- 
2.34.1

