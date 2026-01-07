Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A83932C92D
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 13:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767793655; cv=none; b=Zw3QjrGy4sry61i5KY9pMAnNosaJlZW9jrpH6tLiRkgX6pr8wviN7wWGvxbk4psb9+AKN6YONyp67ghoPomvCK3IxFfbqDen/M/QY3w3FdG9Pttw16Gxab3nR8kEZHv9kE3K9nVsf/qHZiDZTsJ21RAgwJyp+7fZ5S8JS2eTwZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767793655; c=relaxed/simple;
	bh=VGE45WNxQDTO014blHHjIi5tZVWuHW3PG7dXHce6NLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fpSHDkPDbRADsP81GgwJpBdLoSBd8w0l2VIIeTsLheIrwcK2yoABOKcMS1UpYCZL4bDbncln6Yuf5kVQh1iyYflr6WHBw1fC3eesfzt6CdTOCwuF5ZqY0/VJED7+JCfkl3iD/Y+jNnZp8+mjXAyiGQLxpbkBNaWEtiWM1wzZ93Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lWviJchN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ReiK0p8r; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lWviJchN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ReiK0p8r"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6079q5jS218397
	for <linux-scsi@vger.kernel.org>; Wed, 7 Jan 2026 13:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UgZSlnstuL+bWNOM3fLTFdzNQEvh4E0HKjNHVKtgJqc=; b=lWviJchNA/PsdJa2
	68HBFGAAEZATXJ31rW+2RG6l43QqyyRaxzF684XJltEXQSM/ozKObb9cw4aBVQpH
	aWTUCpkY7u9lVShSCiU8NyIbZtzl+Kb5NljkVbDKlx3x6xLL3ZME8NFKgL2XZNHz
	XWqL3dpqT74RhVzHVCJyvzBDMRPw2zZhrXr1qGLIPo04Htpt+kHmU7pzXK121ySt
	46ymjU6S0c79H1QjB4Qn33d/6CC1z1vlTugIxOV6l9O+WuApMaVjuEbkYi1VJN2d
	sLswJmRgRDpritd/ExnaDdVPkFVGh3WOHJxQD42tNFMuka43qg7ikNffbNf8XaD6
	YpCB/Q==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bhn808n15-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 13:47:33 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8b2de66a28eso56898985a.2
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 05:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767793652; x=1768398452; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UgZSlnstuL+bWNOM3fLTFdzNQEvh4E0HKjNHVKtgJqc=;
        b=ReiK0p8rv6lbD4R1+H4CcSbkWKoBEZEQNOz7h5ZTQiuh41UBCPzS9p1/KiRx/nEar3
         KMwiGmXLRR5AC18mK8Osi3xUwh1sQkzaDYt5gmiHzb8MHg9lha0O+5uzRpaB8so5X8IZ
         XuLcD+UBFYXE96gjcxccFSkBd3Bd4m0t+Jd0mf/O+Um8w7lggIueVoOzug30GnCu4yfq
         XAWg7rIhP6sD1FFzau/xX9CIIr45q7SHRVyJ3nMsaYzq6CwjilW6TWIPwuTJY203MJth
         Tvw5aDOnNcOiLNYU50rjkwlTyQt0jcMNRJjMwPe6uWUj5IXKFQpKOb0Pi+AcDg+QtHQB
         9Obg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767793652; x=1768398452;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UgZSlnstuL+bWNOM3fLTFdzNQEvh4E0HKjNHVKtgJqc=;
        b=dgoyPj++mWC6tXz+F4uF5cHWHkT2V0MhDYcJFsHx3NbDDEhbB1dFDOXWXRV+u9T10C
         MeuNlkzDC+V6ifY3nB36mxL5UfAcA8s7lOC5S4c5MVxO3qQWE3AfWitpB/hhjmTUKH6Z
         SsDARxQXcwH7CwVJqgSHpFLBl/7aNtoRhCqXOVgS89E+EOqV56AmxsJs5TYH7WSA3dvn
         jVZGHTJEtsz/ysq8QaTpLpk4dDQKnGqGYMWBoBkXwp8+lSss1B25DqUSJt3eEqMUKz9j
         DITwpli7wXqTfEyWvOf9SyoKBwMDyTj7H6z0nEL6o6LmbYKvFZurRYgmytkxjiDx8qy5
         GR+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVpgsbD47uHvyy3wZD7O9hDgkhXmbDnxAeB3oihoj6oI9uHQsUha3Kx5SNLHJofSwhhrM2tC9nyASf8@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjx4McZnJilnQEuTURJCh8IuZnvzIgoLk1NQxBs7JZ3h7Gh9AJ
	5zmgBFqdDskzZGwPvQKdcFITdKZ1ynL2jm/zVuYSjfNu6B5pcG8EFDdeukwJ4iDEePOaV05wa3f
	pmkHl1CS6zmUdkkIyWIUNLtfZ5WCZ+KK2QiHoV7Ze9JWH3Koqx+zIqpCLsP/4YOsF
X-Gm-Gg: AY/fxX7O1EwEDZpj0RUB6yMEIpWd1yNS+f1cU6+3TatSi3pDvFJUY2+YuHPhjouXeVn
	JcYYWEU85s0+5Mw66nqulAgQ68PaV50trsB5vb+oWVloDOfZH/lMZ7Izhj5wxQrUxqD8A3aqtej
	cogJeoOJKA+xNbWA/Y9GMHDl+302YfAJbBCsIeqD2KJ6H81Sm0tHnxDtpxHQ5hJpI0ym8e7xm1w
	X9B8hug2rzvhHzfvkX2zvzVCDkiWMuT3i9iyQIrzcxd4WOFVTmNfc6+XslWkcUQAmuJCrQvqAVd
	jWYtnSwGvP2p8xYBHRN0B4fP96y49kyiABYMOZ0GHmqxKsHum/Deh2NQ7EUeWaTDgJwXfRPdniK
	MXiTURUA6BZTNM5enBeXbsDQkaTU78GsXXf/l8xUrsVA3jRu0hd4yFSDijQeJ8w7hAhY=
X-Received: by 2002:a05:622a:143:b0:4f1:b3c0:2ae7 with SMTP id d75a77b69052e-4ffb49a0042mr24372031cf.6.1767793652357;
        Wed, 07 Jan 2026 05:47:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEqSd85JPwhEJMYgx6YhAsjKJYD9xSuGfuAYyKuY5Za86pnaJzUy8cquRaa93zxCj87b0H2UA==
X-Received: by 2002:a05:622a:143:b0:4f1:b3c0:2ae7 with SMTP id d75a77b69052e-4ffb49a0042mr24371741cf.6.1767793651855;
        Wed, 07 Jan 2026 05:47:31 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf6d5e0sm4665696a12.31.2026.01.07.05.47.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 05:47:31 -0800 (PST)
Message-ID: <0b27c56c-3aac-4b26-80f5-f8cc52abb66d@oss.qualcomm.com>
Date: Wed, 7 Jan 2026 14:47:26 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] phy: qcom-qmp-ufs: Add Milos support
To: Luca Weiss <luca.weiss@fairphone.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
 <20260107-milos-ufs-v1-4-6982ab20d0ac@fairphone.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260107-milos-ufs-v1-4-6982ab20d0ac@fairphone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=OtJCCi/t c=1 sm=1 tr=0 ts=695e63f5 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=6H0WHjuAAAAA:8 a=EUspDBNiAAAA:8
 a=RTUAgidmgk2qeza8I2cA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-GUID: R7Ele08acIr-7M1kaERUN35XCN1YveMq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDEwMyBTYWx0ZWRfX1EK11/FTN4Fv
 YyPzCgKkTlAFpisjT3GepKJL8yMh7BXSpJ90U67C4uNFyae9p48HPOVpMcZngLJZtly819WJi/x
 X06KPRZtWVx+Hwfj0yRZQXkt/8gXSOXw0YjsreS6+yxLCCz+06ROjumCEO5pJgtjgVnLJDc1HPd
 DbajHQUEt7rc6nZwLrG1h0TTdVt7EVCdZAmEK4A7jKesgnbzBw+YwA8W2exIfNTmtYFpYKwiI0q
 gE10wr0AAcychCXtgBu52PWrxN306fJ3bOAdL4u2gc5qoCddNvJ4vRPCVHg2ss0iWrllwr2d8zL
 x5q5x6NrLMb8MRjk4zdnfQMKCbkuvu6JF5UFuqbeFT45wiVRigYeHf2sfEOstBkd7Zq49c52Z45
 PqpvwE+CXf0H9IwHm9ljkXecv5kgYn9Oaupp78ZL+MdV3EHuYcMV0lunrer6Bgqv49z9WHz1+LR
 eCAGBxA5IE+nTOyqNRQ==
X-Proofpoint-ORIG-GUID: R7Ele08acIr-7M1kaERUN35XCN1YveMq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601070103

On 1/7/26 9:05 AM, Luca Weiss wrote:
> Add the init sequence tables and config for the UFS QMP phy found in the
> Milos SoC.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---

Matches the latest hw team recommendations!

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad

