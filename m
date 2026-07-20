Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C95F2264A7
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 02:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784514971; cv=none; b=L4Q2JwBWDSfC+HDH7a1Jj9E/CfLwO5NXb8oH0LWJ5h7oRudLBdDF6dR24bEr4qQnftcsmrWs120+kil9JSQ8RaWglOAQdqZv/5N5B9AvZsQUqD/WC4qltOxO1FIR0zfkgKHPJiHnsugpGZ27tn1pbjzR3ULtMtoTHXku3M0F2oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784514971; c=relaxed/simple;
	bh=Zd01etCEfWO+CM27GNY1MbP+KsTaDAZ942YCw2f5G5s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YA70VYx6TzIf35t5hOR+h6eXKAdbgL6mkN7M+altCO5vc6mKliI9D/S7TjAunnajX6VttUmLxC09wevbkXw1o8M8EbOFoGOlPCW6xeyzW1ovs3fjLV2zbpsuj+pG8L1KT2WZq3/CJKO7j9S+v+n12bi1f1AeiqyhYFL0c9UlqwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=b5/Bdg9m; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WLHxN2zU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="b5/Bdg9m";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WLHxN2zU"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66JNt5go410583
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 02:36:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=JvsdJN4ylr02nfEuq1zebFxCT9Im8rIcShf
	jIkDDYYk=; b=b5/Bdg9m4rAvFnX8Hrx8VFWvIycY3QV6CN59DmJIfnt5spSzgeZ
	JMCE0y/HlQ+R1eAmP23djwOoz5XzaS72jDqjK7Un5Sg9nhlIAzKj5oG1kCLmIFbd
	F/NP8enz2ZHcI2w6X1zXc3lCmaafk3BcjugMMMNBw1V8iHIThB3d/8fis8BtsygN
	mdsQdRif6hBowTKxwrS+Rx032o8OWKwwNVo9e+8DTXFdztOJIBsU1dVGUf4XVo92
	RlIaJcuXQgNDEk2l1zYldDyaWwvuLzGyIAb6O3U9mRC7pcaEu9FIoSMS7wj2vDKn
	EaTTpqFnePwP4jeKOnylcu2Cld2FgGW3wcA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2nhm0hx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 02:36:09 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e2237bc43so10159889a91.1
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2026 19:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784514969; x=1785119769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JvsdJN4ylr02nfEuq1zebFxCT9Im8rIcShfjIkDDYYk=;
        b=WLHxN2zUDI0iyaI4cxuAp9KLzfT7U/gTsfuBZ/xB9YcjdjAVRo4RNmJagfYkJFS4Ii
         WDeth04tfJ+2U3EtRTU8ar/nhqGUoGCIj8L0GgLJLsDpRgJSAApzK7eVm+h9ZeV+w9bh
         n8V3OwymZpcRIHUDoOY1+dbFWXxMNmdr4AuS22Kc3Qs80BoANrqmh/eJjxlBG38zI3HE
         8fVWV/SjZTAxozmAckesTuTb4evaVWxFvGFxfTctyq2jvQg3sILrD5vmFdelL+EAokAb
         6QdkJrxdR/RpsK3DI4+cSEhSRQwNlgipP2y3KazYJWOWA+53nTHHKpvX2vWaULAPnwE2
         s/GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784514969; x=1785119769;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JvsdJN4ylr02nfEuq1zebFxCT9Im8rIcShfjIkDDYYk=;
        b=G5qGSprFz1As/TPQ+dzMUZLsJ/lczDWrWRBQPfGqXh5x6iuqe/MMmhgPzw6r7mjigW
         woMk+1zNqKATezGdXPOPEAJ/6/1zYX52NEurkrwpFCkDBq9bLp/3HeV1Vpps+8sayIe4
         zHz/QeKGeAOt7kflyFrQUFwJx8jS6jaHhWM5d3MCKLp9Pu5ksbTC7NVENubozVCr/RD6
         6GVnGPZqN0CYweOw8sCkwQaHfjCxcROrcaMJVBYNfgL4S3MNIlp4hjeRm8AXid5vYsCy
         4ffAO59yvEmR3oesNUbqS8FxDVghMjSlvnF+BpbAbw+0XiopiLnAD4CGBs14ZP9R5k+m
         aBvA==
X-Forwarded-Encrypted: i=1; AHgh+RrNOKVlg/VAZeML4oS+tMwOlGRPQNWnhXJoJdn43Vkp3nGCRreZQdPxoDDoTs4w1mXkoWxgLwxjwea3@vger.kernel.org
X-Gm-Message-State: AOJu0YzfuJXHcV//lsgRKBjR4l0eoxRfB/5uGqNHxgm2YI8zJE8zeXxu
	01w4B0AZi1TquYvDF4OaZ7KHmfVUHBbHRDeqA/dh+0t9M1Zpq9yXcfh7EIAYaHQd83QcTJJfE40
	Yp4unS1eUJJlN4uRgvuwy6NL6li6X/ODrJg1Cp7Ai0qzr6L4soQjOsu3CTt8Dey9L
X-Gm-Gg: AfdE7cmXv1Z6U7UEuP+Eti1jWU8QuuZSShx8J2TS1kuFOaoilmMMvexftfOpXvX7dBi
	n21u9Y2R0SHVFT4mnTo/UTXxNEHv2Q+yAmJ53fekJQadzBCXmXgIiSCwS1RwcPmy5M/2NFY4qyI
	vN5jrSGV4x5ZZdj/yXQP9214AA+qpQFBtPA/Vf70Q2X374OXiFGklUzN6nIKX9GgnE3wjO4j3ID
	DXJCxkyP24gw86z2330wm9KEfkjrHw+qCM7yFrU36zG2C8s4GahpLU+VOEYGt/ghbax49BljWUG
	B7L1fyoz1ihg/6B2NhXFpQh5roM4aa3VbW48hqFN23gzqfeyEYfXZ0OQ64rZkXdSCbcoDHPlEWe
	jn+dcuh6xfqDbsvldqKoWGaIaLSucWmti+CLuUFqRGEF4Db/dOTuNg9y42bgs
X-Received: by 2002:a17:90a:d2cf:b0:38e:4cb:51f with SMTP id 98e67ed59e1d1-38e4b446353mr12364883a91.11.1784514968760;
        Sun, 19 Jul 2026 19:36:08 -0700 (PDT)
X-Received: by 2002:a17:90a:d2cf:b0:38e:4cb:51f with SMTP id 98e67ed59e1d1-38e4b446353mr12364810a91.11.1784514967443;
        Sun, 19 Jul 2026 19:36:07 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce29e340esm24646932c88.5.2026.07.19.19.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 19:36:07 -0700 (PDT)
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
        Anjana Hari <anjana.hari@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shengchao.guo@oss.qualcomm.com>, stable@vger.kernel.org
Subject: [PATCH v2] scsi: ufs: dt-bindings: Add missing mcq reg for qcom,sa8255p-ufshc
Date: Mon, 20 Jul 2026 10:35:52 +0800
Message-ID: <20260720023552.2667237-1-shengchao.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Le0MLDfi c=1 sm=1 tr=0 ts=6a5d8999 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=3miq8Qb-Iyz2LYAwW2cA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: lthTC1DP1B4qh_I8SWcQ5DLvWPRRGB2A
X-Proofpoint-ORIG-GUID: lthTC1DP1B4qh_I8SWcQ5DLvWPRRGB2A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDAyNCBTYWx0ZWRfX9oQOLfXH/fKS
 ZYJwb206X15OS1jNvWchflaHFiTN0N9uwVjQhkhJFacVz3nytoFKEcJznZSN1eu+FvpfbfAedWm
 Q7+JTLCQuA3gyJIxwy04lQzl8rZ9Y+Ph0NiqbozyA1EkQr9lu8kUHY2WkEwCaBFY9PdATnDsywy
 7AEK0dpL1+CqyKVsZ/HS1/Gv+SIl5Zmo/2vcH1PwVjyKkSA/WB9eSTWWczA1GxP2CHG+HfzzbZz
 Wl13x5P264Lrq+CU+LgjXZYt3/wrlAjvNGxFh1KsqLSh1LDJ6y7iUZ027YyGiDiTB0eyRIyo9YT
 NsXrDxpMH8duty357scfEYUaMW7OfSds+CdOzMTb4zG+CtTJpLao0Q46A0k2+Nm41qMRfaTmk8m
 UPzDkk94jxS/mMqfI0bYtwNo5CxOG3fNsDcrSreRFYDsH+HApnY+GRJ7ouP1ZCL1NDMNXML7K5+
 gfOU7uIHzCBBNM1B1VQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDAyNCBTYWx0ZWRfXyWhvkOVwD97o
 kNc8BZNBnW6wa1cj9QAWk3k1FSG0AXHQuo3jV4+3PJDTKNxb4nelMPQer4bQAia8GGbI6+ZYt0t
 Nx4EgkgTJ0QOrVB9virUxb35QOzwE14=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_08,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200024

Qualcomm UFS controller found on SoCs SA8255P/SA8797P has a MCQ I/O
address space. It should be defined in the bindings even though Linux
driver currently doesn't utilize it. Fix the binding before it gets
adopted by DTS.

Fixes: e2725ed2a7fb ("scsi: ufs: dt-bindings: Document bindings for SA8255P UFS Host Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
---
Changes for v2:
- Recover the newline which got dropped by accident
- Link to v1: https://lore.kernel.org/r/20260716083313.2367249-1-shengchao.guo@oss.qualcomm.com

 .../devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml      | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
index db165a235cb6..66d73e9025d6 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
@@ -18,7 +18,14 @@ properties:
           - const: qcom,sa8255p-ufshc
 
   reg:
-    maxItems: 1
+    minItems: 1
+    maxItems: 2
+
+  reg-names:
+    minItems: 1
+    items:
+      - const: std
+      - const: mcq
 
   interrupts:
     maxItems: 1
-- 
2.43.0

