Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB08F20320
	for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2024 05:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709098477; cv=none; b=QINmgkcFvA16M1/W2KlCeF11j2EkvwN0BjrvegF6x6ZxFLjKMnoWctza1gccLIwm0lJKyc7M/vHnKVcVB7NioGuiTgzx1a9LTkSTtb2mr4HS+n4wLAt490qc2AzFW6iVl8mCxcXU4jPL7NOiMvpYisOkGgT3GQOVnT//rpPIn5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709098477; c=relaxed/simple;
	bh=r5gaKl4/9HOnP/7BXNKdCndwJNiByOgkcYLbOPwkeaw=;
	h=From:To:Cc:Subject:Date:Message-Id; b=tNazI8K8retsOjqZ19y1V2wO3sE78T0Yky9pBN2tnh2CT1H2VJr0142gIFK2MP3f/C2pxRBSHoXTchFxjZNCTermCjs2GYUe5pUWYv2nWub2agOI4II919WmyinDP6n60XzpyNVVc07V+LVNC96FjBKuKaOuCjYqjmhR7Gj99xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=WNEAD4pj; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="WNEAD4pj"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41S5FMIs025309;
	Wed, 28 Feb 2024 05:34:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	from:to:cc:subject:date:message-id; s=qcppdkim1; bh=fZVSLmxyDzx+
	9tjstc/mDLZTmAULRxRuhBJHjIqW95g=; b=WNEAD4pjakfFOgeNdJF6cQnuRpVV
	YayY0CwpulJfb9/hIr0dd/24kdLwC8Zk++ZQB66Uss5QNdR5iUsPSqU4SXjrIu4Y
	J9bW3grDI+Ey5ry58vrBSxtb+A1Edny+6cbQggPsWzMLmqLmYUnCezVunx7RjRlS
	nKKG7W0mNp2M5wiTQh96wuBqCkV048jFrbog3YAxyIureiKOBsRdj9WHteJcof8n
	NDC3CHjirAjNLLcKNTp3SyUsIWD4wnnaKQSDoNHNd0JtGiKetuIEnRcI7sjKkerO
	HCRiurKPpZ1eBrXPseCfClZouKmdiofWp6dtkjYsJd3YruzpIoWW5rP6fw==
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3whwvt82y3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Feb 2024 05:34:31 +0000 (GMT)
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 41S5YR56021380;
	Wed, 28 Feb 2024 05:34:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 3wf9hkg4n5-1;
	Wed, 28 Feb 2024 05:34:27 +0000
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41S5YR8n021374;
	Wed, 28 Feb 2024 05:34:27 GMT
Received: from hu-maiyas-hyd.qualcomm.com (hu-rampraka-hyd.qualcomm.com [10.213.109.119])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 41S5YQ7S021373;
	Wed, 28 Feb 2024 05:34:27 +0000
Received: by hu-maiyas-hyd.qualcomm.com (Postfix, from userid 2305851)
	id BA5F25013C2; Wed, 28 Feb 2024 11:04:25 +0530 (+0530)
From: Ram Prakash Gupta <quic_rampraka@quicinc.com>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        peter.wang@mediatek.com
Cc: quic_cang@quicinc.com, quic_nguyenb@quicinc.com, quic_pragalla@quicinc.com,
        quic_nitirawa@quicinc.com, quic_bhaskarv@quicinc.com,
        quic_narepall@quicinc.com, quic_sartgarg@quicinc.com,
        linux-scsi@vger.kernel.org,
        Ram Prakash Gupta <quic_rampraka@quicinc.com>
Subject: [PATCH 1/1] Revert "scsi: ufs: core: Only suspend clock scaling if scaling down"
Date: Wed, 28 Feb 2024 11:04:21 +0530
Message-Id: <20240228053421.19700-1-quic_rampraka@quicinc.com>
X-Mailer: git-send-email 2.17.1
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: xiND0i2fx-5IgKpWMVguOe3BDY6bn4st
X-Proofpoint-GUID: xiND0i2fx-5IgKpWMVguOe3BDY6bn4st
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-28_04,2024-02-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxlogscore=999
 bulkscore=0 spamscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2402120000
 definitions=main-2402280041
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

This reverts commit 1d969731b87f122108c50a64acfdbaa63486296e.
Approx 28% random perf IO degradation is observed by suspending clk
scaling only when clks are scaled down. Concern for original fix was
power consumption, which is already taken care by clk gating by putting
the link into hibern8 state.

Signed-off-by: Ram Prakash Gupta <quic_rampraka@quicinc.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c416826762e9..f6be18db031c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1586,7 +1586,7 @@ static int ufshcd_devfreq_target(struct device *dev,
 		ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 
 out:
-	if (sched_clk_scaling_suspend_work && !scale_up)
+	if (sched_clk_scaling_suspend_work)
 		queue_work(hba->clk_scaling.workq,
 			   &hba->clk_scaling.suspend_work);
 
-- 
2.17.1

