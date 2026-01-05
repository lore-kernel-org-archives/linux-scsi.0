Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281C6303CAF
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 08:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767600876; cv=none; b=bEf9Rvie37qSVrOcRfmm00LPqEK970nanoI7zCZ81M08oiL+R99dmwsoeMVk8nQLg9ndfG5KmGvjf71vDkSZaevemmKjKqJ9421fotKeV9q4j6pH+D3jMHixQiafeamC1f9hpuLhOWaRNYPTxCAFBmnFnuEyFo9XFL6TZAWAaUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767600876; c=relaxed/simple;
	bh=iQgnY4tsOzShFSo7WAUmSz6XrB6EpkXakU9TrvblBqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eikgDIcUUvVIUKt4aT7sMFW9CV92vgavYHs68nqXnMtCfFlXGWk6uL5sdzDqmsePKlkHfpHh92+flnSuk7CCBqP1qLi8yEQI+zbOxlJAMW94b734+rdKdwTS+Kc8fIiMkOTv/gro8719rLvUDbrjsnqpvIaBST7qPPfdvLZD3iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AEjWzkeJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Da29QZH6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AEjWzkeJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Da29QZH6"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604MtolT3874886
	for <linux-scsi@vger.kernel.org>; Mon, 5 Jan 2026 08:14:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Knhs8IKzgA/n8eZfM4YQQbHrb2riHOCrLcAUD8rcnII=; b=AEjWzkeJnXtiuWvA
	9K7CIIeLRGgNAj4NJPQnNqUTMGdJ+nTcVMSp5R2dJUg6KqxoDADWaC2OW57IL4Nr
	VVDoS7AE4zsnoSf/gqciO8FZukcajLb5lUImBFzM++zmFYarGqIeyhP7N4N4gUHN
	CCwh81afDEcIegdWf2BoFk/slj6nP8RTkM7mxvfniEowEvJ5YIfqfTOlT/snBLAM
	9LLJ7d0tA3gPM9gDBnLT3cFlcqAJhIMtGQar5VJq71Q6/FYGZ4UJJb+dTMhAbmTx
	KXb7G4GjorRvCBWN8LZnfsa5UCXeWNCTbfOGXtHJE3lXNtGvq9qR1CAi+3GMwVRu
	Qv0dHg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bfyx0h6pv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 08:14:31 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a0f0c7a06eso292965885ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 00:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767600870; x=1768205670; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Knhs8IKzgA/n8eZfM4YQQbHrb2riHOCrLcAUD8rcnII=;
        b=Da29QZH65SFBHFaSj62vxxg/+s9zmnKQiSh5g1bDLcz9bhLF9hXO6Fk0FJBYA4gg0F
         dWx6a1D23s4Fmh0kDuPzux0sL1lgAkswTBCKRHdDcVxuFRXr1WSmpez5DJ6MuMxKrZil
         9LXq/6T+NL8mdSVoCE62RuuGYItquDIONeD3QuYnapWMlocA9YGv/V5XahMH57faTI5B
         9q5KLHCzgQRProCQsl/8ud3LuGu05bEcDnqWFoBapsTUK9Pwi4TKBG8POaZ0AekYpnL4
         2iqjK7tiYWY2Ppc29YLHGUPd5KRlFN00H3lsDZXBDJhCXMN8elRhA2BEedZO4gu6ITE4
         CJmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767600870; x=1768205670;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Knhs8IKzgA/n8eZfM4YQQbHrb2riHOCrLcAUD8rcnII=;
        b=FpWTM3tHoIVxJ6Asdbe1S//kffqd8H3eM0d278oeNIu7TUOakBlUZepZT/EYBccfA5
         4AJfBReGMqc8k9zVr7qEZmLyOqjTD44AGbe4I66ESCFvsyWJyuJsiylkylN87N8xkGXT
         kEw96mvdMnTSMX8b37JMdh2Xep/KPsE4bo9dm6rNVbLegyS+Z9HkJaLYlYKLvlp3rPst
         KzUfzKXIQl+oc6TLJAgn1cQCRZX5JZWIwUNAQcYsEFCvdLrTEtnN625/vdxPMkqd4Hwt
         ++2ZvuhqVdK0rVZh96nl6rVYHx5Q3s5OO7lU3/VfBgGxr0MV8da/prMnA8KcTVJWrav/
         FkjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUda7HxufhJgCWTrwMvh4qMwIwJyRwzx3c0W8kE+lLJy0DerAFlKlNeZFwNyn6udI7g3fjg9g+bwFzX@vger.kernel.org
X-Gm-Message-State: AOJu0YwthFn83MZdAwAQevPdLXiaQaS7h8z4AXnw4Q2fpOHCEysMJX/r
	rlK4QWl/xVXgdYK3sSMYOCdPl0CgX1bjgWKx0C0opsjxtI9qE+F+4Wrescis8zs5MTASEKhlBp5
	lV8rcHDDcIE/b5Ad9jEtFQDGOV2VyOu/XAVifTO939wKOEVpo++u9RVAmEDl7TG6v
X-Gm-Gg: AY/fxX4xekbyYyF0hdHdud+AdkcCCdwY0Kgr5+9UpQ960qHNBbgpzB6dbMw6F92+OHl
	s+A/0uyK3gJFb+fbgBTYAeL4NdhNtJw6ZVsq/IxTvuqvK86nGHpyNwFEsm2b3PZwtfGaCfFGW0o
	P2e+Lv7ZIIVSpTI1P6ZxnXyvlg5bY/aX4SNtuWrkhDChMoLg/cXlgACwOLEgfBDJd4PQ33pSq4d
	yzlPoPSPEOqbYW8bIXwHNFNQgEkFeiqRl09E6LuqCXliOA76pATF+gvr59/cHxps/Zk9RczSzby
	BZPC3JSWlphJBk58D9ghy7BFORAameQ8taA+HTyVArLu/FzYHHlTS2CE0ob2KC0AVku2DdC5QM8
	rrHn5ov6NPGFNlVHrqlN95KEUM9UiHa5/mF18cxDidF831t1tKKA=
X-Received: by 2002:a17:902:ec8b:b0:2a2:c1a3:63df with SMTP id d9443c01a7336-2a2f2830da5mr499135645ad.31.1767600870446;
        Mon, 05 Jan 2026 00:14:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEZI5oU7cvHuyxSVZFYShCuld3qOUBm0+t7A94kkYYSw+mc4FnyDDkRFTHl/35PeuZ3unmeVw==
X-Received: by 2002:a17:902:ec8b:b0:2a2:c1a3:63df with SMTP id d9443c01a7336-2a2f2830da5mr499135335ad.31.1767600869960;
        Mon, 05 Jan 2026 00:14:29 -0800 (PST)
Received: from [10.217.216.105] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d77359sm447042285ad.95.2026.01.05.00.14.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jan 2026 00:14:29 -0800 (PST)
Message-ID: <50d07f12-9a22-4120-a658-e6a462b9f8ee@oss.qualcomm.com>
Date: Mon, 5 Jan 2026 13:44:24 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/4] scsi: ufs: qcom: dt-bindings: Document UFSHC
 compatible for x1e80100
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com
References: <20251231101951.1026163-1-pradeep.pragallapati@oss.qualcomm.com>
 <20251231101951.1026163-3-pradeep.pragallapati@oss.qualcomm.com>
 <20260102-rapid-abiding-parakeet-d0735f@quoll>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <20260102-rapid-abiding-parakeet-d0735f@quoll>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=CZYFJbrl c=1 sm=1 tr=0 ts=695b72e7 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=hz69ntJn8m3YF9laBZ4A:9
 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDA3MiBTYWx0ZWRfXyvMXwkOrDrKz
 H2MMbAmSu+dqmb1+DMAvHXXhBjdLaJYxrGKuA0xevUww4ZwHZRbsv/CpqbY1JPDa1BEhJi3a1Ik
 c+uprH9m0cNG8M161/5ErhygacRdrBRyAQJQgHEZ6LcBOSCY3UxbWwtoKOkgfCmkoQa+27oPFsw
 IyrngKD76MM17L92uhEEPwagJtMyGKTKcKrfDF4IOWnWGhaRwmbQ3V9aMkafZMVfcegjvvItECl
 T6ftZUDbIk6lDKyMLrnHWANh3dBDHH2exywo2F2TAnlpPk0l9JXzZs1MP2yLJq83c/iYzGOtRDR
 u2fOsbiMoZO8xnIzUm/ciMvXg/C8EDSa30sG5GjLcj3ntINiaW+zyAE5ySmr68sgr962xlZa2iy
 H8iw9KAcCzhC4h8CKQrhvDzXPX4pGmTajYMvSbRcHkn3Ekw8D7WjUL/hVthqrjlTTsyEBbBOktK
 m1jj7ktmrisOTZz8sFw==
X-Proofpoint-GUID: x_rGpJB-Y6H8VYZY82YfeoXLnkhUA1oA
X-Proofpoint-ORIG-GUID: x_rGpJB-Y6H8VYZY82YfeoXLnkhUA1oA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601050072



On 1/2/2026 4:55 PM, Krzysztof Kozlowski wrote:
> On Wed, Dec 31, 2025 at 03:49:49PM +0530, Pradeep P V K wrote:
>> Add the UFS Host Controller (UFSHC) compatible for Qualcomm x1e80100
>> SoC.  Use SM8550 as a fallback since x1e80100 shares compatibility
>> with SM8550 UFSHC, enabling reuse of existing support.
> 
> Your last sentence is redundant. "Make devices compatible because they
> are compatible". Why are they compatible? Or just say that you add a new
> device fully compatible with SM8550. Write concise and informative
> statements, not long elaborted paragraphs where only few words are the
> actual information
> 
ok, i will update in my next patchset.

>>
>> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
>> ---
>>   .../bindings/ufs/qcom,sc7180-ufshc.yaml       | 38 +++++++++++--------
>>   1 file changed, 23 insertions(+), 15 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
>> index d94ef4e6b85a..0f6ea7ca06c8 100644
>> --- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
>> +++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
>> @@ -26,26 +26,34 @@ select:
>>             - qcom,sm8350-ufshc
>>             - qcom,sm8450-ufshc
>>             - qcom,sm8550-ufshc
>> +          - qcom,x1e80100-ufshc
> 
> You don't need this.
sure, i will update in my next patchset.
> 
>>     required:
>>       - compatible
> 
> Best regards,
> Krzysztof
> 

