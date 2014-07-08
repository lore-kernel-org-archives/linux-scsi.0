From: Jens Axboe <axboe@kernel.dk>
Subject: Re: uas: kernel BUG at block/blk-tag.c:89 is back again :|
Date: Tue, 08 Jul 2014 13:40:45 +0200
Message-ID: <53BBD8BD.3040600@kernel.dk>
References: <53B2B4B2.8050100@redhat.com> <20140703060135.GA5292@infradead.org> <53B93FE3.8050607@redhat.com> <20140707101015.GB3544@infradead.org> <53BA95C0.3020607@redhat.com> <20140708095317.GA4306@infradead.org> <53BBBFC6.2030205@kernel.dk> <20140708095619.GA11196@infradead.org> <53BBC98C.4070004@kernel.dk> <53BBD51A.4070704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44793 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbaGHLkt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2014 07:40:49 -0400
Received: by mail-wi0-f171.google.com with SMTP id f8so316828wiw.4
        for <linux-scsi@vger.kernel.org>; Tue, 08 Jul 2014 04:40:48 -0700 (PDT)
In-Reply-To: <53BBD51A.4070704@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-scsi@vger.kernel.org

On 2014-07-08 13:25, Hans de Goede wrote:
> Hi,
>
> On 07/08/2014 12:35 PM, Jens Axboe wrote:
>> On 2014-07-08 11:56, Christoph Hellwig wrote:
>>> On Tue, Jul 08, 2014 at 11:54:14AM +0200, Jens Axboe wrote:
>>>>> I've posted the patch in reply to another report and added Jens to the
>>>>> Cc list.  As the block maintainer he need to review and merge it.
>>>>
>>>> Which patch is this?
>>>
>>> This one:
>>>
>>> ---
>>> From: Christoph Hellwig <hch@lst.de>
>>> Subject: block: don't assume last put of shared tags is for the host
>>>
>>> There is no inherent reason why the last put of a tag structure must be
>>> the one for the Scsi_Host, as device model objects can be held for
>>> arbitrary periods.  Merge blk_free_tags and __blk_free_tags into a single
>>> funtion that just release a references and get rid of the BUG() when the
>>> host reference wasn't the last.
>>
>> Thanks, applied. I don't think I was ever CC'ed on this one, though.
>
> Thanks, good to hear.
>
> Can you please add a Cc: stable ? This patch should at least be
> backported to 3.15, where uas support has been declared stable.
>
> With uas it is trivial to trigger the BUG_ON (and break any further
> device hotplugging) since uas allows for tcq, and thus using tags
> over usb (with all of its hotplug goodness and badness).

I did mark it stable when queuing it up, so should be all set.


-- 
Jens Axboe

