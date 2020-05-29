Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F49AC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 16:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 764EE2145D
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 16:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbgE2QYr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 12:24:47 -0400
Received: from smtp.infotech.no ([82.134.31.41]:32768 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE2QYq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 May 2020 12:24:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id D56F320418D;
        Fri, 29 May 2020 18:24:43 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wpwikUY5E7+w; Fri, 29 May 2020 18:24:36 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 7672E20414B;
        Fri, 29 May 2020 18:24:35 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 3/4] scsi: move target device list to xarray
To:     Hannes Reinecke <hare@suse.de>,
        Matthew Wilcox <willy@infradead.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
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
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <8b6cd6c4-06ff-a7f0-76f2-9f7ff3ba472a@interlog.com>
Date:   Fri, 29 May 2020 12:24:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <6ed49962-479e-ced7-16b4-095c8f5f70d6@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-29 8:46 a.m., Hannes Reinecke wrote:
> On 5/29/20 1:21 PM, Matthew Wilcox wrote:
>> On Fri, May 29, 2020 at 08:50:21AM +0200, Hannes Reinecke wrote:
>>>> I meant just use xa_alloc() for everything instead of using xa_insert for
>>>> 0-255.
>>>>
>>> But then I'll have to use xa_find() to get to the actual element as the 1:1
>>> mapping between SCSI LUN and array index is lost.
>>> And seeing that most storage arrays will expose only up to 256 LUNs I
>>> thought this was a good improvement on lookup.
>>> Of course, this only makes sense if xa_load() is more efficient than
>>> xa_find(). If not then of course it's a bit futile.
>>
>> xa_load() is absolutely more efficient than xa_find().  It's just a
>> question of whether it matters ;-)  Carry on ...
>>
> Thanks. I will.
> 
> BTW, care to update the documentation?
> 
>   * Return: 0 on success, -ENOMEM if memory could not be allocated or
>   * -EBUSY if there are no free entries in @limit.
>   */
> int __xa_alloc(struct xarray *xa, u32 *id, void *entry,
>          struct xa_limit limit, gfp_t gfp)
> {
>      XA_STATE(xas, xa, 0);
> 
>      if (WARN_ON_ONCE(xa_is_advanced(entry)))
>          return -EINVAL;
>      if (WARN_ON_ONCE(!xa_track_free(xa)))
>          return -EINVAL;
> 
> So looks as if the documentation is in need of updating to cover -EINVAL.
> And, please, state somewhere that whenever you want to use xa_alloc() you _need_ 
> to specify XA_ALLOC_FLAGS in xa_init_flags(), otherwise
> you trip across the above.
> 
> It's not entirely obvious, and took me the better half of a day to figure out.

Ditto for me. At the time I did relay my frustration to Matthew who did
address it in the documentation. Another one is that xa_find*() requires the
XA_PRESENT mark, even when you are not using marks (or haven't yet learnt
about them ...). A clearer demarcation of the two xarray modes (i.e. either
the user supplies the index, or xarray does) would be helpful. That mode
impacts which parts of the xarray interface are used, for example in the sg
driver rewrite, xarrays are used for all collections but if memory serves,
there isn't a single xa_load() or xa_store() call.

But writing technical documentation is difficult. Very few third parties step
up to help, leaving the designer/implementer to do it. And it is extremely
difficult for someone who knows the code backwards (and where the skeletons are
buried) to stand on their heads and present the information in a pedagogic
manner.

Also traditional code documentation uses 7 bit ASCII text and "ACSII art" in
a sort of nod to earlier generations of programmers. Surely more modern
techniques, including colour diagrams and even animations, should now be
encouraged. Maybe when compilers start accepting html :-)

Doug Gilbert


P.S. I have tried to practice what I preach:
                http://sg.danny.cz/sg/sg_v40.html
