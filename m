Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C5817E4
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 19:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753210960; cv=none; b=KhrOs3Zn+OQiUboGB0PHiI1RHBqN/UQBKV9wUz7UHv9P/V0wwXN/4DuBGp0SOZkpYaM1ZqMxvwEIo0kiNkMCozOItdRRFHJZN/HGYllOOFPJlUpK00pMMppxDyaf01xtiNDS5LVRMEuyjdAKaQa/x5ay6mXmmi8mNqbN3qmfBwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753210960; c=relaxed/simple;
	bh=1jW+AQBLmrBwT5OqSJctwQ/2tI0p4B8L4gpSCTjZz20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ueNsDLI/pgDeGSw3V9RBtRs9qyPtskte36ki8uScpdfqWKqoY4Z3xGA1aiQJLivZ/AGaKfk8xLtsubAqwH4rEGrZmnUbt35aF57omB5FLuo933f3pxTnHC5WqKCKuRhoJAunwG6soeMDfS1J/1QZbDDHFS4sfYpACLUDDPtP8bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gyhtp8el; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gyhtp8el"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MEqw2Y020141
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 19:02:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=eeNJd288lALWCAPcNkFrKeWB
	uzWCZ8l6rZ+MwXhFjY8=; b=gyhtp8elLmKM4dYCBMpPzjGY63U1H7BqaIPm3d/V
	iuhp8iqecnu34Ssg+Ellxxf4780WhBLpFkf0vGOi+IrmadgAMyyR5N0NO8O2Xq/H
	YOcsSfOgJg3dUuyS6FUsPrO6MBFYV+A7UCBTUpKGbz3CjI2GFSg3omVv1tZ/6Fm1
	aHXhIhM3Ls5o+d8EFry9Bo8vN1HOuEwJRGYVRgMS2KPRlilyXuitfggnQk2txLOY
	YnIXvrJ+KD0rShyIWHR1XAl/yglCuuHj79XtqxdIcR4UCsoAT+7ANPS6FF68Kv8g
	Ucql98aRd1srlKnGkvac1UCcQgj4znjRLvHQjjnFnc0/wQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4804na0yrs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 19:02:37 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2349498f00eso1578285ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 12:02:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753210948; x=1753815748;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eeNJd288lALWCAPcNkFrKeWBuzWCZ8l6rZ+MwXhFjY8=;
        b=k6vdLYX9XbocXB0yglG2dfqbQXtZVyNLNiO5h/CLkK8a+WRIEHxjW5OGn68JiuWeb5
         svvt2lHB8Oc1XnZbIS5F26N6rQ/mLp6puIk1r+LI6StVjh4zKn0Je5AyfV5xPGQ6frNQ
         dVfDeIx0M4jURqvLvb99LMM3O6stwXCU8Asph7gCkhLM3GucRVvoGFnaxDrDRc8DxyKg
         jQm9RLBr8u7Oymg71kMR9PXdsUT5uRhuDq6zWqcGVLYSgcAiLQHtOZPnF6EDibn/H+A9
         CerK4RqCsOcICFg/tBqzXNv8AojEo4c9iKHBmMHfq9y14K9RMh5pV+dbhlaiYBhfEAho
         y0sA==
X-Forwarded-Encrypted: i=1; AJvYcCWB7/GmcTg4WVG4AVwRqVIr+kZ7FPQQprflUdKvAmauu2Cw+UGupZ4VpijP5AOLQLemfy17LAaVdaHP@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9/7v74OIgcqyHaEsPHFsU4adSbvUp+bYofRv0d7LY8kI7Sork
	UJMll5KqVIJ7LXY22/Bq6GmSBus1Qdc1U52fj1hZdKmKWOfjCU/xTc4a39OQB1CNlV9/1eBX57M
	FLe2DtVhG7bY4Nr7V+QqEYpmy+YQTmu5DMCxI0+1aPB9NAZH0V54ZouYRZMKHMJTf
X-Gm-Gg: ASbGncuRAgUuTvnE3DAIzPA1yqv5pd0TTLKT6hfdguZ0xwLnsE7MQy0J69wdiudPVKP
	0b51ock1gEnd9n/aziKjSxX3vYsTLe6s3NmXxVgWf2PA2AbCUocaWdhW4ySKvzruEYfClAlsdUv
	8FgejDeV8SFoTRIr0p2GPqrkTzheQipwm4zKcJiGRwh32E2x3zkg6QEPUG4tXrfdfWbwXsueLLA
	nOL4NpwIEO0s161E+1hfUkfwUH5pbm6L8CkQh2NmvgLF8o7In5OXilBLwbnpEBj5rSx7Sj7wgB1
	2xlgS90ZLrofcMVG2/1PVIL91jtGzhoRvVJwZJdCydbxiCUKtpjPV6Vpz1zj8nAvU3vscYUub5x
	Td8GhyJgYvUICCJJ186Ds7GUpNMJ203WPvx6wATllzDzofY8o6mTO
X-Received: by 2002:a17:902:ce8f:b0:21f:5063:d3ca with SMTP id d9443c01a7336-23f8acb16f9mr66352905ad.16.1753210947578;
        Tue, 22 Jul 2025 12:02:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTaRg7+RT9XmmVIQa9Z5l3X/9yEYapn9SUbtScQ0vSYOHwQTYMt6q/ro/+Isxq9+wASsihpg==
X-Received: by 2002:a17:902:ce8f:b0:21f:5063:d3ca with SMTP id d9443c01a7336-23f8acb16f9mr66352225ad.16.1753210947052;
        Tue, 22 Jul 2025 12:02:27 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55a31d7c7a4sm2038313e87.130.2025.07.22.12.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 12:02:25 -0700 (PDT)
Date: Tue, 22 Jul 2025 22:02:23 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
Cc: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        agross@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] dt-bindings: ufs: qcom: Document HS gear and rate
 limit properties
Message-ID: <6yhnlwyuimkrlifmmdihcsuhws6qkdjzmjxdupu6cevu24nmi6@f4vk5dffjie2>
References: <20250722161103.3938-1-quic_rdwivedi@quicinc.com>
 <20250722161103.3938-4-quic_rdwivedi@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722161103.3938-4-quic_rdwivedi@quicinc.com>
X-Proofpoint-GUID: O2mUp88IVpOW5OgXfte6FhHR5cuWS1Ff
X-Proofpoint-ORIG-GUID: O2mUp88IVpOW5OgXfte6FhHR5cuWS1Ff
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDE2MyBTYWx0ZWRfX0lR5tWnmrRcG
 XC5hD1Kw3FFUABpkO+Gj/kmrtiGaE6bePLdsH53pJq/S2pGfopbQbZLKV4Pfnu8/3NQscyH1BTC
 7Mp3CikglfoQe1qweMUNZ4BTTSqYrIyGwry+6JpYdf8VxGHkS3jFpXXZy1sRCIhNWkLTMgZ7q5q
 c5rZafcnr0mqot+r+IMOp4wYMg5IWKARkKWjqFlfgnjMSwhLTbTtUEVcikXsoSifY7TsfDv/NQR
 RsOdfPB3tL5bMe5NsoTN0zHR7KcjYi68I0+sTa9PeKt07Za12U/7NXtw7eyBLN+L+BlsbnsOG2N
 Ku5aqzAiPqiodYNRahtrIz164oDEqhAdKTYKY5/oTAz6WYvhXrFlYic8w1BhwAvhr4KTwiPbVro
 UW10Lqu7HzLIVlXtfofKodtL1K8y3H5ECrXDJUYrQ29AkFQ6Dy1ONOa01DC6SpHq9nTv6rf1
X-Authority-Analysis: v=2.4 cv=DoFW+H/+ c=1 sm=1 tr=0 ts=687fe04d cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=COk6AnOGAAAA:8 a=rRQ5tug-ufnQS7fofaEA:9 a=CjuIK1q_8ugA:10
 a=uG9DUKGECoFWVXl0Dc02:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507220163

On Tue, Jul 22, 2025 at 09:41:03PM +0530, Ram Kumar Dwivedi wrote:
> Add documentation for two new optional properties:
>   - limit-hs-gear
>   - limit-rate
> 
> These properties allow platforms to restrict the maximum high-speed
> gear and rate used by the UFS controller. This is required for
> certain automotive platforms with hardware constraints.

Please reformat other way around: describe the actual problem (which
platforms, which constraints, what breaks, etc). Then describe your
solution.

> 
> Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> ---
>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> index 6c6043d9809e..9dedd09df9e0 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> @@ -111,6 +111,16 @@ properties:
>      description:
>        GPIO connected to the RESET pin of the UFS memory device.
>  
> +  limit-hs-gear:

If the properties are generic, they should go to the ufs-common.yaml. If
not (but why?), then they should be prefixed with 'qcom,' prefix, as
usual.

> +    maxItems: 1
> +    description:
> +      Limit max phy hs gear
> +
> +  limit-rate:
> +    maxItems: 1
> +    description:
> +      Limit max phy hs rate
> +
>  required:
>    - compatible
>    - reg
> -- 
> 2.50.1
> 

-- 
With best wishes
Dmitry
