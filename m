Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEED36A37C
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 11:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782731300; cv=none; b=XJNJR9CofWkh0V7DsamiRxRi5N/Zxeyp7JJ7sDMR8/gP7fMXE+Y6nZBzvLIur0BBnA/OO2nFVoVD8DLnK1c/+2gLzrW8tW1Iwa59mDBo2UhGU1t0gG7uXZsk2BIck30CG2VnPKRWsR56eK90Gek/8i52gTd5GQQk2Nc3++JaWRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782731300; c=relaxed/simple;
	bh=p5oeSozrPpVmGY6T9fydOAx3xRD71h2scVUiMjk8UZw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fjjrRy7W4wY+wCCJ+WeP1hJLHafV3B/IZPih40/JeOamZFFdIeFLus0UJz9t0aOMBk94tZuAk7oVYJcc5R3R7hfXzrqUvYtFEvAMyUCXAB4vvN710esM4Ycm1/KR1/ZKXy6pIuMHcdz4C8byJUmMvo7KGzrf2r/ltg9/Cm+dbPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=piX7RmSp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OLs1ccOx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="piX7RmSp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OLs1ccOx"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65TATDjQ2578972
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 11:08:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Fn5b8KchpWy8FyyHPcxO27rsnTJuShm2MrGXkaTyXWs=; b=piX7RmSpG530hazT
	Lyl4SB23dacMbmR9OW+0Jtjm0A2hj3jmr2LM9IsfVQmEFHFfRQhSDVnXqicrOz2t
	UMtpV+c7KML71+jW8KL23mV9KQ5QAy5v/F8yZxzkp7PjJTdCrjL+3LfNsE/Eylcz
	s++Y2lXgIm07nPBMQbidh/Mf6VrwMZfPL6KUQMQUOC0h8/2GooZRrCC9YMog5mxO
	aB9q61txPYcp6AdcG9+d8xPe6wnq2wuOm6aY7xdvqDi62+irCcYjWUeJ1R2hGI+a
	kU5E5hvQvp1TU31uCxPiVRtgxXA5RkEbQGd4cGtTVfWnZRN3xNS4o6jB6hko/gXX
	csVqDw==
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com [209.85.221.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f3kp7h144-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 11:08:16 +0000 (GMT)
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-5bd6db76caaso149444e0c.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 04:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782731295; x=1783336095; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fn5b8KchpWy8FyyHPcxO27rsnTJuShm2MrGXkaTyXWs=;
        b=OLs1ccOxZTcVgaFv0p/+hLKSdE06m8YArsy52QAdGTKK7Vdxpa9kwU6URC3jJmjWz+
         x3oKNssjwK4+ZlgKAx43MKsJCY+o2Mk/49oYiRmxMVMbE/RgtzNA7o0mPqBXQc9LDJ1i
         Q86I1uQSmL04wj2hP0fxMXHLdkXISCuAH7gHknwgruQXrWOJDN0L8El9IOml/pIwS0jX
         7shhotTPqFARNN0JfoeJBQ7lLMcgX4WYINszBQiqFFDfH23QGlzyTnKroGfzl6SV0RZB
         YuwO+uOeFwUSCZbgvZCb87WOOp0gJXr3yjl7o549Ac1bei4tAnswsRuepsZi0536Xlo4
         NnDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782731295; x=1783336095;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fn5b8KchpWy8FyyHPcxO27rsnTJuShm2MrGXkaTyXWs=;
        b=UZZKhKqR0OSxWxhVImW+4hNYmg7Q+MqIFJicuvOgfXP9BWJZj0kh8OSV51bjpLuSQF
         zk+/bkR+Ol/4+ybDAShHLS36IF+uoqe5Gp8H3IquGXuIe8NblyNHvLDfwJ0pOQYgb+Fx
         k889nPBKCTPWUdxI+dD1X1bwXjmZ9CxBwUf1AUyckuxh0Msv8IwwtoIH+CEf8Vs5Wi5U
         k7qJxq0xafOCM3KFvF2w7fG3nE7r34SXlJ00rd1AiAAihDMpEhMQfd0biRA6k0xNjbnj
         zOlNUZMysheoht/O+Ltjn9crDCOEt+DJWyX9IeR3nhU+I7yVQMnhsPCE1EuWD5KKSJxn
         Rwtw==
X-Forwarded-Encrypted: i=1; AHgh+RrpMxHOhRnMN8XJDHvYgRjbLVKgveML6nwjNPU7GtrAwHXGgoJgJUJQCEhHT5Rl6IvO8bAACbFqGTY7@vger.kernel.org
X-Gm-Message-State: AOJu0YwsQmQH0o11dzNyLLuaZGaR+Q8loWR08CK6is9Z5k0ETRjpJele
	KuBfW4irWG/HnE5tz/AEFg2K1yloeLL5fJYAmh7T6gQBbyb3AK6z14WDEdIq0TyP8IMHEaP0mgi
	f0ata1+YeAqONQSo3FqkWIjDa0am9TY4kqDUO+sbVAVxhGiujNg+3ajuyh/ViVDRv
X-Gm-Gg: AfdE7cn0Eqdzq4omr2EjAs+1sXZyFoB6wdWKr9zJu5C3I0hGAYlKS14x9J08o+AkAui
	zflDuUXyMcIuk0qwGUBcQIu4XnUd3Z0h/vx4VnWRkvq4aNS41/HF7CaSjAKawyY57KUnNV+NJsx
	/sv/gbIxF0O2jIJckskaf6asTRHLEjhIsTKtlq0e3q0vXZUB+mwSlhzUn4PAWO1/SP/2Kv2v5P7
	YC4p3qt/30m5ICQuufkhDxP5dKbmBq9Z6efMVbBwEtoPoo03jMgjYCVz3JmNvvpV65ocr2E7xA/
	J3JSm2bBB8sNFK+NFObrZrRv4fIF1Jl5AoePQeJzwOCGAy1VTuqcR9dyA9QGuRjsPgc3VGLeKng
	IqGhoYqIB1KWrDfn6A6N+u/pQvXUws/sckEE=
X-Received: by 2002:a05:6102:8017:b0:738:a78f:5483 with SMTP id ada2fe7eead31-738a78f5743mr462616137.2.1782731295153;
        Mon, 29 Jun 2026 04:08:15 -0700 (PDT)
X-Received: by 2002:a05:6102:8017:b0:738:a78f:5483 with SMTP id ada2fe7eead31-738a78f5743mr462596137.2.1782731294673;
        Mon, 29 Jun 2026 04:08:14 -0700 (PDT)
Received: from [192.168.120.170] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-697f4bd36adsm6984719a12.27.2026.06.29.04.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2026 04:08:13 -0700 (PDT)
Message-ID: <cc8678f2-49ab-4754-8102-d567b94e52e9@oss.qualcomm.com>
Date: Mon, 29 Jun 2026 13:08:08 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 1/6] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
 <20260609-enable-ice-clock-scaling-v11-1-1cebc8b3275b@oss.qualcomm.com>
 <d1232243-2f23-423b-84ac-4463eac79f9a@oss.qualcomm.com>
 <ajjloqm9eOkrr5W9@hu-arakshit-hyd.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <ajjloqm9eOkrr5W9@hu-arakshit-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA5MSBTYWx0ZWRfX+NR8u1bEjirI
 0s18AlSW6U3J48pj8+nT/e8j1gduiU1FvbM05ChS8l9xCvxSQNj3sQXaDoZuHH72zg42hU5wTZC
 /79ZBjO2DqjfeA3bVI2SCAy0Z9JZe8o=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA5MSBTYWx0ZWRfXzxuC+TFOnBEx
 MLXksejfwXLqciNG1hnwxKP1h8rJkIjoE5cndrekmiuI7gsXXKHtz/pm8TspcGHhqRStK434t5F
 3QbwYMlx4YCdPGTRSyygK/A8LVqCXr+81Mr9S3xOZLUWLVAoH3NF7PgvWWMSPR2K9utEhPTjepa
 PgKjc/8ardk5d8XLHbFFNyB8Bs1lXGnZnzV+CBT5QUcLwCk/M1q6StF4ZU1HLgw/2LkVCf6XST0
 naBV4PdL9VlJob2HQFHPISVb9cAkm7HcHOOTouDz756IW0YZo7TupeK4CcmDVLVdVKDBJhReiAJ
 fNsJkCYvCeYeyBIoLjP9aVE47lRiAWsNhA3eZeN/LN21v6BVFQJv4Ug2Em6VuunVoJBN46zbzQg
 jiPbYiQMdk3xJkbKLDE2ekemmNfMUbaQL0YtORkXJp2YFIentZ1S+BymSJg9uXk5tSaRQ/WzOk4
 2HE80534yGuAHTaHPuQ==
X-Proofpoint-ORIG-GUID: bTDQtIw8M2SpRsnGrboAf1qPcQ7xsxP7
X-Authority-Analysis: v=2.4 cv=MZJcfZ/f c=1 sm=1 tr=0 ts=6a425220 cx=c_pps
 a=wuOIiItHwq1biOnFUQQHKA==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=Y01jbQKe1eecyiKPCdgA:9 a=QEXdDO2ut3YA:10
 a=XD7yVLdPMpWraOa8Un9W:22
X-Proofpoint-GUID: bTDQtIw8M2SpRsnGrboAf1qPcQ7xsxP7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 clxscore=1015 phishscore=0
 bulkscore=0 impostorscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290091

On 6/22/26 9:34 AM, Abhinaba Rakshit wrote:
> On Thu, Jun 18, 2026 at 03:01:54PM +0200, Konrad Dybcio wrote:
>> On 6/8/26 11:47 PM, Abhinaba Rakshit wrote:
>>> Register optional operation-points-v2 table for ICE device
>>> during device probe. Attach the OPP-table with only the ICE
>>> core clock. Since, dtbinding is on a transition phase to include
>>> iface clock and clock-names, attaching the opp-table to core clock
>>> remains optional such that it does not cause probe failures.
>>>
>>> Introduce clock scaling API qcom_ice_scale_clk which scale ICE
>>> core clock based on the target frequency provided and if a valid
>>> OPP-table is registered. Use round_ceil passed to decide on the
>>> rounding of the clock freq against OPP-table. Clock scaling is
>>> disabled when a valid OPP-table is not registered.
>>>
>>> This ensures when an ICE-device specific OPP table is available,
>>> use the PM OPP framework to manage frequency scaling and maintain
>>> proper power-domain constraints.
>>>
>>> Also, ensure to drop the votes in suspend to prevent power/thermal
>>> retention. Subsequently restore the frequency in resume from
>>> core_clk_freq which stores the last ICE core clock operating frequency.
>>>
>>> Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>>> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
>>> ---
>>
>> [...]
>>
>>> @@ -335,6 +342,11 @@ int qcom_ice_suspend(struct qcom_ice *ice)
>>>  {
>>>  	clk_disable_unprepare(ice->iface_clk);
>>>  	clk_disable_unprepare(ice->core_clk);
>>> +
>>> +	/* Drop the clock votes while suspend */
>>> +	if (ice->has_opp)
>>> +		dev_pm_opp_set_rate(ice->dev, 0);
>>
>> The PM core will quiesce the vote as the device suspends, this is
>> unnecessary. Similarly, the rate restore logic will become unnecessary.
>> Especially since dev_pm_opp_set_rate(0) does not actually do any rate
>> setting.
> 
> This section was earlier discussed in the patchset v4:
> https://lore.kernel.org/all/7b219a50-6971-4a0c-a465-418f8abd5556@oss.qualcomm.com/
> The intention here was to drop the RPMh votes once the device goes to suspend same
> as the storage drivers such as mmc drivers does:
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/drivers/mmc/host/sdhci-msm.c#n2946
> This was done to leave the hanging votes *on* for unused clocks.
> 
> However, I get your point, due to mean to say that once device goes to suspend
> and GDSC power-domain will be turned OFF, it will automatically quiesce the
> performance votes?

When the device's runtime state goes to 'suspended', all votes are
dropped (which then propagates up the power domain tree, effectively
lowering the vote which passes through the GDSC to the parent CX domain)

i.e. "yes"

Konrad
