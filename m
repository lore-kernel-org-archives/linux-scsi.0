Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7263E3502B9
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 07:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152361; cv=none; b=Ujpdtx/HWBy4FVxDRpf7qvauUdmEdwv50ET9OzcoRNf5BAM7Rh3INnAQwdKNVVvvaXIlCngtJxFa7t8+gsNy14wEgkQSL6+424aMrZIlHOSNQb1ddE9R2drx/jmIG1cuFHpXCq/UqUSZ3a2GJh1O3iic7uCaQOqG/lIZTo9F+ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152361; c=relaxed/simple;
	bh=H2nsn2ktrgzhdTgsNjVFwrqt4bFjmycDPZWh0G7M/Nc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kGbjKwcKN+2JXGH6oP1nVVX60H/S+WSv272hb3zC682whJNoqPZQ48kZvhR3zoKTK6EtUHhiuhyAUCeZ4zfSmpr9uZVnzMlGc7El+22cIeLOXGpv76HIxP42Z2+vy7a/BUY2YL3pzoe1AEsEhYsUWkIFq9AlrK34CI8sRa+8snA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=d9mEo/18; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HXo/NNn1; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="d9mEo/18";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HXo/NNn1"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N1D22A3649018
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 07:12:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	S1rGHTboQEjoEmpOjXSEJmAbLioeW0D/SeZ6jdLcwJE=; b=d9mEo/18+sa4OA1C
	M4QBoy41opV5kh48sM0cP+qV4REPt7qkpk4hM4KyOJWw/aZqyJBorlITMtiV9SJi
	1l7wKyinpycNtaxE6KZLYj2Ys62+5+RlBRliTf+GSQpXMCCaIJRcBvI0Ewa4Zr5L
	J9t5vgzpgIcc5mLKh1ZWi1ZPAYdcERF4XYMkajm6xbZYaPPrD6F7hwq4VweL5SGc
	8ia32gXhsldHL4fSu+dITQ+x4z9Q/5I4F9wUhTU976PaoL2rg/P1OgQpZRLx0wQP
	DxicEqK7s7UySxXDtcKU+w9aRT0j3GMX/vHhpESRb8PrrBQkYEu0lkDhp8p2m16O
	JzLnoA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4buy4ns616-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 07:12:38 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a79164b686so24847635ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 23:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769152357; x=1769757157; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S1rGHTboQEjoEmpOjXSEJmAbLioeW0D/SeZ6jdLcwJE=;
        b=HXo/NNn1ddv70h4zKHJiaBQm6+L3poN/lpK1PToCHY1X2+2y4bJJVuAw0/saFH+BuE
         +OoyDL7xVwTjRr04wP13SOa0aUH0C9H1Aa7uj59VU5t7PS8GAwKPqZFvzNuMUiwp48Qh
         ivTq6aEVYhyGtKDaD5kBqQq++lnyRKU5spjcD+u+3qszJvf1S+SEzwdh6SWHzyMCHPux
         UFhC/4QaXWhv9dCrWQb8CJdxUpJ9bTIe7TN1PopFBvXnpaoVLR7PKQhICdjKtbhs118c
         l7dJe50Vjo2Ocyp3Gb2R/bUnAZnypvJTjTuS6HHWAlbtVXR9+o+0GH/dlEW4o0/O6T+j
         reWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769152357; x=1769757157;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=S1rGHTboQEjoEmpOjXSEJmAbLioeW0D/SeZ6jdLcwJE=;
        b=czzJkEfcz5/P9V0UdAGjPVrEgVTv5xi5aDMyF+2z8Y+OPNk7qYpXAesuUTivTKMAYO
         6mNYtob5YpiljCwQ3YwTBiKHUu8/SEfsqNE/PNfjyZM6uPIKOV3eLva3z5XA2sLF4XEu
         YeuNypXIF0cO0ChyjzzRJ+JuNIM3pZmK65fnvaLL44oHtYk340mIV5HsbN+2ToRY0QDU
         n8Tjw/ns2xQ0y6slzER0j3Vx4DRCn/BwalQY2yqVFrevUVt56nynFdJicuIWKzKBbUFL
         dMM+DkQxZChSKHHMbyI4JRJjGrm+o2gt9ITKMR8PAAaUmZR0Zl+wA3v/1o1nBP1I9BxH
         Gv5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVZKyrlJX6qu1EtPTLiQmqssS3pRWmrWlMCeKLb14Ie1C+q9HwtbtzU6eqzYGAO/Ym6cNYOUDgxEW0W@vger.kernel.org
X-Gm-Message-State: AOJu0YwdVojqLENHRGF0r1GRsXEmuCG+2SE6NllCwEZP5Xdr1NyflBKE
	B7+iKwFYHfHZYabi1nsvayymDdPu8H31PslTEkHTAja94UegdnfOB6BTJBKGKrruDn1Cj55IXY9
	1BVCj2F4QOKkHnwgWd1GgtGArf7E8cYgk2+7xHCR1T5ApoOz0uYN7Ci4DkeF36g01
X-Gm-Gg: AZuq6aIifu6fgsfLg5CwaADebS+OHzdgZxFBKs8HWkcgBovQj2MrT/c26oR2PGBCl3y
	PLqzUpqgVvXjf7+zNKJJZNrmkMtEAbkwWxo42NAcazwHra7yhcilffakLcVIPx7pxsYps0NxEgW
	gfMoq4JiNy+BvGYRweP42OSZLp8g5E3EnXgn4486B7WGVFgi/e2C/Uv2j5Dn4MzoSgmRY0PYsrC
	iIK8FeBqK3CU58aumXocbmj71hBinj9y5HLyYExxKrW5SFal72CwKP7jmXEMgwoyaIkO7PfIekd
	xX+AUOEgQVW4mmeG1IijpjXUlc2/1z8YJ2gDvWYKQ3qjrW0fOeP89R1MynYkqTRUK519ff9t/Bx
	U2lCaxdaqoF1OOGAJYOzI72JVJ1QUnl7u8sZlz8uzM+lo21w=
X-Received: by 2002:a17:902:ecd1:b0:297:f0a8:e84c with SMTP id d9443c01a7336-2a7fe75c2c5mr17426945ad.52.1769152357542;
        Thu, 22 Jan 2026 23:12:37 -0800 (PST)
X-Received: by 2002:a17:902:ecd1:b0:297:f0a8:e84c with SMTP id d9443c01a7336-2a7fe75c2c5mr17426745ad.52.1769152357067;
        Thu, 22 Jan 2026 23:12:37 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f978e0sm11336775ad.62.2026.01.22.23.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 23:12:36 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 23 Jan 2026 12:42:14 +0530
Subject: [PATCH v3 3/3] soc: qcom: ice: Set ICE clk to TURBO on probe
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-enable-ufs-ice-clock-scaling-v3-3-d0d8532abd98@oss.qualcomm.com>
References: <20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com>
In-Reply-To: <20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-GUID: QCrbijJrAiW-0zSJqqvljCoDntfq-X1v
X-Authority-Analysis: v=2.4 cv=I5lohdgg c=1 sm=1 tr=0 ts=69731f66 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=u1bwIIJuvd_SIhYoViIA:9
 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: QCrbijJrAiW-0zSJqqvljCoDntfq-X1v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA1NCBTYWx0ZWRfX0xeibtpLW9Hm
 yatBAgsdbEeTymQNIhA2tM+KFsr/tD8GkCjGRyf7qa9m49eQKkPCeghawTNII8WLKtvbTmKINpN
 vlCBjnsBeuiLAl08MYTVFCYPx37o1KOVx6dJenSR/VybBClrdv8EZ8+jC10XWnavuqLtSmWXzRL
 tNxwn44s9fYcgGtNKha/yeo8zIWdyPBm9uvineDM9qUEGPRttfA/ahsMuYyVmdjdb3q4fJcAaoq
 y3q39zaRlRAZUJsvb3s9UVLTlwj5O1NZBIHKsW87lREeA2oPYQNGDQN/RAvIM/lmxotzo6hcO7a
 nVEdnU4ykH5uTg8KKKcchlUSRuAPARl74UL3pgUzf+3fwI6DADNrX5XWLdTj4LMWTA/BpOSkbrI
 k/tPIMRtzRoP3gbPBCf7+7tpdQxfYE7HlM48OETGGlABYkoqfXfbq0t58nqgbYaURfFDZ5twvYN
 l3nPo/OGB6AKXImnwoQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_06,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0 phishscore=0
 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601230054

MMC controller lacks a clock scaling mechanism, unlike the UFS
controller. By default, the MMC controller is set to TURBO mode
during probe, but the ICE clock remains at XO frequency,
leading to read/write performance degradation on eMMC.

To address this, set the ICE clock to TURBO during probe to
align it with the controller clock. This ensures consistent
performance and avoids mismatches between the controller
and ICE clock frequencies.

For platforms where ICE is represented as a separate device,
use the OPP framework to vote for TURBO mode, maintaining
proper voltage and power domain constraints.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index ca6a7df7a6827378af1f013c7e62a835d1b80cc5..84ee5813e2d586e8880849c877182d56ca31fd80 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -645,6 +645,11 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 			engine->max_freq = rate;
 			dev_pm_opp_put(opp);
 		}
+
+		/* Vote for maximum clock rate for maximum performance */
+		err = dev_pm_opp_set_rate(dev, INT_MAX);
+		if (err)
+			dev_warn(dev, "Failed boosting the ICE clk to TURBO\n");
 	}
 
 	if (!qcom_ice_check_supported(engine))

-- 
2.34.1

