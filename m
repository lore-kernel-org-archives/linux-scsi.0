Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D373876CA
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 12:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769689082; cv=none; b=ryb+oGhMzMSQuxoB7FREtlZmGnXChXOR12bkqp/WafjtO4dDU4DTCFrZVFuauruYO99beoCdr3sVCc8CHKzy4Qm1qb61v/CHRTnhxMBFH3VIo752am4gPKlRPCpJ7yp7aKTUjojAVp+eVyXc3OWY7UWzw6GP1QOsoAKFBErpHXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769689082; c=relaxed/simple;
	bh=7G2vAEHNegfOtPP4Ox8PcGDR2+nERnG0SVVl7JqceYQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RiESGxA4pwIFQgOEKQGjOF9VvBrp6DhSyIXeQ84NtDQPC82fu6KFK2lyrGzLnsOj97XwG9CKRXhyVOKTChndD31rM0ZJJKFYF3JIGaBpQzZHWP8UpRoCojOpqnmtAEexII8ZFEA4mVOtP8Ty8DBsnavo4O02aJRnpJ6zXs6kzIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LsTVVIj1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZXFyN9qJ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LsTVVIj1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZXFyN9qJ"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60TAPn1R3642648
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 12:17:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FcrwN2wnlNsCPb8qZU41GPI4nI5ZkjV4GQKGB3maAUU=; b=LsTVVIj1PPZjodkk
	FzATDHzgchsILT5pTnWw+S3WwzG++XE4y01Jn9CugZTGE66vc3qYVXQnDpr6JIxJ
	5N1BkRcLeDQWje7A78/HUZDVLBYLWH0DeG05FmqWylhhMivXQPyUnW//tWlXmi1w
	jzHhv6UEhEBblfmAIO2Pxx/Ku1c+VJjmJcfCUjIMATgQSEjE4QViRVUsdEw1KGma
	Dkf5wbTwXiAdbvwfY9rytvPrF/uN9ThvBTeKhboNR9FT+tTidJ4mlTdNda82dvzY
	UtDQIgoqFx7PCTZEnAAwWfgaYUXKkx32Nd0JqHG9UlSh2g1J5KG/9V0Mj0BEPqXS
	ksbGBQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c05sr09se-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 12:17:57 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8b2e518fb75so22078485a.3
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 04:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769689077; x=1770293877; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FcrwN2wnlNsCPb8qZU41GPI4nI5ZkjV4GQKGB3maAUU=;
        b=ZXFyN9qJ3GY2MUcQfhGYxP1CAAWB4eW3Jhho8DfRSHklzxiQLsdgUQhH3Ls/pN4o39
         JfphziZGOk8TEFsG7wTWC+GZc4qQ3bf/spGxTQXjuxLnHfeUhOeY/M8Vzj8qV6OjP20U
         I1wOo6yOpbx0OZLFcb3+UZFoR4VMZd6ochJ/9kzGEkFWnJgmlr80uLWh2MVZnfX65oBw
         0p+sNzGWvxK0XjFOj6pCWg1pvuUnkTdvCLswePlvmulM8cHdtR4ORw/Fvy8hzCyOtx/h
         m42ANmGcawhoq0ljPwoRp8Z18nTGr72ZYGgHWgg3IcH16nzGUFu7XPT2RsT9GJljxUMn
         borw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769689077; x=1770293877;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FcrwN2wnlNsCPb8qZU41GPI4nI5ZkjV4GQKGB3maAUU=;
        b=v9oWkKTglkRsOYqxe13N5dIn5GzzLN4WFySuPRAfQQ8Q2vfmdDrIB2xF9GPxAC3ZNX
         yB3BS3mbuXrnn2fQpU8a2kxH1S7YrUluTi5cYK9qzV/9lCllHOTilY1l1pxmHF2P03yL
         YILH0FBn++X6KJCbT3DVbfqeJ5HnYWYj7Ln1dQ0mIi8t6LZnP0ON4UVIMyFi+gvT5Z/u
         tk9EmhKshjWNUbQcxFmfbONB21aLMIkT8OpvrduTYeWLkyUuJW+FIPstaPR5ENEsd/aC
         i6C8coI+h9xKrXQbKm5KmhEww5kZ0x4wvLFdzWuw53S0wdRYkluduPKZiLjGvhYfPEf3
         L3fA==
X-Forwarded-Encrypted: i=1; AJvYcCV9fOIRYQ0uJ9Y1oj2ea3n5Xx7HfYMxaJ1BTK8JDBBAHJsebxnBHwZAKkcrZ4EouQAK2iCLLFHCAWKZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1xzbeyDLbMahnEbwhdCYryVJVIb3+nR+YZm/j18xyB320lvAq
	ZPvM62FnMJKileB6M//oET1X1tlBVUmPFIZVC380QxUwJhS0qnCOqNINYpGBEQgPgYoRFwaJ97X
	iUaiAmFnj0q4NqSC7cx95wOGOwFltZgPNbsdTXEOvtQSoselxJu/0R9yahA/CNrps
X-Gm-Gg: AZuq6aI2HKRLZirhpLexzqu6/9peosO6rO9+k2Re8MOP1n5d7PZP7uDdvWCG2vf9ao5
	MUlhmWmxHps141AwKpFSR/0YrTxL6ZshOItoagbH9Kw6WVUDzAZlbRAPIp63HJH/xh8VfhRSFZg
	du8Z+6bMeTVlsdl9fkv4txz50e8qATXKU35M88Tg9qKRLGjrqBTxEVoMSi+Mx/e7DHNga6bJ5fN
	DUYvZKp6s2Gg6pLX2fHFGNWay/i/U21zaCIs7fddrO0o3lpaXIhUGJkmS1IvciaoM7saZR7Fc5U
	7CLe8UC1DAqGaBx84y0KV1iurwVi2dbiDpTJkUtOTqZCkXe4Yzjuyd1dml0WG0boQPQmWWRhuJg
	XmrJs5OYk/+uQ7EtXHmFH2TBnlhQCvSG3UFqw22l8ru7qkJatQQGX05kmCKs/DejDtAw=
X-Received: by 2002:a05:620a:bc5:b0:7e6:9e2b:6140 with SMTP id af79cd13be357-8c71ade7be3mr352930285a.8.1769689076979;
        Thu, 29 Jan 2026 04:17:56 -0800 (PST)
X-Received: by 2002:a05:620a:bc5:b0:7e6:9e2b:6140 with SMTP id af79cd13be357-8c71ade7be3mr352926785a.8.1769689076547;
        Thu, 29 Jan 2026 04:17:56 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-658b46abea5sm2831410a12.31.2026.01.29.04.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 04:17:55 -0800 (PST)
Message-ID: <7b219a50-6971-4a0c-a465-418f8abd5556@oss.qualcomm.com>
Date: Thu, 29 Jan 2026 13:17:51 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] Enable ICE clock scaling
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDA4MyBTYWx0ZWRfX9EziVKVSF6nK
 ogK3SY/maM1e6HRPddFx+UzoccS63uWGZqKe7a04IcBuzD5xcv2NFlXzAUqX8oo9rirE5rryidA
 8BnR6SS04sDhhEEDWODho0Gt/wZjZV/OL+ocXax1Y++rh2UE/edr1SAZIu37oBZ0bGUtwcP4EVa
 pgw9mkGMgOcqV+IFSiF71qI1SxNpIB/X+9Gce6zoHlKc/ndZFCcva7JmcLYCmS6Idx4tfUBYcba
 C4JElmUNYyZDm/R5XTbdCqDeNQcfXLk6yR0eIRVcfgurnsvLDVRmzYF/4WR3awAxTvbakQNZsb0
 5u5N5Uzx04lFvALnbAz534ncfO35kmZTqVkTWin2Ty8wtb8oe31DKm4y8HEmZAkLVdrAbo5cSlB
 +gA/JT67eZqjnOqzfvboTcLeMxx4bvXyzdIl7D+PPdM8nIfwm9DS1X5XQHXVHTi/ykkkDigGFPc
 yW9JNMX0+m1cIqjhiDA==
X-Proofpoint-ORIG-GUID: vfZdZ13sMLcZ6BOGYQhWQttG7EDEhTcs
X-Authority-Analysis: v=2.4 cv=UsJu9uwB c=1 sm=1 tr=0 ts=697b4ff5 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=4MEm5NcWsPKhGJVxAVQA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: vfZdZ13sMLcZ6BOGYQhWQttG7EDEhTcs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 clxscore=1015
 spamscore=0 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601290083

On 1/28/26 9:46 AM, Abhinaba Rakshit wrote:
> Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
> using the OPP framework. During ICE device probe, the driver now attempts to
> parse an optional OPP table from the ICE-specific device tree node to
> determine minimum and maximum supported frequencies for DVFS-aware operations.
> API qcom_ice_scale_clk is exposed by ICE driver and is invoked by UFS host
> controller driver in response to clock scaling requests, ensuring coordination
> between ICE and host controller.
> 
> For MMC controllers that do not support clock scaling, the ICE clock frequency
> is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
> consistent operation.

You skipped that bit, so I had to do a little digging..

This paragraph sounds scary on the surface, as leaving a TURBO vote hanging
would absolutely wreck the power/thermal profile of a running device,
however sdhci-msm's autosuspend functions quiesce the ICE by calling
qcom_ice_suspend()

I think you're missing a dev_pm_opp_set(dev, NULL) or so in that function
and a mirrored restore in _resume

Konrad

