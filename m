Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E442217E473
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 13:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745415086; cv=none; b=Ilmpq8s5blF1rSNcoO6DEVD7QCTgJH1auUIkAALlI/Im4bMfm1jE0ycM/Ya1WdOpem3wEyNuE/nm33jGv/AkuZqKGAFAJ6sQQ1H1ChdNF4yd8M8j9ybBo54kT9NGGFEOHxiFn8t6NCZW6FZqyCpJL/Y0AT3LD21cqXre8S35l+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745415086; c=relaxed/simple;
	bh=YPWbosimC3qPkFIdP63gOcohPto8jVI/bjwvfdxo1T0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZosWsUWYg98wzdu/fNyvU8DTaVYYnpaxIDDsYfireBJ/MLIqB82K+Jk/EWfyQAV1gqxFiDeItzW4ttjg3eL2qxB9043Cygvc+wUV2tU6eR4uiL9vyiGJZJE9/Zz9ZuLY5U/yWEJt9jO1LzJR4u4GR15V+EL/p6+cvqnAEweekA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aRFmbBeB; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aRFmbBeB"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NAbjpD016256
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 13:31:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=dZWmP9gM06dWmEKtYYm5mxy3
	nQnWFD6fy7umPVrKHi0=; b=aRFmbBeByAGZvNocZKi/oi6Wq9yS71NB7meeiNC5
	6VkTz4uk1rAlDwQDYkckfe+r/03dNhtgy7dh+2+Iin9RD7qbRHx4v3mwbz8Ow97h
	ejZTDBqmtXWtDK+WEkkHf15QK+jfNOnAAQXhFkEjaaxpfGWCEyay7Mt/FAf72jw0
	F3IeOZ8obV2qKlRVtyVqR5wLUIBRsGu+Q26lSN1UbKtQkAYB9rBL2DwdnrGHAgnc
	hTIHQdArOuO3M5xjZ5odE/21yDszB7JUx3h2mWIQSALFgyWOlqgUKlB804XHgytT
	avZVqKi6iPhVByNXlcHdavlosu/o2JgNgovILUgMNI6MHA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jh3j848-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 13:31:21 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c790dc38b4so188779885a.0
        for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 06:31:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745415080; x=1746019880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dZWmP9gM06dWmEKtYYm5mxy3nQnWFD6fy7umPVrKHi0=;
        b=dbOpZ2XpencEt8UZqOsVRpALhKIvShU0STEDjo1bxQPpCLeq8VTwh+4wWdNP03eID1
         dcQgYyj6EhFuEIuLgy8P+ZEmx6zuW3XutjU8VbT6CDWRYv12Ze6zdFeI79ukf4YUsMdq
         v01650dDAe0d+oMvJjBWxxh/hQwMXlyqsEv+Xw8tYO2LFAYJ4PgJxQyqzrSlZJkKLqZ5
         arzR4a2/aBcndjPlcJmg6iuBg2aZ/p6o3uYt9NItr1+uDFxmEkiPZWuWwww/FL/W1WT4
         eAOW8MPQj7+d85eBJQ37mfGqeDun1mvKQ65fMhoJgsGmVplu7SU/2tNIayiXM2WCuR8z
         7YRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnagY5tv4DEMiM5+rqDCZEQzJD15i0gMK+AMnV8NvracZ6ei/A3lp1t+p45991CDPop7gkM5kiDRDf@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrt4OrOvsMBG2tB9Oa3amxcCOFtM+dtZmKB+hLMwUzqCq+7zKw
	GbYuye6vOw44MgFKwdHQTedTVmYMm4fnU538LSJ1xR9I84EUZObhFplVw6RgG8v9Igo1Erb1t01
	DViYWR4YYoq5EP4XIPnE4NRcW0KOSuk4XtchhTy8Mm0dOlK/vUKWz/lk7Tzy+
X-Gm-Gg: ASbGncuXkauq5obDukxm4Rb4wAqxTY1reXUtrZEWg0pVGsy3JILJXRVwM7MB1aXmCBk
	GvyOCSPt/3tK02guKGR7aFwtKywued8WnLoT7HwJrCuxqpVJtussUUjS4YeKjtpzWXwMhE1v7sg
	mjFDoEOSJnFYT/k0x82ou4d7//xwokKixgqchKJvq43/ERdj6OnlLyXilFeUPx6yOkpmFN4/dPP
	yS2x/lhKdm02WKWoogxNmP36deYJYFhK75Ypje+mY/4AtN3l3jpSAqwlvSqZ4+cb8domTuaaH8s
	WShEkCeA1a1hkN8MbwF7a4PkKmbtPkMTBwh1EvodiKId1nmmCwdKVDIf4OB0k7cn1kM2Ccg18hg
	=
X-Received: by 2002:a05:620a:24c5:b0:7c3:dd2d:c0e2 with SMTP id af79cd13be357-7c94d83dee5mr484772385a.13.1745415080696;
        Wed, 23 Apr 2025 06:31:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpfJbI+AgBKtKkvkNrS86sfl4ggqkejOcLK4vPJLKCGSN66njI9kIk5rDo+YJT0RY1DWgIxg==
X-Received: by 2002:a05:620a:24c5:b0:7c3:dd2d:c0e2 with SMTP id af79cd13be357-7c94d83dee5mr484758485a.13.1745415079978;
        Wed, 23 Apr 2025 06:31:19 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54d6e5f61afsm1578477e87.246.2025.04.23.06.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 06:31:18 -0700 (PDT)
Date: Wed, 23 Apr 2025 16:31:16 +0300
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
Subject: Re: [PATCH 29/33] firmware: qcom: tzmem: disable sm7150 platform
Message-ID: <3skwipkunn6dw4xtzyx4vdiqiwtu2qgezbel3vcu5k4cxk65yi@csi6xun5nlyj>
References: <20250422213137.80366-1-danila@jiaxyga.com>
 <20250422213137.80366-13-danila@jiaxyga.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422213137.80366-13-danila@jiaxyga.com>
X-Proofpoint-ORIG-GUID: z3GfnhvY1HXtC1-qYOJqBZmaNb7UAHhP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA5NSBTYWx0ZWRfX6zs3pIQO9WxT oDgjDXMK+IBVvhqvRiompCkRwNf95Gn+j8eCQw8yUNHexya3aitzlqxJUE0mHhbpLozKNV1Myj2 6AuMiQ1g/w8Zxchs1rmjYzdvGvJL+Ax7KSTZIsQsaAAcVW3S5XemKR7o4SvRmuY5lJP8063qsJi
 tW6QurUq8hr+4OEadw7Q38ZTZ0mHYuxjxNkXG4TgukkN97iM9NIRSNAZg1tYE2M+P/qxOm050MV AhffBYfQQPPcoO3bJPtPYebn4WZiS1qwGdUfWcbFM7TZi1KZ/sLXnN4ehtHOaRzET1Qcdly9rbp /L3KvLD0BKZwHgxA5aOfmquQePtHred5TVtfz5fT7qyv+Z9BUOaG3FA2rqSybkaC3JHUcqPXnpX
 yYj1VibAvVzSoM37S1ScCnZG10cWzRkuEE5HomAWb3J7FvuqGI4DsAZfIvZZi1L29W+5aUWa
X-Authority-Analysis: v=2.4 cv=ELgG00ZC c=1 sm=1 tr=0 ts=6808eba9 cx=c_pps a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=XR8D0OoHHMoA:10 a=7ibcVnAUAAAA:8 a=EUspDBNiAAAA:8 a=UlxMoeSB6LsTFmt9i7YA:9 a=CjuIK1q_8ugA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=HywIFdX19-EX8Ph82vJO:22
X-Proofpoint-GUID: z3GfnhvY1HXtC1-qYOJqBZmaNb7UAHhP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-23_08,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=875 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504230095

On Wed, Apr 23, 2025 at 12:31:33AM +0300, Danila Tikhonov wrote:
> The SHM bridge makes the SM7150 devices reset while probing the RMTFS
> (in qcom_scm_assign_mem()). Blacklist the SHM Bridge on corresponding
> platforms using SoC-level compat string.
> 
> Signed-off-by: Danila Tikhonov <danila@jiaxyga.com>
> ---
>  drivers/firmware/qcom/qcom_tzmem.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

-- 
With best wishes
Dmitry
