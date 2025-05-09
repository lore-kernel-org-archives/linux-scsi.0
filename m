Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D065E22AE68
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 11:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746790559; cv=none; b=mBc608NAnBnavbkCNOg0fGJG5ixG/+RWk98pJJr7a2a7gAKencbplNo/AQfcuJ4cE0Pa6b0Pn/KAeB4/MmV/JtqckDiJzNOciN/YSQ5Tj/aFrZR3G/GcUKgOpunbVL3HDybTq2fxQBMS2P5mkIu1Ga/AIUCq7yym4J8Wl+sePO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746790559; c=relaxed/simple;
	bh=b/ocDn60AZKD7DkQrGARHz1m4s5oOy4i/S4RjymqpjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dvgDlymbPnwhtGXccsmlbXA63UWaS9K04GBU25yI1RVVXlX61R5DqCzVVv90OkGlDCWNa7o+Och8r82gc9OAPB/1R0T6/9t+E3JYymhtV+TWW/tq/tHjPihKsEBdiEX+p+zMxKoMnQTw9q2Kwknz/LLpOH1NpS7XrcHlZWKslEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aAD2UEUj; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aAD2UEUj"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5493310W002620
	for <linux-scsi@vger.kernel.org>; Fri, 9 May 2025 11:35:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	clpGEQdwMWcHuVX1s2S+PQJLA4E0hBPTvMUFRssmFE4=; b=aAD2UEUjR0E5eUUc
	NtEkzdPATHCH3c90bsbbi4K5NgQftUd9kPGnopjSYTILXe1flpgQ/v0ieg7FHqZf
	G0cn7icUQiV8Jy6TzEM3nCs5aUz6AWV3wNXgit1O8deAK1dmq9c78Mu1SI/8zsNW
	p3aZEj2MwS8J5UDWtOVlC5nh38OEgFLMVwmevV9AEu/v0oVHJtLvhgQjc77439Xx
	l3Xq9SK/taKrJw8P8sFaVm20C9HKK/oThsATHMoe1o9uKQ3NT1dd93pJcKbaeshR
	Xq5lVFJ2CcXQr0GG3rFAK5v6906GY7UHzUxWyMZE+vPNtanuY8MACiiTtwk3CwCB
	B1Y1qQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46gnp5cfk8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 09 May 2025 11:35:56 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-48f812db91aso5096051cf.0
        for <linux-scsi@vger.kernel.org>; Fri, 09 May 2025 04:35:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746790556; x=1747395356;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=clpGEQdwMWcHuVX1s2S+PQJLA4E0hBPTvMUFRssmFE4=;
        b=qXXfIcTYIUCjfjHHSbxo4JwKMrES2VPrTGRqBYK5Etmr/4uIo82jlr00hO/ZT+52YV
         hWiMzCfz+3CjlYqSmlxhD4wZ0zlGysWd+Q82A9Xkw7Ed6XwbTLvxndGI4h1yu3b0ef9/
         Qq1VJGdntUvjHel0bRjyNydu3kOC/+Z/o8niIbHWxKWIW8J8FtUDnkHrVf5faHAz60o+
         cG2z34ROrZu1kY1GEcpabrKOV9SheUu6Yzm0N1eaqZ9tWDzAOugr8eJMyBPDcWpxI0gH
         nTB0RuHEs0/HbOvCyhBxuFMZBOz47m8eswz7A63HjclLhtb1YZ+KbchC5eFx7wsRMisW
         wCmw==
X-Forwarded-Encrypted: i=1; AJvYcCUvRRkXq9jW9Pv9plE7/E0/YLUR8xYBN/WSB8FFjzh9N+oHDBsnF6CBcnxFVaLJRzA/76bWeLHqXkCw@vger.kernel.org
X-Gm-Message-State: AOJu0YzRyNjGxqjrysaUkFoX+sTPde8k1ktahlv7hxj38+hl1ETe6kGH
	EysS+vguuCW5mNV2myOFdR9elWnCOP1la0tF3Ox3oPcoY1fHBlTkCJDONnCaA1/blajIM6TbMTq
	/BgFCU/U/GfiyA4c45SjN9dHAofdZzycvLA0e7ZTOz4qI6u8P9vQIBi1Mu2Gp
X-Gm-Gg: ASbGncujAXFyNPZ32xCzHT9XBSznasMMZzp9WnfROjfKgDN0bkjQ9h/H4GjVMCc6TyZ
	ip/vks+iDb1DzHeq8lMJ/kvdGlULWy65yHSgHbdWynUsryNZBYAnby95MvPIDFCGEL2NT6qHyzM
	m34Y/yrqNmJkfJRDup0hsmkl6D4yEJMpeGmkMM+t0dRnu3TNdc2rrGQcaOVR9pSRx0+s4W7jY1m
	79/kGzvAl52eRJ6AtYMkB/MKqbwR8wQbCYxCg/uT6V5MILbZxs5oIYZGUPCrGeGL9m7+iC+k5D1
	K7yAJBzKqE3Ur2/EnB1GkaNeeKUYIK/LNWzkg0VKy9fnFaqwdUCpcc2YBKQbzd/GR98=
X-Received: by 2002:ac8:5f49:0:b0:474:e213:7480 with SMTP id d75a77b69052e-494527f40dcmr13254071cf.15.1746790555653;
        Fri, 09 May 2025 04:35:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQrKt5+ENDzVyZIaPC6bM/I1w4UI11+gCCI1inxl4cHyjOu66kgARpVBcFs8jbdIp2WkVnDQ==
X-Received: by 2002:ac8:5f49:0:b0:474:e213:7480 with SMTP id d75a77b69052e-494527f40dcmr13253771cf.15.1746790555168;
        Fri, 09 May 2025 04:35:55 -0700 (PDT)
Received: from [192.168.65.105] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad21947b26bsm137062266b.86.2025.05.09.04.35.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 May 2025 04:35:54 -0700 (PDT)
Message-ID: <780d84ca-4004-41ef-a9ae-17532053f8a5@oss.qualcomm.com>
Date: Fri, 9 May 2025 13:35:52 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 09/11] scsi: ufs: qcom : Refactor phy_power_on/off
 calls
To: Nitin Rawat <quic_nitirawa@quicinc.com>, vkoul@kernel.org,
        kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, andersson@kernel.org, neil.armstrong@linaro.org
Cc: quic_rdwivedi@quicinc.com, quic_cang@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20250503162440.2954-1-quic_nitirawa@quicinc.com>
 <20250503162440.2954-10-quic_nitirawa@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250503162440.2954-10-quic_nitirawa@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=XL0wSRhE c=1 sm=1 tr=0 ts=681de89c cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8 a=ItZO8zVqQjmK9ylnveIA:9
 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: X1ouWpDimvcd3bcPz83TGVPs0nQaexUJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDExMiBTYWx0ZWRfX6jkpQ2nTsSje
 QNMrjg2LN2Ax9VN2fIcqamd8kZ7MCmo103YNAsrgafZ4Qrxr7VbR5j2Kql1jAAyKTy/hz6qs9uT
 LM5kNfy1FAXUheQIYlrwyuOhLUy8wOyfkCuVmj8tGUTOUqK4q4BpbEj4DCMbRztVuGMx8ZZ2tlK
 Km6kKldj2k6L7RxAH8DrHSoJ9Ygd7JjvGWy1hRydWrbqfu0j94BNcUc/YhpXwXjGTFVCyHgeAeO
 f+ENkJqAPlXWmzEBg7xR3FWw9lCDviqTYD4Lg+aIZ1yayNoJwE2jAXgFQjNHFsot4EetELP0Le2
 Q88cxLlYTkbYLUGfAVs8FS4FmhEZkI3h9fWA2T/2P1abh1/1xyk3+aey37ptJ4MLQrmvnuI8iXF
 sjGN0fFnwT6FMXqZnKnjQFXzjcaGK85I9dbIg8f42E6XC/sOsJ2SDAheGqzzc6QDux86eK2f
X-Proofpoint-ORIG-GUID: X1ouWpDimvcd3bcPz83TGVPs0nQaexUJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-09_04,2025-05-08_04,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505090112

On 5/3/25 6:24 PM, Nitin Rawat wrote:
> Commit 3f6d1767b1a0 ("phy: ufs-qcom: Refactor all init steps into
> phy_poweron") removes the phy_power_on/off from ufs_qcom_setup_clocks
> to suspend/resume func.
> 
> To have a better power saving, remove the phy_power_on/off calls from
> resume/suspend path and put them back to ufs_qcom_setup_clocks, so that
> PHY regulators & clks can be turned on/off along with UFS's clocks.
> 
> Since phy phy_power_on is separated out from phy calibrate, make
> separate calls to phy_power_on and phy_calibrate calls from ufs qcom
> driver.
> 
> Co-developed-by: Can Guo <quic_cang@quicinc.com>
> Signed-off-by: Can Guo <quic_cang@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 55 ++++++++++++++++---------------------
>  1 file changed, 23 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 2cd44ee522b8..ff35cd15c72f 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -639,26 +639,17 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
>  	enum ufs_notify_change_status status)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> -	struct phy *phy = host->generic_phy;
>  
>  	if (status == PRE_CHANGE)
>  		return 0;
>  
> -	if (ufs_qcom_is_link_off(hba)) {
> -		/*
> -		 * Disable the tx/rx lane symbol clocks before PHY is
> -		 * powered down as the PLL source should be disabled
> -		 * after downstream clocks are disabled.
> -		 */
> +	if (!ufs_qcom_is_link_active(hba))

so is_link_off and !is_link_active are not the same thing - this also allows
for disabling the resources when in hibern8/broken states - is that intended?

>  		ufs_qcom_disable_lane_clks(host);
> -		phy_power_off(phy);
>  
> -		/* reset the connected UFS device during power down */
> -		ufs_qcom_device_reset_ctrl(hba, true);
>  
> -	} else if (!ufs_qcom_is_link_active(hba)) {
> -		ufs_qcom_disable_lane_clks(host);
> -	}
> +	/* reset the connected UFS device during power down */
> +	if (ufs_qcom_is_link_off(hba) && host->device_reset)
> +		ufs_qcom_device_reset_ctrl(hba, true);

similarly this will not be allowed in hibern8/broken states now

>  
>  	return ufs_qcom_ice_suspend(host);
>  }
> @@ -666,26 +657,11 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
>  static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> -	struct phy *phy = host->generic_phy;
>  	int err;
>  
> -	if (ufs_qcom_is_link_off(hba)) {
> -		err = phy_power_on(phy);
> -		if (err) {
> -			dev_err(hba->dev, "%s: failed PHY power on: %d\n",
> -				__func__, err);
> -			return err;
> -		}
> -
> -		err = ufs_qcom_enable_lane_clks(host);
> -		if (err)
> -			return err;
> -
> -	} else if (!ufs_qcom_is_link_active(hba)) {
> -		err = ufs_qcom_enable_lane_clks(host);
> -		if (err)
> -			return err;
> -	}
> +	err = ufs_qcom_enable_lane_clks(host);
> +	if (err)
> +		return err;
>  
>  	return ufs_qcom_ice_resume(host);
>  }
> @@ -1042,6 +1018,8 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
>  				 enum ufs_notify_change_status status)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> +	struct phy *phy = host->generic_phy;
> +	int err;
>  
>  	/*
>  	 * In case ufs_qcom_init() is not yet done, simply ignore.
> @@ -1060,10 +1038,22 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
>  				/* disable device ref_clk */
>  				ufs_qcom_dev_ref_clk_ctrl(host, false);
>  			}
> +			err = phy_power_off(phy);

a newline to separate the blocks would improve readability> +			if (err) {
> +				dev_err(hba->dev, "%s: phy power off failed, ret=%d\n",
> +					__func__, err);
> +					return err;

please indent the return statement a tab earlier so it doesn't look
like it's an argument to dev_err()

putting PHY calls in the function that promises to toggle clocks could
also use a comment, maybe extending the kerneldoc to say that certain
clocks come from the PHY so it needs to be managed together

Konrad
