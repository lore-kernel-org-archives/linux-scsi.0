Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB4F3A5E8F
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 18:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775240099; cv=none; b=epPRaLpBXFkW+myL2Lkd5ILn+o6NlNdUMs9jSUYKJmtc0CvchIAhtDTM/qZ9Yuti30Q+4NbkPKK1KSam205pvYNrqXxpUDFFk0uSl/V9E/MIETOiho9riGJGgRV5mf1DWMAvadJBjl1ZufPqkVqmbVQkg6s2ZbP49izPFljqzv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775240099; c=relaxed/simple;
	bh=NSDlO7P8GT2uL0RUBWckhyg8j1c54WcUGo+OSmr/9X4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RFzmly58RvFOo54N99g3SLJjBb/l2wGnvNGd6YL1AyFVKIRktVkIXihHGBABJ9ApKHd+7PLfcgmE5ylAsiVqxnhu7xZfxRbwiH2AG2QDlKLglRFXq9Ikdqlvpnax7/Zi8CUdCs1UxJDa/p3g3lcY+wz4PTqliH1vrr0SIcqLtAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NUeCRTJB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XfCsXv7M; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NUeCRTJB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XfCsXv7M"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 633B1eEe1453490
	for <linux-scsi@vger.kernel.org>; Fri, 3 Apr 2026 18:14:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8eq4fAPdzfCHluO00XoTQB0jQyUIHHbRnBpp5SfKGF8=; b=NUeCRTJBwDqgy/ww
	RMPKFTAjW382xf2KqarMzVJkfOhcSTO/ZTAeLb5+UFvLyBvHzpZ5UnYaG7SM+kHm
	uCmbT1FBLPY+dt5/8MXEzS2E/GJl7fSHmuvMsURT9wscL1AUeR2qpinDhu7uJ7jC
	4e1Ka4gIAJrZVfW9X2G5KKZiun+qLJXa8lz6/C1hT6mv4+o0Bq2+QipIHozHM5iL
	/LOsJ+uKKNErgA9kYqoeF7j0wMVFxFxzkheiyTTbE3Kozek3sIDdPknWEdDJPWqF
	uyNMI3i+2SoOWEj9Hcpq5+UvQMCgHe0DSL6ZBXBpQvHpcN9Swd6OAq9RlzJX8T6T
	qhHAuA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dacam96qm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2026 18:14:57 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b23c909256so31245295ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2026 11:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775240096; x=1775844896; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8eq4fAPdzfCHluO00XoTQB0jQyUIHHbRnBpp5SfKGF8=;
        b=XfCsXv7MG8jc7IV84/ejK39WQZbNH16D9HNT4RxqF/DeJviqurB6jaKQVI+Q2yakIt
         x9yOObPLJdm8KI+69BtywbSQ33o1MHGMKqn9ZFDG1Ew5ffq3mWFNW1g71/aRnadqTEpp
         jFbWJnik0n7Ff3+HkIvH8U3gd3dGtqrrQbS/pJsf8LY7yZ6gc6Ykorqc4OBERyRWdAug
         Xdx01ycQw2A9LEPwTfIk5iICiXvxa7P+dbz3w6cSl+1babfC8vpA6xCDuhIKiKrW7s2g
         cCOnAAocXtKO4Fy1ktnrlhhIsTXJrywwCEu+QD8iPS+Io7UzXQCZu2Eh8I6C+UNzkPDy
         ZMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775240096; x=1775844896;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8eq4fAPdzfCHluO00XoTQB0jQyUIHHbRnBpp5SfKGF8=;
        b=NwT3ymXJKWJ9Y6vgri0pjUrg6i30sLd3EPGx8coFj06M/ebt0IKq9osgZg16ckfrx3
         ZyPpuvDUtoXRZXTLlcZk4XuextA/YJ/cQUwd0jLv9lDftpsg70Au2hK+QoJ9oGvDpxvX
         vxZo7j3IE9Upym3bwmUvW2Hm4qoc9MHnOwQYIkYkRfJiXbeeBHNEvG9UW0HVY5czX4mE
         Tcft1YFRE0HTmFaJ0y4k9L0/xLjML2MiodiGkNCzFZYAebL70znOjMZ0DOWXDexm32+f
         +fy/DCQfE2VO/aeKUHNN3ZdtViUS9Kbq+BzpQsxnnOtpq6nuIbqpIU1DYEokLfZI4XHo
         RpGw==
X-Forwarded-Encrypted: i=1; AJvYcCV6UJBqyECBIHwEZK0sOsdMm4vALog0EHpuA8ZrlcOznBjBQNUsJcdej2qsX72Oug/QTHBL+FZZbe1e@vger.kernel.org
X-Gm-Message-State: AOJu0YxGEMeFoqjp11p698Db262Mforx2DNWk4IqTQ+viiLCmCAceE35
	RxZKm/o41PE4FKCJgSFGJ93CsX612iPN/TN2jS2jlbQKQhjJptxb5cxtv1rH3HX2qPJKuKJfDOl
	4t1tPG9Np1lGZ5kCaZbX0t5yujNdWroPDShFmzRnY58M2Ns7nKFoR75Ctm6C69H/+
X-Gm-Gg: AeBDievaRu455MRmdU3Le1V2ViQy1jU29PFIPFx//GHlv9WOwlfe/JJCDzVKQEOYZM6
	tBTxNgeb1W6Inv2NC73aWlql5LbpIsKr33x1Boddc6/XvNjZc5SCwRcy5aRHzUSeQQKyeZWSb6E
	7O9+mc4HiVkyhZ6cxRBIT/5dDuvuuZFA7fXvIjTqDz6nh6qxQ403D14wNSFkm8RybmJ5Wi7K9UY
	4b1AcCJ5T5dv8lH+7ad8XCunpdEbytEK8INXzUGrMf5RJUw+WJzXWLghLZxFaHxzOlYhEM1L4Cz
	8MtLjSYT0V2FZENghsbKK7YtMYKlzroEEHmaxf2fHwYRYkytRQw/n9HOqnPj2+ICE6kGT4REhMx
	y075Cqg+SM/P5D/+bIaFqC9X2iNhRtchvR7qrWJhc6IjV2MJ8LpRfjd0VRg8=
X-Received: by 2002:a17:903:360c:b0:2b0:6df2:8cd8 with SMTP id d9443c01a7336-2b2817d3f7bmr40518035ad.40.1775240096386;
        Fri, 03 Apr 2026 11:14:56 -0700 (PDT)
X-Received: by 2002:a17:903:360c:b0:2b0:6df2:8cd8 with SMTP id d9443c01a7336-2b2817d3f7bmr40517825ad.40.1775240095763;
        Fri, 03 Apr 2026 11:14:55 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27472d1a2sm67923515ad.7.2026.04.03.11.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 11:14:55 -0700 (PDT)
Date: Fri, 3 Apr 2026 23:44:48 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v7 3/3] soc: qcom: ice: Set ICE clk to TURBO on probe
Message-ID: <adADmJBEzIBamX91@hu-arakshit-hyd.qualcomm.com>
References: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
 <20260302-enable-ufs-ice-clock-scaling-v7-3-669b96ecadd8@oss.qualcomm.com>
 <acF0ggIIJFb7mUUR@hu-arakshit-hyd.qualcomm.com>
 <90375d37-0440-48d9-a3d3-b0b442839d89@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <90375d37-0440-48d9-a3d3-b0b442839d89@oss.qualcomm.com>
X-Proofpoint-GUID: 0p3Od8icZewFd1lC59ymQ4d1OSQYfN0r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDE2MiBTYWx0ZWRfXyehBej3n7ve8
 Kq5gtVnU7xLN2rttLS62JhdIeIKraYN6983ec+CsF8g+agM8geAFqB5SYjUoLPsgS6pJY4HR0RP
 Izy9yDGwQX7gNVssv/OO/ceBnq0gNeyvMe05EYyAWD3n8CQmuZfFjgm4aCy3VI9PSExkc1M0Ipl
 GFK4CSDy2NIZenyr0CwNHRFIop1zAnBaGukDzcBeghX83RYF7booYYrCwWNL4bs6FYpv9P4LYmH
 Qf0nVpBg7KkQeotZbN9stGcB6NZM9k+9DbWfbu+bHMs7HKJgm1V/M3Sq+I8Ht3JrPwfWAxuMt5O
 oXwBEyzW6OhGY2OvvsAZZDGGtYmGANhEwbo7yXAb8aWRVShTkIhbs0MuDDFRcUu4A24S1ynFGLv
 rOWcZwMWFUWT8EwKDBAKeyOrMDDrq2C95RyGGEOq2Ve2GLiQ71sBzkk9AID7B9hHTW09NClqzpk
 CTRAAJc6Fub7U3PcOgw==
X-Proofpoint-ORIG-GUID: 0p3Od8icZewFd1lC59ymQ4d1OSQYfN0r
X-Authority-Analysis: v=2.4 cv=ULXQ3Sfy c=1 sm=1 tr=0 ts=69d003a1 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=y-8eonv6uMWv_09NrVoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-03_05,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 clxscore=1015 spamscore=0
 phishscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604030162

On Mon, Mar 30, 2026 at 08:14:13PM +0530, Harshal Dev wrote:
> >> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> >> index 7976a18d9a4cda1ad6b62b66ce011e244d0f6856..e8ee02a709574afa4ebb8e4395a8d899bf1d4976 100644
> >> --- a/drivers/soc/qcom/ice.c
> >> +++ b/drivers/soc/qcom/ice.c
> >> @@ -659,6 +659,13 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
> >>  			dev_info(dev, "ICE OPP table is not registered, please update your DT\n");
> >>  	}
> >>  
> >> +	if (engine->has_opp) {
> >> +		/* Vote for maximum clock rate for maximum performance */
> >> +		err = dev_pm_opp_set_rate(dev, INT_MAX);
> >> +		if (err)
> >> +			dev_warn(dev, "Failed boosting the ICE clk to TURBO\n");
> >> +	}
> >> +
> >>  	engine->core_clk_freq = clk_get_rate(engine->core_clk);
> >>  	if (!qcom_ice_check_supported(engine))
> >>  		return ERR_PTR(-EOPNOTSUPP);
> > 
> > Hi Konrad
> > 
> > Since you previously reviewed this change, I wanted to share an improved approach
> > that I recently realized for handling ICE clock scaling in the MMC use‑case.
> > 
> > So far, we have been voting for the maximum frequency during the ICE device probe
> > to align with MMC requirements.
> > But because the ICE probe is common across different storage clients, applying
> > the MAX vote at probe time may unintentionally impact other storage paths.
> > 
> > Now that we have a generic scaling API exposed, we can make this logic
> > MMC‑specific instead. In particular, within sdhci_msm_ice_init().
> > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/drivers/mmc/host/sdhci-msm.c#n1966,
> > we can invoke: qcom_ice_scale_clk(ice, INT_MAX, false);
> >
> 
> I agree, this is better instead of blindly turning the clk freq to maximum.
> 
> I was about to ask you to move this to qcom_ice_probe() as per comments in previous
> commit. However, since you have mentioned this now, I suggest adding a call in
> sdhci_msm_ice_init() to qcom_ice_clk_scale() immediately after it calls qcom_ice_create().

Sure, thanks.
Will update it in patchset v8.

Abinaba Rakshit
