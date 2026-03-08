Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A6A29B200;
	Sun,  8 Mar 2026 15:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772982928; cv=none; b=nFSxclYwmuRFHWImW7zsgTpTt2IOin8HW05IEXHfBUnI28iYxwS3/aefVWsh04Mr+m+RX6MwQ24k0qp+IeSlxfp4JjhjiwB1l8KgRuoOLObelR6G5WBwhHWGapZ8IJxm1M6zERV7ilHNZ7lr4Kb1CwRulPMnX5MyVGxI4gkk7nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772982928; c=relaxed/simple;
	bh=gFsbkwN5lzvo/hVbGl9fsFyNshlnCAp1uz345Ks1kv0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b2xVKdOoOSyRJU86dFUnlYf1c2xalexf8rG3VARzo3l3WpRjL12m8F4xOH+PQfQDfXhjzaM9ZK1UFM3/WB/+rIm/DKBjMiVU4ukkXWDJoMdXiquDJAvInGv4RqpPrH5r+5ioymuRIYRRHDSgKsbeK0+2ulpBCT2JNI/Rlosb7NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=O3FXNotG; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="O3FXNotG"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 628EjCOL2718759;
	Sun, 8 Mar 2026 15:15:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=EtR6NbreNC7
	By1QB3a/OgNf3v4xQSX/Taq/8TTR4TII=; b=O3FXNotGJqW7FyDbQbn//PhLSMS
	t9SNP7f02tlC6nzD8rnm3LQ+wWE7HKPpwUpadOu7mmjQ1wgNaE8zJtJ9LxQJq7C9
	o1gNanEKo1wVGNtd6iAjPH1YbRHw/3yaqGYKBZRcp2hMIL3UfCbBfWFIPOlFgWOh
	GJgSJd3gAHEdulcpUrQJ61vtxhQZfiNLiAy+RRQILiHFNuFQZ0WE6iK1p7kSvhdj
	l+K6fKzkNVb7qYmMTOYtfASoeD4OZbmXLCEwiCdiBKbOY+kLvaIhPEhuBsZttkh0
	sXI0th1Vi6DEQOa+TIJFBr18Nh9YgiEsat9gnqkukr+FD5THY6SQt6hXMbg==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4crayrjup9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 15:15:19 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 628FFHCl021298;
	Sun, 8 Mar 2026 15:15:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 4crd45jvgn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 15:15:19 +0000
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 628FFICn021309;
	Sun, 8 Mar 2026 15:15:19 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 628FFISo021307
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 15:15:18 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id B2F325A4; Sun,  8 Mar 2026 08:15:18 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-arm-msm@vger.kernel.org (open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 12/12] scsi: ufs: ufs-qcom: Enable TX Equalization
Date: Sun,  8 Mar 2026 08:14:09 -0700
Message-Id: <20260308151409.3779137-13-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=U5qfzOru c=1 sm=1 tr=0 ts=69ad9287 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8 a=ENi0XzU5rTanaItzT-wA:9
X-Proofpoint-ORIG-GUID: zwvqGyC8MhrsCn7yKGPbo6Ga34_UzxZL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA4MDE0MCBTYWx0ZWRfX+ldZOirUbRsC
 FQD2MUV9r6zDLgQeAu4ZSdLG5VGDmG3aHJS8DjrmpmOFrubIpLCB/R5OpuaybTUePkZezoMp5tU
 pdtrUK7i00ekqSd1xJ91eWDBZdaQHz4L4ChbcFVvP6uATHW8JnETq/AED1lb1S6ErOmmq3fopQl
 HFpvMMjJ4Pj5F7Ipr9hnm504oBveTN33KfBiagoHsdFDmq2C43BuRZRAQNDGpK3tOUPGC57AqDw
 dAk5VMQCrKoGQwdOkN4A37W4E4uq1o2zIVPUwh1TaARz8D4FZCOQ+jkV4W6ixEY5FRZCC12dgHO
 dmjSXerRhiQxwKHGPVFzz1KQkd3UlumiHcPgVNzKZLfYOlizgUOEqjKNwu5/HzUjafk1di8mhcr
 8HZEzFs0jNy47N2j+0LAmXr1PsA1UWBTJNdMkAGZVZpRvCZhfD81Yyp+ftBcy7WnLeet7TIU1gB
 Idzz5yXW6PlM2q9m2RQ==
X-Proofpoint-GUID: zwvqGyC8MhrsCn7yKGPbo6Ga34_UzxZL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-08_04,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603080140

Enable TX Equalization for hosts with HW version 0x7 and onwards.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index a7feef2385fd..af481499e2c4 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1394,6 +1394,8 @@ static void ufs_qcom_set_host_caps(struct ufs_hba *hba)
 
 static void ufs_qcom_set_caps(struct ufs_hba *hba)
 {
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
 	hba->caps |= UFSHCD_CAP_CLK_GATING | UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
 	hba->caps |= UFSHCD_CAP_CLK_SCALING | UFSHCD_CAP_WB_WITH_CLK_SCALING;
 	hba->caps |= UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
@@ -1401,6 +1403,9 @@ static void ufs_qcom_set_caps(struct ufs_hba *hba)
 	hba->caps |= UFSHCD_CAP_AGGR_POWER_COLLAPSE;
 	hba->caps |= UFSHCD_CAP_RPM_AUTOSUSPEND;
 
+	if (host->hw_ver.major >= 0x7)
+		hba->caps |= UFSHCD_CAP_TX_EQUALIZATION;
+
 	ufs_qcom_set_host_caps(hba);
 }
 
-- 
2.34.1

