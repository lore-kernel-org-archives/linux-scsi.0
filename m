Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8A428980F
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 13:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773234255; cv=none; b=EbMQjvWAtnZEulOGlH0JcYd6H4ynbuP0ru+BDrDfOxseTaraxsVPtMBGLM6Zkqimb9Xl+sAfeRsAiqDL2T/S+C9XbaxE3MRXMvOkhKXa4mgNtbU+tSFUthnpbvMCb8I8gj7/MhGLQfUzqju5GZqP0I2qFsDIicWLKJWEPMYTjmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773234255; c=relaxed/simple;
	bh=xd2XtyAY9XXyEH4XMfiLJMLCPQEaqcDJ2L6wyjHLq5s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=uBtRVqpF60hL63FrnqBYl8jRLcMLkeY1vHDvudzZ+Nmabq80d1CCjmRsSnehcTuK9b264MpVPx466y1kcCa43DZx0u7NGqHUXy4CuZQLwXyG4JUwLxOn28RMf2eulmGk1qapqN2iJdaSktD3w7bcuxL94JSNSTikGRVnKbh2yfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IDXE/T0f; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Q3DRj8+Q; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IDXE/T0f";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Q3DRj8+Q"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BAvAhS2622064
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 13:04:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=cw5EY0xtoLmcOoRPIjdHzf
	xH3MGOLatzimYNmV6xPh4=; b=IDXE/T0f2+vc/iKcN9LXV0GqSgpcDxtLhBEJ7y
	O5XIcOhzVBDTlj87wjgka/FYmUqMaBZW5ujh7jICApKi7dt+jbV0aMWUgApRKVvP
	H1DF0xvrYiCm6ufXe7+5/oSZ2PV3wn4T8Uz7QoZNNEZ7ZaJxvbMSZlHstvK6fhlz
	Xp1MfvwQxcwpKcWZhDaYfgwvo/cfyYCktVJLm1Pdv8iqiea4NOxGFrhZDVwg2OqZ
	nvVS4/C1AjvVcJ4JMDJMuFLC4hWjsxZncVyVerzdzEfmSiRPAOxUn4CwjGZbY0UH
	l5HoMTaJZkN8bu2ZpBk0KKPz4huLpg+37CDAJx88BCKH4UbA==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cu73h0d28-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 13:04:13 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-5fff50a4ac4so34204174137.2
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 06:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773234252; x=1773839052; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cw5EY0xtoLmcOoRPIjdHzfxH3MGOLatzimYNmV6xPh4=;
        b=Q3DRj8+QcCOdLS9XZ+qfH9fyaVs9VPnlCLDgkZLBOvS1cPtEsUqBnP7kqjr4s1upAj
         DqJbD4Bv29OopOBwevm5l0U4YaCCVQZRcQiwf/LxvJ59JNXxFMGUM8NASr0sZUc3Bi60
         lr8tR5RcoCHT3OSB7giHGEJlYwCj5h/y599gPCrIravbzcLRxkkUZWN2R0itDKlCsrL6
         /GVVjIoIBgZd6TIPfhk6oB+xcgdy6KcjWLpTVoROoSukcL/66ZuFfWDku4CE8WVVXVU7
         otVkonlhWsrUuQxVcXrm3HbgXIrHBTH813l5L0B6zvb9SqVH4ra5DRBbQWNwIoPQoqRh
         J1QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773234252; x=1773839052;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cw5EY0xtoLmcOoRPIjdHzfxH3MGOLatzimYNmV6xPh4=;
        b=hfKub6VVyljSDAjrzuMrYqlbaKzG2mMbl9yNbAnHdLyTuCXsekTDOOXVaVyE5bIQhr
         8bJ4qZuM7aLVobnFOBdxFA7BZOInqwhEoifYgu4uoqSpfQIINIWGt/OtTwfNRThB0eJL
         EbsmzPsorm7cvmCELKlNySUiAE889NBLgm06+cN/MWMCOrh3Tu5ajN1FX6S4KO72oDkc
         Ssil1hs8Yem14J+or1th+ipsB9M4AoVfKHY8gk7hguZ9ZY2486EbaKLrUsJbEQv6J/IE
         5ytBzGxGk1Kw3Y3rxnLtzDzqavWjaKOkM4nx380MnVZhBWQq2Ppd4Fb3ki9kYwpbWKNU
         N6mg==
X-Forwarded-Encrypted: i=1; AJvYcCWPhM3cbQ/xkhY6sZA3VWd7197q5iLO/PoMYKmV8ejjJsinAgBxRlHsFx8O09TTDQEnnhXhrDeMWzQa@vger.kernel.org
X-Gm-Message-State: AOJu0YwY0oK3rrVCHuEDWGl/HZnBrm81sNDpD9pxjVk+Qu6vSomgDto8
	UOrPQ2EWhYlW0oLIW6eXaZJ9pGwZUUWeGh15cHogLCLRbhetuOjNJkqFG5ebT3fGxEa1V19owsV
	ahiUQ/janMlK4Yo8H/10oDwJYMY8gBPctvBOlckDWI45P8v7B4QhZgqJKFxOqsL6g
X-Gm-Gg: ATEYQzzS811pKiOKWoiCKzCNdjdj9Z9+ZWCZKodMsNwKFvDFzbFlthfLXC2S/rMObNd
	0YvqbVCXM0Jv//koSathBS+g4TUroFCPL+S3dWs8uEpFmYdBrR/n3+OQOTfXjbjHZApDYWOTlnp
	ojYQ2Rrb9eX+ptzfBic7OAp2iMiC4HjIGXs+77p9erXwart47iUBeTGrUAmueoiS1GsqEGBNEFC
	iY3+TKNva7fsgUls3BwxxxZFT1zSidzEN9rqPG3wuGKZkeNCzjkAbnTPWK4A18sN3Yi+vg+Ryxz
	5wByx61Yod60Yt/cLuIYobklk7SnCjZ2iPOyxHvEtyDbYt5SEb/eUGA4ht0HfGtvT3hyOOtQ3Ia
	wPkTCmSVE6wIdeA9RV5S8Bv8PdVUkCg==
X-Received: by 2002:a05:6102:374d:b0:5ff:a8d6:b810 with SMTP id ada2fe7eead31-601ded0a1c7mr982282137.18.1773234251853;
        Wed, 11 Mar 2026 06:04:11 -0700 (PDT)
X-Received: by 2002:a05:6102:374d:b0:5ff:a8d6:b810 with SMTP id ada2fe7eead31-601ded0a1c7mr982222137.18.1773234251231;
        Wed, 11 Mar 2026 06:04:11 -0700 (PDT)
Received: from hackbox.lan ([86.121.162.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b66e3f8sm49499475e9.14.2026.03.11.06.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 06:04:09 -0700 (PDT)
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 15:04:04 +0200
Subject: [PATCH v3] scsi: ufs: qcom: dt-bindings: Document the Eliza UFS
 controller
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-eliza-bindings-ufs-v3-1-498b26864182@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAENosWkC/22NzQ6CMBAGX4X0bEm75Sf15HsYD6W0sAZBWSAq4
 d0tGOOFyyaTfDszM3I9OmLHaGa9m5CwawOoQ8RsbdrKcSwDMxCQCQDJXYNvwwtsS2wr4qMnDsZ
 Apr22OXgWHu+98/jcpOfLl2ksrs4Oq2ld1EhD17+26iTX3S+g9gKT5JLbRKQ61ZlSuT91RPFjN
 I3tbrc4HLZ2JviblBS7Jggm6Z1MvNVCaLtjWpblA0JPmqkXAQAA
X-Change-ID: 20260221-eliza-bindings-ufs-2aa269f9c72f
To: Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=2120;
 i=abel.vesa@oss.qualcomm.com; h=from:subject:message-id;
 bh=xd2XtyAY9XXyEH4XMfiLJMLCPQEaqcDJ2L6wyjHLq5s=;
 b=owEBbQKS/ZANAwAKARtfRMkAlRVWAcsmYgBpsWhGu5DxXu7o5C9xDVMyIwf3BoRysV0RrfiEg
 O+P0nseAkKJAjMEAAEKAB0WIQRO8+4RTnqPKsqn0bgbX0TJAJUVVgUCabFoRgAKCRAbX0TJAJUV
 Vv2wEACpk314AwURQb7MOtYmAEreShUDwirtqi/NbbojYcEBzIx3par2mwdpmr6VI/GuRHy5c4S
 1XktYOek0xQm8O+EuDFcQI4MAPf9o0sOPU2QpVJw5ypO6bpgY3svIBE2ughY9j3beX/9gMQLZ7F
 W6+wgnw7DBGDrFvXiV+kJqzEt0K7wJ27DChgYzIUyOjikpetSj99sD1xXXj3zzS19OOfORXeTaq
 p+VRpD2OFjEhNbLhMJ4Q4qzdRu+CgbR91eft382S31HtjcwpPS/7P2K/r1VZQj8ieBq0ANpMQrL
 8PSjgfwc0Ui5/HC+BLJwLisJylyJ6GMoj6lCx2Gm5lQNHct2CFFE/OKHGDCOyABQUR4J+dcKTup
 X+9vbEEfSKROJEa++kjZvo7HT0vyneJ8WN3drS9uAm30qE+1hlYWDShztM+H6XsFY3lHEWgZy4S
 VeE36O70CrQ6ZU6eXk1RVxb6oZL1vk8W++5pIrkEKK8JXwuamABxOVsLXYU+VOOKg3oZccXhCft
 dxIdbqmIXcNVXsGEx11Guf8ACvZqVNSM4THfCxE+5KHVoUkeIqOrFFJxvStmJxHKGm+WxNDgOpY
 XMO6Khem7NhvOhrGdbiE/T6cPb5uPBQKqEBxASp6S4MExi8DTf0Pt81OPlUWKzeR/RbcabVh8L2
 14cxafR27Is+59Q==
X-Developer-Key: i=abel.vesa@oss.qualcomm.com; a=openpgp;
 fpr=6AFF162D57F4223A8770EF5AF7BF214136F41FAE
X-Proofpoint-ORIG-GUID: cq7LLX8jdQMqPd-7YDGhhcCGba3KehEk
X-Authority-Analysis: v=2.4 cv=T7uBjvKQ c=1 sm=1 tr=0 ts=69b1684d cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=oauzzCmhM186DRC0Y2yWPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=_Xf4zqdJOLMdbiFZgKIA:9 a=QEXdDO2ut3YA:10
 a=-aSRE8QhW-JAV6biHavz:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: cq7LLX8jdQMqPd-7YDGhhcCGba3KehEk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDExMCBTYWx0ZWRfX2GsX8fWdN49u
 Tw9lVTIpersoU9vediBzym2CS25zsak1JegDVF+vwYsLZBqyW3M2XGLUxqBcdQMBkUgOKFVbpSE
 HuAZ0KgZHPqGIwxqLgRxyaldbxxsPFOJ+HZdJqz9uQoxNseBgQY9krN2iAd0ArAzYEbCXJ+bUug
 FbZNvmyuJ8NDKsyWzGl9vVqV+uGDQHbv6h9+pV/3GThbvaT67WXiPhluLh5utOiGXLAjmXNgnUc
 5lHen2KQmveqtsXlveaEaHiGJ/pxuDgoH69W8ciFYx6ykO5eFST7kNsbt3jyFOratPzPJ7j7g0B
 fwyWMnO650ukkPD7baa8calcZiY8A012UslwL4ZnQcMUTKE1qHlv87t5s8QbDtPbNjKDGnl9Onv
 PG0a1dGR2OJyE3M/f3rZ7gtx/uRq8VWrEzXNvldBxgeKAk9At2BoDS+DgMghn+PoCrcHUL4zuCi
 hwqrg+idDegylQjKJQA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 phishscore=0 impostorscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603110110

Document the UFS Controller on the Eliza Platform.

The IP block version here is 6.0.0, exactly the same as on SM8650.

While MCQ reg range is also available on the already documented
platforms, enforce only starting with Eliza.

Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
---
Changes in v3:
- Constrain the reg and reg-names properties so that MCQ reg range is
  required, as suggested by Krzysztof.
- Link to v2: https://patch.msgid.link/20260310-eliza-bindings-ufs-v2-1-1fe14fc9009c@oss.qualcomm.com

Changes in v2:
- Rebased on next-20260309.
- Mentioned the IP revision, as Manivannan requested.
- Link to v1: https://patch.msgid.link/20260223-eliza-bindings-ufs-v1-1-c4059596337f@oss.qualcomm.com
---
 .../devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml         | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
index cea84ab2204f..f28641c6e68f 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
@@ -15,6 +15,7 @@ select:
     compatible:
       contains:
         enum:
+          - qcom,eliza-ufshc
           - qcom,kaanapali-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
@@ -25,6 +26,7 @@ properties:
   compatible:
     items:
       - enum:
+          - qcom,eliza-ufshc
           - qcom,kaanapali-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
@@ -66,6 +68,18 @@ required:
 
 allOf:
   - $ref: qcom,ufs-common.yaml
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,eliza-ufshc
+    then:
+      properties:
+        reg:
+          minItems: 2
+        reg-names:
+          minItems: 2
 
 unevaluatedProperties: false
 

---
base-commit: 343f51842f4ed7143872f3aa116a214a5619a4b9
change-id: 20260221-eliza-bindings-ufs-2aa269f9c72f

Best regards,
--  
Abel Vesa <abel.vesa@oss.qualcomm.com>

