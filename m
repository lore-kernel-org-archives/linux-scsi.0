Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F3C30FC06
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 12:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767011171; cv=none; b=u0QTbL3SHnNoNPjhcgz8QOYnPTEFPUbcP2bVGn04QGlAM6kN4UrPJsor1eO+ZduaUKsInuUj1YnXGblhGGSgzcDkE+U+FA3D+IHzx8VIyMeW78Ad0LVw4GShMFik2t1VnCPLnUr2IixOteMHtHp7JiLQF7NXoX57PpghMuPQpEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767011171; c=relaxed/simple;
	bh=ikcn4WZRbWCLPPagC9V2gjb/C/j86IUWIm1xRYhg8zk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PZeTTDAiNT8EDPmzb0b5FLbqBsvPs8H65M5PPl1Qx9I42jygIHO57Fl5QizPNYhLA+7uHhCjw4JC57jx4EHmpnQrB8020ssEu0wsSnS64tvEz4sgLzhKUw/RbUgAxvPfEJabnI9GfIWtrmcV0piR/oAWlRANHjgwyI+bLrDyKu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=chMeYr0c; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kUKlXEu/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="chMeYr0c";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kUKlXEu/"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BTBj3n03949375
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 12:26:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mN6LYrOGWt+c+fADT3LUTFhdUHN5Zo/kGP75Efm41s8=; b=chMeYr0co3R7t63a
	BiwmMzlSUGP3AfGKxHn3Jla0+pYUFpxTUXEyzG4fPErhIVZV8NxVHRx9gyD3Q863
	FU38wg0uFWJ41jswzR8Z8vZA+fCwzL87vCMbk9M3pIzxTePfBcU+RTJKDVYawvwn
	Jbm5PxOvsLZf0pzhrPGG8Xuoi1KuOoiLkePalrmzcXWJ3gy+K53rSkOM/u1+QSsY
	3Ro2buUfu78uPupYPViDmBDYBkqAfWR8ZjHtKtmnhZCD1kJneWCM9KZGiLL2LvND
	ALvjD3bqzi1h1ErXyEmIDZX3kgV+yETdriSzn6A3ztauaK7zb1ms78U5RvFMgxWR
	reVvWg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ba6dr4dmn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 12:26:09 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8b1be0fdfe1so386243885a.2
        for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 04:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767011168; x=1767615968; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mN6LYrOGWt+c+fADT3LUTFhdUHN5Zo/kGP75Efm41s8=;
        b=kUKlXEu/nBioSvQtKcFUeaea3y53F53DJXlPpuOqkyO8YcdFbKP87BJDFooKlHRIDa
         m2BYoWToT+Ekfwx9GyACKN7W9n8fKFNczPomPgkQuzsDwEpowZnHjY6kOfWGOooNzNMn
         S9tWjn0O5ufKL/98Bu2/dk1vBxjQ0oQRj4VMagJxiOxDaXs/Q8tNxsJ4rqFfp6w2V98+
         9tTzct4XFyJ4eKjlxQvMx7zLH2Ft5+9NdSPzUEXshwDjeBaRFnBGzFPiTwyQE5G8hw/w
         PCQvAoSb+MqLzMQdqYoq/q64NaZaUeEjGk7asWAXXoq6hiiGngsU+8LECk5N9Paod9un
         HDow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767011168; x=1767615968;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mN6LYrOGWt+c+fADT3LUTFhdUHN5Zo/kGP75Efm41s8=;
        b=wSUPtusGcOG4fBL5puOXTPn4HmJZ3QyttSXVrLmIlQ69yE+KOhbUC/A4jM94pY+cbX
         J9KzoxKZPs4J9ow/+NfdlnVPTZa6Ln2BN48kTkO2IEEBQIDOjeIHYgq3nGYqgreHtVRz
         ZN+BjQlIvuc2vmy2YebW86WyGnwrbpsQPDhmZiwAUituZl9FsiLnL/920vHvshTzoGWQ
         ARVVwiBVMoqnNqpxwEr390qRsNlknZtdT2os8+fGP2vzIzAsAxkQNd/cbDuiLTXZOsVt
         vcWxDxteIHaG0bPqdO3OCb8bIwsUmdBggzH2Ncms2lfxqKfu4p2/5DmNW4g0gxoXSvQa
         gw1w==
X-Forwarded-Encrypted: i=1; AJvYcCVgGqBota2zkcYmAyKt9FpJzA6x9AXt2PZMfHAfqxlUm6C2GurJ/OtvrY6V/UOEvbdRt8qRJgTtJOdA@vger.kernel.org
X-Gm-Message-State: AOJu0YwfbdRD4OGxga56jAJNyE0dXuqEVy5cu+OIp8UQn0iU1MRZrYsz
	kCMYyMhSp3L0pxuB9Ozz/Au6dNyvNtLxlWHcRsG2NH3mnbJGq8uGn13yzI7e9W8u9PDlT5qqG+j
	AKKFv5LTroPV+2kCMfFmfYTAYu+PEBM6Gvl0LKn6kg1/0iKFKB+rstuDbKcYImgfv
X-Gm-Gg: AY/fxX7G0VhSN8duOBL7eRIVoDKmVbMwFemRT8o4UGW7wkL6hfjVlt+I2TgeZJcfZEC
	xOX6e8uh3wOQwKbp90F6YP/aCevrD30lbb+jtASYStLaCOO2UW5kir65pnDpcazhAQQk8lemJlU
	LFngvncWp+2BepKBYBWzFvvw9YsTyuJKYOL22ig0OcdMnuwgdMQeQwUW4KT7PwgLWzl9uE+dVrs
	MlDE9xUTgDELAVRhJE/Zca9oLmKzXlDZPHXFKyf2bOAeL050kL3naWnQmfE4idu5mUQ1qpcDFl8
	oWyT3zUd3cHddPgCbfog56ZWb4+0jagFclGWOqi8Fr/iceYjVJSfZ9HeBgooYPFphopAYa7+1Jn
	Cchd2vGvrOoXTSIenilfbVFJ2xjYzBdcOiQumvDxbfSLErOY0ZH+1o4ldkq+w3VbnZw==
X-Received: by 2002:a05:622a:4d:b0:4f1:b3c1:20f8 with SMTP id d75a77b69052e-4f4abd30b01mr356524471cf.4.1767011168339;
        Mon, 29 Dec 2025 04:26:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHTNhJGS6wpzmfsSBspDO1neXn7hzzMwDf7y6CRLVLjolv5e+1eTU6agqRUfN/9vpmI89qn7w==
X-Received: by 2002:a05:622a:4d:b0:4f1:b3c1:20f8 with SMTP id d75a77b69052e-4f4abd30b01mr356523821cf.4.1767011167324;
        Mon, 29 Dec 2025 04:26:07 -0800 (PST)
Received: from [192.168.119.72] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b80377f2f18sm3295432366b.0.2025.12.29.04.26.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 04:26:06 -0800 (PST)
Message-ID: <5c97bac1-d796-4046-9450-65cc99ef7469@oss.qualcomm.com>
Date: Mon, 29 Dec 2025 13:26:04 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 1/4] scsi: ufs: phy: dt-bindings: Add QMP UFS PHY
 compatible for Hamoa
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>, vkoul@kernel.org,
        neil.armstrong@linaro.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, martin.petersen@oracle.com, andersson@kernel.org,
        konradybcio@kernel.org, taniya.das@oss.qualcomm.com,
        dmitry.baryshkov@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
References: <20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com>
 <20251229060642.2807165-2-pradeep.pragallapati@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251229060642.2807165-2-pradeep.pragallapati@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI5MDExNSBTYWx0ZWRfX9YR5NkxM2lLQ
 vFghQPIEYlAgWZFHxTJb4XNZp/OQh2fpSRZP093/7WO26x4q8dd72iaj/cmJ6P/qzUnds2syjig
 Cg9hZcgNKN4rRAlFGdphXwc3X0QbJ5NMXklcY37tF/JJIdNCeJ1Bsm5yt/qp4aMERiujRmt5JkC
 4mrZtCDl7Yic2CCZxXNkRk0Rm4whcB7+nsRvecrJFXZT3bkV3woW81rlEtNrh81YzeRmS6/CrlT
 XdrBgLHkmh9JuFX6/nE9IXUBdMqxoud1VBetL/gGY9/S/iDTJ5Fu0logbm0IHKM8xGdk8LuHvhm
 kQMAdBj8e/A/1WXFrXeiPtffDLWtXAxSaXb7XvOnarWUvTUFy8R4qmrcOYxPD6Kd5r9sjg0Gdex
 Z/pC52tuVbPWmVyJ1UY7Vv1kr0E73rzIBhHJ3gMNjBe+itligCpf85KHQSTqbsJHi6B9oBunmwy
 VKBhAzS4fXJV9ow/6IQ==
X-Authority-Analysis: v=2.4 cv=VdP6/Vp9 c=1 sm=1 tr=0 ts=69527361 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=x0PFmZ93Zfwba3del2YA:9
 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: c6xpt2gA-BAqSfkzhzU8qstP_3GjTk5l
X-Proofpoint-ORIG-GUID: c6xpt2gA-BAqSfkzhzU8qstP_3GjTk5l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_04,2025-12-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 clxscore=1015 malwarescore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512290115

On 12/29/25 7:06 AM, Pradeep P V K wrote:
> Document the QMP UFS PHY compatible for Qualcomm Hamoa to support
> physical layer functionality for UFS found on the SoC. Use fallback to
> indicate the compatibility of the QMP UFS PHY on the Hamoa with that
> on the SM8550.
> 
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> ---
>  .../devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
> index fba7b2549dde..b501f76d8c53 100644
> --- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
> @@ -28,6 +28,10 @@ properties:
>            - enum:
>                - qcom,kaanapali-qmp-ufs-phy
>            - const: qcom,sm8750-qmp-ufs-phy
> +      - items:
> +          - enum:
> +              - qcom,hamoa-qmp-ufs-phy
> +          - const: qcom,sm8550-qmp-ufs-phy

For platforms introduced before we were cleared to use chip codenames,
let's stay with the numerical identifiers for consistency (i.e. all other
compatibles in hamoa.dtsi say qcom,x1e80100-xyz)

Konrad
