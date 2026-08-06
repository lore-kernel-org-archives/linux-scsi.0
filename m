Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BF5282F29
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 16:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786032802; cv=none; b=CG79JzQrnI52lLRD5rsmKS90bUb8fn7/99jp5zVsEdNGvj6vlGROsqO5ZOgLQJZvNyKhtesVXfFFNrCLbj3lY07UuN4ItNdNOSiANk5qV9jjHMcLF6uvSpxzDGLGN96hNEdG/cwCPbD3u0gUsy/NXh0utG1mdY05gdTKFn2YAZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786032802; c=relaxed/simple;
	bh=Ao4k8UCAQ63pTsAXW+nwl6jaANXflQZYV4NF+HzDpas=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YmJCW949OpEQzPCivoo3CcUVoujfEbuCSg/iIWSrSHwUL/sysdZJAVbedVHVxEy4ZDL9W3c8GyMknAlg+4T+cET4DKdMHX/PmuoYfa9TLNVYrP4Zkpk7qJUG1woCzFUozwnaaDawZSwkU9Rfzjla+8O+ZRZ27G+v2uJ9Tb5X4hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gB/OLAD8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ECz3tHyW; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gB/OLAD8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ECz3tHyW"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676EmPxm1553348
	for <linux-scsi@vger.kernel.org>; Thu, 6 Aug 2026 16:13:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Tx+tU+JavHm
	9jlJKkOPRaMWM/yiGuddWBQeSbrpsom8=; b=gB/OLAD8jCO7oDNFB1DvjJBwl7K
	6mwSy9f9tI8GsZeBzOko+RXYNLzeXRHylhpUBjGU/ziir5WXfhkyJfoQM0AqoCXl
	L0cNBsN0u+03ArxdXD00QGiBUjEMKUb5Lzl0bNGwRQJF9Hb5RDC22Y/Buu8yRTJL
	Jg4BUEU78jUwfX6W/pN/MxV+1nlWdKKMtQbeJfizRTQp65lbDOYUhuEZpvhFsEEN
	t1w/v0Lq4P+1z/3h7PrNCDsrpfQNn/EbME8FpdU/mKuxTJF9JerZ62BycFYetUoZ
	uMK8FYGcAooTpMKzNuWMn7YA6fwFV6hLRPjecTQkBhYXBCdvMSBQL+Zc8lg==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvv5b0mh9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2026 16:13:19 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbb467e56aaso2572228a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2026 09:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786032799; x=1786637599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tx+tU+JavHm9jlJKkOPRaMWM/yiGuddWBQeSbrpsom8=;
        b=ECz3tHyWiwYwDEjasSuGGxIIwtRRtxN//y3FgrhzSMvn85R4tPfjXDcHptiwcuU5XB
         lDOlbmULcMBMHKXoz2JU9PFgUrHnlRmX5yhoZpo0v4irSV6cADpqGTAlmwSMe/qF+hti
         H806E9VtA0yK5eWrnZYO0F0cJEuCX1vN4UiKvKQOeKjQ9koNPBnxcJcJmSY8qf1HK121
         hJfr8nFFfSHbUbbgphCzDp7NafM+VzaOWVv5cilJ96V/i4kwxzT+jMLbdT1fwj9fT8Ee
         y0FxvzQQqoRR3CiNa3d4tEiUCXY/WOpA2OGic+RwJbMspYXk1kQrNqU2VRpPU8jDH51J
         acgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786032799; x=1786637599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tx+tU+JavHm9jlJKkOPRaMWM/yiGuddWBQeSbrpsom8=;
        b=BEXbfGgLNUszRE4ieP0IEiVKxhD9/VZBJY5oIvqJdiKnqU0hkDSpe/zMpNZuM8Ixwx
         DgyEDwvUDOtJLsd5eql9uhzz5hsfpS+yKmbr+tNBdhAZdexYJn7TT4gJWo0IdPgtXRHf
         HQGfyDjRrqgf/U7W5nwGk7Yeaa8OCCnjjiQpVj9djv5NRBuu54rpqd9mCIw9I89g6uBI
         bpgGutir6Eg1gLec5q8ZQfooceawUQ+bdFJj/cYW9VACPBzHeb5QSQ4sG3Xn3R5iH3xn
         j7I/WfbfSTv3s7BTs7gy1l9EYMF7UVTltJ3CZhm6qnIYo7WIATlxSwcKTSlzT2G1GhJw
         1S6g==
X-Forwarded-Encrypted: i=1; AHgh+RoOIDhoNTk+IB9YwskgQgsYRNmkzadgjAZB7duGYZkYakN/8LnYQfew64db58G9thL5YZbOtC1tUDCi@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz3+8lqLdV2PSKwXHlZ4bpetvcY8KjLwsXa5frgYrg98wRcSCa
	zG57Q58Rev8lDPwyp9B01LTeAVdTU5cqvDkORmGIDOgXr7X2M69rZGjcbMd9col11NhAtdEg1wM
	g8Gmw2dEqdsd4Z3YmyF9OyYK5m8kD14x4ePjCOobMi8vfDGYdh1vHREyM1StudMQt
X-Gm-Gg: AR+sD13elbGpT3gDKLlR+0p1o2BUlwVWL2dGdEFDLeBW2RBE+JZhLFdzUNTbSFbUeMK
	FdDa+Hm5FYDjN1doqI1bT+1XzBA8pjwhinhq/Pm/bey5ms8UDWQkW9rhts2H7sTQGw7LCwvyI7H
	VBxpp89bJL3SpdCGCyshFt+O7fOhm3scQQ5LxqjB6fg1eK3Zj58SpG+svtD/j2F5yExcTH3kpCF
	fdmnQnoUw1XFSXdZtmEctYytpOaBq3dLfKAyk6keNXgs8WbnZOuZf82U8V7kOzd5O/Ye4PZbUow
	PNkZw6Cn4n9c2ffEwZz3XTqToWuECj+mEH1xr7lY5CkdY9ZF+iaYhNbcZ3D14jMPB8ttchIFwPa
	1w1rnQjjG3qprCAraXeOLRFkGkKhtDOfK
X-Received: by 2002:a05:6a20:72a4:b0:3bf:9142:ba3a with SMTP id adf61e73a8af0-3cb85ef7460mr18750435637.26.1786032798834;
        Thu, 06 Aug 2026 09:13:18 -0700 (PDT)
X-Received: by 2002:a05:6a20:72a4:b0:3bf:9142:ba3a with SMTP id adf61e73a8af0-3cb85ef7460mr18750338637.26.1786032798360;
        Thu, 06 Aug 2026 09:13:18 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315863b761asm43074546eec.1.2026.08.06.09.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:13:17 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, andersson@kernel.org,
        dmitry.baryshkov@oss.qualcomm.com, abel.vesa@oss.qualcomm.com,
        luca.weiss@fairphone.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH v6 1/2] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add Hawi UFS PHY compatible
Date: Thu,  6 Aug 2026 21:43:00 +0530
Message-Id: <20260806161301.1010876-2-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806161301.1010876-1-palash.kambar@oss.qualcomm.com>
References: <20260806161301.1010876-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDEyNiBTYWx0ZWRfX2+1x6JajbD6n
 Jwpz7slKMorB95cfcxKCYNKlIUnoJevDwwZ4YZEwzA6oy6gg+pLCYjzPipxcGxZSqascnTUdQxg
 5fvEdz47GdElL7SLgSWEIJo8FlM3LOKBxcFVvxGlVK1tFeeXVEqDCe3iKOqRztQ9TwoxHN+DCAS
 E7HMDuv46krzWcZol7pj6A40WEqyPH45sRkb2py45RpsGV/xsp9ReISP7EuAY9dGYnPbb5c0z58
 2QgsQQB7oe9U8uMHXj5pVpPI2M5rDapEUb+OJ064zIGYHBT3sQY7AmjEtGD0dze1H8aL+ktYEDg
 GRp5B3MGbfrdqiI0thxYmj03tDVFLAa6hdwnybxpXFL47o7aZbGG7VVEVOTHKadzkSZnnotzbgV
 +DcdyK/xdyVZoeo2zEqKcuku0JfE1kBQuHK6b7RZcX0mNUwu0dyFFTAxCcfn0P8kmTKIJhbvSR1
 RIR+F8qNxsnzu6Bnjhg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDEyNiBTYWx0ZWRfXximrV0JN6vZ2
 vNWZzm22fxITafXqCk7caur66Suh8RkPgqnfD2oRicdqOeh2vQgCTXS3dmKhK0Iqhn2Sn8nXHDF
 nK4QebqnoVrQXfprSnurF2j5PxplhFM=
X-Proofpoint-GUID: MD-DYn5R4HhQn58aIgoeqHUe4na4Y98F
X-Authority-Analysis: v=2.4 cv=W4gIkxWk c=1 sm=1 tr=0 ts=6a74b29f cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=MMZtLZuhhDi3SW52_uAA:9 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-ORIG-GUID: MD-DYn5R4HhQn58aIgoeqHUe4na4Y98F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-06_01,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 impostorscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060126

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

Document QMP UFS PHY compatible for Hawi SoC.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 .../devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml      | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index b2c5c9a375a3..4efe40c0dc97 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -38,6 +38,7 @@ properties:
               - qcom,kaanapali-qmp-ufs-phy
           - const: qcom,sm8750-qmp-ufs-phy
       - enum:
+          - qcom,hawi-qmp-ufs-phy
           - qcom,milos-qmp-ufs-phy
           - qcom,msm8996-qmp-ufs-phy
           - qcom,msm8998-qmp-ufs-phy
@@ -108,6 +109,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,hawi-qmp-ufs-phy
               - qcom,milos-qmp-ufs-phy
               - qcom,msm8998-qmp-ufs-phy
               - qcom,sa8775p-qmp-ufs-phy
-- 
2.34.1

