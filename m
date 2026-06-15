Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260133C4178
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 09:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781514777; cv=none; b=QtkfY9nInJLqYLn9GjyJp57gzKhhrZ33ThaKiNCQSGeuQBEEaRdpIQZAGoPWo+ROb5326yztyXeH/qFh/cvDZjizlvTu2NynPb8krhagDI6NSE3kDyfAHUzXDbbF95ivJ4Dlbd7r0rZlfpwzGfyhddo+WlEOb6FdU7r06PIyOvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781514777; c=relaxed/simple;
	bh=BdCJi1Rg2mcMW+kq/5v3D330ZxIanUdz6zLDDIpa908=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VWILlhf0LvUpxO0KZmGoFf6wq/zWSLVX7yQsCkOWX8YcPOVlmInksdxPMnkfMSqTkpUWWk42MNStEOo9HknLNjrMejbmAwL9O2kcDsDpnSMc1QGeUJMH5EBA5O/BU1PE+HWJSmNxpP5HfHBWad64mFcVZOc6RRHh791Cceo1MyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YYdGFnq2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QxYFfgyf; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YYdGFnq2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QxYFfgyf"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65F6KAar3692507
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 09:12:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=PfJKg8Yakt8VpLjLlx9CcAmkKLgOzxTG617
	/8JeNaAk=; b=YYdGFnq26kH5QqyU8bjvqxWiQ+kGldvSHy9V8u+L3iGduUfgIeS
	oiCdcwF0BOTjTWZN2SHu2iThVTpeMVHFk6nnsqr2vWPETQEsE6V+3g7XWarBY86h
	n31Fl6TiQ4aRr2IQlXqPWqdbBFaMq9LFlKhZqsBqdOeNjbuiveGNydolP4KDy2QR
	XrOfGUd8esgJmES+sN3ab+qoCXpLl0TaVShhPYmVQp8F5uGfSWESSH76tu0THOxs
	wYYMfPv6bd62zcX1+4CYq49kYmU1GDKTtxspkFGtt1hDj3EWiM33QejDxTt4G6c4
	AX0ch0KFeFCxX/JNGw+jgiD+YBJswfCgyhA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eryk6ehha-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 09:12:52 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2bf32fb7cb2so23247385ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 02:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781514772; x=1782119572; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PfJKg8Yakt8VpLjLlx9CcAmkKLgOzxTG617/8JeNaAk=;
        b=QxYFfgyfA1p6vOfz4o8BNGS/ESqC33nstYQP4vEU7Gyk21/Dw/HuVnvpzpc4cRVnhK
         nBKES384le1uhw7cGnjIHeRd09yUlOh0AfbDxCjWmb2wpdb6R4nNd1bkevzUzkDIrNhV
         K9p16OiC6muIZei8Rmq3dRz0SJE3DPEu2wynuuvy7Jql+IAdsvtAwK1PvD0uLJiN1zZq
         fH0jqBB5UYo48tWRhsHNz+4XSkwczFF6o7etDLZCNRQpe0j/0MOax50BrHxLP4aXYPen
         wJQJZZMz+1XKILzTMXzW8dNJEipO3HmxYsjg2rlrzI4b2bbYg9iRgDnscJilNuOMeoi3
         RSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781514772; x=1782119572;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PfJKg8Yakt8VpLjLlx9CcAmkKLgOzxTG617/8JeNaAk=;
        b=f112Hoc2kO/9I4swwy0HM1Zq90UGDEO5P/hdu829RH1l3SHmcb4Mf+PRzF9r7AF7mY
         dgALzce6ay3k08L1fz9eL6dyuDnsfDbHAYM0OL1tc4DQM6L7f6QjII1O5SSKYFjtem9U
         saT90Ql9P+Qw/pD52FlSbnHcFwFgMS3KOrrVEQikvE/DDYfVT3l+S8nclQ92DhZciIUi
         LaKhpLIFUYTvUZrT3XhTIIRTSJHTdgWyXv+PWq4BQ3lTROhsz8sk+tRzZBpox5DRK9e4
         qwvTOnjGb/RB59qBy1yAZKIXWBholseQHluliuXfaBQJMmMUuhEJwkNl9MjOKMaABDeG
         i9HA==
X-Forwarded-Encrypted: i=1; AFNElJ8kVhaFaCeT6bi8lQ2zD1ZDYwrfze/jNXLJdDOdBQYp0a2i9k3YmP8S1+YU9rHFRt0d6kNDVG5rOiF1@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7b+dpLru9XJcLh8ajs1Ko0/blbKpwCegmam97z3ml/LHnJKjM
	6TA5DuzDwCtoACGjULNzxiLluPK7RGMLOUyFEVvElrLABk9uhyG8HEfRsjV8NEmToKu3xys2co1
	WWhpIdf1eHtvqWiGoJWJq4zTj++hdi2gL6B+XZvKyEy9rTMRr9Ey/+A762+VMvVlq
X-Gm-Gg: Acq92OGNCCku339A21as3GiTRrC3E1k+tYm78dFGAEq0vqrjAe7lH2BN7sjkb4hu7jt
	ZnZcOBEGT26Ym7LcXhMddJC+Ck/KCbnT1MBLoropg2zNMIpFMwpCoufnNyIGVcYtnzGnrIxI0sa
	kFFQJqNvYcpl28jUYOps23t0Mwjhh8JQ+B6LWe/JySO5Sn5GsgIj/LhNhWsqd/5Rs/XQ5CBag6E
	SV+5OToN3qQ72YP5nIz5Bjn8xJHbiP4FeNCfAlpG+/kzIr0Z4IGmXG2b2BCTzTYW18b0h+pN1n/
	azxjeW9G5M3uXecS6e34kZwvC5MBah82sOTVqJ10Xsqubx0UxlP6j71HQrth5/3eVPJJkTkeXXP
	7BUV0/i2KS4sLVuPNaFpzQAIFnZRLoh50xC7Aoy9GhqCD/u6xkvNU0A==
X-Received: by 2002:a17:902:e808:b0:2bf:281c:d2d3 with SMTP id d9443c01a7336-2c4104137c6mr147565265ad.9.1781514771576;
        Mon, 15 Jun 2026 02:12:51 -0700 (PDT)
X-Received: by 2002:a17:902:e808:b0:2bf:281c:d2d3 with SMTP id d9443c01a7336-2c4104137c6mr147564875ad.9.1781514771145;
        Mon, 15 Jun 2026 02:12:51 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c433079999sm91669065ad.66.2026.06.15.02.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 02:12:50 -0700 (PDT)
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
Subject: [PATCH v4 0/2] Add Hawi UFS PHY and Controller support
Date: Mon, 15 Jun 2026 14:42:40 +0530
Message-Id: <20260615091242.1617492-1-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDA5NiBTYWx0ZWRfX5jMw6zpE6vYB
 iCqUzXfr3MLXfYMhEwiWs95uuUKA6976fG8Z2WYxeee2s56aUvyOVaCDZijwdrjhYbq6yLyeqyl
 MLsAQ9Eu++7KQOIKTN8yzV0otZe6OMI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDA5NiBTYWx0ZWRfX8n1UoInc1UdH
 cLoXi63+VgloWgu+5HVLK9SlhUPGLrgG8rJLeWlmEZjciugtgFjbiAfupnhy6KFn8qrSA6xY1O5
 2fJq3Lx7Pn0UjmABPkyAxg/QLwNlBoLlhV4FivjUPMyeySZNbWsPGXoGxVCi5mRnqpE2Cxj4VOH
 Pv+XsKNcYQqyOG0FqcOeThLsPMsBUiPLV0PVUAEuVKRlxFI3uxk7wJVoo2mdHi80kRSmRWrIcay
 UtbY3hQge3Dd/RrCfKflQuCVdYrsKiPnl5/k3SIX7zXkum5pGJFs6id/KQmmgRMbSBzrSBw86ba
 1UU0+EGtHYimp+Z1ijn9CzbtG3JUNkqhKiGpcgHF2TYF1BSHQP+erKn3YDp5gZTJWWLu3Y4XsRE
 ZJ5q5XeQVA5wmfIAn1cwbigKnC6blxxq3Qv/ylOBF8F3E+z1idQSjJR/YsyjRdqdD8aWckF48N3
 aFCNeX64ktLDLY3CFIg==
X-Authority-Analysis: v=2.4 cv=NrThtcdJ c=1 sm=1 tr=0 ts=6a2fc214 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=wRtOOnJjwWicnHpPwtUA:9 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: z09M_F7mRPo_RghFJa0JiiZML8G-zw35
X-Proofpoint-ORIG-GUID: z09M_F7mRPo_RghFJa0JiiZML8G-zw35
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_02,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150096

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

