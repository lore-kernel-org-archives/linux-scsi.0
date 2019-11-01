Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93279CA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66F2521734
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbfKAQyH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 12:54:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:47246 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728121AbfKAQyH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Nov 2019 12:54:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 80E51AB89;
        Fri,  1 Nov 2019 16:54:05 +0000 (UTC)
Subject: Re: [PATCH 05/24] scsi: use standard SAM status codes
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191031110452.73463-1-hare@suse.de>
 <20191031110452.73463-6-hare@suse.de>
 <8c3245df-97e3-95aa-498f-4ed47db96132@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <74775fd3-3f13-1060-f93a-37db7b859ecd@suse.de>
Date:   Fri, 1 Nov 2019 17:54:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <8c3245df-97e3-95aa-498f-4ed47db96132@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/1/19 5:26 PM, Bart Van Assche wrote:
> On 10/31/19 4:04 AM, Hannes Reinecke wrote:
>> Use standard SAM status codes and omit the explicit shift to convert
>> to linux-specific ones.
> 
> Isn't an explicit shift required to convert *from* linux-specific codes 
> instead of for converting *to* linux-specific ones?
> 
>>   drivers/ata/libata-scsi.c             |  2 +-
>>   drivers/infiniband/ulp/srp/ib_srp.c   |  2 +-
>>   drivers/scsi/3w-9xxx.c                |  5 +++--
>>   drivers/scsi/3w-sas.c                 |  3 ++-
>>   drivers/scsi/3w-xxxx.c                |  4 ++--
>>   drivers/scsi/arcmsr/arcmsr_hba.c      |  4 ++--
>>   drivers/scsi/bfa/bfad_im.c            |  2 +-
>>   drivers/scsi/dc395x.c                 | 18 +++++-------------
>>   drivers/scsi/dpt_i2o.c                |  2 +-
>>   drivers/scsi/gdth.c                   | 12 ++++++------
>>   drivers/scsi/megaraid.c               | 10 +++++-----
>>   drivers/scsi/megaraid/megaraid_mbox.c | 12 ++++++------
>>   drivers/scsi/pcmcia/nsp_cs.c          |  2 +-
>>   13 files changed, 36 insertions(+), 42 deletions(-)
> 
> Should this patch be split into one patch per driver such? If this patch 
> would introduce a regression that will make it easier to address such 
> regressions. Splitting this patch will also make reviewing easier.
> 
If you think it's worthwhile ... sure.
I'm already at 24 patches; splitting this off would get me an additional 
12 patches, all of which are basically one-liners.

>> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
>> index 3337b1e80412..ada77c136f8b 100644
>> --- a/drivers/scsi/3w-9xxx.c
>> +++ b/drivers/scsi/3w-9xxx.c
>> @@ -1018,7 +1018,8 @@ static int twa_fill_sense(TW_Device_Extension 
>> *tw_dev, int request_id, int copy_
>>       if (copy_sense) {
>>           memcpy(tw_dev->srb[request_id]->sense_buffer, 
>> full_command_packet->header.sense_data, TW_SENSE_DATA_LENGTH);
>> -        tw_dev->srb[request_id]->result = 
>> (full_command_packet->command.newcommand.status << 1);
>> +        tw_dev->srb[request_id]->result =
>> +            full_command_packet->command.newcommand.status;
>>           retval = TW_ISR_DONT_RESULT;
>>           goto out;
>>       }
> 
> Does this change preserve the behavior of this LLD?
> 
Hmm. Actually, I don't know; it feels a bit weird having a firmware 
interface returning linux-specific status codes.
I'll do a bit of digging to see if this isn't an error in the driver.

>> diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
>> index dda6fa857709..d11f62c60877 100644
>> --- a/drivers/scsi/3w-sas.c
>> +++ b/drivers/scsi/3w-sas.c
>> @@ -891,7 +891,8 @@ static int twl_fill_sense(TW_Device_Extension 
>> *tw_dev, int i, int request_id, in
>>       if (copy_sense) {
>>           memcpy(tw_dev->srb[request_id]->sense_buffer, 
>> header->sense_data, TW_SENSE_DATA_LENGTH);
>> -        tw_dev->srb[request_id]->result = 
>> (full_command_packet->command.newcommand.status << 1);
>> +        tw_dev->srb[request_id]->result =
>> +            full_command_packet->command.newcommand.status;
>>           goto out;
>>       }
> 
> Same question here.
> 
... and same answer here :-)

>> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
>> index 6b5841b1c06e..e3cbe5d20aca 100644
>> --- a/drivers/scsi/bfa/bfad_im.c
>> +++ b/drivers/scsi/bfa/bfad_im.c
>> @@ -150,7 +150,7 @@ bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s 
>> *dtsk,
>>       struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dtsk;
>>       wait_queue_head_t *wq;
>> -    cmnd->SCp.Status |= tsk_status << 1;
>> +    cmnd->SCp.Status |= tsk_status;
>>       set_bit(IO_DONE_BIT, (unsigned long *)&cmnd->SCp.Status);
>>       wq = (wait_queue_head_t *) cmnd->SCp.ptr;
>>       cmnd->SCp.ptr = NULL;
> 
> Same question here.
> 
Here it's actually obvious; in it's current form SCp.status holds the 
linux status, and it's always shifted back and forth when reading or 
writing it to hardware-related structures.

So yeah, that does warrant a separate patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
