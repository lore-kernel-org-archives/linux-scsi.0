Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143A5374752
	for <linux-scsi@vger.kernel.org>; Fri,  6 Feb 2026 12:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770380074; cv=none; b=cjqzrESAAz09WxO+C2+f4FcymG7PFLxw6XHqkHtJv91yMeiLM/zs/0QXBeeaOS2Bw0XONqv03yISDzuqPSHYUqejYjghINSsJgm01ZdmslVw/jkWs+Q7s9cFhE7Bry76ongsIRKFPv2BYbewMSMrFyoO3ll0kw+KXLcrJsXJacc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770380074; c=relaxed/simple;
	bh=hXOHsOfXD5mihICS650SxJSJmR9bv1G2AOVi/7XXQao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X0L1GyNjm3ghedVWCilxWjUypv6V94R9Y8/NlUS5hxxPA/VRiOQH9NuseoPyDMJoN+ykPNHiEaRf3/2VWNE8R4OsW1ZzXvKVbMhCHollio6MTPiKehpDmcKqqYeB+7r1ubVRURpmz6NeJdModH6Dnf3p61k+GdwuMlXqpptC+K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XNSCitHk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WJJIpzhV; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XNSCitHk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WJJIpzhV"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6168ZjNf1420290
	for <linux-scsi@vger.kernel.org>; Fri, 6 Feb 2026 12:14:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nT6FRmnp0Jch+N2M4b/OnTDlejboaGGpjvhRTjZezn0=; b=XNSCitHkatb8Glw5
	93KTK4J2Y5PXTy2rrw1uAHzn641Wpl/Aj5UveMCfi+6wf9Mw3VKLY/zu+z2nmZbd
	Jl4af+5JoEpecqqPdnEhRYK4VVbMTQUOVvuiDBszCrd8x0CvEj8iY+T0O+ocPjM3
	dDh2kXnHLL4K69lT3OOqSTujaIAenh+l8GkgzbQzzcrBzu6w/NiG+DabkuabCpF7
	UNyQzR887QL93oUNiM9sV2SHoyz5L4CQul9/K6vqrnTV9Kt5o0u1b48x7g67OQDQ
	pjaZt1ePr8SxaCMHmQM0cgfS6BUXy6n0VnFdtASAuGeMKq3lINIPc5SFbuLx42rd
	R/il9A==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c50a9b7k5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 06 Feb 2026 12:14:32 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8c6de73fab8so71400985a.3
        for <linux-scsi@vger.kernel.org>; Fri, 06 Feb 2026 04:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770380072; x=1770984872; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nT6FRmnp0Jch+N2M4b/OnTDlejboaGGpjvhRTjZezn0=;
        b=WJJIpzhVYjR8FWIeZiDPIz5WzxqWl+bfFvf8ZtleGdFNBpOXCWJOQ0xk8GchLgz2E2
         AdkiqC6kpWsVw80JFQQtljAFs7NLZQfWPkhadvJ388EoHV3W72SDbokMkJW07QABF5zO
         utRF+DqfoEGPYVkW+2DApwP0h+792N/K40OPwZrcnoTHiv/GY6fY+ejBblTGEmLS/R/l
         Ws/VaBNZozJRw9eSnzpCHl4kfL68vMznNaaZliKKeLfBwcc6YWrll9HsJDX6qgBBVNUh
         UNmAHxGVVfFa7Wcg4Zq52nh4JqQc6bV1NXWaNWl1HJfpWGIPYW+65BHCdmqqSRmeFptn
         hYmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770380072; x=1770984872;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nT6FRmnp0Jch+N2M4b/OnTDlejboaGGpjvhRTjZezn0=;
        b=o5TB9AEwtby1ykWcs1Rs/+H90Oo5igb3JKapfmSHJC3khvBKB6ERMCURe7S3Aab553
         ykkvSl7CSj+eY1tuBacsx4rR3dtN7jQ1wUWTectDT0aiIsXqY4N5X4Nu+Uuq4smtMJNh
         Q6CuXFo8s+XnGn21chvnuwg22N3E5BRc/GYEM5fjFaj+b/fsg6JsP6I2NXPGIH6135hP
         ruv+Av++bQFRZdlT1uRd4vI8bUfmjhpgDJ4j1Dm0ZfWOhHPTSHQ63RRPVadEiOTTPcXU
         WmYnAhV5pYTC3e6ELH9f8GRB27spLaVnuFTj9st/W1ghs+zWSsFHMJzFXWZMB2FPJfVM
         ZoBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVooQh1ZBXG0QDUkIm25wEP3cHJc9wHKm3Asl0N3o/FduAnCTyMAUqHz7umH3xpnqTpCGiUejwprFUN@vger.kernel.org
X-Gm-Message-State: AOJu0YwaDmNUzFHJviSTWcXxuZv0n2q8NpRs9Gmm5GTPbWk1kfmgseHg
	Xgn6jzHz6dsO6xBfc0sv8Axjj4liAgMMJ72u22EBEH3q7zQKUMIr80WkD5ymjxU5vtkkNOdhywI
	8AAWFd6TkOBf2TVLjMLdzNuqWSQ04dg4Dn7f8v1ZtXIrMQDjRdZcEBxwHRutxZfeQ
X-Gm-Gg: AZuq6aLXwRxG4sjtb8/S3Osk2tSQeJon8fCUhqktsCVj7t682sop60AwW/rz70+PHX5
	+DUWVJy7wEXpYBRJLqS7sKuCOh0J5e0cTbUUx0HtGRaXyarpMR7rWKxwuhDnsy+GnXSg0V4wF4l
	ONIqBav5rfCNPm/3qljf/xFtSb58zUaEMpBqRLnQfLerrUfBHsdIS1jbe61lelUpdOp4sl5WFBm
	+bGG+EdUDLLJUVSCQRLTjjJrKGNpyBX5mvzjewuEt6jmCnkyss79gkvHPVfH7pNYvOZBWlkw6SB
	LxpxD2jzEliIAoaTWtSJ0jzWTKBDE85gK8gHDxUMacn6hUeA7p6NX2fFOPBMMNM2u/O2s/0ziWX
	GdXDUTPiPLeS9PQ6u4NuUc6QPCXxx/bUOwqOnidX7OU5Cd00DkVkyFSesjQbgiVAXyrE=
X-Received: by 2002:a05:620a:3185:b0:8c9:eee0:dba6 with SMTP id af79cd13be357-8caf0e3369dmr227574185a.7.1770380072237;
        Fri, 06 Feb 2026 04:14:32 -0800 (PST)
X-Received: by 2002:a05:620a:3185:b0:8c9:eee0:dba6 with SMTP id af79cd13be357-8caf0e3369dmr227570485a.7.1770380071701;
        Fri, 06 Feb 2026 04:14:31 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8edacf1532sm76010066b.55.2026.02.06.04.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Feb 2026 04:14:31 -0800 (PST)
Message-ID: <32e65de3-5466-4a91-b7d7-9c0ab9531ef3@oss.qualcomm.com>
Date: Fri, 6 Feb 2026 13:14:28 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] Enable ICE clock scaling
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
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <7b219a50-6971-4a0c-a465-418f8abd5556@oss.qualcomm.com>
 <aYBF3Geeuq2qHmYg@hu-arakshit-hyd.qualcomm.com>
 <cac8e14e-63e4-462a-a505-cd64e81b2d1d@oss.qualcomm.com>
 <aYXYmnFiFbZnVRqX@hu-arakshit-hyd.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <aYXYmnFiFbZnVRqX@hu-arakshit-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: iCtSGnDkVFB7yt2gdVGUzKbwP9pzufm5
X-Proofpoint-ORIG-GUID: iCtSGnDkVFB7yt2gdVGUzKbwP9pzufm5
X-Authority-Analysis: v=2.4 cv=e6ALiKp/ c=1 sm=1 tr=0 ts=6985db28 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=WEYNnfNoJtBL0Lpg3fAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA4NSBTYWx0ZWRfX+8mXgZdP9M7s
 NBdzBAimijh2GDVBVFjPacBjYtVWuTw9EDSgJum5/RnvekVr8uXf7Pt7veB9rSK+IZAMGB9zncH
 fLhMNl4lDK4PXExmU3pEUopSMTXFmUrPWy+vTMKwuouzqJ4V12HSKceGvGoEwVrv8DwwOOux91C
 xmQ30MBRI8D7NTm0D/lFUlybNcMLl/ZlKrgSIDjKYdFsxMtGbb4sQ/Dq5Dn6A8Kg+HE6YhEVuTE
 weOT3IVcnT5cv4/ZoBuWzFPc4aW8X9aZ+kq3fegHFu4GfMe9cKEMeEJ9dwNhNNXHREUAbjk03DB
 agXDIoI7zonZB8XaXMz6RaNk/HdqxKIHNGWM1niaBz4YyPjgXgWI+YZmBpdQux4fcm63F0+YJYi
 Z4/c0Ii5KerKxAur+Snf33rD6rzMKfIgEjlXoAfrfGy0SH+wt4feyPrMV0W62KNLD8ftCQDq9g2
 /90w4s+EAL8cEgZI52g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_03,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602060085

On 2/6/26 1:03 PM, Abhinaba Rakshit wrote:
> On Mon, Feb 02, 2026 at 04:01:38PM +0100, Konrad Dybcio wrote:
>> On 2/2/26 7:36 AM, Abhinaba Rakshit wrote:
>>> On Thu, Jan 29, 2026 at 01:17:51PM +0100, Konrad Dybcio wrote:
>>>> On 1/28/26 9:46 AM, Abhinaba Rakshit wrote:
>>>>> Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
>>>>> using the OPP framework. During ICE device probe, the driver now attempts to
>>>>> parse an optional OPP table from the ICE-specific device tree node to
>>>>> determine minimum and maximum supported frequencies for DVFS-aware operations.
>>>>> API qcom_ice_scale_clk is exposed by ICE driver and is invoked by UFS host
>>>>> controller driver in response to clock scaling requests, ensuring coordination
>>>>> between ICE and host controller.
>>>>>
>>>>> For MMC controllers that do not support clock scaling, the ICE clock frequency
>>>>> is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
>>>>> consistent operation.
>>>>
>>>> You skipped that bit, so I had to do a little digging..
>>>>
>>>> This paragraph sounds scary on the surface, as leaving a TURBO vote hanging
>>>> would absolutely wreck the power/thermal profile of a running device,
>>>> however sdhci-msm's autosuspend functions quiesce the ICE by calling
>>>> qcom_ice_suspend()
>>>>
>>>> I think you're missing a dev_pm_opp_set(dev, NULL) or so in that function
>>>> and a mirrored restore in _resume
>>>
>>> Thanks for pointing this out, its an important piece which is missed.
>>> We can use dev_pm_opp_set_rate(dev, 0/min_freq) in _suspend and restore the
>>
>> FWIW
>>
>> dev_pm_opp_set_rate(0) will drop the rpmh vote altogether and NOT
>> disable the clock or change its rate
>>
>> dev_pm_opp_set_rate(min_freq) will *lower* the rpmh vote and DO
>> set_rate (the clock is also left on)
>>
>> Konrad
>>
> 
> Thanks for the info.
> I guess, dev_pm_opp_set_rate(dev, 0) seems more ideal as this is
> API is for full quiesce mode and the clocks are anyway gated in
> the suspend call (clk_disable_unprepare).

Yeah, please make sure to call dev_pm_opp_set_rate(0) *after* you
disable the clock though, to make sure we don't brownout

Konrad
