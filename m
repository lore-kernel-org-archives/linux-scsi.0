Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE8C3E5A1E
	for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 08:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779698773; cv=none; b=u1oiOAtEnS01N2gxw9cpyJmYmJmDCcp41pVY2dnFuu8W7BiQzrGGj1NEaWo3HZmrVDcQFgzVpHmHTO3e6/DJe8gKR+l6tdynJKCOXg0MsEVihUk2ske4yH0hcK9stLJ8fsmYniR8LFBU9tZ9Fv2NWIgxNuyBfWEi5Awg2d2DEyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779698773; c=relaxed/simple;
	bh=JOzlCCQgArEOC9cPMwGXLcMLk+pKr6iVJ4pkajoSe0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bzT+JscIB6NJON3CihsaawWSDqYu6aNmAltg02eBwzF2sYzRp+D6A4MYUd49UbMuvLD4evj+gIvwY6/BYkKYzj3s59R7+k5AiwKpWwShvuZWKFe6xmoDMP58cYkcBCfafcT6ndlODhqolW5nit/9A8UbXxcpWhH0tAcTsuv83SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=n0ZR32dP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Gmu7iBg9; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="n0ZR32dP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Gmu7iBg9"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64P7Adv0307831
	for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 08:46:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=hFiV6LzYg2/gkd1HSW0VgQp7
	ymJq45Zmxzox7MJnUAg=; b=n0ZR32dPrxyMsE59gimaKdFweRtJMKTJ66AMq3Dg
	S9F/YIQe9LKg/ekHv+TxEBfMr4FPbc+Urpcy5z0JLGpsvrDimvPF9BpLTKnkZ6XF
	sV1/LNEhWq4h73wT/uCA7nylzCs9gGAyMdOswznx0W+c+9f8P1wIMgyPAWTejbze
	OOh1zCKwyOjHvUFn2yenbwMd9rr4MxiylSZKSGMjhVQXbLKhtJaOkXxp3c92oW1B
	Lsc4bUWADFPCFNVsEAsDULjCg411sWsWll/eoBCp78NhDwCA679IhandwMPTIYtB
	V8/4DDSJDM6UMgk7R7ZMNOoZ3eDhDeO0cTwBS5m91hbJkw==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eb386p2c0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 08:46:10 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-516d19f68acso72545161cf.2
        for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 01:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779698770; x=1780303570; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hFiV6LzYg2/gkd1HSW0VgQp7ymJq45Zmxzox7MJnUAg=;
        b=Gmu7iBg9PcaFs34oIygHZ13z77jM/8d0HUxPwOgy/mxjzGmeGacpuayrCl/4NZQs68
         TemnKaAppplHER3ANaM3y/o/KZaHXYbKiDUO/VAVzKX2/33itENR4PkvhEVOc3Ktk2Ze
         m/4LVyByUgGxeBGYzNC7+E66rzdBod1q5wPBIZTz8kGWFKNLYFbB4etZwTAaaus68PEa
         uxSJNblreaLaKo51eHKocuPNwOEu5jZd/NRPPJO1NjrPTKYcszZhRz7uwCMbq7jz1sMl
         x7ZudN/D8oD4fsJZ8QLfuEqnLgiIVQP8bARJEezUyDk/2nfGz/vQpG1GiCflFor/L8qI
         0Zsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779698770; x=1780303570;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hFiV6LzYg2/gkd1HSW0VgQp7ymJq45Zmxzox7MJnUAg=;
        b=bcEpaa6HOPIYdeJWPkKpeWHOZXURi5TNQvrKJQ8nFOKRn4iXxBESZsWkR8yrAXCO7Q
         T/PxqQG4tb/hTpGPSaU+K4uOouS93ZS54VWnyheRZ3dnLuTrvvOoIYloW7nE8ROtC6Co
         XU6RrOY9J0ABgWEiDMMBHwussTu77EUDMaD+HjY48dyBa2bNvGubwkRkPTiNBE0cZVts
         B3HXrhkECVxDFH5zY9bjhSJMkCvaGQeTMrwNBYLCvDcxBSuusg4FIj+pOmH6ogL3n3Ex
         fTb4ymKVfqeF/UY8GF8wubMJHU5/HJWuyNex+Z+3s9/P4kU0i7MGtUIlT9mK4t/xujNI
         Y/gQ==
X-Forwarded-Encrypted: i=1; AFNElJ/tpSJd9Wk69AuMMigISz2IUEpP1LBzQ9Vj0XMcnqUK36MCS5wMAibeEZWpaSLTUY3E5yRyVlcKt4KT@vger.kernel.org
X-Gm-Message-State: AOJu0Yye1tQYjcenDbnMUWXYs+E79VgBQJMbpGUDi4BVdSD6+D91GDQr
	2MxHWeJLkd5FOun4Jv1FZA8pPtkXVy5lvdQCa/xO5IaY66RfA653WhqZVHLUnuw6o9ArDJ3c7z8
	QDRQu8fHLNGkH1eIen0by9LCxJuZeP+wOY3f7qHBR1Kk8VsZlKDDVrnuierlv7B4S
X-Gm-Gg: Acq92OHbr4EMB8Fox51sbuw1Ao35k5KEOyejdPSjS2ZzHr9lz+5kjTcPmMEf5FmG9a0
	VFa8Wx2fzLTWBIGDewmyx61A7WF1uaX1My+6BpGHspgk5EwGUpyi+3m1JWpwVdtnjMfT6YWdTqm
	26W79ArsZHl6k5CVdk72CSmA5XEvLv08nirkUP00ISsUpwjqzxxG4aSCbWP3jG2KFCVpmm0kuPG
	zMhOb5EmCetugusGcLRBtPNkYx9BHGmUSzMScF9X37z31/CnyHkgeE0oaMJUVHCHXkBN7s/EC27
	D944gFMusKUGzo3ZZmiiSkKHKnXx579W2YY/+LdrZ0Bjnx7Y7o1DJoS0+wmnWnWV9PKJ6DYTxj6
	skJzANLw8HsWaXGMnijPB2cZmzi2QhtG1EaNLBnMyQQdBA9ZRS+hyqbuy72RRXfq6dTAC2DS3/4
	eoOVOyoClZpxMtkpI1txcEtaV4lq0g3t3/KCk=
X-Received: by 2002:a05:622a:4a08:b0:50e:5acc:e795 with SMTP id d75a77b69052e-516d428549cmr194093171cf.9.1779698770160;
        Mon, 25 May 2026 01:46:10 -0700 (PDT)
X-Received: by 2002:a05:622a:4a08:b0:50e:5acc:e795 with SMTP id d75a77b69052e-516d428549cmr194092971cf.9.1779698769783;
        Mon, 25 May 2026 01:46:09 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-395dcc0a196sm21352231fa.21.2026.05.25.01.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 01:46:08 -0700 (PDT)
Date: Mon, 25 May 2026 11:46:06 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: palash.kambar@oss.qualcomm.com
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, andersson@kernel.org,
        abel.vesa@oss.qualcomm.com, luca.weiss@fairphone.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 2/3] scsi: ufs: qcom :dt-bindings: Document the Hawi
 UFS controller
Message-ID: <fhdronmweor6vb4yu3ggickvvzj7ls7w4eqb6tsvp4amjpg7ae@xfr4up3iesjh>
References: <20260522172716.820490-1-palash.kambar@oss.qualcomm.com>
 <20260522172716.820490-3-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522172716.820490-3-palash.kambar@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: yi0a7Yf7QI65-64X8Lr3t-6rTv1TYNu9
X-Proofpoint-GUID: yi0a7Yf7QI65-64X8Lr3t-6rTv1TYNu9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDA4OCBTYWx0ZWRfX8rpd6TicbXs1
 njh8YrrDiiJCrejH5aSKfor4laNPX5ep/Ei+1Iqpxxp5Ux3bek3n4SZUStDDt2CyA1XkwveP+ve
 Vxf47kz+K8dRfg6JLU867MRV/nBHHQqV540TdQ0Gmz3/1Y6/fwtuAyGD8EUfNMnX+mzyY6CrVPk
 xlAN+jXlnfRc8RfK7O1uRYr2tFtraHyBhNiBqBZMw57ykIPU7xjzT6igwx6G3Up1YViaDgL8xae
 lRzRWBEdrhQA8SjAf+HrjfYFiqjwY9WMGEUJusLABYFyL05d78xFac9EBDm+5a1KZj9zWQy5IXL
 E2LjASbFprLCtVo0hFCO0bKHu1FUb6Gm8ernaPTtVZ5Lr2L0H4xUDhT2PvWTRzKbuu6+SUTIWGS
 MrrFcDqt8oPy+Z2RBfYVIUlAKV6GR4XtmOCTZi6Rcx3ZyPpgtXpi4k8ZZWl5TygRWRL43j6BT+0
 kxHXNG0uIgN708xulzg==
X-Authority-Analysis: v=2.4 cv=PJY/P/qC c=1 sm=1 tr=0 ts=6a140c52 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=50Eb8-NO9TumpNjsHIYA:9 a=CjuIK1q_8ugA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-25_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605250088

On Fri, May 22, 2026 at 10:57:15PM +0530, palash.kambar@oss.qualcomm.com wrote:
> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
> 
> Document the UFS Controller on the Hawi Platform.

Please fix whitespace order in the subject.

> 
> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> index f28641c6e68f..3de00affa4c6 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> @@ -16,6 +16,7 @@ select:
>        contains:
>          enum:
>            - qcom,eliza-ufshc
> +          - qcom,hawi-ufshc
>            - qcom,kaanapali-ufshc
>            - qcom,sm8650-ufshc
>            - qcom,sm8750-ufshc
> @@ -27,6 +28,7 @@ properties:
>      items:
>        - enum:
>            - qcom,eliza-ufshc
> +          - qcom,hawi-ufshc
>            - qcom,kaanapali-ufshc
>            - qcom,sm8650-ufshc
>            - qcom,sm8750-ufshc
> -- 
> 2.34.1
> 

-- 
With best wishes
Dmitry
