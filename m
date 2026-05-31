Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75F22D9787
	for <linux-scsi@vger.kernel.org>; Sun, 31 May 2026 04:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780202925; cv=none; b=iDrVQDviVzzuyYxMDHppgz5wf7cGx/7sSP7OwjvC2CDu5FhSsU7FiVG0Lsc49QuSFwYIi/1X5/Vhex0X1ISDGIcQJcdPZ1UslElcqZW3hCly9DQH+w+BD3kpJycKiVHh6l6QlcGNjNBFQx27n4G4fxiyBCg996EijWSh6TrQIDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780202925; c=relaxed/simple;
	bh=eyiZHZ/v3MOwhg/Prw9dYSyqo5Kn26ezbRl+K974MAs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=GoCZ9WtCpY5/+9wFkKx5BitCDm74lzxZQz66aSGlkBC/1tjwhbK0WvM5DN8vgnx4s2fc8h1ctwy1oGrY214wJ5qFBXd/SJ24gVACpE3YWgnymAcxKNJoBx0F3jZ1aN4FdavhDNcDHPeALlMfINze46EFS61EgI2VhoFKME9WsJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VJWlsWwy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=g4kWkZOY; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VJWlsWwy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="g4kWkZOY"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64UJ039Q3838769
	for <linux-scsi@vger.kernel.org>; Sun, 31 May 2026 04:48:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ebaidKmwGs+8gsq9/tED+PDL0d2FG0p3YyTatOrtOrc=; b=VJWlsWwyZap7jo9p
	+c95UxByQXJIPd8GKlRYl38DlJzBkjE0LaqD/zhRDa/2loQpEJ6o4HQ6/CLVN8X+
	Aj0XJzpgpSycAdpEPouLTzsHp4d7sQP4+H03mKyu6JyCHYl6/5lLQqfV56jGIib/
	jrl1A1warljlrMiWGxAQkARxY08Ahh0D9JKN62kRoIMtwslkh3nXywD71AxMeygq
	DWWEiaFNconLlZqOPm/bxjmXZdeHRMUGUlcsuGEwCsVs847J+lRttqt2dbn3ZicM
	cOFoRuPxNFOYIDIsnSiBbu/lT6o0B+4K22JyRjZyQLAcfVRPThBvy+r/t9yMiJa/
	gygqHg==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4efq7fav9s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 31 May 2026 04:48:42 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c85a2cde332so102326a12.3
        for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 21:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780202922; x=1780807722; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ebaidKmwGs+8gsq9/tED+PDL0d2FG0p3YyTatOrtOrc=;
        b=g4kWkZOYxFXDPd5IfhT7fmx+NEP9vGNU3HpZRbVe/vYE4cb9RhcwGrkx+siLv9ke5d
         qiyxI5XHJnaztL96qenvi0b3+2bXvyJdPgpmaHcSEqUgnLVbiBO2aOQj0/xnlaziLEiu
         E2gezbp6BdH3s2L+XiSg5xHLhWOJri8V97AQcO2q7q+ZGvdDGq/45M2k+NDLQFRpPl64
         UAsc/2UXfhTLfBHfG4RTqFPUeaR2rTD+pWy4m+SxB3czCeWLPTo9rJICp/7nO6savOi7
         QJcmG70YXcxipnSZ4VEqdDKmzVqcWN1s558DMcmasFKKSHnrf4TaQOUcpk94NHXNg8DP
         2Qaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780202922; x=1780807722;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ebaidKmwGs+8gsq9/tED+PDL0d2FG0p3YyTatOrtOrc=;
        b=nDI5E2J0TNVhFF1pn2OsF8A9EESOwszWXhlgyVx4sLRrs1Qa3rByZMt7uoNx4iOWHk
         vYwsZpeK8T7CQfDQMJQfM71sa9p0nLLE0C2iw7q7J9RpRtfmq3rMhFprcaHk4OJCSTdM
         ZwPzJWCg+AU4T7UD3XCpfNX00VaF/0QjdwCw57TGqfUWfv4otr3sfGY/ex489Okm/a+Z
         vXISa1ejXMhv4cT76zQlLwU2rri98Xv60TTAr2cGERaB+MsMRH413OZxaq1Sqzs3/lYu
         Os7w5MXF5E0ga+booa5EkziqEA+pWhWJBZKinrapi5GziGnshVgm7BRzYGRR7W09FKBW
         0k9Q==
X-Forwarded-Encrypted: i=1; AFNElJ+mGJoWHaZRbVFtM+ziyAmGgJiS/NMrc+DeDvFwt/dEueLZVmdw/bGbK11RZNEk5k5inGYzmYio1T4L@vger.kernel.org
X-Gm-Message-State: AOJu0YxP1tb0q9bDsVMER5HsiTb/PoHaBKKAU3SK5jb6KaxbYosU/kJY
	iOPJZFUd9iRz1hsfMisRq72YxKL/rBIo8V9D0hgQZ8Q4+OptjQmKm9HVMc05HFGLi6bcjw0ohxf
	22nlyTj34pDwvaYXF1tdGNUO8ukNufHMHK0urnDl8ChyxaFzdrjvNR6oGqMKswWbB
X-Gm-Gg: Acq92OGO147+rZIXctotGHP12QyUVe98fc8EUn01ww2DQfdqPhHaQaubhzQQkEDklcF
	iHx4hQ10bzCnc/b8b8Qv9lJaGBYtNSitJsO6GUMKFDvvqLJchMs4ZZ16YzA2d826MLVmeKg48Bo
	VjgOYCVRV0EllTPbB6bL0eHDdX7vaLoGUvd2FtbD28ekDWZtiOMqkacH1sPEhuAmA9hrP4oJMP3
	16tbncO3JA7ZO49o0DY6T0AW/fVqiQW9vfcR9hIP8rBTKtUSBUy4lmMIvfBT+FjDbAwJsCUz2g3
	EahGTmxN1ZdECiArWidnZHVKxIB0/cUfwrPrARcyUKaeobtYwp/4/t237Ziatji7ut5rN1syuMF
	Gdcvwhqtck4qZuwfLxZWfb2Om7iPj4jenOPAUO7AN2zZZbUJA7YWgdC2pHIBMVrSdikPP5CutLu
	jUdyYGnbCtmqyoWapXhwlP
X-Received: by 2002:a05:6a21:700c:b0:3b2:92e0:f987 with SMTP id adf61e73a8af0-3b427c66ad6mr6162195637.16.1780202921707;
        Sat, 30 May 2026 21:48:41 -0700 (PDT)
X-Received: by 2002:a05:6a21:700c:b0:3b2:92e0:f987 with SMTP id adf61e73a8af0-3b427c66ad6mr6162179637.16.1780202921198;
        Sat, 30 May 2026 21:48:41 -0700 (PDT)
Received: from [10.133.33.28] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85771a7c24sm6719775a12.2.2026.05.30.21.48.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2026 21:48:40 -0700 (PDT)
Message-ID: <64bd6272-6111-4ffa-8a4a-366d0c287693@oss.qualcomm.com>
Date: Sun, 31 May 2026 12:48:29 +0800
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
 <b445e9e3-dfda-45d6-bafb-a2deb3357144@kernel.org>
 <7d49742a-7602-4f58-8dce-7e02664b783c@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <7d49742a-7602-4f58-8dce-7e02664b783c@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: iKZ1sDyfIBd4iE356uzh0D8aGh2AUb8H
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTMxMDA0OSBTYWx0ZWRfX09OdK7I+8ivg
 /YKKP4Or70g8uAzo7hAHDbF0lE1GpBGi6vHF8CKRiyi/Vn/P9Y4/V2HRXLnbZkgt6bhjNtkqMO7
 EwChsjS8zvXXjkMygO1DGKwEyaGadpY2glhKW5B2e+oJue4YTxyvKb0ZFPFYJtH4INxanVLDb3y
 kbFB5isgHs7zxDE4NzkGjqSD2XirLvBVf9jtOFpAsoeb+jYElLvbFhZENIid79p6SakrXT27LMs
 t75tY2LQZLS2TCJvme+wAFA0rze3iLr3PKgDmm09EoM33dwBNkqQFFheqilHAYdMXCFdPiEk1iM
 wx2bdgfEUIKi28FPA3jaMyK27ugeV8/7PFKCltdEK/VvTc45+CPxGT6M9zNfVSzJlWLAvzDy3M8
 GH9JT0Y+fs2kaK0MVJckvlpKRaqVbvvuFdc0eRKqTNGbN7fmXEF9UuVoYOXkCkqr0w2RmGgP1SR
 Tnrbz2Imyjp3IjPX10A==
X-Proofpoint-GUID: iKZ1sDyfIBd4iE356uzh0D8aGh2AUb8H
X-Authority-Analysis: v=2.4 cv=XqzK/1F9 c=1 sm=1 tr=0 ts=6a1bbdaa cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=PY6Zn8H8AAAA:8 a=mpaa-ttXAAAA:8 a=EUspDBNiAAAA:8
 a=yqHtDKZHdI7dvUF-9VUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22 a=ySS05r0LPNlNiX1MMvNp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-31_02,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2605310049



On 5/31/2026 9:41 AM, Can Guo wrote:
>
>
> On 5/31/2026 1:33 AM, Krzysztof Kozlowski wrote:
>> On 30/05/2026 14:45, Can Guo wrote:
>>>
>>> On 5/30/2026 12:58 AM, Krzysztof Kozlowski wrote:
>>>> On Fri, May 29, 2026 at 04:33:37AM -0700, Can Guo wrote:
>>>>> UFS v5.0/UFSHCI v5.0 add HS-G6 support (46.6 Gbps/lane) via UniPro 
>>>>> v3.0
>>>>> and M-PHY v6.0. In these specs, TX Equalization is defined for all 
>>>>> High
>>>>> Speed Gears (not only HS-G6) to compensate channel loss and 
>>>>> improve signal
>>>>> integrity at high speed operation.
>>>>>
>>>>> For HS-G6, M-PHY uses PAM4 1b1b line coding, Pre-Coding may also be
>>>>> required depending on channel characteristics.
>>>>>
>>>>> Add vendor-neutral DT properties:
>>>>>
>>>>> - patternProperties for txeq-preshoot-g[1-6] and 
>>>>> txeq-deemphasis-g[1-6]
>>>>> - fixed property tx-precode-enable-g6
>>>>>
>>>>> Each property is a uint32 array of per-lane tuples:
>>>>> <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
>>>>>
>>>>> Accept 2 or 4 values (x1/x2 lane configs). PreShoot and DeEmphasis 
>>>>> values
>>>>> are 0..7. Precode enable values are 0/1 and only applicable to HS-G6.
>>>>>
>>>>> Acked-by: Manivannan Sadhasivam <mani@kernel.org>
>>>>> Reviewed-by: Bean Huo <beanhuo@micron.com>
>>>>> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
>>>>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>>>>> ---
>>>>>    .../devicetree/bindings/ufs/ufs-common.yaml   | 45 
>>>>> +++++++++++++++++++
>>>>>    1 file changed, 45 insertions(+)
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml 
>>>>> b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>>>>> index ed97f5682509..d90cf25adfa5 100644
>>>>> --- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>>>>> +++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>>>>> @@ -105,6 +105,51 @@ properties:
>>>>>          Restricts the UFS controller to rate-a or rate-b for both 
>>>>> TX and
>>>>>          RX directions.
>>>>>    +  tx-precode-enable-g6:
>>>>> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>>>>> +    oneOf:
>>>>> +      - minItems: 2
>>>>> +        maxItems: 2
>>>>> +      - minItems: 4
>>>>> +        maxItems: 4
>>>>> +    items:
>>>>> +      enum: [0, 1]
>>>>> +    description: |
>>>>> +      Static TX Precode enable values for HS-G6 only.
>>>>> +      Values are specified as per-lane tuples:
>>>>> +      <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>].
>>>> You need to include them in any of applicable examples, otherwise
>>>> nothing here is validated.
>>> Hi Krzysztof,
>>>
>>> Thanks for the review.
>>>
>>> Since no UFS5-capable SoC binding exists upstream yet (the target 
>>> SoC is
>> I would imagine cover letter or commit msg would briefly mention that.
> Thanks for the clarification. Will do.
>>
>>> still pre-CS), there is no vendor-specific YAML to attach the 
>>> example to.
>>>
>>> Is a synthetic example directly in ufs-common.yaml OK to you?
>> Skip example in such case.
>>
>>>> Why values cannot be on or off? Or even better: why you cannot just 
>>>> list
>>>> all the lanes which has it enabled, assuming disabled is by default?
>>> Thanks for the suggestions.
>>>
>>> For the "just list enabled lanes" suggestion: precode must be 
>>> configured
>>> independently for the Host-side TX and Device-side TX transceivers 
>>> within
>>> the same physical lane. A lane index list alone cannot capture this
>>> two-dimensional per-lane state. The tuple format <Host_LaneN 
>>> Device_LaneN>
>>> is the minimal encoding that covers both.
>> Again, why do you need to encode '0'?
> The tuple is still needed because Precoding is configured per 
> transmitter-receiver pair,
> so each lane has two independent states:
> - Host_TX -> Device_RX
> - Device_TX -> Host_RX
> A lane-only enabled list cannot represent directional combinations 
> like lane0 =
> (on, off) vs (off, on).
How about we split into two properties, something like below?
tx-precode-enable-g6-host-lanes = <0 1>
tx-precode-enable-g6-device-lanes = <1>

Only listed lanes are enabled; unlisted lanes are disabled by default.

Are you OK with this approach?

Thanks,
Can Guo.
>>
>>> For the "on/off" suggestion: the on/off string pattern is used with
>>> single-value properties (e.g. LED default-state) read via
>>> of_property_read_string(). I am not aware of precedent for on/off as a
>>> string array for per-lane tuples.
>> git grep string-array. Plenty of precedents.
> I will keep the per-lane tuple model but switch tx-precode-enable-g6 
> from 0/1 to
> "on"/"off" (string array) in v7.
>
> Thanks,
> Can Guo.
>>
>> Best regards,
>> Krzysztof
>

