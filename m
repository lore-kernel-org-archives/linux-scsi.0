Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C533919D8BC
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 06:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766988434; cv=none; b=AtSVBLM7jDv9TbcA1ba5GhsEeyoGTKUjs0lLAn3B2OhmgchdkIZwN4dmoEfYL8ZmsI0JRC5nF7VehJGkW2S+zWMRF1or5fpLpYGs2f2LZANbSFKvEBUzcULBZzjVjwpxp7/Zmm1O2VBEcZJsgnek3BIO54U/6lZitYZJnRfD4jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766988434; c=relaxed/simple;
	bh=TX/gNHgRQ7J1bS3tbk1Dh+FkfVaSgF4IVbbXpym+A6A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pTeSl8A4scWvULaRu+8VeEKkSJxKzAuzob9/beiSGUTZ+kzRC6ibCEPWr6UktRD4XYMLfJF1QvUUwjcndnPZ7czrX4gn8CPXp844vK/669YUEtM5iOuH7w0GziMRqldwI96mq1G56nfKol9ez5hD4CK8dqvNWBMNsDuD4YV5P9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jUYBntF8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HmxTO7B6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jUYBntF8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HmxTO7B6"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BSMuhU5052941
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 06:07:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=sveg7Kz1nFapUpPK2hM14UlNm9fSEY/iz4N
	I+FoNRCE=; b=jUYBntF8aOw4klv08qQXkvDKALehx5oKSZ6ucnSqZZgRfBVST62
	akQKLhygbqFWG0SlYffuQWo/hWg1YilYCzzByMfuzipqyxuoSxvfq3MiGSVclnLL
	rmKdNr6nW2ZSJzD4Y2iUuUfWX4+Jn/B6wXhaOpmNU/c4260WfA+LdEh04v1+borH
	nnJPC1Hx8hA/nhQRk8NcUbch9VQHgoR5gZZBVr3g+znilFigTHjSzepMHsW1qCKy
	prFVC9GIa+SjFglDUVotlM9iEJMUyhMkcMRbD+ZOHnxgeQhasY9W8ajN7Rja8rFT
	7nJPMf9mTA1aeczx8DTvU0vvsS3MCHYwgQA==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ba71wugf6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 06:07:11 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7a99a5f77e0so14908113b3a.2
        for <linux-scsi@vger.kernel.org>; Sun, 28 Dec 2025 22:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1766988430; x=1767593230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sveg7Kz1nFapUpPK2hM14UlNm9fSEY/iz4NI+FoNRCE=;
        b=HmxTO7B6TY3NdBh5yHTVbjz9+a2Q9e4FtXSW49GbNAmNhEBNI8mLk6eZUHJH6YfL/F
         VwBKEkoLaXWFEBAQciTp0PiSKV995xohU6t8sLHB6wU054jNS5ssK8oUKCtHsPs0Pzir
         m++yJ35EolpnhWQEq2GmJ7+ElsQ4VVCsxmQZAB2JDE+ZU99bnauDK8BtWAG2oqzPflCP
         qn74prGFk7FutaTWevnPkf5MCp5c/KTpwjWBcn2o0d8FEmVvX5WgUanoLnGpVx36QM3r
         HJC/zwxDXE3McyO1M8ut2u3t9JERRnthsnOXCaSqFylzbAt9FR7tjFZNPEwZvIcde/Jb
         rvlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766988430; x=1767593230;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sveg7Kz1nFapUpPK2hM14UlNm9fSEY/iz4NI+FoNRCE=;
        b=nmUMxB00c0xU/O5zYjM0gSrFivK/PJmuq4UE7yFgzW1W0VUzWE+H2qJopopPYPoK1A
         xhzvnZOpUzR88noxpGRCM9SY+U7AM3M7odqXuoYcF1Sq6anj5Yo1LiY34KLNOvGqfGv/
         vdl7vbw2AvNfTznA9nErKXzwdJK6OcyI6sImOoqr6djkbd7UQBhxSkXWCjmW22JnKqeT
         akCTVzAt6a2iJB9VcBOUpwtzQ5vwRLE3k2+lJ2tQlQ6f0IpDlt9+qFw+60qGDl/yzfuS
         uf84u2DQTSfQlLjMC1UuI3t2jGzoTlbCoWxiSe8W829sY+LQz6F7Jx41/DNPQMUBcpEX
         zkJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTxdkU+d6hcagUz7o/Z8vHV+nHbS8P6Oh6ji6ec+pDOVuDmyaLSKHuxzMCp6uP5YaduC5d/wAJw1mK@vger.kernel.org
X-Gm-Message-State: AOJu0YwL4J4W25CaR5PYLTkVQhc3n5htGXQs4Ftuqltrc1nv6iRef88N
	Yv4XbGxXhsq2YaYZgK+oNoFs3wvV8DSVrAk0G5wga+SGO0O3kvcTHYuOHrwo7JfIpQHSkhMXSbQ
	EwK7WSxhWzcwffGh3moceLOdgm+Dqj9r2fNyRH7eOGDX3ONT7Kz8Kc8reGsqLKaeG
X-Gm-Gg: AY/fxX4al+eB2Dk6oPVTvU4ntGkcC8bcAS0X0HJ0ZVEM3wkDmSs9Jzll84jKPwWUTYb
	xr4lYOtXzAyNOsBJzPj/zQqmxz/dX6PybsIhI5d0wmQj8tfaLBBgZdIbXGyVmVvvqMKCHIC/CC5
	pNLMbKVfw71W5CV3vdZKsgw+Hh4v6NNfuQRpjdG9uj1zMHyEs8vrod2gyPEWc7YqCFHB1l0EwqC
	V4uNrhOLiuBfKZA0DJdkbgNdpH7OURI9fhFKhi1eV2D6mHp8hGgyp6N9jozydk2aZ6/Av67XtDp
	7mJUKp3FKI3eAyw4JFXtTLMtucfYEte+GOeTRrYm/zZs7Y+nMiigQ0/RQ9jrfNekR2Oj8h+wSES
	/NWrsQNqINrPl9w9aFciPR3XR4RF/PeUBtLOjEr7xgPWcBLsAOfpu
X-Received: by 2002:a05:6a00:4f8b:b0:7ff:c51d:7e0 with SMTP id d2e1a72fcca58-7ffc51d0917mr28101047b3a.3.1766988430503;
        Sun, 28 Dec 2025 22:07:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFiR6c1hYnyTq/21Gn61ST9siCjyEGbeaNeJXv4ebdm6O1biqX/yA30qxEpWML0XJqb02hwGg==
X-Received: by 2002:a05:6a00:4f8b:b0:7ff:c51d:7e0 with SMTP id d2e1a72fcca58-7ffc51d0917mr28101026b3a.3.1766988430008;
        Sun, 28 Dec 2025 22:07:10 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e8947a1sm27917763b3a.67.2025.12.28.22.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Dec 2025 22:07:06 -0800 (PST)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Subject: [PATCH V1 0/4] Add UFS support for Hamoa SoC
Date: Mon, 29 Dec 2025 11:36:38 +0530
Message-Id: <20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI5MDA1NCBTYWx0ZWRfXy6XZvT6jM4C5
 iBIHk5N6JChiYjX1wqcjnosB0fEqVwuB2jEiggAjQKV7vE6pRDTPcfG0rU//T237xhhFpd8qfT2
 6GLyoXMVayIx4DIwrxp2Ai8bCiR+/M3wVwI1LEexgIWacqwGQwyXj8/V1Zn7/t/Yrk+FtTBExPj
 iZW8wPBh49ld+h8g6lmmxTwjG+Dlo1kPQzWr5Y1flDgFxlxpE4/d9k3rLnu5hLJe5aUEHXILspS
 dKrZaQf8W+/5+x+klg0kAXxnSmYrXFzJKviZJf0HqMLpK6A42UNwb0tV+PlB90/n/kDDdj8Cac3
 aaGS08juvOUVRfVYChlkmKkbORLxxW4LnO4YzcW58zUQwwRSH/4sO5MJ9TLYrZGfGVAsIFxC1Zz
 qD9+O7S/JgLJT3VCewNxbn7ZBvXzGhHWofMGSkI/S7tV+icumEp/IR2u3D4yb4UlbF5KQ0mjaKj
 3Fx9fwQdP/RkefPG71w==
X-Proofpoint-ORIG-GUID: TtSug6OPcnUY7hgsoAeTOY3ZskCPpNW2
X-Proofpoint-GUID: TtSug6OPcnUY7hgsoAeTOY3ZskCPpNW2
X-Authority-Analysis: v=2.4 cv=CK4nnBrD c=1 sm=1 tr=0 ts=69521a8f cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=MLyGsh9vszGhAdf804IA:9 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_01,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1011 spamscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512290054

Add UFSPHY, UFSHC compatible binding names and UFS devicetree
enablement changes for Qualcomm Hamoa SoC.

Pradeep P V K (4):
  scsi: ufs: phy: dt-bindings: Add QMP UFS PHY compatible for Hamoa
  scsi: ufs: qcom: dt-bindings: Add UFSHC compatible for Hamoa
  arm64: dts: qcom: hamoa: Add UFS nodes for hamoa SoC
  arm64: dts: qcom: hamoa-iot-evk: Enable UFS

 .../phy/qcom,sc8280xp-qmp-ufs-phy.yaml        |   4 +
 .../bindings/ufs/qcom,sc7180-ufshc.yaml       |   6 +-
 arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts    |  18 +++
 arch/arm64/boot/dts/qcom/hamoa.dtsi           | 119 +++++++++++++++++-
 4 files changed, 145 insertions(+), 2 deletions(-)

-- 
2.34.1

