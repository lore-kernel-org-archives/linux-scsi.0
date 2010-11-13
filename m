From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI TMF processing; tag allocation
Date: Sat, 13 Nov 2010 05:37:50 -0700
Message-ID: <20101113123750.GF18258@parisc-linux.org>
References: <380694.87733.qm@web31812.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54827 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab0KMMhw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Nov 2010 07:37:52 -0500
Content-Disposition: inline
In-Reply-To: <380694.87733.qm@web31812.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jaxboe@fusionio.com>

On Fri, Nov 05, 2010 at 11:02:43PM -0700, Luben Tuikov wrote:
> Sure enough, the device receives both, back to back: first the ABORT TASK
> TMF with tag of task to be managed (TTBM) of 3, and then it receives TUR
> with tag of 3. Sure enough the device aborts the TUR.

I think that's acceptable device behaviour, but it's not guaranteed
device behaviour, as far as I can tell.  Receiving the abort and then
the task isn't guaranteed to abort the task.

> First, SCSI Core should probably send ABORT TASK SET. Sending ABORT TASK for each task at the device is also okay, but adds transport overhead.

Agreed.

> Second, SCSI Core should not send ABORT TASK for a completed task. Sure, the device will reply with FUNCTION COMPLETE either way, but in the
> aforementioned case the task server aborts a command which wasn't
> intended to be aborted (and since the tag was reused--see below). That is,
> if the command is in the "eh" queue, and is completed, don't send ABORT
> TASK for it.

Agreed.

> Third, and most importantly, tags should form an increasing sequence and should not be reused until all other tags after it and before it have been reused. This for example can be accomplished if one were to use
> find_next_zero_bit() with non-zero "offset", it being the last allocated
> tag in a modulo the number of tags manner. That is, find_next_zero_bit()
> could wrap as well as starting from an offset or the caller could implement
> that via two calls to this function, in blk_queue_start_tag().

It might be more efficient too.  If we cycle through, we can start by
just trying to assign the next tag; it will likely succeed.  If it's
already assigned, then we can search.

> Forth, transport protocols need tags for other purposes than just sending
> I/O commands, for example sending task management functions. LLDDs should
> be given callbacks to allocate a free tag, only if #3 above is implemented.

Definitely!

> Fifth, all commands that enter queuecommand() should be tagged, regardless
> of whether the device supports tags and how many. At the moment, this
> isn't so, and transports are forced to reserve the first tag the
> transport supports for non-tagged commands and the rest for tagged
> commands. For example INQUIRY coming untagged (tag 0), and then
> READ coming with tag 0 (tagged). This adds additional work for LLDDs to
> check whether the "request" is tagged or not and assign it a tag if
> it is not, or offset the tag if it is tagged with the offset reserved
> for untagged tasks (normally just one).

This one confuses me, though.  I've not seen it happen.  As far as I can
tell, the SCSI layer will either send a single untagged command, or it
will send one-or-more tagged commands.  I haven't been able to provoke it
into sending an untagged command _and_ a tagged command at the same time.

For UAS, I didn't reserve a tag; I just use tag 0 for untagged
commands, and refuse to send a tagged command if there's an untagged
command outstanding.  I could put a printk in to see if that logic
ever triggers...

SPC-4 seems to indicate (in the INQUIRY command, 6.4.2) that support
for queueing is now non-optional, and even support for basic queueing
has been removed, replaced only with the 'command management model'.
I must confess to being somewhat confused by the difference between the
'basic queue' model and 'command management' model, but ideally as a
driver writer, I shouldn't have to understand it (because it would be
handled for me by the SCSI core).

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
