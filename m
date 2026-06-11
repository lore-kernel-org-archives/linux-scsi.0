Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61CA40D586
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 01:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781141208; cv=none; b=RAAGDHKeo7FHnm4wMeI2Edies5d16kwkB3nrtse3wAoVRUAeklQSYf5s5rG/6naxgrp273x6M+KKhtjhjR5ApyOQrVd1O/E5I8VwwSlFTZ3dDp43JYoFLN6vRETZ55k5E8+hQV2uPs3cGFpvnFTKJj1nbMFXcgR4QKgGwoLSZEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781141208; c=relaxed/simple;
	bh=zzAThIjqpu0sM1TOnQcCIDCrUE8XayfKqrpzou6KiGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q5rGepTSQ1N7IlGmTll61RGdz/wrrwbH2fiqlFyDuYXoVq4E65oYM8J4oxLqIBTzakM1KwMN3JMr/nCr6pyb54HpECzfEORjMktQ9Q3OT1Pc09Le/6TPNgOJKo4CQymSPC6DqeTqfYDpFMOnoB3s9wLycfW0btpcKgGEt6JJL/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZdxETPBJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Eeb26axW; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZdxETPBJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Eeb26axW"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65B0NTa03202751
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 01:26:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Rnpup716X2cBe4SElQEx2vvionFYX5DCEvEJtGFq2C8=; b=ZdxETPBJ8/ZfNIgz
	FOBkIADRPJdkN3IBQtVitnTcpHw/cJrSCd4MmWg1N7i2nioJ+n7leKlhs+P3xRgi
	oTQDSSOr4VDk+a335MHmR6oTTsmw6wecmKyzFD0qbphBwQaoZb2Ka/SFe0ZzAhc8
	tL96z7jhJA+vRyCICB2mFSxRLKrS0ADgnBrZuM4SaH+/aE+nZCArDGPyF7QB+N2X
	yHiFDxOiYWkWAnYIuU27LlKtHKkL9D68M7VlsID76pzjaId2J9HgYNwRizojM2ts
	s/VdLxGn8zY0tIC5+VW1oYh480HX3ih8X7uZXKc5wo2Vb0titwIpGFCC680V8rnN
	Pc7QFg==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eqe6th2ar-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 01:26:46 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8423f544944so5368582b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 18:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781141206; x=1781746006; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rnpup716X2cBe4SElQEx2vvionFYX5DCEvEJtGFq2C8=;
        b=Eeb26axWbXz99Y1KkehhojSV6IRULCTwxgdjus3lfJEm996giqC+dtLxzUeOSdcgT3
         38vOGzH3ze+tETyDUaVUUvY6/0oPV1xXsmmaTLk/mtBI+x5rjPS4LmHnXUZsul7FP+nG
         St/IweUR40i1Z2AwMsFKXI+9GW025XiMz3ChXCG18+XXdSM5e5pGWof+CK7FwhXzP5Im
         RL5C65SXKy3B20kXU9jZRwJ4TqDlWLF7mIZeML87RlB0gqU7WS7zM5rkFqKZGrosD983
         6A4NA+nqohR6lr0lr/O/taENK7O72sSL+6/EKCGZ/AWMrFk5sw0o8crURZ3fo/NvCC2G
         KhXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781141206; x=1781746006;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rnpup716X2cBe4SElQEx2vvionFYX5DCEvEJtGFq2C8=;
        b=JmOL6ytGjM+H7sRrqJZD9dhjjZTJV+WUnDxtDpcHeJ6XZQF89oTWRTyFcHhWk3VMWS
         euQMHZ9XqgPxtVI66SmqkBPvMMonB1zV9/Bx6PEU3RRhzRCUr/ohSjUeeEJ2Jm/8I5nn
         utA+y1gAKVT4rAdSUzR8Jdr2sWO2KQgzXS7kaQbhdG9ECtk5DkbRrlz9pc2/xwAqLiFh
         9STcN6Q2/uIIzsgoTxjiOg1AECUQiXRj5F5WeMVdCJQbXfLh1imMNcajw4tHRTX2rWWC
         1Va4N61r6vezE0b3hlwbWQx+sLR/xAhOTlCF14W0NWMf02hSIKkdIoXnRWf0NLq9sSAJ
         qRGg==
X-Gm-Message-State: AOJu0YzJMcJKHWJIlmvugmup7VnEwr6N+PWL6jK+ssxKlQm2lOhMZs3H
	1Ce5bsYWp2w9wrx6T83nyC73PEQRkQ4j5lGHbwIvh1ouGzIFk9TQTXOJD3G4m/9qPSTvZAucSkE
	+prRszy17O62rfC5YLHagN8f1vhd53RnbaskeTfkm7vLSKZ3FQPMgOvZTg5Y59kCG
X-Gm-Gg: Acq92OHvY94id10SldzvwCskDP3ciq3FQOmVcj42p7g5lR+ac49JHLiXzv2dERZ+pPv
	DEvT3I4VDuYdcPtV2+nt28lsq69wDHRwB8SP1yfyU8F+2nc7e581uFLAfk5i9TWIXGjbVfrb+iQ
	S+KVmUuCOhMaBiorcv1UEfSZQXfOy1nKXshAwbGNnDmfllWxdVdx2d+vMVkjNhFQ22sKZRi9nFK
	b1ZPtR3qPEwCtTwX+gNuJxt9r3h/bF06Xmceah74HUaIIsG6kwQVu3IW+9a8QlHYvi823OEJNg7
	r8mDrQB3InQiILNIBVIjNvfJtgGXBFkm+Ym9v52pUGQk4kMoa1LcCI4MhaZeOPiKuPHUo8HekiK
	24UnH73Uv1sjcFppibGxxbEq6G8QsxqfPA+tNi8IRmprXAe0be49XZz34FZsSzZN5GOjIed7Bb7
	WH4CacEs1rK1B4Q+aoJlaO1w==
X-Received: by 2002:a05:6a00:9505:b0:842:6004:3fd9 with SMTP id d2e1a72fcca58-84336bc5b66mr460910b3a.29.1781141206211;
        Wed, 10 Jun 2026 18:26:46 -0700 (PDT)
X-Received: by 2002:a05:6a00:9505:b0:842:6004:3fd9 with SMTP id d2e1a72fcca58-84336bc5b66mr460865b3a.29.1781141205598;
        Wed, 10 Jun 2026 18:26:45 -0700 (PDT)
Received: from [10.133.33.231] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84337bf128bsm109823b3a.27.2026.06.10.18.26.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2026 18:26:45 -0700 (PDT)
Message-ID: <3162fd39-c3c6-4c96-a8d1-0a9819a6f696@oss.qualcomm.com>
Date: Thu, 11 Jun 2026 09:26:40 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
To: Bart Van Assche <bvanassche@acm.org>, krzk@kernel.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260610071516.3763916-1-can.guo@oss.qualcomm.com>
 <20260610071516.3763916-3-can.guo@oss.qualcomm.com>
 <9b304461-2672-470a-91bc-21a5e6935205@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <9b304461-2672-470a-91bc-21a5e6935205@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDAxMSBTYWx0ZWRfX6DoosrkBiZ3r
 fzwOzk1/jmXmmIuZekGKnm7g/zYcO/bbQSnZbuDTe79DWVT1fc3vlnpyO8C3oCpVs8rQ3/T2PIX
 JRplgYX4CEx8I5x/Vqlq5xlvDXEMbyiPQ/f7DhOsuO51K+oCSdM4ID2mAG1hsjCVN1ZLj08BPPg
 MQB6XgFJ8S3XukaRzDnsGjDmTwG6kr0b4b9h3el/jI6w7kzdcznbF2mYPu9wC5za8NIQceew76b
 z+ZJS8LAcKZSS8u7st3KwupoIotdZqPF6iBXKCT+4tXN85MPlwGpuJoWYwXbrW4xsST1QK6sEQT
 d31MNH7ZATJo1NX85CwEMqDXXF078lcVcQl1iprxwXfR36nswrXSGqoJyGbuS050Dg/Zm+ZbwvK
 AJcIBAWZd5gKx76bKEoGbYrFP3DBot5QYfX92ysSIpkJZXP1U7MrX4PEgwB+M78ok66KAHXQk2t
 y41wT36ntiboHN+VBxg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDAxMSBTYWx0ZWRfX3KPQekjB3rN9
 SYVJ6041kqoVIPgqQ8MfLc39FeE66nxJHL+BL7R41t15I6ccUKwdQJiK+LZqb7+TAPfsidNpOzO
 RGUvnTQEM4nVpg18TCwWA2mVvecDUqw=
X-Authority-Analysis: v=2.4 cv=AaiB2XXG c=1 sm=1 tr=0 ts=6a2a0ed6 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=w9uOJpbB8xStSp0LBPAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-ORIG-GUID: BMBiEG0LwOeIgE9TqEvtoa0VmjLhzSYQ
X-Proofpoint-GUID: BMBiEG0LwOeIgE9TqEvtoa0VmjLhzSYQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606110011



On 6/11/2026 4:08 AM, Bart Van Assche wrote:
> On 6/10/26 12:15 AM, Can Guo wrote:
>> Parse board-specific static TX Equalization settings from DT for each HS
>> gear and store them in hba->tx_eq_params.
>
> The word "static" means "showing little change". My understanding is
> that the settings from the DT tree are used if equalization training is
> not performed. If my understanding is correct, I think the use of the
> word "static" is misleading. Maybe "default" or "from_dt" reflects the
> purpose of these settings better?
Thanks for your review.

'from_dt' sounds better.
>
>> When adaptive TX Equalization is used, these static settings are not 
>> final:
>
> What is the meaning of "adaptive" in the above sentence? I haven't 
> found that word in the UFSHCI 5.0 standard nor in the UFS 5.0 standard 
> in the
> context of TX equalization. Should that word perhaps be left out?
'adaptive' is not standard term in spec, I used it to refer to on-demand TX
Equalization Training procedure I put up in the first patch series. If it is
confusing, I can remove it from the commit msg.
>
>> +    /*
>> +     * TX EQTR must run for the following cases:
>> +     * 1. TX EQ settings are invalid.
>> +     * 2. TX EQ settings are valid but static, i.e., populated from DT.
>> +     * 3. TX EQTR procedure is forced.
>> +     */
>
> What is the difference between "TX EQ" and "TX EQTR"? If both refer to
> TX equalization, please use the same acronym for all three bullets.
TX EQ is TX Equalization.
TX EQTR is TX Equalization Training.
>
>>       params->is_valid = true;
>> +    params->is_static = false;
>>   }
>
> Why is "is_static" changed into false here? A comment might be
> appropriate.
After TX EQTR procedure, the params is populated with training results,
which are no longer 'from_dt'. I will add some comments in next version.
>
>> + ufshcd_parse_static_tx_eq_settings(hba);
>
> Please consider changing "static" into "default" or "dt" (device tree)
> in the above function name. I think that will make the code easier to
> follow.
Sure, will use 'from_dt'.

Thanks,
Can Guo.
>
> Otherwise this patch looks good to me.
>
> Thanks,
>
> Bart.

