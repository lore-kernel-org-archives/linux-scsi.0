Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA1D326959
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 09:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771493970; cv=none; b=hNP/0DCPZpbTj49ETjktpoTFE9RC40S0oTPwE07KUr8Dig0fBFA8VSTqqKVvuihTzBR/QcXxVD999xVaOiDORZi1YHsScdIpFYMhuLAhztWXxdPLoHPdRGsJix2luNd3x4zKKlUmfwO96JTIWFRHRiwXkTtbPukF1lRDLvpz4gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771493970; c=relaxed/simple;
	bh=97/JSwHInanQ5uVj6uZW+Gqa6diRHttxVXWOH4oEHHg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Jg31RtRaA8nPyRabevjUPt3jOmgpU00NaW+dtFcxWNZQQbSEV7upUOos2Lxl5efmAx/mh21VZXAvFYs8XK3T50SDWlaJu4sdrJ+/w4npMQPhwI/rHvg+6wR6ndWNa/FXH3hMUTdR/mmAbzuT3TagGn/s5obETC9+aagTujYW2r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QsXELX0m; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eRzh7SMV; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QsXELX0m";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eRzh7SMV"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J4Di8N4025101
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 09:39:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	pdBiIXF+CtpgVdQJL037m1Y+o4vwFkI9Pmjc70ltDag=; b=QsXELX0mB3MJFlLJ
	tcyvEOHo7LPnnaEFmcv19l6WshoD5R7ICfwHP3JQuZZF9y2tUGjj0dyXbKx8c30F
	dvzr6QjNHCjyQlPvlF4J2GefuV/907F2Fq5UnHTr8sVKQ/C3809n/4dw36ZjQbWv
	2rI16SvKcX18zAISTHrdPQ3EPJLMI9vFQxmdDLd/kiqkczF7HKznoeC3d/KCBcO1
	84/aKWp+KQQAjM346DkVo0m1VHuq2qEc7eyP9rmFel85f4zBMZxdESXmFRru3G/F
	s+E4Xnj9LmA96XqebxDAcjKVYrn7YoZzkn18QuXTMCA56cCkQA9eIK2vIILdkIvD
	4AGKVw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cd78c3xqm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 09:39:27 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c6de06e6c08so529879a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 01:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771493966; x=1772098766; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pdBiIXF+CtpgVdQJL037m1Y+o4vwFkI9Pmjc70ltDag=;
        b=eRzh7SMVf6QP2uCq5uxoXDvoOgnGcDDrpnRGoNvAkMufM5nZ8JMtrcdVDgD78TmoOT
         f5yy+BUiNCSfIq2/HWnaT2gkV23Cv7fUid3TkmZ0YLya+KaMbGvt1fm0RkTrIFJ2sJoH
         iJNC2bIwgmSH3KEj8ENXF95KtoLII+Gt2+S6PUIzBxm0tpMGx1zDACAvemhYZVCOSmeK
         mWcH60ysRxqYKi9q634Ty7U5gL97zKK0jrQy6iYklsxQp+LjfGTUUCRyNgF16RmECWR6
         SRGKODUgIQLGdUCH3VGIsDdrkE3hSSbMBZXoPapzwp09CLdzAYuyhO9L9rorEYbku1rP
         2BVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771493966; x=1772098766;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pdBiIXF+CtpgVdQJL037m1Y+o4vwFkI9Pmjc70ltDag=;
        b=r1/Y2g/gChI1pDLiaCE+yq+O6LqEQXrUeXzFfwyrKPsWp2s1I3v+9BXUopEkcLqXAn
         ii9EKfPExkMYLIhDnhZb6dJhq8dl5mNxxYTAL7Yon8D4738K0Y58C1pvWL6nm8PyovWD
         bsR1RshRao5IX9mZn7H7SDFDLmT/EUiT9EA1Du8PgGH/qOdljEza4tEw0axOLADnfzpN
         lGRolpGfgKPxgRheTRGOJDivbTaama2UV/DEI8ARalJQC2ZZ3Awddt/ErQGel/+R/Pc0
         /mg5jNUnudfccTpkEms3BJ+42FkRIQn5ELGVoy86sD3U5OevXdjVlphy9K1V/tQtiybY
         GE8g==
X-Forwarded-Encrypted: i=1; AJvYcCVHUDSz0C7BbuZ0sEw5+RRT6VBJhuevZK3eP+6+2YqOEbuGaxxFzmrM9swCcbAmr/cN8Off/D2GjRjd@vger.kernel.org
X-Gm-Message-State: AOJu0YzD1laECnmID1S4HyiT82VTd+qdpd6za/cbhE8Zd5nwVN7udzUf
	LZ5cOovXzf393R4FJbh0BIZb4VQeTZAf/Xhvoa6QL/wFNh/5bB4RPMDFZEd4+l7DxBA6QjmwDJk
	LKg1R6dIID3d73mVyo6CkrisvzXQOiw0l/6AZ0iVCrdVPh+QVNXMgsR3e/KoABi7R
X-Gm-Gg: AZuq6aLHgBWjxASwoPZKQfBG+nkbBm+jvBTrsqo6Ixd2I77ko4pE7a3Kf/AhmcYvua4
	gWic/xA1tIHfkdg0VAHobzEVUwYOZDuC53LqXi41bF4Dt9HK+xsFF+NvW9vz3uoSzlQBQ/3JX5I
	1rBf+AfOGYiK1F5I1Yu+YKxbcHzYVmv2UjfLYbaG13Q7pyNIpk1TONF7/x96TExoS00ex/DprfK
	KoBMtqISzsD6FrUtbrO+VKuoKLrN//MFAZEYYwtJnGRFTQtg2xxQsOKTvecNH4xQ8z7ww9eTO1W
	xdrfoqMmv27PwawuDvKq/ZY9Qh/QmO9hCrnmiq+E7GBucY1PdNVsFhpp5c+n51ueZIDcXZDrwyJ
	udcwnkPt1+PWeKUcDAIQgf+c2vXNYeK+nycSoRx9ootATkq6dToFbxDN7B80=
X-Received: by 2002:a05:6a00:aa84:b0:822:6830:5900 with SMTP id d2e1a72fcca58-825274893ecmr4662534b3a.6.1771493966329;
        Thu, 19 Feb 2026 01:39:26 -0800 (PST)
X-Received: by 2002:a05:6a00:aa84:b0:822:6830:5900 with SMTP id d2e1a72fcca58-825274893ecmr4662513b3a.6.1771493965853;
        Thu, 19 Feb 2026 01:39:25 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a2ac83sm17710250b3a.12.2026.02.19.01.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 01:39:25 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Thu, 19 Feb 2026 15:09:13 +0530
Subject: [PATCH v6 1/4] dt-bindings: crypto: ice: add operating-points-v2
 property for QCOM ICE
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260219-enable-ufs-ice-clock-scaling-v6-1-0c5245117d45@oss.qualcomm.com>
References: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
In-Reply-To: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-GUID: uxnauKgZs88JslP5cMstHbmb8s7iwreW
X-Proofpoint-ORIG-GUID: uxnauKgZs88JslP5cMstHbmb8s7iwreW
X-Authority-Analysis: v=2.4 cv=P5k3RyAu c=1 sm=1 tr=0 ts=6996da4f cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=QeJYPjCb9QSwVUWzf6EA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA4NyBTYWx0ZWRfX7RwruiHqNG/k
 lI0rgkUin/S9cZBOq8uGKuIo6Nw4zqRmi3csU6SKrVN6aUO5zGVoP5S7213hdQd934QR2lPI+ik
 DD6/pl5T6M6gVWEE0/t329HxPXpKX3H6vZtSVK14BP4p3EUJ7jqznVT4GuFUfROdZdZIsHcQIQd
 c/ITttftMmNFENMS9jczYj/TC89o/FJSz4ht0rQRf3k0avSXMIW96ZjyMyNrGs4998zqnEk43iG
 M50Jh2pz6K4zW9DJ2cW2p9MyVuKPyMjnHYtMW6qfE0DO56EycYVWUjONLCKw4i7u5JvifaqiHjm
 GzTVmZNjBMYv8+b5eVBUDt2Mr6bF4K6NDhy11gIlG5oTg8fAu4/YWr/406LnPRJcHBXuj5vrNTU
 pBvdyB9pDYps6PHkFdY6Xr3qfNxjqtNUG0VeD3qSXQTtGv3toQPk+YNL9x9AHYym8P96bn1y9rO
 DUDR+4wRTBWbi0Cx/XQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_02,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190087

Add support for specifying OPPs for the Qualcomm Inline Crypto Engine
by allowing the use of the standard "operating-points-v2" property in
the ICE device node.

ICE clock management was handled by the storage drivers in legacy
bindings, so the ICE driver itself had no mechanism for clock scaling.
With the introduction of the new standalone ICE device node, clock
control must now be performed directly by the ICE driver. Enabling
operating-points-v2 allows the driver to describe and manage the
frequency and voltage requirements for proper DVFS operation.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
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

