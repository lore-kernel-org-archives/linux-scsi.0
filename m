Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794424959;
	b=o576ov3wE6NE5VtA6/QEVazlRPD3suF8cah2bzNcEoRuyspBWbRFRHefWu02b2lpF8xG
	 WYIZDq9NRlIZGlnADqUxvQWrMF4Vyq59RwTDSWlQRC47sSpECrcFfXXLodiu+4/PaiTaq
	 F5mCPNK2SwBzU8Y/VvV1VwfVEdnjd4qBOmizpmkaNoOQmKzUdq/o8wvftNfwegTHyCv9F
	 CzHC35lv18ORGy6uB6QLggL4x1kErajhsC+bc9U3zW3sV/E+RJrvlAot5/DvWRw6OGmBK
	 wxkGvHG83W2UocPqRu2XUSqo4f3ENQAzsznjn6d7I4EljaQKTkGcDu3UZE//ee/s8jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794424959;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=ReekrPpGktMFuSDQYs4o53/ZO85RZPgLvI6NpbtxPhc=;
	b=JN0i3nxvZsmfjpVZSehBBTkLRcAEN5aOMbw/hH+zkieSPsk9q9pqsImbpYAbWqHcdci/
	 JUzl7Req5qnUiiI+5owJW5qqeWe8rnq2kmTEhTTNGtUVwoQDygVxiBCy+F5bgUHKV+A9l
	 f+NnGKxTURLJy8LRKmoEpqQKI2m6rtZ0bTY9/zLxEvLMbgpmWnlh+Zu/O1acQPBSkYxFi
	 IgE7RWkBSsIXEEElYOvh84CRdc5atS2esIcyzqosmHcCeiJHrDMU3lM8+s2jgXtfo+vKI
	 D8lIqkm7TvhATW+qz3stRDgepu4sJLErAJoYZv8XZoSyprlPeemO3TnkNrAWSe8Huvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=a6cnb6rt;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Bcsk+ogP;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EDF606A32A
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 19:22:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3EDF606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=a6cnb6rt;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Bcsk+ogP
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABIp5AF1141750
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 19:22:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ReekrPpGktMFuSDQYs4o53/ZO85RZPgLvI6NpbtxPhc=; b=a6cnb6rtjgtl9v5k
	zwR8A7DkvUbAkut5S7wJvi8kO4xkz7knxYDT1LfMk8y33eE4Ip1dh0ufrudEFW7S
	UEAgl/+waZYamYSv/1vNP87MnWieZVH6sJHzayXjf81wM3SyuP8hF/OXnF3GtfgV
	c6RUbaupg9tfyaPFjJFVO3eN0TCuuo2XD8WGZo2YekeSEQc9IehNGDaHD3gzF0Kf
	nBEkl4zkEvaLE4/emMURa3So9/KiwroM2gkPwUm4oUVUIlk49vQl6RMVuuXQdr/Q
	LT4EgY/TAIimtftkQavM+XsX6SB/JZ+vxoehs89OUisn05V2iC7S0NElPjjf/Lw8
	NI9ReA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvpjjta83-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 19:22:37 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-36f26e6abe9so5301568eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 11:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794424956; x=1795029756; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ReekrPpGktMFuSDQYs4o53/ZO85RZPgLvI6NpbtxPhc=;
        b=Bcsk+ogPcLGsWWSpFpv0eCRKYpYWl7WHrlDhu6DeXQpi6y9wlxkFaez2xxLrwBVvwj
         wRGg0jIg4nWyti8wlhlwwEZE4yScWgv2oU4xVhfrg/HoUjaAhuV8ZdkScqvaLIr9lA9J
         Ziuvvb1t1zbj7ScuMaJt5uipvQKudHhNdONNDr6+qagJ56l4lnOegkxR/SCg+aum/OYh
         PznXbmam2/XqHIXW73uEDeVp+BTWJLiSX8BP3IboFh4zNsvEhNB2zPyEGgn5AvZrujFI
         pxHhlXWBaR6Ha7T+ku9lGm9i/E3uXxisdSBDxeHBV2Nx0yLd55TUFPXGdyOe7uYAWUwY
         KHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794424956; x=1795029756;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ReekrPpGktMFuSDQYs4o53/ZO85RZPgLvI6NpbtxPhc=;
        b=VbYnSQCL6dxh8cUd6Nazxqorjrg6y+tIuCOGO5nZMDLTOZYZkPNo2vS5dnOBEFnmLE
         vVCP/G/WyYClMnHAgL1zD6ZFJR6me0ihZTV1k2h+QHlk2l3Ao1rwgWNl3CbW3Xxv+gAB
         KSHZaeKOoB3MKM6tg67xlxZzEQZgWuIjTLHKd1FDLGzsxVaM6WtcAX7XB4lZXNQzM6Dz
         NUCrGvnpx94V9UgeNuAFOnqi3rr52JY6ac0chsRbhC/Q/NI9W62bUR1KU+pptZ1WOBdM
         bIpzD4YYC6+Iu7wQFdHF9zBUDc9ZLO45v43yF0OCOQabSmqF5FOcrdcngG0+gZFJWxNK
         b4NA==
X-Forwarded-Encrypted: i=1; AL+hErEgEWYrGDQMt6nrziXsqorkLsTgeEJdw+sh3IduWy8ATzL6ZMur0glrqPokfgKSjwwBG3OWF0dFjoyy@vger.kernel.org
X-Gm-Message-State: APuU4Z8yPAxQ1q5YWx30NuWZ3HqSgDfT0oawBADfEHadNzpFf/xYOb8m
	UU8AFebQQc2jR9Gu2A35RwpKe2BCIy7Nj8aCG/4bE2PAhEl6xklMH40nrP1odCI3aCL+cIB2IZQ
	UQ4X30lXR4T5F1e5uZGwmJNZSsqzFp+i2i1qzwefJx6DDedhvIi8vcYN2w/907Vtx
X-Gm-Gg: AYBFou2EVrKTLjFX1YjRO3pF1av9rGrgBWi2qig9G8Kn64mD/DbVexhDqvOTFqcWG8f
	dlY1np+2Vxw4khpDOVyFPR1rmz93QEBvNKUpKkimTth+iln06VIp5wgLz3/gAxhOGtwMFXhmCoj
	Lg+QrxzTnqFkbKmX/TDDUOyFEuRZY9vTvw9QUi7cxC808D5Fq32P4spwm5Ma8OhdhGyQS/SckYo
	CAzdEpc7GmdSPw+mkuWvzkBsUHfvfpECbnvWvU0McL47EJtA6jLIHM6kISOc+fYvD5LdYVLosFG
	eH66DPx3fTv3ayLAgBEAAPhAxxEYjZhNm8XgplIji2M6BYiFXRNAYPpH/VaOQadW6VMGQhkDAeb
	DGykbPnEHTaa9AGMOJch1uXSPtCIVo9i5+qdCP6jfe/PrANU7U1GYY+FiPnDTS5JeyWz+KPs1l6
	f/GjwU0xqqKTI=
X-Received: by 2002:a05:693c:87c4:10b0:36f:9d8:4a33 with SMTP id 5a478bee46e88-376867551b7mr3870116eec.31.1794424956329;
        Wed, 11 Nov 2026 11:22:36 -0800 (PST)
X-Received: by 2002:a05:693c:87c4:10b0:36f:9d8:4a33 with SMTP id 5a478bee46e88-376867551b7mr3870085eec.31.1794424955755;
        Wed, 11 Nov 2026 11:22:35 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520512ec1sm17793328eec.12.2026.11.11.11.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 11:22:35 -0800 (PST)
Date: Thu, 12 Nov 2026 00:52:27 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v12 0/6] Enable ICE clock scaling
Message-ID: <avTAcw+DZtJ7bSTG@hu-arakshit-hyd.qualcomm.com>
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3NyBTYWx0ZWRfXyIg+mOkq2m69
 oWYgN+epII/3MsSZoMSQTNaMJb0+Bjje5kVKYH8maGiFlUUAEE1N4AMRln4wq+6Wi9UcA5iPlKI
 BWofpi330Vqi4RjkZgpVa/pd5rxcXuOLx8UTlFGTGSdJG+C1Mxl0hlPFI48CWfYEa7PtPShrHsf
 a586R1dJmTgw1khWnKzHQDw0k7Nhudkx8rdtHZxpiATN1zQX4v/lkS8P/fSmY7jvek9pP182RP2
 EVot36piHiTThEnO5JvQwzM65eZN7BhoKgHhBMt831QtW81INUJ7CXzWMr7cosHD1aobCMHbW7D
 6jxgAh1ARZsp6PMH8GIQRmxw/4uJWGtMritTEI3rt4tkCDvp2KUy7ZDy+p6fQyh3utQjVXhd7B9
 HArelyzwfYU4JQFkg1MQS7aWj2mL67V9Xh/LjXowHumz3rf8hH3kvd6kLUozdGaARheW/5pzSBN
 heqdWNiFwlFx+SiwTAg==
X-Proofpoint-ORIG-GUID: CKGWsAcJPJYSqw8be65qgC-93TOsWR0H
X-Authority-Analysis: v=2.4 cv=FeuiV5+6 c=1 sm=1 tr=0 ts=6af4c07d cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=FeIq2xlXlOKQ0BwA5tkA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: CKGWsAcJPJYSqw8be65qgC-93TOsWR0H
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3NyBTYWx0ZWRfXy1dpvMJarPn6
 GCQ/tUzPkQESLormoDN4aya+VJOGJS+7OFXVMDbxgPBPeEH0eHy2H5BXmKpfaIK6UW0pI4te3z+
 sP7h44Sl2ij0MQz5Q93S3Uw2qkrUQZY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_05,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611110077

On Mon, Aug 24, 2026 at 01:17:37AM +0530, Abhinaba Rakshit wrote:
> Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
> using the OPP framework. During ICE device probe, the driver now attempts to
> parse an optional OPP table from the ICE-specific device tree node for 
> DVFS-aware operations. API qcom_ice_scale_clk is exposed by ICE driver
> and is invoked by UFS host controller driver in response to clock scaling
> requests, ensuring coordination between ICE and host controller.
> 
> For MMC controllers that do not support clock scaling, the ICE clock frequency
> is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
> consistent operation.
> 
> Dynamic clock scaling based on OPP tables enables better power-performance
> trade-offs. By adjusting ICE clock frequencies according to workload and power
> constraints, the system can achieve higher throughput when needed and 
> reduce power consumption during idle or low-load conditions.
> 
> The OPP table remains optional, absence of the table will not cause
> probe failure. However, in the absence of an OPP table, ICE clocks will
> remain at their default rates, which may limit performance under
> high-load scenarios or prevent performance optimizations during idle periods.
> 
> Testing:
> * dtbs_check
> * Validated on Rb3Gen2, qcs8300-ride-sx and LeMans-evk
> 
> Merge Order and Dependencies
> ============================
> 
> Patch 2 is dependent on patch 1 for the qcom_ice_scale_clk() API to be available.
> Patch 3 is dependent on patch 1 for the qcom_ice_scale_clk() API to be available.
> 
> Due to dependency, all patches should go through Qcom SoC tree.
> 
> This patchset supersedes earlier ICE clock scaling series (v1–v11) with updated dependencies.
> Hence, this patchset also *Depends-On* the following patchseries:
> 
> [1] Enable sdhc inline crypto engine for kodiak and monaco
>     https://lore.kernel.org/all/20260707-ice_emmc_support-v9-0-701c86f3c25b@oss.qualcomm.com/
> 
> Similar to patchset v11, patchset v12 is rebased on top of latest changes picked onto linux-next.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

Hello Bjorn,

This series has been posted for a while now and I don't see any outstanding review comments on it.
Could you pick it up into your tree for next RC?

Although the series reads as a feature enablement, it's addressing a real regression: on several chipsets,
turning on the Inline Crypto Engine today causes a significant storage throughput drop without this
series applied.

For example:
Without ICE:         Sequential Read:  220 MB/s,     Sequential Write: 310 MB/s
With ICE enabled:    Sequential Read:  143.717 MB/s, Sequential Write: 126.762 MB/s

That's roughly a 35-60% drop in throughput (averaging ~50%). This series is what makes ICE usable without
that penalty, so merging it would let anyone enabling ICE today actually get the performance it's meant
to provide.

Abhinaba Rakshit
