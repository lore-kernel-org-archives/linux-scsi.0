Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2359E32FA12
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 15:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767714156; cv=none; b=A/7yCTeiXB66MFxpRBuLO5UWH8ffmgd9LhEj/tu0SCl+xobU08OTKUnaPLhYQuSoNvWzaMzb/BEw9WG/cc9+l5xFOBI+LXpD3FTPobAq4JMO2ohT8hjOVYtK0y46D0ngniETObEJMeMhhJNJi9uqEagv87oLWjeW7eM6vqlCZRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767714156; c=relaxed/simple;
	bh=s0E6TfSa6hTZvnNvyiD1r3StlrXb2SGLhoUrhrpf0vA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o/V+GdgCUn8rIBieKm7v3wmocGqm5UeTP1Xe/02z901Hz9Yu6wz3ZMIn6T/nr+59DxtXI8Skl1xSP64U5GFc5Jd1t/LwiJmQ3Cv9ex0VPnPJ7YCI3bFKfR+J2sF42MuszzUqbiUhpnWnzjUgTXVL6wql1v4yaE7COQ9ShsTK/es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AeOdqh2H; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WHF2UYlS; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AeOdqh2H";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WHF2UYlS"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6069W8Os4090717
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2026 15:42:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=AIjtUSFiBLS
	/NSPeW1sXaQDeFzH7a7re/A2GcCo2hrQ=; b=AeOdqh2HwWZKS1w9QzVQOHCNYNb
	g/JDq22gd2oa8C9H4OYoQPXd0whK+o3xbIbCJ4APzzyGhhKP+p0fDC7gWGPSrROG
	ZS7tZ9r3Tsl5/fNmc3/eD76skhprn99da8OyTMG7sXnKzGy0nbgVsO+zcF/NFf5b
	BeY4I8B3azcERdNuaG0rssCR/b44I6zJlcyOxpmGTkTusBUsjbTr3ge6kqVqdSBL
	x/fw5LCovCMLs5QzmqMslAfCg0ORA/VbJGxWJgNVNA6buKCe3YEvHDpAA1nk53Qi
	vxjjgJjJxNOc9jBfld8CxwBbPbvMXgGwcsVaKAj9+ENjP1gztWgx81XEZnQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bgyun906j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 15:42:30 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a377e15716so27204805ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 07:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767714149; x=1768318949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AIjtUSFiBLS/NSPeW1sXaQDeFzH7a7re/A2GcCo2hrQ=;
        b=WHF2UYlSPimSN6ST8pqNJHYO1FVuHzqgRbIgTlHL4l+p90FPcorYO9KaHAhOYxEh6q
         1NWJggKQ5YADt02tLQWaWkqkfY8ldkcuiLcIyomG47ugwFA+KfBj03XsAy5Q0X17s+bS
         VFl/M+bYtVtqj4B7gNj9lIAoFFhnyjX2JiJdKGLEBL/tBX+6lUqLLkF8NvFWYy39++xz
         gOvfZ70qhtle3ERN1sQyHl6JR7PycPUO+G8LM/qvml+bhzwv6pv9e/o+YGL74Cg1Xwrp
         +SR0drIOhDpZdiT34byx9CJ0lPjjPP+c24xiKQjK3SFySewwM3KIzTlRLh/n6yL2Bjhk
         5Hiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767714149; x=1768318949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AIjtUSFiBLS/NSPeW1sXaQDeFzH7a7re/A2GcCo2hrQ=;
        b=xSGQfONOpoBTloWIxMRyQjyknOLPCag2J04uWyn3gHMlqD1cAvpY4Qs26u0nFBpqkU
         sUycYWTXN56ZHJrdF3oy3hUa2eEZcVQ74eUdiOVT8L3kSLeiL8Y6kU7eJVu9YRc1Zdum
         OLajHVClq10B32uG6zaH6D99+IgPfGKZo4zKdV1xtFrUL7UIVqdyItcro2f8H932jqPB
         W3gHNRHsUnWzRkD6zAuhd9130Jye1ZUknvXXuUGQxYt11yQqCRfcyxcMHetv+NTgBw2Z
         oaRBn/mztQPArscOzAUpiNBuTjoj4jfH4HRTcd5VxzA+dxJbL/mTd1bru3ipPk+2uHat
         TUrw==
X-Forwarded-Encrypted: i=1; AJvYcCXbYPChGcwIuo+dghEOSkSH0P3MT48XVn2I6373N1pSyxqy35h9unE3eu7DfTOKjiWu7zvpuYGsJiCT@vger.kernel.org
X-Gm-Message-State: AOJu0Yys5yWV+gHfPe+FqMC0ihIhIXfTx4knHleCHAcVDMyAp/VDuXzj
	juMEEdTRoyN2lT+drhzZF5BvHo/NGtRtFjiXE5YDrMcv+GqUMAbIQmqs5ATyPlk1jA7D9eQ/Aih
	SkjI0rt/Cb/yvtNhlOM7KcL9wswqmCtGrSBy0+ErXOSbmnwi5zl8cR5bLGE/TZtou
X-Gm-Gg: AY/fxX5RZ/s2WTdDPyFH1DrRh9Z5Hswz6ftOAKDN2fR1q/0xkkeE756fmeAelTh47Vx
	me6ZORtgyqk0uzHjaAJJ5VBKelTubJ1stcK49j1lFgNCbk8klgnWPeFJMhn4waKiKYnGjnEtfkj
	FEVTsC0jYlFNtBYZtKjHdfjKfo6ldwwExSH/uGOgWPChBEm7dZSeSIyif/Wh7PZi1Ju/C0adgLK
	vagTnq2/A7tG80i79uGvgycjTga9gUeyxVLrDSmyoZK/tS6u9nTL3oYgLuEzLBCxHnZhOZGER4j
	BCSyr9GjMxqIz15uujOWp71rrgU8IpRL60vNbcQ9X90FCvUqNHJrQWnMhh/+I7K+jFGbjCtdbaq
	6bX38xyG8oV9cdj89/+soBb7S0vFtdSxoRhR6qZb1jFrfwY9b2g6F
X-Received: by 2002:a17:902:ef52:b0:2a1:3ee3:d00b with SMTP id d9443c01a7336-2a3e2d88c2emr39917385ad.13.1767714148923;
        Tue, 06 Jan 2026 07:42:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHNU89AUHGyd5fl6xpGJ5YfiGTUlHmSXmkc8WqDRmjagennnun2O6SPUn43mKoyCxqZ312+Yw==
X-Received: by 2002:a17:902:ef52:b0:2a1:3ee3:d00b with SMTP id d9443c01a7336-2a3e2d88c2emr39917065ad.13.1767714148405;
        Tue, 06 Jan 2026 07:42:28 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cd492esm26606395ad.98.2026.01.06.07.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 07:42:28 -0800 (PST)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Subject: [PATCH V4 2/4] dt-bindings: ufs: qcom,sc7180-ufshc: Add UFSHC compatible for x1e80100
Date: Tue,  6 Jan 2026 21:12:05 +0530
Message-Id: <20260106154207.1871487-3-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260106154207.1871487-1-pradeep.pragallapati@oss.qualcomm.com>
References: <20260106154207.1871487-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEzNiBTYWx0ZWRfXxVd2dlfVTL5q
 e4WUD4vljpfdNRuhsRDO637Jh4Ug+C3iIEGOWDhEX5m1vMEupmGRJ8du9fsY/PT8Sjq8ICAh9Oz
 oONPzNhBKyuaSQpw0X4g2KGM6w54mcMCtYxkRE+QWWIbWIvpNWZdsDIigIdqXhNAWSnWVwqzkp5
 LuA/j97ol7e66bekksuTT5QuEdtJMlaqeOksOElLdAS1PTxIItkkHS7Pf97F1ShIDfbs7eCtp8H
 VIdtN/Ak/zkmA52l2pX2zDAEE0KPkYN3ZYsHJuxh4fUOjs20C1fvEAebAdECSfd9dF3xxgcwKak
 28y/Ac2XS6onIHgtBsRxjr4iPdipP3i+ATe1vXgzDdtmLWO4Jp1Hign/ToW2ZXEUhZit56+Fea6
 oVQGn4+aJIR9UeVvmsHExLZ9bsGkWTMrcEBp/QbcbkA41/PSGDSXNydgTvLQd6wSSFu+6QDXHvd
 o844R7fd8rNc9RZVUhA==
X-Authority-Analysis: v=2.4 cv=YqIChoYX c=1 sm=1 tr=0 ts=695d2d66 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=hvc5qC8Ar4ZKm-a3tUAA:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: Z8iFHxWNbpwZGG_aKwnRks4V3gtMoNRy
X-Proofpoint-ORIG-GUID: Z8iFHxWNbpwZGG_aKwnRks4V3gtMoNRy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 phishscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601060136

Add UFS Host Controller (UFSHC) compatible for x1e80100 SoC. Use
SM8550 as a fallback since x1e80100 is fully compatible with it.

Qualcomm UFSHC is no longer compatible with JEDEC UFS-2.0 binding.
Avoid using the "jedec,ufs-2.0" string in the compatible property.

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

