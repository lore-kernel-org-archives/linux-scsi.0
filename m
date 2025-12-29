Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDF7221F15
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 06:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766988446; cv=none; b=d45qzkL0TEUZ1XEcD9yI7zKxRU0YvOK3r8oV7nz9fX/AWPjdHwq+4ZkKv7CiKzSnTa/hEsNzvX+oF/d87Ge00sYujn/RsMe5lQ3a18n6qS+S4djvd87alNPahrUtxRmIFEAT8cbB4gC25wsg532PYqokKb0IxqvpCE0X2O7xFJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766988446; c=relaxed/simple;
	bh=O4EeEWUv2uTtPsYwnH9RypRVFQouYX/8tIpGLdXsHjk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p+w4hMYmpLg/2Z88l32sstrhyt0JJLgVNjh1wAFq0fJ7bFKral4kSa9qA03j7V6Gv+djNAurSLlkDAsM1Q8wwkFdzKuf4nihI41vy0mBXJp94jglVxnY2V2UbjHOi/wYTq3nkn4ZT6kmLPLTPDO1cUkgcr46760nkjXqeYLUKGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=A4cjvcQZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kRLo5pjj; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="A4cjvcQZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kRLo5pjj"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BSMIW9n3647987
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 06:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=I3hUvNAPWtt
	5FBty8NnxL5IbWwIfHhW09CY6p/HgKJk=; b=A4cjvcQZBitn+/t9xbrmC7ZYUgx
	z4geC2PKRUVjOZQHFpOQp7HlpdO4ItilGXqvllUjejD63fg988IgRdZVpuIVDfuh
	Q8qx3CnK/UNfoKaNQDthpVNGtH+9O5htLQARAEWFNUh7W+Q3bw0GLmU66JQQ5iz+
	JhDGwhKrKGA1FEov8brccoNJS43FsFnpfgDkFVWqdz5dCF1dfteXCR1e4r6DCziJ
	kIdulOJh2QNAE4T9/9frKY62ItV9ichSECAW09VPrhSI789g2Q3jWH/rce3NNpBJ
	OqWVpoUggsSSIgoPqx4qR5irdspaPOzssRA1gRdpF7SLjwOd/hLdEkoVQZw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ba6sg3hjk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 06:07:23 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7c1df71b076so17376505b3a.0
        for <linux-scsi@vger.kernel.org>; Sun, 28 Dec 2025 22:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1766988443; x=1767593243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I3hUvNAPWtt5FBty8NnxL5IbWwIfHhW09CY6p/HgKJk=;
        b=kRLo5pjjyeG6+ur8lMhIVjDRIpipagljKF8ksY7xlVSSIhQk2sefk00yVmkVU8il+p
         MH/ej4kyNp/ZBjW4jHd580Voywuat/tXZ9IRtgEW8YrjgW6VTgpgWTiw+M2atBQ4lVLR
         iaDCe1fTjHZrpYno5WPhGSpDSso2Y+mEw+DUFA+UUDo74UsN+onesgA3ARL8xTwwYheS
         CjW1vKd8jiF+bZR4iLU0gB2NPl2t+1zMFhupkAr9f6kK4Ok/Kv92kNQss4BP6nlXs8H2
         jCOhme+MkKCJnyfi6qZC3c+Koeu2ons0phhYpRs6YR8vFTAxXVH+dvrTiogUxzIhXzxb
         6I3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766988443; x=1767593243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I3hUvNAPWtt5FBty8NnxL5IbWwIfHhW09CY6p/HgKJk=;
        b=Xpbhgid/gcSjbhuutOHVLEW0t246EG5bgwqiF+hTNzGmvQUzvAlbG+2kzTSnpjDgPQ
         0tOZn6HwRKdnou2GjgkRJ6jU+b0o28VRZ83ZrT1Q54Fs7JCLjCU0K5oTx2/y3Pu10Y6u
         Hy7po0eNDRhsigDOGX/D+J8UJlWD7LqUaAK8RzvK8r1Et1SWmdBpha10GlcWDIsbGW3t
         w0aMtejuEf/AFi/zZoSMhps53BNhnoWXVm3ql64ugenSneUZF45oRZYBS+BwLO9B+4P1
         Us7Gr2Gmo+bBcev21yqh3m3nqBiyXP7VfYqGyFb1DtYT1wwQgH322uXHeg4/6Az3hK1E
         iWEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnozckTtpO4NOxFFaL+0NGQ+OHHFEATBeKrwqzBa67PmK6Ich0EIvWjuSISNGUowUO0MSGD95Z86pG@vger.kernel.org
X-Gm-Message-State: AOJu0YzUlxOyM8pz+nxc9Zw12HVZxz+CDes5fmG3nt2TfhZ+ypr1uoTM
	LuF09UNAKg7+tX++FRtAutkNPBTyWvUa9DOrSNaHd+UFV5B1YcFGq2qB6h9STuXwIHhITz56vAF
	r8xG8OzGr9bqTN3Y9FRiBY2KajmBC0p00ro/yNgk+q6ZQ9rlZgznHIy0zSf1ACkFs
X-Gm-Gg: AY/fxX7wyDxeCZuJL4wDXQNtlCKG520m3vj3iHugVf2CCNq9jj9o5R9ev+VCH5pNnFV
	7z2rlHESXtO/Kq4v8jjLTO541Hf1XUAxw49N4ZXOFyhReeBqLHkzueXmd6xwLdrxQ9elyuMc2rq
	RFowCMDCnT5npx9UGnBBs2mL3hAPBx5vCjjnQSBhj8l8cLCoF805340TsWqU/XJrWDBfd6gLU4w
	gUyjW474lssZrSExauUii3oxlSC2tl6l7bv1IhoLmixcLsZ4T0NvFIu+uu0rIWbSkDjVuCUwbtk
	g2bRRH73XpDBn51vBYs4kJJ4c0vxF8zZost9Q6YRaNBVjaJTafRgmBB1CeItof6askjpNcbKPaY
	QdnUUjDipnvXVeN2mGtmuvd0huibGVjKGVAtP63fzCw5O3Gio8yGn
X-Received: by 2002:a05:6a00:2998:b0:792:5db2:73ac with SMTP id d2e1a72fcca58-7ff64403c13mr27755383b3a.7.1766988442969;
        Sun, 28 Dec 2025 22:07:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGQjcE18QB3OL4WoMWr8IotpQbW43BKwdAOmr61bEQpyHhcwjCgEyzZ0+Kzga7KsoF96MAkwA==
X-Received: by 2002:a05:6a00:2998:b0:792:5db2:73ac with SMTP id d2e1a72fcca58-7ff64403c13mr27755367b3a.7.1766988442531;
        Sun, 28 Dec 2025 22:07:22 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e8947a1sm27917763b3a.67.2025.12.28.22.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Dec 2025 22:07:21 -0800 (PST)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Subject: [PATCH V1 2/4] scsi: ufs: qcom: dt-bindings: Add UFSHC compatible for Hamoa
Date: Mon, 29 Dec 2025 11:36:40 +0530
Message-Id: <20251229060642.2807165-3-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com>
References: <20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: vjBRR1pmXVLw1qNtn0yjSyChRpn8Yumq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI5MDA1NCBTYWx0ZWRfX+DBNxnPGgwN7
 udraEfViDEwgv50ZVjnqg8ewbXjXRU2iqGJH1Y93wvmHy4Rz3lecDW6YpERTUQR6PpyvOLc7A2m
 UYLUJ0TfxHjLia1esAKWlPei4SHK8sHzNA1K9t0vI+FxKPEHxW3nUiC4ERCwYlkVHLULDuT/JQA
 vX4QAwXdbLNBXDb6oDey7kxxQ41gOPwTRUumx04AHtDUYl0MaFM6AOU9rO9PKoKo6DDmqJDtyss
 JcZ2Imm2TkbPS7MBD9wuRu5yz/aJyvUBXGs3xrM5+a3+ncBhSJyBavz7iF/yTDn+ov2xpD8BNyh
 x5BdJ3TxrK+/125lLLuNxv5YWxqtni5l60xzvthyNGFcZWIkwjU2CY56JYX8OfS7WcKrN1IFUaB
 L4jcjkG7bF44Ty1I+XeopgSa2Fu6bQmcG8c8vemrIEDTNti93QoO1bzdYsGj/VhppnjSpJ2wmv6
 nz4y46wExObRKSBK4HQ==
X-Proofpoint-ORIG-GUID: vjBRR1pmXVLw1qNtn0yjSyChRpn8Yumq
X-Authority-Analysis: v=2.4 cv=Y+L1cxeN c=1 sm=1 tr=0 ts=69521a9b cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=VesTawrJlPzqt9UML1YA:9 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_01,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1011 phishscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512290054

Document the UFSHC compatible for Qualcomm Hamoa SoC. Use fallback
to indicate the compatibility of UFSHC on Hamoa with that on the
SM8550.

Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 .../devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml          | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
index d94ef4e6b85a..3b5a95db7831 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
@@ -31,7 +31,11 @@ select:
 
 properties:
   compatible:
-    items:
+    oneOf:
+      - items:
+          - enum:
+              - qcom,hamoa-ufshc
+          - const: qcom,sm8550-ufshc
       - enum:
           - qcom,msm8998-ufshc
           - qcom,qcs8300-ufshc
-- 
2.34.1

