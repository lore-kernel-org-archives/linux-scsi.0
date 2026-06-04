Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B3135AC32
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 16:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780590090; cv=none; b=Bqli4R4FdVVY6GPKzydSPfCy7qWylyS9z3owJmt3asmD94X1TdRDfIlyE6NTvti+ksZBAGwVtSzTuQn2cZNyEAeWiasUVT+4fbTeh+gk1coMGs6PDtSchQzA+rk6XLxlDJgh8U11q7mDzifC3FDhyyHdtCr2TWXviB7Kuw9fGD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780590090; c=relaxed/simple;
	bh=U9TXOPd4VUyfgdGP/3YuDWRwWJZMvGYeMnDKutkGlKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e7FtMTFM9ZPyHPeVJMn0rvd2Sn8Hw//r1ASDwoa7L+7xzPlEGmDbYTMnATFvV41ZzFrK6OAsZLXA2B5ZD8vNZaQCPgpthCXaFJYyZzTpqwE9H2ivKzCuXHUtsxNFYVfF1Oa9C6BTD7Ma1wcXqFIvOY3wSNBGS2bD8aHE1Wa9yoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FsfbA5eu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eBAn7ZTV; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FsfbA5eu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eBAn7ZTV"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 654EkCCD1135908
	for <linux-scsi@vger.kernel.org>; Thu, 4 Jun 2026 16:21:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	i5z8HxmxqWrZU+ab7mxdqWnWs2pi1AFMItihc/yIPX4=; b=FsfbA5euuy6Fn8Oq
	LqN9kBz993FqfFn3JLUeP8qIZA0gOg65FBm8meZBdXOgElmKWi04pAhnMlxFBHcz
	q9wQVXEYBye7iQSGuUkjVKLrGEOu+guFT6j5yaFV6/0ooodeaaj2SEINF87f4AdU
	p6eSQFxKaJ1F9K2hNwxhsu/5Q/yMOTnpBG55rdwX0ZhdmQNp8DtufQcT99RQS7Nm
	n7XzpreRptrAHZTkFjlXTMKRTOL3dgclJtdQVDyEKNQ7NlQExzK4ioqsVUP32JIL
	RXyMjb7W0a6mqX15xW0OvOmyqnqUlkR4w64pcv4fiGPhxWSktXH8LH0MnhOOndmA
	/XJcQw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ek5wshyca-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 16:21:28 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2bf11699875so9282015ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 09:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780590087; x=1781194887; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i5z8HxmxqWrZU+ab7mxdqWnWs2pi1AFMItihc/yIPX4=;
        b=eBAn7ZTV28tKNpYIblro6uBmMLzhqJjruOsA8Wk1FFFSRBPJT8FGoFvSy+62C2G33K
         HZhocPoq0IIg8SB1r+EGmXt7SYeB5H2Oj2+Nikp4QDJ5nhsupfI3A51avTgayN2+MtIA
         g/k+Ijrsz1A0EtMyoacQYLgl30Sp8cByLsWQpv2N2h/Svi1EeE/vjfjUQuWzReK3z5q4
         EsucqtC1c1IcjnwF2Yve8R8RsEOb3m6wKcs9l7ccWL0jioT7tgE8JvfLd0KeD7CpouDH
         r2SRBSEKwMBJeiGjYl9X6v9OjHYvvxDVl8fXH2tXd+SLm2dlZHYB2HmAW7sEJG+oqfe9
         yNOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780590087; x=1781194887;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i5z8HxmxqWrZU+ab7mxdqWnWs2pi1AFMItihc/yIPX4=;
        b=EKYHHlIj695KzVX5b2dPvXsme5b0QAANyeRsutsgyLhRgPa+1zb1IIecaQjQv9g6kC
         ZFDSgF8WFVTCU1beqndGtSPb1/QLcz1B5LXvnKomRoDNK1ueCphkkB4nrxnA2KqNE7C6
         ZjFv05D9kckoqEa4muuMye2piVad6RlFFAiFHC/rjbHk3GJkp7BeLvdQrfFUBnayb1c6
         IkZprioqGxdtqJbzzvfNjTAxxEsZD3iO8ROJLCQ+JvkT0j+KLzBBinaN7hYUpr7ue/Fh
         9YC1/BRzVkXY0R4FRj1rup48XdmdkvGTAqgIUdoDg09SVOpNG7v7KgOP0KFnDfS6ZKHI
         pPjg==
X-Forwarded-Encrypted: i=1; AFNElJ+/hsWOvrSfgOOwsM05SzC7oJnZacyScOwLiXcTM3cTLdWd2yBQibPMi2L28P13YQ1PaKFdzw6Z8xIr@vger.kernel.org
X-Gm-Message-State: AOJu0Yyedq1tw8lIOFlH28VLiskkd3mX3wNqyueYIF/0kfRut/SyVaT3
	9TJDTnthW6goPGQj7frdQqNkvYFhx+IcmPtL/uW0KyedGkudzZOhTWwGxfzGS2FEFMMJ1Jl8u2+
	OZ8DKjv5Ul8FbTaiD6ssjz2C2EbMeynctnHBY6gjWhfz951BKgfYd+iHN5I/p/UV4O0VrtJAC
X-Gm-Gg: Acq92OGUmM0V2XG+AdMQ6bmEeY02nhcLvb1xogAHUJYnJ2s/hLmeVRYQ+QfbSAQIuS0
	ZlmBlLjiKWuS5a74Kjmbwjm2SWljo3eWac4D3UfyjeZ0/JClFhi45yqsnkzBLgBr0j6dd9m2KX7
	uq9vhaYNBmLJ00jzEsgScZTacfOjNOEfY+PyRNfBd7EcWWhfLpCgnyh6B48qfPR4zcDT7xhpEW+
	OXGRwn1/0agbaoik+8AygYlBxdFFS7fLWn8echZY/8izQ2oZoYAfCWEudSLLaQRzYpPwBmIC9Bg
	lEJahwXgnw85Fm9UvY9G0KJVfMEqpUbGKoYmB4SfzVmgnR1u/tHOpFX0J8pYj0fVz3Qp+kiy807
	AAko6SmgbEss6sjNPim3dy7vXgeU2rRmr5W82Xno42s1J0dOB17ypBf/54KHe1wZ9
X-Received: by 2002:a17:903:b0f:b0:2c1:88a1:9839 with SMTP id d9443c01a7336-2c197d3a55cmr40577715ad.11.1780590087198;
        Thu, 04 Jun 2026 09:21:27 -0700 (PDT)
X-Received: by 2002:a17:903:b0f:b0:2c1:88a1:9839 with SMTP id d9443c01a7336-2c197d3a55cmr40577315ad.11.1780590086785;
        Thu, 04 Jun 2026 09:21:26 -0700 (PDT)
Received: from [192.168.29.82] ([49.37.133.141])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16649bde7sm63691785ad.72.2026.06.04.09.21.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 09:21:26 -0700 (PDT)
Message-ID: <15a69353-8e1f-4ecd-95ca-96d8527fac54@oss.qualcomm.com>
Date: Thu, 4 Jun 2026 21:51:18 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add
 Hawi UFS PHY compatible
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, andersson@kernel.org,
        dmitry.baryshkov@oss.qualcomm.com, abel.vesa@oss.qualcomm.com,
        luca.weiss@fairphone.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com
References: <20260526090956.2340262-1-palash.kambar@oss.qualcomm.com>
 <20260526090956.2340262-2-palash.kambar@oss.qualcomm.com>
 <20260531-rigorous-gay-sturgeon-e8cfe2@quoll>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <20260531-rigorous-gay-sturgeon-e8cfe2@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: rKiagzttyEXw0tm_YNGVJuq9WTs8WYNa
X-Proofpoint-ORIG-GUID: rKiagzttyEXw0tm_YNGVJuq9WTs8WYNa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA0MDE2MCBTYWx0ZWRfX+1UECcXVnxp6
 plrpWE3XXrgu4hXX61rIbBAKgJLqKj8+/WOUKj9wVcYf1YA++YSPGnk7ofL2wVpb2MGQOD6qyZd
 Lt10ehky37EOSfxURBguT84WocoXkiIB6nr7zRwEN7XL1at/wi0ScbsGKiX0vzc7mZzS3HhJ2pp
 2sQ1eMB5kEVDOeaIvLDEGYaJf3ofimENlDldVFW2CaTULID2esL4TU/qXJh12v+NryTSQDXmkr3
 8FkilVLAl/qqlAJkD/XFocX+HFU2RTBBTSkC5WsIv/2ucWRb3d5TFEHgVja1rvWRRrYd7VGZGef
 tXTrZH9eFHTBDfx/9aCxFNRlresRQMtLYwx+zkE4R2HYTnWHQqK/nLB+lvmRgcDY6BwVSUPqWRK
 IMaRjNLax1Va9sEQIEZj2RdO6Xpht6yfndwKspIovSyLRcnkGZzcMmy4D7l99OpeEsS4ZNwo2jf
 44Px9pAY77Xuhptj5jg==
X-Authority-Analysis: v=2.4 cv=POc/P/qC c=1 sm=1 tr=0 ts=6a21a608 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=p6nWuE1qLcVxvtXth5uE9A==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=CrkXPM5SzrEx83M7ahcA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-04_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 clxscore=1015 bulkscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606040160



On 5/31/2026 6:03 PM, Krzysztof Kozlowski wrote:
> On Tue, May 26, 2026 at 02:39:54PM +0530, palash.kambar@oss.qualcomm.com wrote:
>> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
>>
>> Document QMP UFS PHY compatible for Hawi SoC.
> 
> Lack of compatibility is a mistake or intentional?
> 

 Hawi Phy is not compatible with any old SoC.

> Best regards,
> Krzysztof
> 

