Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792662730;
	b=pJG/QSo7sSQoVD0Ls/u13y4wDSDGbQU/Lq/bROxfImfN12dprpA7DkuWy7fkowIdTUxL
	 SS6SyDqtinZeuLxouXjrFiFnS5aKthSxMJZvzaHMcj4Po1r0tPJrcqpnnWwZrzW4gaief
	 77hh0vQiOJ+hLG6i14bNKv8ad3+wmvpEJAvtZSgFX21xc+Davq7kO0OjP2Nq80yThlv4i
	 orgjLHmm3Vs8S47UhhhDofqojFzF78S9Vg1b5NLZnGiX+h4vA8HQy6FotfcMl+c4/3rJP
	 qPOcXXY1BriXvcx0vfCpvA4AY2K7frCuIipzpDrG5aKgrvE8PCp/uHnld+i8WmvcPdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792662730;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=g2TlYvXtYyp8Er721IC1PRai3CL4Jni3K4YQoaDrd38=;
	b=2bXIb1ZuXhm4AubM2fI5/b0zHYigRrvfyjP+MrItO5lv1/29ME5P3IV0wAZ35FNb75+m
	 RmgVQqeXINMDy9otqbX7nAwCHB/Q5gvbCTA44YOTqvrFswzDPTV2LG0itM3P41lj1sQh7
	 koOCwf2ZkmROaDKk8dl278CQ2gHRa2RN/5YtmGhTIRtGT+rTZNVoiyw+QXC4Eav3k1oVa
	 fIx/6p3XsmDFfpD3eW/PDtHCjcZ91uXQHLjm/E7F6bIy+nBgpEyfxH5CKMHXlcGBVgZpe
	 cH+RiLsBtkjGOk8/IDgoC61cMmZZ0ZdFq76p6x+wfdSkLbm74VXG3fRRGPt4CmpxxNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Rfq6P8qn;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="R/vyHk3O";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2ED606A323
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 09:52:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C2ED606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Rfq6P8qn;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=R/vyHk3O
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M9esST3384000
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 09:52:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	g2TlYvXtYyp8Er721IC1PRai3CL4Jni3K4YQoaDrd38=; b=Rfq6P8qn7eTM5IEM
	8ziZrLKUzKDtP1/mhjWh6O6ORDn7ZZLeRd7IOUvMamy9fLP4ZCYLYb9yQaybAOz4
	wo/7c/SJnLdIJqYZLywtqCTgp+ImjqroYW8oZeXwz4t2Q7qDI5gYzt7TCJQZbZuQ
	8T9q63wxiefY34rB4kb/7XBecaeU0h5yBRRpxGMXZkmlKTEjsL4EATvBPMKz8FaN
	Wrx+X02DOHzXMXObZq3oRI9uzIqRsF03RlTAniuRSAo8R7g3qSlptU2MCOcZJAUo
	Eigu3l6SuxoxuRE7+G7KT0DvJjZMOBcjXGC6H+RXduBf2AfsLESUtRFNgo92kr6E
	IS0ShQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93asr0e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 09:52:08 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso3157550eec.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 02:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792662727; x=1793267527; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g2TlYvXtYyp8Er721IC1PRai3CL4Jni3K4YQoaDrd38=;
        b=R/vyHk3O7Rkw0AsdW8nlr16XrdGaBFVQyviunHUkWVa6jdHHL5hKsIb1SgFEGnVpz+
         2uh4zR4S6zFrVOFD5fcqc3qeunBJQ3UtOPNIBwqRAqKB/LAQYt5Kz/njbn6NG6QLlm/E
         JRR1mU30LtbjhK0fhX6Lqbx/pJCqxxcM8hmPyDwBnoChce+FBof2fwxi0b+uIzT/0+og
         N831Y6PDo96dbzM+iUDBuGBmJKi8PdpQqNbU5mxWFlTUb947zeqLGppQRhG50CP/ujf0
         q5ssKSZLYoRXrTGc74da1vQffIZmkPFB/2ul9KzJMDlJeCGCvP2YehEf5/vbfKbW+CcK
         G3Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792662727; x=1793267527;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g2TlYvXtYyp8Er721IC1PRai3CL4Jni3K4YQoaDrd38=;
        b=hVhVIQkHQnbp5HszZqMCzfVV9B5QS8pT1pZciuYfIsfwRGty25ZsGp0IDr80D+vjBE
         nJHwHT0IP3/XVYLqr5Dm0mT3FoNwzQ3Pp38PDlgOw25385xRUjW4Lsx5qk5dJRaYe6eL
         zvAFA7ZaKs5KUZkdqqs73TZq/NwOdUQ+4OwutbP+T0wD2ReIq0E3irOMFaJK7fiJWR79
         zvIjWVoGcnfpj2HXXO+5N6VI22RWAOMQCDcPFAd58dSg3POVQUABWy1wJXgoZodRhcue
         1pnNdqC2802bspwtY0Ss89Il60JTa+CleZeVDXRrW1NbhVR/5jK6LfjRhaUwh5YwBWWw
         13Ig==
X-Forwarded-Encrypted: i=1; AKwUvBy8NhxbT33p1osTIg13ZUQNr1ZhMBioxrYO8OZ1spGNaoDyF61yOqSghkDjMkQRz1aPPns0IIFI3cYh@vger.kernel.org
X-Gm-Message-State: AFq9FYJjq0cr48PFQjAip9DRnxRBuGapcEcpaYplMJWY+HUzk27Ilaik
	jVmxbPul/ozPdj40tDi1/EyQ4sEyxaNon5F111t3KH0rF6PMQBv6/mUxuNxA4l/j43a+uFRRUuP
	HoFPetBceatY7L8zKZYUopU3ulflJBjBnosDoHuOb4o0UIc/ziopUI6evj9J1CGv7
X-Gm-Gg: AYBFou1TNCD5V1UEkMin+dVWb+eFyFeVv6JbUXAeY14zmEo9AxmLlQ4OVZbmx1/D6Qe
	LdoUdEaHk/gjcXFLCBYlNJZy/6EMs26U19kQYN8rRZEl7jjpT2uZoaACLzd8ZvwMn7WUTIdFP0F
	DhLMSp51hr2ygWg3h24sCoxeht5RnNnrN+h07/Rz8nQHvMGkuwOQG0dAK4bS+RR37+/jj49CNtS
	GUacmHhxwn5cRjITdJR/fW+sci/z/+YSAXEDtLVJtu3YOrX7xdduMleXAFGmwhHuPAxAPqEFNon
	65nnQkychU6ar7rfyRGw/PeSNDQifEF43PMMDauF6n1fI8w2c86Ex3SHHgosVC1KRbnU8NLtdvj
	9tq86FWwFeQmm0nfFCC9QVlzaZDWwWBet
X-Received: by 2002:a05:7301:da02:b0:358:45f5:daf with SMTP id 5a478bee46e88-3674e35502cmr5978256eec.29.1792662727311;
        Thu, 22 Oct 2026 02:52:07 -0700 (PDT)
X-Received: by 2002:a05:7301:da02:b0:358:45f5:daf with SMTP id 5a478bee46e88-3674e35502cmr5978228eec.29.1792662726780;
        Thu, 22 Oct 2026 02:52:06 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3673e153519sm15742170eec.3.2026.10.22.02.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 02:52:06 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Thu, 22 Oct 2026 15:21:50 +0530
Subject: [PATCH 1/3] mmc: sdhci-msm: Enable ICE before enabling crypto
 support
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261022-qcom_ice_pm_enable-v1-1-f7a84086c651@oss.qualcomm.com>
References: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
In-Reply-To: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
To: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDAzOSBTYWx0ZWRfXzkhibzFeN1HK
 MfgJimCUp3tsRKkdytZmqw7lGbfRfWDvQAdtaP767u1vojcxyLwpqDRkcJUwXSTfp6FWvZNoDo0
 VVBNNvUS1mH8ImLv8w0pqfVEo/EbeYI/rDcI1VpuOFUI7799RvqIyeFKUUbovvJmKQ3E4C2BShJ
 HRsMJYCSgtsKtekaXvMQjLFE6jYDEDRr8pgbKspFppm0IRStTj8oEoYn+aXjwp40Z54U2nbsDJO
 YQKuClRNkIrqIR8Uhi5gYrCmJ18Qi9pn+bwhwBr2q01IG9uYBBzapz3iTmM23eq9tbJpX/VRyKe
 syrF+Z0IM7U7XIZ3ewS6hutRjclVbh/9TSajFswixIth7h3j/ngLD9lKL+1uTNF6bla6l0X8r3U
 7nz+naZ2eKvkpPt5LwbSu/AIUZlXx6EqyP8i1nxhqNQd6t2wFKHssWY6NrmMhHz38RvudpxjmPy
 jTkP/UBvu4XqFqRfCAA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDAzOSBTYWx0ZWRfXxusbdGxHF1md
 dxfc20XBJJkYIsuR3kKna9enmCrzrrM+tmXje2FpzCf/GjhdHaM4sOjABnsB61oO1qiXxIAbvsf
 v4Uyi5A6hzkmMDCrG6VsX+SMdZgLK10=
X-Authority-Analysis: v=2.4 cv=QPn91QLL c=1 sm=1 tr=0 ts=6ad9dcc8 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=jhS48lKipzocA6WHYXAA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-GUID: LrXBevPpmmTISnxpR83vOV3FcLjDGdLN
X-Proofpoint-ORIG-GUID: LrXBevPpmmTISnxpR83vOV3FcLjDGdLN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610220039

sdhci-msm currently exposes MMC crypto profile and sets MMC_CAP2_CRYPTO
before enabling ICE. This leaves a window where blk-crypto can issue
keyslot programming calls before sdhci-msm has explicitly enabled ICE.

This works today because ICE clocks remain enabled after ICE probe, but
the storage consumer should not rely on that implicit clock state. Once
ICE supports runtime PM and clocks are suspended after probe, accessing
ICE registers before qcom_ice_enable() call can fail due to unclocked
register access.

Enable ICE during the sdhci-msm crypto early init path which ensures ICE
is ready before blk-crypto can issue key programming calls.

Remove ICE enable call from CQE path, since ICE is now enabled
during SDHCI crypto initialization only.

Fixes: c7eed31e235c ("mmc: sdhci-msm: Switch to the new ICE API")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 drivers/mmc/host/sdhci-msm.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index aecd425bf095..85065cfae132 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1928,6 +1928,12 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 
 	msm_host->ice = ice;
 
+	err = qcom_ice_enable(msm_host->ice);
+	if (err) {
+		dev_err(dev, "%s: failed to enable ICE: %d\n", __func__, err);
+		return err;
+	}
+
 	/* Initialize the blk_crypto_profile */
 
 	caps.reg_val = cpu_to_le32(cqhci_readl(cq_host, CQHCI_CCAP));
@@ -1963,12 +1969,6 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 	return 0;
 }
 
-static void sdhci_msm_ice_enable(struct sdhci_msm_host *msm_host)
-{
-	if (msm_host->mmc->caps2 & MMC_CAP2_CRYPTO)
-		qcom_ice_enable(msm_host->ice);
-}
-
 static int sdhci_msm_ice_resume(struct sdhci_msm_host *msm_host)
 {
 	if (msm_host->mmc->caps2 & MMC_CAP2_CRYPTO)
@@ -2141,10 +2141,6 @@ static inline int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 	return 0;
 }
 
-static inline void sdhci_msm_ice_enable(struct sdhci_msm_host *msm_host)
-{
-}
-
 static inline int
 sdhci_msm_ice_resume(struct sdhci_msm_host *msm_host)
 {
@@ -2182,12 +2178,7 @@ static u32 sdhci_msm_cqe_irq(struct sdhci_host *host, u32 intmask)
 
 static void sdhci_msm_cqe_enable(struct mmc_host *mmc)
 {
-	struct sdhci_host *host = mmc_priv(mmc);
-	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
-
 	sdhci_cqe_enable(mmc);
-	sdhci_msm_ice_enable(msm_host);
 }
 
 static void sdhci_msm_cqe_disable(struct mmc_host *mmc, bool recovery)

-- 
2.34.1

