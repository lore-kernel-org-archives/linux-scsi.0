Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BDB1E885A
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 22:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767651662; cv=none; b=Bt5rJU10hP7XQa4GG46dovzjbPPWi05FAEsQ2NHyelSWTv+4ID+eT86YyO2PfN6LS43I6mXaaJBDKFnmeLpw/uI/QZItNGzQqcm/KSDzNjYQzMXjVZWBskYC6me56ZoOcMzuSn4rui5Mqfj1T0dlmrggqjQ1eoA0VVrJmPCmoxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767651662; c=relaxed/simple;
	bh=d6UznWfdHxv0MpKmBa9LwN1mmIS4ZJCNUSS8+kvdMtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TfoB5XEMjO5ueidxBNEXcPy/GSHCZtr9d/C79u0p44c20SojJqQxso8Xu546GvgkT5kBep7UNZnz9abtBcR76+6KgAehwsjbkSlDTlNQZNzOWBFlIAMG7n30JddUbSCufluCgacA7iPeHyvYu7pvEC2+6iUxMHLn6TqcyvBy1uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bl1LYd21; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZeIKck/2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bl1LYd21";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZeIKck/2"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 605GKDYr3338524
	for <linux-scsi@vger.kernel.org>; Mon, 5 Jan 2026 22:21:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=g0fZliYctjACt0ZsbM6HzuSn
	8uaiOqLFgLIVUIMdSuM=; b=bl1LYd21jSHcYiDKmzUk1K9ARbEXaGn2SggweCUi
	CKeXRXpxiQqHZqAcurclOA99hYskco6CmMlUozL2bKGgZUXYm2f4yTXyeoZtbH1L
	DY2CUQZibvJQunq7fHtP5pcMlXM6BtZC4ZSzfkkKPRGFnMuaqvQZEtqPMmCVFtPE
	qeNqX7Ys8JNlYcZoDBDkj5Hy6jXDN5vDMlzW7POPpn5VCcyI/c7bWKGDamXL9cnO
	sJtDEXfZBHwdJamF+1Z7c7fi5Z3yaMt3KYWTZkhXnI1sbsrQFszewjvZ2FgVHxa8
	1yyEgHd1vMvKYmgHWIFzr2mWij7NiMTq/yrmo69jkBpY3g==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bggqu0ys0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 22:21:00 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4ed79dd4a47so7645291cf.3
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 14:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767651660; x=1768256460; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g0fZliYctjACt0ZsbM6HzuSn8uaiOqLFgLIVUIMdSuM=;
        b=ZeIKck/2MmsHdjeEfjN5IBUzecmCCazmgil2npzYlz/VsTNN0NKs+D1zcTR8nvWKcy
         T8EKypxk2FPeiTlVm9Um50xR6m6xx4zlzL8BcKOUL07tDG1LN8qOz4ulsf0ylFQKOKVH
         ULcVgW1BYNIm55kSIKOiwcSvqMLaF5Ihz/xzxNBXUuYUj1QNvNUSGpUKE5NGd8YUp8b2
         XrMjJuv4xJOP1wqD2Raa5zWbX9XhxATQxbvWsrD4cPO1KLeLAeznjwXuDhspfeZ4Ifrq
         eFbH1u7rPDNCRPvXdOSWVve4WPiAb9/N9vtYcro/QxHs7P8MJyRhS1kaagp4ZPoWLUEH
         zgdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767651660; x=1768256460;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g0fZliYctjACt0ZsbM6HzuSn8uaiOqLFgLIVUIMdSuM=;
        b=MOAJKwVI/OTCQV2YUNW/5J5KJQevw8FkJ+HDVd2hTbBa9x2v+UXEDUxcKRl4+XKbFs
         AvRVx+4Nt+0K7bEYWJT0Q3rk/VW1hBlIsL+P/l1lf2wFGTs0UsuKfHSgOUheFU8vAPBo
         TegbLZ2wUmyFs4f1GnS82Z3naKd3ID7ann5ywh8lUNEdTDX/0L/CvYKK5pRxu5lQSklx
         yjXAWbpXYkgD0Oqpz2/VP+y+ThW6GtYU7JFYlSdgor4Sz7G4fC40w3pV8N4ptKrnO//D
         +Rndm7d9z6KPAQMCKqzQW5Vn218Z/jM9GrZa4UtWYixnBLZn+br4Mm6wjp8mYtWIt2cv
         IghA==
X-Forwarded-Encrypted: i=1; AJvYcCV4GdwGPSRWUDuBfJ9vb3EbiedgpbkT0zjhuuHXPcOjOxU2T5Bgvywmn9aS3+wFauALMh39jCl9/BNw@vger.kernel.org
X-Gm-Message-State: AOJu0YxtYzpx/jY/rwZdWHz30xk1vOQoUe1leGZWtMogME3fHfHUTEcJ
	tRp43yeHqotPeVxqqTVf+K8kxJP7aPVS5+VnN4qi9zk9tN+fn6MJUiGreRED7NpVxHG3ZK0Uz5y
	DJ+v674zfG/f/7upeGiVni5ZqEGThdyQ3LD5MA0k02Va0ecjrHSG7+05zaBRWqjqB
X-Gm-Gg: AY/fxX79JAKciFoTUMltYk0rDQ2t5Z+6BIXDMmbvd5q6CdFL8BAaIKPRyT5P1pQfPUQ
	aUWm6FAEPFdwdF/7p2SuA1eaK668OByQisw8FEhY2GA93HfOrx1GYwUZlObOnwW07zm9eN+M7ig
	TaLFqsRlihbDU0+K02aBituzm3Rs0+eS9b3w/q03jH6vUQgsoKuMRSOYal0SNwlcbsGogRO3JPo
	iAh4UhSr6G6KXwKiPyb5SVEJ5pdPZRdB6LhNNRDg0t9CSDcUAoDHR2JRWiujqa+h/hhEX4zVLWz
	ynjY5hH3ei8AGW9MnEiuiEy/PuMgDCy6+3pKq6gDGEywTeSRapHj/aImb4iQPuchFXWS3FlNtyz
	OFVs55UuXnXjWCuRcr2Gb2D5xaWeqSKYzmkAVV5qT1NXV937nGT7iyGJLtxK3dn1pnAf2r0xL4z
	tWbPtmJDIafXd2QYPzje7roHc=
X-Received: by 2002:ac8:57cd:0:b0:4f1:83e3:bbc7 with SMTP id d75a77b69052e-4ffa76db6eamr15736651cf.27.1767651659765;
        Mon, 05 Jan 2026 14:20:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH/lIX3t8X6gbr2QumiMF2IqSfaMQq2ruiQpqdZbynXdzRKgvS3PXF3MUXERhoJkc0UOLV0xQ==
X-Received: by 2002:ac8:57cd:0:b0:4f1:83e3:bbc7 with SMTP id d75a77b69052e-4ffa76db6eamr15736131cf.27.1767651659208;
        Mon, 05 Jan 2026 14:20:59 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b65d5dd06sm105969e87.52.2026.01.05.14.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 14:20:58 -0800 (PST)
Date: Tue, 6 Jan 2026 00:20:56 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, manivannan.sadhasivam@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
Subject: Re: [PATCH V3 0/4] Add UFS support for x1e80100 SoC
Message-ID: <y7lm6zqgbhk4243diyotvox75tcmzhgbkypbkaskrtjcjbruwm@ar7kjmiyv2wr>
References: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE5NSBTYWx0ZWRfX3OKdoXQDoRQU
 dXEDdstczE+VQ/PByJDRcr5ubTOH1yfdObEz+BQLZeQpw3AeU9Uc1WwYras4Lsc2Vbg5HN2GLsT
 VKHZerjNMJovf1dYs4ArkPw/6Bklj+I+eCSAA22ir8czEEW62nYQHXpcJuY8+1lSflZTS3gwn1N
 Zla++uOxJ1WKQ1NSibPcu6gAvyDWxDXwTBE5qtxjCgfsDMxoEE2lOD5QzM/YO1QztBha2PFygA7
 RoQs8cmt8UGEg3N6xJ5JDWd9JbQ+JAk/rWB4Ev5CXGOKv9D3Ht0VXsplReP7zpsfzlkAXqq1Pvy
 bddE+Dc92i5Vuqb+QzHN1jK8TuHB36vWLg1e6fwICCbsD4eL/y1Neshtnhe/iyFEqvHNpcwDBnV
 nDRFMvckjy1IYfsdKQ4HgxH+ZVnwr0OadPXNy7O/KJNIg2ETcxLHP5vWmCd+aTHCvBLayis7jll
 /JQq9vjKMlhM1Ny87Eg==
X-Proofpoint-ORIG-GUID: JcWkhR90hkjuFwrMHUBOX1ANHWNppTwZ
X-Authority-Analysis: v=2.4 cv=fr/RpV4f c=1 sm=1 tr=0 ts=695c394c cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=atQpAzJIPGnAHsar4hIA:9 a=CjuIK1q_8ugA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: JcWkhR90hkjuFwrMHUBOX1ANHWNppTwZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601050195

On Mon, Jan 05, 2026 at 08:16:39PM +0530, Pradeep P V K wrote:
> Add UFSPHY, UFSHC compatible binding names and UFS devicetree
> enablement changes for Qualcomm x1e80100 SoC.
> 
> Changes in V3:
> - Update all dt-bindings commit messages with concise and informative
>   statements [Krzysztof]
> - keep the QMP UFS PHY order by last compatible in numerical ascending
>   order [Krzysztof]
> - Remove qcom,x1e80100-ufshc from select: enum: list of
>   qcom,sc7180-ufshc.yaml file [Krzysztof]
> - Update subject prefix for all dt-bindings [Krzysztof]
> - Add RB-by for SoC dtsi [Konrad, Abel, Taniya]
> - Add RB-by for board dts [Konrad]
> - Link to V2:
>   https://lore.kernel.org/all/20251231101951.1026163-1-pradeep.pragallapati@oss.qualcomm.com

Where did the previous changelog go?

> 
> ---
> Pradeep P V K (4):
>   dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add QMP UFS PHY
>     compatible
>   dt-bindings: ufs: qcom,sc7180-ufshc: Add UFSHC compatible for x1e80100
>   arm64: dts: qcom: hamoa: Add UFS nodes for x1e80100 SoC
>   arm64: dts: qcom: hamoa-iot-evk: Enable UFS
> 
>  .../phy/qcom,sc8280xp-qmp-ufs-phy.yaml        |   4 +
>  .../bindings/ufs/qcom,sc7180-ufshc.yaml       |  37 +++---
>  arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts    |  18 +++
>  arch/arm64/boot/dts/qcom/hamoa.dtsi           | 123 +++++++++++++++++-
>  4 files changed, 164 insertions(+), 18 deletions(-)
> 
> -- 
> 2.34.1
> 

-- 
With best wishes
Dmitry
