Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECFB1A8405
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 13:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745416325; cv=none; b=lZoSuUeZe3ZdoFGFWTifK7Vn9d2rmqHcJiZeBxJ4TlcRWk771BKeJWouhWTW/L2fiYRVL1zK1caI8PZYLm/eAlXcAiHXGwP1tzD5OXO1Qz3gXck2H4ZkYtLWOGyfbhlrdhEGZi917TsaUaknQ3uWfg7ZTDc5gtSWrbql99MYZgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745416325; c=relaxed/simple;
	bh=0bAnqI40qy76MCtFlvAvA88DQRF63SAr4EXXQFTXYnA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AQiHBhOE+Be9lSZYzTmNmKTucBt+Ns+n0lDi4HyKcvlyzIXYgoZgIX+z5xmJa02FzKx2ZeSQyS9qt7SUqhg4HWg09OYFEWcwfnJMVN35yVOgkL9M0n6ePhmNRXI/7BXIaF1fBRYcUltKagbQY+WlwBbbXlDUFc2TBaUtdWo/K6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=I7yFIYaR; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="I7yFIYaR"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NAxVN1017062
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 13:52:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xkJf7kOWyPXE/bAYrd0wNfurykT7yQdN5XAbkQzQbAM=; b=I7yFIYaRltaS8kba
	rOOsTY8k9by6Ol4ONAO4ulcraS94HwCoOHibcZi+u2y1+RgDu15tNcWY9qWPOtgL
	mmftD44RzR7+KquS39u6NqtItkeEY8Fo8UGRujXjYkvlIgjUW3FkF3cmVJMNv5d5
	6uoiGH4/gE4IdU1ejhBdvTTLwT2gg8a1sQ16uq2D4Mbb60UOweGfzrltX5y0ODyI
	vH71BzVnj21YzCaawcVXm3P3J9xuUZIY9LcPEizXnqaBJbi/QJgBUdyYRGevq03S
	HHTIqmft6gzee6h/CTtOUToosGmZV41CPtPLykb3nSjf70r6HMAkaH7YJy/cgbKJ
	irhe1A==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jh3j9n3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 13:52:02 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c544d2c34fso870507785a.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 06:52:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745416322; x=1746021122;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xkJf7kOWyPXE/bAYrd0wNfurykT7yQdN5XAbkQzQbAM=;
        b=g0xNk0WSFmlHxmIjsY0qPX6yOhooEQmPhPBydQVmPxarS/LhmlCF3Ch2KlnyvPlJlr
         oiSQMOPIuDfHZ4u0vSxrtto7+joqU9cr/H6h3dij5Ojs0y3T50BYkXKIoK3sT0dIbsiv
         RDzr5f24J/f5SBEy9RFDpc3/Sud0jUyRE7opEuRW4HU7DNY++pFdDmtPNtETq9V4BaAq
         REpBSIOR22qhUkcQGC3h5A2wCeBgmbBVhddREwGe7JvPQG7a5+vfhUwOtv8Yur9jemhE
         qZgZ3XUI/guQJKKzYJzBWXgZLOsBdo7DvQ4jz+FbE9khmISxcTBJkkxNHL4bnWAhOv/u
         5kSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUe7AMFC+JcUiK57sOPNy7Q7elurckZaPQvjVgEV9sASd5FgBVSHDBjDBc1OXKAayd0j649H93Ub+Jt@vger.kernel.org
X-Gm-Message-State: AOJu0YyvK6KG0DTLy9E1HS/eFzBRdK/GPfVo+u4ZIACsyOMG0fpoOn7b
	uzj0SItDvf/8HJYRZCdzsvkBJFAqWWydAPZDDXp2YiKUZwfezXBmcSUztlIgJLi9PFYgYw35PPw
	qcVn0hIBf+1Fow2XK/A9vomYzkmdqhugnUNtFfcctFTNCCSjX10HT3qzyDw4A
X-Gm-Gg: ASbGncveMmvx1vvUqCzR2GlFrkSMqD7UJTL5DlFl1bLlkTPVLrBnaXF60+OEoUyxUGL
	bTFQcorF97vGAKFsnHU80dZ1Q63USJeDxA4CHDmCflsK20onZFzruplEmMmHpJqjODE06lrDOI+
	vzeuYr63jwLGsFPtysnJeRbG3vpL8qbimgqiQZ+7wXSJkjhOqgxf6A99oCx7UQl/caDrcs7mIn1
	lD/pFpu1T/PWSMwyiZw+1NXbNbTwclY8xDmXhmnn9Z8vbsuSmqUhWUUFmqhP1apZr0dRfG2mmBl
	LtG1HRgTGgSmxnO+uGoZ15k4N87G2K89FqDMOgADbIcJcJlszagdfLjICMC+QaC43wH/GPv6JjA
	zRQJtypQlK+5pRotok36wz8CcLKd2NZfO6D/eJqHay+X0sUCo3kwOcEQG6KJcZPbA
X-Received: by 2002:a05:620a:248d:b0:7c5:43c2:a8f4 with SMTP id af79cd13be357-7c927f6b2b9mr3017557585a.12.1745416322119;
        Wed, 23 Apr 2025 06:52:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHrD8GKWDiajlXtRlhCqQokXaChDX0L7FWqOCEuiK4S46NfWfbpwHzSXWRpOSxjfqEHecTieg==
X-Received: by 2002:a05:620a:248d:b0:7c5:43c2:a8f4 with SMTP id af79cd13be357-7c927f6b2b9mr3017555185a.12.1745416321797;
        Wed, 23 Apr 2025 06:52:01 -0700 (PDT)
Received: from ?IPV6:2001:14bb:ce:6a0b:adf3:3f29:4dd7:6598? (2001-14bb-ce-6a0b-adf3-3f29-4dd7-6598.rev.dnainternet.fi. [2001:14bb:ce:6a0b:adf3:3f29:4dd7:6598])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-310907a8416sm18673731fa.63.2025.04.23.06.51.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 06:52:01 -0700 (PDT)
Message-ID: <7ff824d9-5d86-4d63-a8da-5d94cc489ee6@oss.qualcomm.com>
Date: Wed, 23 Apr 2025 16:51:58 +0300
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 4/9] phy: qcom-qmp-ufs: Refactor UFS PHY reset
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, bjorande@quicinc.com, neil.armstrong@linaro.org,
        quic_rdwivedi@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20250410090102.20781-1-quic_nitirawa@quicinc.com>
 <20250410090102.20781-5-quic_nitirawa@quicinc.com>
 <pur4y63xhfmqlyymg4pehk37ry4gg22h24zceoqjbsxp3hj4yf@4kptase3c4qp>
 <317faeaa-3130-4e28-8c5d-441a76aa79b4@quicinc.com>
 <CAO9ioeXnnbNzriVOYPUeBiWdrPfYUcMk+pVWYv0vZpJbFeByoQ@mail.gmail.com>
 <1adda022-b5d2-43e0-8cf1-de8e72544689@oss.qualcomm.com>
Content-Language: en-US
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
In-Reply-To: <1adda022-b5d2-43e0-8cf1-de8e72544689@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: B-i61iceNKpHnTQJBeJ7onyP0rNB6uW8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA5NyBTYWx0ZWRfX15twhPlOnSa3 sZF9JlnYvrqDR5DJOS2O8EtOU0vhyxdm6lQnS8wvS9hHWCjuPQDIcWffoJt/uKXoy0AByzWg9x/ MqHIZHQt2DNJs3PLY5Ck5YIUCpd6FavdBFTSEEALHGVDBxDLUznwdGIzq727btcKwgipFYMtpeU
 RAlkQSztVyoQ+zmfqXqiGWyuEcE18arUD9Q9JyfHzBwGkoAR307a5AHkl+0pzDJ9R4EFxh7cwZL w2S6SLTaUhHSxOXS/rhGVi4JWQv/JQN010UWg86wb2aifJtGfuT3vVAFyff91vlwoRisVWQ8qmR f6PKA9IeG/Gf2UKOB31yXVGKmNxnEXXDxOHDiXZ5JsNNOBQ8bC52rQFXAXE246tFIjs0YMllvY9
 D8FPBTy1oQ1dsmNMlSTs/QTyY6RTcNQweL6jbMuJxkxgyfgfd5fMsEtgtaQlxAbhAa1QJJT0
X-Authority-Analysis: v=2.4 cv=ELgG00ZC c=1 sm=1 tr=0 ts=6808f083 cx=c_pps a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=COk6AnOGAAAA:8 a=m2W-dpWsrdQmR1pkfZIA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: B-i61iceNKpHnTQJBeJ7onyP0rNB6uW8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-23_08,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504230097

On 23/04/2025 16:47, Konrad Dybcio wrote:
> On 4/11/25 1:08 PM, Dmitry Baryshkov wrote:
>> On Fri, 11 Apr 2025 at 13:50, Nitin Rawat <quic_nitirawa@quicinc.com> wrote:
>>>
>>>
>>>
>>> On 4/11/2025 1:38 AM, Dmitry Baryshkov wrote:
>>>> On Thu, Apr 10, 2025 at 02:30:57PM +0530, Nitin Rawat wrote:
>>>>> Refactor the UFS PHY reset handling to parse the reset logic only once
>>>>> during probe, instead of every resume.
>>>>>
>>>>> Move the UFS PHY reset parsing logic from qmp_phy_power_on to
>>>>> qmp_ufs_probe to avoid unnecessary parsing during resume.
>>>>
>>>> How did you solve the circular dependency issue being noted below?
>>>
>>> Hi Dmitry,
>>> As part of my patch, I moved the parsing logic from qmp_phy_power_on to
>>> qmp_ufs_probe to avoid unnecessary parsing during resume. I'm uncertain
>>> about the circular dependency issue and whether if it still exists.
>>
>> It surely does. The reset controller is registered in the beginning of
>> ufs_qcom_init() and the PHY is acquired only a few lines below. It
>> creates a very small window for PHY driver to probe.
>> Which means, NAK, this patch doesn't look acceptable.
> 
> devlink? EPROBE_DEFER? is this really an issue?

Yes, it is. No, devlink won't help.


-- 
With best wishes
Dmitry
