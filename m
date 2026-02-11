Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239EB368296
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 09:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770803303; cv=none; b=SgrOFO8DU3xImC0RCfeKcuH7xnsGjQM+u5PJ8quyBfb/fCtvX+qlUK8nGMW3AU4PFeBVAHnMhcwhqiILpYnZRaeaLakkhPDKVE2e1jF7fRkvclfG3v6KAEKFlKggBVwLe0vLHnmSAjkL1w3Uh5EXVBL8A5zWPji7dL3//DE2J8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770803303; c=relaxed/simple;
	bh=dIso6CD1flNYkuHpVKNC3gO9e8xW8V5vdISkstjOSdw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=feW7H+OoKSaQbdBUXDJhFv380gw19OAer0VM8DhETagJSHQy5oCkACAydDvWokxxW+VTAYhFuaBPGOTShLW4HA9rGl9PffkoiDeqvWY26i5HWQ38jn21n7P+5eXPYSskSxgAiSqRnFfz4j9MR0UY7k3pbklsOVBs8q9GiiTA2qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FbhCdtvg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LROTliUn; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FbhCdtvg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LROTliUn"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61B2bXqQ3203772
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 09:48:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7YzoQCJ8EA8SUK5OnoYqyU0eTduA7SL8L55krvl1XL4=; b=FbhCdtvg7aCdl3QO
	2IdL1fkF6AQ4liUxqwS+TLslLhH6FE7x6cdQWOSFPgK2uQPfWn4d0yJpPyVtZfgd
	0q7CgADuDI3Q4C0VGj5/Tk7pxWJQ8UkV2atriZ69vPk9iL3hnAVxAsGptB+1KEt9
	Dr3i+lbDX1OQgffGu3g+77wiLJsGxRo7EcR3cPUoKGJKcfI8SbJa8O0USaKHs2D7
	YI7d53NQ1VduLZ3xhQaaw4mFfvzWH6795osizpkTQbtqLT5SKFM7mOGmgUCZSoYW
	Ze1HNYjejVbJ90JaQPWY/jVyzEHCyAifoXdAmdW++YQ0E+n2J2sjmz9RwruhnSPv
	uy9q5g==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c894g2rnr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 09:48:21 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3545dbb7f14so6416624a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 01:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770803300; x=1771408100; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7YzoQCJ8EA8SUK5OnoYqyU0eTduA7SL8L55krvl1XL4=;
        b=LROTliUnIuD8emm+yo4Pu/Xd0IkdZpzDGpoOfWVQPw8NEC2WbppzfR/oNUN1LL62X2
         9nMWMqiTBHLRsBN13rGtZK2KPK24nsTD2ReTBvB5bzaHfJc+aH3vb9pVblIYIsZuLGpI
         nZtc/vbEloJyRJrWjHN59UTXBDU2ebfe3Gla+MBsTWhAkTYDhdGvgJjH6q2/ntYZFkkR
         fm++SZR77rnb7kgymJw4O0tPICm5qYGe1Cn5NkA2gJD3K+A4THj5Km1NIT5j9LjplUZc
         6J3hFdYvzFUzofiiHtx5nas11qu6kjhElHlmTLDt5JgCP3XvwNYoE5p453GabbqP49SY
         fnNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770803300; x=1771408100;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7YzoQCJ8EA8SUK5OnoYqyU0eTduA7SL8L55krvl1XL4=;
        b=OAWQsKjhBIQiRtgGB/qKv/G1jOIHZ0ONklBsmWkzGaGupZbToHxpsZDqGvwpnVlL1R
         dZAN/AiGM+t8KkhaylaMTTG83MVDiFJC5LLk1wPIxYT4yOaDbwa9SJ1RfhwjLjG/6Ddm
         OoRa5fQneT9clMzs50x/SUBrMfn9L8jITcuwsjkZYsy1F2hoD9rGljWgTrX+RMXhbLRM
         phbudxLlwpuNHgi3CrY1OukfkJPDkxeO78WlDE2/8w/SdMREuvcaR33+8oNYmt2fO/tb
         4DGjz0lwRUSkqVcbw+FQOLQlnG8AUY7IgC5raWnS1oiHc8KvroPXE/4ixUyWZZ9G71T4
         r+YQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4HziYY3bY8KEkees26vL4Z6t+y96dnwXSKB5BSMwEkvZrFxSxmgDEGgvSmdqokRC3gnVrIl5kTDp1@vger.kernel.org
X-Gm-Message-State: AOJu0Yzmi9ifuoE53zVnWkcg8NBQMCGz3bPwCv6xRDP0Eenx2prjCOCp
	U2kA4Pr2hHI5veqnk7zD/23H1a34UzgI5buvthOrHFv+B1vvwCYdl9Ah0ezbVDpqqNPI8jq6NGs
	7w9SjIiiBEsiu1NPcC+UgZoKjiBHAfY5GkyyHsFskBY9hIthemUagXCQmG7j5Q827QAW1sU08
X-Gm-Gg: AZuq6aKl80f4YWecpMAJTH7CqwhXR44C2HiUkrLfmUpBFjIhn7RAD0ms90yvTci65ex
	y6U2iaw8rkzBD59pgzSqWRLye7J+VBJFujYFFRydzWPHz74DIeS5HVdjLr9Xb2oIYCOQR9z+oGC
	u4uikZ4j86x44+NWkX0v/dILWy+PyPAlRMHOphY+azGmUnuQub/lCAuGflQNXWeapZLNEQslBn/
	dAnn1OyIrP1BZmqzRzsQNVYLlgEccKeTRtj3VztT0Xk+lkUgniVGi4d3LvKFLDhddoGH1QCXYy+
	FqwFhpNrAtPqhquRcNdDfjHIPX9pQzEQpMhq8mS+GV+JENge6nR/AfvQOdo/YfVmmI9pQ0fdpr3
	hNjcHsJPwQpvugg/SPoFlr9k9xQ/HAvb13ge2b7F8e5ALf+HC4y/Lnl0YJTc=
X-Received: by 2002:a17:90b:2f0b:b0:354:7be4:a250 with SMTP id 98e67ed59e1d1-3567f7ab2f1mr1563856a91.12.1770803299921;
        Wed, 11 Feb 2026 01:48:19 -0800 (PST)
X-Received: by 2002:a17:90b:2f0b:b0:354:7be4:a250 with SMTP id 98e67ed59e1d1-3567f7ab2f1mr1563830a91.12.1770803299475;
        Wed, 11 Feb 2026 01:48:19 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35662f6b84dsm7526640a91.10.2026.02.11.01.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 01:48:19 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Wed, 11 Feb 2026 15:17:47 +0530
Subject: [PATCH v5 4/4] soc: qcom: ice: Set ICE clk to TURBO on probe
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260211-enable-ufs-ice-clock-scaling-v5-4-221c520a1f2e@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDA3OSBTYWx0ZWRfX7POpSOqG+wP8
 2yjmxTQlqt0ZLQ17rTkJ3bSW9t4y1z3f0ltzsO1PJQSu8QRNNNGx7F1bBHJPZ9hxdDgGbmPGMbT
 11vhgi+V4x8fa5khfYY3RBC/2pOYP4xQNWGP/FA/yu1tQq27wCWcgrNaGOMBEuLpDkPvFomu1Kl
 98qr5qSXkWoYoOebvFBmVT8WAnupQywi5ui066al0ObIK/EmJCC1K95NIQuQSEwmXgFB//F/lST
 jmvF1L7iAfh/aMHobmRKo1/ayfVdlQyccpQczEubzjWnJjgV8m5kiAOBXpUSEMQXBdWNX3s5Aau
 8FBBSZYjEwgdOmOgKCY1BazkFIhMBhnoqQoAmmCVZxF2C1s2XBI6rKoqUgYjOvLqeMHJca+cFjP
 wf2br++9iZYeRSzpdA06Hmg5KzQCZFVuZbI4bvkG0z23rd+VfYcifUuCzTccCtKa0pdr8Ha4Uzl
 c58CKG04wkIE5CfClUg==
X-Authority-Analysis: v=2.4 cv=R64O2NRX c=1 sm=1 tr=0 ts=698c5065 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=u1bwIIJuvd_SIhYoViIA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: amZDHfvaJjAqNN82GeX-z8_Ic23BUQfZ
X-Proofpoint-ORIG-GUID: amZDHfvaJjAqNN82GeX-z8_Ic23BUQfZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_03,2026-02-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602110079

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
index 0bdc64db414a7028653c0f3327988b1554788fcf..3b69b5673ea93fa927e62a7f4b5ae52878d564c8 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -707,6 +707,11 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 			engine->max_freq = rate;
 			dev_pm_opp_put(opp);
 		}
+
+		/* Vote for maximum clock rate for maximum performance */
+		err = dev_pm_opp_set_rate(dev, INT_MAX);
+		if (err)
+			dev_warn(dev, "Failed boosting the ICE clk to TURBO\n");
 	}
 
 	engine->core_clk_freq = clk_get_rate(engine->core_clk);

-- 
2.34.1

