Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F810C4BA15
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 16:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B83E2084E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 16:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgBZQT4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 11:19:56 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2470 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726148AbgBZQTz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 11:19:55 -0500
Received: from lhreml706-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id BB79B224DC2E6F8BCB31;
        Wed, 26 Feb 2020 16:19:53 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml706-cah.china.huawei.com (10.201.108.47) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 26 Feb 2020 16:19:53 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5; Wed, 26 Feb
 2020 16:19:53 +0000
Subject: Re: [PATCH v2 10/11] megaraid_sas: Use Block layer API to check SCSI
 device in-flight IO requests
To:     Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, <linux-scsi@vger.kernel.org>
CC:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>,
        Sankar Patra <sankar.patra@broadcom.com>,
        Sasikumar PC <sasikumar.pc@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
 <1579000882-20246-11-git-send-email-anand.lodnoor@broadcom.com>
 <7ca1562c-7a7a-17c5-2429-9725d465a4a8@suse.de>
 <b5ab348d98b790578325140226f741c8@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <d7119a15-8be8-9fb2-3c50-8b0a6605982d@huawei.com>
Date:   Wed, 26 Feb 2020 16:19:52 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <b5ab348d98b790578325140226f741c8@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml708-chm.china.huawei.com (10.201.108.57) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/01/2020 11:19, Anand Lodnoor wrote:
> Hannes,
>                 Thank you for pointing it out. Will incorporate the suggested
> changes in the upcoming patches.

It doesn't look like this suggested change was incorporated in the end.

So I am rebasing series 
https://lore.kernel.org/linux-block/20191202153914.84722-1-hare@suse.de/, 
and this patch conflicts. But I did think that this was a strange 
change, apart from that.

> Thanks & Regards,
> Anand R.L
> 
> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, January 16, 2020 6:01 PM
> To: Anand Lodnoor<anand.lodnoor@broadcom.com>;linux-scsi@vger.kernel.org
> Cc:kashyap.desai@broadcom.com;sumit.saxena@broadcom.com;
> kiran-kumar.kasturi@broadcom.com;sankar.patra@broadcom.com;
> sasikumar.pc@broadcom.com;shivasharan.srikanteshwara@broadcom.com;
> chandrakanth.patil@broadcom.com
> Subject: Re: [PATCH v2 10/11] megaraid_sas: Use Block layer API to check
> SCSI device in-flight IO requests
> 
> On 1/14/20 12:21 PM, Anand Lodnoor wrote:
>> Remove usage of device_busy counter from driver. Instead of
>> device_busy counter now driver uses 'nr_active' counter of
>> request_queue to get the number of inflight request for a LUN.

Is blk_mq_hw_ctx.nr_active really the same as scsi_device.device_busy?

Thanks,
John

>>
>> Link :https://patchwork.kernel.org/patch/11249297/
>> Signed-off-by: Chandrakanth Patil<chandrakanth.patil@broadcom.com>
>> Signed-off-by: Anand Lodnoor<anand.lodnoor@broadcom.com>
>> ---
>>   drivers/scsi/megaraid/megaraid_sas_fusion.c | 56
>> ++++++++++++++++-------------
>>   1 file changed, 31 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> index 0bdd477..f3b36fd 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> @@ -364,6 +364,35 @@ inline void megasas_return_cmd_fusion(struct
>> megasas_instance *instance,
>>   		instance->max_fw_cmds = instance->max_fw_cmds-1;
>>   	}
>>   }
>> +
>> +static inline void
>> +megasas_get_msix_index(struct megasas_instance *instance,
>> +		       struct scsi_cmnd *scmd,
>> +		       struct megasas_cmd_fusion *cmd,
>> +		       u8 data_arms)
>> +{
>> +	int sdev_busy;
>> +
>> +	/* nr_hw_queue = 1 for MegaRAID */
>> +	struct blk_mq_hw_ctx *hctx =
>> +		scmd->device->request_queue->queue_hw_ctx[0];
>> +
> While this might be true it would be better to use the hctx from the request
> itself:
> 
> struct blk_mq_hw_ctx *hctx = scmd->request->mq_hctx;
> 
> Cheers,
> 
> Hannes
> -- Dr. Hannes Reinecke Teamlead Storage & Networking hare@suse.de	+49 
> 911 74053 688 SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 
> Nürnberg HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

