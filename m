Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59562C33CB6
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 17:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34E5F24787
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 17:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406190AbgAPRpZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:45:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:40788 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729991AbgAPRpZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jan 2020 12:45:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CBBC9AF2C;
        Thu, 16 Jan 2020 17:45:21 +0000 (UTC)
Subject: Re: [PATCH 09/11] megaraid_sas: switch fusion adapters to MQ
To:     John Garry <john.garry@huawei.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20191202153914.84722-1-hare@suse.de>
 <20191202153914.84722-10-hare@suse.de>
 <CAL2rwxqjiRTuZ0ntfaHHzG7z-VmxRQCXYyxZeX9eDMrmX+dbGg@mail.gmail.com>
 <efe9c1e7-fa10-3bae-eacd-58d43295d6da@suse.de>
 <CAL2rwxotoWakFS4DPe85hZ4VAgd_zw8pL+B5ckHR9NwEf+-L=g@mail.gmail.com>
 <11034edd-732a-3dd5-0bdc-891b9de05e56@huawei.com>
 <661fd3db-0254-c209-8fb3-f3aa35bac431@suse.de>
 <f3102e65-4201-bf4f-7127-a1e85b18ab59@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <6684b87d-a8e0-3524-b381-6bc26b5456f8@suse.de>
Date:   Thu, 16 Jan 2020 18:45:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <f3102e65-4201-bf4f-7127-a1e85b18ab59@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/16/20 4:47 PM, John Garry wrote:
> 
>>>>
>>>> Hi Hannes,
>>>>
>>>> Sorry for the delay in replying, I observed a few issues with this
>>>> patchset:
>>>>
>>>> 1. "blk_mq_unique_tag_to_hwq(tag)" does not return MSI-x vector to
>>>> which IO submitter CPU is affined with. Due to this IO submission and
>>>> completion CPUs are different which causes performance drop for low
>>>> latency workloads.
>>>
>>> Hi Sumit,
>>>
>>> So the new code has:
>>>
>>> megasas_build_ldio_fusion()
>>> {
>>>
>>> cmd->request_desc->SCSIIO.MSIxIndex =
>>> blk_mq_unique_tag_to_hwq(tag);
>>>
>>> }
>>>
>>> So the value here is hw queue index from blk-mq point of view, and not
>>> megaraid_sas msix index, as you alluded to.
>>>
>>> So we get 80 msix, 8 are reserved for low_latency_index_start (that's
>>> how it seems to me), and we report other 72 as #hw queues = 72 to SCSI
>>> midlayer.
>>>
>>> So I think that this should be:
>>>
>>> cmd->request_desc->SCSIIO.MSIxIndex =
>>> blk_mq_unique_tag_to_hwq(tag) + low_latency_index_start;
>>>
>>>
>> Indeed, that sounds reasonable.
>> (The whole queue mapping stuff isn't exactly well documented :-( )
>>
> 
> Yeah, there's certainly lots of knobs and levers in this driver.
> 
>> I'll be updating the patch.
> 
> About this one:
> 
>  > 2. Seeing below stack traces/messages in dmesg during driver unload –
>  >
>  > [2565601.054366] Call Trace:
>  > [2565601.054368]  blk_mq_free_map_and_requests+0x28/0x50
>  > [2565601.054369]  blk_mq_free_tag_set+0x1d/0x90
>  > [2565601.054370]  scsi_host_dev_release+0x8a/0xf0
>  > [2565601.054370]  device_release+0x27/0x80
>  > [2565601.054371]  kobject_cleanup+0x61/0x190
>  > [2565601.054373]  megasas_detach_one+0x4c1/0x650 [megaraid_sas]
>  > [2565601.054374]  pci_device_remove+0x3b/0xc0
>  > [2565601.054375]  device_release_driver_internal+0xec/0x1b0
>  > [2565601.054376]  driver_detach+0x46/0x90
>  > [2565601.054377]  bus_remove_driver+0x58/0xd0
>  > [2565601.054378]  pci_unregister_driver+0x26/0xa0
>  > [2565601.054379]  megasas_exit+0x91/0x882 [megaraid_sas]
>  > [2565601.054381]  __x64_sys_delete_module+0x16c/0x250
>  > [2565601.054382]  do_syscall_64+0x5b/0x1b0
>  > [2565601.054383]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>  > [2565601.054383] RIP: 0033:0x7f7212a82837
>  > [2565601.054384] RSP: 002b:00007ffdfa2dcea8 EFLAGS: 00000202 ORIG_RAX:
>  > 00000000000000b0
>  > [2565601.054385] RAX: ffffffffffffffda RBX: 0000000000b6e2e0 RCX:
>  > 00007f7212a82837
>  > [2565601.054385] RDX: 00007f7212af3ac0 RSI: 0000000000000800 RDI:
>  > 0000000000b6e348
>  > [2565601.054386] RBP: 0000000000000000 R08: 00007f7212d47060 R09:
>  > 00007f7212af3ac0
>  > [2565601.054386] R10: 00007ffdfa2dcbc0 R11: 0000000000000202 R12:
>  > 00007ffdfa2dd71c
>  > [2565601.054387] R13: 0000000000000000 R14: 0000000000b6e2e0 R15:
>  > 0000000000b6e010
>  > [2565601.054387] ---[ end trace 38899303bd85e838 ]---
> 
> 
> I see it also for hisi_sas_v3_hw.
> 
> And so I don't understand the code change here, specifically where the 
> WARN is generated:
> 
> void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>               unsigned int hctx_idx)
> {
>      struct page *page;
>      int i;
> 
>      if (tags->rqs) {
>          for (i = 0; i < tags->nr_tags; i++)
>              if (WARN_ON(tags->rqs[i]))
>                  tags->rqs[i] = NULL; <--- here
>      }
> 
> 
> I thought that tags->rqs[i] was just a holder for a pointer to a static 
> tag, like assigned here:
> 
> static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
> unsigned int tag, unsigned int op, u64 alloc_time_ns)
> {
>      struct blk_mq_tags *tags = blk_mq_tags_from_data(data);
>      struct request *rq = tags->static_rqs[tag];
> 
>      ...
> 
>      rq->tag = tag;
>      rq->internal_tag = -1;
>      data->hctx->tags->rqs[rq->tag] = rq;
> 
>      ...
> }
> 
> So I don't know why we need to WARN if unset, and then also clear it. 
> The memory is freed pretty soon after this anyway.
> 
Indeed, ->rqs is a holder, referencing an entry in ->static_rqs.
Point here is that ->rqs is set when allocating a request, and should be 
zeroed when freeing the request.
And then this above patch would warn us if there's an imbalance, ie an 
allocated request didn't get freed.
But apparently the latter part didn't happen, leaving us with stale 
entries in ->rqs.
Either we fix that, or we drop the WARN_ON.
Personally I like clearing of the ->rqs pointer (as then it's easier to 
track use-after-free issues), but then this might have performance 
implications, and Jens might have some views about it.
So I'm fine with dropping it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
