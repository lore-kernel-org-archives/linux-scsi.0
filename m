Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFC0332919
	for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2026 12:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774440095; cv=none; b=XO1H1xkYMhwKLFnZEjH9Ey+fLxkR1L47qgNPS10WO28K83T2IEwzEthGxf7E11vJsna/UtyFBMGlkp6EVatCpecM/YpbMrscYxRhd8655os3WG0iVRq4LPbs8dedFBv/rAhdAZcwi+8XLnmo4egdG1fgPtd/OAnIw/IcwGAUeBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774440095; c=relaxed/simple;
	bh=elqbJzwTK4RlLEHDihKz5qYzGOzjo0++lq6c4OD1zzc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pcHwntI18uLdU6fggcWyHob2P4Hwa4iECi9nincLgSWuKd8cVf3KfcH9e5jPKn1t8JYw9mk9o/s81vvH3VRksB0opZ2/btbuQhMGuzZciTlKHg+TosrewdHujLrFzXqNERNgdr6zHB4whUHg8v+Z3XWJMEUFLqfjqqxfT0UDBQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pR/XFy1P; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TOLIuR2D; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pR/XFy1P";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TOLIuR2D"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PBGH9D241598
	for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2026 12:01:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=XVtvdIOXt7W+zMTk6G1imc9LagVh7jOlQc/
	1CUj/6Tw=; b=pR/XFy1PUR3NSsHPV2R6G6z9TcHFMbf1p/rD7Gh1+tKQuIG26HH
	Cd2b2OrNej6+wCfETd/FNRbGGxbNryrFEuUhlJ8hO8ZJBI3jfcyd8qWeJTjTEuGb
	OZYrpbZ8+0wrVqtSFKRI+MJEViONCqeFhYJC/9DXzJulSk56OLTzUWpdQcuJ6AaD
	HN1FslClRzAxp8rzHsGm5WOwRRKlHBUJQOeX/OhHCYk+B9W5Vil9SQqMLjI0R1gQ
	xEyfIBOuSzOUWKsLip0M1Oi3sqCv+jYWHZZalVKVOBInL2ipLOLx//4OptYXuHKc
	ZPBf8Tg14VKPVUcflXjf522MUB3p58www7w==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d4cvp0kmw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2026 12:01:33 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35678f99c6eso4679544a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2026 05:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774440093; x=1775044893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XVtvdIOXt7W+zMTk6G1imc9LagVh7jOlQc/1CUj/6Tw=;
        b=TOLIuR2Dx0bibOQEK0NyLfUtAbO/6h7VPg6zdnL7n8gIW3itauXn/CRXZUh0nN5MQI
         F7watbDQaRzhZ8+7/DmX7pTfvVGoMHF16w4CL93vo6x/6Fbnd04cYgkb6ZBBDqPyJq6E
         XWSMS4QHENh0tVptDiuGl4862r44O5PiDYSHk0ykWjAlABQLRIDxyoSIJ02+YU5Rog+F
         P2QpkvzGn1EDHoiGeTZV66moEZn5pi5wbKWmFYBvF4Esn4coWlXlN+pXF0wHb5zY+2oK
         xSKB0QPWU4e2MTsn2K3ziSnKyqMf3xOOgLkhvugycBgUdWXcp3LQ7abhj640pqPqmGvi
         bKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774440093; x=1775044893;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XVtvdIOXt7W+zMTk6G1imc9LagVh7jOlQc/1CUj/6Tw=;
        b=X4d8bZxEWw5ZmbovHfzlka7yZQVHz1mgamDOYWkpM5T3Uzd/qbIVIHD5ptRzrcnQq1
         ViQeJvG84LnddHt8Dtz90DHfuBc08TiYkuKJjwiarTLa1SF4iHSFJ5jM2hrqW/IC6fFS
         y+DVc9W5/0oHCHRlk+q5Ni1Xu8SDGIRdUeTbBKbymS6m0zTfoQCGekEVWEdSMCmLaRge
         jNdqcAFePtbfkot/6RlwvSHBckhTB4QoebGTs+CYgrHz32LLwpOPyJ+/6FowIPIcVB8p
         EuqLCkAbRXPfKSv/3GTm+81XKL58WnhFhTqDXVgcTTAMO5Hwn1ACG60KS/q7rtKes07D
         rZ+g==
X-Forwarded-Encrypted: i=1; AJvYcCVJTkUxzME4EUNwflrM5GdJPlaA859qq/B669GbGNt3AC5FM+gLR/maBi5AbVKl8+bLwiN7X+I74kIe@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3/iuP6Bd/Jgv2zraV5CFRKpZrxQey3+lmRFcSxeXknIBT25Ji
	9/oTyVbAASVJDQuvp+0JnJAsgvJ1LYM0zx8pCMbLSp92yxrDtaf3VKHHbZTm1Rp3zjvILlD4ehh
	H0etmAhZxAZtsCUcvM+T3rLN4vYlx3xAi1c7L5hUpKee4wJBM6rwdq19Kqjhrn7k6
X-Gm-Gg: ATEYQzwKzSX/TM4Fyh7OaNs+nMARJ5WjQ7Q2yXKAyMhg2ENBe+e0lrpQONroQJqX+KA
	Z7tGm8fZGvFxWwbpTnsVeqjsR/m/rPMx3+/Zfg5SOUpm79ILJ+u7DdDEOqD1Fbsx5RH4zmlHjA0
	cJ0KzwkmETBLnibS+DRKBKsDkeBivGzTv3C0SZ+KWpW19J+/CVLVADpxJXcMeHS7gwlkCCFLRVe
	0ReMGJqP3cOuYoivr4sEV8RAdVasIBDEjUH0QPlOTBSw8uENmfEclKPk8p9DHkkcCsDa9VHt4h9
	bXBmLY8oPKp1N7RfBauXnrPPyESTGD5TWtxkrMtufHrr83dHFsBdU+OSUYKaCmv1k3lLa9DgePS
	PuwCs5V4Aay//yV26Jk4lGVQoG/jxKy2FRrtj
X-Received: by 2002:a17:90b:2e4d:b0:35b:a760:1a54 with SMTP id 98e67ed59e1d1-35c0dd40e29mr2770804a91.18.1774440091849;
        Wed, 25 Mar 2026 05:01:31 -0700 (PDT)
X-Received: by 2002:a17:90b:2e4d:b0:35b:a760:1a54 with SMTP id 98e67ed59e1d1-35c0dd40e29mr2770739a91.18.1774440091099;
        Wed, 25 Mar 2026 05:01:31 -0700 (PDT)
Received: from work ([120.60.74.210])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c03172a8asm6556117a91.15.2026.03.25.05.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 05:01:30 -0700 (PDT)
From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, vladimir.oltean@nxp.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH] scsi: ufs: qcom: Drop the PHY power_count check
Date: Wed, 25 Mar 2026 17:31:22 +0530
Message-ID: <20260325120122.265973-1-manivannan.sadhasivam@oss.qualcomm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: pKPfTMSf13Ma4QQBONG-IW4LVVEeHE_K
X-Proofpoint-GUID: pKPfTMSf13Ma4QQBONG-IW4LVVEeHE_K
X-Authority-Analysis: v=2.4 cv=Q73fIo2a c=1 sm=1 tr=0 ts=69c3ce9d cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=DfnuZq+CPLWApegUcJV09w==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=xL-BF51SwBSFlk349IIA:9 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDA4NSBTYWx0ZWRfX1Q5Trrak6MwQ
 ZHIn4tQ6dGauBAgF0oe80v9MAPITMNk/A15B2TbqSB57MRFi+CNZejgiSR+1MDIXmLABtukR7el
 ReFQpvfl8S8HgHxbJnMWG+RFe18lA3kh3kZHrhvReQ8y7fMLWB8n+jFtO3oVp/6jGyoDtdsPAVj
 noSbli/0lw9CTRdk34v7OU3aPo9jGKtGbOZT9FvSI2mxmw/NDcR3cjeHaYA5qElwqdaVivmN+Ue
 k3CVLFR2so7HCRmWROBGCvTVQjddgAERp75qLngsCrQdsYh8FnxaIPNreAAvfC4PuKAqJVw6a90
 iFHLy82jR1J4HqcQwZY/YhWInhuCspTvbzGOGN9VM5L3rDjGgmDCJwJFX7I99NPI6yJHs+cyFJ6
 Pl243i5lK5BsIqQkZ8ow3XvYiMfCPqCouGQPiUh+u2NjUEqL3g8IwbR9kPzXgcsCGFCdMufo//D
 LBHpxPnb+g9uny2jYDA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_04,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 clxscore=1011 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603250085

phy_power_off() can safely be called even when PHY is not powered on. So
drop the PHY power_count check.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 375fd24ba458..4a410a0137bb 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -508,9 +508,7 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
 	if (ret)
 		return ret;
 
-	if (phy->power_count)
-		phy_power_off(phy);
-
+	phy_power_off(phy);
 
 	/* phy initialization - calibrate the phy */
 	ret = phy_init(phy);
-- 
2.51.0

