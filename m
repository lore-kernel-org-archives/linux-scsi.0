Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC311F09A8
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 11:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745407786; cv=none; b=jDbYBI/S5uAeWHDT2X4LWnk0sCKIa5326gBaN/iBU4DLZ8qXiMfOaBrRx/O47OHBY7kIOowsl0KlBKZozn6myqt2t+3l+PXEA+58CiktAFJLBClAMyTOLv/cpPFI7Hq5PaUuGM9vOAge9yAhKhUZJWHwQse5vok9S5cRQTndBzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745407786; c=relaxed/simple;
	bh=JTT75Mn1aCr++Zw+4/sd68fJWxFJ+nXgtTCekw8+jOM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JVvcvS154EC5ib4U5Z3oXkGgHZO7e0v67rQ1ckICWjc2wemLydbWZHE82SpycwO4RGFInmKxWXQdSyf2xqgIVGWmdsjeHX4grIdjwIpCmhpaWYmSiroMN+A593ZlwHGCkaZ+IOsAbBSQAdFj9F6WGViMH8UuufdJh3iIo3H3fo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mwRh8Og5; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mwRh8Og5"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NApL1M011954
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 11:29:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aiLYMeII1DzKYJXChQAXWDo4SsnOHw7fzuxji7XmLYs=; b=mwRh8Og5wI59bfsL
	gzcq8bksEhmk+alL70SE5tmEiJhgWm7v3YoUgydWlPoy9QAdCYsgkNOyGJtbXtv/
	Bg5QhlVnctg/enbmUjwnHTC4cksMLN/VapnjkbNxEJpxn/xLYAtT9oBDXOfa/c/M
	rb4CBs96lm1bd6OhuVU3oV0E/HHaEcyQeLApr1o+z5kg9tbcw2PLUbhaOc1zCA3a
	NWRlTw3JoQAuSYjJf+Pk3PD96mtt8NsP08IOsOUgp3GyOnvC7O1QBJslOhpB7Vq/
	znAYxLHsTLMXGr1NzCuKPtesTkkG2HU4EWkUxHdBqTgucees4a/htP/It0+i3UN4
	o7vDRA==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jh1hyem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 11:29:43 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6f2c8929757so15156516d6.3
        for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 04:29:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745407782; x=1746012582;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aiLYMeII1DzKYJXChQAXWDo4SsnOHw7fzuxji7XmLYs=;
        b=UmFDP2jKS9qIp/iNtSbEYfRQn+aXcCGLrMfzPMosS3Rj5l6HI+I9It8/Qhh7O0moQB
         LBNGMlMIXJiYIQ3sQ4lSYUHl/tTny+DWY70mVD/e6cvz/NymAduw9+trwTb7Ob3jnXfi
         oG5xl/9crXi6ZlJk41BnIyLIS1WSQZiW6b4DxWlQSPvPZM8oD0mWBW2lxb7LmLfpHqv+
         C5PgJ5h1I36shyRrFiZ0QQ51ZfOeOM4bmKjDmdSugtJEc/Ce6IGta/hNr97Hp7iZ/2BQ
         gFO6lNzijM48u57sXUej/8ocSKiOJcw9dbxJm890Mv36uP19L8DY2FDrZq5oojsGUh83
         9wTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXg8yXNCbDDEdyvAnLeM+La7YPab0oWHIqYOzJR9HB8IGSGyOfioLfcr0iqDuCq9m/6Op+LHcYaN6QD@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1ESLQNwckWTCFozRkGtZMgsJf1tOwmqEvcc7zjnIn1NxwxAlX
	X6Uf7+oSYwE1Lfd8f+AoFqW6nDA0h3QnmWmr+/bbCrrU8tcOPdftL50HTEU6Iv41I+bO1QYQ8wm
	dd4jlFAndUkSqTULLJzsVHIEnT4EO5uZ7ChDkWtXoJO39nUyihvZfZaWxC9Gw
X-Gm-Gg: ASbGncv8Sn9bRL5tGWtMRpCcHXTvKn0UrlXohR2B9AU/FoI6JQnRgAnC5V9RtSdIy3+
	i/jm9WJvzQCJdGhW1kvGUnnwpaVu/d3BV1bAdr/KkzZJLQoffy55eOFJvIZTRmBAFmIHJT/DL+y
	8y52YsEFdJxgfSL2v/yZjliJSlhgfopG2QIdYIIzwYfWGZKtPWIge3D0QAWkKhWeo4llu3s/dDI
	LJKkr2/t1veqBDpklPq/OTpRkh+/RfoufVm/pA99IWXOrMLZkA8hw3s1W+BwQ6kEKp388aCMeOl
	2YUVyVKky3DLAPIBAwwkHCTe4bATCiBiZoJTH+YzwZ0G/Xh8YyodtEGBq4ejP1XCsQ8=
X-Received: by 2002:a05:620a:4543:b0:7c9:2465:8731 with SMTP id af79cd13be357-7c94d123bd5mr169984385a.0.1745407782425;
        Wed, 23 Apr 2025 04:29:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgFbGmUp8j9I7o53Gg0IqLCwRf3sb8p8Am2LmvgQJTpn9FJCrHSFbcU5fZ7b4kD9OfN5zyGA==
X-Received: by 2002:a05:620a:4543:b0:7c9:2465:8731 with SMTP id af79cd13be357-7c94d123bd5mr169982485a.0.1745407782052;
        Wed, 23 Apr 2025 04:29:42 -0700 (PDT)
Received: from [192.168.65.183] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6ef48e5csm802900666b.148.2025.04.23.04.29.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 04:29:41 -0700 (PDT)
Message-ID: <052fe049-a17f-4fa7-80f3-a198de21b3c1@oss.qualcomm.com>
Date: Wed, 23 Apr 2025 13:29:39 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 6/9] phy: qcom-qmp-ufs: Refactor qmp_ufs_exit callback.
To: Nitin Rawat <quic_nitirawa@quicinc.com>, vkoul@kernel.org,
        kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, bjorande@quicinc.com, neil.armstrong@linaro.org
Cc: quic_rdwivedi@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20250410090102.20781-1-quic_nitirawa@quicinc.com>
 <20250410090102.20781-7-quic_nitirawa@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250410090102.20781-7-quic_nitirawa@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: DoZOWycZVOTAc9-IxvW9z1gvesf8n36h
X-Proofpoint-ORIG-GUID: DoZOWycZVOTAc9-IxvW9z1gvesf8n36h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA3OSBTYWx0ZWRfX8vpJU8zxDTlr RfWcgQXxiy/LuCN3zVqJsgBiZxwuPrKHBunVMDhgE4v5BIvUJRzlBhZAYuXDjl//BPun78m3XVP 0Obh6E57FBM1NsRhf+76TTo5bct1ROWD1mUg8mLO/1fiDFjavZaUgRRsyz5E6dq2h+yKkbTkSqu
 26MH2qMHW1Nz7AYUbHByzDFDi0N4xG59r1yFtgG0OIaJJB1bg9NLatmGFNvgb2BbS6S3MiZKhpU GY/1WBREzrbgSR+zvDJ9uu//Oevkefabs9YTr+YCdqUQbsAoUPfR0C6AWw7yOIa7DYldO/Fc0ex mfQj4kdeBBDrNQuDOBiKM6dq1Os8YpgthYDMbb/Q20F45W36agY76oj94etxQWMEnhgChZRj+UB
 UrqI0BKDDoMpzYikTgwh79STR4zeLt9jLbBH8uOZtlfS7EJLjWsbuw3432Ixkgwo8Tyz1Rml
X-Authority-Analysis: v=2.4 cv=ZpjtK87G c=1 sm=1 tr=0 ts=6808cf27 cx=c_pps a=oc9J++0uMp73DTRD5QyR2A==:117 a=FpWmc02/iXfjRdCD7H54yg==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=COk6AnOGAAAA:8 a=0G_SUc_-HujNE8ZPJPcA:9 a=QEXdDO2ut3YA:10
 a=iYH6xdkBrDN1Jqds4HTS:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-23_07,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 bulkscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504230079

On 4/10/25 11:00 AM, Nitin Rawat wrote:
> Rename qmp_ufs_disable to qmp_ufs_power_off and refactor
> the code to move all the power off sequence to qmp_ufs_power_off.
> 
> Co-developed-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---

So this patch does quite a lot without explaining the context
that isn't visible in just the diff below

- .power_on is altered to no longer reset the PHY (but it only did so
   on docs with !no_pcs_sw_reset?)
- partially inlines com_exit (dropping the reset assert)
- removes .disable in favor of .power_off that we can't tell
  what it does just by looking at this patch in the middle of the
  series

Please improve the commit message and consider splitting this change
in two

Konrad
