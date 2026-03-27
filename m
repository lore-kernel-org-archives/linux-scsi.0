Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E23371046
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 09:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774602239; cv=none; b=OP6VB/lg8pQs5CLXtyDGXGORqXcp4CLS4PgxDPbT1cReFVKbZaoBxNMgZzWggxztPMHSJt9lpgU57vyaUzWpV4bbtdgiBGUzGW1zwZaqPNLyarbVKukptk6ne2qSN3mXADZVuNkq1Am1UpVt45C5W91o1z0KkRoOxShYhZcuFKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774602239; c=relaxed/simple;
	bh=CFvW1iMS+3LZVjhX/2U0aGD9Za4P/zB7ODiMTRsW8fI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tPdc+Eu4cLzbTjtkAUdi4G1N1miEH1klks12nEjOvk6x0FeZFkuVZe53tp5SdFjH5vziLRHyXCfCt7mfnBzMH7gm51Vf/I7D6n1hR0N72b+iAZFVI7fz3Ebegf2mXZAhBShk1KxkYTdt7a3SwlJ+YQZ8ZddMZWtAqnvMwoA2qlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=p7fv3hmq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PCzGRrhx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="p7fv3hmq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PCzGRrhx"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62R6wEkT1710555
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 09:03:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=KOtKHyg2g3fjmBMNy3iI2b/T7G7uP9S3ww3
	w7qTvDbw=; b=p7fv3hmqMEyjoP6Y4G6YV60U/0VxQP8hJKPvyUWnHTOA/m8F93I
	SW8ePVRJ69ODcy6Kco9dsKAg9tgFV09hmXbKy1rZ9GzDDQygRo+YvoB6w5ranN6k
	kfZRxVxo2vp81tRLi0ItI2mDzA//1rxaZXyqHBONvjNBwu5cTGVFF8zfEAuOmtEM
	CLvYUbwhr4hZt1YA1HfgRN3z48xXavm5f1hwvgRiM4ERAfQExWjPkYBEXKwQFobH
	CsX0dUI7tubKOmSSqzH2DZULswyqiJLM8KxOl6Z9LO1SXdUL0h4zJlnGsQf7NH93
	HTYOWJdvrSuAhyfho1Tg/pt40lzTJzuIH4g==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d5bxvj98h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 09:03:56 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-35842aa350fso6321513a91.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 02:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774602236; x=1775207036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KOtKHyg2g3fjmBMNy3iI2b/T7G7uP9S3ww3w7qTvDbw=;
        b=PCzGRrhxXj895AwzI86t8QxKyvOzR8BsSJXyNKBQy5Ybrb+zGpgOz0sowGgeLNltrn
         Zfjiz2QrA6zNgVAzwvEoxFVANREtcAtY2ss6GDv8Y52QysH2TAViRYCAXETpNKIPwGlS
         sD8x2lsEo0+6cOjG+JhGWiEG9mG5PsOMmw7zBMlyGOGN9DRe7V58TdfS1ZzsdswVYOjk
         cYuQvTqPbL9gPd6hMRUySCCI+18W6eakRjA5nH0kauFSeSxfnC7cTooZqmPV9RPSihpR
         vOEXSSC7usWI9phdcmS/LdaflkaqM/7T9LQJuLsmz4sLca/MID/HdR6p/xBD/h3nqlOq
         5CaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774602236; x=1775207036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KOtKHyg2g3fjmBMNy3iI2b/T7G7uP9S3ww3w7qTvDbw=;
        b=ZWcpRjrEnH9uW4O+za5P4f5EzDyrJwVo9vzqzqRMYNcr+EllCTp3OZ+FuWQ9R0oM2k
         a+yjC6VbX6RprEeByQ0zUmsRz40LXnN1vivcYwExwoI9ANDopwjxR4Xwo7I4H/P3WsQk
         NKU2w9LIjmu9oePPoxZko8hz5Qhs3dUNFH3zb9l+PEn0g9llltXgR9/SNaCO0MEq9adm
         hqn8CyrcqcEdEtax/yZgxsdt+1JEUDE2sJ+o767ClQP/TTLwo2nuntvHvZPFly+fjCxq
         MvSbRRDR7HsyRrVMrnS/hs2IdsgsiAL6aEzkXPEZVkqbBHms6v2OTzPgsmyMDWT+C/7z
         A9PA==
X-Forwarded-Encrypted: i=1; AJvYcCXcb079+EXOPEmDPqn5OPi65qQqpSYFXfSKLlG9V4KGsGOUdPCDmMaWZbY6E0VUp6KSNxJfgYo2nd2z@vger.kernel.org
X-Gm-Message-State: AOJu0YxfFl2zP/hCKCiOs+H84WCWQg+l6YaQ0scIol91efP+Mh3kvkhV
	Qk2Eiz8RRjhPAuEHc/hkq1Vjy53vgq8VbloADtX+5CGv3XGkQVj+e82TKTBcvFGhtkD3ROPVulA
	WZ1JBvrPgQ1FeQensUBdZZaQme/Yme/7lt++YR7OZTFDOIEmNZpx8yJnHJ06frghX
X-Gm-Gg: ATEYQzxGkO+1XzimTWGA8J78A3l2sd6l94+0NQ3GxN8LfUU14ubeAYRfUecDgPg1SVe
	H/VKAInDOs5ZS2skqZP6xZF1U5T0f/9gFDMrNsWOIVIxb65EVVuSZP7cro/79COow/81ypSUwwX
	mb2hG4HJgo8WQs5h8m/gRbGeqf2SPEE1SuYI195ybzLPkYSbiFTi337rW7oKLZ3SB1o6wMIGx+s
	7cy/qa/uemhRZLHjauOG5eqb7C7YrNtVUV+mu3Mh8hwint1a1M+zC/LEuqL09+kleMUvRDa+iDF
	1PqVJ73wdwXIWwdJm8IA0JOAkPbYC55Irlvw9CgpcC17ZolLCJhYpD/tSIkyDSyM265fSTKfU6U
	AkdWoVgMiBmV9Q0fRdiVvQhkQcmEIjatsk4rlyHtVUgH/pSIW9WcICQ==
X-Received: by 2002:a17:90b:4acb:b0:35b:e5b4:b4c5 with SMTP id 98e67ed59e1d1-35c300f4ff7mr1677951a91.25.1774602235706;
        Fri, 27 Mar 2026 02:03:55 -0700 (PDT)
X-Received: by 2002:a17:90b:4acb:b0:35b:e5b4:b4c5 with SMTP id 98e67ed59e1d1-35c300f4ff7mr1677903a91.25.1774602235034;
        Fri, 27 Mar 2026 02:03:55 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c22a81744sm4230006a91.5.2026.03.27.02.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 02:03:54 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        shawn.lin@rock-chips.com, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V2 0/2] Add post change sequence for link start notify
Date: Fri, 27 Mar 2026 14:33:44 +0530
Message-Id: <20260327090346.656324-1-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: n8-KGLWh10DAwVG76NzjsbGfyEKqnNKA
X-Proofpoint-ORIG-GUID: n8-KGLWh10DAwVG76NzjsbGfyEKqnNKA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA2NiBTYWx0ZWRfX+ZB5WSVAe0yV
 lFADBHh89gsZWDVUkhWhqNmducelEGBR/1Er91eGsQR2KsHgLMWrhNKrMFlaeNUrzkEnz577aqk
 BlndBJwFty8qykPErtHPIorJK49YUcL0zHXxL5sDwHG2gO9yW3rMfV20r95PHB60h1/EVzhU/y6
 HjS20Y6TXccDr8qvxoP9aCBfigwPSCHnFIGD8OIbd/7+R3abo4pdDjpA1luI6v9hsMp3cXlcUmm
 IDwo5EVKcB/RZ4lmnvLo9aNZAnxWTmqoUFsfGD/4FBYdI1tvy1P7/6xt5dag/64AWRCafTTaJSs
 vY/hurAZdaqEvhIKX0SkdGAYZBIZ/kHftMGT6Z2/0LXIvp0NSudzooqDNZxQ7YAs72WonVfL1vJ
 sCu7C/i86O545ND0u3FUV14IoskNXJucgxH1hNgn7+zyxPMOPmqyNNl34YKBhV3wK+kALhXkmHJ
 Bf3N2STfgkHG8EMR5Zg==
X-Authority-Analysis: v=2.4 cv=ToXrRTXh c=1 sm=1 tr=0 ts=69c647fc cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=rbNoiXgGD7Sd92Kb1yEA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=0 suspectscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270066

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

This patch series introduces two updates to the UFS subsystem aimed at
improving link stability and power efficiency on platforms using the
Qualcomm UFS host controller.

During link startup, the number of connected TX/RX lanes discovered may be
fewer than the lanes specified in the device tree. The current UFS core
driver configures all DT-defined lanes unconditionally, which can lead to
mismatches during power mode changes. Patch 1/2 ensures to fail on this.

Additionally, certain Qualcomm platforms support Auto Hibern8 (AH8), where
the UFS controller autonomously de-asserts clk_req signals to the GCC
during Hibern8 state. Enabling this mechanism allows the clock controller
to gate unused clocks, providing meaningful power savings. Patch 2/2 adds
support for enabling this feature as recommended by the Hardware
Programming Guidelines.

---
changes from V1
1) Addressed Shawn Lin's comments to fix comment to connected lanes.
2) Addressed Bart's comments to remove warning and trigger failure 
   incase of lane mismatch.
---

Palash Kambar (2):
  ufs: core: Configure only active lanes during link
  ufs: ufs-qcom: Enable Auto Hibern8 clock request support

 drivers/ufs/core/ufshcd.c   | 39 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c | 11 +++++++++++
 drivers/ufs/host/ufs-qcom.h | 11 +++++++++++
 3 files changed, 61 insertions(+)

-- 
2.34.1

