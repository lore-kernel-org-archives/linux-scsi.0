Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739F2299922;
	Tue, 25 Aug 2026 14:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787669546; cv=none; b=Pl80FjuFphUCu+yYYPy5KXSfbNHF6thcPw6zh/mvvp5rpSV5WwDi17s6gXLTjyR0l0DJJWk7g0H0Wh17MBfW7YG2a+HJdUswczWVwvxEYVzK+aPM2TJfPx9F9JO1nkrfq/bNRAE9W+IhYhzwD83UNxjdQ4sehx09IKjM0vd4j88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787669546; c=relaxed/simple;
	bh=2+5AmPM/bnoC/0AGB8YWIpRzHhxre1udeUZJmrST0UQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qckz5fdPcOWHKe4l7TNaOuuKYs+9uFfVLqbB3oy6EevtvAP6/7jaKl90YGo2T+7pIc7JYEP7jVkQ+wbiOhSjOiDr46sbAx2nKfbU0Gcs+48Oh2KtZniDm8ZOBDqbu0fSWZRKv9d7C4MiPZcCNCYCI88i5bfAtPzW8zfnhK66SKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JpVqzeI5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JpVqzeI5"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67PEUKJs1727613;
	Tue, 25 Aug 2026 14:52:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=JVbsZ1A9bAk
	AazSfcmCvj7O4DpTxLXgjjGjpEvKDVCw=; b=JpVqzeI5hjyR7IiXsUBCHzjao/W
	8lDnwk3j6ireZbTvF9/7u3MS7vRrb1YXVzX1Y2YUoOu2hVhPQylRItNhTwKylBt7
	2lK3RrUTTdg8fKaUI7qPkksqhp/75EK3AHCFBoDyWGqY/ynmF01rN33EOJCB07rh
	V9xcukNX9YEomzQJLofBeyNJ9+t8TVg+FV5YyB+Jthnv9EzGtIh7nasVB84B8kO+
	68XVlNzSCUmBButf4ClXovySJV8n2OGjWEaEu/jowrC/evx49c0K3GPG1322aqG7
	NXt9vv2f58FjkloswCDtyHnWWJ7QaMLUKzgm0PP0keA7OC1ps21NROo4feg==
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g9cgu06wr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Aug 2026 14:52:11 +0000 (GMT)
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 67PEq8K1006177;
	Tue, 25 Aug 2026 14:52:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTPS id 4g74uk183f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Aug 2026 14:52:08 +0000 (GMT)
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 67PEq8Hd006157;
	Tue, 25 Aug 2026 14:52:08 GMT
Received: from hu-devc-hyd-u22-c.qualcomm.com ([10.213.101.157])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTPS id 67PEq80P006150
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Aug 2026 14:52:08 +0000 (GMT)
Received: by hu-devc-hyd-u22-c.qualcomm.com (Postfix, from userid 2342877)
	id C1EEC64A; Tue, 25 Aug 2026 20:22:07 +0530 (+0530)
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, konrad.dybcio@oss.qualcomm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Subject: [PATCH V2 2/2] ufs: ufs-qcom: Fix sequential read variance
Date: Tue, 25 Aug 2026 20:22:03 +0530
Message-Id: <20260825145203.265579-3-nitin.rawat@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260825145203.265579-1-nitin.rawat@oss.qualcomm.com>
References: <20260825145203.265579-1-nitin.rawat@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI1MDEyNiBTYWx0ZWRfX1L9ir1dt29id
 E0WWXwHArUoao4zI4TxWiyBwrHej6FXSw/WWjZarPM28ZCNwiYbBvSVMOhMb5tJWfSIFTkAcD86
 Sg9+8zvVocJFk8jDJh9jVhxDxDJA3YM=
X-Proofpoint-ORIG-GUID: k10n2tlsxLiUTw36MqMRmPFsUA9mVGmH
X-Proofpoint-GUID: k10n2tlsxLiUTw36MqMRmPFsUA9mVGmH
X-Authority-Analysis: v=2.4 cv=Sb7HsPRu c=1 sm=1 tr=0 ts=6a8dac1b cx=c_pps
 a=Ou0eQOY4+eZoSc0qltEV5Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8 a=Qz0M3Qwa2ObwqG_0uY4A:9
 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI1MDEyNiBTYWx0ZWRfX7E7qjxoSIcWl
 HmPgyQukCp3P1ChiEuhRRh2YvpMD0cT3UxmIUWXD2HYF+HVLBMTp3v/Uk2NEg5ksQcWkfEn3xBS
 jDJ2aW313KA5XSO/tT3vk610xlBv8yXxxfvXfOrYKmHp1mMfrNKJmeodNcF91u6lP3pLJYC6M/8
 +FrV51jM2IR2qHJ4mC/ItIqcCwdEr/lzvC7QKK9aHzD1Jjlx7FfhPZg1NgSr2yHBTrRh30VfL0H
 gX66aZoRjlExDtbupRpgH8t0pqSn2zYje95gHPks7BAZR/XSlRQbC2xGf6e6BxXqpdilo2l0Y6e
 L20R6EUXQpXj9HvN1/Qhb39iQHyq3OFZ5jUd/YKlbUdM1+sPhdZMQpuLyvCfqMwovhVs6Pk2D2A
 9SeAj8Nj++7c7R4lD3MqmpznF7iluMIRezTppvSkFJ/9J2s0jQAFrBxY6UpFdqPjdmI/0Hgaphv
 oFlO8/V2o/3AI0smozw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-25_04,2026-08-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608250126

The current devfreq downdifferential threshold of 5% causes overly
aggressive frequency downscaling, leading to performance degradation
sometimes during sequential read workloads.

Update the UFS devfreq downdifferential threshold to 65.
This widens the hysteresis window and prevents overly aggressive
downscaling, ensuring that frequency is maintained for loads above 5%
and scaling down occurs only when utilization falls below this level,
while scale-up still triggers above the 70% threshold.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 35bb9ab5fa2c..16cf1260cbfb 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -2291,7 +2291,7 @@ static void ufs_qcom_config_scaling_param(struct ufs_hba *hba,
 	p->polling_ms = 60;
 	p->timer = DEVFREQ_TIMER_DELAYED;
 	d->upthreshold = 70;
-	d->downdifferential = 5;
+	d->downdifferential = 65;

 	hba->clk_scaling.suspend_on_no_request = true;
 }
--
2.34.1

