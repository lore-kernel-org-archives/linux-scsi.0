Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511AE21516E
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 18:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753210523; cv=none; b=oVl81cyaKREGQZn3QdxDjGC3rvMWYr+eBwZqgajQ4tF06Mk3nm9sjGb1fFOYZ2I8AHSkKHpBM+Cw2HHIbhLxga6B9vgpK1YODT1WTD8Ys0vjUSZTRGhdzHlTNSmXekjlK7Nvtx3b6ZEFYJpixQ7cdAgNuKaDp3MJfnYfjEp22dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753210523; c=relaxed/simple;
	bh=5QY0ZBT0oOOO0nndZd7h0v+4kaypL91h5hBfStoNEuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HVlacgiOfWWPCU3GiktTWtBzM81VaTEbIfBQRBV/xK3U9XkFTAzfRA+L6HcklFfjSQd8XQRUxXmzESk0oC05hp/lr/JKs3JEPpgDbGjE8GYtDZTL2t3A+9XyY1gjccObfbaaJDb960XH/lMKuxoo5mVWp+iuzSED417qU0BHdqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Yl4laYLO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Yl4laYLO"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MIWGj0016262
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 18:55:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=6BKqR8929ZlHM9nTa+e8Knv7
	7GCKjeguQdgKc3ESW7k=; b=Yl4laYLOP5V48dNaAN2Dg/rXt9/yvG3zedNbt8mr
	/2JGccPEbhD2cw82gJ9PgCugnqRRnNtIk2ahHF2HMvm4gVpZXr2RvoHwXqPhZc+s
	7OmSoW0W+wzfYeJFD9oXIUwV7wEMS8iZrap6puZfdy1CVfV4ZG5Up8nfGl459b3U
	1m/oDS766ZzUY+yrv+6QdCB09EDdDqOCnsf95UfVHuQaFEX4yZ2BSLR2c0H196PL
	Q5EiDolx2RGf8zbPeFW4QsT/kQ3yEq+/zgSJnBUuENkxhk/u+T4/IJw7g6bCcz5f
	5k2fELcqZnQnVnuSlM502a2zYfk9mgsOnXcX2fMf/ff4Kw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48048s2nfe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 18:55:21 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7e36f4272d4so440532285a.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 11:55:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753210520; x=1753815320;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6BKqR8929ZlHM9nTa+e8Knv77GCKjeguQdgKc3ESW7k=;
        b=amskIgpvrJc97BeAWsSa4cj2mmjQvyeBuxcwFU4qOsWUWSi+pV2bT9Gf60bJMLgPnW
         O4W2db9N9cEsAnFsl1ZsEWnwTEfykSp5Z53l6MdKG0kq5CnQl/h6jsaV5wNUCRySjt0h
         tK+w9SDgZQ4KRYleG7ZW2yGWb18YgcAfRQCC2U4G7wfgxSNi1wdgVizcOP84NgB3Fmfj
         11HiZOhcGeJYPc6DOJoRlTIJBkK8ck3pAsfnW62WRfHg9HCzxLB5pbK3Phrldcayv4ao
         tN/X/xGyMlzUKNenmWHLhkWmLsZeQPsbH+GSX+qiYNH8YkXUjLvBJ4X5uq0k/1Hba2gS
         sZIA==
X-Forwarded-Encrypted: i=1; AJvYcCUSK2NDyMAmRoPcsjs0FKWhHCS8GIqIAIHq71GVAS74vcUoTRMo2jA5mrFPV8YW/ALwo/GoGeqTRgBB@vger.kernel.org
X-Gm-Message-State: AOJu0YyVi96gp0roHM90rAXZVDvCG+fn1k/jeTYfDYHogllMgTAmrYbc
	AVYQtEOqwDL/nFZ9qJldNGkP0vExFcRHSHiV1lycX2HscfuwRrYzaDe7osvGG6pOVFiT1A8IC4Q
	7E7k/lJ+ZSDfyyceCP4hFnEBB4qOwgulxzHSyi7vIxFYhkhWb904X5L87QHP/PMv2
X-Gm-Gg: ASbGncuG73ZveM5UdVN+dNcmEp2cfTq8fg2qstzP0Wgingy3iNqUWD4wIcVDAUyeWWc
	yyf0zgN2rr8VhAQvFewUtHSqXeJAFXtmi95fiyTlO0EChHDBu2uKqepahkjl2lNCEtFxVZNgaSf
	uh+5W4ZPKnWpdVE7aPhsATz/cCQmClN/9FjlMGyrs1e9aJbD2K2nZbVLyjQSpdzTAcRxEdnLZoD
	GBnqctyTF3o5ZvG55eEcvgrWXLmKqlwR+4YiOiqaW1yqgJXoxaDs2H+d/f20GLP8M3P1u3xUZ3A
	T3Cq11brWizDgb/HgD8IFK0n5+sExuG5gAjqmpTB8NS78ePbJptGj5Q/wwzbIr1UDtGN3Dz1Sl3
	9cEeLC7vrbCDhthp8VgnV8+IiycUU4OdAyQmTetu2cjy0ICeHVfc9
X-Received: by 2002:a05:620a:258d:b0:7e6:234e:8e8b with SMTP id af79cd13be357-7e62a17cbd0mr33307085a.39.1753210520180;
        Tue, 22 Jul 2025 11:55:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0JkKltrirF9ixXg7tHwQG49S1rE2Y01788xVR7C3PcWVSHdggi98ryTWzd0HejsZYizLvmw==
X-Received: by 2002:a05:620a:258d:b0:7e6:234e:8e8b with SMTP id af79cd13be357-7e62a17cbd0mr33303585a.39.1753210519558;
        Tue, 22 Jul 2025 11:55:19 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-330a91c228bsm17136171fa.62.2025.07.22.11.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 11:55:17 -0700 (PDT)
Date: Tue, 22 Jul 2025 21:55:14 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
Cc: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        agross@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] arm64: dts: qcom: sa8155: Add gear and rate limit
 properties to UFS
Message-ID: <kavkq2wgtapagzcdvm3lcvy52bcgbqul6oqjaluvzi3q2a5z6g@jzrowliqets6>
References: <20250722161103.3938-1-quic_rdwivedi@quicinc.com>
 <20250722161103.3938-3-quic_rdwivedi@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722161103.3938-3-quic_rdwivedi@quicinc.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDE2MSBTYWx0ZWRfX2BtODz+3Dq76
 VJWI8Av0Y5SJRy2xSt/L7W7BL/1R+IB1NC/CbF7tWjJ3ZWvfY1Gpgq00sRF1w3IaRAFY+V4DshD
 Sx+pXGuojthxwCLKqFvFgEwtyqvunordNV+6c2bC1m8qrdIZHUcbdfqkZElbENwgR/apxaAwjYW
 mhbvjZ7mMBG2h7GcpzylatcFrmgqdFzcefIb3xmzkpgOQPQsFMtNKRYXl/5z9abmKuUyQ716zi0
 rpp1uc4+U1NetmpNK1M6vgTh3Q6sPqn0oZ17Gu5+HuV5EfquI8CcUSXa6atcL74tZwT4iBVVsv4
 PQ3IxDYOEs9AlNlGh5179IYdLvAuUGFnRLAbwF6Rf0I9XwgwCYxrxc2wOx4iBsHUhTNNuZUR5fw
 4v18dQgZnQol0oEyhia/fjlarjuYfAHhufUaZSdi0tSTcjBS8SJAalt9FaIbOh6mtExhaeXV
X-Proofpoint-ORIG-GUID: OVBlxlpNBKdmAPjxEp1lj0o8BP_4TDAB
X-Proofpoint-GUID: OVBlxlpNBKdmAPjxEp1lj0o8BP_4TDAB
X-Authority-Analysis: v=2.4 cv=OPUn3TaB c=1 sm=1 tr=0 ts=687fde99 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=COk6AnOGAAAA:8 a=PsoIiSmMjj9FaRidGiUA:9 a=CjuIK1q_8ugA:10
 a=IoWCM6iH3mJn3m4BftBB:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 suspectscore=0
 spamscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507220161

On Tue, Jul 22, 2025 at 09:41:02PM +0530, Ram Kumar Dwivedi wrote:
> Add optional limit-hs-gear and limit-rate properties to the UFS node to
> support automotive use cases that require limiting the maximum Tx/Rx HS
> gear and rate due to hardware constraints.


If they are optional and they are for automotive, then why are you
adding them to the SM8150 DTSi file, enforcing them for all SM8150
targets?

> 
> Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> ---
>  arch/arm64/boot/dts/qcom/sm8150.dtsi | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
> index b5494bcf5cff..87e8b60b3b2d 100644
> --- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
> @@ -2082,6 +2082,9 @@ ufs_mem_hc: ufshc@1d84000 {
>  			resets = <&gcc GCC_UFS_PHY_BCR>;
>  			reset-names = "rst";
>  
> +			limit-hs-gear = <3>;
> +			limit-rate = <1>;
> +
>  			iommus = <&apps_smmu 0x300 0>;
>  
>  			clock-names =
> -- 
> 2.50.1
> 

-- 
With best wishes
Dmitry
