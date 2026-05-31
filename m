Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062EB7260F
	for <linux-scsi@vger.kernel.org>; Sun, 31 May 2026 01:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780191681; cv=none; b=gjZLZAnYAImCiFzUR3HBdypTW2crP0rKHFZ9QhrAMwueNw/BfHPJxpVcEmOkEawlHQrDEVMVOP9/5e3XPArXUNg87w/x823MilNjxNLNyKBvhogLgm9ijC55iPUJhkBvNJ1iHSJ+RML4kDqtAXh4Nt6O4tJlQKqF1FXnpPYedFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780191681; c=relaxed/simple;
	bh=XK57a8QkqCPmkZ0tZgJphFdbSEl/i6kCWvEEqnmOvME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CrD+0v+O9TXyWY3DKhbdUv7ZevrUJhqIpd4ru9eqEBF/VfwYajLrcSTf9741MAGkhYArw42dSDAUQtkXrlukTpd0Dr48hEk/iDGzIm300DHAfjBTdDR9ppm8Er1WEYxI1VU4z4q1CQ0ri5F9tcoQk2+RAD49yKqQPhFNzhzDZp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SBld4c93; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HfWgAf6W; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SBld4c93";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HfWgAf6W"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64UEPvbW1751442
	for <linux-scsi@vger.kernel.org>; Sun, 31 May 2026 01:41:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QP/YmQQpucJZRAia0geXRt1bwULI4Tj+5E1XuSKtbHk=; b=SBld4c93EtHDw6FZ
	iqp3saJCFfg4PS1UlsS4Appqch9UUYlIFoFt/om5A4Jr/Lmvp6b8Lu/DmUCESLEF
	3efpNJgwOhXNh5R6NbIfU1sRLlAC6rvqWpZIPpZt88etreWRicCyI5/PzgafEGFa
	GuxUA+qEiWR7+XWXbJBaDzHIBVHw0ZRtTt0Rpxk3tUNB/iktz6nJEoYjWIyp3q/y
	MfH8ElRHS3fZUb/49fiKauF/hYVrbCK7mdYKmEmbuqYrkooTOQgbrMCqM35psAth
	pSQlgCX2nfOnh3Doa61hu0AKgD3bgqvsNf7O0XCFj3jylvbgPHQXMe/oP9Rnw0+p
	Xf72Ng==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4efr41agyk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 31 May 2026 01:41:19 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-36d98b5a68fso470970a91.2
        for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 18:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780191678; x=1780796478; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QP/YmQQpucJZRAia0geXRt1bwULI4Tj+5E1XuSKtbHk=;
        b=HfWgAf6W1BcevZgUZtpA5XH/J0udvtClg0c1zNfU6aIJGISdDgInTHzd/LpYyU+5Kd
         NySacc7IKKNYJeE/HaE0HPHLwNhmzdmf7LWRLIt+fTkjVRFJ8m+mYn+ZMJhLx7HmnHtX
         uRHPapb0TrkTf5Dj7s8qWuW99cYYufE/Ycltm8LZ4I/cfsv7CweFpW+oCbXJmG9jNRjo
         MsiXHCJYQdkD+WYfznEI6/xQrkttlHULBV4QzcvZJ4YnzKJZIyVEP1DbTpV7TFqQqjDV
         Akr1ViNdbJ9mJK1nDWJm/8ow9i+iKko0Tz/+F6WEzESMMSa5aaVjdmfsB9J6ZZTe+PnW
         hj0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780191678; x=1780796478;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QP/YmQQpucJZRAia0geXRt1bwULI4Tj+5E1XuSKtbHk=;
        b=tArQOKiqXeRKJ8EbtJrZpMSbP8BcgA7uKg5yyaiVMPHDWleoC1XnXKR+b48vx5txSU
         f8IBQk+iMYVmaRRnZ3BjeRd01nkIv3uGVi/wtcyHKroSIj85ofoDRlkPRTf/F4eipRSx
         NYxqygAlpcIfdqe4U3ZBJwpzY5IM27GUbJ8+X7kr6qR7pAc08KqVr1pbQNj2R64sorgY
         wKuH406rasBH6Qp+OUaw31Eiv1hRrMfuAr7T7EeIIBPJYEWjgNjlETT9dym35NF69Xdl
         UfVahZnVELIdSb11JR5nVEbrDiVO0cNJh0N2QskBHoV1Dz5sWq+64EfkwKuLnMawqqK1
         avgw==
X-Forwarded-Encrypted: i=1; AFNElJ9M0GidJF46nrLgQTiPCdsjRnQ4muG5jLnwOrhKbWkiJNLUDR8/aRE3esLA4X3MtRZHfpaNbDW9n3IO@vger.kernel.org
X-Gm-Message-State: AOJu0YwF5qGlZFpwPuHMxFZZZdmr7mAopMYJsdfCosGJug+clHLL2aen
	9EdWORJ98foptBXu9lBR3wfOSAaryE6rJdVQ7s74ZGDqIogHt/peEslr/asQKDjIaFCGDpIM/5H
	s70BFglbhEj12uhm+PXVtRMzcmzYwFwyPMEAE6Z1WfzhuAQf0Ctm5Y6hcjup8Fhln
X-Gm-Gg: Acq92OGb5FSCKASpV9n8xfYc4Q3XNhcg8W6/KbwqU0VQbHtMNycZbUEI7r1Xjdf5dKr
	/kgsCIMleN6Sl+D696xfeWccsQkZjXThkosqeUViX5E7x+wUi44mU3VlDVpov+0OVvOM5NXR32J
	QsS62GUTW6YyHnQkWedXgxvCjTizWFm9Dapj+EOKN4JvjyiUzpny+bqaaByIjEoW/dkXHeb4H+e
	+WvHxrAcVG4ihO/XmpYlbTZuvK0HTw7AU3GJkTsPJKE8YZY0X+Z9lDBYp8IQDtP1h3BRZbXUR7Q
	6ck0rBx/AJ8YWjsMlGoq2S7glvQxedM10mU+d6/NE5/NK4sozXcWv5s3VhO9QLJxvdrsJPIoBO2
	74t8ji2RTZXJ+6uA3n+NxZmCju1uXixccvqcq8h+S6Wv0WTlbqM7lrCamcCZnM1tGji/MJF4cm1
	IZ076k/Nx4O9Zm9sB8a70M
X-Received: by 2002:a17:90b:4d0f:b0:368:7c0f:ebf7 with SMTP id 98e67ed59e1d1-36c501b8fbdmr4902605a91.16.1780191678403;
        Sat, 30 May 2026 18:41:18 -0700 (PDT)
X-Received: by 2002:a17:90b:4d0f:b0:368:7c0f:ebf7 with SMTP id 98e67ed59e1d1-36c501b8fbdmr4902580a91.16.1780191677869;
        Sat, 30 May 2026 18:41:17 -0700 (PDT)
Received: from [10.133.33.28] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bbdcd0a2dsm3670713a91.2.2026.05.30.18.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2026 18:41:17 -0700 (PDT)
Message-ID: <7d49742a-7602-4f58-8dce-7e02664b783c@oss.qualcomm.com>
Date: Sun, 31 May 2026 09:41:06 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org,
        linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Matthias Brugger
 <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Zhaoming Luo <zhml@posteo.com>,
        Ram Kumar Dwivedi
 <quic_rdwivedi@quicinc.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
References: <20260529113338.984301-1-can.guo@oss.qualcomm.com>
 <20260529113338.984301-2-can.guo@oss.qualcomm.com>
 <20260529-neat-bright-shellfish-eab5e8@quoll>
 <ada65ce2-6736-44fe-9396-d3ed632274ce@oss.qualcomm.com>
 <b445e9e3-dfda-45d6-bafb-a2deb3357144@kernel.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <b445e9e3-dfda-45d6-bafb-a2deb3357144@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=fOEJG5ae c=1 sm=1 tr=0 ts=6a1b91bf cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=PY6Zn8H8AAAA:8 a=mpaa-ttXAAAA:8 a=EUspDBNiAAAA:8
 a=7_JFPPHlOpLMAyv0mBMA:9 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
 a=ySS05r0LPNlNiX1MMvNp:22
X-Proofpoint-ORIG-GUID: ZVFIPu8nftPrD51qXRButp9GwFacgqeS
X-Proofpoint-GUID: ZVFIPu8nftPrD51qXRButp9GwFacgqeS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTMxMDAxNSBTYWx0ZWRfXyNXUSJg3ekzV
 42g3aKmcOsjnQnb/NOffZw5NNJKpb971beUsqzOXo0Xw82rLCkMMpwtyi6gI89PasXmj901ilRA
 5eQNnVs05mokyN/0GLMoreSOTWzRDvC/HFmyMgh8+fNr7/ldmC98+1Ys/9qCAjMhk2w5IHRRaMu
 EvEv5bfc/ZM1mTYsJE6S/0srcEAf9YHGzuod4TYElqwvVWBZXjCC09IquOty436UuXwRoenZ6oH
 bfSGX7mo27oQyNaucXZqrQ8rdXs5l3pJpeVZ/e42ppc/OAt2obgpcs49oKt6IHmWCHq5aH2T7i0
 DkKkWCQSwSwPJWIuYXEqYxZi6xiCAuLr/gXANF6MDOVqbMcmTahRwKcBYx/K9etulPQSvu5uxR0
 HoptM16UOEZWj0H+vBeDx8f9xYJmTIXHi/ekbOcJ5qdK1glxe7Us3jnzfwE6qjjofc9q9ePJal4
 D6K3mhKfDols/8E0yng==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-31_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605310015



On 5/31/2026 1:33 AM, Krzysztof Kozlowski wrote:
> On 30/05/2026 14:45, Can Guo wrote:
>>
>> On 5/30/2026 12:58 AM, Krzysztof Kozlowski wrote:
>>> On Fri, May 29, 2026 at 04:33:37AM -0700, Can Guo wrote:
>>>> UFS v5.0/UFSHCI v5.0 add HS-G6 support (46.6 Gbps/lane) via UniPro v3.0
>>>> and M-PHY v6.0. In these specs, TX Equalization is defined for all High
>>>> Speed Gears (not only HS-G6) to compensate channel loss and improve signal
>>>> integrity at high speed operation.
>>>>
>>>> For HS-G6, M-PHY uses PAM4 1b1b line coding, Pre-Coding may also be
>>>> required depending on channel characteristics.
>>>>
>>>> Add vendor-neutral DT properties:
>>>>
>>>> - patternProperties for txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6]
>>>> - fixed property tx-precode-enable-g6
>>>>
>>>> Each property is a uint32 array of per-lane tuples:
>>>> <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
>>>>
>>>> Accept 2 or 4 values (x1/x2 lane configs). PreShoot and DeEmphasis values
>>>> are 0..7. Precode enable values are 0/1 and only applicable to HS-G6.
>>>>
>>>> Acked-by: Manivannan Sadhasivam <mani@kernel.org>
>>>> Reviewed-by: Bean Huo <beanhuo@micron.com>
>>>> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
>>>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>>>> ---
>>>>    .../devicetree/bindings/ufs/ufs-common.yaml   | 45 +++++++++++++++++++
>>>>    1 file changed, 45 insertions(+)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>>>> index ed97f5682509..d90cf25adfa5 100644
>>>> --- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>>>> +++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>>>> @@ -105,6 +105,51 @@ properties:
>>>>          Restricts the UFS controller to rate-a or rate-b for both TX and
>>>>          RX directions.
>>>>    
>>>> +  tx-precode-enable-g6:
>>>> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>>>> +    oneOf:
>>>> +      - minItems: 2
>>>> +        maxItems: 2
>>>> +      - minItems: 4
>>>> +        maxItems: 4
>>>> +    items:
>>>> +      enum: [0, 1]
>>>> +    description: |
>>>> +      Static TX Precode enable values for HS-G6 only.
>>>> +      Values are specified as per-lane tuples:
>>>> +      <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>].
>>> You need to include them in any of applicable examples, otherwise
>>> nothing here is validated.
>> Hi Krzysztof,
>>
>> Thanks for the review.
>>
>> Since no UFS5-capable SoC binding exists upstream yet (the target SoC is
> I would imagine cover letter or commit msg would briefly mention that.
Thanks for the clarification. Will do.
>
>> still pre-CS), there is no vendor-specific YAML to attach the example to.
>>
>> Is a synthetic example directly in ufs-common.yaml OK to you?
> Skip example in such case.
>
>>> Why values cannot be on or off? Or even better: why you cannot just list
>>> all the lanes which has it enabled, assuming disabled is by default?
>> Thanks for the suggestions.
>>
>> For the "just list enabled lanes" suggestion: precode must be configured
>> independently for the Host-side TX and Device-side TX transceivers within
>> the same physical lane. A lane index list alone cannot capture this
>> two-dimensional per-lane state. The tuple format <Host_LaneN Device_LaneN>
>> is the minimal encoding that covers both.
> Again, why do you need to encode '0'?
The tuple is still needed because Precoding is configured per 
transmitter-receiver pair,
so each lane has two independent states:
- Host_TX -> Device_RX
- Device_TX -> Host_RX
A lane-only enabled list cannot represent directional combinations like 
lane0 =
(on, off) vs (off, on).
>
>> For the "on/off" suggestion: the on/off string pattern is used with
>> single-value properties (e.g. LED default-state) read via
>> of_property_read_string(). I am not aware of precedent for on/off as a
>> string array for per-lane tuples.
> git grep string-array. Plenty of precedents.
I will keep the per-lane tuple model but switch tx-precode-enable-g6 
from 0/1 to
"on"/"off" (string array) in v7.

Thanks,
Can Guo.
>
> Best regards,
> Krzysztof

