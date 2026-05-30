Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF2F2F3621
	for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 13:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780149478; cv=none; b=pgTCAXQiH3w01ZiT3zVfH3RW1y0OIM+sSdtNzyl8r6LnokC1yOZH07o5n3a0Heb+Ew5pykfnVSKzZQ0WdRvP3idr1mDy5PkRqSiv10KOyotALrlplLWJPHbhvxYf8eGc7mG1BIEiegoxX3ANmV/Z0I28T8FQxTW6O+XFXhdevxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780149478; c=relaxed/simple;
	bh=3JkTCQgiH3LxrL3vazE20yrW65gmotpbptgLugSPFxE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=DYbaqEUXun61qy/6nhTzZhuvx3G4fPRmgXpdU6RtvUAPtrFcQJIk+ucjr/bjFovrthM74A6tNwBHZbZa1YbS/j/pszQhQfvgrZbakm17GM5v/X3zIb6eyXckHT6Q0SSKLYI16M+vujjXVTGZxNRrklH94Nr/s5OUmgHn9OVRr4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bzxEthrp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=I+rSQQBv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bzxEthrp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="I+rSQQBv"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64U3k8aH1758088
	for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 13:57:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wyfGzEjL9T0vealm6OZP5o97m37ViNP+EY8gC06YbN0=; b=bzxEthrpwQ2pHhnC
	mXbdLD543QfAL0YPQACuqoLErzbiPmGmLK1F83dQzicPXablwtcUpB0CmOzQ4/Ej
	/o85P/EnhUT5Jr72fA92EBsbLovboI69RstSVEjSaYjawP5owiUfpEqtVP3itFkT
	bwBpdTqIm/sCLD+ffq0iAdOe4fjaOmdL6j6iGg3NZAgKGtvVQ0GQxgd++r2ArBKY
	Uu6FNeoStb52siXH9bVGNIGAltQwkfIIjzwD+Sdr63BrQtsanHiQEoi9AEA1OP9H
	5AxM50aPa4JS8+ibUZgElClEFOpcel7BFu9ssKSsSfgRmMGN/zMl7yJEcWhpTRs7
	TjYPAA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4efr9890u9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 13:57:56 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3663cbff31cso10432583a91.2
        for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 06:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780149475; x=1780754275; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wyfGzEjL9T0vealm6OZP5o97m37ViNP+EY8gC06YbN0=;
        b=I+rSQQBvJ3WKQ+26x1mt+Js0Biz5ceGMCMUCkO480Qnwh1+O2qbxld1UnSXu6zrHck
         KKEsvY+8qyqNEcG6dbWJZqWHzg1UtcgfxBU42Rx/KqDyGFexfNZE5DYw0XfPawMBAF6k
         O1RiPXfiGcWmr+h8CtcMEIV/leYCCivNfY4k+O0KM0crkwNqznsx729WRTVAAQf6h2tY
         WTNQm+XluEMr+4FRmtMVgs9tKbD2LYUV06tr03fMi7KurMKz/lPTSNYSfHljla5OOzwx
         nuNE6DD9rrThXOPcpoXkgZSQ76zNONmDb80gbTMpep9AqoHR875RGjyW54BFhPOFRfw9
         RDug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780149475; x=1780754275;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wyfGzEjL9T0vealm6OZP5o97m37ViNP+EY8gC06YbN0=;
        b=nl1Cg7M9wkquA8PwsJowsXOSgsq+HT4PyQRLGJPRxsd85FzWsui+/uPLZJM4xO9pn2
         S2fNAr5uO1521BqGzPpxkuFqMNiosH/kRprVcEyhnrUPv5K0ecq154ncMktWhnw8auAJ
         wtcl/6jSe91gQdTJc5vJWhu6s2d5RISIGu/UekdTY71K4CKMJtiTVBrm42ucA/p0SUwd
         VgyGDRFXjJ1qEqKPTndTfPazJ+xjQubjOzIUdjoWiOzXC39WJEmy0gQ1tDJpIYrQ3HWL
         73Vk52J7kMrwMMKujSylL5M1zowqh/UFxJsJ2lq+nzbThHQrHSDliGx3f38JZVT7MRHT
         81fA==
X-Forwarded-Encrypted: i=1; AFNElJ+VGiIk+jALxmIYxEv9Hubco7DMJjrWmMYimZ8+1snJbzibwrla+fp/avibSp5h2B3KMlBOlFiu0sUj@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2EQGifUFNDAJ15yHwM0/aj+7pxS/NM/NqUPS6HpbyoIXebIAQ
	7HIjWB+YzEUHltJEQ7MpRgQf1lQgtBNXUP7tv8rT8VTrByAhkk2Ecl+8koLOB+QF5dcKR2PkkZf
	HT9KpQ0/RjELZ8IjQzSTCBfUJuqTtWDs9SpS66oiOWwH3coenLCr47owtZMnfHo6U
X-Gm-Gg: Acq92OEWP0W6Q5SvF5iuKlBVtvG2P/sX0yCduXXzkzt9eSqfhpBamKthgh5/pXloTDR
	0/lEf9QC4RXhcMZrDshmyKP8Zi84qfKxs8be1KyA+D2JMkOhNZhs02hdPoI1sOV626w6bU/MND/
	uaodHpnUcYKkMIjpZZGPEibJt78ZUtYl5xWcroC7PPypX+wLKsfDkta3bI+Q8ts7F+oN16UyIpU
	tR0eqyVjyAm8jeSJjeDpGdG7oRDAJWgGT4qeCKKLYOpyn1Fe/h8LRA7r29PxAKp8DSVd4hyk/pm
	s4pUc2n1R5/K9naTQl2FnBOvR3TueRcTSbezWwPCJjrWH5Fcf/fw8T9/pmJyhhU4QsNUl03QCmr
	rSxidvpiwdVMHjGGYBedJH/FmF+SWjBbkKB/TU2iLUCm4bS8XjVajZZT1FCSfSOvCl8i9ssFee/
	E0RNSefUKVHXom6VTTWvwZ
X-Received: by 2002:a17:90b:5704:b0:36b:9c4a:e05d with SMTP id 98e67ed59e1d1-36c501ce691mr3673535a91.17.1780149475473;
        Sat, 30 May 2026 06:57:55 -0700 (PDT)
X-Received: by 2002:a17:90b:5704:b0:36b:9c4a:e05d with SMTP id 98e67ed59e1d1-36c501ce691mr3673524a91.17.1780149474988;
        Sat, 30 May 2026 06:57:54 -0700 (PDT)
Received: from [10.133.33.28] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bbffc1879sm5653053a91.5.2026.05.30.06.57.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2026 06:57:54 -0700 (PDT)
Message-ID: <dff3c74f-0c46-4ac1-914a-9ea8bd40316c@oss.qualcomm.com>
Date: Sat, 30 May 2026 21:57:37 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
From: Can Guo <can.guo@oss.qualcomm.com>
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
Content-Language: en-US
In-Reply-To: <ada65ce2-6736-44fe-9396-d3ed632274ce@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=BaDoFLt2 c=1 sm=1 tr=0 ts=6a1aece4 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=PY6Zn8H8AAAA:8 a=mpaa-ttXAAAA:8 a=EUspDBNiAAAA:8
 a=LJiSo-RwSUm5TJ8LWggA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22 a=ySS05r0LPNlNiX1MMvNp:22
X-Proofpoint-GUID: CpXyUQVpM9uROHfSNVy_11KNp9Kx3SzU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTMwMDE1MSBTYWx0ZWRfX3rpZmAPWJqc5
 o79bNarRLAN4jabWYzHIL67cHiWedsjOJiCdOovdm1ekhWFyRgf1NAAWTxMccUdceU5i4K3Dyuz
 1iU+DyyTYZPO9x5CGjm/tGWnG34n9fz0bVagACz7HlnGXKUvW5mMDQzE1orCphGkbfM0026Ia1Z
 fkaVXLt+yKrQGarFyNoERwXJD3l1Yiw0pSCCKBfrXwXC2b26p4Dvspp9dodtmsJ7Y7rWx3qx0GI
 P9SaPQ9fPM+ttpq4M67jzyiwyvdEjx3TnhV0fAdVLtL70NEQ/RydvgpMJ2Oql0lNC/Az6bEcjQb
 SdyjGiFkYsOri0wZai61o83xatLxC/hhy40zJYJY/X2DGLtDTIjAvroqCWvhhcfyEgXyE8wlv+5
 ngxmh/rTMT2zkXHNidyrr7k5DQGTOkGk2xap8vYZ0chLS9FDxR0/0cUVvVXtLSeproFDEn8W5o0
 hzswXMxVMIFEldFyngA==
X-Proofpoint-ORIG-GUID: CpXyUQVpM9uROHfSNVy_11KNp9Kx3SzU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-30_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 phishscore=0 malwarescore=0 impostorscore=0
 adultscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605300151



On 5/30/2026 8:45 PM, Can Guo wrote:
>
>
> On 5/30/2026 12:58 AM, Krzysztof Kozlowski wrote:
>> On Fri, May 29, 2026 at 04:33:37AM -0700, Can Guo wrote:
>>> UFS v5.0/UFSHCI v5.0 add HS-G6 support (46.6 Gbps/lane) via UniPro v3.0
>>> and M-PHY v6.0. In these specs, TX Equalization is defined for all High
>>> Speed Gears (not only HS-G6) to compensate channel loss and improve 
>>> signal
>>> integrity at high speed operation.
>>>
>>> For HS-G6, M-PHY uses PAM4 1b1b line coding, Pre-Coding may also be
>>> required depending on channel characteristics.
>>>
>>> Add vendor-neutral DT properties:
>>>
>>> - patternProperties for txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6]
>>> - fixed property tx-precode-enable-g6
>>>
>>> Each property is a uint32 array of per-lane tuples:
>>> <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
>>>
>>> Accept 2 or 4 values (x1/x2 lane configs). PreShoot and DeEmphasis 
>>> values
>>> are 0..7. Precode enable values are 0/1 and only applicable to HS-G6.
>>>
>>> Acked-by: Manivannan Sadhasivam <mani@kernel.org>
>>> Reviewed-by: Bean Huo <beanhuo@micron.com>
>>> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
>>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>>> ---
>>>   .../devicetree/bindings/ufs/ufs-common.yaml   | 45 
>>> +++++++++++++++++++
>>>   1 file changed, 45 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml 
>>> b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>>> index ed97f5682509..d90cf25adfa5 100644
>>> --- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>>> +++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>>> @@ -105,6 +105,51 @@ properties:
>>>         Restricts the UFS controller to rate-a or rate-b for both TX 
>>> and
>>>         RX directions.
>>>   +  tx-precode-enable-g6:
>>> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>>> +    oneOf:
>>> +      - minItems: 2
>>> +        maxItems: 2
>>> +      - minItems: 4
>>> +        maxItems: 4
>>> +    items:
>>> +      enum: [0, 1]
>>> +    description: |
>>> +      Static TX Precode enable values for HS-G6 only.
>>> +      Values are specified as per-lane tuples:
>>> +      <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>].
>> You need to include them in any of applicable examples, otherwise
>> nothing here is validated.
> Hi Krzysztof,
>
> Thanks for the review.
>
> Since no UFS5-capable SoC binding exists upstream yet (the target SoC is
> still pre-CS), there is no vendor-specific YAML to attach the example to.
>
> Is a synthetic example directly in ufs-common.yaml OK to you?
Let me update qcom,sm8650-ufshc.yaml as it includes sm8650 and others.

Thanks,
Can Guo.
>>
>> Why values cannot be on or off? Or even better: why you cannot just list
>> all the lanes which has it enabled, assuming disabled is by default?
> Thanks for the suggestions.
>
> For the "just list enabled lanes" suggestion: precode must be configured
> independently for the Host-side TX and Device-side TX transceivers within
> the same physical lane. A lane index list alone cannot capture this
> two-dimensional per-lane state. The tuple format <Host_LaneN 
> Device_LaneN>
> is the minimal encoding that covers both.
>
> For the "on/off" suggestion: the on/off string pattern is used with
> single-value properties (e.g. LED default-state) read via
> of_property_read_string(). I am not aware of precedent for on/off as a
> string array for per-lane tuples.
>>
>>> +
>>> +patternProperties:
>>> +  "^txeq-preshoot-g[1-6]$":
>>> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>>> +    oneOf:
>>> +      - minItems: 2
>>> +        maxItems: 2
>>> +      - minItems: 4
>>> +        maxItems: 4
>>> +    items:
>>> +      minimum: 0
>>> +      maximum: 7
>> What is the meaning of values? Nothing here refers to the spec, so is
>> this driver specific?
> These are not driver-specific. PreShoot and DeEmphasis are standard
> features of the MIPI M-PHY / UniPro stack. The range [0, 7] is defined
> in the UniPro specification for the relevant PA layer attributes, and 
> each
> value maps to a specific dB level as defined in the M-PHY specification.
> I will add the value-to-dB mapping table to the property descriptions 
> in v7.
>
> Thanks,
> Can Guo.
>>
>> Best regards,
>> Krzysztof
>>
>

