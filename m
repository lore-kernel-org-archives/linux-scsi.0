Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A581AC04A6A
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Aug 2023 03:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbjHODbR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 23:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbjHOD3H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 23:29:07 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4056C1998;
        Mon, 14 Aug 2023 20:20:26 -0700 (PDT)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37F2jVv8014065;
        Tue, 15 Aug 2023 03:20:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=qLGJnULZaClH4RdURETjhaMgqIBINYf3tTBguvmLEYY=;
 b=SAkg128iXHr4uXS231k2H46+Tv/qe6VbqhWgeiXFTO7hF+TPLEPuGOz4scYGzoUFVguv
 D26HDt+MlLOVMJ2cTAVK+dlQDiGhEriH5gCvfImyvpqPJzRMNA17pUexu5FQuaFFzpaW
 lD0WmVuOaydYczp5KXem6vjbvqGQlH4I1jg0roOaQxBOjta4bbZ3EY7SPHUtUXTFh4H0
 BKeeZQpMvnLi0lCQRvwm2aRaQmA0+etB5yzB+ySSIJDRtLijX8jviDzvWwEn5Wij4Azu
 Qss4OAN7rcmNlQ+hmYXtB6Z+CT7b2i32IusAH6DOUaMUBbrfx2wMEpyNWL10zckqxwRR wA== 
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sfxbyg7wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 03:20:07 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37F3K5tZ018030
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 03:20:05 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.30; Mon, 14 Aug
 2023 20:20:04 -0700
Message-ID: <1c6dfd06-088d-7b3a-af01-b8c553f9fa18@quicinc.com>
Date:   Mon, 14 Aug 2023 20:20:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 9/9] scsi: ufs: Inform the block layer about write
 ordering
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Can Guo" <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Damien Le Moal" <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bean Huo" <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Arthur Simchaev" <Arthur.Simchaev@wdc.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-10-bvanassche@acm.org>
 <668f296c-48f3-02ef-5ac1-30131579ea8d@quicinc.com>
 <4b3d0fa7-cccb-b206-e48a-c5ee48560ea4@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <4b3d0fa7-cccb-b206-e48a-c5ee48560ea4@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: FMgEPhOAHe2TGuLDmlh1fpTLbzeDipcd
X-Proofpoint-ORIG-GUID: FMgEPhOAHe2TGuLDmlh1fpTLbzeDipcd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-15_01,2023-08-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308150028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/2023 9:23 AM, Bart Van Assche wrote:
> On 8/12/23 10:09, Bao D. Nguyen wrote:
>> I am not reviewing other patches in this series, so I don't know the 
>> whole context. Here is my comment on this patch alone.
>>
>> Looks like you rely on ufshcd_auto_hibern8_update() being invoked so 
>> that you can update the driver_preserves_write_order. However, the 
>> hba->ahit value can be updated by the vendor's driver, and 
>> ufshcd_auto_hibern8_enable() can be invoked without 
>> ufshcd_auto_hibern8_update(). Therefore, you may have a situation 
>> where the driver_preserves_write_order is true by default, but 
>> Auto-hibernation is enabled by default.
> 
> Hi Bao,
> 
> Other than setting a default value for auto-hibernation, vendor drivers
> must not modify the auto-hibernation settings.
IMO, it is not a good solution to prohibit changing auto-hibernation 
settings during runtime. I can think of a few situations where changing 
this parameter may help the system such as:
- Reduce heat. The device may be hot, so hibernate often helps.
- Battery is low, so hibernate quicker to save battery.
- Allows the vendor to make decision whether to trade performance for 
power, or vice versa. Sometimes, the system can afford trading 
performance for power saving.

How about this?
- Make ufshcd_auto_hibern8_enable() a static function. It should not be 
called from the vendor drivers.
- Mandate that vendor drivers must only update auto-hibernation settings 
via the ufshcd_auto_hibern8_update() api. This function is already 
exported, so only need to update the function comment to make it clear 
(updating the hba->ahit alone may result in abnormal behavior).

Thanks,
Bao


> 
> ufshcd_auto_hibern8_enable() calls from outside 
> ufshcd_auto_hibern8_update() are used to reapply auto-hibernation
> settings and not to modify auto-hibernation settings.
> 
> So I think that integrating the following change on top of this patch is
> sufficient:
> 
> @@ -5172,7 +5172,9 @@ static int ufshcd_slave_configure(struct 
> scsi_device *sdev)
> 
>       ufshcd_hpb_configure(hba, sdev);
> 
> -    q->limits.driver_preserves_write_order = true;
> +    q->limits.driver_preserves_write_order =
> +        !ufshcd_is_auto_hibern8_supported(hba) ||
> +        FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) == 0;
Yes, this should help.

>       blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
>       if (hba->quirks & UFSHCD_QUIRK_4KB_DMA_ALIGNMENT)
>           blk_queue_update_dma_alignment(q, SZ_4K - 1);
> 
> Thanks,
> 
> Bart.
> 

