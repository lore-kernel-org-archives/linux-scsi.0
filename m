Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA37181CEF;
	Wed, 26 Jun 2024 13:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719407910; cv=none; b=JvtBG5x4eZZzaS/HzI0kReK6bEIBk2ZNOL2IpUrXiqSJZFztpMDcps6BtBbX2oBCXxlhjA9/A7NNF3ed/jHNl1sRvcLRfBnWp+1VnLcbkrqp3M0Cwc7Jvqp26HCekGNZ8G/dsRl8kXiUUeHdmRszJqLZ9pEe7ZX206sCTSi48ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719407910; c=relaxed/simple;
	bh=LnJ4BdBatnaKJIt8DTZVCb92CAvzC0dTStPyroTM/vc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=NH4hSczJPyb0bUzLWPr636VsRyBsdod4d1pvO48muo7oaWPtnln711pmUigowdKXW08M407FxcN+8Ed94+tkPHN4Z5f58h+jePPZhxxBjxFoVNkD+52ffQfxvSy51900Eedv8v8tmrjSUeBwkMJfvxea1KMmMHEwAm/dtP1c1wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=duf1TmKr; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="duf1TmKr"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45QAfUmK015158;
	Wed, 26 Jun 2024 13:18:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DK9j4PGjY2UmCnvRToOqo/sLZ+R/jph7j04TEirCL6s=; b=duf1TmKrLXk3ZFis
	BMCwHZsGpJ70zHd6N45JcK2fPq0JDD5GuAcdWNxH3yoifvR4OTMMUPlF0R5SudZ3
	d3zr2vxdPaddhFMoj9MxhBD2mL+GtWatuPwc47uvfEu1EX+XHbfjga1u9GivxRIw
	HYFoUZUHIGNGfvFMUEfrA3BWZmmH3ntdj9YInca8sB80ppSfhosR2ln8K0wJkSrT
	35SKUbYtypx6UAwOP0XZfW800opwJ5Oo88aRVzaMEIr+2Mdmc+Tcr6Yqy6NSSAsU
	uI250nr8iIZofrlSdKYCQz+aqwua/lA0qWYfTnESOgrVWYlHY15i1nxdmoj95J4B
	KJvioQ==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ywqshsra7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 13:18:13 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA05.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45QDICdf002339
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 13:18:12 GMT
Received: from [10.239.155.136] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 26 Jun
 2024 06:18:08 -0700
Message-ID: <272184ed-2fd8-413a-816c-9470bf9332da@quicinc.com>
Date: Wed, 26 Jun 2024 21:18:04 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: quiesce request queues before check
 pending cmds
To: Bart Van Assche <bvanassche@acm.org>,
        =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "quic_rampraka@quicinc.com" <quic_rampraka@quicinc.com>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
        "beanhuo@micron.com"
	<beanhuo@micron.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "junwoo80.lee@samsung.com" <junwoo80.lee@samsung.com>,
        "mani@kernel.org"
	<mani@kernel.org>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>,
        "quic_asutoshd@quicinc.com"
	<quic_asutoshd@quicinc.com>,
        "quic_mnaresh@quicinc.com"
	<quic_mnaresh@quicinc.com>,
        "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
References: <1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com>
 <d3fc4d2b-81b0-4ab2-9606-5f4a5fb8b867@acm.org>
 <efc80348-46c0-4307-a363-a242a7b44d94@quicinc.com>
 <b1173b6f-445c-4d6d-9c78-b0351da2893a@acm.org>
 <ee45ce9429b1f69147c1a01e07b050275b4009bf.camel@mediatek.com>
 <3c7e776e-df2e-4718-995f-5e5dfa3cc916@acm.org>
Content-Language: en-US
From: Ziqi Chen <quic_ziqichen@quicinc.com>
In-Reply-To: <3c7e776e-df2e-4718-995f-5e5dfa3cc916@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: t0o3G9yz7_cq_Ga1aXwpg19sBXPty3gt
X-Proofpoint-GUID: t0o3G9yz7_cq_Ga1aXwpg19sBXPty3gt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-26_07,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 bulkscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2406260099



On 6/26/2024 12:13 AM, Bart Van Assche wrote:
> On 6/24/24 8:38 PM, Peter Wang (王信友) wrote:
>> But ufshcd_scsi_block_requests usage is correct in SDR mode.
> 
> ufshcd_scsi_block_requests() uses scsi_block_requests(). It is almost
> never correct to use scsi_block_requests() in a blk-mq driver because
> scsi_block_requests() does not wait for ongoing request submission
> calls to complete. scsi_block_requests() is a legacy from the time when
> all request dispatching and queueing was protected by the SCSI host
> lock, a change that was made in 2010 or about 14 years ago. See also
> https://lore.kernel.org/linux-scsi/20101105002409.GA21714@havoc.gtf.org/
> 
>> So, I think ufshcd_wait_for_doorbell_clr should be revise.
>> Check tr_doorbell in SDR mode. (before 8d077ede48c1 do)
>> Check each HWQ's are all empty in MCQ mode. (need think how to do)
>> Make sure all requests is complete, and finish this function' job
>> correctly.
>> Or there still have a gap in ufshcd_wait_for_doorbell_clr.
> 
> ufshcd_wait_for_doorbell_clr() should be removed and 
> ufshcd_clock_scaling_prepare() should use blk_mq_freeze_*().
> See also my patch "ufs: Simplify the clock scaling mechanism
> implementation" from 5 years ago 
> (https://lore.kernel.org/linux-scsi/20191112173743.141503-5-bvanassche@acm.org/).
> 
The defect of blk_mq_freeze_*() is that it would bring in significant 
latency and performance regression. I don't think it is what many people 
want to see.

BRs,
Ziqi

> Best regards,
> 
> Bart.
