Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844D718D658
	for <linux-scsi@vger.kernel.org>; Mon,  8 Dec 2025 07:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765177763; cv=none; b=HCdAiT5Ni/wnzeicrbKBgGFuriMr6s/mPZhw9jfsVmyFWV/OkFMETovT01E6uEqG7gjUW2PFDhWCiz/w63h1aeyOqHMpbBu4sbuwS1l5UkYwuOcY6K0GrbBex2TRsEgTD3FKFNtirWcX+euOrxJhx/QUBfmFzJss/Abr8rJe2RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765177763; c=relaxed/simple;
	bh=PShQG3ndj7tkDtNMZfmCOByjgIYKtQBRM4b7X5xkNtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gxa7k7joPPHSPzSKfJG0XQgZvQHYtZLup3uOl3yWPt2Xnl7G2m/A0XDDx/RZ//EONHfzAlj6th692CzyhLfmI7aVrwPmLqIVeNN9NUskz7zU8WbaYJftBJGT2T0svD0dptHHTlJqRmonHMV7uMNl32xY9THtRM+lmlLVp9ILKIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=REFpxc/L; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=F7LlNdx2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="REFpxc/L";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="F7LlNdx2"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B7MjVFf3037028
	for <linux-scsi@vger.kernel.org>; Mon, 8 Dec 2025 07:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	cX/+KAsLDp91a+LwpT9OZCwIyCxEuhtvetMOSj+6zSU=; b=REFpxc/LkER3KH2L
	tdzHMOzcBTFpxoLjrFLhSNKVXHRsFHTBCEh0Wuyau9fOW3Led86NxWM5aUkVhzjq
	zP2eayZiiPrD0o7c/zHKvagJsWzwymF6EmktmfxbuhV4JlmcApCGDDViKgK/W/2u
	1ToG7GGvZjcvlTelIV9gSOhcedXioyQmtznDWJWHdXVZ9rVb3zVMgybogui8dW8q
	DNOcs3SR9cIfZlSsODa3LhIvgemabTdMzfoLzNorj7mttlLTT2NW5SvLSPsZNSfx
	geq7CWl8u38yFPe57Jm8YvvbhuzKaNQ+RJszg1Zq7eugsLnnuTo0hGeR5hflwDUH
	8dbmfQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4avbesc3qy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 08 Dec 2025 07:09:20 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2954d676f9dso9326685ad.0
        for <linux-scsi@vger.kernel.org>; Sun, 07 Dec 2025 23:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765177760; x=1765782560; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=cX/+KAsLDp91a+LwpT9OZCwIyCxEuhtvetMOSj+6zSU=;
        b=F7LlNdx2MwdYy+lf0t8LXl4Ptq2S6gnMMF8GHvZ0cgJkT5jAo5OV2rkXQjhFqmLJ0r
         pKC9/NhRVb21q6Dd7AHKo+vVgc/11D6BKGRRCqgp/v9rxUGDjY24Kaa/uOXw1uY6LKFa
         TeLoQfKmAw4cZceHdJdNueGKzLQFRUvxRQL4WTZD/Pfus/vUZwS8nOCI/3sGuHjNSRcG
         lYWtEJ81y5vh+EaA7x2GXlvRTUwk/TmFzQfy30T/ApDHRFkbsxMro/BbXcLpyUn+kAwt
         i+5bNc2jy2Ed6+9LcDmKO2EyHulPywEte8kNG9HhXVokrw6S7mZ+4Z5CNE1YUymlFGVC
         LjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765177760; x=1765782560;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cX/+KAsLDp91a+LwpT9OZCwIyCxEuhtvetMOSj+6zSU=;
        b=f861npqkw+OrWOqYiDQN/Ypx5SWjNuwGThz000UqpXES7uC1MNuF/cmFSpcTXjKAi7
         MP34sVqrqcXMDUzbCZOza9ln7Nb4Gr/f8zgvu8SV13FD8wfJsAxYrFD1kCcoDTPeTyB9
         asg42UWAIDuN+a8d6leIlYZz7nwGyPKbQorteU1HzUC+2NDWjN377navpLe1IFfbuOHV
         7Md3ha2TBir7eHhsT7bQXAtRVjH5fPBkbA8/WRkO2VH8N8FB9lSGIU3LC6AOhdfRvSrk
         73KVRWdKe6+KDu0V+fUHmNBt9qcYuilPBweta0/OcrlrEgvrLSB6Tt2BLDX04btRiDhv
         Ocyw==
X-Forwarded-Encrypted: i=1; AJvYcCXuLG2VSjDyP0IMd/xw5ZaRcN4RA0OeD7aHXVAUvxrNHpdxOuALH5ihQ81U2SzmtRi9RhK7iHHbvBq9@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm1Mm1C7eUFoqDGc/b+4meifcYcBMWr0zA4pZb18FFLNNWnqND
	pH7kPGv6vxWH4xBglKqX9ujuq9zY2UwYbpwXyOcI4e0ALeJjqDBRQvvQwT/wOHJmSLVDyWxylpw
	5sVtF3DqzFcmbew46yzYf8VAc7iElGjDBi5nmRByRS95M48Vsp841+e3+4I/6clG2
X-Gm-Gg: ASbGncvDF5m/0ac644cSAKLTAfGYL23h+biQ+298zqE8rKTu/kdUyxo54/EnN51VIXV
	X3L5aueUKnHR2i65558daH5xsGT7JHGUTC/PcodYVzR7J5Vkf8wGyr3K2a/o70fuxyWTuA6cTzc
	ZqCHTnBFToHtjnQqkvqQ88wm0rLl1gXvb2WDxPymMGabubqKMVPaCqsj64J0wW7sVvZUfr7TAqB
	qNiLkMk+/PSkew5/tclOPDVQ75Jt7jcnMamDyfmckBJGymJDc8O4DMrZuDPfCpZeKg1tIJh9MWN
	0PguvO7vpLzUOU60Dw7jgs/CV4Aikax8M/8zWaVdEjAj6Lm6NeSFG8TLoFfWlQesUdVZeuSteKs
	28gdDnuezDCTf9jJejqDL0oJTyJFVNdvk5qKYH0MYGrpx8oCp9ArsQAa5jQdkpTWIF94=
X-Received: by 2002:a17:903:983:b0:295:86a1:5008 with SMTP id d9443c01a7336-29df610ba14mr55545205ad.38.1765177759830;
        Sun, 07 Dec 2025 23:09:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGx8XRYAyY+JvYHyb37Kf3oZ7+rhiRhdSwsRFTeeefOjC41lbHs9wT+4xGtntrNJazcEFuSmQ==
X-Received: by 2002:a17:903:983:b0:295:86a1:5008 with SMTP id d9443c01a7336-29df610ba14mr55544935ad.38.1765177759290;
        Sun, 07 Dec 2025 23:09:19 -0800 (PST)
Received: from [10.200.7.150] (p99250-ipoefx.ipoe.ocn.ne.jp. [153.246.134.249])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae49cbf0sm113370675ad.4.2025.12.07.23.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Dec 2025 23:09:18 -0800 (PST)
Message-ID: <4574e679-2f2e-49c8-abb1-3a30f3492efe@oss.qualcomm.com>
Date: Mon, 8 Dec 2025 08:09:15 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: qcom: Fix confusing cleanup.h syntax
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20251208020807.5043-2-krzysztof.kozlowski@oss.qualcomm.com>
 <lpneh6skxhpkalzvpjjresw3akxzzxmizohfzjtwgplzpjbsjc@yje4z22fbhcp>
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Content-Language: en-US
Autocrypt: addr=krzysztof.kozlowski@oss.qualcomm.com; keydata=
 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
 cwzYbmi/Et7T2+47PN9NZAOyb771QoVr8A==
In-Reply-To: <lpneh6skxhpkalzvpjjresw3akxzzxmizohfzjtwgplzpjbsjc@yje4z22fbhcp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: BFUJ0IaaQ6V3ggvZvUpT7A3SzKewjMow
X-Authority-Analysis: v=2.4 cv=GulPO01C c=1 sm=1 tr=0 ts=693679a0 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=gC7H+NTNV8TiHuUi9Bl0tg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8
 a=SeOFx7V_euqXWXERuV0A:9 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA4MDA1OSBTYWx0ZWRfX4exUNW3p8yXb
 soymXggfLA3CStUmdpGdq0+cEsxCfmgDQkT3R1JOHhYcCDKLNvd4cdEqd8dwTUQkANb7K2frfL4
 q3Ft5yj5i7pt8L1QFQN4xPGW2/JDps7F2vlgBornhrkcMu5NgP9KlwjO0mzMcrGamxeGIU4Ui/c
 pTBxAfiYUD7sP5yD3q8KnnoZTfd1tAslYJur7PHUnevIwHSbcgvPMrbGOF0XllM6tpoU/ptz5O2
 DC+2v5eMrzoO0s1wjhzR6gnpogfm9jV7lxAOKLEfLpKrgvDHWFxrl7D1CXIAXVMfO1WNTCtyN00
 spu4koE+IU1kry+Z7kBsCIKsa4QKclyWlxnXe1AkxE8+hfx8FNA7DsNoquYNX6Bfi5LBhkc5N/A
 COCUUPjcWjNBe0ET2iFylkmDY+gO3w==
X-Proofpoint-GUID: BFUJ0IaaQ6V3ggvZvUpT7A3SzKewjMow
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 suspectscore=0 clxscore=1015 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512080059

On 08/12/2025 06:16, Manivannan Sadhasivam wrote:
> On Mon, Dec 08, 2025 at 03:08:08AM +0100, Krzysztof Kozlowski wrote:
>> Initializing automatic __free variables to NULL without need (e.g.
>> branches with different allocations), followed by actual allocation is
>> in contrary to explicit coding rules guiding cleanup.h:
>>
>> "Given that the "__free(...) = NULL" pattern for variables defined at
>> the top of the function poses this potential interdependency problem the
>> recommendation is to always define and assign variables in one statement
>> and not group variable definitions at the top of the function when
>> __free() is used."
>>
>> Code does not have a bug, but is less readable and uses discouraged
>> coding practice, so fix that by moving declaration to the place of
>> assignment.
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> 
> Thanks. On the side note, I would recommend adding this check to checkpatch to
> warn people in the first place.
> 
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>


That could be too many false positives. =NULL initialization is correct
and valid in certain cases. Just should not be the default/standard.

Best regards,
Krzysztof
