Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECED33D6CF
	for <linux-scsi@vger.kernel.org>; Fri,  6 Feb 2026 12:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770379427; cv=none; b=oTP0yTxt7QDBj8EW2g0St2fr1lVFCQJ5OE5MZJRAsDDNCNHhcq0Io685/owXpRSYR+xH0mBLChF46TnCw5qErqL+UtKC9gBqIDTGEd/5n7hdBVnFL7zLiApkreyC8EkxVSQwX7ScQ/ZIIQettdvlrxgS83NoltGTLiTtVXKQtqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770379427; c=relaxed/simple;
	bh=uy8KSJl1E4N7YPO0LpxK5qPqXXBNu7tHP4Vg5Bk3lZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iX5xj6cK9I5iKJ+WPPA2clNlBiwmrKiEUjVXPKg9JPYstKVdAvSgABlpcypor+9hKh74R5T9EvzHAgFeatmuUJEbBRSlao8lp2m1Q65o3VvFbBwPvRSHvk0pNsqw3iaGLelDBmpxNgKORmIE0MI9F/Z/uYDRoJWHGc/qL/iqjoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PXMR+MJE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hzjJ4lv3; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PXMR+MJE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hzjJ4lv3"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6167Xquf2482100
	for <linux-scsi@vger.kernel.org>; Fri, 6 Feb 2026 12:03:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	D7T/znkIGcIBDaQtDiqCYQV9+wOLqdbwc+EurdTvLiI=; b=PXMR+MJEslhETkVY
	MCMDVLvFyILaRh7tUetTxZ1avmPppThdRXrnzIv4eR4QpWJ4qPm406rCNr/yqZVn
	JZaIJvbDel4i5scGM7hbwIoZjPzdvp05lu2+fOuxhIezU9SM/HdOG7u8GxBr1n4i
	lAaX6u7WY0lSBMNtQqegg1eL2YFzc0B9fE08f9wpuGcJ1Q/3dIbxycXQDoYfy4FJ
	Nn5qclHYayIGdoDNZNK03ICt361Xx1Sr4P6bLF+h/mUVPfKlMRQkHVdqOjLBIeQD
	sr3jLAjcK7bYaYB0Dx4/Q5nFl8y18MXVoazLVUT2M8ZFFvRSi3ms5j+AACWI8Hu8
	jynHiw==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c5c170ur9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 06 Feb 2026 12:03:47 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c6310f81285so3487474a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 06 Feb 2026 04:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770379426; x=1770984226; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=D7T/znkIGcIBDaQtDiqCYQV9+wOLqdbwc+EurdTvLiI=;
        b=hzjJ4lv3xpv/7OreRoHOONs49TP6jCarw6gXfZYN0SERy2KakzPUrbKtdAE4XmrfYg
         JXyKSDIn4aF895miPo5yyyAuNvDhX3D/q7cs9yRPe5i/0gY/+ycOwpSWuUnLawNkkpSs
         XbRrl/qrY6siKlWYpNgUKxbxul+RQUbKOmZOXsbYGaxQfIKokPbQ4yAwRw9M61tlPuMg
         gn5s6b5vIhIDzcuW6Z5PK/YXc3RTlZhQYOefumwV38Ghj0h9DBNpOTnGf4T9zTGh4YnN
         JCTNY3fyOKpLgT4gPU1jRkwZ4WrsQ6tppyOIEXhyNsRRlrPrU7SLclq1rnqRHb7EbO49
         MdqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770379426; x=1770984226;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D7T/znkIGcIBDaQtDiqCYQV9+wOLqdbwc+EurdTvLiI=;
        b=ij6AhKJ8NcXbLE4qEdDZlmM4wsmomuUhH4pK0mau2VM8kyY/QcVUkBx3XWG/NMcv85
         wTbr1e8kunua4AMUdepAMBWwthR70CH+1RqmAYkGKirSJTrCyL2ho7BHV341mfQQOIbv
         NBxlp6bApBGNCkfIYClbPNDKO/GkZvCY3EREJ+flNL6flFegAZAPJhFPi/QQjzysOpR9
         C5ilDwrfq3yD9ciHvAkZcXUdwRYxYN92c4WHEV+l05qmnF2Nst+356xcLf2nWkzf5ZGG
         ExIsDlzvEaUMJ+3CsCwuZAeJVhiKnPQacg5BFd9abqAQyaM0JQJChpdrqC7a9ECtfWPA
         oKxw==
X-Forwarded-Encrypted: i=1; AJvYcCVV878p0Ek0gdU/EVhq6c0PF4LBuDlZDcqaUuHUpnTaWOvTtlT42+qh0/OpJjHx7ECfCeJIwAg9BHpb@vger.kernel.org
X-Gm-Message-State: AOJu0YwtIQpDWzqdysfaKdZPKHIm7JHOJODFLAh4Oqb1RLTcEnrMPum6
	2A6arXPRbTXw8ec1dE4rla6LpWIzvC26oYFejUHIn6xAek2x26EAT8uqsWnWMvxOxpIJEz0m9S8
	LEYK6bvDTrBVFClIWkXKRbK2jpAUDSBcTdYu5wZmrHrM3+2zK6GvNAAWGfmZOdRnS
X-Gm-Gg: AZuq6aJO1newk96ihw7nxHDlalbQjtSANv64trqkPRxLf5AUbu3vrldZmUPicjQp2fo
	WRBHmE1icL2FNt4BNqq9RmsEyhxo9zq128a+lyPwZWKTlAH3+eIS1k5WiFwdRO5ypcBhjNrhQLq
	Z+zyxzkRN0Z/k/Y+ps/f+T1KYMNJ6YMOOPEXrtvW1K5fku1md2TalSa8tPs7fORsGxqHjmM0hvp
	ek4TN8KzPZjqbyXZAAVjIKCwzC0IZ00U6WoFQtA4gFRMoj+WwWwLI6GxhQoLtIbtJqIgC7pEpyd
	RMO1hFEVf+oLrmvWBPqK0BP60EmJrJC2a3Ayp1zjSzRFgXHD/WpI6lRFJOSDok9CFQSO7n+Atug
	9o5uLoCeouQUpxlVoi3AFBD/CW0BnwBIcvJKl7NvAcNvx5GM=
X-Received: by 2002:a05:6a21:150c:b0:392:e583:b766 with SMTP id adf61e73a8af0-393ad339ac9mr2560261637.42.1770379426373;
        Fri, 06 Feb 2026 04:03:46 -0800 (PST)
X-Received: by 2002:a05:6a21:150c:b0:392:e583:b766 with SMTP id adf61e73a8af0-393ad339ac9mr2560231637.42.1770379425888;
        Fri, 06 Feb 2026 04:03:45 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6dcb4fbcbdsm2262924a12.4.2026.02.06.04.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 04:03:45 -0800 (PST)
Date: Fri, 6 Feb 2026 17:33:38 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 0/4] Enable ICE clock scaling
Message-ID: <aYXYmnFiFbZnVRqX@hu-arakshit-hyd.qualcomm.com>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <7b219a50-6971-4a0c-a465-418f8abd5556@oss.qualcomm.com>
 <aYBF3Geeuq2qHmYg@hu-arakshit-hyd.qualcomm.com>
 <cac8e14e-63e4-462a-a505-cd64e81b2d1d@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cac8e14e-63e4-462a-a505-cd64e81b2d1d@oss.qualcomm.com>
X-Proofpoint-GUID: 8v85dRNi8fJXgsylS9t_rLmA-lKtQvk_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA4NCBTYWx0ZWRfX2rXHM/ucN9JT
 OdNS5nkaxQazg9D/S+zsIdhJ0SBIpqQvw40L5Rj+63uFVPPqhiCi6e2kliiCirb9LYaTeuMMOAS
 FbstZKMwf1HjCAoTIesb+5F7Mb+CHyB1O5BxmDWY0ejoeDBdQddLqLtXcXSUfdzmmL67bVCQcCj
 LouyUwnjTSH2uUOWqouPO0wMiwcpsQ7/EJcCPmJYMJ8SbxKWUc58gPrvFCFb2Icko66F//Og+0l
 4Lr6F68SBl6ame86lbVgLIg/9gSJ10R6+yj8bAOP5AmtB/aJ9bVkyu6X6pCYWIFogfahrfoQWGQ
 Z2xH47iTL9T7we/VXUHjES8e3SVbMYOjDjuS2Exd+muW2lEqbNywqBRG45odb+fdchOECSn58CH
 ghLEcL20Qn+RqN737KmOrF2reG+g3JjCGs5Ol937ZjZmtn+UOvILTgMo8IDts/vz6KUNZlgB5Ba
 UW1MwI6OKe+JWlowpWQ==
X-Proofpoint-ORIG-GUID: 8v85dRNi8fJXgsylS9t_rLmA-lKtQvk_
X-Authority-Analysis: v=2.4 cv=E7TAZKdl c=1 sm=1 tr=0 ts=6985d8a3 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=LeY25DUbnqDghkOhmf8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_03,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 spamscore=0 clxscore=1015 bulkscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602060084

On Mon, Feb 02, 2026 at 04:01:38PM +0100, Konrad Dybcio wrote:
> On 2/2/26 7:36 AM, Abhinaba Rakshit wrote:
> > On Thu, Jan 29, 2026 at 01:17:51PM +0100, Konrad Dybcio wrote:
> >> On 1/28/26 9:46 AM, Abhinaba Rakshit wrote:
> >>> Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
> >>> using the OPP framework. During ICE device probe, the driver now attempts to
> >>> parse an optional OPP table from the ICE-specific device tree node to
> >>> determine minimum and maximum supported frequencies for DVFS-aware operations.
> >>> API qcom_ice_scale_clk is exposed by ICE driver and is invoked by UFS host
> >>> controller driver in response to clock scaling requests, ensuring coordination
> >>> between ICE and host controller.
> >>>
> >>> For MMC controllers that do not support clock scaling, the ICE clock frequency
> >>> is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
> >>> consistent operation.
> >>
> >> You skipped that bit, so I had to do a little digging..
> >>
> >> This paragraph sounds scary on the surface, as leaving a TURBO vote hanging
> >> would absolutely wreck the power/thermal profile of a running device,
> >> however sdhci-msm's autosuspend functions quiesce the ICE by calling
> >> qcom_ice_suspend()
> >>
> >> I think you're missing a dev_pm_opp_set(dev, NULL) or so in that function
> >> and a mirrored restore in _resume
> > 
> > Thanks for pointing this out, its an important piece which is missed.
> > We can use dev_pm_opp_set_rate(dev, 0/min_freq) in _suspend and restore the
> 
> FWIW
> 
> dev_pm_opp_set_rate(0) will drop the rpmh vote altogether and NOT
> disable the clock or change its rate
> 
> dev_pm_opp_set_rate(min_freq) will *lower* the rpmh vote and DO
> set_rate (the clock is also left on)
> 
> Konrad
>

Thanks for the info.
I guess, dev_pm_opp_set_rate(dev, 0) seems more ideal as this is
API is for full quiesce mode and the clocks are anyway gated in
the suspend call (clk_disable_unprepare).
 
Abhinaba Rakshit
