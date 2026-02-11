Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873FA36682E
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 09:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770803286; cv=none; b=nyZZhPwY151cvt+UTgLiacPCoVWq3iDm16bqIGP9Ca0WA3pXETI+YMPyC2TvJCtoA1HzFQVM7c3LpRhOQ937FkEsxoYsTojgoHnzhQdq0ou3QppbP4F2/6zrZhBlIo0PDZj90/NMNwYPlDmOaFrpSCnZHdz4sE5SnOqT07RKUkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770803286; c=relaxed/simple;
	bh=A9DBiNP8iL9dR4Wka9rYBtFBrkJpTxjiScTy9/hyWFo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=daT3twcinYX9fNmR/4KgoLgxMZd9nyDIJzeUT/4n16c80QwMrpSDsvPlVlq3DnA6VIPN9vIQMZ+pzOisSjJj9ALPQ6WnZYttP6yZQPK1gtmh7LA5/u1z7VErRnYljfp1A83zT8pOefwhdOMyjNv1PUplkbjZyPy/w2WtUxyDUdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Bs56DhjY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FRKuPkRT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Bs56DhjY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FRKuPkRT"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61B90TQa4006707
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 09:48:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bJF5kOcx+0z0jZVRbBhfjrP6SosQxJ8NlSFELd8k49c=; b=Bs56DhjYDyPDgFsE
	MeU5w/OlDVv3A0fJtiOs9sOZhI2FbRs2YC2nRw7E68N4lDcgfb5+N3SIW+GNCy0g
	uVRYfdrzYStnojBfqwcGGCAxZrDiGGYYaTVvATif1qkpxzkjFFLrqx7uTWheJRcG
	SIig9OyYPI+qdE/1pLJLKvpm05ufIs7lbJMWtQGgUPEQWhLA5ta/9czZKtGDRuIg
	tZDKudRt0y/d6SGsAtn9nv3VcwCnaoulklDIum371hO1TKgtsvm1ZTZBnof/DbW7
	1kOYjdrBM/PF5QdF5gZmcDJfE5mJ0+auqqxE9Txl2Yb69RKGnqVdT+F0JtN6pC0t
	z22FhQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c8fbwsg29-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 09:48:04 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-35658758045so1781423a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 01:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770803283; x=1771408083; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bJF5kOcx+0z0jZVRbBhfjrP6SosQxJ8NlSFELd8k49c=;
        b=FRKuPkRTFdkhOSShs0E4qHZe/kTtDNuEcgN3hFAfKFd4gmu+qNCiEkuW/ktnowdQLY
         QfFYULSWY6im8k0CC8Gb2Kn1gCAzN5t9fHZnLxiXeY0r5PWfBdGoh64nfG5FhgQLDzrf
         4nRUprA0VnsLbWeMPmrCk2EmdCeP5Eep5qGYdhug+tXBDJ6Dbc4mHxx9xdKXMnoptBkl
         SJJjdlA4PMg+y6/lEAIH2ySmqz8DeNTA8BcWoCkVOa86pyZPikxcUbmE8FzsWvIWCwjg
         f0raOc9At3pMb7S93hqhpQAjjfqzxsOObyyynMtNo0Js2gliZpNdTlODDKsFR7Kxj7TG
         8wdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770803283; x=1771408083;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bJF5kOcx+0z0jZVRbBhfjrP6SosQxJ8NlSFELd8k49c=;
        b=jY+p2pjNw0ocOSpsnWuawZL9kyk/y5nrVd8VZa8CzDiVD0T9Sy9wuTSB1q2HaEIKIu
         mUtj6Hy0JpMXqj9miZ4bQ4XKKsLgtsKj78IPH7eonqFN51ahLLDpVwgTikIeMwnI7VtH
         EQo7NqN2kbHdUoynj3cSUkh2fU6woOaD0JdMFXmrtO/uOMTfUQzD/c7GNu6zEDwH5AXq
         K+b3t8T2mHhfX2h2MHMiv22pSYY3L2uEHp4W6XGxTSQAvnEexSJpnvwgXW/eBaDp07s0
         Vv8FXBR5LS9aTd1be44OXBFq0J2ZPMh5vEym0SejuIczjBZSXq40imgw4YQH/MNcx/NZ
         vETA==
X-Forwarded-Encrypted: i=1; AJvYcCU4jVTMVUn+fl4kCK5vVII2sptRD37WJaYDSVnS5Vc1DbyaZTN3tWtENJXgfiSaoUiXPgKpBYN9IylI@vger.kernel.org
X-Gm-Message-State: AOJu0YwJ47v/PIy7g8EViGWCx6a38X5UnG/PITx0L7f9dSTqePCL6qXz
	KvhquW1pGgWxT5zwRZNFrL/q8nw9UTLlZOwZowhzgeMWDW0zujZ42raj4KZ+fa5z+ZQyA6GoWkt
	OTgS6IXXv2KqqaqAhBYpRyePld70T7QUwIWQMntWsXt4WEfV4XEzbtXnwg4+CkjExHCsKTxEr
X-Gm-Gg: AZuq6aIjigTlrpH+Du2c2kKTl96GBPczDcx3gTBR4eZ60okCpq1oTRcv0ZKuFNvEnnv
	TZY6jMF1m12YXXPumixCP1mHiYhr2rPu+92lfz2W95dPrNV6765iBNdBpou2kcmgACTB7YqqRUz
	BkeULi8PFMeJgn56rJrAqN1IVSnWZ7dgargJ9V1IPMSJfUif14BKxTgrHPVPIfQdWEj7XqkGc9d
	BluT1Hi0Kao3xxFA6m/plvruW/h/dmieyNbhTjX0De//Jy5Hmaa47oFeYhsA8Ye6avIThZgTe39
	ZmtWhCUGN8nRjf5WydJr/Bs9aJ8zB7KRvgEeKIAmBOSGvZR/Qcd250mdpCepn8l/fsmdndRDWVR
	js5QB2T0KWt+5h5lFUl6jYw/3oix+4zPbX93ZnN92YlGUDegYlvKoo+v1ItY=
X-Received: by 2002:a17:90b:5285:b0:354:ad98:7d1c with SMTP id 98e67ed59e1d1-3567afe23abmr1943049a91.11.1770803283390;
        Wed, 11 Feb 2026 01:48:03 -0800 (PST)
X-Received: by 2002:a17:90b:5285:b0:354:ad98:7d1c with SMTP id 98e67ed59e1d1-3567afe23abmr1943039a91.11.1770803282848;
        Wed, 11 Feb 2026 01:48:02 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35662f6b84dsm7526640a91.10.2026.02.11.01.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 01:48:02 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Wed, 11 Feb 2026 15:17:44 +0530
Subject: [PATCH v5 1/4] dt-bindings: crypto: ice: add operating-points-v2
 property for QCOM ICE
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260211-enable-ufs-ice-clock-scaling-v5-1-221c520a1f2e@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=GM4F0+NK c=1 sm=1 tr=0 ts=698c5054 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=QeJYPjCb9QSwVUWzf6EA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: 0qrY8eCa3zOZkOSKqd_o_9gDygzvBxLj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDA3OSBTYWx0ZWRfX5tOGM0cEq5JV
 84HOEqp8T5WUlok6L51g9ytXI82ToAvgE7WLonQKcdHCXo15wr5I8dJTgHXdinICdDVB7LjzgDY
 ipWO6X1seL1LrwFZZZRZ3jlHHEc9p9AhWtjuN7xp9/ASO0q12k3brbeNQQyHSW8OO4uJ8OOk393
 fjCVx0PClCASXs6Ipw9XgFhdKOzA+DdDaBsDzHKS9oZVAlwCH4Pvf3n258qFGfa/05iePZhMzF8
 il/KxGR+9T74j3dIHoSe7WbhJPRbafdDM/TRUFrLueK91fKa5JPQEe7944rgFaJfhLOCns3KhDo
 9bi2xKkIp9npiNifG0xULj178PiazGki898E5a0fh092aJu8TuJESZNbYrct57xMQIYtrOhMGyg
 7YJbRqyw2h/CMeJRk4dLu9N6NT26P9GOeE9szfw4i8s+zDHb5HiqsmEd46j+mNlZkLNBqt+Efib
 wFFdOUYf+rmaVnV7P4w==
X-Proofpoint-ORIG-GUID: 0qrY8eCa3zOZkOSKqd_o_9gDygzvBxLj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_03,2026-02-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 spamscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602110079

Add support for specifying OPPs for the Qualcomm Inline Crypto Engine
by allowing the use of the standard "operating-points-v2" property in
the ICE device node.

ICE clock management was handled by the storage drivers in legacy
bindings, so the ICE driver itself had no mechanism for clock scaling.
With the introduction of the new standalone ICE device node, clock
control must now be performed directly by the ICE driver. Enabling
operating-points-v2 allows the driver to describe and manage the
frequency and voltage requirements for proper DVFS operation.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 .../bindings/crypto/qcom,inline-crypto-engine.yaml | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index c3408dcf5d2057270a732fe0e6744f4aa6496e06..50bcf3309b9fa0a3f727f010301670e5de58366f 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -30,6 +30,11 @@ properties:
   clocks:
     maxItems: 1
 
+  operating-points-v2: true
+
+  opp-table:
+    type: object
+
 required:
   - compatible
   - reg
@@ -46,5 +51,26 @@ examples:
                    "qcom,inline-crypto-engine";
       reg = <0x01d88000 0x8000>;
       clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+
+      operating-points-v2 = <&ice_opp_table>;
+
+      ice_opp_table: opp-table {
+        compatible = "operating-points-v2";
+
+        opp-100000000 {
+          opp-hz = /bits/ 64 <100000000>;
+          required-opps = <&rpmhpd_opp_low_svs>;
+        };
+
+        opp-201500000 {
+          opp-hz = /bits/ 64 <201500000>;
+          required-opps = <&rpmhpd_opp_svs_l1>;
+        };
+
+        opp-403000000 {
+          opp-hz = /bits/ 64 <403000000>;
+          required-opps = <&rpmhpd_opp_nom>;
+        };
+      };
     };
 ...

-- 
2.34.1

