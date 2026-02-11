Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016DF366DA2
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 09:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770803298; cv=none; b=GAQWTTd2VWPCmlAyIElbX0QrcPxY4C/WzzWeGOmBXdLnMGbyaDp+GgfV+XJYRsm20Y+cQLiZa4HtT9T4cBZmoB28sA7focecgD/b8kDEMaajvXq0dIfVrzxMfyrNPdOBpA91AKOmLGUZz60xjQxmNLST7i9jE11g4lHv94lZxrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770803298; c=relaxed/simple;
	bh=ErJkRgjBn3kKndkizVQHXkQsIRTnMx+SsxhZmXO0g4M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CHtO8rJ+LSLq+LN6NjM0hS3fk3MOGqO7DiMx8+4w5rQmwgoUc83BVOrzK4jEtnJ40NkTlEfm12rwryKnCV7QJN7t4SADikjoQPUOijOdR3n/EkfiM8Jdi1/aQW5XhoyZEpA335yEWEUMpSlf2OVEbb50ub+rgUkw3N95RRcRb+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H/Ac56Cq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YGCS2E1J; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H/Ac56Cq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YGCS2E1J"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61B9JNXC3322724
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 09:48:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TsVRt6v8DspztJLCo2JToFVZCJzTWengupu9/MmG2/c=; b=H/Ac56CqqD9ny6nO
	sFV6m0DbpMQZbIyeahh+s5P10jaay2+Vk5ESk5ASNCVw0abuT4pZ2+yLfNXF8Hit
	BuTpgyQFjl8VxvkoJRgj0dRcLGq5+vbfRoC5Fi66tR909+RnHGWfOxumxYGMrI1j
	IB3G0/Zt1obrrY4W4qtchJCY9GhUyn1FHsGTm2ts2lORfmfYM9neBO9Dmmc8xM4H
	NV/obGSGx3THDn0dd60sWNZqKWiGyvZZdsO0L/mMBZSSYP/5Wvh96nWClmxXNmzD
	il5LuqS2ARn2QfBlsmZZs9hwGeCFMf2o+POUtT8/Ei9wNLoN4esoJ/WNNIicGiI+
	bY+TXg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c8epshjyv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 09:48:15 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-352de7a89e1so1632907a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 01:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770803294; x=1771408094; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TsVRt6v8DspztJLCo2JToFVZCJzTWengupu9/MmG2/c=;
        b=YGCS2E1JQ8IWd+yPcsKtLK1cxL6MvLHvBE7JbZ3XcziuaLYC0Y7nrw1FlvXaVGSuui
         k7Umxki8NwuAXUMXNYC0Vo/+m4pFCmL8SajXIth0A89XeaUq7j/X51zvrtrSg8L4hF9D
         Di+yt7PLVUQmTMO9WGM2/M2LFZK2OyTP2wiG+vqRd8gTHLXoTunK6ajM30hBuSkNpBT7
         EPiDL0H7J+CTT3wFddmvE+21UUEUdYrxsBcmxY/ve7wvJHSnAn3+Q6Fm2ORG58PcZ8yy
         fhf+BOySNtib3OaDFxJjVpXU6zM9210/4RPOsHOTCYD2gwhVt5CXTqxbsHoJjWumf4/d
         0yMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770803294; x=1771408094;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TsVRt6v8DspztJLCo2JToFVZCJzTWengupu9/MmG2/c=;
        b=k2QlLVz49nJCszlNBOr/93L+JBuiSrLFz2WKZe5/wb33xARpM6hiX+oeuvCQXERl1j
         DSsHOW9A0mhFzcOeTXVsnKWpElsljkFU2uDAchWfkbFby+3H8kWe95PDJyQ6+Qppq1Ho
         aq0pJoVwcUigLv14iN+yH4ug9yc24/U2kRnAtaBwan4EgseroFcopAA0TUb+ZadpgDof
         eS8h++peNM+HO9qAOo23SW2jr9Qe2b2Em83RjJYbwrAJgPT08zoI7b+s3LKCd5GtvVwL
         jcWcYphfa6k+0G3ZXD0/C9C1dGFQST1y0KrD6CVOfNyuMc2kruTqZOU2uYw1UyBSlQ4J
         LdJg==
X-Forwarded-Encrypted: i=1; AJvYcCVPrcj1u06+yq0+Nsi3lh0NXwMIX1nvFJTKjLKCjjvNMhy4xKFn9MUjhCBWVlGykvhDJvwE1cGKIsRt@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2bkFWYM4hsPzxJQZV/rrxUxNfV0IlzH/2wCMyT6k1NFF5bMRj
	CXjY17SGSs6QLgkvkE4xbI3IdMUv5ogi/LneOtW1fnrzz5Wq/WiBWzo8dhfhqzp/29bSolltvwj
	2epcWGXIdD2XYVrZ5Ql4D6ztN8BvwjNo4F7ePfQeNfapY6q5eCNm4I8Iv3jn37VHYMHzTI/Os
X-Gm-Gg: AZuq6aJo12nzuO+LCvVQGkkemWNXPHPr++/W0f2XDo5AZvtyiAN2kZod7ig7PHNIQ3b
	AegMOMhhwNyqCH+rvuSWQOFKw+kFasHbA0oZOOYTxHOfURzldN/z5hFrH4ZRLdOkewQFlNHOgbM
	Fofn6iMB7uo9a7MbGfU7Y73icz6xKidawDOWiAyw4wzJBcMGpNM9gWFtQqfOuvOmR01WbMWk/Ts
	H5OVXQVd2fCCUtB/wxjmZHieTh0fsnnwyHWpd2AurY/ntugfvPZgZpC+RumH7zFsLA2c0+hKc9L
	aNNMeF4LS8ULK7oafm/cWUw18YXEAMp4nhmClCFhsI4K1XgisyVhxTyvNr8fxPuGy2lIg7RZJWy
	FIX0yO5T4ORPnvNhkKG+QqvxGETXf/EnRw/Y2C6NzCz25vwUikXHfFyokfrs=
X-Received: by 2002:a17:90b:2750:b0:354:c3a4:3a2 with SMTP id 98e67ed59e1d1-354c3a40bcamr11698251a91.29.1770803294433;
        Wed, 11 Feb 2026 01:48:14 -0800 (PST)
X-Received: by 2002:a17:90b:2750:b0:354:c3a4:3a2 with SMTP id 98e67ed59e1d1-354c3a40bcamr11698226a91.29.1770803293978;
        Wed, 11 Feb 2026 01:48:13 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35662f6b84dsm7526640a91.10.2026.02.11.01.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 01:48:13 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Wed, 11 Feb 2026 15:17:46 +0530
Subject: [PATCH v5 3/4] ufs: host: Add ICE clock scaling during UFS clock
 changes
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260211-enable-ufs-ice-clock-scaling-v5-3-221c520a1f2e@oss.qualcomm.com>
References: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
In-Reply-To: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDA3OSBTYWx0ZWRfX79pLRjCs7X4I
 M5NzK9ZyBkngzhb1S/w+Lc3kDT+dxXeuliKcI77eyeTX4S25n1pR0rg0nKi3KpnZRJMWKAkZUa0
 nkpz3qIrkebmGgHaw+gnQ+ejyE63EYsXFqq+7YwPiUr/R9JwLYm/2wFaA0bYRHNk1jfY/wuN+/O
 FES3CWv7PPBYvGAzPCn9Q8+C9MV6a/88kkwV4Dxgsd1ZKGf+ej/Y2161Mt4Trkee11Poz2xwp+U
 jbgrqbmC0CRS+B7cT3M921XQfUS5wnbeIShGQqNBnY15h1hWwF62UQrWYmoD74cnYahswY5NPBY
 V1J8QPeX5YLhfbAsSITPvuNunEm/dJKshWeNmLccRv6Q8Rqa7jr/i4dneE36t+jBw4NgXC4VNJL
 G3IejV3vC3iRzFPEMqv7I8l2hQqguHwdHd0XyJuA4aZeLeH1Ri6E9a29L00HpeZL0IG57Wh0HiB
 Up42ifkvM0oAPkWPvCQ==
X-Proofpoint-ORIG-GUID: AQVgiy7b2fj4w9lo72XE9GF9E0zCFIXz
X-Proofpoint-GUID: AQVgiy7b2fj4w9lo72XE9GF9E0zCFIXz
X-Authority-Analysis: v=2.4 cv=I/Vohdgg c=1 sm=1 tr=0 ts=698c505f cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=6u5mSuNpuy9df7-r3awA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_03,2026-02-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602110079

Implement ICE (Inline Crypto Engine) clock scaling in sync with
UFS controller clock scaling. This ensures that the ICE operates at
an appropriate frequency when the UFS clocks are scaled up or down,
improving performance and maintaining stability for crypto operations.

Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8d119b3223cbdaa3297d2beabced0962a1a847d5..00cb9cde760380e7e4213095b9c66657a23b13ee 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -305,6 +305,15 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
 	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
+				  bool scale_up, unsigned int flags)
+{
+	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
+		return qcom_ice_scale_clk(host->ice, target_freq, scale_up, flags);
+
+	return 0;
+}
+
 static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
 	.keyslot_program	= ufs_qcom_ice_keyslot_program,
 	.keyslot_evict		= ufs_qcom_ice_keyslot_evict,
@@ -339,6 +348,12 @@ static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
 {
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
+				  bool scale_up, unsigned int flags)
+{
+	return 0;
+}
+
 #endif
 
 static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
@@ -1646,6 +1661,8 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
 		else
 			err = ufs_qcom_clk_scale_down_post_change(hba, target_freq);
 
+		if (!err)
+			err = ufs_qcom_ice_scale_clk(host, target_freq, scale_up, 0);
 
 		if (err) {
 			ufshcd_uic_hibern8_exit(hba);

-- 
2.34.1

