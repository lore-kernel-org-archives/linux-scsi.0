Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BEB2500DE
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 18:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753210467; cv=none; b=OldpRjO451SR44MYgDWe4h4GdTFvXOqpfwFFKBw60Z8F8+A7EcGICEnZ9bMNzIzt0dPIVmQoFH/BwHez1n51F/Hr4r7Kso9hLIIOYrrTTpkte77sXulcpVhh/hVAbE/tN8Ezbqgm+c9cckT1Epyyqv49BqCJbTNlkmhOkSbCO9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753210467; c=relaxed/simple;
	bh=96xfn4tCHea2gia7bvnVjslaPkgqvIGZbOhlkhi2lqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ltvOfwAxMDqJV4DX7ktPyE0lV43QVvlAaGT7HHOSrgc7JgAMAx7v67i+elvN3JFNCgkc7tTwa8VzTJclt86lll3e5XUtkx6j0VyjKkDdFBnHfxKx89pYg5FYDSmAHgUhYeGuw8k+mv/i/XlmCyUIHujUhUZK02ZssnfncONPGak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OJ+uu7gn; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OJ+uu7gn"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MF5B8u012850
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 18:54:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=/4kWT0NOLTYGI8Jw3DZJpmHB
	CM5z1oJo6kgrF1DYaDw=; b=OJ+uu7gn9b6y+gkHNreX6ur2vMNsWU7RvG4zlI4D
	yUMSXtk6rWUBZiC4Lgr1TOdWW/x7MCIcu/FwC7R2kq9i6C5W6SK1bpYfH08zoWgA
	uPVLwBVIeTjuMFSkH3hsLljeQzydCoxvqJmZoXhbHzED2PxbNMtuv7VV82BGD8W+
	kI91abkXerfSYdJKjZnM51yZApXWp42vhHuD9qAfuKWIFIi3CYxterOcR96SV6Fq
	JwzE5N2h+7RiXdCGiHshDzd50iDXpfLjGhz8duQqsOKW1g13jxMwAMN5q4jf4DeE
	PqDKNvATfS3URU0mvvHr3YjjQAHVjPjC8JpiU6/McEFbYQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 481g3enced-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 18:54:23 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4ab878dfc1aso111308621cf.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 11:54:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753210462; x=1753815262;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/4kWT0NOLTYGI8Jw3DZJpmHBCM5z1oJo6kgrF1DYaDw=;
        b=jcTRYnvwu6jFCqDFnqaaCHuxRi7betmNwjnnEruaVqmaJ1BqYea+Vdp7tWE3TRENzm
         ruaPSN9amzUsLIX7Ms6+jHVcvUC4Kz+QAwWzURbD1bhqcXvGEmmc2ogimYSGrkHgxwi8
         B2suhMfjxnrWaIbCNQfMTGSmTX/rBhavB2WIKM9X3LmrqMDdsD5s6tJyvMgSTzo80Vxv
         czQzKPhuiwseUl2S7UpN39dP1JSwcOwsg1LNpwBXLYobMIH9ggJj5XqVvy/cn7zMpdbI
         GmQdBM3CAvKfh6fOVumrn6xyO//cPclWZPjI2mbW4fzEnz3kGG8hDsJJZf1lWiVVJurr
         DcaA==
X-Forwarded-Encrypted: i=1; AJvYcCW2hSS2jFiH6OQX1gL3RHXQ+I4mat+A1DehM5/rhkq4MPeVrnj7Qxz6TXM6olYcsFqDhQKcOxWUnEA6@vger.kernel.org
X-Gm-Message-State: AOJu0YxTqjfp6gF42vCK2NvLLR4dZMGIdII0oQrzHmPcC12XW/7Tlkbz
	MqF+ZV1yNziMq6XlQHkePe4cRM+nYF91RPVXmI9kDCztLKe7M6IQAYovy1BNKFX+y4rsMsd1XUa
	Usv9SYWa5UiqiqMuOCiYVU9sbWoJ1VDBs4rl5SOwt+cHGM7W3tx9pILzxq2CQJq5c
X-Gm-Gg: ASbGncuZAQktrIWg8YMlF0XzRBJ+me9HJ/LxhFyis4rOTQZxRulMX4Nki1h3dBFFAlZ
	hPZE802DunDJqKqte/SdVWsCb06re5AFEGvrW/oAOvRRjiYGkuG9VOsxo15cp5kKudueZ4LnNO9
	EN3Bs9EwF59Lf1+/Ep1OOmj1iJdkRegkbpV2iR01VhXi9gFSscBOFpmlOZUZViQfVtG05fjGfma
	AkhTWEFYCgI4K0/Pw3OARuoEMJQ/qW8HiGmvEEiLyluXzdMxOblwhagWycekrlZBaDw6kzD1gWw
	MiG9392y0pGQFNxHp9Rk8YAwc9ge1psZXsWBZ3Or9QRavEMGfu777vTaLEQNhS6UG0AskLEmFZT
	EgMWG+JkrpghQRZHcor0zTYlhRZQxwzQ2NGGvNSQDe5KcSiVh1I3r
X-Received: by 2002:a05:622a:144d:b0:4ab:377c:b6be with SMTP id d75a77b69052e-4ae6de98f09mr1912341cf.22.1753210461918;
        Tue, 22 Jul 2025 11:54:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhRnikguNGu1BrDZFDmisqE4jxon1gG+KvhvICXhN14dMxNM4hz1lupwOy1zhqjhe9hxqXqw==
X-Received: by 2002:a05:622a:144d:b0:4ab:377c:b6be with SMTP id d75a77b69052e-4ae6de98f09mr1911951cf.22.1753210461368;
        Tue, 22 Jul 2025 11:54:21 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55a31d912aasm2035430e87.155.2025.07.22.11.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 11:54:20 -0700 (PDT)
Date: Tue, 22 Jul 2025 21:54:17 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
Cc: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        agross@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ufs: ufs-qcom: Add support for DT-based gear and
 rate limiting
Message-ID: <2ihbf52nryduic5vzlqdldzgx2fe4zidt4hzcugurqsuosiawq@qs66zxptpmqf>
References: <20250722161103.3938-1-quic_rdwivedi@quicinc.com>
 <20250722161103.3938-2-quic_rdwivedi@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722161103.3938-2-quic_rdwivedi@quicinc.com>
X-Proofpoint-ORIG-GUID: xsAHq1o5rByXmgAqfw-oRKIpEpBmTCdq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDE2MSBTYWx0ZWRfXxFfLsreRFikE
 d8D4aaaiclqIswPJuu1L2v8mUQSTLpW7j7VF/uai/KW+HRi4w8UebveHJ6CSh5ykczEYzQCtT/N
 73KKrcaI9moxYlOEMO7gG47ifLT4B691OGDLchiK8tM5/EScsJdtgByYH42egO77ywjVWxPCZZC
 zlLtqtvjSistHUUlVaxHn5HmlWKwGhw0A1Bbl5dDz+kWJi8BT8M5UatDkMq+kQdYD9V4qc8NcU6
 JrB5dPAmgLOOu8IZ29ScPpZBAdjUt/kQJCkxL1xsTPOKuaU1q8wugXxgE1SRQ9LH75nXl7hExGD
 +ujSK1v20OyIqMAQNFKLbJ9Jx2EsX1vFcrbsYmREG0SiuMd+xn/r++lhq0X5o+Qq/agvgCIQ2XO
 Cyn4XvGgL99MGGx6Lxns4OsiVr/f6xjs/dJDYg+YSZXZoGGHb83ESWq0CjD7mDEfZCUYVtmr
X-Authority-Analysis: v=2.4 cv=Q+fS452a c=1 sm=1 tr=0 ts=687fde5f cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=COk6AnOGAAAA:8 a=neWBWJ4wSANu-z5_DMoA:9 a=CjuIK1q_8ugA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: xsAHq1o5rByXmgAqfw-oRKIpEpBmTCdq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507220161

On Tue, Jul 22, 2025 at 09:41:01PM +0530, Ram Kumar Dwivedi wrote:
> Add optional device tree properties to limit Tx/Rx gear and rate during UFS
> initialization. Parse these properties in ufs_qcom_init() and apply them to
> host->host_params to enforce platform-specific constraints.
> 
> Use this mechanism to cap the maximum gear or rate on platforms with
> hardware limitations, such as those required by some automotive customers
> using SA8155. Preserve the default behavior if the properties are not
> specified in the device tree.
> 
> Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 4bbe4de1679b..5e7fd3257aca 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -494,12 +494,8 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
>  	 * If the HS-G5 PHY gear is used, update host_params->hs_rate to Rate-A,
>  	 * so that the subsequent power mode change shall stick to Rate-A.
>  	 */
> -	if (host->hw_ver.major == 0x5) {
> -		if (host->phy_gear == UFS_HS_G5)
> -			host_params->hs_rate = PA_HS_MODE_A;
> -		else
> -			host_params->hs_rate = PA_HS_MODE_B;
> -	}
> +	if (host->hw_ver.major == 0x5 && host->phy_gear == UFS_HS_G5)
> +		host_params->hs_rate = PA_HS_MODE_A;

Why? This doesn't seem related.

>  
>  	mode = host_params->hs_rate == PA_HS_MODE_B ? PHY_MODE_UFS_HS_B : PHY_MODE_UFS_HS_A;
>  
> @@ -1096,6 +1092,25 @@ static void ufs_qcom_set_phy_gear(struct ufs_qcom_host *host)
>  	}
>  }
>  
> +static void ufs_qcom_parse_limits(struct ufs_qcom_host *host)
> +{
> +	struct ufs_host_params *host_params = &host->host_params;
> +	struct device_node *np = host->hba->dev->of_node;
> +	u32 hs_gear, hs_rate = 0;
> +
> +	if (!np)
> +		return;
> +
> +	if (!of_property_read_u32(np, "limit-hs-gear", &hs_gear)) {

These are generic properties, so they need to be handled in a generic
code path.

Also, the patch with bindings should preceed driver and DT changes.

> +		host_params->hs_tx_gear = hs_gear;
> +		host_params->hs_rx_gear = hs_gear;
> +		host->phy_gear = hs_gear;
> +	}
> +
> +	if (!of_property_read_u32(np, "limit-rate", &hs_rate))
> +		host_params->hs_rate = hs_rate;
> +}
> +
>  static void ufs_qcom_set_host_params(struct ufs_hba *hba)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> @@ -1337,6 +1352,7 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  	ufs_qcom_advertise_quirks(hba);
>  	ufs_qcom_set_host_params(hba);
>  	ufs_qcom_set_phy_gear(host);
> +	ufs_qcom_parse_limits(host);
>  
>  	err = ufs_qcom_ice_init(host);
>  	if (err)
> -- 
> 2.50.1
> 

-- 
With best wishes
Dmitry
