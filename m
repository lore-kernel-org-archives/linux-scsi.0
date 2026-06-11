Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D49D402B96
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 14:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781187256; cv=none; b=g1kNoP+/4NDBGL8DCPnqW6H1Fx320k8p0qRs6vjhwELWVPe/6pRNE9C194xvk8yhMARVCK1oKtJ/3ZdfJt184vboiRUH0qVh7saMoP0g6bUNcCUlNKk2EeNmIY71EyLXnWKzLquvzpykrF+4rmDdHnZKIRwA475lxoISIwv4BCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781187256; c=relaxed/simple;
	bh=/KXfgHqvKtIKL7qU20XZzM/WnBHXM4OFw2OoYJ39uDU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJpqIz5n4BAMg/fQ05PIwJa/rR/77IWAzVwx3b4z/FBfmfDizt4sJbkmjT3ByvlWXaSxn22D+uVB/yaZDx/dnooJPtGjVEoTckYCHK7gjtXhRt9eoIJl4FdmgiAsb0qqXVi309Dnqbx9xgc7kyK6rrMomynBOJJ/+yFayds6Kjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=R/Qln5nu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YI0XGX1H; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="R/Qln5nu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YI0XGX1H"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65BCT67g546778
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 14:14:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BT1cmZgyC5OEU1NGiHjMPSjXyj8whKVB9HRG3NFstnE=; b=R/Qln5nuVBgPV919
	sfIX6c1x5AAUsW+SqhU8GbRqOn5FZxTnLGF5MMhTjop9k1CUzkBfGHVUnlWWwm1X
	1Ng8RG2z9BRw4UZI/gmpL9ZUyah+dbAMp3/7yoS4MCRk+h6YXmrIgx5LFtcRGtAq
	FACCU7+UcuEKjp+4DJVN9iyxc4xpc9q0qNH5tZkaGER5fiwr5qk1pr+BDX/3rVIe
	G45pLBwkU5lLfN/gtJIjtsuopbAxGvhvZH44xYl70gphNzjymbz+1RRKnQawi3Yd
	mj8E/DyNSYI9M+rp0CI2owsN3PhGB0qPST7FnV7pIyJQMJcgSbCXSkKn1sLa1AKm
	fF+CRw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eqe6skw9e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 14:14:14 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-842308adb3bso10416972b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 07:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781187253; x=1781792053; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BT1cmZgyC5OEU1NGiHjMPSjXyj8whKVB9HRG3NFstnE=;
        b=YI0XGX1HAgDkT5L1E5TaLTgMTs8U42xWNdiq29xvjKSiz29KFmXI5pt49QnB4Y31hp
         w/K/iNwQ66L4Kib3ldHpU0uXFpdnLQqc3iY2Ppt82VAuhcg06zPxnyqxSMIaa7tbBthn
         BbzanQ06y/amr7TkeUH/IaGMDKaj3ey9QhCVPdli3GyK0wIFoREkKNNg8yEUQyMIWCXK
         rdzuW/pu8Wiegk1wABo7cgACmngqn4JBsH79C209nTRC8KZks5bDhMdkJKVB7He9qoSL
         wPzJs88oSXZ6AZIBONg6ZE+o+z1DHtx1dZyy/BIfkoGIua8oU7ETI5/CiqnKyXX1Ior1
         ZY7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781187253; x=1781792053;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BT1cmZgyC5OEU1NGiHjMPSjXyj8whKVB9HRG3NFstnE=;
        b=I/KL/v8iiLVAy4ywP5CfSRqEttigqwJ8KOZUwgX+/k9+JXLvIBDU430sn2nRhj5Qja
         +MiR9FuhR50eRZ4cjw6D47+bRjh6IS73gNhKL/6dCyMB6VNcrX4E+JuERcOJ79wnpUku
         D1Ll8TEL+O6SBIrbeCztXkm9coUBKdltkckRf9Sn4ulS6Br8bc25dhG3wzQWSYQM04Ff
         VqQ7Uf1FDhLn5yRBw6BpMgxm4RY6+gkQ2VSEB3hTisVGG6kQ6yo9FrIZUFcMtRZ9aty4
         Ix+zq7pC5sRoiQxW9zpDAPimhFvYiZP3AmV0oXO8fLcNMCG5aLDWNagHwyixYQEIbL4H
         shRA==
X-Gm-Message-State: AOJu0YxxPJQfZ1NCHDXf9d5Qpn4edLObK0xYHCb76uT+oAsvO3aepbKi
	Vh2lQfC/4dyxNVj2GaH8gZwrPjPEWp4MIisGEKBvGsJQktoRG0mzErzJqvx76rmPsUBFXvmCme2
	5J+YSmPmLTpdrr/xIsYtyuwjQPm9NBO3CYXS08+XcTPftVdKPuza5Xxc7zx7/4LVc
X-Gm-Gg: Acq92OEO6mo2M6rcvQRxBaJApVAN2n5lGErEObdlF+VxoDcHIUtxOgl0SvPNXRZG1t6
	goAFm87qGpwvP2ZrG2pTyYCsrub799sY2tBU/2ZxkuTk19HLWRYTKIVezTUJCrOPATgkdcM0pXd
	eQFIzNe1+wB/jwEglJRCoifeTf5qaY8MXU10xZ8pnOWfkDcfW0vmvGEUIxr2qD662T12d49clgX
	4/0rUiX2ICcc2C+oOYK3b9YQW2Ggktidb4wOaLvnmRr9OfFqq0HVWW1i/Zj3GbZujj74baYvVhn
	fIxZTqw9Cnb+iss0c2G9eyjXA7XoLireUtP1tCRkBMSApNeBHzvX/4hxs4hh0pPVLJc27SpkA7l
	l7f/7bLKiTlWx8x3NA4irFdg/CChKtln/uWSL4RlCxDeTBWgIGHxiOrWGhPOyA/dyV0eLo6UFku
	XDX//5ijHhURQutz71zmRLcw==
X-Received: by 2002:a05:6a00:8d8d:b0:842:6004:3fcf with SMTP id d2e1a72fcca58-84336a8b12cmr3445498b3a.29.1781187253306;
        Thu, 11 Jun 2026 07:14:13 -0700 (PDT)
X-Received: by 2002:a05:6a00:8d8d:b0:842:6004:3fcf with SMTP id d2e1a72fcca58-84336a8b12cmr3445454b3a.29.1781187252798;
        Thu, 11 Jun 2026 07:14:12 -0700 (PDT)
Received: from [10.133.33.231] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84337be7097sm2391884b3a.24.2026.06.11.07.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 07:14:12 -0700 (PDT)
Message-ID: <ec582b2d-012f-4bba-a247-4b7040d02df9@oss.qualcomm.com>
Date: Thu, 11 Jun 2026 22:14:06 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
To: Krzysztof Kozlowski <krzk@kernel.org>, bvanassche@acm.org,
        beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, Zhaoming Luo <zhml@posteo.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20260610071516.3763916-1-can.guo@oss.qualcomm.com>
 <20260610071516.3763916-2-can.guo@oss.qualcomm.com>
 <b62e7f1a-bc13-442c-ad7b-0969e3b9073d@kernel.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <b62e7f1a-bc13-442c-ad7b-0969e3b9073d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=GbMnWwXL c=1 sm=1 tr=0 ts=6a2ac2b6 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=qkbM5XvOScw6ZQYEvzUA:9 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-ORIG-GUID: qN68ZSkkFV0yNRnerYHBgYjCFBmSZ4KI
X-Proofpoint-GUID: qN68ZSkkFV0yNRnerYHBgYjCFBmSZ4KI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDE0MyBTYWx0ZWRfX7D0d0wqXqYiq
 HwjA0mQ1vMxwpu8D79IQcST1x225jHa2n5VcZc2fmjQToYrNa5+PifJXAkxlk0LcgICgHnxWsmD
 Iw0xsznDJpN/LabBIgAabjfxR6SKqhUxqSjtoPDv+sbz9qk6r6gdC1iZp8W13ERWfnv1ms1wY2j
 HfwcMqmHRXLJazH3L4xTIH3Ck07cvt+e0aXPsezgTMO0VV7GpDo+pSTy7lV8exw6QZzlwAXWQAY
 ULkvO9ThRJY8xhc9WkWmhb2ffQGIsUhWslkqNHesh8I5Bnz3q0/wJI/0nt5V+h1WhE1zB8HLg/u
 vCZpypU8d0DIg8a61iGcsUiiiptSScek8BRXj1o+aqNFf7zrRwWVOr4TUZm8f0/moaRBh+9PIWl
 PCqKFkEa1LskNEjNT/qCMkqDyL/aHsliA8ohuF+uobbAaemqSOnqz2blZvQdQENji9G0TeaJr0y
 u8690EXLsbJr5a1CEcQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDE0MyBTYWx0ZWRfX0b47JeQmCYIW
 0s5ybbsiCaDrbFXKqYlNNmU1pUGg2UNz+UFjSaxLntjwbyILxW9HEkEDqYEnFjfH9M4qe7W5qkN
 9Qby8QLl/OJTnxE/w40YBhRhG3Gypis=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_02,2026-06-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 impostorscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606110143



On 6/11/2026 9:32 PM, Krzysztof Kozlowski wrote:
> On 10/06/2026 09:15, Can Guo wrote:
>> UFS v5.0/UFSHCI v5.0 add HS-G6 support via UniPro v3.0 and M-PHY v6.0.
>> These specs define TX Equalization for all High Speed Gears, and HS-G6 may
>> also require TX precode depending on channel characteristics.
>>
>> Document vendor-neutral DT properties in ufs-common.yaml:
>>
>> - patternProperties for txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6]
>> - tx-precode-g6-host-lanes
>> - tx-precode-g6-device-lanes
>>
>> txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6] accept per-lane tuples:
>> <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
> Instead of repeating the diff, you should explain why these properties
> are needed. Insufficient explanation was also pointed out at v1.
>
> Why this cannot be deduced from the IP compatible? Does it depend on the
> device memory? Who determines the values here and what do they depend
> on? Also here you explain lack of auto tuning for example.
I will give more explanations in next version.
>
>> PreShoot and DeEmphasis values are 0..7 and accept 2 or 4 values for x1/x2
>> lane configurations.
>>
> ...
>
>
>> +      Lane indices for static Host-side TX precode enable settings for HS-G6
>> +      only. Listed lanes have precode enabled; unlisted lanes are disabled.
>> +
>> +  tx-precode-g6-device-lanes:
>> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>> +    minItems: 1
>> +    maxItems: 2
>> +    uniqueItems: true
>> +    items:
>> +      minimum: 0
>> +      maximum: 1
>> +    description: |
>> +      Lane indices for static Device-side TX precode enable settings for HS-G6
>> +      only. Listed lanes have precode enabled; unlisted lanes are disabled.
>
> I need to reverse my opinion and let's go to v6 implementation. These
> properties look more consistent in v6 with respect to preshoot and
> deepmhasis properties.
>
> You want actually matrix, so:
>
>    tx-precode-enable-g6:
>      $ref: /schemas/types.yaml#/definitions/uint32-matrix
>      oneOf:
>        - items:
>            - description: Host_Lane0 precode
>            - description: Device_Lane0 precode
>        - items:
>            - description: Host_Lane0 precode
>            - description: Device_Lane0 precode
>            - description: Host_Lane1 precode
>            - description: Device_Lane1 precode
>      items:
>        enum: [0, 1]
>      description:
>        Static TX Precode enable values for HS-G6 only.
>
> And similar style with items also for preshoot and deepmhasis.
Thanks for the suggestions. Will update in next version and come back.

Best Regards,
Can Guo.
>
>
> Best regards,
> Krzysztof

