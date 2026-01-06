Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842E1341044
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 13:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767706996; cv=none; b=u5bJaJKlj2BMcjowZ7CW6BUXjBH8gWWA8mXor0tz2GVeZkbVv2vsMkUCJgYFhwmQOW833qhKs/zynO2R4fmBymGqWoQ92iqTJgOfwaUhC1p20c8Xaz1VGotO+vQsd/N+d71JmEn9UAAEH49cf3Atgfw40Q4pZ6l2P/Q66sN2VZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767706996; c=relaxed/simple;
	bh=D80o9EsXJewZNSVmYUZMc01TjjkRv8EvS4LxYUBrHXQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=glXDuGqYiLufxFeRRuaxAiau2bCBn+X9F/jsb2d/4Z5Ba+7m+rqQKUfJ5wTqkpEBLsnvhOccfkCjBGV92bD/WWyBs2Ftm/yYupR2MBroi5vFyqqzTmQ4EZmtucqAH4j+IgTQ0ypso6UKNQ+jAQsXsbQrRBRDC7cM+MGQVNLngZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=J0aX86OD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Cjxd7htV; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="J0aX86OD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Cjxd7htV"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606BfNPQ307852
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2026 13:43:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uLiWYEynIRTli5iLZfUwSdeUWShSGGhNHrikoZue2hw=; b=J0aX86OD38L/ihEG
	cIqeMzaQaS0Azz0CWxLt3YxaH3ooW2TLrW0YyWV/gawC1ewJkoQ19h1DZAOhEdms
	n20GTq1JzJalmXtRQ8YuAU9/p2GkIyum0ld+H5sTHcqRpKJtsXrnaQzXGqo4D+/G
	f7cnfkq1the+z4fieWFVZBwfTfs37nITGNK+fD5H2Vz6WaizD8JRCKx8SNFjYIIs
	UKuS55JfZLDYBTypXBT162cPeaeM+ojqcv8qRYqFJo8tFmrFX+cT/u0UxByXWxNM
	H2ZgAcn3v161h9Aaqp981UkHcAWXClwtQ93sGqBXGEzgXpT8lqk/iULSgBaNMgEe
	4PIsHw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bh1r6gar9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 13:43:13 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34c64cd48a8so2114198a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 05:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767706992; x=1768311792; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uLiWYEynIRTli5iLZfUwSdeUWShSGGhNHrikoZue2hw=;
        b=Cjxd7htVOALHlriU+85anGleb7AX5eZGQMIh90tdlrU4Xr664SFOuWr82s5tAsGgE5
         XRvmdY7oXc7dGPvQcQetxXjTUbbdYRQnHZzS4oHCExzj7mITXsUo7DZmkeIyhd7A8CcM
         TP4p81aiJjOS9dBRYYgN5JrwVr1cbq3k4Crd1qQwDJXAERhspuACJ9aq5ZEvOfHmVCIq
         dk2n4e25BAyFCPOX3+S02brZxRlOKlG4fDkiPit7T2XKoyzskvQLke1fBdHvKbEf5T+N
         i90aSt3qt5daWwb4tkuebKZeX1ZbLuIAtvHQQDUdx5q/FF9OLek5qu6uVZllNJwDTpg+
         Am4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767706992; x=1768311792;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uLiWYEynIRTli5iLZfUwSdeUWShSGGhNHrikoZue2hw=;
        b=A9IEbsM4fBOhxODpX0CjnzYvfukQ0oXIYWrWW6awFRyooeIApy3EyYtxqnQr5Z9Nvh
         xcXjcDrTrRH8srZfGqXmTx4/5yf5QOpb/3YnDbWyvf2Ylq8GRtPExjY447dv76q0DlS6
         Qx1igh3t/JtzJDnNgq4FJZ4q5h/p+TsammiTljbXqvqFsf2/vltcgTQ4hA0ZLnS8+YYC
         oqju+XwgVb1QvP14HejruaE3rI4vCsgc8nWwTA8z+hk93LuYW/tEqtk7OU0Sw4LsAh1C
         6qJwZmgNT/lXkwCMvXRI10668UcaitZqNnH7AvDIQL43tgl9ln7rXL7rAsg6ieKPO+rv
         HLFg==
X-Forwarded-Encrypted: i=1; AJvYcCUWbedLg2QvOuanrsSpYBS/mz3BlISpILptoy+3xDaz8I+po5QsP6BoWGQKOT0vjL1VLlpjahUH2v4i@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc4MgTO7YTeioLl3fRF53gzVAGBoifL7w6V49lJso4xR4F/eT5
	lQZqoSROGOUDImaFQC1PXHs4tjYfkK7CxIs5FknVeGk6zUllAX7ptBpO4AaO2wxzRb0YSqBoTlK
	hGpUxCUl6QA8dCJz+qCjnNf7MRJLQbxsc59/O3sesb3RgO12koEdT9Qji/lyUFMnR
X-Gm-Gg: AY/fxX6QGw+wX4vLhAd/jDkRTsOAgddAMYRKL3EXVombuARBcjd346OuoF9a5nxoqPm
	qe5/ALd1GbXjQe/Wcx3Xu1b9qtAvBJv1pGFnr65fINCkxNWxtQm7M3Sb/RmwalzwzRl4W46lNzx
	zNMIDTA9CG2YrAUorBp8vj35vOCDTUoWDEq5CPGJ/pwnVNfOIHy5kbXvratys0xF8G8ddcjwt68
	OoamVpgmRT87q5Kvq46On17H2EVXJo4U01AcJtMIRZnwXDLDPEJ4q2uCYblSIa04oGrukaz1EjP
	q8EOPxtoJfRYh49OJbOBcXBSKAWVxU7G2yhIFZLiNDUYafypOFOyQVKlRA7kh5gh6KLnAX7mnH2
	pLaaH7UI+nA6qcFx2TmIKPcTxyWyYYVp0SY77
X-Received: by 2002:a17:90b:1c09:b0:340:29a1:1b0c with SMTP id 98e67ed59e1d1-34f5f27b806mr2702400a91.7.1767706992310;
        Tue, 06 Jan 2026 05:43:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGD+obWqEHiOhYvyIBJwtK58+QNm8r/eU2qpn1o9iTdFOjvPGIDaeqHWFLhjFsKmMd6wZsjbw==
X-Received: by 2002:a17:90b:1c09:b0:340:29a1:1b0c with SMTP id 98e67ed59e1d1-34f5f27b806mr2702382a91.7.1767706991838;
        Tue, 06 Jan 2026 05:43:11 -0800 (PST)
Received: from [10.218.4.141] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5fb7419csm2429615a91.13.2026.01.06.05.43.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jan 2026 05:43:11 -0800 (PST)
Message-ID: <1824a665-04b7-42af-b338-46c851a3986e@oss.qualcomm.com>
Date: Tue, 6 Jan 2026 19:13:05 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/4] dt-bindings: ufs: Document bindings for SA8255P
 UFS Host Controller
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@hansenpartnership.com,
        martin.petersen@oracle.com, anjana.hari@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251231045553.622611-1-ram.dwivedi@oss.qualcomm.com>
 <20251231045553.622611-3-ram.dwivedi@oss.qualcomm.com>
 <4mq5a4lhboymigbaruphlhip4zvmxl6xusvqrqb57bhx3yirt4@mgxdlr5onl6l>
 <d724c6d3-0dff-43a3-827b-fdf8be2a6a0d@kernel.org>
Content-Language: en-US
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
In-Reply-To: <d724c6d3-0dff-43a3-827b-fdf8be2a6a0d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: XWS9Q1hjdFxchfeQdzIqg5KdB2CT-_4N
X-Proofpoint-ORIG-GUID: XWS9Q1hjdFxchfeQdzIqg5KdB2CT-_4N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDExOSBTYWx0ZWRfX1q9pmq2sY6Ya
 WjzSUPDyq05gpeh6uqjaCoKmoxaUSWBLHbzoywdPwzmqzUolOduZmDYiKG3IuK32I9vKLBiWggD
 wGnYeHU5qWhU9mIyu5q6hEZXETFNkgnQUWcctQCLOrNzjgC5JLqHBX2JbVaQ7YZlnMhHPc8/FUW
 FZgvfM22BMgzSU/u9zDbE8hwr2hI783Ua7DsoDs3+Q3R9qoiRdnD1BeZSYWMJ6uvIOl3Sk0OEQf
 YqbSMKlxdLNKx7g4pbQzxfd0ksgr24TPUIUQamBFjfPmUaBLb5N7bXDjfeftFSbvbksOW0webJR
 oaizxa/OKeKEyIo9dQztcIVP1FqBhOeUN4pB7ERYpC6xDWWGV4S/H5a1FlBoX4pd+tnarj/AVAR
 h+pn6ZoWe1c0jBsE7YsIIJKn8HhajDPfZMaH6wtiQHf5TOAvxKVK7HiDAm7PKjoOpqBEyhPpfcj
 L1I/vATpcKHXXShNiUg==
X-Authority-Analysis: v=2.4 cv=Ctuys34D c=1 sm=1 tr=0 ts=695d1171 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=_ka70gv7TbPfTrNNl4sA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601060119



On 31-Dec-25 1:23 PM, Krzysztof Kozlowski wrote:
> On 31/12/2025 06:19, Dmitry Baryshkov wrote:
>> On Wed, Dec 31, 2025 at 10:25:51AM +0530, Ram Kumar Dwivedi wrote:
>>> Document the device tree bindings for UFS host controller on
>>> Qualcomm SA8255P platform which integrates firmware-managed
>>> resources.
>>>
>>> The platform firmware implements the SCMI server and manages
>>> resources such as the PHY, clocks, regulators and resets via the
>>> SCMI power protocol. As a result, the OS-visible DT only describes
>>> the controller’s MMIO, interrupt, IOMMU and power-domain interfaces.
>>>
>>> The generic "qcom,ufshc" and "jedec,ufs-2.0" compatible strings are
>>> removed from the binding, since this firmware managed design won't
>>> be compatible with the drivers doing full resource management.
>>>
>>> Co-developed-by: Anjana Hari <anjana.hari@oss.qualcomm.com>
>>> Signed-off-by: Anjana Hari <anjana.hari@oss.qualcomm.com>
>>> Signed-off-by: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
>>> ---
>>>  .../bindings/ufs/qcom,sa8255p-ufshc.yaml      | 62 +++++++++++++++++++
>>>  1 file changed, 62 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
>>>
>>> +
>>> +examples:
>>> +  - |
>>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
>>> +
>>> +    soc {
>>> +        #address-cells = <1>;
>>> +        #size-cells = <1>;
>>
>> This didn't really improve. You don't need 'soc' node at all. Please
>> drop it.
>>
> 
> It was already asked by Bjorn, then I reminded that. So I wonder if
> repeating three times will work?
> 
> Feels like a waste of our time if same feedback has to be repeated three
> times.

Hi Krzysztof and Dmitry,

I have removed the address-cells and size-cells in latest patchset.

Thanks,
Ram.


> 
> Best regards,
> Krzysztof

