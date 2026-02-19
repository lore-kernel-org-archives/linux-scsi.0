Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3792FD691
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 14:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771510839; cv=none; b=k08MTgfOtZXnHI+CpMxTk2CUlR7tuvp0Bp/odC7eE8FEKMtZl+oww3jsrFfkkeMlLmV+qYpNkAA7uS3vyp8HlpFlH9ZTjYKuD7LOtLcKDci1nncPDkV4BPQ7LHoq3hVe4KRqLGGsLYkjCPFh8uPQEYo5R/CCJ3rZSrBgsxToal8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771510839; c=relaxed/simple;
	bh=EoTRB37SeccKHBtVBHrYRty94wgbxpHZAwwtK3YUt1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ohCyVhor9hlY6WRZXZzVX3XU3+qkxTpaM0qUW7FYFcbq6REVzv0qG+S4ggrg1yA8S3ETxJ8xSE1z/6iWYbsX21KvLRcx1QpiQ62CSGBaisQebbWViSTDk/hAX0Pumdfpt8iNjEFUUVOGmWCEb8rwQTtSRt47nPo1wR6m7GYDN/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=myhzW81f; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=frtjub29; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="myhzW81f";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="frtjub29"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61JBNOcn3566862
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 14:20:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	AY6SzcgnN1ygLs6NoU90S60oq4F1AC43RaLiXbNMb7k=; b=myhzW81fJU9IimI0
	N0kmSTdqXiTLyaj9ehFU8/Y+CBje0zMUUVH0Dn9tAHEIxiOdn1aLBAyask+DHIbG
	YQKcwl79BFSGG4Pu/YbVs74vwQfwIoU++NROHLJUoVdXQpUWpI7q2rjAnanrl2r7
	aJ0WJzuhTKpkBfrG+Y1Dl1Sd7orJgArMjzn0ptVktb6ILOC0oNJAVZnK0cyFXEGk
	vNuBx//ZWqApdEN2u8L1GtNcC7imubi8NdRBBY/SwMjAVahSMaloej5O+uS5I5Es
	5aLlud4ZBAF4v0/zTf4bll3Np5hcx8bzHXvoB4Mir0aN93WvPNolfv4ZjeXXbESa
	cWyKbg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ce1k80gs2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 14:20:37 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8c70c91c8b0so83493885a.2
        for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 06:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771510837; x=1772115637; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AY6SzcgnN1ygLs6NoU90S60oq4F1AC43RaLiXbNMb7k=;
        b=frtjub29bpGWI9jaL5/HfGCXWDFcravH3rJscz0lSsJZhU2i2OgIukDRuAGkQu0gc+
         UBwZEAWoyywveSJR8uQjYfXRmCyEUYRg7QZknLmGlOasdzYzxdwLihn/IPHhrutW+ZYb
         iME46pqaDnZKNA6yyjqMlan5pxac+OzfSr+Tx5av9EdY3Am4dTAbpfkjsmuBqO1dIf+Z
         ytFPm9py7bogyryWBVhJ6Gm05YPUDvl8PYBGOn24wBHLF6rjv8eSGs6yT3tNExL8TVpS
         L1RoH9d+bWH2wDQpM8rY7UJRBfnYY12UbYUrcsn6xgP3XH1J2ICnzYpm1/Dxqp/Jn4ty
         zEcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771510837; x=1772115637;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AY6SzcgnN1ygLs6NoU90S60oq4F1AC43RaLiXbNMb7k=;
        b=ZTm4gFl7i1yzGUGQ12uX9XkIiPmSlPEUY2DF7FC2r6kpPYCUDmQ6c9j1gw8EMNMWsl
         RJgWeubUqwG9Ii8Es9f8MONlpJ0W8g09DIWu34vgsBewbAxPzGWZ5ip1DX+XdfgiDiMM
         cn7KPydH5c9Dv/2QkAPn6P9GecwlFklDAAFkHzDgxJTU6geYpbTSCWinmvtyFZeUB0s8
         q5CiTj9rb5hS/UDF6pfnxSuvvKXSv23t8OAYy3PkEB7HsItqyrzQJy7jaA6T/9uNkh1F
         2e07YWv2d6yNHSdRy4QUsI2IItgtDa5TzzX4z6M19GsDUAPNwVl45+unk48fWlXRoBYa
         TiXw==
X-Forwarded-Encrypted: i=1; AJvYcCURVCTCl+L7IJcOYOICScBpRylFiL0CRnNfPvREV3TUzef6DeoeVQUTIVqnxS/7YeXWxPv7pR2kq2uh@vger.kernel.org
X-Gm-Message-State: AOJu0Yycf3h7IWij3HAzvIYaednlfPwaDRs1Nu42kbfJdcapvM9v2gP8
	GjVRT9ecXmWxwXuU9TzEKNvbHc7x5WQ/STSWEA2DlwroXj1iYYpHJSsT4h44xGQlbd8WPX3jv/d
	zL5V+AALnZKPOj1A6RKvsBLgJJa0r8mA0J0NEPdDvIXN3Faf6rMYdUGoSZJV9Aa4s
X-Gm-Gg: AZuq6aK2QTlqQmK2w+ZvddYxGrKIEIykliZbuQcwwtEf2LZiYLEae/gBLQ/08787Qvm
	U1fanm4Hd8OowmZ1qzX9/jrNk/SPS41XX+se1/SPeM+3wysG5TKiW3qJw2P3j7pQrX+kASsZjBn
	BnzwgYWk3tJEoeX1DgMF+nid4quWG14RILB+885lhvqu7v8S7UCW/8ahwgmoHVTY1QF65alqEIy
	pckRKXAzHJyWI1AzQH5riEstIob6raVLNQmPAUzg/mpp9lnX9c9GIR1gcTCotnl6w/ly0VPh30F
	rFSUg6f7ni6mmCMvO2EiSnvPrC1BhOlgrhr1qhmM1dVJo4MSI6xx+0pgGMtc9SiGzSE8U1iahPl
	Ae3lzNdlKnp+P88YuESh6pV4A3tNCu8rCaOfkiCJDI+CLxOA8AioOjXBzWjFKqnpOr+bzgj4go9
	VV9AQ=
X-Received: by 2002:a05:620a:318b:b0:8c6:e2a7:ad1c with SMTP id af79cd13be357-8cb40850a4bmr2122380885a.5.1771510836609;
        Thu, 19 Feb 2026 06:20:36 -0800 (PST)
X-Received: by 2002:a05:620a:318b:b0:8c6:e2a7:ad1c with SMTP id af79cd13be357-8cb40850a4bmr2122375785a.5.1771510835889;
        Thu, 19 Feb 2026 06:20:35 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9048d96bb0sm116689366b.18.2026.02.19.06.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Feb 2026 06:20:35 -0800 (PST)
Message-ID: <6d2c99c4-3fe0-4e79-94e8-98b752158bd6@oss.qualcomm.com>
Date: Thu, 19 Feb 2026 15:20:31 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
References: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
 <20260211-enable-ufs-ice-clock-scaling-v5-2-221c520a1f2e@oss.qualcomm.com>
 <bfbe04db-bf64-418b-a75a-88879bf0bf2d@oss.qualcomm.com>
 <aY7MidG/Kcrs83O9@hu-arakshit-hyd.qualcomm.com>
 <3ecb8d08-64cb-4fe1-bebd-1532dc5a86af@oss.qualcomm.com>
 <aZYMwyEQD9RPQnjs@hu-arakshit-hyd.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <aZYMwyEQD9RPQnjs@hu-arakshit-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: whc83nlRifW2MaIVad8_As6zCfyuGtQW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDEzMCBTYWx0ZWRfX1ZaSJ+vE37ts
 ZAJz+eRTJR9zSTnmy9/U+gCX2f0W/1jSpaY84Dj7y9Qf8dMbUwNKoKolt3P5aDu1XSen99+oSGB
 0XM8hZdS8t5XM1kY8jdEOks+Mh71/UdP1iEF2zbd46zRaKoH/Ks7aOIi0RYd1PbU6fzESNILTKa
 y/vKxeb8ynGflVn0hmoSOxZhqR+uwDDIwxxG72Fpp8E6JJ3XqgY3Xdr4Oup7XGmoSx1cvbuP2KO
 glVON8bsgMqpnjMgcmYAcDEbpHuoRIX0NC3gsdYkufFKwJLxZK9/8a9pCR918HnMzRKT1/3Iv6T
 DvqM9n0qTcL3iB+H7OSZi2wxOun7aRHbpQpOxczcAscchE+cKQU1zE5mSEZivcK6cJkLkhv5xC4
 pHnetKBh7ljZhhStSCZrlkZu5qwcPjjSqAHWX0HI8dMWJVmIKXn6uY9SddLIZAUxUSadK0+laF1
 hY8r66GjtfM1i+/18kw==
X-Authority-Analysis: v=2.4 cv=cdrfb3DM c=1 sm=1 tr=0 ts=69971c35 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=VczSQE6j7Ae0sFSu3OgA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: whc83nlRifW2MaIVad8_As6zCfyuGtQW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_04,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602190130

On 2/18/26 8:02 PM, Abhinaba Rakshit wrote:
> On Mon, Feb 16, 2026 at 01:18:57PM +0100, Konrad Dybcio wrote:
>> On 2/13/26 8:02 AM, Abhinaba Rakshit wrote:
>>> On Thu, Feb 12, 2026 at 12:30:00PM +0100, Konrad Dybcio wrote:
>>>> On 2/11/26 10:47 AM, Abhinaba Rakshit wrote:
>>>>> Register optional operation-points-v2 table for ICE device
>>>>> and aquire its minimum and maximum frequency during ICE
>>>>> device probe.

[...]

>>> However, my main concern was for the corner cases, where:
>>> (target_freq > max && ROUND_CEIL)
>>> and
>>> (target_freq < min && ROUND_FLOOR)
>>> In both the cases, the OPP APIs will fail and the clock remains unchanged.
>>
>> I would argue that's expected behavior, if the requested rate can not
>> be achieved, the "set_rate"-like function should fail
>>
>>> Hence, I added the checks to make the API as generic/robust as possible.
>>
>> AFAICT we generally set storage_ctrl_rate == ice_clk_rate with some slight
>> play, but the latter never goes above the FMAX of the former
>>
>> For the second case, I'm not sure it's valid. For "find lowest rate" I would
>> expect find_freq_*ceil*(rate=0). For other cases of scale-down I would expect
>> that we want to keep the clock at >= (or ideally == )storage_ctrl_clk anyway
>> so I'm not sure _floor() is useful
> 
> Clear, I guess, the idea is to ensure ice-clk <= storage-clk in case of scale_up
> and ice-clk >= storage-clk in case of scale_down.

I don't quite understand the first case (ice <= storage for scale_up), could you
please elaborate?

Konrad
