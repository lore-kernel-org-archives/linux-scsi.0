Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2223EAC72
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 09:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779873901; cv=none; b=c3XMgMTBZwBfiO4R4UBNV6qg4mbyxIEMOOOlHd+tGXJnGvqNEnacKB/yF/no3M4XjzNMRRv6Kcw/2e+SUoQdmEnEO9U5/cIbZcdKXNdKemA8elt5fBsbfMsDpgPkL0Iu99y+8WR360gCa4Ra+7U/0IN7LD5VO4SiYAmPv1pLOts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779873901; c=relaxed/simple;
	bh=/7Jd4VOaB4qlsCgaarV6w4lXmvP9bq/K6BBHhhAFItE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p2gmbrMvgFei5wF9PGS5e69Nv5qSfUvyPkh5iXN0Fpa32nU4AOTImZJP5Vk/+SVZo+/7dXou6+ZSb2rl5zRKXOfiKOFqLPEnT6U6Hz1/Gl/DHOHcVjydKj/EXVC2lrVDqn4P0xZ165Rek3ffaPLv8K3tHHWzXQ8PUN8KdNuZD8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RKyriFtH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CJuyQYND; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RKyriFtH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CJuyQYND"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64R8mSLH973110
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 09:24:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mlUOP6drrP/Dby3+Bii3q+jW3qXxSn5Z01xfOp7PAWA=; b=RKyriFtHRaOYrUiH
	ERR4WurqZBpACyHWQCNs4uxEs69xEw0Hwg7OOwAatalui54oF4JAz8dKtF8Y/6as
	v5yC6J1t3Vcx+agl//atIjxHtBAmNbSApWa0GZ3K1I/1awQgJp69HmmSsEoLjD+A
	1ostcquQJAi5JBI5EQgOOMkbbq8r9IMmA0cmuuTxtG+2WPp7KIcnda5JjLJfzW2D
	mBd/KabdgjJ8ugUQLria7ItyiJAtPhZZGhOJ82d5eNor9s3EpOCdc4eauasEG4Wo
	t2ruff28PXv4CDTWeEM0C66zE/rWcX9dDxbQ6l+pCNwdssWPLJLSW1hoeZKLNZvf
	YKqy2w==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4edeff3ex5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 09:24:57 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-368edd5fec4so12574710a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 02:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779873897; x=1780478697; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mlUOP6drrP/Dby3+Bii3q+jW3qXxSn5Z01xfOp7PAWA=;
        b=CJuyQYND5rNAyz6lhWrppDP7K/KQll3m9gy0Aiz3NfvGYC8GRA+LfFLkYWKCggvDAm
         OLV1j38yjrAmzjKPK/E8TXCUMg0TuJ4aqdHYKaqtfiJmF0dId0jd2M7DS7poJsBGuIGz
         nUZEi9P1Id3Zq+dwjMfRInn0c5j5CrYmJ60rtyc84KZzX77ZFdI8z4EX742pz/1VDNc2
         1URxEF3Mn7gFnVLQ9wASohbPKdQsK/esOAFxgEcgQBAFcMXRHVNyYwH9By4CQq4YCOW/
         jrRTPsIG5FNuKX7NfEae+6iiFYk30Hia/T+guqDF7s1gG8AzfJqRXb8Lq6BYH84+Wa8X
         6SLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779873897; x=1780478697;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mlUOP6drrP/Dby3+Bii3q+jW3qXxSn5Z01xfOp7PAWA=;
        b=rKhju6HGdNsz6gtmyFMRJRe9ZmVYEC0yuZRgC3X0u+Z9ML0kWDbW00rjCnNvMo2Qz3
         A0HRpoSlMiTAk/JLU8nZe0CCqCrWpodGnKMUJ5rbxXkQNyHbZwcexPlkKYbFgPNVxCn6
         lmRWPuxENYqq5id4N3c22xZPTC1sEgD0p7Ez/obWnzOd62g7aEsNk7j5HRO2zQfhrvOP
         6SjeNRs6KNhH1f+nOcFn0SI87uFsnE8qXMfOgfgAW8fM1GAOFIWhl5RyOdIrJerOm1+q
         l8Amsy8MH7gQalbMLb/mGOJ8kDef9MMTO6o7TAhl3JCfe9+UUohKl1Fp2xk60lAQY7eU
         d6DQ==
X-Forwarded-Encrypted: i=1; AFNElJ/1FP+G3nLElVcrWZ9DkobPdTvbTbfIymyHvcpxFrN7N+CnTIoK5L+9Q0+z2aMyeKkho/gbCKQE2KdV@vger.kernel.org
X-Gm-Message-State: AOJu0YxJLkyZVn8GPKc3UTZJfcQIsTgHppJBLpxy1wNr6f2zQHg/cWB0
	QjHaAhXn8/es/NW/B0rp4qKSPUqudnHh4TAMKbIvBS0NJ3fN0FwHJvcqyZlqPKJOH6+sLKMhlo9
	SxRRApGVb3KejAUif5eZb5xS+DwNhVs5dvgMJdgP3LziRTJqw8SKW4vsUpe+ITjyal/Hla6Ik
X-Gm-Gg: Acq92OERvtSAgtHE2FXcdOALttHEHI8uWDBZ3Ibvj4pBCWQ1G31K8BsLG4IxjcroALc
	ORNL32ag/4DgGLp5wMN6fokd/godmLUoCgHHdusGF3Sfbw7VeHb1MVK+DUrSXAT5zbC77IcXntf
	zOOVdZn6Pnu+rFp66woBLyR/00/wp0Mg5VpPJhTSrwobNL3Mt5HrK+YEfu7zPXFTcFmkK/3A/pF
	Hy56JBbaqdtQss3pUheIiya6BTAcD2XRHTmDHBqj6IPZ/XinLlAFsHnEEXPHjxnd6/Q4OtSdU2l
	SlIiiu+YgJZPAzROuCFmo7dUseoDQjj2nktDJtcRqoraXgFgbaoxMX5ykVyBTmK/yxeGD3VHxXy
	og9eMvl12FyIaJ7Uq5oz1O7PJ57qK6wGxwsrCQ4QpQrWCBYfYdNUnsWuXYKJT2pJMJsNfw3cvrV
	VZuFeBzV884XQ=
X-Received: by 2002:a17:90b:3bcc:b0:367:e244:4c40 with SMTP id 98e67ed59e1d1-36a67893102mr21805520a91.26.1779873896542;
        Wed, 27 May 2026 02:24:56 -0700 (PDT)
X-Received: by 2002:a17:90b:3bcc:b0:367:e244:4c40 with SMTP id 98e67ed59e1d1-36a67893102mr21805494a91.26.1779873896072;
        Wed, 27 May 2026 02:24:56 -0700 (PDT)
Received: from [10.133.33.247] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36ac1fe6df3sm9243334a91.2.2026.05.27.02.24.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 02:24:55 -0700 (PDT)
Message-ID: <1cd587f0-d571-4bd8-a8c0-97248e732cec@oss.qualcomm.com>
Date: Wed, 27 May 2026 17:24:51 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Zhaoming Luo
 <zhml@posteo.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20260523134711.323425-1-can.guo@oss.qualcomm.com>
 <20260523134711.323425-2-can.guo@oss.qualcomm.com>
 <m6qq3kxgfs73jve2pjmmszymgxb7aizdfo2rwg72o66n2rvov2@xkcvifciwu3z>
 <96962564-ff25-4d81-a605-3d9c05fa000a@oss.qualcomm.com>
 <qrqggwpuigevauuzjcvggcmbzkphutemlpsvuymy7qn5yblnsd@djbgzgyeekre>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <qrqggwpuigevauuzjcvggcmbzkphutemlpsvuymy7qn5yblnsd@djbgzgyeekre>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=ONEXGyaB c=1 sm=1 tr=0 ts=6a16b869 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=YG64nluAAAAA:20 a=7UmM63-barXJ9Uf7px8A:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-ORIG-GUID: Jx9h3sfygfQB8VQrjgZTq0xj4jBp8WjM
X-Proofpoint-GUID: Jx9h3sfygfQB8VQrjgZTq0xj4jBp8WjM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDA5MCBTYWx0ZWRfXym5gMCDTGWtx
 cuscbpNDA/bGjAGLbYVZwuY8qYp2oL5c21DrwbLPUL72lH3ghpcYjH54kbQu5qig5fJ+TsHOn13
 ZXXZNLKcIX2GLBRngwPrSiq+Ogv5L92jgSDdr6y8cqd1sOjWe1ud8i1+MG52pzaUxDO9FJPl49V
 hbWs/qJfmf1J2ItcQjEB2Q1jR4KOGY7B54PUBF8A0t3cUwSW/5t9IVoszrsmukkr2H0bI1V0/2T
 f6m8s7oeVwZlcTrLwG1i+ne4HbMdtxYDC4AwuwFJaMZP0trFvHYD2iieTT2X9KzBdSUHIlX5v0W
 860J93SltjRj6LqRZwuYjTmm7lXrNkHZkJIZmz31xDkr/pdeNk0dyu7UWDul4m/3OwbSednvD16
 6X7jqFqn+zYnQG0hSHKy2QgQt/keVstWLD7m9FhUGHVXiTv2jr8uvy75duRmIbVuHgd/yyeve1u
 4AMq0G8nGhyaARnZR+A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_01,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 suspectscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605270090



On 5/27/2026 5:15 PM, Manivannan Sadhasivam wrote:
> On Wed, May 27, 2026 at 04:51:04PM +0800, Can Guo wrote:
>> Hi Mani,
>>
>> On 5/23/2026 10:14 PM, Manivannan Sadhasivam wrote:
>>> On Sat, May 23, 2026 at 06:47:10AM -0700, Can Guo wrote:
>>>> UFS v5.0/UFSHCI v5.0 add HS-G6 support (46.6 Gbps/lane) via UniPro v3.0
>>>> and M-PHY v6.0. In these specs, TX Equalization is defined for all High
>>>> Speed Gears (not only HS-G6) to compensate channel loss and improve signal
>>>> integrity at high speed operation.
>>>>
>>>> For HS-G6, M-PHY uses PAM4 1b1b line coding, Pre-Coding may also be
>>>> required depending on channel characteristics.
>>>>
>>>> Add vendor-neutral DT patternProperties:
>>>> txeq-settings-g[1-6]
>>>>
>>>> Each property is a uint32 array of per-lane tuples:
>>>> (PreShoot, DeEmphasis, PrecodeEn)
>>>>
>>> I don't think combining all EQ settings (PreShoot, DeEmphasis, PrecodeEn) in a
>>> single property as opaque tuples is the right approach. These are three
>>> semantically distinct parameters with independent value ranges. So packing
>>> them into a uint32 array makes validation impossible in the schema.
>>>
>>> AFACIS, PrecodeEn is applicable only to HS-G6 (PAM4), but the proposed
>>> patternProperties forces it into G1-G5 tuples as well, which is semantically
>>> wrong.
>> Point taken for the PrecodeEn.
>>> PCIe binding defines one property per data rate for EQ presets:
>>> https://github.com/devicetree-org/dt-schema/blob/main/dtschema/schemas/pci/pci-bus-common.yaml#L193
>>>
>>> Similarly, UFS should define one property per gear per (like, txeq-preshoot-g6,
>>> txeq-deemphasis-g6, txeq-precode-enable-g6,...) rather than clubbing everything
>>> into opaque tuples.
>> Thanks for the suggestion. I will go with below approach:
>>
>> txeq-preshoot-g6 = <Host Lane 0 PreShoot, Device Lane 0 PreShoot, Host Lane
>> 1 PreShoot, Device Lane 1 PreShoot>;
>> txeq-deemphasis-g6 = <Host Lane 0 DeEmphasis, Device Lane 0 DeEmphasis, Host
>> Lane 1 DeEmphasis, Device Lane 1 DeEmphasis>;
>> txeq-precode-en-g6 = <Host Lane 0 PrecodeEn, Device Lane 0 PrecodeEn, Host
>> Lane 1 PrecodeEn, Device Lane 1 PrecodeEn>;
>>
> How about encoding Host and Device values in a single tuple. Like,
>
> 	txeq-preshoot-g6 = <Lane_0 Host_PreShoot Device_PreShoot>, <Lane 1...>,
Man, I don't like that way to be honest, it took me a few minutes to 
understand it on the PCIe side...

Let's go with my approach please...

Thanks,
Can Guo.
>
> - Mani
>

