Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568002C3259
	for <linux-scsi@vger.kernel.org>; Thu,  8 Jan 2026 04:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767848318; cv=none; b=mZm1li9w6a1YJ4HAVNmyw7bPF5kv1Yr9rLTWhPy1EyKX2D0QkUWHSSonGdWw5/2kOpelBt9K8xUEeY+6evZzZXyZpkUI7nEpljhrzcyM+hwQQSrgDPZ3V08gSTbQcZAY/98JcuGk1DhspnogFAVuyT1GYQwqFquATGoFvpN5yXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767848318; c=relaxed/simple;
	bh=5/8v1qa7MDZIB7Kys1KfUbhrpgKuhP4L2dEhcrc+Qps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ucgxTsTnGJPdLgTNALkriFusTyQaA3e1VIGD2nQnDMHbbyvDtch6qhwWHbN0ZMfkHW/UsxQFfYACwUutwsdY3i/Tbc7cODRpBQfRZuAdHx7tenna5wA1M65GtBVJSK8aDDMFNUi3gU6ksnlYFRCa4n4zrEL5knBo/WA2N2xviGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ls44GIRT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=diNSPQoz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ls44GIRT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="diNSPQoz"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 607HVToW3890526
	for <linux-scsi@vger.kernel.org>; Thu, 8 Jan 2026 04:58:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1oZWKL8WFE/TBScZ84iQCle13ucFqibIGaIK9CHjIWk=; b=Ls44GIRTBwJnmZ2l
	cCVNybIBFEwBR0OmoKChQLF0+FpGPVL6Cd37IN/Sacaz1E17g56Jf4bvsL8ka0AI
	FiV0Iar6JsFLKLlkzztFtZ4MeK7/dVd1qYnuDlA0sFii1ni7yszKQpnzz17DaN86
	Oyj59An+Qx2HqOjTc1893NFKU6+A40TWi+y6SemQXt4+pU3TmSW5YRR9l4gtVUR+
	U/U5s2e8Rj4vxGAP5S8+cU35ut+TqzrQsuguPMos8cEr6gL/6zHWv6LJXUlZQWU7
	993LR8mffu09QuKiCdaAna1hXwcFgt2c23Ho2axVRbQZ/EdGmSB+GPKvN3Z8WKBQ
	FHUkKw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bhuy71rms-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 08 Jan 2026 04:58:35 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b99763210e5so3114878a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 20:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767848315; x=1768453115; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1oZWKL8WFE/TBScZ84iQCle13ucFqibIGaIK9CHjIWk=;
        b=diNSPQozxkOo9NbpPwJiIWPg1Y6scULfJiA7Eq4KimuMxcJixkwxIMevkzaxr+sxs5
         sR8w/5pWyMQG2Rqlu+zsh+cAGXRAqpCnMW/t7qsrItNCFvnLx6QGhSOzSE+Gm6Qag+ae
         TNKg26lhlNgQm8woWmPQi2/GXTfczBy91kmn3QI2o12eF9VadBIyDIEQdMzX08VgYZFS
         Z4yAVWVuc9PxeGR+764kmr+bnFlOTYftZ/qXJL67IwF0cAofnJdu8W7W82lauykyOMef
         5GJIMsPXtjgsE+7gl0rD6L4ZdcSWui20kG4Q7TFu0a1EZ1VWuLjn5RPGPXv4TplLaZqe
         doyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767848315; x=1768453115;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1oZWKL8WFE/TBScZ84iQCle13ucFqibIGaIK9CHjIWk=;
        b=b8CL4cWEgn8Zf8lkkZ7GXCbvYH7WVHJokmAwbF55M1wa2tEyBfBS2/W0R0PCit++ae
         mLY6O4/R4W2vWwlb4TkW+Uoo6rYVAM9bNTYfRBCLspbMnDyBE1c0RlvFOiM/YUH08qWm
         OoupY2Hm1oGsLnkDzRAUJ2w000C4DJbBgtsZ/lNxDJWmfUFJ2vRan1lVuUqGFyLQ7cRa
         hcLaILuZdXFtB1x9kdAYJteNXpSyddjSHm7tU4xStg5DLmrLtYB1HNzSVkU1ulWSvFRZ
         p9dvYhph9vb2uPju6GJSD6TIbOppFdDsNpRb9dM6LFisICDEePynvO9e4YOXMh1fYfPC
         Sb5w==
X-Forwarded-Encrypted: i=1; AJvYcCWvQwTtwXYvlplXak8VwtmrxdqTLfpgZSV/HkbQSaNovW2g5I9AQoqRZiOh1KaR0QLVLrq1Ze53/WYX@vger.kernel.org
X-Gm-Message-State: AOJu0YwzKlaf87TEDbR7nH5zWYMZsobWFPMLDEYsE9gxw91VgwTwjw5+
	chMgQpwbB8GB7phVaVAPh6B9VDn037PukRzh0of1l/uHJ+1k+eRuNVPZoh4Bto2nhPoCm1+8MrU
	u2e2pS3qz+Zg12LQrQvFvbH7lpdjwbdOW1aR8oRdSjSKUhMjTcPltugBBlJme+8FhdOYob9nB
X-Gm-Gg: AY/fxX6SIRkVRGPy96jI2CdHQAJvgepcQReBhQk3FjD22OixhvkdE1oUBTgHgB14tQm
	+s91wmESrftTX58mgLuweod3027kwCRAjj8lrHk5enwo96L7YDWcjrLuf+p2FkmjZdHQj2jJcvf
	VIIAAn19hy1gNx2lUzokyrMGaaICOUZwzRnlOwZbHdLVY9YuMcW9aIcp0zwpZPAq0lM9qr/lQys
	98DKzEQBBYR8s4gU18OgGt+slRBz2UyVeD7vcSqKaA4Kqtb3qI7T/eNSxdqQ0fopiXrORgO6INY
	HcdZT2W6Vj7oTBIcvRHwCipL6NXVX1Nekl/FR6Miesu5hgUnbs4U194SwOV+63zbS29uuBP8AaJ
	FR/QFUP/57rkcUGN0YxQ/lQ==
X-Received: by 2002:a05:6a20:3ca8:b0:343:af1:9a57 with SMTP id adf61e73a8af0-3898f9dd1d5mr3728905637.56.1767848314628;
        Wed, 07 Jan 2026 20:58:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFN6TScipKb3lPetOYRKbU8aWMIDLVoyDaluyKREQZEFcX+18m2Z804vQAWuMfyQ/M0fOsdmg==
X-Received: by 2002:a05:6a20:3ca8:b0:343:af1:9a57 with SMTP id adf61e73a8af0-3898f9dd1d5mr3728874637.56.1767848314031;
        Wed, 07 Jan 2026 20:58:34 -0800 (PST)
Received: from work ([120.60.56.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f6b7a5a69sm1638678a91.1.2026.01.07.20.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 20:58:33 -0800 (PST)
Date: Thu, 8 Jan 2026 10:28:26 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
Subject: Re: [PATCH V4 2/4] dt-bindings: ufs: qcom,sc7180-ufshc: Add UFSHC
 compatible for x1e80100
Message-ID: <tg2eahc5pf2pqvavihtptbxn6hqftdd6euhhap3v4kkffzgasb@fyq5mxlsu5py>
References: <20260106154207.1871487-1-pradeep.pragallapati@oss.qualcomm.com>
 <20260106154207.1871487-3-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260106154207.1871487-3-pradeep.pragallapati@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: -zJDRjBQQoB1sCHyvbVYZqxA4usZ_M7J
X-Proofpoint-GUID: -zJDRjBQQoB1sCHyvbVYZqxA4usZ_M7J
X-Authority-Analysis: v=2.4 cv=DZEaa/tW c=1 sm=1 tr=0 ts=695f397b cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=RufU61fwOX414azV3ffNTg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8
 a=drqrqwM6pU4QfT7bHcMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDAyOSBTYWx0ZWRfX/nK0D7gvh9hE
 LuC/Mz2rzVjBQxhBEWdev8Nd6Tbu1t895UznBZBO68kPmJuZSd/OjB6aYqqaQkIuA16HBLaLGNi
 qiAJBwDJ/cnLOqxStpbIup5+gVuHUcnkHHK8n1ne1fAfipj11Aift0UgbYvMxhsj0YavVgvMoRR
 6npQBpJrifulc0pAsB40qiS+85NtlwmbwDmUWrXdwf/1cqpaCaMz4GI4H5CUv2oBbX3nRvTxvSx
 9np7PmAo78LH8z5uc+7fjdT5TQBMmz3LVBQ6hdCSzYNuxr44O49ydfuyFYt67D7tFyxi1U7AIJA
 rCypFHPF4PTxKQCvmkYYlelocfgNm4Oiw9JuSxVQmkFBji40AoDuNCIAwqyHBUecB5gbiRddNGD
 OFqGjP79x2Rc8G2emIEcrFiMpO2Sg896346z49KxIPmdEGuCHaL2dzqMExx6qkJf4Dz7HmRQLcm
 qiJ4vYcm9pGQouXIXCw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_05,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0
 spamscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601080029

On Tue, Jan 06, 2026 at 09:12:05PM +0530, Pradeep P V K wrote:
> Add UFS Host Controller (UFSHC) compatible for x1e80100 SoC. Use
> SM8550 as a fallback since x1e80100 is fully compatible with it.
> 
> Qualcomm UFSHC is no longer compatible with JEDEC UFS-2.0 binding.
> Avoid using the "jedec,ufs-2.0" string in the compatible property.
> 
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>

Acked-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
>  .../bindings/ufs/qcom,sc7180-ufshc.yaml       | 36 +++++++++++--------
>  1 file changed, 21 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> index d94ef4e6b85a..fe18e41ebac7 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> @@ -31,21 +31,27 @@ select:
>  
>  properties:
>    compatible:
> -    items:
> -      - enum:
> -          - qcom,msm8998-ufshc
> -          - qcom,qcs8300-ufshc
> -          - qcom,sa8775p-ufshc
> -          - qcom,sc7180-ufshc
> -          - qcom,sc7280-ufshc
> -          - qcom,sc8180x-ufshc
> -          - qcom,sc8280xp-ufshc
> -          - qcom,sm8250-ufshc
> -          - qcom,sm8350-ufshc
> -          - qcom,sm8450-ufshc
> -          - qcom,sm8550-ufshc
> -      - const: qcom,ufshc
> -      - const: jedec,ufs-2.0
> +    oneOf:
> +      - items:
> +          - enum:
> +              - qcom,x1e80100-ufshc
> +          - const: qcom,sm8550-ufshc
> +          - const: qcom,ufshc
> +      - items:
> +          - enum:
> +              - qcom,msm8998-ufshc
> +              - qcom,qcs8300-ufshc
> +              - qcom,sa8775p-ufshc
> +              - qcom,sc7180-ufshc
> +              - qcom,sc7280-ufshc
> +              - qcom,sc8180x-ufshc
> +              - qcom,sc8280xp-ufshc
> +              - qcom,sm8250-ufshc
> +              - qcom,sm8350-ufshc
> +              - qcom,sm8450-ufshc
> +              - qcom,sm8550-ufshc
> +          - const: qcom,ufshc
> +          - const: jedec,ufs-2.0
>  
>    reg:
>      maxItems: 1
> -- 
> 2.34.1
> 

-- 
மணிவண்ணன் சதாசிவம்
