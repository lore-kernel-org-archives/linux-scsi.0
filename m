Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004803C1405
	for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 12:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780145154; cv=none; b=LtbbdkjGkfIPjZOZPt9OdVHnRX3AT55REbPldqkid0xxqHoAyGa1OFgqmdaj89jpU8b6VjwtCBLiuxu68CJOsQEMuLTf7Sg/UPt8IFM9WathpGq9ISZvIqJHfK1B8/6r8f9jQJvNdnjHdbJ/4NZ6PUUMLHXbL6cyL4fwi2Mo4YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780145154; c=relaxed/simple;
	bh=qLHdRRkUwqBxCpPW0Ntu4msdUcCpKXvE/Ks1icjXsPU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FlT78nMtYSwLSTALSWS9ZhKx1EMGDm3QlDeAKBlCEAeuEOdP6C4m3g76r5HqqIDvsw+RdAA59vRU8dwLdgLGOUP0OooI5Gh6JCD3nz3R2cLUC1DDKptvSswA6gfz0MlSET4T98N7akRcqL//qkR2JGkgrfz/hBv10RS/o9+24hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=miv3gCRa; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PAAKkmPb; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="miv3gCRa";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PAAKkmPb"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64U3k5oC1758075
	for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 12:45:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Nin2RexOF9iwnmMuFG61q/RqPczDKVNMSIjMs8/E8aM=; b=miv3gCRaRoUeDlx4
	OD4Yfrm+nG9seA4EnIU3oyzrx1uJQ+nnIM5V/WIDWiLMl6+Gu+Y5hT2PFqrmegKE
	XI+YQ5ooCXc3necMfA1qaCBakIp09err41Ut4jvpHwj/BRf14Hr6BK5+bKJZ/sfJ
	RA7Q6K+OU9wKifPgd5ZXfXBWBQ11FcByjkb7o9LILN9XF2cDbZZvyENjGZvAraga
	ak0SVrS9ABLaxJ3tgkDfhjSceupxqeBkPUoNw0s8dpxShf5TvjYZM4IOHJq1Buz3
	4UncoICJyfDZm4JWlEsQGyZcnhx/BOL/9Z3dpLVJ0leVmZ7UptkpwPRsFT1jy22n
	L84Wiw==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4efr988w2m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 12:45:47 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2bc763c7256so304418195ad.3
        for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 05:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780145147; x=1780749947; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nin2RexOF9iwnmMuFG61q/RqPczDKVNMSIjMs8/E8aM=;
        b=PAAKkmPbFrjpsbamyQIIlUzZP+3oJigjvfZqRt7c8pTJCh1bEkCaXKxjeseufV2SNi
         Jrm+BCtA+gMa5aTwj5skb+RtX6k5RLhAki24YSI7pVZ2NdvGBpOvouJl7B2bnnUOYNPN
         Kf+WJQu28TXIGGSi2Gs7VBFAk14JhrnGL5u804GR4fLVPl/1RBIc5PvcF8bz03KAPh/o
         5bThQKOIQimWMrFrlTMZGrypvoWYDmBMkgrgTflWlTtUt16KFNwCvFo8xJ2GH/wk97xz
         Bw/kSMC3n1GZ3g2leuV9VKpxMjU7tuDakV+Vr3q5VNCqa/0R+vEAmjcfzDWNCLKA5PLt
         JqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780145147; x=1780749947;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nin2RexOF9iwnmMuFG61q/RqPczDKVNMSIjMs8/E8aM=;
        b=FA6/RzC0QGt1p2Ng/COz4Z8etWZydboZoS+Ixp1IMaQrosY1iPKjFz9nxzUKFMGjJk
         NQ49j58rPmlKmB6VyG/4UpHR/0QEaa5hKjASUmH7xEsJuOmrz71jShmcZdvltcqGdGnb
         Z7RPcCCLDnSZqs07u+1BLhYBCY49t6PojqGntzRpt8jNUJxcvPklGoZpAPAe8VkmhaWi
         f5MW0SiyTgdGfkqfBxTaWsycs5/xL722Td9jal3iAvwU0GCp6TBdKcstcvOeoC9rLEXV
         Vk4T9AJbj0/bkdchuxAVjyTXbspOKiyN54mJODe7M/jbgB8GIDvhEApNfRTRVWMPq2Pr
         Eq3Q==
X-Forwarded-Encrypted: i=1; AFNElJ8RClY1A5uFCr9iyYCK9R9qt8L4Ljh2dEUsDrDRjuTgksfjVDOzXprJY3YG3wNIiTQxhyZL/YdNWI2c@vger.kernel.org
X-Gm-Message-State: AOJu0YzaPg9e1zpd04neSqH30i5+Q8olfAuommFMBhu+X0fdQj/qJWkY
	H6dT9pWGD3oTT4e5OtP/EKN14pU6wAdS5vydszlQSJ33j7hE1Np3Ffd65owTxbLPwC+Y3MzgstC
	d8UAQLPxi5w8yfUjpnBu0HLO1umyLTA3zXMQeMSekp5+HQjyhVWYzfeNWZ6fd//XQ
X-Gm-Gg: Acq92OGk72Zqkfk8gZoImipuBzPFruB2b55saVDhMCgZ9w7jz7spW7/dCUxLYDkGxaa
	C30C4Xg3ZQuYwukLo6+CKd/7dwwTZnnu159OLFp3x7mGyy4NuN3QEOa6X/FQNwwGPfHRwkhVI+n
	04xSqSTGB3yf5JQ7UCKgidK7TckKC5R7jVRdxFViBpXzLZvnffmPepRRoddafBt941cIV7Fik9u
	ecQCZk2gdeIdD3O8yn0pHDg0XAwhjfvyecs3XmeGFbg5t4EFg+SV1WdqpruW/2RXZQNr2cJRK+y
	DivvOrpnaOoBVvaVYDCc2N9G7tw/HvSb01kdz1GYYzoS7sdakca3MQeAl/xLSr9IQtk+gk3Ljb9
	oGvDyuFu/Zty8crLMJIbl5TD7Pffhz6hJiBRd+vfkn3slAiasd8Bd6xHRp9P7yZiqhJp0dVuZRD
	N/z0XmobxULNAP0NZLfddS
X-Received: by 2002:a17:902:cf12:b0:2b0:52b7:e82 with SMTP id d9443c01a7336-2bf367d0043mr46268805ad.16.1780145146412;
        Sat, 30 May 2026 05:45:46 -0700 (PDT)
X-Received: by 2002:a17:902:cf12:b0:2b0:52b7:e82 with SMTP id d9443c01a7336-2bf367d0043mr46268355ad.16.1780145145817;
        Sat, 30 May 2026 05:45:45 -0700 (PDT)
Received: from [10.133.33.28] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf239e6f57sm49204365ad.13.2026.05.30.05.45.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2026 05:45:45 -0700 (PDT)
Message-ID: <ada65ce2-6736-44fe-9396-d3ed632274ce@oss.qualcomm.com>
Date: Sat, 30 May 2026 20:45:27 +0800
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
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <20260529-neat-bright-shellfish-eab5e8@quoll>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=BaDoFLt2 c=1 sm=1 tr=0 ts=6a1adbfb cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=PY6Zn8H8AAAA:8 a=mpaa-ttXAAAA:8 a=EUspDBNiAAAA:8
 a=pYZB3BhZI7Cztb0yzh8A:9 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
 a=ySS05r0LPNlNiX1MMvNp:22
X-Proofpoint-GUID: bMkIEpZidjOGMc_1y0VVc_I6FSlgXcGq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTMwMDEzNyBTYWx0ZWRfX/3gsNauo8Cmy
 1S6ZJEW/CYn6L78v33rHcB2hQVEILlQ33zMh2YSp303e3CweDMp1NdFA+6DZVeJFoYoOn0fg73e
 odVHh4/DQKOLyWe6Bj5ehWqWwsJxOydS4nNJMHXULd1nfg+7aS0hlEfYLGjj93AKovJLqOGO+By
 ZIFtzdPn8GWDvhOoA2qqMllZz50nw0vNopecYNcxy5aBSBtLik+IZ2556aG0gjp6pp9vRM4bu2g
 M7TyADR8Q5hLTpfBfPjBjEnUDi5odJ6VI6qwV1bf8NFEuBDzgU+6LxGEGLoKzYw28mxVnzKidmL
 SpVQe3QOS7+vdIDprlbNigOFpIedSh2MYgtC0scvf1i8lrYGTOZvt6QFyg6XWvzQVhPXdgK4uW/
 Sc41/D7DE7Lf/h/Zp6xQSqmVkHCLVKjcN/CP/HDtQ+Nl/9yvMd7DHhaVRiORuGAF+NQhTg2AOxd
 I5GRYSHGQ9lUUx4wDqA==
X-Proofpoint-ORIG-GUID: bMkIEpZidjOGMc_1y0VVc_I6FSlgXcGq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-30_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 phishscore=0 malwarescore=0 impostorscore=0
 adultscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605300137



On 5/30/2026 12:58 AM, Krzysztof Kozlowski wrote:
> On Fri, May 29, 2026 at 04:33:37AM -0700, Can Guo wrote:
>> UFS v5.0/UFSHCI v5.0 add HS-G6 support (46.6 Gbps/lane) via UniPro v3.0
>> and M-PHY v6.0. In these specs, TX Equalization is defined for all High
>> Speed Gears (not only HS-G6) to compensate channel loss and improve signal
>> integrity at high speed operation.
>>
>> For HS-G6, M-PHY uses PAM4 1b1b line coding, Pre-Coding may also be
>> required depending on channel characteristics.
>>
>> Add vendor-neutral DT properties:
>>
>> - patternProperties for txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6]
>> - fixed property tx-precode-enable-g6
>>
>> Each property is a uint32 array of per-lane tuples:
>> <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
>>
>> Accept 2 or 4 values (x1/x2 lane configs). PreShoot and DeEmphasis values
>> are 0..7. Precode enable values are 0/1 and only applicable to HS-G6.
>>
>> Acked-by: Manivannan Sadhasivam <mani@kernel.org>
>> Reviewed-by: Bean Huo <beanhuo@micron.com>
>> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>> ---
>>   .../devicetree/bindings/ufs/ufs-common.yaml   | 45 +++++++++++++++++++
>>   1 file changed, 45 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>> index ed97f5682509..d90cf25adfa5 100644
>> --- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>> +++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>> @@ -105,6 +105,51 @@ properties:
>>         Restricts the UFS controller to rate-a or rate-b for both TX and
>>         RX directions.
>>   
>> +  tx-precode-enable-g6:
>> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>> +    oneOf:
>> +      - minItems: 2
>> +        maxItems: 2
>> +      - minItems: 4
>> +        maxItems: 4
>> +    items:
>> +      enum: [0, 1]
>> +    description: |
>> +      Static TX Precode enable values for HS-G6 only.
>> +      Values are specified as per-lane tuples:
>> +      <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>].
> You need to include them in any of applicable examples, otherwise
> nothing here is validated.
Hi Krzysztof,

Thanks for the review.

Since no UFS5-capable SoC binding exists upstream yet (the target SoC is
still pre-CS), there is no vendor-specific YAML to attach the example to.

Is a synthetic example directly in ufs-common.yaml OK to you?
>
> Why values cannot be on or off? Or even better: why you cannot just list
> all the lanes which has it enabled, assuming disabled is by default?
Thanks for the suggestions.

For the "just list enabled lanes" suggestion: precode must be configured
independently for the Host-side TX and Device-side TX transceivers within
the same physical lane. A lane index list alone cannot capture this
two-dimensional per-lane state. The tuple format <Host_LaneN Device_LaneN>
is the minimal encoding that covers both.

For the "on/off" suggestion: the on/off string pattern is used with
single-value properties (e.g. LED default-state) read via
of_property_read_string(). I am not aware of precedent for on/off as a
string array for per-lane tuples.
>
>> +
>> +patternProperties:
>> +  "^txeq-preshoot-g[1-6]$":
>> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>> +    oneOf:
>> +      - minItems: 2
>> +        maxItems: 2
>> +      - minItems: 4
>> +        maxItems: 4
>> +    items:
>> +      minimum: 0
>> +      maximum: 7
> What is the meaning of values? Nothing here refers to the spec, so is
> this driver specific?
These are not driver-specific. PreShoot and DeEmphasis are standard
features of the MIPI M-PHY / UniPro stack. The range [0, 7] is defined
in the UniPro specification for the relevant PA layer attributes, and each
value maps to a specific dB level as defined in the M-PHY specification.
I will add the value-to-dB mapping table to the property descriptions in v7.

Thanks,
Can Guo.
>
> Best regards,
> Krzysztof
>

