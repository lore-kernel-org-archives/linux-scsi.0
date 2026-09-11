Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D374A5EC1
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 16:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789145254; cv=none; b=bc+75GR8y6gmjJKjxMkR5blKwJzMcd/YYDrZeTSG1oAxbVD+kPVuI6xoCoSn/lHSTTV16s1Uv0y9aqGuFRuN1HtKEo+XHj/WJkB8gfbLl9Y4KmvYB0+5adqSzOOwvEHaKZRvT/dpJUSuTqMBclLZlLFDfKdrWetjoqouCpMxrDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789145254; c=relaxed/simple;
	bh=cGF4M7H2BWDSkfXAPdpNOY2HONhPgqyoW2d8CtFkC8M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kZNExe/7gLI9Z2df/BN4rArhmtTao111s48IJR1W54SoDq/+pyFhzlnSuKaWAlL7X9GFk/40E4GTOlPZPeNo3jelnX3mW54mEYQ5f7zV5RSNk90NJe9sd9EBha288xXZDEPUOybWfIBukH6MCq1dA/p0huTLuT1V4JEchVY5Bwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UJyok6/l; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Pe6tq1iC; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UJyok6/l";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Pe6tq1iC"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68BG43SY3426877
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 16:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uihisGELWKJXs3ghPTChJvWF5WlMaRjqVwCduuDVyXE=; b=UJyok6/lz5rH1yy0
	mHE6FTCwqUrRqNR6Y8heDrqlvVTL6ahujHmMUpR2CW+SgmflvBDrwmhRB0M6SQzp
	+ZkI8MKkdT8WMYmv3g9qlf893zXNSCEruGmsr69KrQWXQZLtFBGpAHLDagDPM5hs
	tWMyExZD3tcYu1Y86VAMk76xHXQlMSMY8JXAlbNqYKJdgli0KqlZADbxd0gqUu9k
	TRTaIDoXMKpP01pI6Ec+g/ebF5BMuAeMaZ6g1bOWZtk+MSGZbhH8No7388K/vcrC
	wg8+7DEj8Oq5lWUSyH21I1mG3TDkXwPaodD2Ii0GiqbvUt/486dZ9vLS8/V9nT3p
	nDZTPg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmmubr5g2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 16:47:31 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e54b6556aso1575918a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 09:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789145250; x=1789750050; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uihisGELWKJXs3ghPTChJvWF5WlMaRjqVwCduuDVyXE=;
        b=Pe6tq1iCgr6EdxShSP2vGCLkBAC7xslzN3oDJJtrD4zvtD1aDj1c+GeqOXQUeaUM6Z
         M764tMnLq0OFuQhb0qo4gWtYy7fnbIPKzOpkyKXqZpIgm8d4n30hbV5aKf4uF9uNJCSz
         Jy7t1UNpXltx6tvg9rwRzO5UktLYDW7cvKNxnScalKOMEjXuqLFXBS+yzW+8UfIkPIB4
         m+XSnf9vRwp34FI+WiaZOXL4HYnsFvt8OneXrKejWn42K80BW53hHVGz4zAhsxjnQw7k
         aJYlrD7CyQqCbo5C9xbYPyWjhb6xAdHQ2057B4n/wpiKqPdcQvYGwelkguvzO8xNAod4
         Ws0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789145250; x=1789750050;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uihisGELWKJXs3ghPTChJvWF5WlMaRjqVwCduuDVyXE=;
        b=seEV1Ju9DjIAz6hTd+4VBP+lKBl3Q4Qcam/QThKGCnYtMwjCSiuCdyo5Iy7Ezt8Wkw
         ZiOkUSSSygZdAzshVWAiXAPB7ogQTIoRECzT9e4Pu+r8l5eQMJuneTEHJnJdE2foc8C0
         /QWI+nTZDSP9SCC/fvh5xpozDfWYtwSzMB8yDfMgkGUuaq2BxO86le3LjllVfqWmBN0z
         naoNxZsZicvqwNSnqAl692zC+TqD2gczVBPRxY/B8ecr36sL7hnlZOcPDuuVVw0rax7q
         hhlmFb292INf0eqXKoEneSZhNNkWyX4CRNFekuxyTqofFclP7As3wgkdPOuSdpHC6pOE
         lmiA==
X-Forwarded-Encrypted: i=1; AKwUvBxI5Y3X+iXYtweAP7JPZ0OtJ9GzVASgLjBdFpGOMIGto22/Sa3GeZHgoTYajL7HIr6S7pKE8xPi3U3C@vger.kernel.org
X-Gm-Message-State: AFuF++kIIcSUkbtzgm1wW5Y6dee5Q7gVxH8XLFgGWH/Br+wv6R+1vzsh
	xMZ10WaTSQ+/y6lRBHjpcrK/MKNTtjGeksIWoldQfSbadP/RvEWCioOMCczczLLU92CYwFpAwCn
	lJ3jHCC7HAi9UnyNzkBMyuitZ3Z7KE2jzNLc6TJ9/tDNzHgWNglcltU6gngB2huIn
X-Gm-Gg: AYBFou2zXF8LwFRdNS2dEUexWxPjf5vUkmow7I7oVGPIgPgkLEdavMMbbE6Y3bcDzLs
	lFJXsChLsrC80COsIZXaq3Tq9QUVY/5golEsh82ru587631G8zbefE7cC8OPsG1mdwguDi+de3y
	gloDXmawy9QpgaUO7hvk7QPNxT1nSzKK1F7uUfHNaI5xncWlYgiUsJ7L1ABXZrUbEaRqHfytOdc
	LnjcmELrrlqEhYvRpHLCQJatMFeLaTrhR4nreABrSS1/S9vjcsSYXduAllMdPMdZYKkiGMEYEfc
	Yocx+6CiDo6L9qXCs9S0MJvs3xZdUCckAawkEgsWO6FMseX06e30BEg4Hl/ylKQG85huZE0ePCn
	VOQmHM8msh/cTjGcyvhxTx/GwJA==
X-Received: by 2002:a17:90b:518f:b0:38e:97f0:aa4b with SMTP id 98e67ed59e1d1-39d9c1bef27mr9067192a91.13.1789145250465;
        Fri, 11 Sep 2026 09:47:30 -0700 (PDT)
X-Received: by 2002:a17:90b:518f:b0:38e:97f0:aa4b with SMTP id 98e67ed59e1d1-39d9c1bef27mr9067137a91.13.1789145249963;
        Fri, 11 Sep 2026 09:47:29 -0700 (PDT)
Received: from [10.213.101.15] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39da64d4bdfsm944193a91.0.2026.09.11.09.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 09:47:29 -0700 (PDT)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Date: Fri, 11 Sep 2026 22:17:05 +0530
Subject: [PATCH 1/5] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Document
 Glymur QMP UFS PHY
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-glymur_ufs_qcb_enablement-v1-1-b9fc5e2ee99a@oss.qualcomm.com>
References: <20260911-glymur_ufs_qcb_enablement-v1-0-b9fc5e2ee99a@oss.qualcomm.com>
In-Reply-To: <20260911-glymur_ufs_qcb_enablement-v1-0-b9fc5e2ee99a@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789145236; l=1139;
 i=pradeep.pragallapati@oss.qualcomm.com; s=20260911;
 h=from:subject:message-id; bh=cGF4M7H2BWDSkfXAPdpNOY2HONhPgqyoW2d8CtFkC8M=;
 b=ScVpIgOtIpyh+zz/FM85IaQRzpO1CYWvF3zezlK70MQ69qTI3KN7mM03N0ll8YBeXAIO3HOSF
 RmtA9jO4UcZANvQVPYSanKloQKp30VzV5xrSHH+j7kz03E9iCbd84gg
X-Developer-Key: i=pradeep.pragallapati@oss.qualcomm.com; a=ed25519;
 pk=uyRUsge8nQMwf3iW/e/o0U8z9nWLCMm1MGKxEftztic=
X-Proofpoint-GUID: SYFrglSif9yYqVAnVhZU6CCkY_TDg-V4
X-Proofpoint-ORIG-GUID: SYFrglSif9yYqVAnVhZU6CCkY_TDg-V4
X-Authority-Analysis: v=2.4 cv=dakVTnXe c=1 sm=1 tr=0 ts=6aa430a3 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=BahsdhlD1VgbZ89a8f0A:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDIzNCBTYWx0ZWRfX0xGyAqBGE6Ug
 L6yRAF9zyUJsNJIfN391T14ZGvnmFnMmYbDTz9OnPNsKIl2DL1Tj9z2wO8Qyq9a5EkAW19sB5Z8
 1NxxU9VZWwEtIQV8i40AhSMwSEFJdANdNbmJcuYgzMKAugb/nd8RxgyjsmfpUVJIZNKV2Et72na
 L9aOv+n20Ywn3v1/lolxBo+bM8T0k1gJxu6exemPHeFN/HnL81XIJVhlw2t8O7wWVqDWvrZr0U0
 ZEzkPDuekJekpr76IgFGMoxsz4s34WJ+iDLE3r3Gsz/h2zwIhjPgmr5vMW8tIpHSNbZG4c0ILYQ
 ftLn/MNoyMnHQKP5yNzOgcgpzxappimiw0eh1vUqsMfrOfHi7dD+orZqv27a0JYRiGZyHEDanpp
 +X55MKGm4ZFjWG+bTwrcGW7NmirqMrgHnuZQReiXCFocJ4+DPoCgcz0mGvB8E6fP99KDQLhzjIw
 2r41zp9XtRwS1x7Mcyw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDIzNCBTYWx0ZWRfX/ZP9d/NO/AJy
 yPAhxldF+ZS6xY+1D2aY3ZUsQ6FpX5yHUsU/kKp9tPHelWjG6TH4w85aQzst3f9u6RToLot+LzC
 /wvYzbJ4Z0SCRV2a3Rlg0anMDyAvgNM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_05,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110234

Document the QMP UFS PHY on Glymur SoC.

Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index 4efe40c0dc97..e1b19ed42542 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -38,6 +38,7 @@ properties:
               - qcom,kaanapali-qmp-ufs-phy
           - const: qcom,sm8750-qmp-ufs-phy
       - enum:
+          - qcom,glymur-qmp-ufs-phy
           - qcom,hawi-qmp-ufs-phy
           - qcom,milos-qmp-ufs-phy
           - qcom,msm8996-qmp-ufs-phy
@@ -109,6 +110,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,glymur-qmp-ufs-phy
               - qcom,hawi-qmp-ufs-phy
               - qcom,milos-qmp-ufs-phy
               - qcom,msm8998-qmp-ufs-phy

-- 
2.34.1

