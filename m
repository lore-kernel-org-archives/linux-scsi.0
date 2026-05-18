Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B21A3DA7CA
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 09:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779097211; cv=none; b=Y0OTWQvdjlFm2u1EoTNCg/Mdr5fYKaMDNuJqXRa/iX36EeL8ErKQkZrR2tySVEUqdcKHadWiyVDSuZpEnHj+5Y//YKy9lKKWOS3JLINY5ZSvXub+3H/CbYYh+0fIQc5a09Lvb36auwMBAjMtawAo/cWoapqvb3qF05GeKWB1+UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779097211; c=relaxed/simple;
	bh=BbZDADV9aNJ8ydE14L+gU90RVsCd90buJJw+8cFtdeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XaK+GaKLCnQEv5fBZ65eWLZPrO5FdkXZjWpNZYDHmIlRWvUL+TIZmGQvdUXSj3wZCY4fXcIT91fDjHJtNcyds89vvUPVg5hbmcB9Xmhp1XK81y7NqT+Qweluc6B1AMKqCr634WroauEPt64xdaGlRrBhXG9Yn0vI7LaBNpLHgAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pYmbloLU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Y84B8F6j; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pYmbloLU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Y84B8F6j"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64I6bBBJ559349
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 09:40:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	lWFZw5xDeVN9rwM0z38SMphPc1np9JV8e43sR+KJnWc=; b=pYmbloLUXOYDrgdV
	MTJCyTa1SgSxp8UyD9RXP7uhel3YP7DfPIgnGs1XJF4doFwE6Ia15yMC0i7nTNc8
	hrQXoxASlRR3u5tNnMDNIeNfy63eca0cbRF5AlVq+Cu2ZYSKl9cBcuUobtyuoaU2
	+NeTDcnja/sJ0SXiT94+636o+NUZE9C+VGcfLSToUpW3IyBND6DoBI33MG0vheJg
	/zGDdycwG8pJHsSy3NZ2xXASh4Dwh6PEvz/onwf2+GpljuUbpnkaNJnyncqOP3Zf
	iwaru2Xy4tl5MnqsIP/xnRe3LF4V3HVis/qF7bIXCq69gyWnd8LAuuc8eM0JdyB+
	5q8Nww==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e6h0qdt0p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 09:40:08 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ba115ab6bbso23611745ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 02:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779097208; x=1779702008; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lWFZw5xDeVN9rwM0z38SMphPc1np9JV8e43sR+KJnWc=;
        b=Y84B8F6jzbZOAGHJpOPIFVhhyRpAFP+8i7jccmjgEMNDOSA8xLWaTPi+88p6Up6Oh2
         dPgCQ2FToFae/w8nWpdrcGT99daWJ4C6o0puHL6ufxQpCPFembH/SxN/oeMRwQzMMXen
         +bE48ZItR/je5kProL0PH54GvBVRDQz4sObvJjh4xy2i5oqhDBqZcZz1kh7pcaXV4x2/
         GY6eZMEQm82x5xdZnlQmfxfF91QAuMaLJTOW8QunfOMZ+urukPKylsH79qWdzR0g5NZc
         bcI0kwZelUaLucl7bfoGQY19Y1BptJYvw/O2o8n1TAyz+zydxVcC/U2ay6UZBLKtEQSi
         abvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779097208; x=1779702008;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lWFZw5xDeVN9rwM0z38SMphPc1np9JV8e43sR+KJnWc=;
        b=pCb54b5FVA7zwlRUDn7MAzEvFAV1x1YJU3OuSzXjZ4TeBDUxJKKsYZM096cu3YlTfr
         B5KImz2J6G823HXZDmtEt8P+0acB9W/cE4dZkDNl7rAErWNbYqs9f1C/U24UAm6H3N7A
         YBBsTHI/6WeMxUdtRLbIdm1uze4tN3+vK0lZkrT4GzIGhOp7SLaZ80BNjuD4W50kMsAQ
         fmCi8DzF4uwUlSDQdfA374q6iBzvl0UXHD0+XVZmrgCDAD3tWAq0W6H2ZhyMH+AEBLWf
         jvKvnsBMvYowiNae98+xg8nkLW+/aV54hNFFcR+PGRj9oqlAnyXPM9/2CZ6F747mpfvg
         cH/w==
X-Gm-Message-State: AOJu0YzEPUu90AM0qZZxop8bz8ksmi87kX+U6zG6InzLn6Cg9XgGQZGX
	kEVjGP+jgm5ew9MTp0Y3py0dLfhAoFJJcYsn8kOfstQtc2ygs5hmeDDjWBMkh+HF2gfLeOOLFWg
	CcJmnR4furohr2hqs904NgeFfNvazbJ7YdRIFUmJI76rVAT5c7RSnLBjwzC1FkzjZ
X-Gm-Gg: Acq92OG7rjuB0+JJDrHnJWxhpa4cofmV/yImXeqZ0jBrGmw5be4LvWNVmFEMo8BFxNB
	ItCVPT4PkVcOzz2o1dqRqlFjgj/MDQ0Z68Fgf+h5qw64via2AK2xgAt/m7HBfRS/ZttippHlCGP
	5ddjioTyxSJ8R0ZHMRg8TzUd4jXRlRQUMYW2Rf+zm8G91ihjKcsFdIiVdKCPWKOWZdFEOvxZBsS
	/MEeNcu0xP8EoSvp3CgZ0UZZnIfwNZKf2OnhNgtSSTWdinw25Gk3cdF/3mj0cP5FHjRGPOfLb7H
	/WKEAbzJwH36zjkUkv3LIf/DbpPyt1W6zeymFUh8NhEFLD7bRxDzUom1HW4WaB9BB2dBWcc2iqq
	NfoWqAOuS4tyVLKkbjB4f4IESF0sWInt9ymYn1LIJOssFM6PiPIcjyTWKrh3eoHpumgF81cNL2u
	X1p5FZQWMOULpRmovWRZggwQk=
X-Received: by 2002:a17:903:3c43:b0:2bd:e43c:12d0 with SMTP id d9443c01a7336-2bde43c14b7mr37115265ad.28.1779097207934;
        Mon, 18 May 2026 02:40:07 -0700 (PDT)
X-Received: by 2002:a17:903:3c43:b0:2bd:e43c:12d0 with SMTP id d9443c01a7336-2bde43c14b7mr37114865ad.28.1779097207406;
        Mon, 18 May 2026 02:40:07 -0700 (PDT)
Received: from [10.133.33.94] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5c16ac4asm134369635ad.33.2026.05.18.02.40.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 02:40:07 -0700 (PDT)
Message-ID: <2dc8245b-cea3-414d-af3b-c9fcc5b06785@oss.qualcomm.com>
Date: Mon, 18 May 2026 17:40:02 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: core: Add a quirk for extended TX EQTR
 Adapt L0L1L2L3 length
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
        bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260501131641.826258-1-can.guo@oss.qualcomm.com>
 <20260501131641.826258-2-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Ziqi Chen <ziqi.chen@oss.qualcomm.com>
In-Reply-To: <20260501131641.826258-2-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: OVOpOflZ1oz-HKGsF2WFUbsmvBodgZ_U
X-Proofpoint-GUID: OVOpOflZ1oz-HKGsF2WFUbsmvBodgZ_U
X-Authority-Analysis: v=2.4 cv=fIMJG5ae c=1 sm=1 tr=0 ts=6a0ade78 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=IHJe4OGsecWJCRHte3IA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE4MDA5MiBTYWx0ZWRfX9f35UVru5K8l
 4OdxsKBl1lLmGetSIaisW5aBPXm2tnGIWGpbssQXAjaC2NZ2l/XCy2RQRto5z5qcwKC8cLIoaLe
 2J5FofVgzfSOc4HxhYezpvqWKFHJ5xsHLBcvYQjn8t/tz6SW9sdI4Wxo2mkNxnObsKUHa0n+pSC
 ywW3cJMipcMIik2NYsTK8tg5GYx+xDW4lYvKTsRjX09I7SV/f2NJYeM+sb7mm2rPvJX4l0nXlKD
 HYVFqJmeObvLxasaMw6WWmShjB1RLrKblmOQfMPRRIGPsh8zw4+SWezD/AE555p5sK8vcz95IYf
 UI736fNtFVel9ULVMpSEH0pDGarWt7QGsySvIMCDlp/zixqIczj4AgnkQx64cKn3Yfc/ntGV/Tw
 MzCta18vzPP5ZjdeNN1r7oN1+hE+OXKH5YayoL4KvYI7lfHk/R7XyWJbjERAgjGFyk7PMo6iPA5
 eFAQ2KhcJvqy2Lyopfw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-18_02,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 spamscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605180092


On 5/1/2026 9:16 PM, Can Guo wrote:
> Add a quirk to support TX Equalization Training (EQTR) using Adapt L0L1L2L3
> length which is larger than what is allowed by M-PHY spec ver 6.0.
>
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>

Reviewed-by: Ziqi Chen <ziqi.chen@oss.qualcomm.com>

> ---
>   drivers/ufs/core/ufs-txeq.c | 8 ++++++--
>   include/ufs/ufshcd.h        | 7 +++++++
>   2 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
> index b2dc89124353..fe647450a7a1 100644
> --- a/drivers/ufs/core/ufs-txeq.c
> +++ b/drivers/ufs/core/ufs-txeq.c
> @@ -740,7 +740,9 @@ static int ufshcd_setup_tx_eqtr_adapt_length(struct ufs_hba *hba,
>   		if (adapt_l0l1l2l3_cap_local > ADAPT_L0L1L2L3_LENGTH_MAX) {
>   			dev_err(hba->dev, "local RX_HS_G%u_ADAPT_INITIAL_L0L1L2L3_CAP (0x%x) exceeds MAX\n",
>   				gear, adapt_l0l1l2l3_cap_local);
> -			return -EINVAL;
> +
> +			if (!(hba->quirks & UFSHCD_QUIRK_EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3))
> +				return -EINVAL;
>   		}
>   
>   		ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PEERRXHSG6ADAPTINITIALL0L1L2L3),
> @@ -751,7 +753,9 @@ static int ufshcd_setup_tx_eqtr_adapt_length(struct ufs_hba *hba,
>   		if (adapt_l0l1l2l3_cap_peer > ADAPT_L0L1L2L3_LENGTH_MAX) {
>   			dev_err(hba->dev, "peer RX_HS_G%u_ADAPT_INITIAL_L0L1L2L3_CAP (0x%x) exceeds MAX\n",
>   				gear, adapt_l0l1l2l3_cap_peer);
> -			return -EINVAL;
> +
> +			if (!(hba->quirks & UFSHCD_QUIRK_EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3))
> +				return -EINVAL;
>   		}
>   
>   		t_adapt_l0l1l2l3_local = adapt_cap_to_t_adapt_l0l1l2l3(adapt_l0l1l2l3_cap_local);
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index cfbc75d8df83..7a7c07636cf7 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -804,6 +804,13 @@ enum ufshcd_quirks {
>   	 * delay after enabling VCC to ensure it's stable.
>   	 */
>   	UFSHCD_QUIRK_VCC_ON_DELAY			= 1 << 27,
> +
> +	/*
> +	 * This quirk indicates that Host supports TX Equalization Training
> +	 * (EQTR) using Adapt L0L1L2L3 length which is larger than what is
> +	 * allowed by M-PHY spec ver 6.0.
> +	 */
> +	UFSHCD_QUIRK_EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3	= 1 << 28,
>   };
>   
>   enum ufshcd_caps {
