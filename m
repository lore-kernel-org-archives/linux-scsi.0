Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4633D9449
	for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 05:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714368773; cv=none; b=FH33snHB2WpI1aM21cnKEj0fm/ltdjixmnq3moJooYsYqWYl/93tPgoJBz7xcAZMgYxEZ7+4V5vjv7MwDvImoZlnK79P80D/wGbvDXr8DLZxYpSzTBVJEMsiim9Nu8MS30RDviwFRbU+uX2xjeSIejw14Ih9YFxlF21uczCx0Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714368773; c=relaxed/simple;
	bh=cGC9l+MrRE5sqvYyYQlGKM/FjfiGLdS+vExxrYcgFgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YaX2c5DrEhNa/Gn7NAvdS0P5ES7GflhqKySrQEttQQWwzu1vwFEzJqBzAprgkjRM51+Vp4zgTc4f/tNLp9pjKcAOp8S1KWhwSnVVm2K6NijDNymJJXW47fqQp3fLC4Ti3MUw+DMX1tGiTUQl8M58buZDyFS95pzH5GpChDW92z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=UOjj1mB9; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="UOjj1mB9"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 43T4bKWw022283;
	Mon, 29 Apr 2024 05:32:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	qcppdkim1; bh=Ht/MFyXNDUabN91ycQWGe0F3ru4RrnUlsaTDPw6gMbo=; b=UO
	jj1mB9C04MVkBa/Sfknkgau2dW5Q+D1eC4NBrSPRtig5+r9cjmSvbK1vHm8X6fxN
	jCkHkXhMfL5Qg51xNs4rhRTNtJUGPfTUQtLS9697nf5w/xOJD1Rrn8FZSoS7kFrF
	hMHOeZR9EjKzgj4zXCNJbZR5lBu9Eq2R4TYVeaGKvotOtnqNRWV0JqOikSuz5ROl
	22z2BkaA1SRQ6AtbO5eUPrYnt60K0Zg7ChOnhLDeTC+x2+emhcYMFV7fCFbFi5g5
	ouFklm2ZIB/FVPxX9Bc3LP+GnA6mk+DW/TYieCz0kkBKZgsWvZoNHJpdPnMwM5Bz
	E5NTiLWy+EElXmPswu6A==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3xrravjv1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 05:32:44 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 43T5Wh6h015084
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 05:32:43 GMT
Received: from [10.216.15.162] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sun, 28 Apr
 2024 22:32:39 -0700
Message-ID: <45a050ca-3ff3-5235-283a-72d8f92aba65@quicinc.com>
Date: Mon, 29 Apr 2024 11:02:34 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/1] Revert "scsi: ufs: core: Only suspend clock scaling
 if scaling down"
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
        "quic_sartgarg@quicinc.com" <quic_sartgarg@quicinc.com>,
        "quic_bhaskarv@quicinc.com" <quic_bhaskarv@quicinc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "quic_narepall@quicinc.com" <quic_narepall@quicinc.com>,
        "quic_pragalla@quicinc.com" <quic_pragalla@quicinc.com>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>
References: <20240228053421.19700-1-quic_rampraka@quicinc.com>
 <a585c5a82fdb36b543d48568d0c5ae1265642f26.camel@mediatek.com>
 <bd253a59-de58-2184-a818-82ef1ed8c962@quicinc.com>
 <768897ca7336df5b159c7d39e467b5b74f49b3b4.camel@mediatek.com>
 <2d0c0aee-0dcb-7ac3-907c-ee477d5fc376@quicinc.com>
 <5e71880541ad80f545f045816ab9f13d4a89003a.camel@mediatek.com>
Content-Language: en-US
From: Ram Prakash Gupta <quic_rampraka@quicinc.com>
In-Reply-To: <5e71880541ad80f545f045816ab9f13d4a89003a.camel@mediatek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 6AIlESQ-7RNpcjYeiuYIC-s-WUMbRx_g
X-Proofpoint-ORIG-GUID: 6AIlESQ-7RNpcjYeiuYIC-s-WUMbRx_g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-29_02,2024-04-26_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2404010003
 definitions=main-2404290035



On 4/25/2024 6:45 PM, Peter Wang (王信友) wrote:
> On Wed, 2024-04-24 at 14:44 +0530, Ram Prakash Gupta wrote:
>>
>> Hi Peter,
>>
>> I tried different dvfs settings, none is helping including enlarged
>> polling period time, its degrading perf numbers as its taking longer
>> time to scale up when the load is high and clk is low.
>>
>> I checked from power side on qualcomm boards, suspending with zero
>> request is not impacting power hence I am consider a vops to add
>> which
>> can help your use case too, I tested this vops and it works fine on
>> qualcomm boards.
>>
>> here is a small snippet of a different approach using vops, which I
>> am
>> planning to push under a separate mail subject to remove this
>> deadlock
>> between mediatek and qualcomm, scaling config.
>>
>> -       if (sched_clk_scaling_suspend_work && !scale_up)
>> +       if (sched_clk_scaling_suspend_work &&
>> hba->clk_scaling.no_req_suspend)
>> +               queue_work(hba->clk_scaling.workq,
>> +                          &hba->clk_scaling.suspend_work);
>>
> 
> Hi Ram,
> 
> It is weird for me that if no_req_suspend is true, queue suspend work?
> Dosen't "no_req_suspend" simply mean "do not suspend"?
> 
> Thanks
> Peter

Hi Peter,

well I intended to shorthand the naming of macro for "no request 
suspend", meaning suspend when there is no request, which I want to 
control in the scaling logic.

I am open to suggestion on name of the variable if you suggest any other 
meaningful name.

and earlier the logic was, scaling was getting suspended when there were 
no request, that we would like to keep via vops for qcom board, rest 
everyone can use the default existing logic.

Thanks,
Ram
> 
> 
> 
>> +       else if (sched_clk_scaling_suspend_work && !scale_up)
>>
>> Here no_req_suspend would be false by default, so would hit else if
>> case, which is desirable for mediatek boards. For qualcomm,
>> no_req_suspend would set it to true via vops. please let me know if
>> this
>> is ok for you.
>>
>> Thanks,
>> Ram
