From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] scsi-misc-2.5 user per-device spare command
Date: Fri, 25 Apr 2003 13:38:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EA97287.705@rogers.com>
References: <20030424100229.A32098@beaverton.ibm.com> <20030424100317.A32134@beaverton.ibm.com> <20030425111227.B28577@infradead.org> <20030425093718.A8776@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep04-mail.bloor.is.net.cable.rogers.com ([66.185.86.74]:9365
	"EHLO fep04-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S263577AbTDYR0K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Apr 2003 13:26:10 -0400
In-Reply-To: <20030425093718.A8776@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> Christoph -
> 
> On Fri, Apr 25, 2003 at 11:12:27AM +0100, Christoph Hellwig wrote:
> 
>>On Thu, Apr 24, 2003 at 10:03:17AM -0700, Patrick Mansfield wrote:
>>
>>>Patch against scsi-misc-2.5
>>>
>>>Use a per-device spare command rather than a per-host spare.
>>
>>Why?  This means we'll have a much bigger number of spare commands
>>around.
> 
> 
> So we are guaranteed to be able to have at least one IO in flight for all
> devices. With a per-host spare, some device(s) might have to wait
> (generally polling based on an interval dependent on whatever blk_plug_device
> gives us) for a command to become available, and it is not clear what the
> IO behaviour - especially for swap - will be in such cases.
> 
> It simplifies the code, and allows removal of a lock from the IO
> completion path.

I don't buy both arguments.  We've discussed this before as James
pointed out.

Futhermore, we should have an *empirical* result that the current
infrastructure (spare cmd) fails, before braking it and introducing
the *inferior* implementation you suggested.

> For systems with one disk we are better off (than with a per host spare) -
> we have one spare, we always use it, and we don't allocate or use the per
> host free_list_lock.

No, this is NOT true.  Some *devices* (not LLDD) will be able to
have more than ONE active/pending command.

So your solution will take the spare command out, when the
first request is sent to the device and from that point on,
it will try the cache... Uuuurrrggghh (shudders)

(Note what James pointed out for allocating from the slab
and pinning of a page (you can see this from /proc/slabinfo).)

But as soon as we touch the cache to get one command struct,
we already have PAGE_SIZE/sizof(struct scsi_cmnd) - 1 command
structs available... AND the spare gone.... Uuuurrrggghh (shudders)
 
> For larger numbers of disks, if we normally have IO in flight to all
> devices, there is not much difference.

This is not necessarily true (IO to *all* devices at all times).
*And* if there's not much difference, then we should stick with
the current infrastructure because it is WAY bettter.

> Generally, we have one extra
> command per device that does not have IO in flight.

Not with your patch we not!

> Ideally we should have some sysfs attribute to specify whether a spare (or
> spares) is needed or not, default to no spare, and then have some user
> land method to normally add a spare for any scsi swap devices (maybe
> swapon?).

This has been discussed long ago (I think Linus got involved) and it
was voted down.

[Kernel] Settings like this are NOT and SHOULD NOT be user land settable!!!

Giving radio knobs for all kinds of kernel settings to lusers,
will render the kernel untunable and will f*ck the whole thing over.

No!

> But, a sysfs attribute (one inode) would use almost as much memory as the
> spare command itself (340 bytes, but should be smaller), and adds a bit of
> code to the put case. (we could save almost as much memory as we are
> allocating for the spare just by removing for example the scsi "rev" sysfs
> attribute, or even more by exposing all of the inquiry as a binary file).
> 
> If the sysfs attributes were lighter, something lighter is available, or
> general sentiment is to just go ahead and use a sysfs attribute, I can
> change the code to use it. (I don't think having more than one spare per
> device is useful.)

Don't bother changing anything.  This patch should not go in -- not
enough necessity for it (not at all, that is).
 
>>>+	/*
>>>+	 * Use any spare command first.
>>>+	 */
>>>+	cmd = sdev->spare_cmd;
>>>+	if (cmd != NULL)
>>>+		sdev->spare_cmd = NULL;
>>>+	else 
>>>+		cmd = kmem_cache_alloc(sdev->host->cmd_pool->slab,
>>>+				gfp_mask | sdev->host->cmd_pool->gfp_mask);
>>
>>This logical is flawed.  We don't need a spare command if we always use
>>it first.  In addition the sdev->spare_cmd access is racy.
> 
> 
> I had originally coded it to only use the spare on failure of the cache,
> but then we would normally never use the spare (similiar to our per-host
> spare today).

Thats the whole point!!! (all caps -- not typed)

-- 
Luben






