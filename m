Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96CF253F13
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 01:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777253495; cv=none; b=sviEXwOK2LsAKLTzdqzSk3ju1TsvpRSZkc/JiIyX6FeZNlqxyU0vJbr448VlDltTyPwQb24X4snLkLdXl0GBQD/W5oKX68GJXNy3jYoR9J6nb2/Nw+fzva2w2w3vgCxPuTOgPbgKeMJd5yUfGTYG4/jLRpnVVnGyJdIF61B7NZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777253495; c=relaxed/simple;
	bh=CF/VkGSnULA8sexSCH7XNQhxVz6rJI9RlejZ4QQZ/iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcYknMmgA7mupq7yl5RTzS9MGI9w/mNhJNStQktVepvlFvglVRdTTW+ALBSUia27voXh2l8tb7Tn2YpzEfU+K5SlJoCZUiPHV9io/hl+Vs/ij0MkPlcmI6NvAJkp7DP05TnodR7IAkkbpU6CAj4RePXOw9iJ0NRdntFED1gHsKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jMaqNRru; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KFFIUYzB; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jMaqNRru";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KFFIUYzB"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63Q002nF047771
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 01:31:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=1ykU0Jg/GL/
	a1gB+8RXaCy7Z3yIThudpi0vPFY9q8Ws=; b=jMaqNRrupI8ZS3eDfpZxynfLOIS
	ZGdbChWy+b6f49EHilVgDtQUpMj2NOrtWF/GeqFcFG2loKd4N1unoMr+9COe3M49
	cMnQt0YDBTViTEfTGAUehy/Ws++lo1nyNzzcOYG/L9rzLoPBZghyZ4+sofDSMLiY
	iWHHHZEbfTuUACPzvliL4kd+CXP5i2MWM22eHdupFVCgrh4a1GwmITjVEalpnqcO
	CmPAIMODhX4swyytC2sQuZZXlHDfzz24XJbWkkimSV7AXAA9Gs/ZX1TmxW3/xIZe
	GFsS3Ee9QC3T82MEaq/X/hHUZX2cJM4QK8M3LoYBHm3fNglVLOyZAxqMTQA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4drnkxbxq3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 01:31:33 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2c16233ee11so13346730eec.1
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2026 18:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777253493; x=1777858293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ykU0Jg/GL/a1gB+8RXaCy7Z3yIThudpi0vPFY9q8Ws=;
        b=KFFIUYzBhdvRLUsa6IdNtpKzPVVBs2tFqU9ypGljmiIIJN8rhCkatklnstxpDHR3uE
         804TXOS4SBgRNk9sacbjohlZ4n1a4saf8WgOq5PhNs/rKabR+fU3hbvRi48TSxlu7nQM
         LxLdVPFlBaOqWa3xwgz4lBcMrj9ghsO+6JT9TQ6vSSctrTSLr2gylsFVS6ZosrUEmoaM
         nIv1qUH29PWS2Cdn9h1fqjJ02qnprJeskNxHKPjeQJlNTrz6GbNBBXjHzzL8G9qaLG2G
         UUEflYS4Mdj6W+kyCozB4tMouG/twY67iv5FcQtitl048KKTZvezYYtNA3nFy3iebjKL
         gpnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777253493; x=1777858293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1ykU0Jg/GL/a1gB+8RXaCy7Z3yIThudpi0vPFY9q8Ws=;
        b=KSHVDfnp4FqWB2a6lroAyCHPkNjXb5Wn4bphGDYiFDpSAI98A+KVekkkNTDdD+/8L2
         ikDLJapPkvlzcTdv2nBdAwAbumHfDUs2bJPIGIRmhdjzdRVlz4OGLcfOINN0N4AhJy/s
         OXap497bgZ01B5zuvs+fhPazaSYqkthSHCqflt1pIRCHGuLD79i6jOrP98BIffS1/h4p
         LBIpQkiazTjLF9w+wH9IOYpNVeXZB6MKIT0EmS7btfpkVmRL62V7nXCWarHJf2qqPn4q
         GBuLto0qPIYudI4NBzuVbdlZP9A2e6dwoivcEl7gPYiRfOqmPhz3q4PEVQabVvaHibIM
         VQKA==
X-Forwarded-Encrypted: i=1; AFNElJ/YMYtynXJbeYygkZu5cmwHRvs6O3FchdlhSjsReehBwQR7UP/YMRR7AVSXynWCiSm8qmBWQWbf2Vx6@vger.kernel.org
X-Gm-Message-State: AOJu0YxAFT7uHvlhPyOJMow97/GwAUyaTQ9ukCyw3QNjh7Xc0Ukw5Qoh
	EZaRRrpLG1BCEXs/RJ83O4SaiCCISUKpDK+Brm17jVn1Q4JChytnWcUZMaGkvDCeF8lH88HGSjB
	+9CX072CXkOSnowjmCKRiL6geTNgnDqfEX7yUKrVB+UGh32MZemU95RWBE0U0kHXd
X-Gm-Gg: AeBDievcCUdXFhqF/0g6D0mwxMtgSC495K2nDVvK68O1gBr7gZbFmS4kD/Unc+Xr+DT
	mLvPTEs/iwc0rrns3zDZg/uGSqMlC+s4mA90xVd8F6MNfUChT6TC3sQX0exk3vUY+YWfYgkHGG2
	KAfDSp8ZjoB+TdQ9rGEdxk08/fj9v2xwfQ0DnECuWGihMDz0xmHmMVOcs0a/vTwnblIzJKXCme2
	1DVWmIywpZINjWMSn6GN59brfwQkcOxEbvkqONxkV+I4WvR+6J5V5SaF+Jowp6A0vgNoYtxwZ6p
	Rw579o6vwn86KSO/oydM1IwNkhp4yzGCzTs6/23ja6rFHZCZyEQEA67asV67fKG0q0FqIv127MD
	TcN57xV1ZWQp8MmdYScs9bZc8wtvsuNCm7mwxH8rcBxuv/sSQ/B0H4yz6gDRh6fGx5XqZp/i/u3
	0OO7vOCG/4rlBblmwY
X-Received: by 2002:a05:693c:40c9:b0:2e6:ff79:e344 with SMTP id 5a478bee46e88-2e6ff7a04bemr15279266eec.9.1777253492749;
        Sun, 26 Apr 2026 18:31:32 -0700 (PDT)
X-Received: by 2002:a05:693c:40c9:b0:2e6:ff79:e344 with SMTP id 5a478bee46e88-2e6ff7a04bemr15279255eec.9.1777253492218;
        Sun, 26 Apr 2026 18:31:32 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e53a4a8018sm52749042eec.8.2026.04.26.18.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 18:31:31 -0700 (PDT)
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shengchao.guo@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH v2 1/2] scsi: ufs: dt-bindings: Add compatible for Nord UFS Host Controller
Date: Mon, 27 Apr 2026 09:31:14 +0800
Message-ID: <20260427013115.231731-2-shengchao.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427013115.231731-1-shengchao.guo@oss.qualcomm.com>
References: <20260427013115.231731-1-shengchao.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Rpm-43rG_BYCiksIb80C-orGhGWRlMnq
X-Proofpoint-ORIG-GUID: Rpm-43rG_BYCiksIb80C-orGhGWRlMnq
X-Authority-Analysis: v=2.4 cv=TuPWQjXh c=1 sm=1 tr=0 ts=69eebc75 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=o674AwMwzFixoRFAmicA:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDAxNCBTYWx0ZWRfX6RTPmMmdB3HS
 ylNNV3kujJgsekJUj3aXbi4KftGeFnnwdiWX4LWvZvh+4WQzD7R/Iy1pxhKvAVLerB65BDYiWfC
 mV8XjAVpJ/ZMvddeYUK73eZJmb5qxOG0pQz5sSrgiZ1SIvC+MmLCiaiPLxxqDU86vbDpxFBdtC2
 de0GonBnLsWI962mCz6/TZ+Ici2a6TpQMNBQ75ENZn/heFWEsWSnAbmM2Z7kb9PBQs8ZypEAuf7
 AH19rnfJO8wrtU4iwhMkB3jZBi2G7UYvyER1t2pDVyo5uyxH0NSEwXXkZW4jgXffF8LRF0nUHkM
 LqrI90n4STI9B7cg2QaIij5W+v9dGLhaLByEARB7ktjq87knW51zrpk4GHE1TzkepgkIs8LiKrO
 AmRdiBLvPvKk8EjSgoQif6rX9Z4/HLWuXJvFzbUUTRJRX8wa93rRmiG5r8bKjMuyWlZkDqfcUxF
 2y+ChuuHetl+hhHWt1A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-26_07,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 impostorscore=0 clxscore=1015 suspectscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604270014

Document UFS Host Controller on Qualcomm Nord SoC. Like the Eliza SoC,
Nord has a multi-queue command (MCQ) register range in addition to
the standard one, making both reg entries required.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
index f28641c6e68f..900d93b675cd 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
@@ -17,6 +17,7 @@ select:
         enum:
           - qcom,eliza-ufshc
           - qcom,kaanapali-ufshc
+          - qcom,nord-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
   required:
@@ -28,6 +29,7 @@ properties:
       - enum:
           - qcom,eliza-ufshc
           - qcom,kaanapali-ufshc
+          - qcom,nord-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
       - const: qcom,ufshc
@@ -74,6 +76,7 @@ allOf:
           contains:
             enum:
               - qcom,eliza-ufshc
+              - qcom,nord-ufshc
     then:
       properties:
         reg:
-- 
2.43.0

