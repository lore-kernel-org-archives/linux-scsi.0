From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Alternative TRIM proposal
Date: Fri, 3 Oct 2008 09:42:37 -0600
Message-ID: <20081003154237.GT13822@parisc-linux.org>
References: <200810021732.m92HW7qL015836@coles02.co.lsil.com> <OF93179061.8BBD23CF-ON862574D6.006C600D-862574D6.006E8EBB@seagate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53446 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYJCPmj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Oct 2008 11:42:39 -0400
Content-Disposition: inline
In-Reply-To: <OF93179061.8BBD23CF-ON862574D6.006C600D-862574D6.006E8EBB@seagate.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerry.Houlder@seagate.com
Cc: dougg@torque.net, "Knight, Frederick" <Frederick.Knight@netapp.com>, linux-scsi@vger.kernel.org, t10@t10.org, David Woodhouse <dwmw2@infradead.org>

On Thu, Oct 02, 2008 at 03:07:34PM -0500, Gerry.Houlder@seagate.com wrote:
> I will not be able to attend the call tomorrow, so I will offer my opinions
> on the T10 reflector.

Thanks, Gerry.

> (a) I don't see any point to doing a 12 byte TRIM command. The 16 byte
> command is more future proof and any SCSI system (except maybe ATAPI) that
> can do 10 and 12 byte commands can also do 16 byte commands.

Unfortunately, that's not true.  A survey of the SCSI host adapters in
Linux shows that many only support 12-byte commands.  A reasonable
person might decide that it's not worth supporting these adapters any
more, but I don't want to see support disappear because we didn't know
about it.

> (b) Likewise I don't see any point to a 32 byte TRIM command. The extra
> fields in the CDB are for checking Protection Information fields attached
> to user data; since the trim command won't transfer any user data these
> fields add no value.

I may well have been mistaken in my understanding of the protection
information.  I thought there was potential for the drive to check the
protection information currently written to the media and to fail the
TRIM if it wasn't there.  It would be just a verification step.

> (d) I'm not sure why you don't like the T13 approach, where multiple
> extents can be trimmed in one command instead of having to send a separate
> command for each extent to be trimmed. If you tell me that when a person
> goes to the GUI file manager and marks 10 files for deletion, some of which
> might be fragmented into several extends, the operating system will only
> trim one extent at a time (waiting for each to be trimmed before doing the
> next) rather than combining multiple extents into one interface command
> then perhaps there is no advantage to being able to do multiple extents.
> The advantage of multiple extents in one command is using less interface
> bus bandwidth. The only disadvantage is error recovery; if the command
> fails or is aborted for other reasons it is messier because the host has to
> figure out which (if any) of the extents were done and which have to be
> retried. I hope you will expound on your reason(s) for liking the one
> extent at a time approach.

The most recent version of the T13 proposal I've seen is e07154r6 and
that only allows for a single extent per command.  If T13 have changed
their proposal to allow multiple extents in a single command, then I
withdraw my opposition because synchronising the capabilities between
T10 and T13 is my main goal.

I don't think it's necessary for each TRIM to be completed before sending
the next; I think it's entirely reasonable to use tags to send multiple
TRIMs at a time.

Filesystems already do their best to avoid fragmentation (as I'm sure
we're all aware of the performance penalties for fragmented files on
rotating media), so I suspect there are not too many extents per file
already.

It is today the case in Linux that each extent will be sent from the
filesystem to the block layer individually.  I can't speak to other
operating systems, maybe some of them allow filesystems to send a list
of extents to the SCSI layer, maybe their SCSI layer can take extents
out of the queue and bundle them together into a single command.

Are there devices that would operate more efficiently if given a list of
(discontiguous) extents to trim rather than getting several consecutive
commands each with a single trim extent in it?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
