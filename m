Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5422E3168E8
	for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2026 09:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771580584; cv=none; b=JgJJMMeYXM2qMZ6y/SbM6wyqDJGVUoNkbxmVRfU6reoHZ159YqlB8qx4b2ynhQ4WD5x1TUMvFoNLzzRZRQffw/dE7ETeq3CVqAacGUJw/daDHJVrArahP3jd85ZM+ebhqPXxhTf0Ob97lZwR3XY30q5wPtvI2CefZ6gNaC9SFqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771580584; c=relaxed/simple;
	bh=CiWq+Xs4vmJh57HSDRnCX837eKkd1jg+USAW7LmCI34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K7e4cbwUrR430aKjN9F+C9WmQgYC+qt+a6O9GK1/KtCzxlUNZzllVj8tuNdX5H0hLlXnRNrQ4W8pgms0wiOzt0PQMK1da4Io/yPzND8VGFwKiEeEi7gQte2KgitHvm0VCBEfqOEQbTP1WC5dK7Yf14TZQPCYCDYWcGyYZ+vXc8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SigV1Ufs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LwWpa0tl; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SigV1Ufs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LwWpa0tl"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61K5SACY3034855
	for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2026 09:43:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Yq1Y/8D7dzvVWIg3adPvOmmq+xjHtt7YPV2lZuHm6v4=; b=SigV1UfsG8k21zWZ
	/++sdX/4++YVit6xZK1BheTCMXHzNp2CG3RyP6/BIplNRTUcEzTpxRWX7klVcJeF
	y9sMsznn/5KK5p9uLcxScVq9j7MivdK4gCJ9PsIZfw1jXKlJlPMEFYcn//GMGbGN
	oNfOF6xCfAB7N/cgLvY7brbgjpZTeMWpVKTz+4zuezbjjKs2xt0xi6AUG825rddn
	g9/QOEt772XFRPo0n0MslBOt1IsVF9HxxpyvJLGNLRF7UhWVn2P77f29H3zIz6BI
	1nSDTOE8XmieNAurj2Qh55hft3NXxun+J8yUnPXmtFWHAOJ7/85Qm0EUDxkcoZcp
	g7/+dg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ce6k02dte-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2026 09:43:02 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8cb38346fdbso181639685a.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2026 01:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771580581; x=1772185381; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Yq1Y/8D7dzvVWIg3adPvOmmq+xjHtt7YPV2lZuHm6v4=;
        b=LwWpa0tl+E1Tghqp3YpvzG+bVrvB1Eb1M9Yw2Ge4ICrJ/Ec2FnxG9I9SZn2W4NyJfh
         x2w54JLp3x+LnT5TY+ke+vsXo0xLCx5uMRJOITlPn/wlaY54OJZGAAhQ9wmrRkKjLF1Y
         R5cF6tHJOHj5Q0KpDoKuoTKu4Kcrs64tI8SmGEuApJud9SXwg+zGBVTUc1QEQUAatUm8
         p18EhTnwL5TwbhKCHnTkDOWYJCUm2/HgAcmFlPTMBScfUSHq8/Tml6T6R/kc6Ig2aiPp
         /drqUEC3R7KKoCxKN41QregsLvNqDxJyxspMbd5YQ0UT2AYKYcgs6/t8nXLrVMmQh8dI
         dZAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771580581; x=1772185381;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yq1Y/8D7dzvVWIg3adPvOmmq+xjHtt7YPV2lZuHm6v4=;
        b=CMlXk29li2AYpGnJ/akSRjXwIKpdApfCYhwhBxFsuaXCx5OI1++3QfgG3C5ShjLeV/
         HN6bhCPGjd2fyp8Gc0V5p9QYgqi4DfDT1NQUFb12bqDyoIfxoxR9/OW+18J7aMqeyW3l
         U9qU3U6wJ38I6s3L8WE4Ii/6ihbhk1EwryzLXmFvB7vQzOH71+fCBq2Ae78kdg+nOVNv
         Lvqv8ik5j8BpP08naQ9qj73jJZAoZFlys4EbqIutV3lViIVUGlUBf8mErpk3P2Iterr5
         eRl8hYTGy4lzdVq4mkD0cj57ziZpg6FAFMkYEHXnwmcEIHnQBBklKkxDw1cCV4KdPogB
         bCDg==
X-Forwarded-Encrypted: i=1; AJvYcCWK0/n4r1ztfC0Xo8c1q//uZ06pG8WpPNtF8tPOq3sp6FbgbgM2hkaG9J5gBGZXzg7Up255WNK1vaFE@vger.kernel.org
X-Gm-Message-State: AOJu0YxSogCHbbbP3+z8fMOoD7O8mBDxNns6C1t+4/JNFNdxxxqEwiuA
	7Z23JEjikpTrZGOTKXXajVfaoMt8WVwuUXXs7yDC2dO2svMWpW/imIk0d6qnPplswPf8u5gVksJ
	TAja3t8jIs9gQgmJPyZ0PL2WIE5QYyY3MuYuUjGQinF+c8B8TsOCbxm5yC/QMUzBM
X-Gm-Gg: AZuq6aJhaI1A3L34vqa+FuUM+nqqw6T8qespsLTU/ZyHrk9F05xF297ZBhnXRaoT/hY
	zQtQL1b9E4F3oFgAEQCpPRxn06vd6tV7oc9ZGOUXYRXaOXI6C6oIxPNqZMmtXr0zh0Kck9yBhpj
	sHhxwEN8KF2lWmcQPyZqwG5GaqgvIMrVv+mGpgajVtH3gx5dsDVQd5Rec4saHT5sZUY7jA9Stft
	WqhHKhtz1xFN1h/gk7natXSnaTp+4CDUJ7QHzGqHVX8c3g/iT+rA/atAA7ngduiZWi7LH3Wq49P
	Y+52Ea5tv9LAN9E0yM4oGV6PR83OFF9iAnASHlsJpZQoQrDPvvpTAx0z09LbenRVbUIAhh8nHnR
	A773r05mKe53qb1gR7trTHL6/3JhS/qC6qNxdGXAgphdlbf/16TvMT6StX/KexF0wo4tzZDmlc+
	6VdAo=
X-Received: by 2002:a05:620a:5dd1:b0:8cb:47cc:2dc8 with SMTP id af79cd13be357-8cb47cc3ad5mr1716687985a.3.1771580581647;
        Fri, 20 Feb 2026 01:43:01 -0800 (PST)
X-Received: by 2002:a05:620a:5dd1:b0:8cb:47cc:2dc8 with SMTP id af79cd13be357-8cb47cc3ad5mr1716684785a.3.1771580581218;
        Fri, 20 Feb 2026 01:43:01 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65bad4fa7c7sm4793620a12.31.2026.02.20.01.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Feb 2026 01:43:00 -0800 (PST)
Message-ID: <5bf31bf9-835b-4b87-a4d0-8452d516f13c@oss.qualcomm.com>
Date: Fri, 20 Feb 2026 10:42:58 +0100
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
 <6d2c99c4-3fe0-4e79-94e8-98b752158bd6@oss.qualcomm.com>
 <aZgOUv+QweA7vE1W@hu-arakshit-hyd.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <aZgOUv+QweA7vE1W@hu-arakshit-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDA4NCBTYWx0ZWRfX7Gl+3THRMoQo
 CMSZWyHX1LzlIkHIlr9urG3BANiKAshdLzL/NqIYw58YP0kTi5UTkrhObguRqUzWFJhI3p66mhw
 Sf86/aJ6aWozKhdzK2MvmHsCkFXB/O1Q4erJKWZn3AopyTiZ+1Gc0vndA3BgBdDibc5azMf3FAA
 Tzlv32FmrEDblsl223cZvwI/NlxIOTnkvd3XmHWUHbQRLhYTkgsbwWwMnOH+U9hV/FPScCTVAhy
 gkiGxRsB3n5fa7MXH7SZ8HUKNf1K0cRU8pKCBcbH6I9jQD2eDdBQVmW/Ud4uNfoJRE4bWzS1DPU
 L5wDTnJzgW3oUUTYzuTPT277xcdwg7YF65ufQLNqcUIHSBcMGLBJZMJY3gnPa2uwZYG/vMGsjct
 3y9uznARi8UHfe4V/o7X6T2M4swobZISqElUq1Pn4e1us8PDShM79AV67mEyZvYWn5Fz1Nl6Cz0
 wmTaTiR3HPqomPS7tnw==
X-Proofpoint-ORIG-GUID: JEYMNZSFqQsmESy88TlAzH0U8-5IEjE6
X-Authority-Analysis: v=2.4 cv=K6Ev3iWI c=1 sm=1 tr=0 ts=69982ca6 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=A-1GGxaxaoYmO2IoDNcA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: JEYMNZSFqQsmESy88TlAzH0U8-5IEjE6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-20_01,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602200084

On 2/20/26 8:33 AM, Abhinaba Rakshit wrote:
> On Thu, Feb 19, 2026 at 03:20:31PM +0100, Konrad Dybcio wrote:
>> On 2/18/26 8:02 PM, Abhinaba Rakshit wrote:
>>> On Mon, Feb 16, 2026 at 01:18:57PM +0100, Konrad Dybcio wrote:
>>>> On 2/13/26 8:02 AM, Abhinaba Rakshit wrote:
>>>>> On Thu, Feb 12, 2026 at 12:30:00PM +0100, Konrad Dybcio wrote:
>>>>>> On 2/11/26 10:47 AM, Abhinaba Rakshit wrote:
>>>>>>> Register optional operation-points-v2 table for ICE device
>>>>>>> and aquire its minimum and maximum frequency during ICE
>>>>>>> device probe.
>>
>> [...]
>>
>>>>> However, my main concern was for the corner cases, where:
>>>>> (target_freq > max && ROUND_CEIL)
>>>>> and
>>>>> (target_freq < min && ROUND_FLOOR)
>>>>> In both the cases, the OPP APIs will fail and the clock remains unchanged.
>>>>
>>>> I would argue that's expected behavior, if the requested rate can not
>>>> be achieved, the "set_rate"-like function should fail
>>>>
>>>>> Hence, I added the checks to make the API as generic/robust as possible.
>>>>
>>>> AFAICT we generally set storage_ctrl_rate == ice_clk_rate with some slight
>>>> play, but the latter never goes above the FMAX of the former
>>>>
>>>> For the second case, I'm not sure it's valid. For "find lowest rate" I would
>>>> expect find_freq_*ceil*(rate=0). For other cases of scale-down I would expect
>>>> that we want to keep the clock at >= (or ideally == )storage_ctrl_clk anyway
>>>> so I'm not sure _floor() is useful
>>>
>>> Clear, I guess, the idea is to ensure ice-clk <= storage-clk in case of scale_up
>>> and ice-clk >= storage-clk in case of scale_down.
>>
>> I don't quite understand the first case (ice <= storage for scale_up), could you
>> please elaborate?
> 
> Here I basically mean to say is that, as you mentioned "we generally set
> storage_ctrl_rate == ice_clk_rate, but latter never goes above the FMAX of the former".
> I guess, the ideal way to handle this is to ensure using _floor when we want to scale_up.
> This ensures the ice_clk does not vote for more that what storage_ctrl is running on.

Right, but what I was asking specifically is why we don't want that to happen

> Also, this avoids the corner case, where target_freq provided is higher that the supporter
> rates (descriped in ICE OPP-table) for ICE, using _ceil makes no sense.

This is potentially a valid concern, do we have cases of storage_clk > ice_clk?

Konrad
