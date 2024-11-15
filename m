Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0DF18DF89
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 09:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731662992; cv=none; b=u54+EdF4V0bA/Tvsl2QjDNyIxF/FUC89mDxsRqnCUWVac6h+a174VKsM5X90VOgh5471qfzPUh/r7flk9DEVXBlrFSJ92Ahx9Yqt9Dyy/cvnm5l9S6yNEaZNNXhOXDmAVoOenH5hG337lN/Ej+d3dK/uxBFYRXO1Fbcwvl3m2ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731662992; c=relaxed/simple;
	bh=G0zu/kxNxKcQtvKr/SX+SGJGenykagdf3bB7R8ypZfs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=otQNPU3Vlr/CwLvK2/Wbkk1vizmVczBWN5+RNu2TyuDvAEouUFV0hSwy3uJxZy0WvqrsfmTG9FR13ilaxmAsdFoA8e3E1oDmURKi8v/9sLZpBN5LAZbbW0x4cSa4OX2zKgM7S6trtxyRXcahsZGcYpYRWeXTtrVIoIHth59Tnsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=fail smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pUi41dl3; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pUi41dl3"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AF8FdIB023940
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 09:29:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LRHknoPsbe6evKngpi5ETRwDISaYc4zV2stJIhrntjA=; b=pUi41dl3jqmaJKhe
	43DYdcPjjN1CgQkiamqK+pLIzqh0w28DV4/tmzBplW5Xp9GxBMEk8X8RYD4vfe1x
	PkBrv2FcP63HjjzIChgxWKlM0lD9RamzB4Bn9BbUEzMFapMEORrChZd5wCdZGvtf
	3Z2cvvnY2KF+jH/Azr6hGT/v1gW2qEOveOJ1QXk4ds5kJdPZLkxuGAEWRG/6MzXw
	dRFalRvWTLDU8HxNHwW1YI9pdq4nMkO44u9mcsD/u4P3PpUlvi2wmu11cc/6niIm
	RQoWB8c6NVGU4TAFfjKHSTE43IbQTuD/3gBcQtw6AKIRdyLvbcjFZt60HZ46nRYY
	0gAY9A==
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 42vsg581h6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 09:29:50 +0000 (GMT)
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-83aae920bb7so35909039f.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 01:29:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731662989; x=1732267789;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LRHknoPsbe6evKngpi5ETRwDISaYc4zV2stJIhrntjA=;
        b=NmZ0+hbwSGJxkG2jwAUxWIZ889ItdFQhoc8QZm8yj/3PZXx033SvDHTo8lPhPU9dSE
         wNflrswYzELYlncfGpu4h/FbfqW6d9YQCssq3ymObUvywI3UEwb5W6Xcx7TBrm3vU3wZ
         3J9m3Dkc+gDI0rqzFha/B98XnYtkxOLVRxkehKA7glkr+y+8aU1CCZaxMeIR/jrqfzj9
         f+w+RWSbcUwCEXNEB1fd3xbcKJMFIst/l9FBdLLbZcjQbZCOcb8k13JM8+lnqbY6rzsy
         PVsltmtpMGHcIvr8TW5doCm5QXqAawnLv5S7bviCg/llhCsn2MWRNaT2SrFiHfCTa3k6
         7hQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPi4HlyerW2aLIrbi0LB7siYl7+cOfdiKLi3B7yFuPTeIU4/nQHhmAYLMh+48MKjza11JFFE4EBTSw@vger.kernel.org
X-Gm-Message-State: AOJu0YycBcdlXvvKSksOcYDYTm1bOpmUZigakRqKwA2Wfw9CuDwPtsiO
	l4LUH5fJ4jDEIrOCgiYrJhhJnc0cfBhaUCTBCdfTgxvscco6i6L3UJg7WDrsmWhUl44tlt36A6K
	4LYGNwxIKlNrY3d08KLXjph5GXnJSFUsBD9ia3E4oYIty94b7BinXZ4NPAocf
X-Received: by 2002:a05:6602:1684:b0:83a:abd1:6af2 with SMTP id ca18e2360f4ac-83e6c17c54emr62128539f.3.1731662988850;
        Fri, 15 Nov 2024 01:29:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH29I4bw5bnOpuIKz+9weVZfbmKQVczvtIhJBNOsApQf7VuhYEIDAZw5lf4xCwR3nEjOv0H9w==
X-Received: by 2002:a05:6602:1684:b0:83a:abd1:6af2 with SMTP id ca18e2360f4ac-83e6c17c54emr62127739f.3.1731662988407;
        Fri, 15 Nov 2024 01:29:48 -0800 (PST)
Received: from [192.168.212.120] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20dffd782sm162167066b.129.2024.11.15.01.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 01:29:47 -0800 (PST)
Message-ID: <eb511e4d-d5b2-4bde-8282-eadcd2eba018@oss.qualcomm.com>
Date: Fri, 15 Nov 2024 10:29:43 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/4] arm64: dts: qcom: qcs615: add UFS node
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Xin Liu <quic_liuxin@quicinc.com>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Andy Gross <agross@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, quic_jiegan@quicinc.com,
        quic_aiquny@quicinc.com, quic_tingweiz@quicinc.com,
        quic_sayalil@quicinc.com
References: <20241017042300.872963-1-quic_liuxin@quicinc.com>
 <20241017042300.872963-4-quic_liuxin@quicinc.com>
 <5fe37609-ed58-4617-bd5f-90edc90f5d8b@oss.qualcomm.com>
 <28069114-9893-486b-a8d8-4c8b9ada1b0c@quicinc.com>
 <20241113092716.h3mabw4bzgc5gcha@thinkpad>
 <c0b3bd36-6ec0-4d7d-9a65-5b8f02cd6c98@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <c0b3bd36-6ec0-4d7d-9a65-5b8f02cd6c98@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: tEHLvGK0xKAcBmKfZ-IVQGgqzcT9YfVj
X-Proofpoint-ORIG-GUID: tEHLvGK0xKAcBmKfZ-IVQGgqzcT9YfVj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 mlxlogscore=857 impostorscore=0 bulkscore=0 adultscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411150080

On 14.11.2024 4:20 PM, Konrad Dybcio wrote:
> On 13.11.2024 10:27 AM, Manivannan Sadhasivam wrote:
>> On Wed, Nov 13, 2024 at 05:19:49PM +0800, Xin Liu wrote:
>>>
>>>
>>> 在 2024/10/26 3:24, Konrad Dybcio 写道:
>>>> On 17.10.2024 6:22 AM, Xin Liu wrote:
>>>>> From: Sayali Lokhande <quic_sayalil@quicinc.com>	
>>>>> 	
>>>>> Add the UFS Host Controller node and its PHY for QCS615 SoC.
>>>>>
>>>>> Signed-off-by: Sayali Lokhande <quic_sayalil@quicinc.com>
>>>>> Co-developed-by: Xin Liu <quic_liuxin@quicinc.com>
>>>>> Signed-off-by: Xin Liu <quic_liuxin@quicinc.com>
>>>>> ---
> 
> [...]
> 
> 
>>>>> +
>>>>> +			status = "disabled";
>>>>> +		};
>>>>> +
>>>>> +		ufs_mem_phy: phy@1d87000 {
>>>>> +			compatible = "qcom,qcs615-qmp-ufs-phy", "qcom,sm6115-qmp-ufs-phy";
>>>>> +			reg = <0x0 0x01d87000 0x0 0xe00>;
>>>>
>>>> This register region is a bit longer
>>> I just confirmed again, there's no problem here.
> 
> I'd happen to disagree, please make it 0xe10-long

Ignore, I was looking at the wrong SoC. Sorry.

Konrad
