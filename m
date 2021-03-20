Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F77C433C1
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 12:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8DF861973
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 12:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhCTMR3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Mar 2021 08:17:29 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2722 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhCTMRH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Mar 2021 08:17:07 -0400
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4F2flZ10yKz67yxJ;
        Sat, 20 Mar 2021 20:12:26 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sat, 20 Mar 2021 13:17:05 +0100
Received: from [10.210.166.185] (10.210.166.185) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sat, 20 Mar 2021 12:17:03 +0000
Subject: Re: [PATCH v2] scsi: libsas: Reset num_scatter if libata mark qc as
 NODATA
To:     Jason Yan <yanaijie@huawei.com>, Jolly Shah <jollys@google.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <a.darwish@linutronix.de>, <luojiaxing@huawei.com>,
        <dan.carpenter@oracle.com>, <b.zolnierkie@samsung.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210318225632.2481291-1-jollys@google.com>
 <5e7ea537-86ab-f654-1df4-765364116e18@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <993f97da-01f0-262b-3fbe-66fa1769698a@huawei.com>
Date:   Sat, 20 Mar 2021 12:14:52 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <5e7ea537-86ab-f654-1df4-765364116e18@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.210.166.185]
X-ClientProxiedBy: lhreml735-chm.china.huawei.com (10.201.108.86) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/03/2021 01:43, Jason Yan wrote:
> 
> 
> 在 2021/3/19 6:56, Jolly Shah 写道:
>> When the cache_type for the scsi device is changed, the scsi layer
>> issues a MODE_SELECT command. The caching mode details are communicated
>> via a request buffer associated with the scsi command with data
>> direction set as DMA_TO_DEVICE (scsi_mode_select). When this command
>> reaches the libata layer, as a part of generic initial setup, libata
>> layer sets up the scatterlist for the command using the scsi command
>> (ata_scsi_qc_new). This command is then translated by the libata layer
>> into ATA_CMD_SET_FEATURES (ata_scsi_mode_select_xlat). The libata layer
>> treats this as a non data command (ata_mselect_caching), since it only
>> needs an ata taskfile to pass the caching on/off information to the
>> device. It does not need the scatterlist that has been setup, so it does
>> not perform dma_map_sg on the scatterlist (ata_qc_issue). Unfortunately,
>> when this command reaches the libsas layer(sas_ata_qc_issue), libsas
>> layer sees it as a non data command with a scatterlist. It cannot
>> extract the correct dma length, since the scatterlist has not been
>> mapped with dma_map_sg for a DMA operation. When this partially
>> constructed SAS task reaches pm80xx LLDD, it results in below warning.
>>
>> "pm80xx_chip_sata_req 6058: The sg list address
>> start_addr=0x0000000000000000 data_len=0x0end_addr_high=0xffffffff
>> end_addr_low=0xffffffff has crossed 4G boundary"
>>
>> This patch updates code to handle ata non data commands separately so
>> num_scatter and total_xfer_len remain 0.
>>
>> Fixes: 53de092f47ff ("scsi: libsas: Set data_dir as DMA_NONE if libata 
>> marks qc as NODATA")
>> Signed-off-by: Jolly Shah <jollys@google.com>

Reviewed-by: John Garry <john.garry@huawei.com>

@luojiaxing, can you please test this?

>> ---
>> v2:
>> - reorganized code to avoid setting num_scatter twice
>>
>>   drivers/scsi/libsas/sas_ata.c | 9 ++++-----
>>   1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_ata.c 
>> b/drivers/scsi/libsas/sas_ata.c
>> index 024e5a550759..8b9a39077dba 100644
>> --- a/drivers/scsi/libsas/sas_ata.c
>> +++ b/drivers/scsi/libsas/sas_ata.c
>> @@ -201,18 +201,17 @@ static unsigned int sas_ata_qc_issue(struct 
>> ata_queued_cmd *qc)
>>           memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
>>           task->total_xfer_len = qc->nbytes;
>>           task->num_scatter = qc->n_elem;
>> +        task->data_dir = qc->dma_dir;
>> +    } else if (qc->tf.protocol == ATA_PROT_NODATA) {
>> +        task->data_dir = DMA_NONE;
> 
> Hi Jolly & John,
> 
> We only set DMA_NONE for ATA_PROT_NODATA, I'm curious about why 
> ATA_PROT_NCQ_NODATA and ATAPI_PROT_NODATA do not need to set DMA_NONE?

So we can see something like atapi_eh_tur() -> ata_exec_internal(), 
which is a ATAPI NONDATA and has DMA_NONE, so should be ok.

Other cases, like those using the xlate function on the qc for 
ATA_PROT_NCQ_NODATA, could be checked further.

For now, we're just trying to fix the fix.

> 
> Thanks,
> Jason
> 
> 
>>       } else {
>>           for_each_sg(qc->sg, sg, qc->n_elem, si)
>>               xfer += sg_dma_len(sg);
>>           task->total_xfer_len = xfer;
>>           task->num_scatter = si;
>> -    }
>> -
>> -    if (qc->tf.protocol == ATA_PROT_NODATA)
>> -        task->data_dir = DMA_NONE;
>> -    else
>>           task->data_dir = qc->dma_dir;
>> +    }
>>       task->scatter = qc->sg;
>>       task->ata_task.retry_count = 1;
>>       task->task_state_flags = SAS_TASK_STATE_PENDING;
>>
> .

