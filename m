Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D0C47DF98
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 10:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727989; cv=none; b=uwsLI4WLtsfGxmdD9/A4VocadUf2k60JCifUhVu5GHV3hhFbw8gNsOXTLuEmOHQyCisj67auJz1gi/Pseo+Bm52IJVvCvqn0VjCv8hbDpc69PsYGcIyn0fhfLpWBM0RrRpYlXuCgeQnz/lT4jU/tqCQDImmM5EGEcEzK9Sm8PVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727989; c=relaxed/simple;
	bh=cGF4M7H2BWDSkfXAPdpNOY2HONhPgqyoW2d8CtFkC8M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FcMBXBN+g/mqjtvj45u/NYkJnxBFUoqNK35gnLFf7sxkO6IF1w/cK8es9FP7Oi5rPHeiBH/b3YAaJk4o4v8Fe7rmi84hQq5mL2IduKg2YIFOcwb/yu622VlOwr0sYfK+x3bkNu0Y4tvZjuhs8dQzkU0XsbFA2b1LVtI2p4QGU9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H4JektdX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=erQRKfh5; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H4JektdX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="erQRKfh5"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I9dYdw1404257
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 10:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uihisGELWKJXs3ghPTChJvWF5WlMaRjqVwCduuDVyXE=; b=H4JektdXU7n8uCkQ
	yfPKXqFLy2+aFUSqnCYq48cDfUffZIeqchY87OzqOl4MmpKKidu5KJLq99kUfAQu
	K07rHA3aqYC90CPW4gAkh9ak9BVmucrncoX9HNMJ7DjaHFBYhEnQmRC2SfaTsJXh
	NXzznxTwQiNb40UneBtv5ZLTF/BerqJs+LN11CTMX17fmj7fLV1oflBsayRcFFAW
	3UDk8Jc1I14tBtI5lOlQXBJWfMYoM4NvGtJRquF36icmnDB0XXoDpMTy7tmqcXDY
	30NiAoMPEwZgMoDJ7SEhwEsVdfNdLIW7TX2MENAPiSIqwZaCa6asT9X1Z7bRVtzR
	EavLqQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4grtdpt818-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 10:39:46 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2dc7337e2a7so9095195ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 03:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789727986; x=1790332786; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uihisGELWKJXs3ghPTChJvWF5WlMaRjqVwCduuDVyXE=;
        b=erQRKfh5VGHlqACKEHWaIkSB/OykxG0ffgngMrIAcjMrwvxSqUtd+bIwTtT98/B8Y6
         dRsuOdFH/CEcvlQip/lMXpw1godRJHu0FrFurWSlhXGW+66IiqYfrdDpQiPnrmde2NoM
         7y2WJst7hUPCOxQ9OZXgBO2QY7s3y7ZqifbnqN9s5CsgF2Wox/hYrDLlAz5SMWdRWU/5
         vkz9XKRcx6zts4Ja64czgwKA4q2P0ijvU0+gyavjUl9d0SZK3KjNsyCOwQ+4ZlQPTP48
         W8uC3FoiAu/hg6p2waigSoKGND9jhVJu7RxC/O0FWfM1LshzNa2z1hNULoebUYtjPs2W
         OiXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789727986; x=1790332786;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uihisGELWKJXs3ghPTChJvWF5WlMaRjqVwCduuDVyXE=;
        b=tG1LRtNZDPql5iWjJP8IuFskDSyAV0YUnJD4Eoi8TVDbfwWJB+0KBvNT0+qNnPKFpa
         hjrbIiabw8QQLqNVOg5hKVITrTeSP0FO84TsRTQZYi1LHHBbA24A4YsZ+t50JD2vu362
         0bJqGVBgdKZKi1BInXxy+R5zg0xQxQsLY3+EagNf1R3I4TvBd4MtbR5l5G8jc8R1mkLZ
         b5wLhPwcxlEhsLoEhB86MBZ4RpjXmEvO3qu5x5SYQacvLAKnSxM50Wo6EzwID/MUEfz3
         guEAgSVhIKE0Af2ELdBZZ5HAK2FF4ZO94/f55KelzF3yM+wuIvl5M8gViZRZ9XhOLh/S
         F0Sg==
X-Forwarded-Encrypted: i=1; AKwUvBzMBMhjnTnNi7WwFX3cOj/Mn94MAlHsuZR3U1hZrVePjgOrZgaWXIOGSDjNJq3DSUhStUzav//mEgvq@vger.kernel.org
X-Gm-Message-State: AFuF++nRi0XkJhYFVkSzrlLrJNVHeaVbK3wi0Ele6SSbgaOtnWOEVpBD
	q/341cY2I7IBRI3T0dA5ZxYT2pXH2o8yR+DlPjfbj7JqDhKaCiR9r+Z5w/6aS9hZqvq1bK8cK7v
	QvR4G+O7WNfIv4y7/NVp61ISF195zjOf5qIJftm4GNxTl4JKcwx8XI2NjfUBaVpW1
X-Gm-Gg: AYBFou35FnPaByxjQYA9zBsy9XpzgbS/EZ4DIUzriBRf1hRdWwXMGvDf7Za9JNqxVwr
	3gHm/YsXp5zLWZunx7a14a54giXWT6Inxt4kwHBi/YaBX5V9tpNxKytnV8E5I9FT5iqjtWa/Eu/
	51ZdmPEy9Gy6mICtAWVav9Jat/LAu86C5nYvQnoCUqY2dZMfeSOF4CxMFyJ+i+ZmwwPWXls5qEu
	NuspCIz+BJopqyM+zD1z77CQKSf0BAHXuX4HMq4PP9JgBuO6aLlZFU8gQS9ltNTY+FgZTi07tF0
	5ORvGrNYV+B0chioDlHCd1NjQ1/bdRJ0XO8dli+OWuld1R/Qikt8g8HhkLNvwj9qAbY7YxTYfxH
	K+t12BgipbcQEVYV2ENNPC3XXAg==
X-Received: by 2002:a17:903:2ec3:b0:2cf:9347:f445 with SMTP id d9443c01a7336-2ddb1adf192mr49207425ad.10.1789727986124;
        Fri, 18 Sep 2026 03:39:46 -0700 (PDT)
X-Received: by 2002:a17:903:2ec3:b0:2cf:9347:f445 with SMTP id d9443c01a7336-2ddb1adf192mr49206925ad.10.1789727985688;
        Fri, 18 Sep 2026 03:39:45 -0700 (PDT)
Received: from [10.213.101.15] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c286d98e7sm4020702eec.9.2026.09.18.03.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 03:39:45 -0700 (PDT)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Date: Fri, 18 Sep 2026 16:09:07 +0530
Subject: [PATCH v2 1/5] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy:
 Document Glymur QMP UFS PHY
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-glymur_ufs_qcb_enablement-v2-1-16619f7e36a6@oss.qualcomm.com>
References: <20260918-glymur_ufs_qcb_enablement-v2-0-16619f7e36a6@oss.qualcomm.com>
In-Reply-To: <20260918-glymur_ufs_qcb_enablement-v2-0-16619f7e36a6@oss.qualcomm.com>
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
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789727970; l=1139;
 i=pradeep.pragallapati@oss.qualcomm.com; s=20260911;
 h=from:subject:message-id; bh=cGF4M7H2BWDSkfXAPdpNOY2HONhPgqyoW2d8CtFkC8M=;
 b=XzF0ig8/4xrWYyFA3Oq5tym/qWpafBD2LB5j9S4Py9tkdaCW4+PyCdSCMH10Q18nc1dRGX3ma
 dR8Y2ZUi7BaACkcHS/z0R8Wqi987zFC9aNVjuj6osBsOUctZec/o2Zk
X-Developer-Key: i=pradeep.pragallapati@oss.qualcomm.com; a=ed25519;
 pk=uyRUsge8nQMwf3iW/e/o0U8z9nWLCMm1MGKxEftztic=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0OSBTYWx0ZWRfX99dsYeHKJIxg
 Ev2RGlUZaExun52fj0zB3CDAWOipi35LyjL73pVQ2JqP2Ag8JLyermc6uY8zzjMwxAi/6srCMkv
 xszg25KfJb+JXS/JGt4Q7uRrFhdsWBn47K7NAPsYjm89LLkygSrjYXqctpvC44PIO3W3fwIxy4v
 Gnvk0WFW7/fnf/24c3fcCjiH0zIggMnOulhYwtMSx9F9U1+Av7TLTSTd4aBwqRa+oS2d9CVscft
 h0vS202yp7gvls8DpCLQxCvmpXI725PKaknVnG+gX3VPf7uZQ4ifg9xKddWR7XZRDbgzvZOZtAD
 e7Hw0IXcqXLjBfRP2WVJXmpjLSKT3Ff0amGIKdX/DZDOSSc/89QCbYSim8zhhXRaZOKFi0BNtXs
 fbg0uaWOmPWRzpL6p2b06loKn38pUT0LCElELzTdMmhe5+F6kUMCr8lZ90hmpwWkbgy95Ij85ua
 afe03Nhbwo8sWdwPvrQ==
X-Authority-Analysis: v=2.4 cv=N+e8hG9B c=1 sm=1 tr=0 ts=6aad14f2 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=BahsdhlD1VgbZ89a8f0A:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0OSBTYWx0ZWRfX1XnsDhyLx24I
 nv2C77PJvknN3wCK3zPRqlIvAlPi1h2L7+tiIK5Y6H8lRd3WhcAkfnNV1kX63WHnWyrcsBfdvNw
 eXtFEHPCVLG/II8zfyHKRixVTW9M22Y=
X-Proofpoint-ORIG-GUID: tpFWdbH_A6-GY8Y7gT12uZV_hkWvTgSE
X-Proofpoint-GUID: tpFWdbH_A6-GY8Y7gT12uZV_hkWvTgSE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 spamscore=0 adultscore=0 impostorscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180149

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

