Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A7828FAA8
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 11:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746790720; cv=none; b=VYoct4X0BxtsiZ1guVCinp6GR1km3EZIxy00mtgFpkqEjHfOt9nJ1OIYWT3q50xDPLDvRSp7lCk+Tuf6KzGfZoTxfAXV9Ihf+U1t3bw0qdURSJ8t4dXFOupJC1o07CcZIuxunKdKLmC65fohslYBv/0S6EKQsZHzkX4oo7UY2GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746790720; c=relaxed/simple;
	bh=na1tyqxwqq2l1aEZSwT5PbD9czWYVEmyxOMMTJ+/ats=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h/XJ+/xl7FuJisRwy0PHA96cjFLAak8OuoGscq398KzEnayrPSWgIWEFTg4j9tOG/IcubF37uBhVAMmPZu/AYPBy/7QhSPnPPTjQITx9VG48fF60TnA/PdAGywlhzmMsUCt499cBYipSEhKYF4G3gaIY9/76ckZFb0NEufCwrv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FWCa/3Hk; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FWCa/3Hk"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5492hfdN022769
	for <linux-scsi@vger.kernel.org>; Fri, 9 May 2025 11:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wzY8pBM41DENYEFwwG+7GSqI4H2wlchni1dLBitsUOs=; b=FWCa/3Hk+EvtQiK5
	HqAgKsFZg1Lw10+Dbnq3j6hMAlZCN/1WognMOM7lVXiuVPaElDB/e4nJIRB+1Sk1
	0DQComVyWkX2guws/sUNwTmyTl+iioVOKzR0GZk8bIUKtyLb9Ys4GjoZsesfV3Xb
	BVTKgH3xHd0ESXlHEQf9qGARqYf0i9ptESmzCpDbbZcVp19RkCgQVytEF1JTc0p7
	azqvW7R8ZFm1gFWdJL+9n606bl6Aa3Ex8uMkmQGmlXlQAtLVxkFnAYv/jgVBQrHO
	oOgTKwzHXrmGUTbvTSCf/HNhwoWjlXMp4UMApZ1mRmSNqXyHO/44VvTvctA73tM1
	sdfcNA==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46gnp84j65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 09 May 2025 11:38:38 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6f6e71d6787so1816646d6.0
        for <linux-scsi@vger.kernel.org>; Fri, 09 May 2025 04:38:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746790717; x=1747395517;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wzY8pBM41DENYEFwwG+7GSqI4H2wlchni1dLBitsUOs=;
        b=MauWd5D62uM4IK0dZzzSnc7YNAAhHRbbs6Rflqv9gkt2lxZAj7SrHZ5+m3pBhZ6hK8
         3Y/KwVUU6rKxi40KxgqNKLUFXBbSO0wSiOtWf5Gnd8PA26JIjUlVa6X4C1FOGzOcwheh
         atRYU33q2wCt8Og+mI4OulfeT8ziYfqDMjjrHoym7FUTNLw4CBxpV+YNHaWmDifwuK9I
         dYtB3+m6KhPA5omaNRWIDUv7STy9IfUZQYgrnHpwuccaeJEb4t0o8ntb4HusCrLn+NkL
         wxu1y56D+z5Hm5RiguMF0qOOasQ/U6z8gAuzvIcYqW8nQM4pJUbIe64X+5jf+/LFtVfq
         JEXg==
X-Forwarded-Encrypted: i=1; AJvYcCX/Uv8aD9zboRceTl0xLOxBjPYIMWxiEVM2qFLtewrL0IEGKmYEMhG1ArWKEKvPiDRRaVHLq+wXvY8P@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1kQpHBbcn+KflmtA/OSu2a+NvLLarbkEUZy4Q/TysfKkr2UbD
	t9L3bxIaQUcd6F9pY91tGhP92BimjhfyFiOw6J2b1lo67bBPeTeSku5B2xyV3TciR7cv3wqyUJf
	QoYFbVs4WOrSOTYkMGO8M3B2Q9xItEEhwsjZ30BMRmmRIorqwX+fUlhMyAy68
X-Gm-Gg: ASbGncvtLfFtptxLCvf7+0Rs7MeBdT6h37naZNhiBKUfBqjqvkh/sDmJevq05r4vySs
	9FKHMEiDrVvJEeVa+qGhOnYVJxiVWnzpsFFFq8XtONjrhO8Uuyc0LZ3XF5dA9FGNgzHH1CL6trE
	RdYAL1rUNBJCEHw1G7yn4zYAbukccbnn7Gtyp4gvguDdA6mijUV/egUAZtJ8BqwaHBB2E+gEAeZ
	JRN9r9nOpt2j5Lb91Ri/5L2Xk0hVYFXdzlQbJ+51NmSYSJRpadUZ9zhdkFPGLEig7o5vRLwUIxw
	mhbFC3y++XvucXqGAJJXRPVDC2fLDseFId2NFO7WUv6v7HALTunypD74NmjSo6ZgN2g=
X-Received: by 2002:a05:620a:390d:b0:7c0:c42a:707d with SMTP id af79cd13be357-7cd0114f7afmr171897585a.15.1746790717089;
        Fri, 09 May 2025 04:38:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2mTyIvcv8MpYVvW+C/BCuqOrS5cjs+4maoMxoSUTTRMdl+MKEdX34QZo79ZW83evuQYcgnA==
X-Received: by 2002:a05:620a:390d:b0:7c0:c42a:707d with SMTP id af79cd13be357-7cd0114f7afmr171895185a.15.1746790716679;
        Fri, 09 May 2025 04:38:36 -0700 (PDT)
Received: from [192.168.65.105] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad22ba47376sm10450066b.53.2025.05.09.04.38.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 May 2025 04:38:36 -0700 (PDT)
Message-ID: <104e863f-a5c6-432d-8f65-0fd87602b288@oss.qualcomm.com>
Date: Fri, 9 May 2025 13:38:33 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 11/11] scsi: ufs: qcom: Prevent calling phy_exit before
 phy_init
To: Nitin Rawat <quic_nitirawa@quicinc.com>, vkoul@kernel.org,
        kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, andersson@kernel.org, neil.armstrong@linaro.org
Cc: quic_rdwivedi@quicinc.com, quic_cang@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20250503162440.2954-1-quic_nitirawa@quicinc.com>
 <20250503162440.2954-12-quic_nitirawa@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250503162440.2954-12-quic_nitirawa@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=M7xNKzws c=1 sm=1 tr=0 ts=681de93e cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8
 a=4sLBAxgaFKQY7hVYck8A:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: tFcgUREb_cZTtnuMR4nFZNHIBnvru1lb
X-Proofpoint-GUID: tFcgUREb_cZTtnuMR4nFZNHIBnvru1lb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDExMyBTYWx0ZWRfXxcLABvHV9x8t
 JigRHS67+y+XHOfuOnosLw76mcoqeSvGKn3MAIur2Pe+mjJGImdi/YXX9Qu46aQpvJRj9XqUlaG
 oCUe/A1jSsC8LRd3pnCmPfKGHRdaTLp60hB3vuyyo6k972dt4Y41D03xcBiqdFkUsKDCSt0gvua
 LGz+ZVNJi87ZwK7XpJq8PeOnCe/T2nEa8O5086yw7wEBGfh7Kz/Jy89XI7zJ+I/Sfl+/zPMqH+T
 gQlfe60glAES7Cy01dOgN/V22neF/GtbIdSxnNkZfuEuQPsF7oNWbJljm7+y6RPXgAzuXtF3yWY
 qrbNOCruZcdfNdkHu/wo/shWA7uEH1zZmQbD0KJEpFV6e+ejPAAwHNSZbju4R100AiiIwc8s+P0
 VX3BanUUkXE4KQxkDJ7maD3Gb7yF9+yxSW8Zlp8oJxza8jrzI3F5fM0IyVdq9mMkgiNJDA2i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-09_04,2025-05-08_04,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0 priorityscore=1501
 spamscore=0 mlxlogscore=999 bulkscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505090113

On 5/3/25 6:24 PM, Nitin Rawat wrote:
> Prevent calling phy_exit before phy_init to avoid abnormal power
> count and the following warning during boot up.
> 
> [5.146763] phy phy-1d80000.phy.0: phy_power_on was called before phy_init
> 
> Fixes: 7bac65687510 ("scsi: ufs: qcom: Power off the PHY if it was already powered on in ufs_qcom_power_up_sequence()")
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index a7e9e06847f8..db51e1e7d836 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -482,7 +482,6 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
> 
>  	if (phy->power_count) {
>  		ufs_qcom_phy_power_off(hba);
> -		phy_exit(phy);
>  	}

You can also remove the {} now 

since this is a fix for existing issues, which I don't think has any dependencies
on your other changes, please post it as the first patch so that the maintainer
can pick it up more easily

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
