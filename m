Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557C2EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Aug 2023 09:11:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbjHGJLD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 05:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjHGJLC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 05:11:02 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84121E6C;
        Mon,  7 Aug 2023 02:11:01 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3778ZLgI012753;
        Mon, 7 Aug 2023 09:10:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=yThY566GT6ogsFbeuR/k0d8GogwCb501Mia32jVcASw=;
 b=XdMgNAjYew21I//lCnB57JZN7spa9djFaBAWLNw6JiyPprM8iJopo2nlmlcrn6j5s1FQ
 g/U0RKOgsjyIdcVzRWQ4t3jq0PN6ry8GoqIJZmcZsYr1/k5gGIEW6irDFXKQB0Hw4FvI
 b/PCQkc30l6M0/FplvRVN5WRiWdQDatn/6Nmc0TWIP5j76cqReCnAe0SVBy786Gh1vhj
 7sRTTl1ammBQx34EWV1SoylmRA2KsUClnhQywFQoiH9c2CyfgTI4PcSgHOdx/r2GqG4k
 dWwTBmtKQDakMM+ucbL1ueht4HiTzIXxgjvrhUnmCXXdROZwHecsZZ89rFOxEhG8rQth Ng== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3s9fqfax6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Aug 2023 09:10:32 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3779AVIL005991
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 7 Aug 2023 09:10:31 GMT
Received: from [10.253.14.51] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.30; Mon, 7 Aug
 2023 02:10:27 -0700
Message-ID: <dae8266c-ea52-f421-ec44-077cf4b033f8@quicinc.com>
Date:   Mon, 7 Aug 2023 17:10:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v6 6/7] scsi: ufs: Split an if-condition
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Avri Altman" <avri.altman@wdc.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Stanley Chu" <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20230804154821.3232094-1-bvanassche@acm.org>
 <20230804154821.3232094-7-bvanassche@acm.org>
From:   Can Guo <quic_cang@quicinc.com>
In-Reply-To: <20230804154821.3232094-7-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 4PKjqTppo55k8w1Z8ScapNEynNN0IH60
X-Proofpoint-ORIG-GUID: 4PKjqTppo55k8w1Z8ScapNEynNN0IH60
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_06,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 clxscore=1011 suspectscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308070085
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 8/4/2023 11:48 PM, Bart Van Assche wrote:
> Make the next patch in this series easier to read. No functionality is
> changed.
>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 129446775796..ae7b868f9c26 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4352,8 +4352,9 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
>   	}
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
>   
> -	if (update &&
> -	    !pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
> +	if (!update)
> +		return;
> +	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
>   		ufshcd_rpm_get_sync(hba);
>   		ufshcd_hold(hba);
>   		ufshcd_auto_hibern8_enable(hba);
Reviewed-by: Can Guo <quic_cang@quicinc.com>
