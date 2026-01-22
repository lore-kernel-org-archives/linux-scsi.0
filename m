Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A3B2E265A;
	Thu, 22 Jan 2026 14:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769091225; cv=none; b=WjnIHkOBAP8H9sZ4GWwuU5vSkQpTzp916ydf7KkjZ62p0m1SArQFviysz9Hi1gAIZgceBI68fA0TmaeuaQBGiGh6MkPn/zq5b9/IDMwN4BhT5bwLcGN/9ZPF1ZHVeaWH1iRxN00frA8Wq5NByGtiBpmFqMhDOXM+//X8LJ7A6jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769091225; c=relaxed/simple;
	bh=ueTtTVB8GC9WUyzeFqiO8jHKsbzgOPS/r3MQMGdx6f8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mA8PAfzSsSf3wBueK+oSNg3Z1gwQxxYU83x/N1kotKyOSMiSB/CN+EctsYOZoxmcT3brKn7y5lNEutEsHq0yIoQyFCh8kkNOQbc+X7Z2j1av73atv1b3T6LdzfXLvstY2uCQQPOGxV3GhrHwZYetN6NXXwTRKSRJMUVkCGDz3zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AAMMqvrd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AAMMqvrd"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60M7B3BA817280;
	Thu, 22 Jan 2026 14:13:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=jLUgQs/4OUc
	fayTLxtAjSVuB0VrHJh6CCqMEaTwZTI4=; b=AAMMqvrdW2hRR3CpOUBMiGpjRkK
	o+bRRdDcqkS1PwJOdkpxxndbvqC6xWIJWhz2lCIeuu774WBcBaIy44mMcNgXoQkV
	hOURu1UUxD+i9aedzWXEBGEo0uLvEav5bSL30v8uz017r64WKFaeSxHRP6eheF6j
	eHriUQmRLgD0/Xq8DayUqCMDLPVmjSRgoyAn06sxvFVq+fxcIbSjm+Y+ze05GDzB
	o6EcA3muJCTIQwfWlUCnI4bC6O7NOvjTZ/EMUzVGFcOlcW1cvl7sJVXkDg6fz+Ne
	tGvpOqHt7jttumhIufmasHGHN5sAgqYhlSW3ryu01j50njI/3+FbXGy1fMA==
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bu65v2rw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Jan 2026 14:13:39 +0000 (GMT)
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 60MEDZlM003679;
	Thu, 22 Jan 2026 14:13:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTPS id 4br3gmypp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Jan 2026 14:13:35 +0000
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60MEDZ0T003673;
	Thu, 22 Jan 2026 14:13:35 GMT
Received: from hu-devc-hyd-u22-c.qualcomm.com ([10.213.101.157])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTPS id 60MEDZ5Q003668
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Jan 2026 14:13:35 +0000
Received: by hu-devc-hyd-u22-c.qualcomm.com (Postfix, from userid 2342877)
	id 747325E9; Thu, 22 Jan 2026 19:43:34 +0530 (+0530)
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Subject: [PATCH V1 3/3] ufs: ufs-qcom: Fix sequential read variance
Date: Thu, 22 Jan 2026 19:43:31 +0530
Message-Id: <20260122141331.239354-4-nitin.rawat@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260122141331.239354-1-nitin.rawat@oss.qualcomm.com>
References: <20260122141331.239354-1-nitin.rawat@oss.qualcomm.com>
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
X-Proofpoint-GUID: 5zvX-tZmSMbsd3o0ukosornQIZwo-YCo
X-Proofpoint-ORIG-GUID: 5zvX-tZmSMbsd3o0ukosornQIZwo-YCo
X-Authority-Analysis: v=2.4 cv=J8qnLQnS c=1 sm=1 tr=0 ts=69723093 cx=c_pps
 a=Ou0eQOY4+eZoSc0qltEV5Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8
 a=Qz0M3Qwa2ObwqG_0uY4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDEwNyBTYWx0ZWRfX90c39K/uSlfO
 bCa/rmILoz0l6OeP0bp7ibnip1zYd5AWR+OEKAZDL7kFYAeZ8q5uilGOPx1UMxS6poWiOjrQsLp
 xD7BjedL7IbBjfm9AgkcARF2CTluPvIXSodOYxTSRxnaesQpsl3NKh2eDjzPUh/0h56ddgJPJui
 q6biJNoaQ8Sl8chsO3z2X7sWKVqNv35Z1cFwISgEGA9wwxDV33++hE1IrYPN21VqsRy/ql/0D9t
 xZTyED7/QNrQrfTQF8KEw3mGAOKtfhlpj7j1gg6IQ7p4AZLeb8mAhLqP50ITpA1vxM3cCUHv2I7
 O6QecV86OficiAgMcbC2BxMnUji2dE/LgPcodvnCcW91QSVeoM0Zbaiiykcm1Tk5bEwSVYgpj0O
 ZRGbQRoSkv7V4c7e4IafK8ghpQLOEUn9pUkx3arn1v83A2yw0TXc7x/M3k57UGPMxZ7W2MssRnQ
 a7Ssmu5pWTtZ6tyNQjQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1011
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601220107

The current devfreq downdifferential threshold of 5% causes overly
aggressive frequency downscaling, leading to performance degradation
sometimes during sequential read workloads.

Update the UFS devfreq downdifferential threshold to 65.
This widens the hysteresis window and prevents overly aggressive
downscaling, ensuring that frequency is maintained for loads above 5%
and scaling down occurs only when utilization falls below this level,
while scale-up still triggers above the 70% threshold.

Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index ab5aed241913..5ef810b95b72 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1962,7 +1962,7 @@ static void ufs_qcom_config_scaling_param(struct ufs_hba *hba,
 	p->polling_ms = 60;
 	p->timer = DEVFREQ_TIMER_DELAYED;
 	d->upthreshold = 70;
-	d->downdifferential = 5;
+	d->downdifferential = 65;

 	hba->clk_scaling.suspend_on_no_request = true;
 }
--
2.34.1

