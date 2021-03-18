Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98365C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 16:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6058664F30
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 16:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhCRQTs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:19:48 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2713 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbhCRQTZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 12:19:25 -0400
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4F1XD659wHz681Cw;
        Fri, 19 Mar 2021 00:14:46 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 18 Mar 2021 17:19:22 +0100
Received: from [10.47.0.142] (10.47.0.142) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Thu, 18 Mar
 2021 16:19:21 +0000
Subject: Re: [PATCH] scsi: libsas: Reset num_scatter if libata mark qc as
 NODATA
To:     Jolly Shah <jollys@google.com>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <a.darwish@linutronix.de>, Jason Yan <yanaijie@huawei.com>,
        <luojiaxing@huawei.com>, <dan.carpenter@oracle.com>,
        <b.zolnierkie@samsung.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210316193905.1673600-1-jollys@google.com>
 <5e2c35b6-a9c4-0637-738b-ff6920635425@huawei.com>
 <CABGCNpDdK2+DNTJpzjig3hX3W_7JB8nEcRcuRnv8Z4oRSq2-dA@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <329a6159-7da6-f60d-b1a5-14648b90f052@huawei.com>
Date:   Thu, 18 Mar 2021 16:17:11 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CABGCNpDdK2+DNTJpzjig3hX3W_7JB8nEcRcuRnv8Z4oRSq2-dA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.0.142]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/03/2021 00:24, Jolly Shah wrote:
> Hi John,
> 
> Thanks for the review.
> 
> 
> On Wed, Mar 17, 2021 at 4:44 AM John Garry <john.garry@huawei.com> wrote:
>>
>> On 16/03/2021 19:39, Jolly Shah wrote:
>>> When the cache_type for the scsi device is changed, the scsi layer
>>> issues a MODE_SELECT command. The caching mode details are communicated
>>> via a request buffer associated with the scsi command with data
>>> direction set as DMA_TO_DEVICE (scsi_mode_select). When this command
>>> reaches the libata layer, as a part of generic initial setup, libata
>>> layer sets up the scatterlist for the command using the scsi command
>>> (ata_scsi_qc_new). This command is then translated by the libata layer
>>> into ATA_CMD_SET_FEATURES (ata_scsi_mode_select_xlat). The libata layer
>>> treats this as a non data command (ata_mselect_caching), since it only
>>> needs an ata taskfile to pass the caching on/off information to the
>>> device. It does not need the scatterlist that has been setup, so it does
>>> not perform dma_map_sg on the scatterlist (ata_qc_issue).
>>
>> So if we don't perform the dma_map_sg() on the sgl at this point, then
>> it seems to me that we should not perform for_each_sg() on it either,
>> right? That is still what happens in sas_ata_qc_issue() in this case.
>>

Hi Jolly Shah,

> 
> Yes that's right. To avoid that, I can add elseif block for
> ATA_PROT_NODATA before for_each_sg() is performed. Currently there's
> existing code block for ATA_PROT_NODATA after for_each_sg()  is
> performed,
> reused that to reset num_scatter. Please suggest.
> 

How about just combine the 2x if-else statements into 1x if-elif-else 
statement, like:


if (ata_is_atapi(qc->tf.protocol)) {
	memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
	task->total_xfer_len = qc->nbytes;
	task->num_scatter = qc->n_elem;
	task->data_dir = qc->dma_dir;
} else if (qc->tf.protocol == ATA_PROT_NODATA) {
	task->data_dir = DMA_NONE;
} else {
	for_each_sg(qc->sg, sg, qc->n_elem, si)
		xfer += sg_dma_len(sg);

	task->total_xfer_len = xfer;
	task->num_scatter = si;
	task->data_dir = qc->dma_dir;
}

>>> Unfortunately,
>>> when this command reaches the libsas layer(sas_ata_qc_issue), libsas
>>> layer sees it as a non data command with a scatterlist. It cannot
>>> extract the correct dma length, since the scatterlist has not been
>>> mapped with dma_map_sg for a DMA operation. When this partially
>>> constructed SAS task reaches pm80xx LLDD, it results in below warning.
>>>
>>> "pm80xx_chip_sata_req 6058: The sg list address
>>> start_addr=0x0000000000000000 data_len=0x0end_addr_high=0xffffffff
>>> end_addr_low=0xffffffff has crossed 4G boundary"
>>>
>>> This patch assigns appropriate value to  num_sectors for ata non data
>>> commands.
>>>
>>> Signed-off-by: Jolly Shah <jollys@google.com>
>>> ---
>>>    drivers/scsi/libsas/sas_ata.c | 6 ++++--
>>>    1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
>>> index 024e5a550759..94ec08cebbaa 100644
>>> --- a/drivers/scsi/libsas/sas_ata.c
>>> +++ b/drivers/scsi/libsas/sas_ata.c
>>> @@ -209,10 +209,12 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
>>>                task->num_scatter = si;
>>>        }
>>>
>>> -     if (qc->tf.protocol == ATA_PROT_NODATA)
>>> +     if (qc->tf.protocol == ATA_PROT_NODATA) {
>>>                task->data_dir = DMA_NONE;
>>> -     else
>>> +             task->num_scatter = 0;
>>
>> task->num_scatter has already been set in this function. Best not set it
>> twice.
>>
> 
> Sure. Please suggest if I should update patch to above suggested
> approach. That will avoid setting num_scatter twice.
> 

Thanks,
John

BTW, could we add a fixes tag?
