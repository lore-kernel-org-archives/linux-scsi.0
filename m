Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49683C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 17:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F3DE20849
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 17:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388905AbgEZRxk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 13:53:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:49492 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388586AbgEZRxj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 May 2020 13:53:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 97708AC37;
        Tue, 26 May 2020 17:53:40 +0000 (UTC)
Subject: Re: [RFC v2 1/6] scsi: xarray hctl
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com
References: <20200524155814.5895-1-dgilbert@interlog.com>
 <20200524155814.5895-2-dgilbert@interlog.com>
 <6527a0ca-954c-70e8-f0f5-08206c1779f2@suse.de>
 <8dab99d1-a22d-0065-5a7a-fd9b80bc661a@interlog.com>
 <20200525174052.GD17206@bombadil.infradead.org>
 <825bece5-e209-a4da-ddb1-809c48e4e9b3@suse.de>
 <20200526142727.GH17206@bombadil.infradead.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b14bdfa1-1cb9-6e3f-c025-fccdfa034024@suse.de>
Date:   Tue, 26 May 2020 19:53:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200526142727.GH17206@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/26/20 4:27 PM, Matthew Wilcox wrote:
> On Tue, May 26, 2020 at 08:21:26AM +0200, Hannes Reinecke wrote:
>> On 5/25/20 7:40 PM, Matthew Wilcox wrote:
>>> You aren't the first person to ask about having a 64-bit lookup on
>>> 32-bit machines.  Indeed, I remember Hannes asking for a 256 bit lookup
>>> at LinuxCon in Prague.  I have always been reluctant to add such a thing
>>> because the XArray uses quite a naive data type underneath.  It works well with
>>> dense arrays but becomes very wasteful of memory for sparse arrays.
>>>
>>> My understanding of SCSI-world is that most devices have a single
>>> LUN 0.  Most devices that have multiple LUNs number them sequentially.
>>> Some devices have either an internal structure or essentially pick random
>>> LUNs for the devices they expose.
>>
>> Not quite. You are correct that most devices have a single LUN 0
>> (think of libata :-), but those with several LUNs typically
>> enumerate them. In most cases the enumeration starts at 0 (or 1,
>> if LUN 0 is used for a management LUN), and reaches up to 256.
>> Some arrays use a different LUN layout, which means that the top
>> two bit of the LUN number are set, and possibly some intermediate
>> numbers, too. But the LUNs themselves are numbered consecutively, too;
>> it's just at a certain offset.
>> I've never seen anyone picking LUN numbers at random.
> 
> Ah, OK.  I think for these arrays you'd be better off accepting the cost
> of an extra 4 bytes in the struct scsi_device rather than the cost of
> storing the scsi_device at the LUN.
> 
> Let's just work an example where you have a 64-bit LUN with 4 ranges,
> each of 64 entries (this is almost a best-case scenario for the XArray).
> [0,63], 2^62+[0,63], 2^63+[0,63], 2^63+2^62+[0,63].
> 
> If we store them sequentially in an allocating XArray, we take up 256 *
> 4 bytes = 1kB extra space in the scsi_device.  The XArray will allocate
> four nodes plus one node to hold the four nodes, which is 5 * 576 bytes
> (2780 bytes) for a total of 3804 bytes.
> 
> Storing them in at their LUN will allocate a top level node which covers
> bits 60-66, then four nodes, each covering bits of 54-59, another four
> nodes covering bits 48-53, four nodes for 42-47, ...  I make it 41 nodes,
> coming to 23616 bytes.  And the pointer chase to get to each LUN is
> ten deep.  It'll mostly be cached, but still ...
> 
Which is my worry, too.
In the end we're having a massively large array space (128bit if we take 
the numbers as they stand today), of which only a _tiny_ fraction is 
actually allocated.
We can try to reduce the array space by eg. restricting channels and 
targets to be 16 bits, and the LUN to be 32 bits.
But then we'll be having a hard time arguing; "Hey, we have a cool new 
feature, which has a really nice interface, but we can't support the 
same set of devices as we have now...".
That surely will go down well.

Maybe one should look at using an rbtree directly; _that_ could be made 
to work with an 128bit index, and lookup should be fast, too.
Let's see.

>> But still, the original question still stands: what would be the most
>> efficient way using xarrays here?
>> We have a four-level hierarchy Host:Channel:Target:LUN
>> and we need to lookup devices (and, occasinally, targets) per host.
>> At this time, 'channel' and 'target' are unsigned integer, and
>> LUNs are 64 bit.
> 
> It certainly seems sensible to me to have a per-host allocating XArray
> to store the targets that belong to that host.  I imagine you also want
> a per-target XArray for the LUNs that belong to that target.  Do you
> also want a per-host XArray to store the LUNs so you can iterate all
> LUNs per host as a single lookup rather than indirecting through the
> target Xarray?  That's a design decision for you to make.
> 
Seeing that I'm trying to use the existing HCTL number as index it's 
quite hard to have a per-host lookup structure, as this would inevitably
require a separate LUN index somewhere.
Which would mean to have a two-level xarray structure, where the first 
xarray hold the scsi targets, and the second one the LUNs per target.
Not super-nice, but doable.

Still thinking about the rbtree idea, though.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
