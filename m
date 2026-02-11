Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECCC25F98B
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 13:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770816602; cv=none; b=PI1Bepl7F7eeOMtNhq00bL+dj6UHXJBZnvkOlyQJX96GKPmZXX2gx/O94Y6zGvo7rzIKI4Fuq3x7phh+OZO6aqNIFWpowIlpzvjC8Y6OntHlQCEhtl6GRLfg2hXy5OfkdBNkvUZZHHEf/nUuiQiIdaF1xWhmX8kYLmmPG4hUBqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770816602; c=relaxed/simple;
	bh=O4eEzxfJ06dTN4TZmevXD4WpG9wx6z38RWNWZWKwQ5I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B/eUX57Gd7frcgG5z8DmxcbJ9on704jOSUYHU132A33No7uyI5GZFVUDHodjLd9QNsN3VbWz3auA9baeZaxwZLvL4XwDjaMVp5Pj+7a6ZNVD/GnIIpsqwy7PmHlVg3qTplyqaKK9N4vPE+4wg9i0g4u/0Yt6Bb7cY1d+SCXWPEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MqdGGIQD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NsTibFTQ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MqdGGIQD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NsTibFTQ"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61B8bp0F4177319
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 13:29:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Mg7jJNgLIUo
	B6hOXMTj2nXOzrwCGa394XSFokHpCUZI=; b=MqdGGIQDf40YjM7//P703kk6m4N
	MCX8+fyyA4ksYP4UJOrHespO1x6N26tRa6mlW3Wu4PCYpmDvFOgAZObv6yTBTw/Z
	PxLny9f4cplxyWe0SjbS4jxoO8Vm0qKkdGyTWdJW5NYK9ZfWsBwudfs7Pt4xZArt
	lwKkAel38gVUcFlR9fFW95JqU9z7kGYL/eWUhGzL8KZn8TPIFncOuVdMrezGiLH3
	RVcDhNDJCNOQG1+1znAHnwYyWqTvsZhcB7tZ2Gk9hlvP+9Rd1S7rPoa64+wOjDHk
	dO2MVVvejmuEZNp4IfoCmABFDQtA3HHL0A2f9HqQIqo1mFjwymNbu9VQNyw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c879mkw7b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 13:29:59 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8243eb5aee3so3222776b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 05:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770816599; x=1771421399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mg7jJNgLIUoB6hOXMTj2nXOzrwCGa394XSFokHpCUZI=;
        b=NsTibFTQ+9BGaRT2YLkPf3gUrbn0piyi20iSGyfBuBgkuzdCk+lnfQsGP2XToOaxz1
         B4tgx3HoJ7DVpDOrSH8GH6IFypCCxeM1Fp/8Qtb6c+pouuyAO9Lc3RhoELcUG342gX2n
         6cmHv0TYIrFTY5i2+AMkUmkjeYCmNQQ2BGpEtZsDm9ZGsWjdfnv66bTjBVZZsuk2Kc/O
         IC2ASWpoueJMJlsDyxI2cpT9+JgeJ10zQkx+rm1kRRdOpel99xXhGC+88ur79J8oSgvP
         rR1gJa7btpjvVeU/P4lkVt2+HQSNI8fWMl1g/WYWXtKUoW9VPLfipAQth3BuP/jHMlPe
         BaFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770816599; x=1771421399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mg7jJNgLIUoB6hOXMTj2nXOzrwCGa394XSFokHpCUZI=;
        b=qJj6ZoWzgvN6SoKCw5uaiwMAylX4bQ+/Vz07sQjE7LyA5PNu+T2sB9gjJt5A+xOoS2
         nS52XewjYaGvJmwa/dfXeF16HuWEktXOgnmNEHVZ/tgu+9LKKF/lp94GvFrv9YICDyZA
         WUaeV3Wt/60dRdUpY8HFDFWwFR4zwFsEWDf0qIIFBSIrFfEJfm4Hyb10bthLHtHDehBU
         XlMJKLaKstq1VNHa2+BBcZ92lkk2T1Q8KK9AlL9Eml0IbaLgr/hOZ+fCt2LK1Fh/lAWG
         ze4j38wNodoK9HpwVk8TM8V4XtpKRP7DEOhTzgFytNteEMjDrFXbiwqJuFhFoQ2JLUiI
         KtOw==
X-Forwarded-Encrypted: i=1; AJvYcCX8LO3oesX8v+j/V0nIGSyCW6fyPe4rA2VvSAP2bnef/uzYCdaY+7GJSfP2eEJJH+PwwNc0ogj2UxoW@vger.kernel.org
X-Gm-Message-State: AOJu0YygYUmj7typZ2xoIB6w/LByadsRRIM42TDx8oplV8ReSFxkXx6j
	TVsPQBwNTmlqPcMjrD6dxLKeuPFd53ebTxoybXBkHrvBShwHmpmi51h8XoZR/gV+/sNkvUdg6Qk
	20OQU45RA67NGrseuZoDTV7E/XXIiTJ3weHa9GtF28B2QOCq+0JHVy5oIeVPVjPWw
X-Gm-Gg: AZuq6aIuul2TVCdXJaiKPVREvP8oQ+7GnvFvOuMr2drc5tke5gjBDxDrZ458Zx2w75V
	pajGuUBNBnC68pVA905xtyu7T48z9xav7tNFM/QHVsUnFKwKyxZ80zARSoUfF5lVRQUsblg6JDH
	rFVQIEFluxsKIvYG3wrPdp/hTzz4rqnOj/JzBsNbfYCsYWo/fTAWdKzgs+Y92ENvZrB8Il3d3Bc
	pAT8F9+T/QbKJY+faRMj12V9svkAcJX2Nw7B5PQo/CMuULOEvBvdrh8pswGbkUzbFzlhXB1o/G1
	+4yBGDx3fGJ/py1yYInMImW9hbKdf5KEKyj/oFwKCtnB/WOWzPYaHwAJgGy6qSo4kKUjbsQ9VcN
	KYEuLqbT36h9U9vy0GZz4YWBGwL+ZhI29Ur4J/ouGn77bCC6T7+dMHrVgsTIQ36TY
X-Received: by 2002:a05:6a00:7493:b0:823:9c6:1985 with SMTP id d2e1a72fcca58-82441634f48mr12870447b3a.16.1770816598811;
        Wed, 11 Feb 2026 05:29:58 -0800 (PST)
X-Received: by 2002:a05:6a00:7493:b0:823:9c6:1985 with SMTP id d2e1a72fcca58-82441634f48mr12870409b3a.16.1770816598164;
        Wed, 11 Feb 2026 05:29:58 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e84bc1asm2143655b3a.58.2026.02.11.05.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 05:29:57 -0800 (PST)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH V5 1/3] dt-bindings: ufs: qcom,sc7180-ufshc: Add UFSHC compatible for x1e80100
Date: Wed, 11 Feb 2026 18:59:24 +0530
Message-Id: <20260211132926.3716716-2-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260211132926.3716716-1-pradeep.pragallapati@oss.qualcomm.com>
References: <20260211132926.3716716-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=UKjQ3Sfy c=1 sm=1 tr=0 ts=698c8457 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=uoUYCPJ4ct4VCx-fAfYA:9 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDEwNCBTYWx0ZWRfX6T2ziT9ZsOAS
 8wKxY/Rc0P+JjIvdIqAMmRsAIVDEmT9cd99k4ZrT4f9QahjwX/nTTK9WgpzSfYIC7U7Jt7TCr08
 +2v3POTpfoYnlEShJXp1zOX+xksIV2nrXfrhZkgFKuF7tvutc6utHvBFgVhB2v3FAEiczDHFqHK
 r37UDcvwWQhlakyvzdiE1V3A3FgqTctZHSCw+MYXxazfeFE2JkaMZA1kY2l5WLCmPqnaWHbZzkq
 qwckSY81A1yEM3O1xHEp+Snws1PodgaY4uuTSfSG2ruO5cIv1Ne1mejL8LTvJLsuIOwxkf1anAw
 dNkONMSy6aOi9Jl5muBkV42nptiXHEYTWN36rhiPtmWIYeuPD1a6wPMIRl9dlFES96xRh9l6DRd
 8eRzZUqI+ZdtyhEZSGTmcggDG7ip3EWREtmMCZ8UX/xLTb7mCkPf9vzb5L7S1Z7ITE+tzmDRM1l
 qORzynQf/Vcn5hGSHhA==
X-Proofpoint-ORIG-GUID: h0p2RVdySb1myMVepyn8oJLPbwShcXQy
X-Proofpoint-GUID: h0p2RVdySb1myMVepyn8oJLPbwShcXQy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 phishscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602110104

Add UFS Host Controller (UFSHC) compatible for x1e80100 SoC. Use
SM8550 as a fallback since x1e80100 is fully compatible with it.

Qualcomm UFSHC is no longer compatible with JEDEC UFS-2.0 binding.
Avoid using the "jedec,ufs-2.0" string in the compatible property.

Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 .../bindings/ufs/qcom,sc7180-ufshc.yaml       | 36 +++++++++++--------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
index d94ef4e6b85a..fe18e41ebac7 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
@@ -31,21 +31,27 @@ select:
 
 properties:
   compatible:
-    items:
-      - enum:
-          - qcom,msm8998-ufshc
-          - qcom,qcs8300-ufshc
-          - qcom,sa8775p-ufshc
-          - qcom,sc7180-ufshc
-          - qcom,sc7280-ufshc
-          - qcom,sc8180x-ufshc
-          - qcom,sc8280xp-ufshc
-          - qcom,sm8250-ufshc
-          - qcom,sm8350-ufshc
-          - qcom,sm8450-ufshc
-          - qcom,sm8550-ufshc
-      - const: qcom,ufshc
-      - const: jedec,ufs-2.0
+    oneOf:
+      - items:
+          - enum:
+              - qcom,x1e80100-ufshc
+          - const: qcom,sm8550-ufshc
+          - const: qcom,ufshc
+      - items:
+          - enum:
+              - qcom,msm8998-ufshc
+              - qcom,qcs8300-ufshc
+              - qcom,sa8775p-ufshc
+              - qcom,sc7180-ufshc
+              - qcom,sc7280-ufshc
+              - qcom,sc8180x-ufshc
+              - qcom,sc8280xp-ufshc
+              - qcom,sm8250-ufshc
+              - qcom,sm8350-ufshc
+              - qcom,sm8450-ufshc
+              - qcom,sm8550-ufshc
+          - const: qcom,ufshc
+          - const: jedec,ufs-2.0
 
   reg:
     maxItems: 1
-- 
2.34.1

