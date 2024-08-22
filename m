Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D15E43165
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 20:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724360109; cv=none; b=p+mLIB4kiAQfhTHoFI8+RzZLdarY16t39MhQWGCHCNdywRR2tH/2aGRO/m6snqhS3cW97zyoBvoWs7OKyHJvRMoHLCta+LmkekUsjlv75tO5DmTAb6B1tUTUCdTLAZXyW0j+BEXcgcR2UZtJSTMLT2sD9AgfRYMN9SrMvMRDXjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724360109; c=relaxed/simple;
	bh=lk/j7QXZxbrcwQpBYZRpIEAXCwrHBx4EgjCJ7r7YiuQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Nkgu2X8HRk3FWJjRMa/yIJTIItGvY5dLW6UGf1Q3H6VYK0gVjKr09fPIoxlob5y1zA08cpgVD0kasHgiWdRtdEIRZraOBpKIDDyP9vMWrGsOGrBmAJ5ygC/zvNO6ypv8LA79qtcaQ4Ktsu5EqPPMlaEYI+4Jl/g6eeHwX6uwQUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=MZnxVgRO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="MZnxVgRO"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47MA15pC009123;
	Thu, 22 Aug 2024 20:54:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7eKurc3ZGeoyznIIPBvuMO7PrxjrUYi1JS4idaQTXc4=; b=MZnxVgROba3S7QYb
	WU8UvvCund97e0/RYkdec51DdKkgmZmAhS3X306E4PNWNBcomLI33k1a3wWHtEcU
	xVrW2gCrRGg6C/xXp1R/nRu6oAKgNrauI6kr1aS+UqeYo4HFj/E2Dfe/avcclzka
	+zCBSTSsCzVC4a1lb1vp16Zz5fHMvkWQ/V2ZyqdM1GyQv/p/kuo84hMIuNoRZER1
	xYOWkIQTnQyTWRdn0qTvHj0L25HIXAE+w2YMIjkRDrvMcHQMfNWjJyW24IJQsaF3
	fpGavgM/0Rj4d0u3IafwGMyX2vwdMue8O1QUMQGhMEQL/NHQ0IAeEVgCR10Cm2IU
	eQACYw==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 414pe5s6t3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Aug 2024 20:54:49 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47MKsmR1032115
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Aug 2024 20:54:48 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 22 Aug
 2024 13:54:47 -0700
Message-ID: <3a455ddb-7dad-cb2c-7b80-ec355221fb0a@quicinc.com>
Date: Thu, 22 Aug 2024 13:54:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
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
        Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <41e5ed21-8ea6-3a4c-2f25-922458593f38@quicinc.com>
 <6e8df17b-320e-4bfc-a0be-c7918b0263d4@acm.org>
 <6fceba57-e1f6-e76b-94f3-1684c1fe6e98@quicinc.com>
 <85481ed2-a911-41a4-8fd4-80e4d20dbf04@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <85481ed2-a911-41a4-8fd4-80e4d20dbf04@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: XDti8fck53HBXN6Nt-p5zspzY9JU6Icf
X-Proofpoint-GUID: XDti8fck53HBXN6Nt-p5zspzY9JU6Icf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-22_14,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 spamscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408220156

On 8/22/2024 11:13 AM, Bart Van Assche wrote:
> On 8/21/24 6:05 PM, Bao D. Nguyen wrote:
>> If I understand correctly, the link is hibernated because we had a 
>> successful ufshcd_uic_hibern8_enter() earlier. Then the 
>> ufshcd_uic_pwr_ctrl() is invoked probably from a power mode change 
>> command? (a callstack would be helpful in this case).
> 
> Hi Bao,
> 
> ufshcd_uic_hibern8_enter() calls ufshcd_uic_pwr_ctrl() directly. The
> former function causes the latter to send the UIC_CMD_DME_HIBER_ENTER
> command. Although UIC_CMD_DME_HIBER_ENTER causes the link to enter the
> hibernation state, the code in ufshcd_uic_pwr_ctrl() for re-enabling
> interrupts causes the UFS host controller that I'm testing to exit the
> hibernation state.
> 
>> Anyway, accessing the UFSHCI host controller registers space somehow 
>> affected the M-PHY link state? If my understanding is correct, it 
>> seems like a hardware issue that we are trying to work around?
> 
> Yes, this is a workaround particular behavior of a particular UFS
> controller.

Thank you for the clarification, Bart.
I am just curious about providing workaround for a hardware issue in the 
ufs core driver. Sometimes I notice the community is not accepting such 
a change and push the change to be implemented in the vendor/platform 
drivers.

Now about your workaround, I have the same concern as Bean.
For a ufshcd_uic_pwr_ctrl() command, i.e PMC, hibern8_enter/exit() 
commands, you will get 2 ufshcd_uic_cmd_compl() interrupts or 1 uic 
completion interrupt with 2 status bits set at once.
a. UIC_COMMAND_COMPL is set
b. and one of these bits UIC_POWER_MODE || UIC_HIBERNATE_EXIT || 
UIC_HIBERNATE_ENTER is set, depending on the completed uic command. 


In your proposed change to ufshcd_uic_cmd_compl(), you are signalling 
both complete(&cmd->done) and complete(hba->uic_async_done) for a single 
ufshcd_uic_pwr_ctrl() command which can cause issues.

Thanks, Bao

> 
> Thanks,
> 
> Bart.
> 

