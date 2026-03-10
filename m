Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A9B372B31
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 10:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773139497; cv=none; b=Os9Zd14O6b4F6sEiJ2vre5KUSXwv/17wapSymvB1W0pkyvNkejVSKZJ3et74eQo+x5w8rxR82LPI6dd/L63583k23AC+ccMBybPKxiSc7jAvThZnU/aTv/4G2Qss0hz7uEWEEhq/kq5pos34Hz9NHcSL8lQhX+CT48iSXv1PJ80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773139497; c=relaxed/simple;
	bh=VYqZFYY1+cE3kNpEyMABsGXCNNIr/F4JFJuKQ4WCFOg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=SL2cHxBElwf0AS3M7NkKnEMnm2m1h0qX3nIFsP+5zObR/pNM12EDvdMD1c30m9JqDqjIpfg36wt8P64KzoxPzTs8xNhe5Vf3WXOI/rb16lJNwswopVz3o6vKrH3ftXdgEAU1lyZn5McArK7njSWPtrdD6Vu+sYsoTtWjxDhrDKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Swx2o5BS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CEYGHUbo; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Swx2o5BS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CEYGHUbo"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A8h4X22754089
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 10:44:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=+OlrFIqiEpL5qAomcbolrp
	dzGN+78ymBS+haaySPmI4=; b=Swx2o5BSDQ1qCJrg5GQ1QQLVLg5GRxnWm0kBy5
	KHeG/a5RnJnDUpgHsm432Nx66Py/8anHn+xyvsMvGZ2cyAC+V9QVaqb0g6cDu1c7
	AJjjycCCSjy1tf49i91dci5fyFZw9Z1AQlsFwKxMunjowpNKw17h/2de7xQH+vyj
	76UKTi7fWvoBEJEU2vhz6WXenV6Fmwiin9daGjRU5W6g4dj7gn/hi1AKue3CM4JL
	EkeLs7Xv1VUDfsq9cJenYDdO8HsefHuIclvJNMOH8eIrFU1C30dvgZx065OnyAWk
	RCQJ/cBicShN+rU5PAE04NkF7IjgZNnZqsQKYTrahBI3TDuQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctg1mrgfk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 10:44:54 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8cd81506677so1314559585a.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 03:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773139493; x=1773744293; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+OlrFIqiEpL5qAomcbolrpdzGN+78ymBS+haaySPmI4=;
        b=CEYGHUbo+8oxO97Q0RvAPUC3QWnSveMt0A6v1ez9MO19F4rYVVYQDYoJkr/IC8h776
         9hkH/vkbjNRbpBwW4KwkkLw+MfjARSw0T6MyAHdHhZ+VFlywt7s/8lBJM9LyB0MTGC1Q
         5RD/HhuBMQUydPktJb0U09L3IDw78EjQBbFK/143/NpmzX/BQqAoZEaua/IvE8V33wJk
         AUAK8jroWRyCME5e/OJo+rtdTKRFQ1gqWIEF+dfHke78VPV8oyerhrgZMbx/Lu+pW2oD
         hKSCtqP8mwFxDllinBPWTrioVj1BBxla97coTuXJzOA1gAWTwqFLFk3GkKTx8dzAupMr
         6r2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773139493; x=1773744293;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+OlrFIqiEpL5qAomcbolrpdzGN+78ymBS+haaySPmI4=;
        b=LFV+ePGHNVYyFpqjaya7LbSq7LFM1y1B8Ou7dvxubcVmvNZbFlULqDuL9VoJFT0Hws
         bS/PsET3rswzHZ0j1FYxNBbC3KTmNhOVYwU4USVkJ2L+0LAWyaIh9V7Lfl543gwpwrRm
         qbKBuwuQI1mtLa5TX5B2Ul3o+sfS8A6syqiM0wsA08HwNWI/Hzg5RedyotI5CvjZNogz
         4ZZVcsrw18EZlBtqdYYEYPuEjXHi1o3M+iW+OUIepQBKiVCvOxDkzvRXL0iU1jifsE0x
         DRYgBn5MZQOtrjzv2zk4DGWdC4Ue1GAl78nwcmeHp5HXENEWKQG1e7eSznoTVUa5hgTL
         seNA==
X-Forwarded-Encrypted: i=1; AJvYcCWJ/k8bWvjY8U3bOVXIlJ3WOLRIFq8aoSEhSI9q8sgjTebrJ0GaKBf4yFow3QsRd/pQZaFVYHNN7Xwm@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3GH2TiSsH1ZY0jKG8oK17GTCednBhYJw1HkijPQYAIE9U2mZ/
	2W+J0BY0GiWQtRZD6Zkg5hIfeJX/07R/tmyNwKXXDqVmNzC2fd6z7lQpJdimW2B7AMwZRbFs1QG
	gYPxKmw1S62+jig+RTbapFSTuS7Usil4/qGd8WnGaWDu/F2/mX1k14pXHVUX6N1HK
X-Gm-Gg: ATEYQzw06BrByUNdjY+vC23r9f2ybkym4dtqoRz1K5/oklFsy9oedOR7va1Y5UmfrQT
	ZmzciFCNA5M4sLnmvx40TmIUNZGK9vKRl4YTt4GQ0lJMNqsmhMTfEcPOUxdxKpjSNRWRQyAlvH0
	oSh34/KlMDYizbxb4rCfLEgelG5JSE0ehqXoZo7XGR2WoAIzumH6uwW3xIPeDdzRZWk8KBQ1mGh
	g+tS5SPgVlKHyquAWGMY5rrZbA5JqEaj2vaA1/Hgj0CVxqzX8uv5TQpZJUxyNFygbXAsNEobD+g
	k/AN2sc7MieEITOyYeYxiiuizY4XIGDdkVr9OC1YWdiPqS2pB5Jsr8avC+Qlnskgd/2eZVJSF82
	WSpHnjqCzgvvLm4PYlyf1H+ilfgvfGw==
X-Received: by 2002:a05:620a:700a:b0:8ca:3d7c:e767 with SMTP id af79cd13be357-8cd6d4fae62mr1741636085a.52.1773139492428;
        Tue, 10 Mar 2026 03:44:52 -0700 (PDT)
X-Received: by 2002:a05:620a:700a:b0:8ca:3d7c:e767 with SMTP id af79cd13be357-8cd6d4fae62mr1741633085a.52.1773139491899;
        Tue, 10 Mar 2026 03:44:51 -0700 (PDT)
Received: from hackbox.lan ([86.121.162.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4852aac79b3sm126515265e9.19.2026.03.10.03.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 03:44:50 -0700 (PDT)
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 12:44:42 +0200
Subject: [PATCH v2] scsi: ufs: qcom: dt-bindings: Document the Eliza UFS
 controller
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-eliza-bindings-ufs-v2-1-1fe14fc9009c@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIABn2r2kC/22NQQ6CMBREr0K6toR+BFJX3sOwKKWFb7DVfiAq4
 e4WjDs3k7xkZt7CyAQ0xE7JwoKZkdC7CHBImO6V6wzHNjKDDMoMQHAz4FvxBl2LriM+WeKgFJT
 SSl2BZXF4D8bicz+91F+mqbkaPW5PW6NHGn147dZZbL2fIP8nmAUXXB+zQhayzPPKnj1R+pjUo
 P3tlsZg9bquHzbrhJjNAAAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1406;
 i=abel.vesa@oss.qualcomm.com; h=from:subject:message-id;
 bh=VYqZFYY1+cE3kNpEyMABsGXCNNIr/F4JFJuKQ4WCFOg=;
 b=owEBbQKS/ZANAwAKARtfRMkAlRVWAcsmYgBpr/YblxyMdrh8pMJXdQyBLLqd/6N8LzUhzNOxV
 /iFoOC/l+6JAjMEAAEKAB0WIQRO8+4RTnqPKsqn0bgbX0TJAJUVVgUCaa/2GwAKCRAbX0TJAJUV
 Vv5sEACdSCn5fOXVHlKN/nGOtWGK5OCSBVM0EjPteUNC/faOR8JT0JlE3SQkXRox4ZiH9hzkZTs
 4ly33Kr22EdsMsnls+JVqMxFp+RFbQa89XxO08SIjBG/3uEYiiuoJr+YwqlVy9fgEQ53kP43gg4
 SIvj+4wn1lWCtgTwauRCLKC82c4Kj0A7+jJrt8xSgojkfPsAFRMrOnomHwTQJnAOmIgIgzeWOEF
 b3FLVilcO+HdUkgTz3A4H85OdU5KsMix3ar8GI5KKq6hpjWhhD9jZmGJ5uCo6H0VBIIukms322C
 GLz6jNY7mI/XOnATmi749z88sNP+MBaMCXKL3u3hi40xB+N4P/Hjfw/6T/1lSOXlR0rzE7FqEyA
 6ePKFjygnaBa1/G6aMfx8+lf4pipDJxKRcLMPICxLFoZbAQFfg3MBRjhToS6MiLuhT5oXD1bE6R
 dtDVCc5DnPzl+SHdEXQGX/s+rJsjEKHfTlXonXYj4g3X6RCO5cZvp4tPFuGsqA3lHNI+F7TQClB
 /8G9766M0TubVEIlmgn/TzRXi5PR67PWASm55/eIN2VapA3ineGUFUtCHr/Gr9Vx9lklScOTti1
 M00UgMESEYDHMukC1w648R6RzpFalTvzeBbFojPo9N8dV4IHx6Fdgm72QoXEAOsdUStpeK+AORQ
 l1zPE6DMosleCIA==
X-Developer-Key: i=abel.vesa@oss.qualcomm.com; a=openpgp;
 fpr=6AFF162D57F4223A8770EF5AF7BF214136F41FAE
X-Authority-Analysis: v=2.4 cv=YOeSCBGx c=1 sm=1 tr=0 ts=69aff626 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=oauzzCmhM186DRC0Y2yWPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=Xt2ahHBdTslk2qdXQsYA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-ORIG-GUID: uM1lTpyemZFe_yQ8QgGLhSMRpEg-ey7U
X-Proofpoint-GUID: uM1lTpyemZFe_yQ8QgGLhSMRpEg-ey7U
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA5MiBTYWx0ZWRfX1oOCZU/GY+ei
 4IzkVuA5H6t0nvA8WgBDDMNp08+qtfXoCA0htEOQXEPuV+2dFqIos5N8IYUzR5daIKjAL59bEdR
 JlMN3r6WC/PAgKNAfqqsgJnQYEM+d5gNp+AXzxN8D7Czh5Dy/2L8WD0oZ1Z4lJS+GcSjxI1OwZV
 VJyAA76GhLMEzbG0ye7W8Nz0FHjmVVu9bh4K9clFDnIJPEWVfb2YNhAKiD6VEYsDujMlTaM38p+
 kzS5AISWTL4HWelT+ErTYgD6o+OescDqClS5IVR8URg1PXcA4VNj8+ISHVvztMucFEU56s0/CPi
 Rk6/5pAyYSXdp+ErxIvkVeEDei83UhX4WHzxDRM3rD5WL7CDPXZRn9YPaebo0owgf7vYHnuYJr+
 Di9QtflfhQihYf5TljHPe8hIH5nd6JAZbZK5XaaWiGj26BpCFCG+IsiLHlBiAGcZXt6XogQ4Uh7
 v4HRgKT0+qV1qb6ycbw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603100092

Document the UFS Controller on the Eliza Platform.

The IP block version here is 6.0.0, exactly the same as on SM8650.

Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
---
Changes in v2:
- Rebased on next-20260309.
- Mentioned the IP revision, as Manivannan requested.
- Link to v1: https://patch.msgid.link/20260223-eliza-bindings-ufs-v1-1-c4059596337f@oss.qualcomm.com
---
 Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
index cea84ab2204f..80550144f932 100644
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

---
base-commit: 343f51842f4ed7143872f3aa116a214a5619a4b9
change-id: 20260221-eliza-bindings-ufs-2aa269f9c72f

Best regards,
--  
Abel Vesa <abel.vesa@oss.qualcomm.com>

