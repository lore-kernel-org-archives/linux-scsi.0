Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228B2355F44
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 06:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773209363; cv=none; b=DBLJear83+6wdTzXxH7S54JP+/OqrIO5PxFfOiQFklLouid/bdlAjItx4nmYW2cE+Qvy+I9BZZLQePR+ReIqQoFw9oPJtLjDECTYMZTcqub/C6c19oe68sSAjdB6o6tbqMi4JkkjkzZcMp6K60VF9bNrhwbyAbVYoqSUsMSqmvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773209363; c=relaxed/simple;
	bh=WHXHafAynHKkHVvFrmMCyz5FDvbxOVRJIvIcU5nzCzQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OQXBY1LWfg5JojJAhr0QffwBOqN0smklD4fhx0rMuvL5eHqDuv5Ssl6JLv+/4DH6LJS9ad9G71H9PknVKO5NklnKWxDpuaR2Vzz2DaS7xNNnFFZOqiN83g7v7x8uW+hkPuIEDZFYq3gyd3k7J+BRPIIdpELYHiWkoXUW7sboHZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bBb/9NZM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=d+GiDj8F; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bBb/9NZM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="d+GiDj8F"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62B3FM6K248220
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 06:09:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=/iY6DYMUe5OQ8UYnYJIGI8IsR1zVKVNzhI6
	znnStA9o=; b=bBb/9NZMr7b/hblHfreL0grBCwZILRn0RHnoxRz9qhIIWYuZ3mp
	ka72NxpOi5X6HAQi/j9R3wN4mmFYOMhEACYXv4TXGkG57Gfb8hmWDJSNOcHdfCsU
	WTUHZ/2DMbSFS9QyyyJpJqhBSKBNLUr/GIVeXscw6fL2k8Fp9qZV5bA0TOyl542g
	bHUFviJx+02WrybY4ZYpK2NsJvU4JepyRniEdcdh+uIPXdX2FKB9DsoZMkRQjORZ
	mUTPywQLaP3pBltEYEtEM6Wv9FbsJx4i4ffaf3+ZGbMeUqSfrnmzdu/1XnmiYcaD
	6l2/p4cLWCy1M7wNTybwQfDzS5qStZFK1BQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctqv1247p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 06:09:21 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2aad5fec175so508633045ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 23:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773209360; x=1773814160; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/iY6DYMUe5OQ8UYnYJIGI8IsR1zVKVNzhI6znnStA9o=;
        b=d+GiDj8F4keAl9a63p6BXvL/J0ARyrutgUNQq84+bpH/hcclWvVhMG3RIfxE1QtCi9
         V9p9B+U7wzEu91qaObq9NV7YGtCDoFsuoz+EgqFq14HlyW8X+e4I14Q3Fl/XRCiQkVE4
         ITlnMtej2gO12DixMQJp5npJ0CQihfqJUGSk196vuVw+t7GKeelVaOZ0v2KevtAMsZjN
         MSSlVYnoaL2s0IYlClzfKHzrawF41STev+7PACunrLtgCjwMu2YR89QjmHMOYakRfRvb
         VObsIDsuEHjuZbEHV7U/00geT0xA+VjyeDjJhIfDIwHsByJXnol2IHNB85eH+P6O5629
         RG2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773209360; x=1773814160;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/iY6DYMUe5OQ8UYnYJIGI8IsR1zVKVNzhI6znnStA9o=;
        b=YFWip/uDSunp1rhITsKA6givg2RiW1yfPvpMNwAGztw5RpRzBO/W4wWWfxWUe09fQS
         jrEvYpwIvdMrW5pIQKTy1m8oVUhgjqyZv+fB5M5OUqYTbN6kGZlFRsjRAUbGvZhmigCo
         4+K9Z2zZ+K05CouEKWvRPihxu+sAQgMprI7jjYRkokcrdPOdhLGyq0dPniQSwSC1/n5s
         s2AfFrArCyJHEGZC1p7ge56TJKqKfYSgr6H5yJJjKjyVEXcg4OzTdXpPekqDcbKPxUUc
         +nCjj51V9HkievUxrcJfXQQBDuNrOVJZfZi+Cp46KvcIV5UmSJi2OzLtyXwRgedIsgvJ
         JDHA==
X-Forwarded-Encrypted: i=1; AJvYcCVmQm4QP8I841anA+cvAoGKqOy9fACxZrwv2A/yAyrfid2dVPnGp7i6ViDTrnuk7TvbEVTcAUFFkIZc@vger.kernel.org
X-Gm-Message-State: AOJu0Yxorp1C3KCZjavzI79egalyXxLurUzrTwVmD6GNTTUME4isWCmP
	th2x5butCiaEYIEgPAp7QdIMn9DUN0LGFtcIXCrgGtOs8M3ciaXdb2UOLDvO7m+dUNYf3dlYROE
	t3qaB7ussE08KlHR7ZhgZVuCnQpppm0GWYxMlx2umJW1sK2mU8233DpAPA9eyP+cp
X-Gm-Gg: ATEYQzzJLuiPNLjpY4PBgZosdIhWTUys2Hv2cM4J10mTLQQJhiMW9fONnvIs/W/wJA1
	Mm9Xno/QBG+MU0dQ1yrukczomPexXaSbHGrL8hXUhXIncfAplnwcfcMdDeqV1af2Sfhz2j9Z/+Y
	mkWjVw7p+YBqHUSkkNmH1aqFD4hiOQZK26E1FmtW3GVMC7EJ20xVedRQ1qKtaoKJmuyxCnn0wdI
	oHUbxh/WHhBGeTNbV3fp9rL7YupAoLqHnauUy7mTgDnuxoruc1a9p8pQuioW0TX3bsB88CHP20A
	cy4UxjEP/GMwxgGxTbTa7b+93/2549WLQ2CnIL5KYsFjo7G2Rcc+vgMztPLZv/KyKoovGckXEw0
	El9moyfFF8sFuK7JOuPG2G0+QWQLSxXkH/S7QgoOsFJY3C302drwFSg==
X-Received: by 2002:a17:903:189:b0:2ae:5223:59ac with SMTP id d9443c01a7336-2aeae7953dfmr15618565ad.13.1773209360186;
        Tue, 10 Mar 2026 23:09:20 -0700 (PDT)
X-Received: by 2002:a17:903:189:b0:2ae:5223:59ac with SMTP id d9443c01a7336-2aeae7953dfmr15618375ad.13.1773209359775;
        Tue, 10 Mar 2026 23:09:19 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae246fe5sm12433265ad.28.2026.03.10.23.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 23:09:19 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH v1 0/2] Add post change sequence for link start notify
Date: Wed, 11 Mar 2026 11:39:10 +0530
Message-Id: <20260311060912.3139257-1-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDA1MCBTYWx0ZWRfX+2JMewvhrDj2
 hj0or8WL6lzYkpdCdEBVp7lYn2ro0SPaSjjLs2K0TYi/zE1xn7tnsOK/a0kdvS4DlSdAKLSaXLg
 dGU1zJNUcbskMRwGts8M4Z0Wf4meSW7Jx80dS8rysMHeFZVa2rfzizcTITDRIc13wI7lO7sBXfc
 DcIGiRZG5VZkSZuZyaxQwPt9tVWJdL65/1c9fYF+QRxlY6+fCRn/8zEnE0IUUDPncgVRFTQOmPt
 sSdVOIPy+2uA7W/pCGAiLNIHIM3UV9zdzYgwjs6drGxSPjRRZ6iA6W1Ggv41vCqEwVZYIUknpqU
 Yg6W7Mq33YgSTYKwFhaDJMzjqRuzKi6p9Nouze9Injt/l58bwsyO5EEyZIY0Izt+S4d5tOByoDs
 8YkLrN659qI9jKQFSwKb7f/L1NBFAzOHPowW5s31c2uHLu92EH4JTcy4u8LOH3+gh67ZaBdRZE1
 Edl/b/HYUv7/hOjzQRg==
X-Proofpoint-GUID: FTRqcNqbNxh6Lr1s9iR2Fz5e9owupoo1
X-Authority-Analysis: v=2.4 cv=S5vUAYsP c=1 sm=1 tr=0 ts=69b10711 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=rbNoiXgGD7Sd92Kb1yEA:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: FTRqcNqbNxh6Lr1s9iR2Fz5e9owupoo1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1011 suspectscore=0
 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603110050

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

This patch series introduces two updates to the UFS subsystem aimed at
improving link stability and power efficiency on platforms using the
Qualcomm UFS host controller.

During link startup, the number of active TX/RX lanes discovered may be
fewer than the lanes specified in the device tree. The current UFS core
driver configures all DT-defined lanes unconditionally, which can lead to
mismatches during power mode changes. Patch 1/2 ensures to warn on this.

Additionally, certain Qualcomm platforms support Auto Hibern8 (AH8), where
the UFS controller autonomously de-asserts clk_req signals to the GCC
during Hibern8 state. Enabling this mechanism allows the clock controller
to gate unused clocks, providing meaningful power savings. Patch 2/2 adds
support for enabling this feature as recommended by the Hardware
Programming Guidelines.

Palash Kambar (2):
  ufs: core: Configure only active lanes during link
  ufs: ufs-qcom: Enable Auto Hibern8 clock request support

 drivers/ufs/core/ufshcd.c   | 39 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c | 11 +++++++++++
 drivers/ufs/host/ufs-qcom.h | 11 +++++++++++
 3 files changed, 61 insertions(+)

-- 
2.34.1

