Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410F924677A
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765381955; cv=none; b=S9z9kNWyo8GyWxKt87woLlx8q2lgN8VVVf/viYzrWg+U4ZQKog3mfyYno7ZnliWjf4apd6WB+nTEBcDr5pXQi6JujyGn8/5HXY86DYkzjw/ujYZOpfBcNmG9JZfIowGRvt1nVUvvkdpxI+jtd+bdSmFb8bY2dgYRWkkZyo2NYSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765381955; c=relaxed/simple;
	bh=Sy3rkYIAkT984AorK7upQDIq//OeA6DevD/fk0iMMAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GXMDR1mvGECHsouIkY8GAxaRWF00UlQcA6iK1cSIv0yS91wWKHUMIRWjAhWjHiI+kvVIVdChUJMPJkB+t5Ovj3b8eZSWCX7Ddo7kJ7sW5XlC60qc7dZ/OUq6d+abZKXRK/WtBbN6L24pNMqImPtGgexbKFwCjX1vCyXAsh99pxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dqctR2k+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=So1WLXq0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dqctR2k+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="So1WLXq0"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BAB6EW32419737
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:52:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PJy/hWRaHKDG88WN/vJ1UcLi9eIjuGmXlKYwBNenPpE=; b=dqctR2k+ZnmQqdT6
	o5rcRVOD/O8kI2qs/6pFkA4TZ/87k+EoLTY8C2BjbGsFHIplbB3gmKQqru5qwjly
	+/Oh+JwUbyQENvD5Qcef58U5SdKCayaUPiApH/029ZeWPaWUuytiTNamiDwqiS05
	TeAR81zuKoyvAJaomGIGvK1CZGELfLQxH3ljMxgvnwKJurPQXoUFROvfMvuAGM/b
	XQOiDhf5cagsKwtgLpC+9es2MfhDrPR71XchcwvpGBYMd0Ym5UPJU3PY6t5H1Wvf
	BchyolZzacYqjejm46l2iUX2dXCEbye0Qy5lpwfic+bTtW9BFOrPesP+EaWqlvMz
	z9Wy8A==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ay7pp0vab-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:52:33 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-29b760316a8so9885ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 07:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765381953; x=1765986753; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PJy/hWRaHKDG88WN/vJ1UcLi9eIjuGmXlKYwBNenPpE=;
        b=So1WLXq05yGqqNFRvGuIlNYsfD7TIupu7v1frSGOp1Z9ysXEqDcRuzLaZ6IL0FLoJ5
         nHYvyNjkagcoZk3ZRcQ0gzpCNZ67csosW3nW7A5T2E/Q6ZULOt/hqjTdxE9mIqYOZ62y
         Ppn/ENdv7UUgBYtNKzF+j6xSH1lIl+3/g7slEEsz5h+vrTVdPlau9MadXBm9/KEGX1V3
         T5yxknXeCZNg4D2vW4U7S8qIcq5Wq0a2nTmVXu/maiVyQLJoVYHiTCEaai4uOMDgKE+3
         HfGUlQ3fqFkw12lX2ejpjLvdZejbPUGaqjNasVRj7f3jLKzoKCF1pa0uxVQObxPxET85
         hqkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765381953; x=1765986753;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PJy/hWRaHKDG88WN/vJ1UcLi9eIjuGmXlKYwBNenPpE=;
        b=kmDucE0A5YfwYO72YHKAkE7BTdd+fJCP1n8jg4ibcTJngctsfPojLew8noexH0qXyp
         6FkTNySRd8yQZsqp8xsymuDQ7cy2UUTkqhyMGRAMUUFQLjxgp2IrqUlq+EmVwf8b4Ppg
         iO2DzkqJvKK9NVrYQOd/l+s9g52Fw83VMJfO87jqnP7KBLB3ZL5fcCZLbtNj1XH22Jxs
         XRzQ4QmFGp/HBOPnGOQ8rFhI1yw9x6EZXN6/g+gyiXWZZEKpmZbl6lgULyQaDGNsbsRS
         OiBO2HJ09rc3JUL750GElnAK+UAtTApnH1rJe6gOG9b6n0R+QcjiM5SyQwJroNB9gu9O
         fwNA==
X-Forwarded-Encrypted: i=1; AJvYcCUTlyo9zrnZB+Plz8sZrfKo+F007yk0Gz//DAk3v0OCh2+23yWlHbBaHfAx9f8u/AvnS0HHwpKoCbld@vger.kernel.org
X-Gm-Message-State: AOJu0YzN/HFG44AAYlBDNJVJVzYOyBkVPvCQ0NYVCC8AiyuH1egqpIzS
	cFTR54th9eAcHLasnwBGy6ADu3dGFSHAMCQss+ItqbWiHBC0Lm6h6pg0s+DtfNgKOiL/hN7ORme
	4283xm0LmQBM9dpxWHiCIOOo4SxXjwqyZW8to7PJH36oRqDzTYQU4Zp3f/gJSB+uM
X-Gm-Gg: AY/fxX5NbnTvUFyfsDVqj/aE3rMH9r+nXhQKRBklRVX5zTyZdhaDFe4PafGtacGGmcs
	KnzCdz6Bkj8GU9vfo/LJrTkNy/gQfxAW10i2nTG+dclpUOlTY/f9LPOsV3Tq5mpVOJc7m+zvl0I
	3MPxegFWZOjtNc7wDm+JJWQLUvZCLp/Mww7ToTIDRIFgb9C/AnylSmjjYlDSPm6HMJcq3Q25eWh
	TzOj1u6cbhfjOzUFZSXjhMVGQv60Z2ajsm5PhV5FBh6dhqhiMBRozc7Pe5tqfXnSj1GJ8scAMAG
	nc12sjp4f7kubQA++nzH11M3YEXgGp7zSNZ/dJ9UVHoSq0Z+g++mnw/dzL4Q7TtmP6VbQuYxw8U
	NasufeDcBfEaQdWCumOe/ScfVtrl6WU9+Ubt8
X-Received: by 2002:a17:903:1a03:b0:294:cc8d:c0c2 with SMTP id d9443c01a7336-29ec22f5eaemr35571165ad.27.1765381952915;
        Wed, 10 Dec 2025 07:52:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGgR0SmEbFzoaUp8IC339sYqgwpstSC6VT0zYYRqG/MrbWzQIXm8DtQk0x+2NkzuYsymN0sng==
X-Received: by 2002:a17:903:1a03:b0:294:cc8d:c0c2 with SMTP id d9443c01a7336-29ec22f5eaemr35570695ad.27.1765381952378;
        Wed, 10 Dec 2025 07:52:32 -0800 (PST)
Received: from [10.218.4.141] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29daeaab9b1sm187393045ad.77.2025.12.10.07.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 07:52:31 -0800 (PST)
Message-ID: <bd2d11b0-c4fb-418c-9a0e-7f5d63bbed8c@oss.qualcomm.com>
Date: Wed, 10 Dec 2025 21:22:27 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 2/3] dt-bindings: ufs: Document bindings for SA8255P
 UFS Host Controller
To: Bjorn Andersson <andersson@kernel.org>
Cc: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@hansenpartnership.com,
        martin.petersen@oracle.com, quic_ahari@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251114145646.2291324-1-ram.dwivedi@oss.qualcomm.com>
 <20251114145646.2291324-3-ram.dwivedi@oss.qualcomm.com>
 <p6a5nazgd74fwbo6c3ctgvwifcigwwn4azkiu7nrmovrn5cmqn@nxzryxyx4oao>
Content-Language: en-US
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
In-Reply-To: <p6a5nazgd74fwbo6c3ctgvwifcigwwn4azkiu7nrmovrn5cmqn@nxzryxyx4oao>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: QPBSTmvc7KyiOdPhxb0BN-uDS5DdCtMT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDEyOSBTYWx0ZWRfXzyyUrTe98we4
 386pefj/RxylOEBR6rCtw8EK32u+Oy5JrefMS1D/tKMTbedev8a0mHWolOat3psDOmTeCJfPRz4
 M9JFDssEgB7Tan4n+I7LqojqAHwoPCNZZ6Qqi3tXxBTMI0brgX5ibgzabC+vaPt4djFDVuxxe+w
 B7R79SxRbHRfXj3HXpvYNM8V+78fk4MmsAvupaTr9R18wPzhRmRWBI2m4+mWACkIiWj8Jrop87v
 vC9StRXnxkNMl5Oq2f82Ux0ZK/adrJOU3in5cdjIujaeZ8TpBZSpRHlKZw0ssAQXawd6wRUzmIP
 7D/9psU/DYSddVnYfyLjqTMXOaFcsSxXjUGLfCbsBZSusXNXWSkX3/OEnRaUjbaL08QXXBtFIWy
 9ACv+UjHHEbbALCtEu/AGFZmE4wwqQ==
X-Proofpoint-ORIG-GUID: QPBSTmvc7KyiOdPhxb0BN-uDS5DdCtMT
X-Authority-Analysis: v=2.4 cv=WaMBqkhX c=1 sm=1 tr=0 ts=69399741 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=gEfo2CItAAAA:8 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8
 a=I-uMcen_RorggYIV1ZkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22 a=sptkURWiP4Gy88Gu7hUp:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-10_01,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 spamscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512100129



On 15-Nov-25 1:02 AM, Bjorn Andersson wrote:
> On Fri, Nov 14, 2025 at 08:26:45PM +0530, Ram Kumar Dwivedi wrote:
>> From: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
>>
>> Document the device tree bindings for UFS host controller on
>> Qualcomm SA8255P platform which integrates firmware-managed
>> resources.
>>
>> The platform firmware implements the SCMI server and manages
>> resources such as the PHY, clocks, regulators and resets via the
>> SCMI power protocol. As a result, the OS-visible DT only describes
>> the controller’s MMIO, interrupt, IOMMU and power-domain interfaces.
>>
>> The generic "qcom,ufshc" and "jedec,ufs-2.0" compatible strings are
>> removed from the binding, since this firmware managed design won't
>> be compatible with the drivers doing full resource management.
>>
>> Co-developed-by: Anjana Hari <quic_ahari@quicinc.com>
>> Signed-off-by: Anjana Hari <quic_ahari@quicinc.com>
>> Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
>> ---
>>  .../bindings/ufs/qcom,sa8255p-ufshc.yaml      | 63 +++++++++++++++++++
>>  1 file changed, 63 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
>> new file mode 100644
>> index 000000000000..3b31f6282feb
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
>> @@ -0,0 +1,63 @@
>> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/ufs/qcom,sa8255p-ufshc.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Qualcomm SA8255P UFS Host Controller
>> +
>> +maintainers:
>> +  - Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
>> +  - Anjana Hari <quic_ahari@quicinc.com>
> 
> This should be @oss.qualcomm.com, or @qti.qualcomm.com, not
> @quicinc.com.

Hi Bjorn,

Thanks for pointing this out. I’ve updated this in the
latest patchset.

Thanks,
Ram.

> 
>> +
>> +properties:
>> +  compatible:
>> +    const: qcom,sa8255p-ufshc
>> +
>> +  reg:
>> +    maxItems: 1
>> +
>> +  interrupts:
>> +    maxItems: 1
>> +
>> +  iommus:
>> +    maxItems: 1
>> +
>> +  dma-coherent:
>> +    type: boolean
>> +
>> +  power-domains:
>> +    maxItems: 1
>> +
>> +required:
>> +  - compatible
>> +  - reg
>> +  - interrupts
>> +  - power-domains
>> +  - iommus
>> +  - dma-coherent
>> +
>> +allOf:
>> +  - $ref: ufs-common.yaml
>> +
>> +unevaluatedProperties: false
>> +
>> +examples:
>> +  - |
>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
>> +
>> +    soc {
>> +        #address-cells = <2>;
>> +        #size-cells = <2>;
>> +
>> +        ufshc@1d84000 {
>> +            compatible = "qcom,sa8255p-ufshc";
>> +            reg = <0x0 0x01d84000 0x0 0x3000>;
> 
> Drop the two 0x0 and you don't need to change address/size-cells.
> 
> Regards,
> Bjorn
> 
>> +            interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
>> +            lanes-per-direction = <2>;
>> +
>> +            iommus = <&apps_smmu 0x100 0x0>;
>> +            power-domains = <&scmi3_pd 0>;
>> +            dma-coherent;
>> +        };
>> +    };
>> -- 
>> 2.34.1
>>
>>

