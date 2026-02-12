Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09C33563FF
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 12:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770897926; cv=none; b=D275cL+ll4b/4rSY+qENDiFWBc/ydvEftFF/sdP9O/Lp/bVmD6IIo0iAx0B4oHvDW2MSEyqjAXhZi9qWo1SQkow94x5D98fVcKgX3MOibVrXzkQmDEJZsSeXF82XDOoHeRekJ6qqOU9UG8HQ5/vMaeteVLzGltLyfdq21qcPiZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770897926; c=relaxed/simple;
	bh=o2GFVDqXiSLUKn8UeGbPsRZ1svvguHIXozzWU8zIjZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hpw04Z6aUdbeZjCikn/DhbQc2BkFnD9QM/UX7uUV0gyxc9ZEqQoSeGGvvSqeOBchD2WkboC6gbAhQXLuIl87XMTH52VPS4Fs4Ncx//K0NCE1e3BhM3UEz7wSiwMzyGOXjpDq7MXt7ydD2GTgoMNW0XCMQVP+r6SRTjwBn9VNdWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VpJqUq1x; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=P1rG4Dbv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VpJqUq1x";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="P1rG4Dbv"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61CAFmh4008898
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 12:05:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qHpGzoa3aopZAtJxfvEehMpSqEZ816kpOkyer+YIROI=; b=VpJqUq1x4U4uaVZ0
	8uMfx/11i4i/O5tLZzXy9biQVtAsH1gyOQ2Mj1AfY4TeKOG/LBF20+CuJyem2Cth
	psNooWPvjpsD/Tf1BdqcXBY545Clbx176K/2RbxMRGF/16J05Row/CnpYKA+R5fV
	FStFEkGpClfx8tltg8a1yC3ZAAMpx0PvwInuYx0vzO+qIuQ7whWGT6t7Xarxv74e
	7h7Rt4NHZrk4mZpvZCmx9b+fqQm1IVWKRCAFzhW6t0/WOGzzIBkmzLPAk5MjVEJ+
	JfzpxWIWTnSW/AMnl3wzEOksBV9rJSUZlL7Ocb34lfRU0bntKCSHIqVahF+X70x/
	Y/GgIQ==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c9cy48a04-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 12:05:24 +0000 (GMT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-89547ddf32bso17414786d6.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 04:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770897924; x=1771502724; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qHpGzoa3aopZAtJxfvEehMpSqEZ816kpOkyer+YIROI=;
        b=P1rG4DbvXTwogHQiPHoJA46cssDjLbzEelbSKm44tAYDctVIm0jXhV81hu5vZ4k/oe
         W/mCZdUZQwFIGYU/Bjl1iY5aSzJcD/Kfk7qXZ0xQHcWntxmSn8outCZ5YFE2hI4MPtlO
         Ipa9A4UebWQ/qPnZkkQldapqb3adRk2npWpdR85KmkU1yg8RkyWkGjtlfVYVyJsWOPFi
         lGRO4wtoDavpcfffbA7PJDBQERUlkB+AbDfFUz9/KbWe9yujCxkJz5CVhPfpa6gJ4Yh8
         1CjN0Sb5ICL382FMalaEW+ukEgI8SoT8W/PJcA374bWA0we33sMw817BBezZKGp4zs9g
         5fTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770897924; x=1771502724;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qHpGzoa3aopZAtJxfvEehMpSqEZ816kpOkyer+YIROI=;
        b=RzIJva3pancfKGp/xEQVptm+9vMxQguBLndJsk7ZQBBDcCVrysLRI853d/9OuwEguM
         2X6k1VMPmfGaH+bTA/DK7mA1dddJshl1NJBbTaF6sA2KxYmuJGj4/4DTuFCUWo3BuRjc
         4QxsB69vMInFq5NlkISB9e1gwl81qxtQVDpwkVqHl76qoJWD8c6rWycSU7lKx01i8swM
         l1XIcaoI9xpsqMhYy6zB45Rqno4JOmxrMnx/uDiOHoS7FvBceFGntmEfD50b2lWdfjjf
         t9Nc/0/oJ68aeUMCRrTH7M6eWdb2O9OAN/rKYNH9MeCAMzXyIhQtQSVAKkLI87wM8Gwf
         SDlA==
X-Forwarded-Encrypted: i=1; AJvYcCUJDESjvAjBrN8jffhPor0LpsbomtCpyW4XiswPMjblgIWNZNXNHhKaJadiJTX+5qaFdrmC1O309Ktx@vger.kernel.org
X-Gm-Message-State: AOJu0YzttD35/e0yGerQohejo51MLN8PADkzqaXpuTQ0vjPurfebHh7e
	Vg/Hmg5V5NfNO1GlHn/yAxIm76P8FIhZMNabdvA4lOgU40KwXEYKQbtgK2/8c2F98o16+bevl6y
	K0ONXTdrgEEMfiXVVYvICrhdlaKpqvEgY1yCa+yyGU8FUT/TUz96EN9TdnZv6qXmP
X-Gm-Gg: AZuq6aLeO0oSorCKD1J1BAHFNggHxQXf04pUmAXJ4+JE+hWU6ywiZZ79FoDdWYQ9/6U
	tGRt04xuc8StJdfelC8suqYMowgOh0ifgepHLKYP9ThKNcc5pEA1oJU8dwaQBgb94q2TV7x0SwS
	j86kFx+u/Lah0ck6ahy2Sooz2R6dLymbdKVmNj9vbHRpCZaJwClZ7ppj3YXuOWm35RkD6Z2qtDF
	dSfCxlaXLz5oT9/jqHAGIpB7M7+IxbnT5ccarxSDvj/OMS848/kC1l15O7bTWWLuH2e358MP4pE
	Shl901zN4X+AjLQq7zpf2kiIsb+8Sneq4bEqvi2ZloMOiM0TJWtSa0wQHUjTQuIIoNz3CpTINh7
	bPi5W/gL33dnFbTZsknp/nkZZsy+DjG3k+qk/Rl8ZxgK6QJQVI4ZPwQ4WqMIJ/IGgbd/FtHh9DP
	fHL4M=
X-Received: by 2002:a05:6214:484a:b0:897:1d50:2336 with SMTP id 6a1803df08f44-89727972a48mr28203106d6.6.1770897923779;
        Thu, 12 Feb 2026 04:05:23 -0800 (PST)
X-Received: by 2002:a05:6214:484a:b0:897:1d50:2336 with SMTP id 6a1803df08f44-89727972a48mr28202586d6.6.1770897923258;
        Thu, 12 Feb 2026 04:05:23 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65b2da1aceasm1112696a12.19.2026.02.12.04.05.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 04:05:22 -0800 (PST)
Message-ID: <fe57b3f0-cda1-4bde-a215-12e3aa9ea344@oss.qualcomm.com>
Date: Thu, 12 Feb 2026 13:05:20 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] soc: qcom: ice: Remove platform_driver support and
 expose as a pure library
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: manivannan.sadhasivam@oss.qualcomm.com,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson
 <ulf.hansson@linaro.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Sumit Garg <sumit.garg@oss.qualcomm.com>, stable@vger.kernel.org,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
References: <20260210-qcom-ice-fix-v2-0-9c1ab5d6502c@oss.qualcomm.com>
 <20260210-qcom-ice-fix-v2-1-9c1ab5d6502c@oss.qualcomm.com>
 <7d61d324-0d26-47ce-aac6-d17abdcf05cd@oss.qualcomm.com>
 <jkrkp74jgjg6d63ro4inl7ily4p6s35hmhpxeroyzue3o55tto@sgl2b4uv6ysv>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <jkrkp74jgjg6d63ro4inl7ily4p6s35hmhpxeroyzue3o55tto@sgl2b4uv6ysv>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: Bju-CekUuhMiUa-IfDC4uvjh4_kEqwqL
X-Proofpoint-GUID: Bju-CekUuhMiUa-IfDC4uvjh4_kEqwqL
X-Authority-Analysis: v=2.4 cv=XvX3+FF9 c=1 sm=1 tr=0 ts=698dc204 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=FGFzfvMP8PCZN11w_dYA:9 a=QEXdDO2ut3YA:10
 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEyMDA4OSBTYWx0ZWRfXy2IiWNzqey8M
 FZf1Y1Neas7vuWQgJzs1Vmps5M6dv6gv6q9jlcIk2hwpBkjTZCT0hE6tgSVGe8Nt8wZoMz9BOqq
 paQOW1dySKdZhBxRW+xSkN20LoQ4Dl1HBiZncYZ69F8VjidfxEsF/C5X1KreP0ZOgT9GezYki8I
 CsAUqBBg5nXzhi8p9TaMrZ+24E5CBKMb83oNvptaOlgOGfMW6rYg4MTljmwGgiL3tUlRhfghazi
 +U597Umbu30QsgAPBEig95PkUT9GZrDQQeO66/5JEcChkDzNfiPGFOzvQbSoqJ2gtByPwCL7cuf
 3BLuXdASWVHU5AtJ1FLjunhW1c5YmDAexXN8uvpmuZXA51UNAsXSmQs2MjlJUN9tLXCafYefO9z
 //YUb37CzKNFGmDtLPWsO7z1wX5MuY5RZUZAiNIRS24bYIN+/Cfg0KjKyvGnXae/JRT8omxH4yZ
 zvj1H7LkwW9ZsCMvO1A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_03,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 malwarescore=0 adultscore=0 phishscore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602120089

On 2/10/26 1:19 PM, Manivannan Sadhasivam wrote:
> On Tue, Feb 10, 2026 at 10:39:54AM +0100, Konrad Dybcio wrote:
>> On 2/10/26 7:56 AM, Manivannan Sadhasivam via B4 Relay wrote:
>>> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>>>
>>> The current platform driver design causes probe ordering races with
>>> consumers (UFS, eMMC) due to ICE's dependency on SCM firmware calls. If ICE
>>> probe fails (missing ICE SCM or DT registers), devm_of_qcom_ice_get() loops
>>> with -EPROBE_DEFER, leaving consumers non-functional even when ICE should
>>> be gracefully disabled. devm_of_qcom_ice_get() cannot know if the ICE
>>> driver probe has failed due to above reasons or it is waiting for the SCM
>>> driver.
>>
>> [...]
>>
>>> -static void qcom_ice_put(const struct qcom_ice *ice)
>>> +static void qcom_ice_put(struct kref *kref)
>>>  {
>>> -	struct platform_device *pdev = to_platform_device(ice->dev);
>>> -
>>> -	if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice"))
>>> -		platform_device_put(pdev);
>>> +	platform_device_put(to_platform_device(ice_handle->dev));
>>> +	ice_handle = NULL;
>>>  }
>>>  
>>>  static void devm_of_qcom_ice_put(struct device *dev, void *res)
>>>  {
>>> -	qcom_ice_put(*(struct qcom_ice **)res);
>>> +	const struct qcom_ice *ice = *(struct qcom_ice **)res;
>>> +	struct platform_device *pdev = to_platform_device(ice->dev);
>>> +
>>> +	if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice"))
>>> +		kref_put(&ice_handle->refcount, qcom_ice_put);
>>
>> IIUC this makes the refcount go down only in the legacy DT case - why?
>>
> 
> It is the other way around, no? Absence of 'ice' reg range in the consumer node
> means it is using *new* binding.

Yeah obviously you're right

I suppose in the legacy case we don't need any refcounting, since there's only
a single reference, from the storage controller device..

This assumption would break if someone had a funny idea to specify the same
"ice" range for sdcc and ufs though (via the legacy binding), but let's hope
no one does that..

Konrad
