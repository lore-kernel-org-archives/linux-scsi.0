Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2152B279915
	for <linux-scsi@vger.kernel.org>; Thu,  8 May 2025 15:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746718248; cv=none; b=MKEEkYzyvp4FGG7SGGyGdpGJIOxr/OPXm3zbrLiHOSiOP0802cDnG5IK310UZ3OvmkFYOXd2uSQQEhcEtItWOHT7d2CJ/br6//M6jqfL1I/6nAVYA1HIbrrreejlLJWsTQXk0LlA+xRQWCzufFQLsymHpbVKgRONBvl5FK24WSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746718248; c=relaxed/simple;
	bh=Hwq9EPxp8FC16XFobVGFtBFmz7z8fzoxIcMzVoGcSx4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ld97J2Vpx8gRcaP4Z9yxlg79/OrfghU51briESmLvs2UzFgiRk0WgNfGLHxq2dsr6Dvgvk+gFKZ3K9YIKhQUmrLLOTH8tE2mG1VyPGbz3gkz+OSARtuvbnLTodrtYk29RELfJLPSe+KuFkONO4et9rUAXd3znbP7p0B5JYeQsQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=c0/fZMmC; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="c0/fZMmC"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5489cf1X013634
	for <linux-scsi@vger.kernel.org>; Thu, 8 May 2025 15:30:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fG5eq7oCcGLrY9+nU8ZI5t59ab5XGtk3o4t0+xbuPO8=; b=c0/fZMmCTTH1DGe2
	NsD9ace0U2qJN1YloODOXZcPPuTFMbUnIrudzy8bYOgflQz6n+QVeQ7c/ea8e8by
	G4na5bv9SBeUeKYIVTCGDndXpQSy6jOAxraI/dH9bsKqgD/tU4r/SOKLyVLEsC89
	2cFhc7Tj9bdaFuMbppRomMpfzPQvtAo2YlNW9js0VWjafRoXZ3KtfX9xpKK0TW1K
	6X7jF6it0vJD2RpP4LYO2/BMwV8ATb/ozhFZm4ez2/EZVx+COSfuKsKKHksjlUMr
	xzlyKbt7B3HX/lVwu6vorWp2FUEIZaP9ev4HXgVq12BigHrweocIh75exXV6oLqC
	1EmKFQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46gt52ryde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 08 May 2025 15:30:46 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c5af539464so26630585a.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 May 2025 08:30:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746718245; x=1747323045;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fG5eq7oCcGLrY9+nU8ZI5t59ab5XGtk3o4t0+xbuPO8=;
        b=eav5KteML4E1A6o0ue3sbyK7A0DtqtiDhv467gf+35S4uvDhQsYYruzFtHmzIiG4aM
         FEXopDOC9TxjCI7mKEMHPRnWp4fxonn4fyTbLBy4ieBKuZ2F3hBq04ka/Lfjiz5sRj6G
         iAN73D6ixdnllsT0LKXrVl97XqAPS/Bzgwng6bRhw15fp17+K8YC8LNb8DCnyE67uTV7
         XzUPSH2z2A4PZgoW4Dm57PykZMQYldZe0R53qmKUY3jDa1lEtVyq/CL8UlWgsapCOEkv
         UjHa+49J2FBZFWE9Q1UcFezw1awsbdSHfwWN6vsNLeXvj0d8htcudRsdu54gbvid5nx2
         PNDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVk/oGgwG1NVV+DcrRmF6b81sdg+DtaIjkwEfVYPNA9R76lrMjQW8s4GFFhbpcyQn6OLH8J+kQU6yN@vger.kernel.org
X-Gm-Message-State: AOJu0YyWgAq+2fMopq0G+lD8/z9fSsOnPCuW/hM55l3sxNmcXCdwJCdn
	dni1Vu+IpXtD1LQphc+4sfS6o6PNftNmzZVFwEkhTnKAUAkDY8ySFd8SgEunlhgdAQasOKhQSrh
	YAyq5KssGBIlfClgycnkqHS6i8UkoxcLiF647egHutsp4e132DZfBXs7uldrm
X-Gm-Gg: ASbGnctxmjoUBZ8guyFh6z9gW1hQhU6uGjjQw6AI7ZCxR4ZwILVYg7zbBovevonu87N
	SYYaTIFRdZ32avbI+ZuS4Dzp6t5awOBLoU9TfQcs35YnjQQje/72cQ0q4oLnaqvc+wJJdYSlOsv
	O6rroxmEBzUNs3zgMDzWTFZwrcS2WqbGyUw6qOYdZOrDREEf1Gq0jtJzgkMCBzpYMyqwkHG2rDo
	o9JKsEHnW2lTrt+YRIjVpyCzHWIp2i5NXiOiC3ftNXx+RM5iEofFhm87d2CbtyX0Y/eTJi3epa+
	p8Hp0BF7JSr4aNom4WWLnsZNhTPjV2UpvQBJthvPrM8xe11sr514z630G3Ncl5WCKW4=
X-Received: by 2002:a05:620a:269a:b0:7c3:c340:70bf with SMTP id af79cd13be357-7cd012a3e67mr101985a.14.1746718244744;
        Thu, 08 May 2025 08:30:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcHhfv1CePMih+NQ7khTsqGDoI3CoI/rsyT7oxNoEd8Echel305z0c+OwfziY7rWKZ5y4aBA==
X-Received: by 2002:a05:620a:269a:b0:7c3:c340:70bf with SMTP id af79cd13be357-7cd012a3e67mr98885a.14.1746718244301;
        Thu, 08 May 2025 08:30:44 -0700 (PDT)
Received: from [192.168.65.105] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad21974701dsm451366b.116.2025.05.08.08.30.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 08:30:43 -0700 (PDT)
Message-ID: <b3c662ca-16bb-44df-ba68-faf55b1e3dfa@oss.qualcomm.com>
Date: Thu, 8 May 2025 17:30:40 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] scsi: ufs: qcom: Check gear against max gear in
 vop freq_to_gear()
To: Ziqi Chen <quic_ziqichen@quicinc.com>, quic_cang@quicinc.com,
        bvanassche@acm.org, mani@kernel.org, beanhuo@micron.com,
        avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com, quic_nguyenb@quicinc.com,
        quic_nitirawa@quicinc.com, quic_rampraka@quicinc.com,
        neil.armstrong@linaro.org, luca.weiss@fairphone.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20250507074415.2451940-1-quic_ziqichen@quicinc.com>
 <20250507074415.2451940-2-quic_ziqichen@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250507074415.2451940-2-quic_ziqichen@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA4MDEzMyBTYWx0ZWRfX4V0j3Z2YAbyo
 URDgcgnpjPg+Imxr/9QSM+/WbVHuS+9w9ZG/XP+COK4dKR7rrjaMgQ93S3PsTZ0nCPz1CttCJij
 sB9c/s05sZKxiBbnhw4Vd9ngce7QU21DDWsN+/YoLjLkPBpYuK44PsXqSZT/FGqmxeGzNXb/Uad
 X6YnTPA2Cegm713IfLiBlITgKFOorrJGCGrXcf4jzwmHFayOExcHb947vB9P0ypt979b594cfaG
 xoDfETCITUV71bwIfU05plH4f6reuiVpP1rl766cKgmV+xM3o4hF7WGDzQVM1S1p9fTz0GKs1qT
 iBv4C04a+NLHDZIEHDN5GeLYs+woi0izfpBNzmXIwned5W057j0zN0EjyoVYUBMtmG+deV5/vBL
 aruQEakTVjvRdjOIFgaJHU32H0QXU4lA1Os0MRZ7N242J0ATCNiklyt46+vl4Lt0ovcDCArD
X-Authority-Analysis: v=2.4 cv=LKFmQIW9 c=1 sm=1 tr=0 ts=681cce26 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=KKAkSRfTAAAA:8 a=COk6AnOGAAAA:8
 a=ufAJUjbdAAAA:8 a=Ell6U6KZOJ3Qm4-2En0A:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=cvBusfyB2V15izCimMoJ:22 a=TjNXssC_j7lpFel5tvFf:22
 a=rB1ygNaI0PWiOa_UD5GD:22
X-Proofpoint-ORIG-GUID: 8SKVXcUVcFJKzFBrxRWVZT45esbWe4_O
X-Proofpoint-GUID: 8SKVXcUVcFJKzFBrxRWVZT45esbWe4_O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-08_05,2025-05-08_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2504070000 definitions=main-2505080133

On 5/7/25 9:44 AM, Ziqi Chen wrote:
> The vop freq_to_gear() may return a gear greater than the negotiated max
> gear, return the negotiated max gear if the mapped gear is greater than it.
> 
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
> Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
> 
> ---
> v1 - > v2:
> 1. Instead of return 'gear', return '0' directly if didn't find mapped
>    gear
> 2. Derectly return min_t(gear,max_gear) instead assign to 'gear' then
>    return it.
> ---
>  drivers/ufs/host/ufs-qcom.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 790da25cbaf3..7f10926100a5 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -2105,10 +2105,10 @@ static u32 ufs_qcom_freq_to_gear_speed(struct ufs_hba *hba, unsigned long freq)
>  		break;
>  	default:
>  		dev_err(hba->dev, "%s: Unsupported clock freq : %lu\n", __func__, freq);
> -		break;
> +		return 0;

That's UFS_PWM_DONT_CHANGE, please it so that the reader can more easily
make sense of the code.. Actually, perhaps this function could be tagged
to return an entry of this enum specifically

Konrad

>  	}
>  
> -	return gear;
> +	return min_t(u32, gear, hba->max_pwr_info.info.gear_rx);
>  }
>  
>  /*
