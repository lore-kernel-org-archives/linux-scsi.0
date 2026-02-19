Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595822FE595
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 14:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771510715; cv=none; b=CSbcg/C5pvqCmEMrONo3MzYgmevOXH9BXVjkGR0x5mlEhTWJ/YCcmqkmj9fepUo3TptCkq+aErDoDmqOELC3snB23nSARf34Y8FKx+YMRbeV0jckA+GqJcJME1g/VFxh89y8E+eyd50VfmfVyI2BV7LIBSst6VUAam4tQWao5EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771510715; c=relaxed/simple;
	bh=l2+yFArAt6HLkcsncg+FDTIGCg0hoeriCBLtZp05nF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GENzEbbPsLmVJEAeM2nLG9KJMJXU/n9WgNQnjpdSKZncVO2Bq612IlBub+Agr5aYbTwdvCKm8jEPuB8JhXQdhv3+NPFeOs6I6YISx48VyN0XgyP99qWEqbcQBg87gZRq3E6lV8Gh4i5zNk5GLCQXim4CrV3SOE26eqGLIFbxfvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DMJB9Bpx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ky61syfl; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DMJB9Bpx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ky61syfl"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61JEFbS24071040
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 14:18:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fI+C+WM3mKxwnH0W4AOtVbzKTZRTzsan7m781umLAjo=; b=DMJB9BpxMWLVLgv+
	r3jM4755MQco87FiotYp668gQRoT2lTX/MTV2GDE+/QLOSjAoOrnZtmqvLnnHKyX
	khmtrLnvN9TuZ8XJ09b8RKrg+JZNxP09b2dnaOFSWLHxwpRmV9GHqE0332mYrc1L
	I2vZzeznY/P8GesO+W6gp0oLES6j/lz6AkqUGPETfcYvo7Wrrw537E/RZ7Es6OwW
	C0M11gFDvzFB7fn1wX8GwQWn0qYi7eTCG+L+fhECyZDuR1MDh+7Hzmy0mHqqnxIQ
	I0DH9DWkR60G13IG3s/MfDt/9N9E8O6zHImDgzUrAeRLwCGPAMWsfF63bf4LvEAD
	ysHQXw==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cdtjy1guy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 14:18:33 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cb456d53a5so89724085a.2
        for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 06:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771510712; x=1772115512; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fI+C+WM3mKxwnH0W4AOtVbzKTZRTzsan7m781umLAjo=;
        b=Ky61syflwiQm/AVn3RfjsGYbmjyq0LqHLPPBeG96L5IYSmZShX367TTrQ8LKWTXeiL
         YRhjXfzkut53qj8jaEF94Jsbf+m2wblwKi/dzIkw37bPDth7geGhC134lHtyJJ/XUZfK
         zS1Fy7B7f+GAA9MueFdzlwawXqacvOZIDtZdQ5ZRKva4uJcYPhvtvv9g0fo2bTkq/82C
         8j6NjM8UfhjSDXKitM57T0DFhETzZnWmr2sfMCBtq6PzTD9+UpimTy7qr5lWOofW2S38
         ZVwIaMROC8TSXKDgUPUNQ0EucmaVtK37QdkOFSYI0/DP7fkKD+arh2H73urV1oAygCsi
         bJfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771510712; x=1772115512;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fI+C+WM3mKxwnH0W4AOtVbzKTZRTzsan7m781umLAjo=;
        b=H3OTxVnWzpXn2t8CeaIdTqFvU8T+bomJD8mVmSrBwirKS2WLnWu0rELE4J1D66llYV
         xU+srhfSchUJswA3MHtTnKdzsGJwz0XpDAYoAGJj3/Mpg1YSwK9zT/56646EXNBUNcK9
         u64Aq5rilZMblBSvD9Hp6+f8fLTyZ6kI54jfMqRRSrkf11jcFLSMcte+yYs5sovSaEmy
         58OelGp8zVYxTgQqhRBprjrONyGyeWUoZi7oPc5UU63rEzMnKH4G/cxMAWMqRof4KHIN
         9Mtg1aH1+ZxqavuvSehRWjBUGI34SC2bHH9pz84SJRXtojIXN0PinDtMlWyPBwfFnXRH
         XQ9A==
X-Forwarded-Encrypted: i=1; AJvYcCWpv42Hdi0sTtwZg1BxmZ/pyUL/+b12H5tlDlMfhfF4ajqPq9TRhbil4kD7+GM/aTSTujQKj+5tTO1L@vger.kernel.org
X-Gm-Message-State: AOJu0YwPM4LuUebOhlTBIAQ8D2wHu8WTaT/h/dbJ/ZxeNH383DDUzjBR
	llu/TXx039eHmymZE50TmEcYxXzOTVuNwFjEpza4rGbOd2J3XmlZVtbFOIw14/gL6cVJd/Oalmc
	ySU3xGADKaK0Lu4p9sR0WLUMlkfuu95qNz82dUrPoMXdNUvLsiVhbyFX19bj6C7hR
X-Gm-Gg: AZuq6aKzp2tcj3pM5eYKZDiODefLjAYmJY/dgVLBy/03t9YD4XgvMz/EUP9nkgowova
	Ob9KqfFRaEgK61ajkc6KPShrxpouP7BgHuvtYThujK3bPZESYtjdmemswueiHvdwvdj4Z8c/oHr
	+0A1Vf7U0Sd4sebOPFc8VYt0ovmsn2wh4G2OVJVTTxX+21Ek6PB588n+sua2xQlqrDTVtvwb9Dx
	wd7vlMOyvUXuofHc5dYnxbPjfw+ZtMt/rCB59XSliQ/v2dUWt8nGgSVKywBGv0kOFnRe4miqlbd
	dZ0xyAGTbCdydXkwvo9qIC/xycfUltSBujszEqb0hVLYEWIDmuDQkz54ylw29IULdjsGkfGEHiU
	v8DvmwVMhxwEyTl7kfVa4h1UHlaVk8VIBTdrBWrHIF2d2ozLf4Puum7tO3zTSvwVBgvukNSPr1l
	MGGjY=
X-Received: by 2002:a05:620a:468b:b0:8c0:c999:df5a with SMTP id af79cd13be357-8cb408c8f1emr2037398285a.6.1771510711997;
        Thu, 19 Feb 2026 06:18:31 -0800 (PST)
X-Received: by 2002:a05:620a:468b:b0:8c0:c999:df5a with SMTP id af79cd13be357-8cb408c8f1emr2037394485a.6.1771510711456;
        Thu, 19 Feb 2026 06:18:31 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e5f5b2e35sm5303818e87.82.2026.02.19.06.18.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Feb 2026 06:18:30 -0800 (PST)
Message-ID: <e9d543b2-6412-43f8-840a-044257fa9a96@oss.qualcomm.com>
Date: Thu, 19 Feb 2026 15:18:26 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/4] soc: qcom: ice: Set ICE clk to TURBO on probe
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
 <20260219-enable-ufs-ice-clock-scaling-v6-4-0c5245117d45@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260219-enable-ufs-ice-clock-scaling-v6-4-0c5245117d45@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDEzMCBTYWx0ZWRfX9IOeRPe3ThNA
 /nuQaOPFNGupddeqUYj1EjTvHxMNIw+MX1wtiqTzDPyI2bIa8iGwuomSPo/z89Sidk1Dfi3T0bJ
 8io5Dj5gReTuz/jMrAU7vbc71I2XUIh5ffVhq/t55uGqU0pXZOlnY13vEdSZ2L6KQLHKCvuy2Cp
 NuKK6LzH18U+lp8JTxKPX5BjISbnQpWC87NojtEGlOIofEsJ4RnoVwDNCKWAPXKUryrHkf4mpKN
 0W2Z8CErSKLM/IiBSMmsfhpuFxT8UHu+cfQDcQ4ccTvH6thnytzsC2RsqvFO2D8duVgg4yvRYcz
 4yRVUFusEFeWlNnKdIfOAtEbTF/FWR7aQp7nTF7E8xoeD9pDj1uDTs18B1L5cfWmecvsogy8hYn
 U+D8OmZeHYeJBxmzw5B/s41zlLxFwC2aWiLxganALoSW3cjR65z+ixbjopdSPUq38ApNB5d/p2U
 +CNoY3Azu+GrMoKaDyA==
X-Proofpoint-GUID: l97__CDymm_im_HJoSTZ8XQZrgje-eOa
X-Authority-Analysis: v=2.4 cv=FoUIPmrq c=1 sm=1 tr=0 ts=69971bb9 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=kiQjUq8FSzjVjtPiR3oA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-ORIG-GUID: l97__CDymm_im_HJoSTZ8XQZrgje-eOa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_04,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190130

On 2/19/26 10:39 AM, Abhinaba Rakshit wrote:
> MMC controller lacks a clock scaling mechanism, unlike the UFS
> controller. By default, the MMC controller is set to TURBO mode
> during probe, but the ICE clock remains at XO frequency,
> leading to read/write performance degradation on eMMC.
> 
> To address this, set the ICE clock to TURBO during probe to
> align it with the controller clock. This ensures consistent
> performance and avoids mismatches between the controller
> and ICE clock frequencies.
> 
> For platforms where ICE is represented as a separate device,
> use the OPP framework to vote for TURBO mode, maintaining
> proper voltage and power domain constraints.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
>  drivers/soc/qcom/ice.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index 1372dc4a4a4d0df982ea3a174df8779a37ce07c6..a60a793f9c230e08ebd7cae89a828980e762db27 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -665,6 +665,13 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
>  			dev_info(dev, "ICE OPP table is not registered\n");
>  	}
>  
> +	if (engine->has_opp) {
> +		/* Vote for maximum clock rate for maximum performance */
> +		err = dev_pm_opp_set_rate(dev, INT_MAX);
> +		if (err)
> +			dev_warn(dev, "Failed boosting the ICE clk to TURBO\n");

I suppose this isn't exactly critical, but should never happen either

Nonetheless, it's fine

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
