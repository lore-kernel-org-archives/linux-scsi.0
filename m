From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2.6.16-rc6] Promise SuperTrak driver
Date: Fri, 31 Mar 2006 10:21:06 -0500
Message-ID: <442D48E2.3050706@garzik.org>
References: <NONAMEBK04QBh0TzlYb000006b5@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:52154 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751333AbWCaPVO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Mar 2006 10:21:14 -0500
In-Reply-To: <NONAMEBK04QBh0TzlYb000006b5@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@osdl.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "promise_linux@promise.com" <promise_linux@promise.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Ed Lin wrote:
> ======= On 2006-03-15 04:04:30, Matthew Wilcox wrote:
> 
>> On Mon, Mar 13, 2006 at 03:42:36PM -0800, Andrew Morton wrote:
>>>> +#include <linux/irq.h>
>>> Can't include linux/irq.h from generic code (we really ought to fix that).
>> In a sense we have -- everybody should include <linux/interrupt.h> and
>> not <*/irq.h>.  Perhaps we need to poison the includes.
>>
>>>> +static inline u16 shasta_alloc_tag(u32 *bitmap)
>>>> +{
>>>> +	u16 i;
>>>> +	for (i = 0; i < TAG_BITMAP_LENGTH; i++) 
>>>> +		if (!((*bitmap) & (1 << i))) {
>>>> +			*bitmap |= (1 << i);
>>>> +			return i;
>>>> +		}
>>>> +
>>>> +	return TAG_BITMAP_LENGTH;
>>>> +}
>>> This is too large to be inlined.
>> And if I read the driver right, is unnecessary code.  It could just use
>> the midlayer tag code (ok, not scsi_populate_tag_msg() which is
>> SPI-specific, but scsi_activate_tcq(), scsi_deactivate_tcq(),
>> scsi_find_tag(), scsi_set_tag_type(), and scsi_get_tag_type() should all
>> work, being thin wrappers around the block layer functionality.
>>
> 
> Really sorry about that. But...
> 
> When I was starting to implement the tcq according to the advice, I
> suddenly found there may be a misunderstanding here. I think the tagged
> command queue should be applied to a disk. But here the tag is adapter(HBA)
> wide, not just for a specific disk. So maybe this is not the proper case
> where tagged queue is being used...

The block layer code works just fine with host queueing, but I agree
that it may not be appropriate for the SCSI tcq API.

In any case, I'm fine with merging the driver with existing tagging --
since its known to work -- and then pondering the best course of action
for tagging APIs in a later patch to the shasta driver.

Let's go ahead and get it in, minus the requested tagging changes but
including the other requests.

	Jeff



