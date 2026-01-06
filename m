Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A0433A9DD
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 15:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767714152; cv=none; b=kyd4tmp+bAoI8AzpXC4EgOrKEKSoI7cCTnpU6QymdqmNX2MR98VTiqNqqwsG7o8on86YYq7ZUCN+yQqMko1wPg2Yi+1/dBwoQaEp5adrRga+8+0nHQHIgDCC81nO+8TaPLHMwJTn4FuagrJXPpcwx73oLmGLlH2WvbF4Wdj1KJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767714152; c=relaxed/simple;
	bh=ZPJGICzg/PAxZH8bSEPQLz2TYwfgDekPYOvxH6T3IeU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MKolimIpI5gT0txVmSE41+GJv0s7DNmYYqsVL08nwwBTlzzmQd1ysXvVlmwOGv/ErCnserusvUP66hmnlfYXvMDmJhyCCWYOfdEujZm/zLP+hGqq5OiXA3JtWYN14hxJltL6vI0pSP0TUKdGg3mNB3V4jxmY4lrXR09DVjJ1+H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MLDfCaes; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iNITIDP9; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MLDfCaes";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iNITIDP9"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606FKpF0185361
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2026 15:42:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=YESivx2vId7
	pgvI677Lj8GeC8AWBep4KbqgfD3sAVdE=; b=MLDfCaesEqrocpF/1zem1nSU+w3
	I84gJq2GbTFDOdCuerlVlxGrQulwQdQraGxMayP0VRYqTursSIOIOoDDzzdAr37i
	p/mDj+xklYiS97QjLXO29ColTScvsTLkHwoVxmV4EAQGkW0qGICFQwFDL7BXdnrQ
	sFRZr6vzo20INwVASPLwSFHAQOSgrWix7AMiEYJplz/4Gq+g65YbcdnNuZCkBe1M
	LB652m+nM4MGVHeoD26HOjpn4FBEU7YWB4VCEhUUyOWBGN7obInDEauEcsJLnHdb
	24RVmIit6jvlzxjHAzaOabz4LEnAU79a9VIHh6rrwrj4YQ48GQdVAZ2McRw==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bh4y0g24r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 15:42:24 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-29f1f69eec6so13186455ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 07:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767714144; x=1768318944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YESivx2vId7pgvI677Lj8GeC8AWBep4KbqgfD3sAVdE=;
        b=iNITIDP900XeZxhBx1MDnAkUIB4CWc7hO6qTpunR3FBNIEx1ko9zblOBycKQ9qtU8G
         fnZSWXDl1clS7syycsu4rjzrRntE5mDsVrRzMe0cGhiNDQudqZ1MNHEC4z7+i3Z/6x2l
         0dFkaOph2cc1YTkEh64WCB88tScFMt/BU0nVqodwXtGjrrZjDjEB7wGWeMbNcY+j1Cd2
         MbKwhLl+BctOWVHdhyiWx6SeYrIiY5sggr65FjZeoU1I8RMVNBra3Tfvhekiq76AiqH6
         yEnuJXrErso36m4j7f7CFSg4L4P1war1O0vfmuDG2QbYa+L2R/asYaPTSlpiJMUU+HgT
         birg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767714144; x=1768318944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YESivx2vId7pgvI677Lj8GeC8AWBep4KbqgfD3sAVdE=;
        b=YDY+aesnPqyMk+ZsL9EN5PoWudiZFZ8u2fHNXTxRvrECoxgUaDRi1ymPLpbDYx/U5i
         m80uF3SWyPHOSliWGeSQNiUVeNnIeWyrggu/uC7XWQK/EI2WkUwQbAEVFsq/MHmji4zo
         SGFEs5vV9KcU69mbPqb9fMcU4/1DkcHrZ4m/0AgeL9GdcQg5VqwLYAskJiSKwhlfnw4V
         5qLE9jFnND2Bb0+7+O/3a4QtRvjeboD0nQGA1DB8vjz5S+OqmWWdmtmKwp1KxaUTS8GS
         E11/RPAfiFDWszRl8bvzTOHn1tyo3pIE2mK1Ot1TIyHMIT0+DpQo4KEEMH3MPzcnsuCU
         LQqA==
X-Forwarded-Encrypted: i=1; AJvYcCVA1EUU/WQFKCsbRwm28Ndc3M6KzifX1sU/wJtyGHeKjH5r/8LWfL4gnc4K5b4hedO28vHr1h33aPPb@vger.kernel.org
X-Gm-Message-State: AOJu0YyBCKFpF4sX6XJqP1M+KaavpgLyJVeYDpGeI8YMosfA4RxPp/cC
	iY6V1Woc10k7As4mIq6E6oy/SKmF7oGjMfLOIW3odpP0Es4gVr3Xszjpa92E7Ay54p8SFj4Hgsg
	s+6TVRx3T4cXSyBuH2oZ6LafCH8laNoSOFTqtdjBrPcu0FUZnB2PD5JM81dwzs7ni
X-Gm-Gg: AY/fxX5qLsGkdPYCgUUq1s5KntmnF0DSVxmppc7AyI0GSHxm9INg6tq817XCb/rSTVO
	93Ahg168Ib4GU/l4V4xvk9eiTN14aFGbN0nMgBXDXZS1WDUt20EFLyj9Eye3AKdg5XBvXVtEf+n
	VQ4WhOR/QyjOH7DYbpQJm+aWyEOn8KjxYrorgH/HKuqF+2zWr+UEz8dfUtDeKAsnjEKXUAKiiYq
	10vGZSxRg7/OVZIdI0SW5ai6qVWPtCdf4l/JpSCpHGgpGCTpdZokOy/UVQkK5b2bB1AHQJCZmWh
	6M2awKxLUYEJw4+xPX3Y1gAaKpR4Gx/nDRdxtR7WFxaoQ0pkols4JMzIYjPa97MMfKkZ41AbhC5
	oAb7UOCxnmGb5xxof1gTs24yfgxmg07cdTkOO+3zmlRIGeDudTTr8
X-Received: by 2002:a17:902:db07:b0:2a3:1b33:ae30 with SMTP id d9443c01a7336-2a3e2d2f36emr21943595ad.51.1767714143935;
        Tue, 06 Jan 2026 07:42:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGay4nVOi1x4DbIYZyz8vZ1XzEs0+0iXhI5PWvt/W510lDGQiyOk1gcoRq7cSfvhWP9CNq/Dw==
X-Received: by 2002:a17:902:db07:b0:2a3:1b33:ae30 with SMTP id d9443c01a7336-2a3e2d2f36emr21943305ad.51.1767714143388;
        Tue, 06 Jan 2026 07:42:23 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cd492esm26606395ad.98.2026.01.06.07.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 07:42:23 -0800 (PST)
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
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH V4 1/4] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add QMP UFS PHY compatible
Date: Tue,  6 Jan 2026 21:12:04 +0530
Message-Id: <20260106154207.1871487-2-pradeep.pragallapati@oss.qualcomm.com>
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
X-Proofpoint-GUID: DdMKA30Oyn52hiLf-IeykzttScev9Tux
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEzNiBTYWx0ZWRfXxOJS4Gl93gXd
 QADPw75GnVM/CiE8O9yR7HKXHiK/eSaFPoVgjvZdalnXLkC+15Sb/iSId/GjvXX9gcDOcKnU2hv
 QGQdLR3KkCDSu0iTgNi4Y4rQJzgMbl5EQD6mwFoIToSeQEbFQwASqY60pFCn/o67CHlv2Qw94ll
 UWOZB5s1vcHK2G/eEqYvUgfoXDNTWtB2J+3ChOFhYEfFJuQzEkMBs2xW2UOlhfiDSv8Z39DGCUF
 2qvkeUFOvhv1VBtVnukqx/tT5iTPGoRXm59Rjr6l92vZhcBPJ0YOgHsWnROGzM/X310L2nnWbA6
 8PK+Wyub6RRNh+NLYPpG7t3WOR909oolRs1iVdBIBALwaWZQCmzy744n7w+N2Cv8wsIAQBmaJZC
 bKVZJyu6X+GxKTq7yH1pXU+mYdyzN1OeMXLlb+lhZYblqpq2xz7pLFna5HoPYPsAMSk4OPYBzHx
 OoeXKOUE9SZjXZ9amew==
X-Authority-Analysis: v=2.4 cv=eqnSD4pX c=1 sm=1 tr=0 ts=695d2d60 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=Csm91wPUG_1LpuPihvAA:9 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: DdMKA30Oyn52hiLf-IeykzttScev9Tux
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601060136

Document QMP UFS PHY compatible for x1e80100 SoC. Use SM8550 as a
fallback since x1e80100 is fully compatible with it.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 .../devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index fba7b2549dde..166e3787db58 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -20,6 +20,10 @@ properties:
           - enum:
               - qcom,qcs615-qmp-ufs-phy
           - const: qcom,sm6115-qmp-ufs-phy
+      - items:
+          - enum:
+              - qcom,x1e80100-qmp-ufs-phy
+          - const: qcom,sm8550-qmp-ufs-phy
       - items:
           - enum:
               - qcom,qcs8300-qmp-ufs-phy
-- 
2.34.1

