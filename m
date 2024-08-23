Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD78314A4C3
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 11:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724412416; cv=none; b=eDTlDIMj/dMGGjcRL96xW3dNSMII0rkPRWQ1GahAXLzPvbIo9Vv55grEYiMkG83yQsLowxzNe5WJp7Re3ojZix9ahyfc6gTFN0lHU1yTM4v9jS/P4G4MkF+JEGWGcGZ1u1m5ZOZQt/QBkpEwSB+hYXM3MeaLli/oI1hXfGmAGbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724412416; c=relaxed/simple;
	bh=p5OCLgTc/ZL2wR1XM0/qAo1HRdjvBaxpIdUUwT5Vd98=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Ac8jEo50ffZVN9waF84GTb8vgCWwLsjCDau+gOMGG4asVSQpupIunKNPYoulV5G2QWSeVyHMEE5DWLBxvICG34gQ95zbZ5MZkZCs9Zz2yHLOaQIfKn1BNCdhYjh5wz3BIVTqIZXvrIdCBW3l/zliZM0R3Q7NJPEDGYDptliczjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=kvvr9Adp; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="kvvr9Adp"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47N20sDp008705;
	Fri, 23 Aug 2024 11:26:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GOh6hJKAs5YIZ0cok+0cTAW5NjWAX0v4CtClDuKYWfU=; b=kvvr9Adpa3mlSqKm
	w9C8YGYJTE0cwdcCrStmEpJQF3PfBwjyP5omt2PSEPSuYRIw1B5vPPBgnKYSCC+X
	fUkWhSm8pUiXJrVk+h0BZN+FgaaVPAsS6mlJSXP8tI5MKyfpl7HiEy/sXK5NwqLA
	aI5NAU8ksf4DEiywKrBejRiaogk0sd0iu94RJGbnfLV2AJ24+YViSGHmuqbgzEm6
	Hjxmt3qXxy5CoydpDQnggvdIMNbxFYfOYOzK9prefcEP1+CJrGnG3pbjne+Ft5tF
	mgyOQwoOT5kkR60CJ8GKeV02JsqSn6kJti+EAbSH+NlNnwZaTl2I1X1naK/yV/KF
	It4U+g==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 415gsd6a77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Aug 2024 11:26:35 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47NBQZFs026614
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Aug 2024 11:26:35 GMT
Received: from [10.253.11.23] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Fri, 23 Aug
 2024 04:26:31 -0700
Message-ID: <2f3ebec2-9372-4d6f-b956-2de42b2ddcc5@quicinc.com>
Date: Fri, 23 Aug 2024 19:26:13 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
To: Bean Huo <huobean@gmail.com>, Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Peter Wang
	<peter.wang@mediatek.com>,
        Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>,
        Avri Altman <avri.altman@wdc.com>,
        "Andrew Halaney" <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
        Alim
 Akhtar <alim.akhtar@samsung.com>,
        Eric Biggers <ebiggers@google.com>, Minwoo
 Im <minwoo.im@samsung.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        <quic_nitirawa@quicinc.com>, <quic_mapa@quicinc.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <0e552232c1759ba1749acb9b606a03670bbe1ba1.camel@gmail.com>
 <25ba6504-9a10-4c59-a180-620ddfd06622@acm.org>
 <bb2a1649ef94637f236dece7255d497f7fe03f19.camel@gmail.com>
 <4964ac76-abdd-4cdc-b8d0-3484b3286449@acm.org>
 <8a81431a90c9c0c5bb0c90deba825284bff55d83.camel@gmail.com>
Content-Language: en-US
From: Can Guo <quic_cang@quicinc.com>
In-Reply-To: <8a81431a90c9c0c5bb0c90deba825284bff55d83.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: h6ve3YMYZXt2s3p-QrloJ-H8ne6CVu05
X-Proofpoint-ORIG-GUID: h6ve3YMYZXt2s3p-QrloJ-H8ne6CVu05
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-23_08,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 clxscore=1011 lowpriorityscore=0 impostorscore=0
 mlxscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2407110000 definitions=main-2408230084


On 8/23/2024 6:54 PM, Bean Huo wrote:
> On Thu, 2024-08-22 at 10:51 -0700, Bart Van Assche wrote:
>> On 8/22/24 7:17 AM, Bean Huo wrote:
>>> Do you mean re-enabling UIC complete interrupt will cause the
>>> problem?
>> That's correct. ufshcd_uic_hibern8_enter() calls
>> ufshcd_uic_pwr_ctrl()
>> indirectly. For the test setup that is on my desk, the code in
>> ufshcd_uic_pwr_ctrl() that re-enables the UIC completion interrupt
>> causes the UFS host controller to exit hibernation.

That is a weird UFS host controller behavior.

At least Qcom UFS host controller does not behave like this, because 
accessing the

UFSHCI IRQ register does not require/involve link communication with the 
UFS device.


Thanks,

Can Guo.

>>
>> Thanks,
>>
>> Bart.
>
> Do you think this is only true in your case or for a specific UFS
> controller vendor? and this doesnnot mean that all UFS controller
> vendors have this problem? Maybe MTK has confirmed this.
>
> Kind regards,
> Bean
