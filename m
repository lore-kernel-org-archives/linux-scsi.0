Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAED53D301A
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 09:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779786619; cv=none; b=Jm9rw8LpiQqstpcdOhPkPq2OeXeQKLjSMTGVSoAKXOGTbPAxKDLzJGDYBMJO76rTX3WqhZ12mTTzeNwtzyZv6eDz+RwXFrc9jO9v7jEVQDJ0mIjzVlHuxGAURryNfCmWhJLfXDvl+qIt/MifDaLKeBKFcMtBqlEOfomC4Y/+e1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779786619; c=relaxed/simple;
	bh=Jh4GLxB6Rml7ZWF9Pmj+De43LcnXHClRiwWLaGtJ/UU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XTWNqjQ4Ins/8V6CStuf45aObZxUlJsdHscoIUVwNvv7ELnTw8xSAIDMWAxStqwBw727/ndZZiY9D70y0ZWz5Im1tEa2TgnS9vltvHxUHFILok/XgHfcO/LTLOZXh5MKiYl44FkwVYDwN7M6A8lOQbUw9Qsu8c/09mPJtFAorf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=USZUTzBg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JmTQrCPi; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="USZUTzBg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JmTQrCPi"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64Q6mSS43263539
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 09:10:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=m4Lq8YbuP0exEB+3/26cPn4yY9bT/1N5VNN
	durUkg00=; b=USZUTzBg4njH+5H/R99S3hfvmuV1x5rFLxsREzth4h4en8DAcwb
	PFfU31E6QSzZbxRMa7nXVE65qBYIco+UgZlVNp7NLAef1zxXb4SJ/9PvGPfK7MvP
	6R4xlIackLmYwSJ2yqCK3qHsHrXC4edEVwGK+dc25YuAAhH0eOfizcquCH6qw4zK
	4+SUwXzX6cH/ooTohGOU8ddRf4xObEakPTJu/j/8pjeJOH6IzAWYltPnUyMuBwEJ
	rGBL/uuDM7ciXD4TEGwFRdz02sysfCdcQiDkzkb8lYd97jXel7hWKlVRyTD5EaaN
	DrjvKFZL1MrnJIjFhvD6txpTibGSdtyfEwg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ecnhs3n8w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 09:10:13 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b9b8137828so105644265ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 02:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779786612; x=1780391412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m4Lq8YbuP0exEB+3/26cPn4yY9bT/1N5VNNdurUkg00=;
        b=JmTQrCPiOy/z54R66LiZ3AZAAsHnK9oSa76phr/tjP/59w3FGc8RybYhEAkXvh+x7m
         Wtt2Cn3q6NMiAFfvzPuN5f6Qb7o2C7gsEfwWClkzdB7vaen1v00fwxoZ9bKIiMM9sHqA
         XmpfRQZL20MdD5MuYFm7mvFJVcuUa2jUjhst6xmlim8nlASXyVg4zIY65d037P/wt0RM
         i7cdaI9UZxI1c1LiMgvhcC6sQ5ZpZ8ir2XvSjmFlWCGsTaMEIFI0HyfAyzrgdXKA8I4u
         FRNWItHHhdS8l/hNRZltyu/8R/4+wRLNDU0d5/VyerWwgWmMcngX0xfWAr8bETF3C48C
         tPGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779786612; x=1780391412;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m4Lq8YbuP0exEB+3/26cPn4yY9bT/1N5VNNdurUkg00=;
        b=hDQ8hSmU48Rjnax5/yo4SxK3cuWutxfa4Grw+qfEb/pwShIC5XJrFc1pMc8k7KWiWw
         8PcW71Iy14D8XyIJWGl1apZnvqrn49NUExGiDAQianp4lwavrI58EERZ273GjKoEmZXc
         KKuDBHzQNhgzdQtVyJzZ2zDXUXZhIjyFMUh4SMUvxSU4+izBQr5e8CHNc3OjoBBHcXNI
         c59gpnSaXtuUFneBbZ9aLJCSMJSUrtexZfa8ONDJsmncdIopdkvYnu1HgFfpoHrQ2XII
         djOwXC7O7/aizjXRIu1CnuX7SqAz8Q+6ONQfVFjIf9BeH18E1Bq36GlCSyBdUdZHaLRb
         6ugA==
X-Forwarded-Encrypted: i=1; AFNElJ9imG+JuCuBSw8GrE/FKipM44Ink63A3YnDNN7Rl4/ed/Bwfvup45JOH/qKqyBYcpVyXiuPHZzKxBBF@vger.kernel.org
X-Gm-Message-State: AOJu0YxAbSonLAWAK7ZN+Ja1mSjsfMrsYrXJsR27h7coTY0uS/ege62E
	hUjQhLMpGdajE9X0IENhUTuB7fchGPFzsMVfV85fxUGaTrp6I9AEE8onj9hbUpAQYE8A5143Oxg
	O6IqNDiDqoNbLahitfoxuofjWC+YBhJe53SfJI4HOoHDJ8ckmiVxFCFYgBnF6PWDj
X-Gm-Gg: Acq92OF34dycLGsoF/NexYMJoitzrdfhY5QSTC3JDyS+iiHDOdnGqenTFWLcXaxwbnM
	iRQRG78loZR9ioRP7nKGMMeu3z8JdSIvQOW3tYoF6plXRC29Si3hRYROdCZcjeSKhkFt3LzvoHB
	F7H0kFaKOba77fEfzJ9oc9LKm84Oeb8XT2opQuqM3q/QW9Ewsf9Cu2ofj2EQ4ir3YYI7bchybHs
	CXSp57PzGapuzMKp5F524QkCDlD9fzfwMjgkyFiP472W3TMhjelsxvj1R5uQXShpbZkc25xTSgI
	p577ZuNymGjy3do8CiR9qkRUK3AlvMFNZNumR+l+8Lf6v1qGKiBN4730sRozCA+lxZs4D5WRuNa
	9OvyIKFXPW8/3bBmxwQFRrp9zCu0PqMR/VlJY0dLiVgtNocXClAkNCQ==
X-Received: by 2002:a17:902:e845:b0:2ba:4f37:d3a7 with SMTP id d9443c01a7336-2beb06a63c6mr206020165ad.27.1779786612148;
        Tue, 26 May 2026 02:10:12 -0700 (PDT)
X-Received: by 2002:a17:902:e845:b0:2ba:4f37:d3a7 with SMTP id d9443c01a7336-2beb06a63c6mr206019725ad.27.1779786611626;
        Tue, 26 May 2026 02:10:11 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb5695a40sm109237915ad.17.2026.05.26.02.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 02:10:10 -0700 (PDT)
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
Subject: [PATCH v3 0/3] Add Hawi UFS PHY and Controller support
Date: Tue, 26 May 2026 14:39:53 +0530
Message-Id: <20260526090956.2340262-1-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Vd3H+lp9 c=1 sm=1 tr=0 ts=6a156375 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=wRtOOnJjwWicnHpPwtUA:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: M5HWT9UZdbWyXBfPK-VlG9EB-xs6U_iD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDA3OSBTYWx0ZWRfX+7fbl3KMQoDc
 NJGMwA/m3LedRS8xgilwVbrM6oh9A66KXTzABcHdyIYnzLQ55PMmY5QH2gfw0d7LsolSobVNYmZ
 P7MwizPAz2Meq9VnSDNQj8LJdYijOAxxumXdduIvg9JV8RdNewgUfTLHh5sjLm7y0VzoaZb7jnV
 OorNOn1Ls/IugRxfO51ph6DQUCK1u0cAPa8fxmtd3qDFDKJsg8Ll8q6Sa8GERRSVZxtEWP79WFx
 0tCHdX+n1N7v7V4Khc7olFElqRiRlbkRHq9jePpfAXl9eKxwLJV5R3LWTYimPT7a/lhKYhvZsgb
 4OF4RncQ49XQq5OTgZUQkSq91XQfHkOfWlWGShEWdyoXBdXsVjnZHxTVumxU3QyVywSdyZQQyDX
 9iaCTVGU6WsTLP0x5zWbCesaIPl5VlpySpKTxEMSJXts6y6MvE3xrwt3l+YSujZuQO81LDR1R7C
 ocss4OV8f1cEKNgx9Xw==
X-Proofpoint-ORIG-GUID: M5HWT9UZdbWyXBfPK-VlG9EB-xs6U_iD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-26_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605260079

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

This series introduces devicetree binding documentation and PHY
initialization support required to enable UFS on this platform.

  1. Devicetree binding documentation for the QMP UFS PHY
     used on Qualcomm Hawi.
  2. Devicetree binding documentation for the UFS controller
     instance present on the Hawi platform.
  3. Initialization sequence tables and configuration required
     for the QMP UFS PHY on Hawi SoC.

---
changes from V1
1) Addressed Dmitry's comments to fix versioning for PCS and qserdes.
2) Addressed Mani's comments and fixed missed compatible string and
   binding name correction.

changes from V2
1) Addressed Dmitry's comments to remove whitespace and stray line.

Palash Kambar (3):
  dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add Hawi UFS PHY
    compatible
  scsi: ufs: qcom: dt-bindings: Document the Hawi UFS controller
  phy: qcom-qmp-ufs: Add UFS PHY support on Hawi

 .../phy/qcom,sc8280xp-qmp-ufs-phy.yaml        |   2 +
 .../bindings/ufs/qcom,sm8650-ufshc.yaml       |   2 +
 .../phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h    |  24 +++
 .../phy-qcom-qmp-qserdes-txrx-ufs-v8.h        |  37 +++++
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c       | 139 ++++++++++++++++++
 5 files changed, 204 insertions(+)
 create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
 create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h

-- 
2.34.1

