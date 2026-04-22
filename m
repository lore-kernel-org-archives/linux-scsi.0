Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F893CCFA0
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 11:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776858599; cv=none; b=FF9pU0kGcR8QoUp3yI8VGr02llOT0iE/xlV6FQKthBkUWQmKRPCerZRZVtmAsDEMpM6O2Ntk6A4LUsZr7Z7QiznG9JRSph3eg8+NQlfTHQ70sD7NpxRy9ur/MMJmEPRO0zK25lD6Ec7C1DwF/4tZRJhCfC69kTA62zmymHELA/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776858599; c=relaxed/simple;
	bh=R5g1AEpsUhkpB+vKfkU4doSkGb3/fFyv8wBJh7RYZgQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aoJm0pZjJbOGSqwEaEod/bdQ4Rh1gHuGGofkls+XfNikfQ2zQXKnc7rGpZ6WjE5Yv27PgrRij0x47CB6gSB0P/vEEQc9gbyyCVV6BPUIfB4g+6biWRdsum3yBV3YSlOAAd+3PEFuXgJW6UNIRtfWAATaU3mHhSz92lLZv9ZyUoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=poM3JtLe; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Jsek5mg0; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="poM3JtLe";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Jsek5mg0"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63M99ECn1443728
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 11:49:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=HzJc5YwAYvE
	SGw264S07BfCAoWa2ckeWSsi2YS5Hpig=; b=poM3JtLeX2KDx6uo11rIiVHUvJs
	teANa9uGM2aVnGJE6aRhieFdAOAsQZY83YRl/tMQL39T9R+jBhh5h1lfi+W5wwS2
	P38v7aFuKZR7zm9rujc5bWNGMl44KeCMh5qRIWwyF+PzjBge+k6sC2COEh/ozRBw
	d8JbFliQZk3CIeJkblC2UR48NJQiDdeilvw7bXTmKGDDfbrTQdbQPsqn8S/mfByQ
	tuOrGLxykbGfCEI1qLp0BhDawZOfZMpEDR2ZHkaduMdA18vGDm8HYU4zFr/ezUsz
	qwbH/P2o5tV6cROzWrJJoLu/dPHIvcLAE/+3pH4vg0yC19nDbKkvVaRvw1g==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dpenfu4fu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 11:49:55 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b2e91add2aso46251275ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 04:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776858594; x=1777463394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HzJc5YwAYvESGw264S07BfCAoWa2ckeWSsi2YS5Hpig=;
        b=Jsek5mg0dLqMm7zgPkwWhT308/7IxiPjGc/eoVVZ15Z2C+gfxNkNyZvvNfIraDXd9v
         5s1Nr0lK7ZmoVA9UMc2VFttrGQJXRSni86hegspLsiLl6VAXy3zev3NCgml4BW4gNztd
         1WfUrwplgEM6orSFBC1Q6H2f6f32ZdwMQ9Pkh110LMUxKt+UMNscUG2rYpYGfh6NZWSG
         duTMhoTycXwxFJdl7X52YliJuTFSa3ATJfI2Z1QenGcJK3z46cio0EF3H80P2nKEZv1D
         SvZVDa2eoEEdl8MwoqwlAjrU2Jd6E8cNwGTtJwOxc601pvo74PQ44LM690i7nIVGmPv7
         0V6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776858594; x=1777463394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HzJc5YwAYvESGw264S07BfCAoWa2ckeWSsi2YS5Hpig=;
        b=Cr1KwC9bFVxuDr3sugty1uyQiJ/jsSAThCpOr3mTL94t4dBHjz/R3i16eENTmlNucc
         l9CxSHJl9qRNT8DZnZfAVE/NTtaYSkpyNw9NA+h6vVcDbNoTQAWoOsfhKBkIquGfikb3
         PtCFSn/cT7IjPdO+eeylosXw6Qyn/GHns8n+oFqydS5DhR4jRMkbtfTokVS/lqG+dfIj
         MF3awTgtcn9YqHINsStCHwnjUTYJgvsEcF9jdr4b76ETlbIpKHYewq3IhUlUkkE8V8Fp
         /8eaR07ZkxgjK0q2V+86sFCQDvPEZ5QNZ/ef4yIK5km8WdfvbbLrbKCnzgAPqnfE8tK7
         Tzng==
X-Forwarded-Encrypted: i=1; AFNElJ/0W+/LanMCdtqMPgFOZ6oClaQHxXExstXvfAMtlA865v7PpcU0cIxu2qbgYQZZ8OlCkfmJb5gsymQX@vger.kernel.org
X-Gm-Message-State: AOJu0YykNhyfl5WKwZ5KL3/llx/7/Qneu4dQsDTQUkyNJRZPWlUXTayY
	XBh9KpVX4tsPIF/U5r6/MeJVxupqdrwK62jF85U0QJ0DA5XViL7BbJZw2phFrIO8Q7eaxz1WpO5
	Tzxn/EG42802i2HcTLwxkJOLw4zcm/ZRsAY9Vfgvr+4zsyRiNUrWYUIZ8w69d7trc
X-Gm-Gg: AeBDieuVsO7lEyx49e2klYyoDsXwQvNNkZSE2pTnZp4HtOAxHfBdgWpM7ZdyNLFy1Yt
	7MVsoXpd+r83yqbcCnv/JjOc79GgWgbtn1mv28HKoKY62M8c6mrLH2BBRFTDAcXDzjPn9nHyv6F
	BGUy7bZgSzgCWjYHtM7Fs2h6wT30C4yRax0AIXuxhL+UEv5Lho451t85a2G7mHILmrfe4tk8JSy
	MWmAYdzLYEYSfwj6GKboU2S+OCDwucXUg37mw/DWlwXSa1mnSxAfH2RuXdIYnV9ai6mB6D9J9yv
	41/MiYn7Bf3SoeINkJryB04zco2Z6UwCWziCSWDeIiTYh4aFBNHB8uA7X95z8aLkYPOi/4y7hzZ
	WjsErvl4aa77KcmcHAAYyXEkwxnVVgPr/mT53yCFUAHzlZCkQC6q20Ug96RaQgTip
X-Received: by 2002:a17:902:d50b:b0:2b4:6470:760d with SMTP id d9443c01a7336-2b5f9e8e436mr230479285ad.14.1776858594516;
        Wed, 22 Apr 2026 04:49:54 -0700 (PDT)
X-Received: by 2002:a17:902:d50b:b0:2b4:6470:760d with SMTP id d9443c01a7336-2b5f9e8e436mr230478865ad.14.1776858594022;
        Wed, 22 Apr 2026 04:49:54 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa34ea7sm163047125ad.34.2026.04.22.04.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 04:49:53 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.lin@rock-chips.com,
        bvanassche@acm.org, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V5 1/2] ufs: core: Configure only active lanes during link
Date: Wed, 22 Apr 2026 17:19:38 +0530
Message-Id: <20260422114939.2901925-2-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260422114939.2901925-1-palash.kambar@oss.qualcomm.com>
References: <20260422114939.2901925-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: ftmNoHfYDgDyECCWtUxXrCIhDBhUwV3k
X-Authority-Analysis: v=2.4 cv=YJuvDxGx c=1 sm=1 tr=0 ts=69e8b5e3 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=Z8YMyZzXpU5RQDwMThsA:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDExMyBTYWx0ZWRfX6em8hnSBINIk
 kDrcMFMNY0APcAZhWwtgj8E3sAAeVtx0XadV8jsv3QC/M7Bnc7eSqFDb77yiRc8AQCGng9B5hbH
 dCqXY8AdesL5BiOhvxMAfE9n0IrmqrpEDlHjnQHEXrYbaHsEwyRfvfAY4ClOsfFjW5CATEI3pf6
 8yWy6Y6/c1FcwgKLgSCtWefBwC3chbvIR6OGktiTZMMvPGhDZ92jDdr5tTRbYzGlrNw+1TCv7WE
 17IP/aIxUfAncqgjuJPvHVnLK4OhTIk2n2Mt7hFb87ymVHkVC+ecGaaHntP0MosbrQs4WbP0tUH
 by+DB7NAB5qLQ3vyyjiyOkfv68r5l/i+yG6zkzv65bZETp1xTUkpfMkfoYjW916D6JeWBbnm/EW
 4kP5wES/C05JAj3MoLjIwwxRKaFHWj3KMRyKiNTgy2c7aOW3REjnrAHzosaiG+rANGQhquWjBBv
 +MnMBRH7wNtILufBROA==
X-Proofpoint-ORIG-GUID: ftmNoHfYDgDyECCWtUxXrCIhDBhUwV3k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604220113

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

