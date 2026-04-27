Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FFA25DB0D
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 01:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777253500; cv=none; b=QkABpp0ZZvDnnh1qXYPAQGXsuuZCMRG27n780CpDxN2OF1aScOZK+kQq0uyIraV3LbDbdV4Kt76P1hYXngZXFivQNRKRJNr+hfipxknQ1lYQ+/biSwqwJJjZz8ZGctmJKAwqXg3njz8XutjZOkqMV5OGNQCiT8uS+H4msZF80aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777253500; c=relaxed/simple;
	bh=GMmcn+CVvliit5mGd6Y0/iKeyYddLwRd3s2aVazKWbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OF+6psmov61/cgYHDTb0hr8078LJSdO2c9G8BeBHnL6Wtzxjvr3bjaSHdUxu+tf8P2PeICsAQPhJWOawgerpctQCMr8a13UfAdSQSvGCwX6nlILcSWyWc7BEvN/jWp2d+5nyQxIZG9Y5dfdL9WsGZHrXhbFDv0bvSg4N6RQcsko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lYQwuzsl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OJhVawof; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lYQwuzsl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OJhVawof"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63QKdNDf2138382
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 01:31:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=11+wJCVGbqH
	Fg8+Qau8Gh/1gOG6th05BId0D3j7ZQ8g=; b=lYQwuzslmgwiNHpn7lMKv5N/KwQ
	xRudwaUKa2kiEqtaEQ/leO7Bvrs/irnoMBCJZea8EfAgxUR4S64Gyq4/S14PdOsc
	ftA0EdC52vZ4qhr3qWBtJeuWkkZQQNGx60farJf4+kk7JurlVrVh506s+WU5q1xD
	dkpuJByIOBFNfcbyhX5F/LtMY7Iz4/SvEEQYzKtQbkYtEfAGgylvK93toRiyclBG
	11COuDIAknIJAuv6QfwbaoYycUD6J2JHsllu6XkjsuDV9aAgoPOh+btgHlk4dhrx
	FCjMI6xl0OUtM+u9i2BSeUqlWygH32+i8b2Et8if6WnILLCncqdpgJyrAeA==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4drp07kx1d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 01:31:38 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2bdd327d970so6117135eec.1
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2026 18:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777253497; x=1777858297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=11+wJCVGbqHFg8+Qau8Gh/1gOG6th05BId0D3j7ZQ8g=;
        b=OJhVawofm/S4BMWClAc5MsAN3CfqK+wecIhKkZnWFNQWnaVy2X0FMpKGpakGASUBiJ
         ykw1tD7p6Hu6zSUudWmfuyTci/CnkkOz5XyQgh/tEOX/LA2pA6hMowaYPx0yeqzPCKVF
         v2tefHOtZzzcmxTPmweu6zsLl318D9D87NAPTBfhli40ugZ1A3sgA9h7Aoj+AGypNtCt
         b0Zm64DOOQ5lRw0ccPq6j8UZmsv0D+/a6Wn42uTMnBPYCjIxQmh/pmOYitZC2GCVFA0Y
         ah3sFaRsNQprBubXVwbdYUUB61ddwO1p31ytET7SrPNc+Xwm8nrA2KRTPUPYjtrIuKZt
         /j9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777253497; x=1777858297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=11+wJCVGbqHFg8+Qau8Gh/1gOG6th05BId0D3j7ZQ8g=;
        b=LUqeKPra3ZYuPe2q/11bPpI88kHcN0RTGm5sQvMivRQtbwPjaB4Put4kOrQMpP7KZy
         q553EXxQzaNNTaPg43nuGc+4DqB3RoAw394b3X6k1IZrGBO/QDI5PQPUV2pPXdQ3gD1a
         5J/69n+QIR6XSAudJTF7TWuh/iBV8bGJd5z8+cMD8QhDu7kWG+VkF81r4EJSE4ELzsYB
         YbRYVpwc97grIjB/SukuE2wv+Awq1lMILFJoCMCa9id7oo+9FDcIpxSNWpW2r/ugp++3
         xeZkM/7Mddg0IqXJCYPwAYNXDY8r8/7rpIMKAcPGFmAv1ZPZ8J6eJNX4NQX0hGZmag2V
         zuqw==
X-Forwarded-Encrypted: i=1; AFNElJ8mIDWTIyKEwlJckxGhQOL7rL1OQnFI8KNL797w85ZVW/PsJzm+77/ZR5yQ0eaaoQsb8xMKAGkjvzf7@vger.kernel.org
X-Gm-Message-State: AOJu0YzS7aMjFPP1K0mRIV3dJjWX7ISYuee+OZjSQh9Y5ZiNzVmYhl9z
	wPEFfm1EOlhXbrTpKIe6RzunCeRS0bvFZdhzOQ/vkXWEKGR44DtpK/oY37UJfwNOvJ8Lu/jpxEA
	q3eVjBtYuwbiU8PRI+EwYIstn+BaITiGZaTKFoQTQ8E1L58cxcCmqLIzFH+ifiNAk
X-Gm-Gg: AeBDiesRsPAySeibdkpNJYeSQMOGrTeJKwirrYg2O4U3Qr5O2s4Ql3YQ/paNlAVXgvj
	laUvrWcTxUwWO1d7HPi+UlljsXVpQ8cFreNIKdp1YIhELKI+PKeuGz06IcW6rRuVU8C05ocf5e4
	KxSFup1PzMlxU6p5YzDuCZIWBUpMk/SFnNJATEacoSfIPYJSY4nHbck1o6VBDmugoMG/MlU4eWU
	0VHeY74alZ97wcQmEBTowr0va+eh/mjZeN3Ue4WzSSpyXHLu7LXC845u8IkCmGZwEh/SMebAThb
	TaOVJwUIfkjS1MzYezfAoLbMF2af73uboUXAKpaHbeDXCF6qBRw/Rzc4v/DkNlM/0YQnfbYhtXt
	6WJ/mid2NBaDHOVWSeFGIecGKWo2sjxEZHh0ElHAkVZ2VZvh0VzxU/qHJCDSurk7cleTzit3Bjn
	wtnGwWWRvNWqtElkLG
X-Received: by 2002:a05:7300:5711:b0:2c5:c532:1fe1 with SMTP id 5a478bee46e88-2e42c15ceacmr18576870eec.3.1777253497367;
        Sun, 26 Apr 2026 18:31:37 -0700 (PDT)
X-Received: by 2002:a05:7300:5711:b0:2c5:c532:1fe1 with SMTP id 5a478bee46e88-2e42c15ceacmr18576852eec.3.1777253496801;
        Sun, 26 Apr 2026 18:31:36 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e53a4a8018sm52749042eec.8.2026.04.26.18.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 18:31:36 -0700 (PDT)
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
        Shawn Guo <shengchao.guo@oss.qualcomm.com>
Subject: [PATCH v2 2/2] scsi: ufs: dt-bindings: Add compatible for SA8797P UFS Host Controller
Date: Mon, 27 Apr 2026 09:31:15 +0800
Message-ID: <20260427013115.231731-3-shengchao.guo@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=K8QS2SWI c=1 sm=1 tr=0 ts=69eebc7a cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=ld1VxiVWUvbaCiqNsT4A:9 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: WwBz9g2P-DtLJhXULB-EUNpmHWLcZL4W
X-Proofpoint-GUID: WwBz9g2P-DtLJhXULB-EUNpmHWLcZL4W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDAxNCBTYWx0ZWRfX7etT7oN+eCr5
 5wRj5RFw5/zvu35TSpBtq4GjEFq5uF2BpHB4UL2A4DlMaO4ztsoMOB0ra3IdNnNLAS13Eoq+LDu
 PLKCBMVPi49ehKrbNWeBXjW2mw6xjW6gzkP7tGrGZRspHMyGQjf5KhD0H0TDaIiUIEpbd5/l/Yk
 OLl7DcdCsOOMleQfsFojpDlC8JDF1hwCyBy746crrRg2Vo/bR5F+t4shy9/xeTDFsTrNswRPyYP
 8efIrLIipB6+CtupsxvT5QFkrEJTivUse7IzPIKj5w5W+F2H9AP14KuX6+eOBOa7eH7mxJETIoH
 vvRHy6BSJ4clrFX6jKUlVFI34VZT2UrCMvepkExqwaTwMUuybyt5g3cW3r0z6sBzcmvDLRAVDaO
 v5k0rj8Z24W20tODBsMMMy209CwQg/IdSSncW5y4ggq5RyXGTBPQ6R2igUdQx1EPg/Z89VQReFq
 gH/3qnV8quCd9+LyQsA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-26_07,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604270014

From: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>

SA8797P is the automotive variant of the Nord SoC. Like SA8255P, its
platform firmware implements an SCMI server that manages UFS resources
such as the PHY, clocks, regulators and resets via the SCMI power
protocol. As a result, the OS-visible DT only describes the controller's
MMIO, interrupt, IOMMU and power-domain interfaces, making SA8255P the
appropriate fallback compatible.

Signed-off-by: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
---
 .../devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml         | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
index 75fae9f1eba7..db165a235cb6 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
@@ -11,7 +11,11 @@ maintainers:
 
 properties:
   compatible:
-    const: qcom,sa8255p-ufshc
+    oneOf:
+      - const: qcom,sa8255p-ufshc
+      - items:
+          - const: qcom,sa8797p-ufshc
+          - const: qcom,sa8255p-ufshc
 
   reg:
     maxItems: 1
-- 
2.43.0

