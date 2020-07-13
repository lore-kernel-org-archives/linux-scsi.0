Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BCCAC433E4
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 12:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 701CA20738
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 12:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbgGMMU4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 08:20:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:55656 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgGMMU4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jul 2020 08:20:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 78368B1CE;
        Mon, 13 Jul 2020 12:20:54 +0000 (UTC)
Subject: Re: [PATCH RFC v7 07/12] blk-mq: Add support in
 hctx_tags_bitmap_show() for a shared sbitmap
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, ming.lei@redhat.com, bvanassche@acm.org,
        hare@suse.com, hch@lst.de, shivasharan.srikanteshwara@broadcom.com
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        megaraidlinux.pdl@broadcom.com
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-8-git-send-email-john.garry@huawei.com>
 <9f4741c5-d117-d764-cf3a-a57192a788c3@suse.de>
 <aad6efa3-2d7f-ca68-d239-44ea187c8017@huawei.com>
 <7ed6ccf1-6ad9-1df7-f55d-4ed6cac1e08d@suse.de>
 <2de767d0-d472-9101-f805-68194687279a@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <7c918203-804d-f164-fab3-295ef72fcd85@suse.de>
Date:   Mon, 13 Jul 2020 14:20:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <2de767d0-d472-9101-f805-68194687279a@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/20 11:41 AM, John Garry wrote:
> On 12/06/2020 07:06, Hannes Reinecke wrote:
>>>>>
>>>>> +out:
>>>>> +    sbitmap_free(&shared_sb);
>>>>> +    return res;
>>>>> +}
>>>>> +
>>>>>   static int hctx_tags_bitmap_show(void *data, struct seq_file *m)
>>>>>   {
>>>>>       struct blk_mq_hw_ctx *hctx = data;
>>>>> @@ -823,6 +884,7 @@ static const struct blk_mq_debugfs_attr
>>>>> blk_mq_debugfs_hctx_shared_sbitmap_attrs
>>>>>       {"busy", 0400, hctx_busy_show},
>>>>>       {"ctx_map", 0400, hctx_ctx_map_show},
>>>>>       {"tags", 0400, hctx_tags_show},
>>>>> +    {"tags_bitmap", 0400, hctx_tags_shared_sbitmap_bitmap_show},
>>>>>       {"sched_tags", 0400, hctx_sched_tags_show},
>>>>>       {"sched_tags_bitmap", 0400, hctx_sched_tags_bitmap_show},
>>>>>       {"io_poll", 0600, hctx_io_poll_show, hctx_io_poll_write},
>>>>>
>>>> Ah, right. Here it is.
>>>>
>>>> But I don't get it; why do we have to allocate a temporary bitmap
>>>> and can't walk the existing shared sbitmap?
>>>
> 
> Just coming back to this now...
> 
>>> For the bitmap dump - sbitmap_bitmap_show() - it is passed a struct
>>> sbitmap *. So we have to filter into a temp per-hctx struct sbitmap.
>>> We could change sbitmap_bitmap_show() to accept a filter iterator -
>>> which I think you're getting at - but I am not sure it's worth the
>>> change. Or else use the allocated sbitmap for the hctx, as above*,
>>> but I may be remove that (see 4/12 response).
>>>
>> Yes, I do think I would prefer updating sbitmap_bitmap_show() to
>> accept a filter. Especially as Ming Lei has now updated the tag
>> iterators to accept a filter, too, so it should be an easy change.
> 
> Can you please explain how you would use an iterator here?
> 
> In fact, I am half thinking of dropping this patch entirely.
> 
> So I feel that current behavior is a little strange, as some may expect
> /sys/kernel/debug/block/sdX/hctxY/tags_bitmap would only show tags for
> hctxY for sdX, while it is for hctxY for all queues. Same for
> /sys/kernel/debug/block/sdX/hctxY/tags
> 
> And then, for what we have in this patch:
> 
> static void hctx_filter_sb(struct sbitmap *sb, struct blk_mq_hw_ctx *hctx)
> {
> struct hctx_sb_data hctx_sb_data = { .sb = sb, .hctx = hctx };
> 
> blk_mq_queue_tag_busy_iter(hctx->queue, hctx_filter_fn, &hctx_sb_data);
> }
> 
> This will give tags only for this queue. So not the same. So I feel it's
> better to change current behavior (so consistent) or change neither. And
> changing current behavior would also mean we need to change what we show
> in /sys/kernel/debug/block/sdX/hctxY/tags, and that looks troublesome also.
> 
> Opinion?
> 
The whole notion of having sysfs presenting tags per hctx doesn't really
apply anymore when running with shared tags.

We could be sticking with the per-hctx attribute, but then busy tags
won't be displayed correctly as tags might be busy, but not on this hctx.
The alternative idea of projecting everything over to hctx0 (or just
duplicating the output from hctx0) would be technically correct, but
would be missing the per-hctx information.

Ideally we would have some sort of tri-state information here: busy,
busy on other hctx, not busy.
Then the per-hctx attribute would start making sense again.

Otherwise I would just leave it for now.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
