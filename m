From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Tue, 28 Sep 2010 07:03:15 +0900
Message-ID: <4CA114A3.4010202@fusionio.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>	 <4CA0CC38.5010804@fusionio.com>  <20100927172309.GA13874@redhat.com> <1285624684.2888.120.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:33000 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab0I0WDT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 18:03:19 -0400
In-Reply-To: <1285624684.2888.120.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2010-09-28 06:58, James Bottomley wrote:
> On Mon, 2010-09-27 at 13:23 -0400, Mike Snitzer wrote:
>> On Mon, Sep 27 2010 at 12:54pm -0400,
>> Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>>> On 2010-09-28 01:41, Martin K. Petersen wrote:
>>>> Mike Snitzer reported that he has access to a device that supports thin
>>>> provisioning but does not use the Block Limits VPD page to indicate
>>>> discard granularity. Instead it reports a huge (1MB) physical block
>>>> size. That caused a bit of fallout in the topology stack which assumed a
>>>> physical block size of 4KiB or less.
>>>
>>> Fixing the overflow aside, I question the validity of setting the physical
>>> block size to something larger than PAGE_SIZE as there's no way that that
>>> could really work in the current kernel.
>>>
>>> I would suggest doing something similar as we do with other 'invalid'
>>> settings that we cannot honor, print a warning and drop the queue
>>> limits to PAGE_SIZE.
>>
>> I'm inclined to agree.  Doesn't make a whole lot of sense.
>>
>> But could this cap of PAGE_SIZE be enforced with a follow-on patch?  Or
>> would you rather see it be dealt with in a single revised 2/2 patch?
> 
> It's up to Jens, but I'd prefer, unless there's a very good reason, that
> the patches we put into the kernel be right first time around, since
> that generates a cleaner history and a better example should anyone go
> looking for one in the tree.

Yes, from a correctness point of view it doesn't matter, but when
people go looking up fixes for whatever reason, it's much better to
include such a fix in the original patch so it's not missed.

-- 
Jens Axboe

