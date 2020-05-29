Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75522C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 13:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A077207F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 13:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgE2NRF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 09:17:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:46924 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgE2NRE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 May 2020 09:17:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 835C0AD18;
        Fri, 29 May 2020 13:17:02 +0000 (UTC)
Subject: Re: [PATCH 3/4] scsi: move target device list to xarray
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200528163625.110184-1-hare@suse.de>
 <20200528163625.110184-4-hare@suse.de>
 <a6b85428-f32c-e57b-fa3e-e376400819ac@interlog.com>
 <20200528185402.GP17206@bombadil.infradead.org>
 <c33c3000-caac-4b51-42fd-d6e13a9fd641@suse.de>
 <20200529002056.GS17206@bombadil.infradead.org>
 <8c84ac5f-f64a-0372-5738-fb49f2d01c91@suse.de>
 <20200529112107.GT17206@bombadil.infradead.org>
 <6ed49962-479e-ced7-16b4-095c8f5f70d6@suse.de>
 <20200529125022.GA19604@bombadil.infradead.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7e9893bb-5445-7d71-205b-e22f256c8796@suse.de>
Date:   Fri, 29 May 2020 15:17:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200529125022.GA19604@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/29/20 2:50 PM, Matthew Wilcox wrote:
> On Fri, May 29, 2020 at 02:46:48PM +0200, Hannes Reinecke wrote:
>> On 5/29/20 1:21 PM, Matthew Wilcox wrote:
>>> On Fri, May 29, 2020 at 08:50:21AM +0200, Hannes Reinecke wrote:
>>>>> I meant just use xa_alloc() for everything instead of using xa_insert for
>>>>> 0-255.
>>>>>
>>>> But then I'll have to use xa_find() to get to the actual element as the 1:1
>>>> mapping between SCSI LUN and array index is lost.
>>>> And seeing that most storage arrays will expose only up to 256 LUNs I
>>>> thought this was a good improvement on lookup.
>>>> Of course, this only makes sense if xa_load() is more efficient than
>>>> xa_find(). If not then of course it's a bit futile.
>>>
>>> xa_load() is absolutely more efficient than xa_find().  It's just a
>>> question of whether it matters ;-)  Carry on ...
>>>
>> Thanks. I will.
>>
>> BTW, care to update the documentation?
>>
>>   * Return: 0 on success, -ENOMEM if memory could not be allocated or
>>   * -EBUSY if there are no free entries in @limit.
>>   */
>> int __xa_alloc(struct xarray *xa, u32 *id, void *entry,
>> 		struct xa_limit limit, gfp_t gfp)
>> {
>> 	XA_STATE(xas, xa, 0);
>>
>> 	if (WARN_ON_ONCE(xa_is_advanced(entry)))
>> 		return -EINVAL;
>> 	if (WARN_ON_ONCE(!xa_track_free(xa)))
>> 		return -EINVAL;
>>
>> So looks as if the documentation is in need of updating to cover -EINVAL.
>> And, please, state somewhere that whenever you want to use xa_alloc() you
>> _need_ to specify XA_ALLOC_FLAGS in xa_init_flags(), otherwise
>> you trip across the above.
> 
> Like this?
> 
> Allocating XArrays
> ------------------
> 
> If you use DEFINE_XARRAY_ALLOC() to define the XArray, or
> initialise it by passing ``XA_FLAGS_ALLOC`` to xa_init_flags(),
> the XArray changes to track whether entries are in use or not.
> 
> You can call xa_alloc() to store the entry at an unused index
> in the XArray.  If you need to modify the array from interrupt context,
> you can use xa_alloc_bh() or xa_alloc_irq() to disable
> interrupts while allocating the ID.
> 
> 
What I'm missing is the connection between the first paragraph and the 
second.
It starts with 'If you use ...', making no indication what would happen 
if you don't.
And the second paragraph just says '... to store the entry ...'; is 
never said anything about tracking entries.

Why not simply append this sentenct to the second paragraph:

In order to use xa_alloc() you need to pass the XA_FLAGS_ALLOC when
calling xa_init_flags()l

>> It's not entirely obvious, and took me the better half of a day to figure
>> out.
> 
> Really?  You get a nice WARN_ON and backtrace so you can see where
> you went wrong ... What could I change to make this easier?
> 
It _could_ have said 'You forgot to pass XA_ALLOC_FLAGS in xa_init_flags()'.
Then it would've been immediately obvious without having to delve into 
xarray code.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
