Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9575217F33
	for <linux-scsi@vger.kernel.org>; Mon,  2 Feb 2026 15:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770044507; cv=none; b=TI1eEQXOnP8/IIJ4Rbvsj1VHx3GLzsWWZSBNd2rek/ar8vGwrqtui0R2MSMGmsWx23UKGOAiaZeymhoLBviqYP8oRc07Ej85mhINZr7nQZ9LJqAP2rHXr7prXyoh+SnKdiLR5B2Srm8Njv0QJFlomYgvmaLDLwnnmPj9er3UcNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770044507; c=relaxed/simple;
	bh=JcxIl+U6XrrYzwzysRKriC7B7jJmpe/ag7DnsCLo6KY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d6N2ehjCf/ZS6gO/doyDXFN1aq8SRZW+SmbXPy6L4VjDuplGbhJ/s/e+IcaavTjZcXlAOqiQZQoSCHyMnT1kzl1MJK3kS/LVdzY5ld+dG0n7ahpjfN0Id7EemOjI46MXphqs0ZEwmQXS7SSRQqlBRw+Y8jbzESn0f6ljVida9BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GtaZJJNF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AblAgGM2; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GtaZJJNF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AblAgGM2"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61286FR01331761
	for <linux-scsi@vger.kernel.org>; Mon, 2 Feb 2026 15:01:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	b7LkWBSg9k/hqZXrb855SBQlwZa3bPE252WnYqjGZpc=; b=GtaZJJNFInkB0nDH
	54tU49dyHv+VRHJZVBVJMVqJVvxuHoy1ovO4QvYQfZfGdsGfExvWo28Un/bDUCk5
	VKxVX2OW1YQnzWUG9zpQkzbVrouNacirwHDWVQItC3VXh46cmsOlYkcgvPKDkcut
	5fjMcnaME0scGguzeWG3lvQdQsudjNlzePnArMMwXC4ux0kXQKS5WPZoF2S64/iT
	fk/2FcJZ6/Y6ZQZiUqttHbdeyQeXljEK2HBkEPtbjVxMLv4Qg5uGQEOeBJ4a93Vz
	pSsuSXAlg6LQYi4O8n+B1BwjGjUKv/X8dxuXJfgZwprHwaJ7P23ycrkSogrria07
	h6XDMA==
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c1awnwuwx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 02 Feb 2026 15:01:44 +0000 (GMT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7cfdf8a0722so1287595a34.0
        for <linux-scsi@vger.kernel.org>; Mon, 02 Feb 2026 07:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770044504; x=1770649304; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b7LkWBSg9k/hqZXrb855SBQlwZa3bPE252WnYqjGZpc=;
        b=AblAgGM274VEbWYjs/UhCbYCGtZPQe/YGUiPcBm9cUhrYjyWsNNJrVebLVZGqqjPhG
         xUqdUMWmjeQKKFQAFKc6klct+3n8OTqJ54+GNSVzbrdv91d3ujqwQAFc0rC4xZxpCY0l
         Oo2RKwP1QwM/QxbsvGBYdqYX/gxJi269czzwX3FEdhFBl/DMgP7lBesf6m64kee5cQDI
         yr8gwUKeb2nGO5Itipe4uTIdHygEpcMIY8JI2ClQd8efqdp7WwL2XVKcARAnD6gvIssb
         4yMlEmiEMoN3xL+Q3r2t4lmSkSEP6x1/SLvjFt4To7C0vjX69fKEWI0mVdAMIH2flXCR
         DLkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770044504; x=1770649304;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b7LkWBSg9k/hqZXrb855SBQlwZa3bPE252WnYqjGZpc=;
        b=ShUFP/wxTO/bsOVO1G6VrN8KmwNd98+LR72Q8ZB10lXMc6ke2CQ2vP0eGl9rrqDxFe
         hT9j41dPU3GNgldlBDh4M3gAsxGs4tcPZX8FeTW69HMeD9dA7gRx/+CUOfWFppHMAlW4
         AnNWdUkT5LLRhX5/EA+QHSBD7ieIqtM5NcXSc2pDzLHXjTNfSGwfDHK8LoOWzEP+/mbY
         77Syorq4hN6rZW1/BBpw5QF9E+eauSgI0KJztcH8YZQe42GmMNqywFRCxTqqZd1s5tRB
         tPrtVhO5+uN62oh/tPL82SmE/otpbvykaTOcjiQB1LP8tzquioY00tw1a7iwwul5R2qf
         7f8A==
X-Forwarded-Encrypted: i=1; AJvYcCW2uVexO5GSulJXtcOzZ9AhGOjhhQhHN8Oy95zpu6DjTe6mXrlYakur8vFors6mmcbB1UNjeHw4/gLj@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/jDT9Ka4JaMu0oYkaH58cLs6GloXkXpu6VAepcoN9/xTwheXE
	7puxDdfi/P6rs4KWeqELn4MxDkVsXJ4d8vjKS7d/JlxuOUfjpTXFCI0ADl/PJgEHFbk2cZfN8Mp
	YFgQ7sBSrKgJPDQaZMl1F+Dh5MCjW/yqsDIg3RLjwVh+OoKjYmzkCNNmGljj1FjOz
X-Gm-Gg: AZuq6aJQOQs2YA8wACasH9Oy7IxzeD3A2HZcRyXibPVsJaTurnVrujOoIiViO00qcJE
	KHTivNfAQihovdb6ApkN70E4PiDAumK6iugyyEWM14fFwFt4z5bAkR8T9ua3vmQXnKYNqnfmVjk
	qbXoArsA/v++cydUmg5HyX61xHEi/xQTGXpBMiD3UhF3dAEaDYg0mBfTI9RnPoWgM3ZkKL4vCXc
	WJWq9bQIPkKHM6TYY1QRqkfeuMkwl0HGEUMjMrtN43aXxqmNakDSEK6hwgdt0UCth9Ikz6qNutz
	XlCQOmNmJIwa3JDtSr5SkW7clo4jidSo4fbgfQ/qWVD0TmXgwJ925It6h5UpeYCMzQlNJYpsjOM
	ZR3IqWdpzE+iR1/Gro2fjutVorprmUNUKWJ3MFBCeTuQvNFR41sQJagXnNdW/NDkKDL4=
X-Received: by 2002:a05:6830:4124:b0:7cf:e23f:5ae3 with SMTP id 46e09a7af769-7d1a525f7acmr4859567a34.1.1770044503726;
        Mon, 02 Feb 2026 07:01:43 -0800 (PST)
X-Received: by 2002:a05:6830:4124:b0:7cf:e23f:5ae3 with SMTP id 46e09a7af769-7d1a525f7acmr4859515a34.1.1770044502743;
        Mon, 02 Feb 2026 07:01:42 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbf2ecc73sm897795866b.62.2026.02.02.07.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Feb 2026 07:01:41 -0800 (PST)
Message-ID: <cac8e14e-63e4-462a-a505-cd64e81b2d1d@oss.qualcomm.com>
Date: Mon, 2 Feb 2026 16:01:38 +0100
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
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <aYBF3Geeuq2qHmYg@hu-arakshit-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=MNltWcZl c=1 sm=1 tr=0 ts=6980bc58 cx=c_pps
 a=+3WqYijBVYhDct2f5Fivkw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=fQ1HhNXxD7se1t-yopsA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=eYe2g0i6gJ5uXG_o6N4q:22
X-Proofpoint-GUID: srCXrokR2w0jwdIXosawcjx47XMoGFtG
X-Proofpoint-ORIG-GUID: srCXrokR2w0jwdIXosawcjx47XMoGFtG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDExOCBTYWx0ZWRfXw+BUVSWiVqva
 OLDLOhjFneXukV1+sHPn4i43JIssf7ZnrYn1zhgt3xmK1Rv7s8xqN/t5/en7BRpp0t5a4mQAp/6
 unFXV7VA10lQPt2k811QQDIkP8Q8SMZUkbbsj8hE+msF/DcJ+7MTNU+3wTrVRhVwzT2zK14cXkD
 pIfCpkNn5XkJDw/wwyEr3HHG8J+WOEVA3+EL4aYqWg8/a7rHVSpPRgeIFp7WApSkJL9m013Xcxc
 GfwJGkD0dtHXQpq+mrnkHFOxBCBhaWI4ZVY3rmqk8jmVGeCpbpqhd9MIQHxc/J8cf3G3IxHxwnZ
 Hk6DkxKu3mohRkX1vZBByALSd1l7XCfKPyfQF53C2knit72lFeqSn7llYc4xZ6IintuulqDnvYl
 9+gnA6VxOfgUE3P0WzTJedqGs7pr1rxPDdiwL1qOM537Ifq9ymw+9MPU3k8xZufE7bIvoYjcPgr
 OPLamsON392q9untBZg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_04,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 impostorscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602020118

On 2/2/26 7:36 AM, Abhinaba Rakshit wrote:
> On Thu, Jan 29, 2026 at 01:17:51PM +0100, Konrad Dybcio wrote:
>> On 1/28/26 9:46 AM, Abhinaba Rakshit wrote:
>>> Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
>>> using the OPP framework. During ICE device probe, the driver now attempts to
>>> parse an optional OPP table from the ICE-specific device tree node to
>>> determine minimum and maximum supported frequencies for DVFS-aware operations.
>>> API qcom_ice_scale_clk is exposed by ICE driver and is invoked by UFS host
>>> controller driver in response to clock scaling requests, ensuring coordination
>>> between ICE and host controller.
>>>
>>> For MMC controllers that do not support clock scaling, the ICE clock frequency
>>> is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
>>> consistent operation.
>>
>> You skipped that bit, so I had to do a little digging..
>>
>> This paragraph sounds scary on the surface, as leaving a TURBO vote hanging
>> would absolutely wreck the power/thermal profile of a running device,
>> however sdhci-msm's autosuspend functions quiesce the ICE by calling
>> qcom_ice_suspend()
>>
>> I think you're missing a dev_pm_opp_set(dev, NULL) or so in that function
>> and a mirrored restore in _resume
> 
> Thanks for pointing this out, its an important piece which is missed.
> We can use dev_pm_opp_set_rate(dev, 0/min_freq) in _suspend and restore the

FWIW

dev_pm_opp_set_rate(0) will drop the rpmh vote altogether and NOT
disable the clock or change its rate

dev_pm_opp_set_rate(min_freq) will *lower* the rpmh vote and DO
set_rate (the clock is also left on)

Konrad

> suspended frequency in the _resume. Something similar which is used by sdhci-msm.
