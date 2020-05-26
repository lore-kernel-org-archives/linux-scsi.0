Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D7BC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 20:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E74AB208A7
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 20:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391210AbgEZU1l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 16:27:41 -0400
Received: from smtp.infotech.no ([82.134.31.41]:50676 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389367AbgEZU1l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 May 2020 16:27:41 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 584B8204237;
        Tue, 26 May 2020 22:27:39 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ac6SfQxpuy1t; Tue, 26 May 2020 22:27:32 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 591B220414B;
        Tue, 26 May 2020 22:27:31 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [RFC v2 1/6] scsi: xarray hctl
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     Hannes Reinecke <hare@suse.de>,
        Matthew Wilcox <willy@infradead.org>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com
References: <20200524155814.5895-1-dgilbert@interlog.com>
 <20200524155814.5895-2-dgilbert@interlog.com>
 <6527a0ca-954c-70e8-f0f5-08206c1779f2@suse.de>
 <8dab99d1-a22d-0065-5a7a-fd9b80bc661a@interlog.com>
 <20200525174052.GD17206@bombadil.infradead.org>
 <825bece5-e209-a4da-ddb1-809c48e4e9b3@suse.de>
 <20200526142727.GH17206@bombadil.infradead.org>
 <b14bdfa1-1cb9-6e3f-c025-fccdfa034024@suse.de>
 <4a52d9a2-d0ed-27a9-f839-1f81a8b872fc@interlog.com>
Message-ID: <0eb4bb5d-1c2f-9230-beec-4b523e1d1501@interlog.com>
Date:   Tue, 26 May 2020 16:27:30 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <4a52d9a2-d0ed-27a9-f839-1f81a8b872fc@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-26 3:10 p.m., Douglas Gilbert wrote:
> On 2020-05-26 1:53 p.m., Hannes Reinecke wrote:
>> On 5/26/20 4:27 PM, Matthew Wilcox wrote:
>>> On Tue, May 26, 2020 at 08:21:26AM +0200, Hannes Reinecke wrote:
>>>> On 5/25/20 7:40 PM, Matthew Wilcox wrote:
>>>>> You aren't the first person to ask about having a 64-bit lookup on
>>>>> 32-bit machines.  Indeed, I remember Hannes asking for a 256 bit lookup
>>>>> at LinuxCon in Prague.  I have always been reluctant to add such a thing
>>>>> because the XArray uses quite a naive data type underneath.  It works well 
>>>>> with
>>>>> dense arrays but becomes very wasteful of memory for sparse arrays.
>>>>>
>>>>> My understanding of SCSI-world is that most devices have a single
>>>>> LUN 0.  Most devices that have multiple LUNs number them sequentially.
>>>>> Some devices have either an internal structure or essentially pick random
>>>>> LUNs for the devices they expose.
>>>>
>>>> Not quite. You are correct that most devices have a single LUN 0
>>>> (think of libata :-), but those with several LUNs typically
>>>> enumerate them. In most cases the enumeration starts at 0 (or 1,
>>>> if LUN 0 is used for a management LUN), and reaches up to 256.
>>>> Some arrays use a different LUN layout, which means that the top
>>>> two bit of the LUN number are set, and possibly some intermediate
>>>> numbers, too. But the LUNs themselves are numbered consecutively, too;
>>>> it's just at a certain offset.
>>>> I've never seen anyone picking LUN numbers at random.
>>>
>>> Ah, OK.  I think for these arrays you'd be better off accepting the cost
>>> of an extra 4 bytes in the struct scsi_device rather than the cost of
>>> storing the scsi_device at the LUN.
>>>
>>> Let's just work an example where you have a 64-bit LUN with 4 ranges,
>>> each of 64 entries (this is almost a best-case scenario for the XArray).
>>> [0,63], 2^62+[0,63], 2^63+[0,63], 2^63+2^62+[0,63].
>>>
>>> If we store them sequentially in an allocating XArray, we take up 256 *
>>> 4 bytes = 1kB extra space in the scsi_device.  The XArray will allocate
>>> four nodes plus one node to hold the four nodes, which is 5 * 576 bytes
>>> (2780 bytes) for a total of 3804 bytes.
>>>
>>> Storing them in at their LUN will allocate a top level node which covers
>>> bits 60-66, then four nodes, each covering bits of 54-59, another four
>>> nodes covering bits 48-53, four nodes for 42-47, ...  I make it 41 nodes,
>>> coming to 23616 bytes.  And the pointer chase to get to each LUN is
>>> ten deep.  It'll mostly be cached, but still ...
>>>
>> Which is my worry, too.
>> In the end we're having a massively large array space (128bit if we take the 
>> numbers as they stand today), of which only a _tiny_ fraction is actually 
>> allocated.
>> We can try to reduce the array space by eg. restricting channels and targets 
>> to be 16 bits, and the LUN to be 32 bits.
>> But then we'll be having a hard time arguing; "Hey, we have a cool new 
>> feature, which has a really nice interface, but we can't support the same set 
>> of devices as we have now...".
>> That surely will go down well.
>>
>> Maybe one should look at using an rbtree directly; _that_ could be made to 
>> work with an 128bit index, and lookup should be fast, too.
>> Let's see.
>>
>>>> But still, the original question still stands: what would be the most
>>>> efficient way using xarrays here?
>>>> We have a four-level hierarchy Host:Channel:Target:LUN
>>>> and we need to lookup devices (and, occasinally, targets) per host.
>>>> At this time, 'channel' and 'target' are unsigned integer, and
>>>> LUNs are 64 bit.
>>>
>>> It certainly seems sensible to me to have a per-host allocating XArray
>>> to store the targets that belong to that host.  I imagine you also want
>>> a per-target XArray for the LUNs that belong to that target.  Do you
>>> also want a per-host XArray to store the LUNs so you can iterate all
>>> LUNs per host as a single lookup rather than indirecting through the
>>> target Xarray?  That's a design decision for you to make.
>>>
>> Seeing that I'm trying to use the existing HCTL number as index it's quite 
>> hard to have a per-host lookup structure, as this would inevitably
>> require a separate LUN index somewhere.
>> Which would mean to have a two-level xarray structure, where the first xarray 
>> hold the scsi targets, and the second one the LUNs per target.
>> Not super-nice, but doable.
>>
>> Still thinking about the rbtree idea, though.
> 
> You already have one, and it handles its own locking. It is called xarray :-)
> 
> 
> Circling back to where I started: xarrays that allocate their own indexes.
> 
> Apart from the LUN ***, the other indexes tend to be monotonic increasing, most
> of the time, correct Hannes? So thinking about an xarray in a shost object
> with pointers to starget objects. At run time if say a target disappears,
> often another appears either with the same target_id or a larger target_id,
> perhaps larger than any previously issued id. So with careful insertions
> (xa_alloc() will allow us to precisely position replacements) we can maintain
> that monotonic ascending order. As I showed in patch 6/6 we can easily
> track the number of elements in each xarray, lets call it 'n'. For
> n < 12 (say) we don't care and just do O(n) iterator searches. For n >= 12
> we check if the xarray is in ascending order, if it isn't, we sort it by
> the index we want (e.g. channel_id,target_id). For elements that we
> change positions of, in the xarray, we need to change the variable I called 
> 'sh_idx' (i.e. the xarray index) in the corresponding starget object.
> 
> Why do this, to do a binary search when n >= 12, of course. Lookup time
> is then O(ln(n)) with only around ln(n) cache-unfriendly visits to starget
> objects.
> 
> And that sort can be much better than O(n.ln(n)) since at the point of an
> insertion, if the xarray was known to be sorted before the insertion,
> then we only need as single iteration through the xarray to place the
> new element in the correct position. After that it would be handy to
> xa_swap() function that gave us the new xarray index. Making sure the
> xarray indexes don't become too sparse might also be addressed in the
> sort.
> 
> 
> Question to Matthew:
> Will xa_find(&xarray, &idx, full_range, 0)
> return NULL _and_ place the index of the lowest "hole" in that xarray
> (or 1 beyond the upper limit of the range) in 'idx' ?
> 
> Note to others: the last argument in a typical xa_find() call
> is either XA_PRESENT or some other mark the app is using, not 0.
> 
> Doug Gilbert
> 
> 
> *** the SCSI REPORT LUNS command doesn't say anything about the _ordering_
>      of LUNs or even if it is stable from one invocation to the next.
>      There is nothing to stop the scsi_scan.c code from sorting the LUN
>      inventory before applying it to the ML object tree.

Maybe interest Matthew into doing the heavy lifting:

void xa_compact_and_sort(struct xa_array *xa,
                          int offset_ul_idx,
                          int (*compar)(const void *l, const void *r));

[Function modelled on qsort(3), perhaps qsort_r(3) would be better.]

The second argument to xa_compact_and_sort() is either:
     - offsetof(struct struct, sh_idx) where sh_idx is an unsigned long, or
     - if less than zero then ignore index fixup and don't compact

The third argument is either:
      - a compare function that, for example, acts on an ordering for the
        key: channel_id,target_id and uses it to return <0, ==0 or >=0
        based on being called with pointers to two starget objects, or
      - NULL: then just do a compaction if ul_idx >= 0

So when ul_idx >= 0 xa_compact_and_sort() places the new compacted index
at each *((unsigned long *)((u8 *)starget) + ul_idx)). So in the case of
my 1/6 patch the type of sh_idx would change from int to unsigned long.

		
