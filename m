Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7FD3CD8CE
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 05:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776923985; cv=none; b=SdpxU0Eo6UesEaqbLIFdBguxOf/vWHR2xJM8azy1gj32hN+CpOil0gdNXyFx/LZoCUZL50137g3Y77qFGgSNSuceMeBa7jAwbsG6cTrKiOc/hAYn0Zf0YTe0LqtS7MZ7n0BdudoDHe+N+ed6J2/LoyJ7qzBVJY8uj2Ow0Pj5UdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776923985; c=relaxed/simple;
	bh=1AQ/Due4IloRH6PqbqtwJJhCyJe1FAOAHsQoAaiIWig=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RYbSMRo49ig7ZNaP/zEAbzWYu9Tkm7QjGLIsbnF4Ta6grhw5v8Gg0I6+HP68VUkpMQVN7depr44eICYhLEEU1vgu2X1VlikoYKkItvSyNP7H2TJf+ysTab8vpu+qPbLRmlEV13wPdET/rkU9sUrhYfab99jTI9TUt6kKpGDlKHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hoDVcpOH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fnspNgeg; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hoDVcpOH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fnspNgeg"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N3aS7U3528447
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 05:59:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=b8mBGmprGjV
	jfLz070FTlou3WVMADchu5GjJPHxk8sQ=; b=hoDVcpOHVKf5h5aCOGbU+Lxur+O
	u9Lls+JraJrqk6bb3/23PWpnAvx8aslu7J4VivBMf0dVXjn/sfsLmBzJpG2sRB7v
	RcFiTXCzIN8nPZin297kJggFan9ceoCVksrEzH0vM7zCwfplz6Z3tDrofmEjJ29M
	D3HDtvD0Bfztq0WoJl+OSd2FlyZqNYPlnQmdv5Pa0aZR0NoY54XK3yo36l0Den/f
	Z18kc5Hjp47U5woV+sR0FzyHR4aZePZ/6n178rjoka9YRJtDSZ+oWY0VxSUtcCsW
	jT8nBeGaIbmtIVmBDLkwlVrwC9yqouGu8FHvsByx3QTwqTzlulXkOm1tZKg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dq16wtg25-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 05:59:43 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-35641c14663so7641535a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 22:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776923982; x=1777528782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b8mBGmprGjVjfLz070FTlou3WVMADchu5GjJPHxk8sQ=;
        b=fnspNgegYZ8P3W7evKD4Ih4dEp0WYNH8Oi+u4Tr3IC2JrSYUvUi36QiX67AoAN5V3V
         vP57Mrq5N4jxgCXdr+BF8BXP02R2i57NJmr14B4yK45F0x2bziDGYTM/deqCr0tSSVRL
         4296Lvo9JmTyDHKBwU7WvbTTEi/7eoZx2QS4RxHVyPdBBQiTpJsSx/Qqc+wkTCdAzNdC
         7GVmO/craULFFHDDkzWG96Z/SkfwSZElr0TiKa4qwQxgWW0Jawu2NLO0MGfWs5amG1aL
         bofAgeSF0jVCvkxBd+CgKNd+boy7b7y2xMT7iUouUAcJBbQsYtJsJwFnu5UX5oMf2kWZ
         T2rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776923982; x=1777528782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b8mBGmprGjVjfLz070FTlou3WVMADchu5GjJPHxk8sQ=;
        b=VqXKgALCoI2ieQhxX3ipcBQkadVEFAsUG5+nq0YE/6kKDcssg+uu/QXemlsY/IPF0U
         5Tkw5xZR8YiVSsCuUpGjYR8AnsjaIBe2ifEj6eo9x4kA0OJz1tpKC/0EQgV1XxfjoB9j
         a1hFPSqaaqg/SuBbAUzj3OZ6Nsh5KWuoZr9BOVV9drXCAlWeEKOR/1lfT4OY6mUUkrO9
         JTha4X4skZM6RVyYE8cOQRLhLlrspO1HtTznvGdfd1o8wLHt8o2hzps+xxsNfZtH524r
         55xC75s/K9rX7io4g+DgcIo3rCxYj2ja1MqILVM+7mW+O1qupTNHUCD5nm0JlZEQ0pKR
         sEJQ==
X-Forwarded-Encrypted: i=1; AFNElJ+4DynCs6m5DhIVUYm3IJy0BpxP1HwDk7kksHJu6E34Pqz4TESfGYLJHW9IYdNf7VlEmImN0XP6XxRj@vger.kernel.org
X-Gm-Message-State: AOJu0YyT5LYjR/Lcwz/haGnLIGLV3jbMAa72AXAMn/+tQR0C1Qgdjwb/
	xjhhhE/8v0rhncNaxPOJfreR6U0UdEfxJFQYNvP+fIaBqum8XEqU2DXK8KYeBf9UcdbHRTPBOn5
	z3K6VMRkhf0mkYYYzJXSzDzc5NNaIUx4F2/hD0pQzhlxgDraFRhUhDl43bmr2bQye
X-Gm-Gg: AeBDies54HETGHygBTASuRDzgxnrt8BLV/c+pz5gtb7cmvhhTb3ZodLi6qDYp/E7dS/
	iSiF1E7hElaCBbM2vtlsiuPNCZTczNdC/w9JBSLJ1fVRw7MPcT037GawUQUV0hO124uzNff7hFc
	ll1mu7fVmV3+U7Sr28nvy4FaM9ycliBrfFi6RTi/WspVOoHBMmfauUxreG6bVxw86RtGLMIxxR8
	RJQyAqVHnKGDhjn1QFusv+f9Ge7sg52or295kJgh0R0r1UBhxaZObaG2LkV9GILU3i5dlzANGiQ
	s0bZmOjG4G7khVMUgwL0YDaoKzxPTuaZQroDXvKsLK06IsTnyM/caBhfROAwzqCuyEquPdsTVCQ
	WUxGXs6UJ3Bx8t65zaZ3Zu60mYC2RTeeVXUN5rRINkD77QfUuOlKr4WjOSam+015Y
X-Received: by 2002:a17:90b:5286:b0:35f:9ab2:a5a6 with SMTP id 98e67ed59e1d1-361403d5b55mr24724627a91.2.1776923982101;
        Wed, 22 Apr 2026 22:59:42 -0700 (PDT)
X-Received: by 2002:a17:90b:5286:b0:35f:9ab2:a5a6 with SMTP id 98e67ed59e1d1-361403d5b55mr24724592a91.2.1776923981618;
        Wed, 22 Apr 2026 22:59:41 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-361418c3944sm23461841a91.8.2026.04.22.22.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 22:59:41 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        shawn.lin@rock-chips.com, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V6 1/2] ufs: core: Configure only active lanes during link
Date: Thu, 23 Apr 2026 11:29:13 +0530
Message-Id: <20260423055914.3566684-2-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260423055914.3566684-1-palash.kambar@oss.qualcomm.com>
References: <20260423055914.3566684-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDA1MyBTYWx0ZWRfX86MszcJAzqRg
 /uVVV55JMx310bD7ULkeS05Ps/GeoZ82+OXhPdPSZxvnSOKonVq6xS+lF9O23Qo4JewdPQLKTIp
 hHZXxOGGViWINVfiHp/aLY4PM1twWeOVsFf997umacoTg/6z1e9n9EX6UCZQKOGMQFsILRPj1Y0
 DvatvrTz9TYuY0hDw+eG1Ntz6zP/98FjPkkSOZSn1mJyW+mD3pQ5eOtPQX0VnuxbMCYjutsCUlR
 pxPkOcpxyOb0HpZ3TiHsFYD0BjzxYspTLIR7q6Xu9/ueMFfx4de9s4dsVNfbzziXFdB20mW5l81
 KpsNVyE/NdIb8aVwq2ne/fpos7GOk5FzX1hVFSjbw1zInCVRkSxPKG6fG8U1sLtSbXv+q7cYeii
 hQzv44qxFvdEt0rR0Oaa1lWJdPQaOPHlxJIaBY24FzgGswZWm4Cfn79iSNl79SNYYXxwZ9V5kVX
 4pp1lW6oRwd14gJkZlg==
X-Authority-Analysis: v=2.4 cv=dL+WXuZb c=1 sm=1 tr=0 ts=69e9b54f cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=N54-gffFAAAA:8 a=s8YR1HE3AAAA:8 a=VwQbUJbxAAAA:8 a=Z8YMyZzXpU5RQDwMThsA:9
 a=mQ_c8vxmzFEMiUWkPHU9:22 a=jGH_LyMDp9YhSvY-UuyI:22
X-Proofpoint-GUID: RfT7xwN_ao-UXxL7PIpmLGmPCeTbe6Ke
X-Proofpoint-ORIG-GUID: RfT7xwN_ao-UXxL7PIpmLGmPCeTbe6Ke
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 spamscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604230053

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

The number of connected lanes detected during UFS link startup can be
fewer than the lanes specified in the device tree. The current driver
logic attempts to configure all lanes defined in the device tree,
regardless of their actual availability. This mismatch may cause
failures during power mode changes.

Hence, Add a check during link startup to ensure that only the lanes
actually discovered are considered valid. If a mismatch is detected,
fail the initialization early, preventing the driver from entering
an unsupported configuration that could cause power mode transition
failures.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 drivers/ufs/core/ufshcd.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 31950fc51a4c..fe5bc85c6870 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5035,6 +5035,37 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
 }
 EXPORT_SYMBOL_GPL(ufshcd_update_evt_hist);
 
+static int ufshcd_validate_link_params(struct ufs_hba *hba)
+{
+	int ret, val;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
+			     &val);
+	if (ret)
+		return ret;
+
+	if (val != hba->lanes_per_direction) {
+		dev_err(hba->dev, "Tx lane mismatch [config,reported] [%d,%d]\n",
+			hba->lanes_per_direction, val);
+		ret = -ENOLINK;
+		return ret;
+	}
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES),
+			     &val);
+	if (ret)
+		return ret;
+
+	if (val != hba->lanes_per_direction) {
+		dev_err(hba->dev, "Rx lane mismatch [config,reported] [%d,%d]\n",
+			hba->lanes_per_direction, val);
+		ret = -ENOLINK;
+		return ret;
+	}
+
+	return 0;
+}
+
 /**
  * ufshcd_link_startup - Initialize unipro link startup
  * @hba: per adapter instance
@@ -5108,6 +5139,10 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 			goto out;
 	}
 
+	ret = ufshcd_validate_link_params(hba);
+	if (ret)
+		goto out;
+
 	/* Include any host controller configuration via UIC commands */
 	ret = ufshcd_vops_link_startup_notify(hba, POST_CHANGE);
 	if (ret)
-- 
2.34.1

