From: Mark Lord <lkml@rtr.ca>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 25 Mar 2008 13:37:03 -0400
Message-ID: <47E9383F.3050908@rtr.ca>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca> <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca> <47E90458.7030801@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:2704 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130AbYCYRhE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Mar 2008 13:37:04 -0400
In-Reply-To: <47E90458.7030801@zytor.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@suse.de>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

H. Peter Anvin wrote:
> Mark Lord wrote:
>>
>> Yeah, that would be just as good, really.  Maybe even better.
>>
>> Mark Lord wrote (later on):
>>> Instead, software has to search everything inside /sys/block/
>>> looking for a "dev" file whose contents match,
>>> rather than just trying to access something like this:
>>>
>>>   /sys/block/8:1/start
>>> or
>>>   /sys/block/majors/8/minors/1/start
>>>
>>> Or any one of a number of similar ways to arrange it. 
>> ..
> 
> It shouldn't be under /sys/block... there are enough many things that 
> scan /sys/block and assume any directory underneath it has the current 
> format.
..

So long as we only add things, and not remove them, then any software
that scans /sys/block/ shouldn't care, really.

But yes, it could go elsewhere, too.
Perhaps a /sys/dev/ directory, populated with symbolic links
(or hard links?) back to the /sys/block/ entries, something like this:

   /sys/dev/block/8:0 -> ../../../block/sda
   /sys/dev/block/8:1 -> ../../../block/sda/sda1
   /sys/dev/block/8:2 -> ../../../block/sda/sda2
   ...

That's just a suggestion, really.
And what about character devices?

Perhaps Greg will chime in.
