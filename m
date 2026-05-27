Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591842F6560
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 08:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779871873; cv=none; b=gsdc9TssPgV7QX+tpKJ3Hirhak6drtTRKkmdddtUU3X9YSwBIAo/aD9eta4QtdqEkE1neuQ2fXjKoess+YEVAW3h7Z/XQRK+S96bGZTTJRAiOTTa9oabb3VZzJJQ9B5J94UGwtwFYoroWK8YGfy3wal1TraPn+6WAtVD/JHLYs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779871873; c=relaxed/simple;
	bh=DFJoUVD3KvyymoOkoSNQAVLhRnYQDEGBHGGZx7nO70o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=loQ1tk6oWyYjH/DnHYiFwTtD05TGenv96ib+4wi+oZ+yF5rhA8ADNZajaaDQ6DnhINBU2mMxBSEdQUa/lWA78pqYvrpTAcafce7kBdlBcjnUoVIMPFCmUuDPRlk6NH90MEJZ6Jl7pKnvdKsVjLN5nEEXp0EVbBwwlCYE+GJ4CVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iS6p1WY/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JDirJV3R; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iS6p1WY/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JDirJV3R"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64R8mZ9K1168079
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 08:51:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/6hNas6apydJkTdrJtwj+iHqEC9GL8SPaeohHHAAp3w=; b=iS6p1WY/yLTgswAO
	8kWHVQSv0t9Roku2LWMl/84BJ5Sqv5pfrfrBSh+ovc3y19nLMBaTKCexsYkGCcAy
	YOs7bN9t6X9zclCEJ3ZW6Jn6Quqb+U+84cZM88yvSG70/1UIXF6cVF3PKg43PigB
	/NjSKa9zqzEsYIZ/jbhl7Sa2axDwlsVZ1EapXYwKtLvxivHIa6qYgoKbYiPJFR7s
	zfRIp+FuuOoIFcL3VSTJVtSU+ub4xsPa3dC4Cje77AkRU9/lWD+3AKpM7aT0T35F
	F7KHP1SUBtuMelQkAAuPgIoKr68znGMcwWYhbe7t7Zo9+OBbGLc8sQeqkdatBNXx
	JyASLA==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4edfqk2uwp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 08:51:11 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-837c4eb3bdfso6922398b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 01:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779871871; x=1780476671; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/6hNas6apydJkTdrJtwj+iHqEC9GL8SPaeohHHAAp3w=;
        b=JDirJV3RAK++piRvBQUBCBaaHoo/fAE7s+2YqNGXKtMiLpi7lfYfclWVIYWisTX6fN
         mFSVn5g5+KMYsMY45wV5mSxepHSRwRz1uTdTuhpgoGs/itz5EtgahH+0lesuwWuvlfbJ
         EMBFfOr89keS+YyLCf8p1IT86swh0ICmXkcFAk66a88p3OLj7++kzvBOzUlsX7tzLMva
         jHLkldax5F3HJjl2za4dbZz9xVY6OoRXgGStshtuy5ghFf06l8qro+96jSkuqXqsEHsL
         /9NPunbhX5c+RcLwFqMFgCedcEii6n+xSMxgeS80pIN7B1RI47doZwklDfQ57sj34yCp
         JiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779871871; x=1780476671;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/6hNas6apydJkTdrJtwj+iHqEC9GL8SPaeohHHAAp3w=;
        b=jsG6e1PRnhDoULt6b7zcTlDoaG3mJhl0ffrFzVyESlEdiLDDOIsit+ri3eJnvqa8Fb
         rdoAwsmz5vuKubdbNCM+gWoUB5LHb1PF3RXqkNsFTVMC94BnslSV4cTxLFcth5sKzl8c
         VC4sqgxCInHFjrmaA9NC99lBHW23bjDO21fTHYvDIZKXzl4tbUDFp+gcbSwJ8zoILE/M
         8E51xaY1EE2mhXap5NCbE8P8J5V+szJj6TDowA+SEa0ftvnP3cxKyH613Gz192qPTz+Q
         IauJvUW9MIzs5kXDpEX7BYaIUIjWvnn63FSJhDM7kKHMoYqh1OwXquy831nxjX7bfrof
         9cCA==
X-Forwarded-Encrypted: i=1; AFNElJ+5MuYiXw3Z0k+qLSw0D04GsNtGXYDgsEAk0r4OOV9CpEcl0OKpnJqxT+6sb+bVf/FCU+hqd0jC8kEp@vger.kernel.org
X-Gm-Message-State: AOJu0YyWWKnkFTQVIrp+gda2ttmipn0htS7LuC7zYQUEZGidsL02fmF2
	M/CF8QsvluBwZLi5DSmHJlJ/IUj7Ex+shVwd/m34bwwH2PlltApgb1nsIEuOdi3dKJZRjwdDQtS
	8P6cXR2cwa8NuQZ/GKzdUSdgv/a5LM23TPw+mKixwjb86TiQKaLCOgqKt4sCW2M84
X-Gm-Gg: Acq92OHpStSXNONDVmopwx43X3xPmh4pe6HpT4nYi36PUFqVZcSNobi9ldus8lKc7KI
	LmLWNmgczwoAQw9Lkga2a/ikz2btaY3XgcBPfEaMEXt1RofLIZVmiwWC83gWR1LKSrhOTmra27w
	oDPOmWJWNgQJ2PWnmy6LuwKoZKNOyfHDUP0ge2wAWNGn+TuztBvK2LYBCE3ytbOktQS7I2DiF+J
	/cpM+jVcRNiF6QNK5VP39PQLc4rGf1t1rIzQ5wVvQ48SYL17284U3U+vPwW64jvLKB/rTlzqw8e
	eaU/fL6erhhK7a0GnMTnFDpQB1ruKIeOcFVY2QLDkCCDsigY5PvEXTEwPUbrMHFhGH6YPJ26Ppp
	Und6sxFkqmkvt8sUsQ17SaE/s7pV8hTEyFuG+12XihPVKbFHhGpRhBVB4wPRSAVDBpRCu5L9IrP
	X1y4uLMalgAqWGSWV4oI0Z0A==
X-Received: by 2002:a05:6a00:8c04:b0:835:cc47:6fe3 with SMTP id d2e1a72fcca58-8415f3b0825mr23559363b3a.45.1779871870744;
        Wed, 27 May 2026 01:51:10 -0700 (PDT)
X-Received: by 2002:a05:6a00:8c04:b0:835:cc47:6fe3 with SMTP id d2e1a72fcca58-8415f3b0825mr23559329b3a.45.1779871870245;
        Wed, 27 May 2026 01:51:10 -0700 (PDT)
Received: from [10.133.33.247] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d6ebb97bsm1659411b3a.23.2026.05.27.01.51.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 01:51:09 -0700 (PDT)
Message-ID: <96962564-ff25-4d81-a605-3d9c05fa000a@oss.qualcomm.com>
Date: Wed, 27 May 2026 16:51:04 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Zhaoming Luo
 <zhml@posteo.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20260523134711.323425-1-can.guo@oss.qualcomm.com>
 <20260523134711.323425-2-can.guo@oss.qualcomm.com>
 <m6qq3kxgfs73jve2pjmmszymgxb7aizdfo2rwg72o66n2rvov2@xkcvifciwu3z>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <m6qq3kxgfs73jve2pjmmszymgxb7aizdfo2rwg72o66n2rvov2@xkcvifciwu3z>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=fqPsol4f c=1 sm=1 tr=0 ts=6a16b07f cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=YG64nluAAAAA:20 a=eDkNqlp1enX9kxdETvUA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-ORIG-GUID: OXxftlmH4w6QhTIj7NTtiAN8ZlGBn-Kq
X-Proofpoint-GUID: OXxftlmH4w6QhTIj7NTtiAN8ZlGBn-Kq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDA4NCBTYWx0ZWRfXxL5AaeHVfFcL
 j4iYcP0HdJV0cnG5q0xuGy+Cu0203e0zYzv4Q3W88ylvGZPZTbedFNY1C4OTiw5AbjUZfQUPSqh
 ik3CASvFbROzmlWw6N1YCW2cU5iDll9DfDPU2n8FNKgyKVUMa7XUGIQBE2ou3m+RSCW3Rg9cx6n
 8dQJ+gOsK7WsQgCX21z9ArUCipfrqfoAUHBceaRqV+oT29v7WQP5/zYDa1XD6Ts6oRnZ2Ufp3i6
 EVtzEfvUt7IW7BgA2v6BKjKoSzsDTTL2635rLO4JHu4OAfatoJhUCkjN0lNOGmCcNvRvjHXla2f
 FWoQa9z/kBdySrR09vP6lR/M21i+1WNazZTBTvNjJBjxIkHmdiI7Q1hwOP6QmVnazyyKiWI/54U
 ulu1kr1chv4rr4imLXKyILg3hu16NmJU7BIP254NTMpJYDMr84fEqVOZagwLdhDJt2/Q8FpiKIt
 Rx6RJtyKGUKfSeOlxuA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_01,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0 impostorscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605270084

Hi Mani,

On 5/23/2026 10:14 PM, Manivannan Sadhasivam wrote:
> On Sat, May 23, 2026 at 06:47:10AM -0700, Can Guo wrote:
>> UFS v5.0/UFSHCI v5.0 add HS-G6 support (46.6 Gbps/lane) via UniPro v3.0
>> and M-PHY v6.0. In these specs, TX Equalization is defined for all High
>> Speed Gears (not only HS-G6) to compensate channel loss and improve signal
>> integrity at high speed operation.
>>
>> For HS-G6, M-PHY uses PAM4 1b1b line coding, Pre-Coding may also be
>> required depending on channel characteristics.
>>
>> Add vendor-neutral DT patternProperties:
>> txeq-settings-g[1-6]
>>
>> Each property is a uint32 array of per-lane tuples:
>> (PreShoot, DeEmphasis, PrecodeEn)
>>
> I don't think combining all EQ settings (PreShoot, DeEmphasis, PrecodeEn) in a
> single property as opaque tuples is the right approach. These are three
> semantically distinct parameters with independent value ranges. So packing
> them into a uint32 array makes validation impossible in the schema.
>
> AFACIS, PrecodeEn is applicable only to HS-G6 (PAM4), but the proposed
> patternProperties forces it into G1-G5 tuples as well, which is semantically
> wrong.
Point taken for the PrecodeEn.
>
> PCIe binding defines one property per data rate for EQ presets:
> https://github.com/devicetree-org/dt-schema/blob/main/dtschema/schemas/pci/pci-bus-common.yaml#L193
>
> Similarly, UFS should define one property per gear per (like, txeq-preshoot-g6,
> txeq-deemphasis-g6, txeq-precode-enable-g6,...) rather than clubbing everything
> into opaque tuples.
Thanks for the suggestion. I will go with below approach:

txeq-preshoot-g6 = <Host Lane 0 PreShoot, Device Lane 0 PreShoot, Host 
Lane 1 PreShoot, Device Lane 1 PreShoot>;
txeq-deemphasis-g6 = <Host Lane 0 DeEmphasis, Device Lane 0 DeEmphasis, 
Host Lane 1 DeEmphasis, Device Lane 1 DeEmphasis>;
txeq-precode-en-g6 = <Host Lane 0 PrecodeEn, Device Lane 0 PrecodeEn, 
Host Lane 1 PrecodeEn, Device Lane 1 PrecodeEn>;

Thanks,
Can Guo.
>
> - Mani
>

