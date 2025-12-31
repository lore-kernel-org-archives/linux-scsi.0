Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797192DECC2
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 10:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767176455; cv=none; b=bFxvD/PjEjw/BhB3LClPu4VxIzvNE+sYMYcqqe29FvKllcvuaFcrhL84JurRN7A/AfEigHRaVQvcZn1nEZthl8sZBsgSB7TkSEQ5NFaus6fr4vBGhGT97AFGmAvcq+h8Zk464Q9qwL4btDRwBUlxwBaAM0MtnvKB2uQTWRgjctQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767176455; c=relaxed/simple;
	bh=8WR566cU73AzIVvj5nUGmGy2ZK2KG3l1HWVhlpXkS+Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WHZR28+ImW+QdQzn4hqxrtxdfpEj+0N3Mg9nOH4MN+KS6UyasnD3+k7uoGkGAWGZxTJkb1rYmvtWSXByM1tUTNp95WoxlRlz5BVI+n6B1sDl4721lILcNZJLLflxuyxt6IHoK1BS3kJcEDwAm6YrtQ6yyGxEdf0bL0MET7uhqws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FnPRuUIT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KMmpwrXG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FnPRuUIT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KMmpwrXG"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BV0n1IQ3115933
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 10:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=xx9aZG8wIa1
	01V/TwxOXidAinRDzq5VmWS/ZoJSBsZg=; b=FnPRuUIT/sj0BxH8oV68peQye6Q
	qQ4NzHhlo4/E3pzlChIrGn7LZiYvAMDNHholCmLDyEsMtroP+6TvrsKoZaIf4NV6
	rHf8sLhWGLikqoARANR2873ZQ+OmdhplGXU/I7rJqm+igzg83Rntd6I6DH04X+vG
	x1dLwtfs3JQrNsOk7l0E1yAAY82sAtcle2xzgZt/Y1tUuU/7S3QJq7Tw2slHoY+a
	xtJjzHqZFnYbELrTgIE9NnthgtEPmiApgBLW7btJeTm27Jq7M11+4sdLjY136bg5
	G221Uo0WKDQVAeHFG9NgCSBdT96EJ2gPqkmlTPgzNZdq63XC0RZqiF+3rrg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bc0skm468-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 10:20:53 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34e5a9de94bso22688601a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 02:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767176452; x=1767781252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xx9aZG8wIa101V/TwxOXidAinRDzq5VmWS/ZoJSBsZg=;
        b=KMmpwrXGFwZqobLbDH67UDrFzFliwXGZHbyRRPGuwMxUCtK/EOoLLkZwHk1p6p+ULk
         fRKcImELatoEuHT4OXeZoMTIjqD0EBIHEkGmqu/kAS4SJIByDCrwx13LXs5zFFkoRz14
         yWf+PTG4tiwBIP2SfHrHc8hTm1TSAB4lFLFVslKJdrJ7i4AooHT3bBrGi7OFoStD5MvC
         aRGpJjYGG9XIuRNSAC4ikoA9KIvY6qfIM2JjNXoYuJ5Boj9FXi2+q9RK1rPqFZ6oYICK
         SuI2QgGXV+0QT3GPvx+j9ZEeIfdVqzy1noO8BAXupfST4vpPt1ITV1lOGHiBl13i1os+
         0UhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767176452; x=1767781252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xx9aZG8wIa101V/TwxOXidAinRDzq5VmWS/ZoJSBsZg=;
        b=sQ17ldhbtxl9znGZ5g7kf4dRBG8GV5dRH1IpCNwh+v7F31v6Kc8qJYHFmQHipOt24F
         MKW8VfLPLmXzSI59XJPWXW232zm2/xWSrEuiRLrWcae2eq0RRzW3yXfOHc9RM2otmrvw
         nBVlqeT2ALR5LKn/kq8Jv44BZx2TYEWf5iYQWFk6RAj3Sl/Es7Vt+eJNWEUx2zIVRxAs
         7OYki9RrK8TckNni/VnUSL3H/RFnjpQoQDkOkaBakZzFVcvSMJh1Be9m3v6eV4RRNN6i
         Exd98JmO+qmU3V5FtBNA5OyJryBwX4pIWOYvEZTsoaPjwGUwZdG7QuoD7nANTgORH9Sk
         I/XQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzmW9otQDlpnFl539uS6Pk/PqRUJLyVcZLgZvtrUgqV5cii/Apkyu1ZyO/036K3XEaXicSQno7rTOF@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5RsHkV00vyTg5lyYKqwn/gG2RcZnE5xROeMNcqOj3Tr252ppS
	41UY23azBlMvYbGS3MNTojhszXn11z+UfrpFE1emtM0KUu32Kmd3UFHFRMa5db6VUA451frYeKN
	apUbfgvzoPSqj7Y5+pImtl+VBVQBKCk/1GzNQTQKvO9Yg1ks/rT+6myCdFRggfwjr
X-Gm-Gg: AY/fxX6zNZm3A3XdQHsN1OZKRlwHeWtVi5p0Z6liyjk3+qWQ7mECNFyqgRDI6GEABQ4
	q1O8J2q/1COhvmTvL+RNpIHMEoDv1Bzb76JtstIKRQIWs50/dJ5yTfj6wa0YB1Webx+IswD0TB2
	7ay0+eALiYFcRF/vHdtc18VjpQb5+iYkF3dHDt5s2aonwlQH5Qq1fCjxp6DAwu01RPryHtvenBg
	+xBhdFSDrKdaSuEaPjZHa7clnIpE8NJvjl0GTXbQgDPZitJrQgGz16uH173sqeOHYExc/+E+ym7
	ueydXobyMsq8amYhmYnz0f/ySFgfdgEaYuauwaGyY9XxeR7E9mNlhcVxaUtg6ld/dau/EubzNKf
	e4mJyfYgRTEVyXg1fnSLIA4M/ZDgEyHnRL0PrTiIFWCmSQD03ugW6
X-Received: by 2002:a05:6a20:e210:b0:352:d5b:c427 with SMTP id adf61e73a8af0-376a81dc79fmr31125195637.3.1767176452287;
        Wed, 31 Dec 2025 02:20:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG6ef1qNkB4ZGwXjGOPHg2/nLF6kCSrBmPw7ORZ3kLabBKQWgsNm0Fbe+7WBYD7Up5GwaiDpQ==
X-Received: by 2002:a05:6a20:e210:b0:352:d5b:c427 with SMTP id adf61e73a8af0-376a81dc79fmr31125178637.3.1767176451804;
        Wed, 31 Dec 2025 02:20:51 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e9223ae29sm32163920a91.16.2025.12.31.02.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 02:20:49 -0800 (PST)
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
Subject: [PATCH V2 2/4] scsi: ufs: qcom: dt-bindings: Document UFSHC compatible for x1e80100
Date: Wed, 31 Dec 2025 15:49:49 +0530
Message-Id: <20251231101951.1026163-3-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251231101951.1026163-1-pradeep.pragallapati@oss.qualcomm.com>
References: <20251231101951.1026163-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMxMDA5MCBTYWx0ZWRfX9YLou818bX8p
 Si/eyzp/cfsTUgYW7KZXrtiwUpWrrhFVmM1MpCAPZVQt8j9zAdX8NcP0rCm0u2tBLgIRhH3azpw
 ue2yR8Cv5OJfF/uwD55obwXBEbcxUOVIj120N3UKnLOgYBaiPLdUF/VmmfJXgPEQLE3EM878iqi
 rhgo4Q3kVqkIuoRYtIvHdxFUCDT9EJ+kvpfma5+VlYu59pB0VH0c7JPAAJSubWaXrS2yPDENL7w
 kroV7A9hUNkKtvXUK+B7/kZNhmbAMq9xYKMZpHE5v46gKyKf0Igcl6JyEk84FAmmcHJS0+MQPqI
 7vplCv5+iJTEG0sa7IIzLKyh/j6fTNZ7ZrVqBOgOPXXs/I5ysTfEa6HB+B/1x79ROcIYKW1jMPa
 YbqP3g9BZkLJUGlcx6yiZvSq62/hEkfFrg5Bn03QHExaD/8gn8gI8Tl3xMXIG8NxiOfGcvnqI1q
 0aVlUjikw+fnvhkvntA==
X-Proofpoint-ORIG-GUID: td95BQViEzbYmAQsrui1-rw3B3e55lUM
X-Proofpoint-GUID: td95BQViEzbYmAQsrui1-rw3B3e55lUM
X-Authority-Analysis: v=2.4 cv=FJ0WBuos c=1 sm=1 tr=0 ts=6954f905 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=y5OUiIJSVdG28iL48i8A:9 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-31_03,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 suspectscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 phishscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512310090

Add the UFS Host Controller (UFSHC) compatible for Qualcomm x1e80100
SoC.  Use SM8550 as a fallback since x1e80100 shares compatibility
with SM8550 UFSHC, enabling reuse of existing support.

Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 .../bindings/ufs/qcom,sc7180-ufshc.yaml       | 38 +++++++++++--------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
index d94ef4e6b85a..0f6ea7ca06c8 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
@@ -26,26 +26,34 @@ select:
           - qcom,sm8350-ufshc
           - qcom,sm8450-ufshc
           - qcom,sm8550-ufshc
+          - qcom,x1e80100-ufshc
   required:
     - compatible
 
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
+          - const: jedec,ufs-2.0
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

