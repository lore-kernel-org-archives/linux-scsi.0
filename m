Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000F8146A60
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 13:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745415042; cv=none; b=udZ345H/6dcZCO7+57iGt8siJT+Vxlh50H3bgCbI69Ys2UE94VPg0JDfRSboC+yf3XZ+qT2GZPAcak5s4FBpD9onAge+B2zdwnVXzTc33DepAdX4gJbCwB/TYGe8+YmE9ZfLp/0Kfra0Rjpur0Vd8BTvF7BoogTU59nLepCER+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745415042; c=relaxed/simple;
	bh=WKYV1t5SeWLAIvo4ur1wBfNb7+r/gkkLurn3pxPhYaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uzSiKYlPEEUonBrKnUBy7DgU5F4/fLSTKZaAaxweIpSHNOQIzUyiadvYfam1BCfeFzmMhddrcCwZaIWy21Vvzt3AQDwSXRUQNV+Sz/yzhasKBbrGYJ1tvp79sm8NDohX+YW/0y5qUGjCJQuxIFxE7Y2ueQ/jB8M3U8T1UtFTzG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cMs/EHWK; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cMs/EHWK"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NAfuRe021519
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 13:30:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=WbGQoV5TtWkaVGbUVN+WB0tm
	HemlYXyNkVd6UejF+r4=; b=cMs/EHWKfrAVRpO315acQbgZZJrzBxOlSGiIOMx9
	zwT6LIfesMxaap/QlbAfHn9MOEpnI0fRVwmxA4oyMrlws4IWwmii8eJ8i3ioCYtR
	bCdeaFMKpfQhh4Jc2CIWxvAda6zIw7ph9ud54R262WevDmyWjR4Asu9QKasd9UH+
	SdbCiI1VD5rM93gtiGwPgSaIx9azBicbu9aGd1zBPRLqrVmpPKYDx7QCElEmQaWO
	RIOCuQ3F8Bnb8HBTLqNL3juAHUqf5V7GEu0g6MkQqEp17NbnWznTx3FbsX/hBr6f
	gXq5Hrx5qouoGpzNHL6a2llVUK1gikagyits7xD3HpNiWA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jh228vu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 13:30:39 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c5e2872e57so1033908785a.0
        for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 06:30:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745415035; x=1746019835;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WbGQoV5TtWkaVGbUVN+WB0tmHemlYXyNkVd6UejF+r4=;
        b=eq4FRwBIbxHYlxc/vpahahtnQYhBKxh80OwG2iMPVbJw0zX0Gq6OoHP9J27tcge7q0
         KdhLvZsifiUG3deF7BLS6GdJME1F7CrNt2q0RZmG48ffhLNx20CY+pZV+O/GzMRRXo0V
         bXTPnheOqMs1LzV6RUp1qhet/iNPR9HpTCD926G7v4y475vXyEbJ/qH2BOG2MDU9Foh0
         GnQ9WOfz4V5mzQNOKHU1sIOxbN3/9/tvWCtVJjoE3Ut+n2aePrWgGCI2hXsbW/4rvRQv
         WCeBzCBBeuTRRh0vjQPrPJF8xmktZZTdZBoP+WoOG3LX4Wae1ZowSrd8tNLXiTvirEFS
         GLOA==
X-Forwarded-Encrypted: i=1; AJvYcCWPvafkxkUFByUtOmr7Gbtzsnse9ZKSQGCTSX2dXWlXMk/Oy+Dz4xHOcDFDLk6tWBd1KZOa0tE11ohF@vger.kernel.org
X-Gm-Message-State: AOJu0YyMqAXpaGbFdbLOmfNVpdpCFo11Me6+EJ6Xng5zXMpSFwIOUy82
	w9nTqhLMRo6lv3DqmR/ypFhBb3qgB22GnVoaa/HOSPA2fnmUnuG44v7hcMmEEKyDMdtnsHsCx1j
	no4vxEfgB9THM9hP+zmXzSYqQgMqEDRCKLucUZHzisNc1CpGuE9PByc3sC7ME
X-Gm-Gg: ASbGncsruTe5Z3+cAAmYxnKV7etnPS6XKaiR9kkae3kCd1y9wpsD1gip0oC+r6VfZfh
	88JeAU7vu3weqsdAjuR5RYrXKg58I0kAPvA1oHDEjIeZb4NbsG8wkKmkTNulagvZlDOx19ZpW8j
	9eIv7+HmVA8afY7Laql9Z6JU0qzzXliYK0IuhTyxLMtxadHcXNOmiEq77h6xWvGPG6nOVeHY0pB
	fYteKtg65gYYWX6Z+fbJ1hx/cpNbDjAj4cRF247SH9yS6sW83MLirhQFZm6USVb2DZruSiU252R
	+uuCzmeaNyvYSXefR4Ed3zTbEbICMYxIrOlQI6WKHITVxtzIan39yILfyKH3075jm/EwTOxoA6Q
	=
X-Received: by 2002:a05:620a:370d:b0:7c5:5670:bd75 with SMTP id af79cd13be357-7c928038eadmr3337069885a.46.1745415035090;
        Wed, 23 Apr 2025 06:30:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXTfpWsbVAbU0ylBQYL51RHYlyc+81kcBQZEj2nboNhovZTX2+cu6ODjDZ2xy1hvKkUJMoaw==
X-Received: by 2002:a05:620a:370d:b0:7c5:5670:bd75 with SMTP id af79cd13be357-7c928038eadmr3337049985a.46.1745415034096;
        Wed, 23 Apr 2025 06:30:34 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54d6e5cf767sm1524502e87.129.2025.04.23.06.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 06:30:33 -0700 (PDT)
Date: Wed, 23 Apr 2025 16:30:31 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Danila Tikhonov <danila@jiaxyga.com>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Rajendra Nayak <quic_rjendra@quicinc.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wesley Cheng <quic_wcheng@quicinc.com>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Souradeep Chowdhury <quic_schowdhu@quicinc.com>,
        Lee Jones <lee@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Alex Elder <elder@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Andy Gross <agross@kernel.org>,
        Srinivas Kandagatla <srini@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Georgi Djakov <djakov@kernel.org>,
        Loic Poulain <loic.poulain@oss.qualcomm.com>,
        Robert Foss <rfoss@kernel.org>, Andi Shyti <andi.shyti@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Taniya Das <quic_tdas@quicinc.com>,
        Sibi Sankar <quic_sibis@quicinc.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Imran Shaik <quic_imrashai@quicinc.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Jessica Zhang <quic_jesszhan@quicinc.com>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>, Kees Cook <kees@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "Guilherme G . Piccoli" <gpiccoli@igalia.com>,
        David Wronek <david@mainlining.org>,
        Jens Reidel <adrian@mainlining.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-remoteproc@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-hardening@vger.kernel.org,
        linux@mainlining.org, ~postmarketos/upstreaming@lists.sr.ht
Subject: Re: [PATCH 27/33] soc: qcom: pd-mapper: Add support for SM7150
Message-ID: <wi6azppohttfttjniktjsovstktalut6uhnxiiwekvqtjsw5gu@nstvkc7pv5bs>
References: <20250422213137.80366-1-danila@jiaxyga.com>
 <20250422213137.80366-11-danila@jiaxyga.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422213137.80366-11-danila@jiaxyga.com>
X-Authority-Analysis: v=2.4 cv=EtLSrTcA c=1 sm=1 tr=0 ts=6808eb7f cx=c_pps a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=XR8D0OoHHMoA:10 a=OuZLqq7tAAAA:8 a=7ibcVnAUAAAA:8 a=EUspDBNiAAAA:8 a=JQ2_29xaah9frsLSoU4A:9 a=CjuIK1q_8ugA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=AKGiAy9iJ-JzxKVHQNES:22 a=HywIFdX19-EX8Ph82vJO:22
X-Proofpoint-GUID: CqVJMfRk990SR6azBTO8V_9o6Xy0eaLL
X-Proofpoint-ORIG-GUID: CqVJMfRk990SR6azBTO8V_9o6Xy0eaLL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA5NSBTYWx0ZWRfX5YqK+sKbKOW+ MFUACgqMNygstiv/fwsop6OAVVXlafZjHh1f43Ys9J4CcZQkyZ2OOViIVTj2kjDoUdBMOesWsuu I0PW4K6OcorsFiEXu1AUP8lz4UR7hXFtfyci2QB/DQP1YQY6f/xrPvM9UjSMYp+nHTm+nAHUBPv
 pt4/Kp2utAvDn3B5c+1M7VUJ21edJBFEyaUUNK6jcKbhDFtlhQkUd0pgSuFXvSOjmxKTy/a1bcd CIUz7Lk1enpYCzgl6m36/GuGhORSIA11XbO16R3UZfUduPDNBWqK9XX/bSFqekw7jEE/V8gMcDW fVo07tVF3ZTRUOOAJ6DK9/LeOnjJeuotWW0ZIdIfjy2WatGocZ407bc0Ipr79FeDxlmEueTkFDA
 NJZuhdvVkL6DiDkdV0R9QIOoSl42oVO+gdCcgauSurDLg1tLN3DDnD0IOlkY4ivrBTfujJfS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-23_08,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 spamscore=0 mlxlogscore=835
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504230095

On Wed, Apr 23, 2025 at 12:31:31AM +0300, Danila Tikhonov wrote:
> From: Jens Reidel <adrian@mainlining.org>
> 
> SM7150 protection domains are the same as SC7180, with the subtle
> difference that SM7150 has a CDSP.
> 
> Signed-off-by: Jens Reidel <adrian@mainlining.org>
> Signed-off-by: Danila Tikhonov <danila@jiaxyga.com>
> ---
>  drivers/soc/qcom/qcom_pd_mapper.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> 

-- 
With best wishes
Dmitry
