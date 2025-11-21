Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECAC350D4D
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 13:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732818; cv=none; b=G7/v9ShqCONOcoyDeugXHCd2L5wTJYkBMWV7pn3uu+x1MlvuC/kuHm4KGFpRY5qCXySqDfjawTuj2C7iwFJuOzUgStBRO4advt9eH7Foj+AyfiIm2Gpu2iv1OpfCRLRSsVMRjUmpkkfg4Q5ZhUGMbITBD1wrYE/apOxbvuO2PBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732818; c=relaxed/simple;
	bh=+WSh/nrOulGAjXJGC0pDYRfoXLb6sCiD5Gc02jtCuTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YS7CkcSW23QMLMyNxkAYVzK3wzpxg57dk3O+s7LQdVL2whxSlBYM8TnwBMs7fLgJTqdHBlKXUpP7Fu3kiu7DubG54K98eVvNBV0VJAFgXk0pJoUpqx9ZXwLboI3QYscoWroIqIb/HGz7xm3fDKxf3kfewOl3lZYYbz0SxwfG34M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XC4IgcGQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JcubMNZb; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XC4IgcGQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JcubMNZb"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AL8rpXP3676366
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 13:46:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	j+DO9BekeG00CRw1FjqoZ6sLkEuK+yJJGU53v8nxNZk=; b=XC4IgcGQxhnMoFwW
	AJMvAyCMqowJDywOL1vS+Vpl0Uw99bP5Hh4MK6DTDa/d5zCE6cukp5mleKA1y88w
	O6cSeSFlPfRfBX3L8zUrSBXDVmdbP96rRKoXFboJsT7bE29rP93OilGaI3jPU/H5
	tdcVwNff2HeVA5Zuz2asiBQcvkm0BzjMwws6iYyf+8pKgaO2nvXy7h2BeHzv0aiv
	WQN876VSNAplyKIPr6UEu6u0i59QWOA+HL2KI6XY1hcDN/BExJNJC851qZyO64ap
	wgTyA1E9l21nVyV0+geBYCYWJ9g8QeKpyAJCrSdee6CK16IeG9cplA1nvX8UdnAl
	bcVydg==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ajmyj8xvk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 13:46:55 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4ed5ff5e770so4178491cf.3
        for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 05:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1763732815; x=1764337615; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j+DO9BekeG00CRw1FjqoZ6sLkEuK+yJJGU53v8nxNZk=;
        b=JcubMNZbF5mjAja4WcDyplrRub5z2QIj3rhAm8nRwL5Yw7SySDJSHbI96fl3v5dGes
         kZatGuDyTBwhSRF1REXm5D5OHH7nR+HGk3ZZT0XK5+57gta6caux8SeO4E/b0n9Gih8z
         YU250YXEHkUA68AkhlSRFJ/dN+GrUGIclmELfNTS4TckGnpUi2sfHv2M5xK2F/JBsK8r
         mOHoFQmAuIOp0UPYtDQ94WJYvMw2HAbbWxU6P6JFgO6VN9+DZY6IMsCQvZ47zEMo9399
         En3rotmOa/7hEMUtu5B4C5SdXgz2uCZrabZmfbtAesqA9kJDerIan//Ps/GHXYSIsx2t
         FBGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763732815; x=1764337615;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j+DO9BekeG00CRw1FjqoZ6sLkEuK+yJJGU53v8nxNZk=;
        b=P+ZCQ/S0fWl4kLVHCQVrh36Xl4lcdSPns2aJpvcMy2yQz0Y7gUEYLi/o3JWB+kYh/Z
         OJVTo/2WfDfW1uTPAgY9+/BkKbl+QY0UVmg4OgcDJ4s5mG3+UJUZbbps66z2cG3F30P5
         ZQOFDcY27AgpR71gpYVpjTA0FgO1soLutx7Yfmw9VDbTigDXnn1pe8+DqtRDOW0glUE4
         9GcCie6R5a1yqGLDS1tOZTbRaG3HRGw2cKGt+XKku0Y6G/e/1miWOv5NccMRqZQDzX0o
         PTzMsp9hjQBttmzqTnTzCS6kw1Asmbh7mKjux3Y5LjxQBNA6aYdTSy+vEFKyXfOXa5tz
         6Kjg==
X-Forwarded-Encrypted: i=1; AJvYcCWmYQK5e2s75LAkusQCz+1Sww8sGbBCpyTJDq81YMW3L3eTHDugjY5EkPQ3l5C829JxBDcrKjqC7EVM@vger.kernel.org
X-Gm-Message-State: AOJu0YxGHYi62mO1fdQy7enPQqL5ywTVQOG0B9mmcNPqxo+je4qt59Hz
	3whCgWoIl1IuvTZENdVXq9+M9tanlR83UHS0abzCT22jEForELoj8RS5+1uTrpr/9Xcr/L/+jwS
	Wz9mYqbHN4+ciXRABDQZtHR3uJ/4JIMB2JyGfU/dpeY1TJR4XK/3jdMSVd9rQYhjG
X-Gm-Gg: ASbGncvXtedTYeYdm6h124Tx6tNODXT83PtvpnMa1y/HDzCvYOmZfKa/851oH9WM0qY
	ajgFoSutaD2YSugNebu0VetyXvANbH1ufMR99c7TGSfux3tkKsbNcEpuDcBu9GJEagEhOSwq1FM
	w+hyjcrD7U0nuP2/BRFEq8fSzNnItra8fcU3iOy4IVFdnzpjYHa/TM2nNLwBt8zUKktkcj/Ti+y
	jUbW2PYMNP2U3Rg6FQlAU7stdjJejiNgn3jm5VvRrWh3q1n/vkbOSEeBjCycpm52fZMUwn4euGg
	DmLue+1Boy9dhyl5tCAxy11HrV8xBi0ba4BW7Gg49Ub8UwWzdqeIrw6JOsol29e2O9XAte3e7jL
	yAHvGou95PeE4+dlbDNyEa7v4tH28g/ED9zHZsoVKJuN9tyQQGkoBrzeDWiFkUSCdsuU=
X-Received: by 2002:a05:622a:1184:b0:4ed:afb4:5e30 with SMTP id d75a77b69052e-4ee5895624cmr23133151cf.11.1763732815251;
        Fri, 21 Nov 2025 05:46:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF7DtYkRqUxlcO+pemjw2RleQ5P1i+dCdeHRUXrMnmyJnA8E8Rx1MkOitI3BlsemaFfVRZ7bw==
X-Received: by 2002:a05:622a:1184:b0:4ed:afb4:5e30 with SMTP id d75a77b69052e-4ee5895624cmr23132801cf.11.1763732814788;
        Fri, 21 Nov 2025 05:46:54 -0800 (PST)
Received: from [192.168.119.202] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cdd5e0sm496933766b.1.2025.11.21.05.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 05:46:54 -0800 (PST)
Message-ID: <c04cd051-b6d0-4d98-ac2d-4fc7ffcb4301@oss.qualcomm.com>
Date: Fri, 21 Nov 2025 14:46:52 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20251121-enable-ufs-ice-clock-scaling-v2-0-66cb72998041@oss.qualcomm.com>
 <20251121-enable-ufs-ice-clock-scaling-v2-1-66cb72998041@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251121-enable-ufs-ice-clock-scaling-v2-1-66cb72998041@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=ELgLElZC c=1 sm=1 tr=0 ts=69206d4f cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=DINW31QT5aIcAUPt0q8A:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIxMDEwMCBTYWx0ZWRfX8Lx2pP7kIKXE
 0twjntJn6VfqkbLm2/J6dQp4NBsicQg/ZPaZ6NW4SXnGHtmyHQZvLul1PnvK2Ur8WCUx8FCGaG6
 bIikCDuPeAsP4gBydKm+ja3VhDIfRtrH8+psD2+4jCY5MEnmrgiUFZcwd8trSGUF8DXJNsu7vGf
 fN5pE9Xlr1kpjf3a5d+ko4Vjzh0ttqwLeg0w4dtSF9vNmAbZIUD4eJq2xRqEBPD6cmP+DHtnsGW
 PU3ty8y8Mi+P1pJQJdn++VU7T/rpTQBqiQ3NqOqu/QqFGc1RobaB1pEpwuMP0DRQaP6fzp3Pf4M
 9EJQDD29EcwiDfzCNrNhnSshZXSnMh8pQxEcSyn/KjSkWqUKoZyG2EZF2QGLL3OModp44+POSBt
 at87TkJtpFO1rvF2pKSOtj/ik3GJcA==
X-Proofpoint-GUID: OKbulvShX4EzoQvNxYgCX6Vb_NmSWwzA
X-Proofpoint-ORIG-GUID: OKbulvShX4EzoQvNxYgCX6Vb_NmSWwzA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_03,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 phishscore=0 spamscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511210100

On 11/21/25 11:36 AM, Abhinaba Rakshit wrote:
> Register optional operation-points-v2 table for ICE device
> and aquire its minimum and maximum frequency during ICE
> device probe.
> 
> Introduce clock scaling API qcom_ice_scale_clk which scale ICE
> core clock if valid (non-zero) frequencies are obtained from
> OPP-table. Zero min and max (default values) frequencies depicts
> clock scaling is disabled.
> 
> When an ICE-device specific OPP table is available, use the PM OPP
> framework to manage frequency scaling and maintain proper power-domain
> constraints. For legacy targets without an ICE-device specific OPP table,
> fall back to the standard clock framework APIs to set the frequency.

You can still set a frequency through OPP APIs if the table is empty
(and one is always created even if devm_pm_opp_of_add_table() fails)

[...]

>  	/*
>  	 * Legacy DT binding uses different clk names for each consumer,
> -	 * so lets try those first. If none of those are a match, it means
> -	 * the we only have one clock and it is part of the dedicated DT node.
> -	 * Also, enable the clock before we check what HW version the driver
> -	 * supports.
> +	 * so lets try those first. Also get its corresponding clock index.
> +	 */

I would argue *not* setting the rate on targets utilizing a binding without
an OPP table for the ICE is probably a smart thing to do, because we may
brownout the SoC this way

Konrad
