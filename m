Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377F73A9612
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 05:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785215477; cv=none; b=Yo9EpxWC9shr/Rhgj/RizmJSNf1y2YR7+nhpYyAMWR41m0jO2dc7NaCl88OkUYAeMiowu8HLhKTRv8m2hqVyBGp0TDvVw8Rq+Y1mL9y/8jZOnR12KeLx57DwJdeifsO4rX4191IuX+Ux6JDjKP3JWLMTnhTZNd+6mU7xnY7Exwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785215477; c=relaxed/simple;
	bh=q+UK1XhtSfIhjthr20rgfkj+oUHnC6ToCT9BL2OiKjA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DsmfuZv85u4muBaCzivev3+NGBLhBvMDTKNKAvRBEdzzGHot3k/3UydPcjRp6gWmSFjG5U2InvQP4susz8iXHbIkt8J9nM2CaFND1svGQH2uerfxCt9KwYUIjCPqeRgpU025SsqmXCEgg3VXKHocNLd1tZGqOtjqf/w1Uo1OjNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=e1ftWEmX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Stm1J1mi; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="e1ftWEmX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Stm1J1mi"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66S3bB691063010
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 05:11:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=xPwsVOCTiK9RFodipmOUjkKrchhpTiUvCqn
	0W9TM1Ow=; b=e1ftWEmXO2NuLjqe8ijf4CaiYNBAo2aPpqtTohMfL30tz2dWrdn
	zvrYEjK8YcWsLvlwGw9p/SqQB5MtGkYno02y39dPYK9Sl72WmfdvESSsQ8DAFtMC
	rsTU9ksQFZaOcFpFoOBrTZhJASYeBshGk5AnjafjdCZwQ0cbXxJInRFubM/X78Qg
	wY7QubVXnC1+TvGbwC8k6wIqH7bEuVwD8RLMHXBpbYf8Y3zBCGPEKINDBQqngbvP
	0Ml36Nw9o17Z8vLB7wkO9L4EPUMJiTFJl8bHd16tZTThZOFS4l0twBqXJ1Osxy+U
	LbMoqXlh25ipUOv/ltOwytaETuxZNlL6tAA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fp4v6ckps-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 05:11:15 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cfe48ca1efso34428435ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 22:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785215474; x=1785820274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xPwsVOCTiK9RFodipmOUjkKrchhpTiUvCqn0W9TM1Ow=;
        b=Stm1J1miTnLPE5hD83Jk2QGb248sanBF3RF0YpZNXZKiotdubkDtuOn17/XaPLeLuj
         pQMc8a/OBMCvE5oVJERqBNn2//3v7mdQ2sgNcJJ0Rf9us+/d/IyoMFMn12wTdEyv6pvq
         z6usuYGyHAfLeViZ+2LnlYRYIadY7bUQZ2Pd61f0q2eOYG0Nc8GrhbEkFYPZDwJ+wMp+
         osRuCXbmf76rqQVIk+9r8PDqEBGXubXuSfx1ihTcLH9gPbMWYAEF5ZvMiwGIRLa+Rskd
         5BjeJsYcaH20Xpg32v7pAcOGhsXpfMec5xAiLebuiomIX9CAhJJrrC9RJ3Xt22+Xo6PD
         jcew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785215474; x=1785820274;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xPwsVOCTiK9RFodipmOUjkKrchhpTiUvCqn0W9TM1Ow=;
        b=k8EatxhYnHBemxO49yDM4VsGjPPYNPAgNDmkMLO12f6blOlOdnbdrVAzi1838SdD6g
         gcZTtbigdzxY2xTCJTDVbzao6dNgfaQ41oKB8i+ulF9ZjzofTVjP7mRcdddkvNU8z1g/
         V29Jg9wpXR2LAPL9LAzH67EHa0xjDWWYXn74kzrIvPnLl69ex+mcZEezfj/fC1IrIBYk
         Ai2NorqW4Osh5qeEOTc+BGO+K0ygxRIDAv86d3o92jADWovdDSJ6uE4hmVn8bxri+wmC
         SmoHbpAp/JWgU8rxv3dg32ZHSmAROhrvSpDkj+JgNsIT41AtsSl1y2n7pt8Xo9tV2tF6
         BThQ==
X-Forwarded-Encrypted: i=1; AHgh+RpMKUMJD/IlRduT0jiPPFVPw3wKQJwypwIG0x2ZEL5mr+La3w4QoEXUg8GB3iLWO5ZbVxqp4ZcjvEXZ@vger.kernel.org
X-Gm-Message-State: AOJu0YwblBQf0/ua4iutL9YoxZS4fczl1viPHNuHi37Y2MUUDTrrWWHm
	ZOLcSD+tKWxr9AOdrRTD8shGAtkDAcA5zz7YBcigmXNYRTD0cSUnpDY3Z8EYUbIqmGd7H/KcgAw
	O+UEhJ1h3KPk3yt40/3dinWET0Kd3Q7POtNx0bJjy4tRDPwrsbd2fwY7OcIWrpi2V
X-Gm-Gg: AR+sD12ZnbEhxFL5kdx/ZL/6XUibFFrcLEONgnEDBQSlnts7qhtaE/r2tFSFF2M3Za3
	glgcxHhNiMLj8jUpZcqZ77HGg7gEz+2wU9vpt0xgu34rz70nXp4vs2c/Lr/IcdoPPBdV0KVMD8k
	/Po+L02Ymn/HoUygBe9X8WVEfIrXE8U0o7rjHhlRlyQwf8d94PpDM681y/h9XI5t2JJBHq4XHuB
	mBWPe83Ki4zbE96tG6zUr5IlyznsEH+6kol8vH9pbXL/TV5g7UXdnIMIrk0cmpThSmbX5W6ihqs
	1bd3fExeAduXo/Jv9oh343po2xGTV9fRCG9PJHsEgdu9RhWE77i9Wyu6IWW6R23F+zmrqnxG/pI
	vZCpCyKZMmWvNTVyCSAE0PDAPGcCR2uA3eFeK3ri6QuG0HivMZegjlhkte6Tb
X-Received: by 2002:a17:902:fda5:b0:2ca:20b1:3e0a with SMTP id d9443c01a7336-2d015c8fbcemr11760905ad.3.1785215474376;
        Mon, 27 Jul 2026 22:11:14 -0700 (PDT)
X-Received: by 2002:a17:902:fda5:b0:2ca:20b1:3e0a with SMTP id d9443c01a7336-2d015c8fbcemr11760495ad.3.1785215473976;
        Mon, 27 Jul 2026 22:11:13 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde5e26e9sm46069695ad.23.2026.07.27.22.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 22:11:13 -0700 (PDT)
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shawn Guo <shengchao.guo@oss.qualcomm.com>
Subject: [PATCH] ufs: host: qcom: Enable MCQ support for sa8255p
Date: Tue, 28 Jul 2026 13:11:04 +0800
Message-ID: <20260728051104.675088-1-shengchao.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDA0NCBTYWx0ZWRfX6Q/5fYJR43/B
 6vq1db3evjLdTfWjPyUvB8MsvdfuX5XUXRcqHff4gKpMebpEGRps58sltow8UaULaL0VbBKI0N+
 l4rzTnwKa7UPJZH6cPfq0DTX9LTRcdY=
X-Proofpoint-GUID: tWMoODSVE81xQ5fSeM4NwBHUSHVh3kOZ
X-Authority-Analysis: v=2.4 cv=ev3vCIpX c=1 sm=1 tr=0 ts=6a6839f3 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=E97KwoIb8eNdQlaa2bkA:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: tWMoODSVE81xQ5fSeM4NwBHUSHVh3kOZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDA0NCBTYWx0ZWRfXwjNxWyPegRnX
 YC8sD841+5yQA8zIwp0MuQqyPfrh8RjHgPooCdIK0qN/34PKLnXLCYr4cXB7B9a+dXRRwBB0B+j
 6N+FSuoCse6IyJHIbZ4muh4N5deyTuiWtFG+RFvBQA1rtld2HpBBDasdHMwJOgdfNakI7qqWuP0
 emOnMHktyTQ22yU+aDOz1ESZGZtzS8uvKQ1WdirWijhTyNTHR9K3ECF/MLDSCMOCJ6AwuFci6y3
 V6YL6w1Iq87/ezx2WjWdYsCU6vrmfDrtD9szKA5Z/SnW384cBtMqMN+T/dsRRm15aEg1D2/zzAE
 0sIEOqqyBVFRBF4FGMjmESFyTnC4+xz5w/kMxRcThr2Ysw6jEHJnQB3JCvAGwRrA9L9D3CoxZoN
 ozcPsT/NkzrfCmizwztsKhpSCVkdAXKwWZzmbIg5zUirF4rlQttsQ2PH3Pwwqw9+5vjS8byCpHG
 lDTf4FoJdVvs+rp3w7Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_01,2026-07-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 impostorscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607280044

The sa8255p vops (fw-managed variant) was missing the MCQ hooks, causing
the driver to silently fall back to SDB mode even when MCQ resource is
available. Wire up the same MCQ ops used by the standard qcom vops,
so that MCQ mode works on sa8255p.

Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 0500320545c4..d2acbbe647cb 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -2950,6 +2950,11 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_sa8255p_vops = {
 	.resume                 = ufs_qcom_fw_managed_resume,
 	.dbg_register_dump      = ufs_qcom_dump_dbg_regs,
 	.device_reset           = ufs_qcom_fw_managed_device_reset,
+	.mcq_config_resource	= ufs_qcom_mcq_config_resource,
+	.get_hba_mac		= ufs_qcom_get_hba_mac,
+	.op_runtime_config	= ufs_qcom_op_runtime_config,
+	.get_outstanding_cqs	= ufs_qcom_get_outstanding_cqs,
+	.config_esi		= ufs_qcom_config_esi,
 };
 
 /**
-- 
2.43.0

