Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB75303A07
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 07:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773731062; cv=none; b=n++vVUCBIWHRHi2isO451wBP38Wlc5ffeFb2IwR7RR/NO5l0vk6LderY5XP2D4SAuF7Pv97jt0s0ZohPSmvSEkOzxcC18JBR0vxO1WL22QkKus+hDIHSj70Ue1fIZU4xFyKONwZ6I9mqqeM/xjX66pXC3kn67FbmpRwHgO7SrhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773731062; c=relaxed/simple;
	bh=Pj0AescwKQKugE0oUPQYGMX8mPyxhjBvNONkzt4D0uE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dhe/jWTI10JUoxQaCloXXx3C7fi1etFc211KXKKvM3DsfmKR4ih1xj5fd9Bxlel9Ryr8XtBHGeMP7/D7WdGHwWssqu4kZQfXP83Z0JZTjjiz8S4U0/eEzElkjRu1Y8dhmVDx3vn1qMKTGPj0xbz6kCPp8MTC+yiYHCereyYQgJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JUIixCwD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AaYxVNYa; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JUIixCwD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AaYxVNYa"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H5E6R91428842
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 07:04:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fQNtTToqGV4iqPYhKUIsqJXXPCuv1iHkfFdTRqxCiQo=; b=JUIixCwDas5DFYMy
	EDuIAFeBUMMY/9dhI2upXEXxoVyLDhxYr6ONiiqFQkmr4PHCjKApeEs0zs73bqNW
	pwanfaX6myV6EHZyNZR74IG/Pa/sLSeRIuGoobUcb8i4RX/HNkqyiv0W20IpAziF
	Ljonbkl47NZhzpXWzt1fjy8z3oUVQdm0FG3ObsH1ojJD+YnQITc5sPSoGAwyN+nP
	7PYD6sIdin9L6f6ZXYEJ4JFi+DYnIr1kJme/c+6kNGC+9BvihX4zE0j0pAB1M8lg
	vwD3w5wlFGmRvlCPX7giByaVg6wGIbR9X5bR2L8W5RpVFpoOxF5GaoiqhKOkj2QY
	JFg0ag==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxh99bkc8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 07:04:20 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-359fe4e9ea7so4639972a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 00:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773731060; x=1774335860; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fQNtTToqGV4iqPYhKUIsqJXXPCuv1iHkfFdTRqxCiQo=;
        b=AaYxVNYa4stq3qwaM/4kFjEi49URmJn9mC5zrNAWe2kAASn+joszKVnzuPhF6df0IJ
         JDV3SpsbGEvuqflHUSC8nTVxNXD1DW2h6NBpiOMmVWTBjCjOBoPQHla970RVak2gnWsP
         mCEaz8pu2hZpkKrNrNv8rdSK5tAj4bXLi5lCpKfCzMCpJBM6Z0sYkly8iUjhtB6VlXMA
         rTKzAjsFREIEWM3cazyg6iSD3ctjhmbkotqHOaWRFG4IqfA4i+jDZheSG09IJAPjPb1A
         p5TP98jzHcZjEBrAjgA8orsf/6XYN4kCSvKGyUuXoMbOdd8WTiMmBPpaNcrp7lobH6UC
         osSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773731060; x=1774335860;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fQNtTToqGV4iqPYhKUIsqJXXPCuv1iHkfFdTRqxCiQo=;
        b=E8WOwpfBgiTOuOqhN9ZQGkZA8QwhXQwk/GQ3zNVfM1sB/u22Z53cUJue7NdjftgzxF
         JEaDgxhdVI6Wpgw6dKFzfsl8CYjDmH+XWbZ92SRXn39SebEBYSs81zdImCtbiHH1SETR
         9HAbm+qoYcCDpoxAacAtkjqxpmCr75ilq/zj5zD4VyrA+b4D9nsBWB7Lqrrzap48iJ7s
         PMvF6R565cbKgnsosCyOdMjhSBGW5Xm66TpLmt2/dcERj56XcRenfmemIBwMOk1KKtGl
         j6ePjISb7DOMov42PwChC0fbqvC3MIam1k8BXn0evQm9ggJEytLcV5NcFfZ7s0WKizSd
         hLMg==
X-Gm-Message-State: AOJu0YyaLXV24iiPG8t51jocgw/t/hlogzT5XJim2ltvKw1nnINT5R+4
	YHBwhio3EB+qEM06LizufeUBVfgy2VUURfa47kZD3a4H9Vn7yIRegs9cETlYlZSEC+46fBUAKnA
	vsRHht/FbkyXXjnWeHrDGAGrY78hrg75XB9cz6XTtKuqJ5PwzWjT6jKtIHNsa/PpW
X-Gm-Gg: ATEYQzxpAHvq4kdPaGlW51xkgxL7BfvbB2xDM4rjS4YsD1rJ3ZvLM9aerJJnbKxcwlA
	6tgi+V0AZtyt5RjW62U9E6SYEwIGHvvzu4CqwEitCLAzmWu3jRHqL7dmTLszKFoEIdeq9ZHIppH
	N2zQYYdFJ9hrHDmKUmUQltgqeubpkjZhPpmkVSMmlA1xnfhG5Oqwy0/PWSxsZrKkv7k+J5W2y36
	bQZf11DQWB4fyZD77dYdgj/jF6Jcff2cJiHQXBGY4+Q5IbFumR+x18riope5F69mxznt9SR4gch
	4xFqkQNx9kpQrj2Ey28t61SWLO0012iwu3JuPG1Ne2xcZZTDlb9M34nvtXc4Ef1U9JaY9imsWGB
	EaPaSolVnwjlvKOtWktOeT3Sd2MIHKRXAKfIKFcK8CHUGgbPVu+HFRWT2TSpZLl9c9ExcP1h/SY
	qRTRFWSBz+sQ==
X-Received: by 2002:a05:6a20:5499:b0:398:795c:26c7 with SMTP id adf61e73a8af0-398eca24ad9mr14692430637.3.1773731059911;
        Tue, 17 Mar 2026 00:04:19 -0700 (PDT)
X-Received: by 2002:a05:6a20:5499:b0:398:795c:26c7 with SMTP id adf61e73a8af0-398eca24ad9mr14692405637.3.1773731059390;
        Tue, 17 Mar 2026 00:04:19 -0700 (PDT)
Received: from [10.133.33.84] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73ebb6336bsm12409470a12.21.2026.03.17.00.04.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 00:04:19 -0700 (PDT)
Message-ID: <fca5317f-78c5-46d9-b93d-de65a603c395@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 15:04:12 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/12] scsi: ufs: core: Add support for TX Equalization
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com,
        beanhuo@micron.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
 <20260308151409.3779137-5-can.guo@oss.qualcomm.com>
 <c44cc56f-513e-457b-96de-203d4b534496@acm.org>
 <f88d9fc6-4227-4cd3-a124-0e93122e1d85@oss.qualcomm.com>
 <6e07208c-a94b-44dc-8f7e-ccbb0ff8840e@oss.qualcomm.com>
 <16e4ee41-c156-4f09-80cb-e0e7918c87bf@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <16e4ee41-c156-4f09-80cb-e0e7918c87bf@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=RJ++3oi+ c=1 sm=1 tr=0 ts=69b8fcf4 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=utLGG-T327fd-dhq7TkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDA2MCBTYWx0ZWRfX8nPrliO/BDg2
 s8vttrzj9ZtTHhm//Cg886G5n2/25ysXb1UEm7QGmbEHaM61X51R6FVU92JcLqZoM+Qtu0KIGb3
 mGnNWIe2xtKiunojPjnuFVS6UdAc7/hbcg6e7P4RfHurmPKhAlG6XDm2fw9zuOrZmUEft/fHsJ2
 dXmLQxf6EwdQaSII6Wl/4A3F2c4wjdcGyvzYz65pDSCgVwxI7SjntvCJijS+731ICeRK6os3apC
 z5mwz41KnhL83uFjJt8o30fvruxOA20eI3xnrcsqW4SjYQTCT7P+Q/cgW6Gr8NvIHX+vzYhj5gh
 ziuqlltI6RdALnY4qJ45vjNd/N82h5aBmSkaDNBZOOB2d4NiNv0ynZkJaSnkOPdTiqCxvMQHQKu
 RuUWV0qhDzB5ZQnjOdAsLS5nkrYP3JjqZady7olOJbrp2O767VCXPKdX8bkFVHNa7Rio64pbAhO
 r4NM+s6MTTSWSHUxHVA==
X-Proofpoint-ORIG-GUID: Akch-YVnw2yCz1Utwt3gxCq2GtOlGzMJ
X-Proofpoint-GUID: Akch-YVnw2yCz1Utwt3gxCq2GtOlGzMJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 spamscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603170060



On 3/17/2026 12:55 AM, Bart Van Assche wrote:
> On 3/14/26 2:33 AM, Can Guo wrote:
>>
>>
>> On 3/14/2026 4:19 PM, Can Guo wrote:
>>>
>>>
>>> On 3/14/2026 6:19 AM, Bart Van Assche wrote:
>>>> On 3/8/26 8:14 AM, Can Guo wrote:
>>>>> +static int txeq_gear_set(const char *val, const struct 
>>>>> kernel_param *kp)
>>>>> +{
>>>>> +    return param_set_uint_minmax(val, kp, UFS_HS_G1, UFS_HS_G6);
>>>>> +}
>>>>
>>>> Why UFS_HS_G6 instead of UFS_HS_GEAR_MAX?
>>> I will use 'UFS_HS_GEAR_MAX - 1' in next version.
>> On second thought, to make the code more readable and scalable, I 
>> will use UFS_HS_GEAR_MAX
>> here. To achieve so, I am going to tweak the code like below:
>>
>> enum ufs_hs_gear_tag {
>>          UFS_HS_DONT_CHANGE,     /* Don't change Gear */
>>          UFS_HS_G1,              /* HS Gear 1 (default for reset) */
>>          UFS_HS_G2,              /* HS Gear 2 */
>>          UFS_HS_G3,              /* HS Gear 3 */
>>          UFS_HS_G4,              /* HS Gear 4 */
>>          UFS_HS_G5,              /* HS Gear 5 */
>> +      UFS_HS_G6,              /* HS Gear 6 */
>> +      UFS_HS_GEAR_MAX_INVALID,
>> };
>> +
>> + #define UFS_HS_GEAR_MAX         UFS_HS_GEAR_MAX_INVALID - 1
> Will UFS_HS_GEAR_MAX_INVALID be used anywhere? If not, please leave it
> out and add the following past UFS_HS_G6 instead of just
> "UFS_HS_GEAR_MAX":
>
>     UFS_HS_GEAR_MAX = UFS_HS_G6,
OK.

Thanks,
Can Guo.
>
> Thanks,
>
> Bart.

