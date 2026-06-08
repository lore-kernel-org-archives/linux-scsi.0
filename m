Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CA83A0E85
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2026 21:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780955323; cv=none; b=Ewq4uKNGAmdTYSYCFY2BsvhxLhd/CWvitxYUcL4v7YhFUKYKfzo7hA8vZ30VNioqA8PF+qHN8MwXO5CIgt+ogCnkIGuAcC9aLjamCcLuF3obzO2SqJusdnnSxFTMthEqTBF+uUPsy19Eiuhb96rKbIhbC6q7dZ6Sb5m53rRIeUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780955323; c=relaxed/simple;
	bh=V18lkZ+mYtRW45RZQcZ5zGi4H7dZflBvwdwCuHqEMXs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EVPdPfxpLgZHBoMBQqjr4Qeu3dz2nbeA7l1FYdIqmQzf+ol8GfxWDybXLiVKprDaRJZ0Yx8fsGMVTC8kSOzBotAyngYR5HJc7XgodPrelC3NoE+QYIhkbnm/vfXhLsfWx3cScqS7q3HA8oA7JYuJKKplnYM6bzJyM8sty+JJFZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BJVK7Dj2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FxUiFifv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BJVK7Dj2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FxUiFifv"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658IwY1X276097
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2026 21:48:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	A2btTWcfqlMf79K2ygn2F3WwB6X9SQ/bHFDltKt8bfE=; b=BJVK7Dj20XAZt07t
	qwaKXPK9Tit4+EKS3XvP2r/ubOYWVXrqwZl4Nfon26q3SBcFu3xlskWpP8Qi9yjV
	qCXlHqujpmlXJ6ORrTgpKa338GfwZAyLivf9BrORfjpiY7p9R+cVjsR7I5hdAvS/
	wUu24W/xmS6MyzFAHUelqTbCuyyfFJH7g3mgc4N5jEcockwjHgjCLPooTRoZnoPv
	zb+kxGl/HsPBShKHFxv6qp1NY5FQcjOCO37HgviploNW8pfdo7r1hvSOYBcxIeig
	Vs1gpemk3ojyuJb64fZV074QmC1apzpCao4hlZk9BGTyhNg7MkbIWxPKLLnL0l6N
	kWcRMQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4enuptk38e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2026 21:48:41 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8422a0eee68so6303541b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2026 14:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780955320; x=1781560120; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A2btTWcfqlMf79K2ygn2F3WwB6X9SQ/bHFDltKt8bfE=;
        b=FxUiFifvAyuyytvCJyRAoMEn8z0Rw7QgsGngpkzLEd8tGC/zQlolX5e6gh1WF4VVQ4
         rzm/ksGYXHudO5E8xKtYi4pjHK+1UBmSaI2EWJztpZZ9KNvkQIHsgsmoQWDve7RBuVJ6
         WJNz8RDWGbiOwk4A6lt53u3RpJD2/VmMevnTwKLqnfU1IWRHxkcK0+wxW7T/kVsbyT2e
         wkztYNZcF2nbDHGXnaSAlun/DR2tnFv27ztVVieq7gMwM9y1Dg+WgZUPl4GaFGCgkQ8t
         UaWh6Vk/I7yIEpwnJ/KWLn8SfXtcYMTJb79Z+J75HmiJjl+LLVUr9ctzzFSkEACbNm59
         ZooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780955320; x=1781560120;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A2btTWcfqlMf79K2ygn2F3WwB6X9SQ/bHFDltKt8bfE=;
        b=ZTY8grz2KLl3qOokLy9NTQMFz9c5zHLjMBR5Wb9pK9i4do+kbNuTba+UxlmI6mPF02
         0Cux8pyCl/cAxcMaJ4FGKsuns4R3Uwj9Tzd/3JOPCVyGM8DpkVqgJiCFRVFiF6mlPFRl
         ktvT2/xDu+NGFnBDpaldGNgJVyvUB80bWBlBEwrOWmcrcqOy/AlER0jg6n2KzbeBCk2s
         xkc3RkIyYRsoBF5x3O7nxtrDBn561jd5pieeE/XuaJs9xLUQoIjzs62DtNQY0L5GhhLZ
         zArWcBLcE5flxhDK8/gHKtc0sUnuE5jnUQ9+gHiA00UKvmrw5I+ztIqDSHm2ldvxs2BW
         Cf9A==
X-Forwarded-Encrypted: i=1; AFNElJ8NPb4/5JLalgS5/4+76YfLydSF8vDOwZLxoG/VJGjADCK6L1XoQNYNASwE0bkROTx1DiFXDvAx5ykK@vger.kernel.org
X-Gm-Message-State: AOJu0YyoZIkAFW0jN3UxR8lT4vAcPVe309v/KSfVs0TmPLasX2MmaBY4
	7Z6AV1QE59uPPvYTne4J4lhWaTo6QMnP9Xnw6ZaBotmK5ZJ0/+Zs7vDdWYJcCUE7YDUJ7sOXNGE
	mo3xDrV/2PxdAWICgYQspIWcOsqpdTfja0JhzRLUUrkKqbUYaAeavd1Sd6Y1CebcV
X-Gm-Gg: Acq92OFFn+bu+k77RidQpMrpRpoKGMV4kykftAY8CPOR9ck3QBAsexqPhjiOaYJlaer
	3vNENlgPzNc6mYmilY4mbp4xCs1erbMWu3yUHn96HJ/pV6+xFoWO8NEqzbPawEhqNYcIAElJ7vx
	cgc39qjOOQ4N4DsCuFRN7zmbIMyJVRf/ifRWLmrPgS6tUu4IWDYA51JFwo3VVcwrbAIDl8tOY34
	YfdciobOV0GWtbr77SbqwVXMYD8lrzQhIhLDn8SMz9EfWhvrin1mdzF8w6/pUxIeJWowqDF5+UC
	QxgQhkjtHHGvbJr1RMK2pn3w4RTtLuiMFv7YMr1v98hOZl/KcklP5t+hm4bAcDXtYFO4t8Xj5qU
	3FPFK3cJsUoXNsIUz3iO+ajykAzRhg0xpQwteKevxnrdZVWVd6rbwJuqDhcDmim1ggFTY+A==
X-Received: by 2002:a05:6a00:10c4:b0:842:4982:81c with SMTP id d2e1a72fcca58-842b0d5d2e7mr16779875b3a.20.1780955320060;
        Mon, 08 Jun 2026 14:48:40 -0700 (PDT)
X-Received: by 2002:a05:6a00:10c4:b0:842:4982:81c with SMTP id d2e1a72fcca58-842b0d5d2e7mr16779847b3a.20.1780955319634;
        Mon, 08 Jun 2026 14:48:39 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828cf783sm19607485b3a.40.2026.06.08.14.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 14:48:39 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Tue, 09 Jun 2026 03:17:24 +0530
Subject: [PATCH v11 2/6] ufs: host: Add ICE clock scaling during UFS clock
 changes
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-enable-ice-clock-scaling-v11-2-1cebc8b3275b@oss.qualcomm.com>
References: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
In-Reply-To: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: x6FOjocDu2ymNMCfBAiE_rS35O-9Fjjt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDE5OSBTYWx0ZWRfX4/19Uj7vAO0c
 gt8zuxjKJ5ijl6HfZfeLDA6a0zftBOSABUMXCKdmr5F216dr4Dr8/WzFTHE6lAA/YmkFvOIl+5Z
 HIHpck+LbzmGFhFeqm7/Qv+4zYKntksNClWw+QIgWwY91p8QOLXBX1jMlfy4EF1avu+LhJJfS6r
 cxMLFuCRrQu4mh3T7rip2ET7anCyOfWMMCm6yJ8Dq4J0+3vkqTEl/FiUK+jxmBKblKO738j06e7
 iSzQ7A6lheY89eC9xIXxQozYPe3GAIvMaBrW7mitJNtvoh1yM13qkcRTNKubhXDT/tsjSCfqqEI
 Ktgaf2awgtGwveOkfBAfjclJ2tRTMf4NJL1lY4BjuBVyzJTCkK4aomaiNSu/Mpb+bpYb7+2NvsM
 wPV2FjgnhYfXdzQrFNM2DkW03qHcUXbJFx5lCdFYVokYFN5CAEkMpTeP3NZquSjwRRC36hj0UWG
 WfH249JW5bob/JJpVGA==
X-Authority-Analysis: v=2.4 cv=XKAAjwhE c=1 sm=1 tr=0 ts=6a2738b9 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=4vEl8bdWBwuQafGpEzkA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: x6FOjocDu2ymNMCfBAiE_rS35O-9Fjjt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_05,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606080199

Implement ICE (Inline Crypto Engine) clock scaling in sync with
UFS controller clock scaling. This ensures that the ICE operates at
an appropriate frequency when the UFS clocks are scaled up or down,
improving performance and maintaining stability for crypto operations.

For scale_up operation ensure to pass ~round_ceil (round_floor)
and vice-versa for scale_down operations.

In case of OPP scaling is not supported by ICE, ensure to not prevent
devfreq for UFS, as ICE OPP-table is optional.

Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 291c4344876481461ab958f3048db5405bbead62..dc15d7806c7b677d6890cd4b077cae4f4d5c9a41 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -306,6 +306,15 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
 	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
+				  bool round_ceil)
+{
+	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
+		return qcom_ice_scale_clk(host->ice, target_freq, round_ceil);
+
+	return 0;
+}
+
 static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
 	.keyslot_program	= ufs_qcom_ice_keyslot_program,
 	.keyslot_evict		= ufs_qcom_ice_keyslot_evict,
@@ -340,6 +349,12 @@ static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
 {
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
+				  bool round_ceil)
+{
+	return 0;
+}
+
 #endif
 
 static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
@@ -1946,6 +1961,12 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
 			return err;
 		}
 
+		err = ufs_qcom_ice_scale_clk(host, target_freq, !scale_up);
+		if (err && err != -EOPNOTSUPP) {
+			ufshcd_uic_hibern8_exit(hba);
+			return err;
+		}
+
 		ufs_qcom_icc_update_bw(host);
 		ufshcd_uic_hibern8_exit(hba);
 	}

-- 
2.34.1

