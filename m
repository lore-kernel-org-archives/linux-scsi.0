From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [Patch] Fix oops on rmmod usb-storage
Date: Wed, 29 Sep 2004 10:12:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929171251.GA5368@us.ibm.com>
References: <415A67B8.2080003@suse.de> <20040929130332.A11785@infradead.org> <415AAB0F.2080802@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:5063 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S268719AbUI2RNY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 13:13:24 -0400
Content-Disposition: inline
In-Reply-To: <415AAB0F.2080802@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, Andrew Morton <akpm@osdl.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Alan Stern <stern@rowland.harvard.edu>

Hannes Reinecke [hare@suse.de] wrote:
> Christoph Hellwig wrote:
> >[please send scsi issues to linux-scsi, thanks]
> >
> >
> >>It turned out that in drivers/scsi/hosts.c:scsi_remove_host()
> >>first the host is removed with scsi_forget_host() and _then_ all 
> >>outstanding I/O to this host is cancelled with scsi_host_cancel(). 
> >>Sounds a bit fishy as scsi_host_cancel() tries to talk to a host which 
> >>we just have deleted ...
> >>(Incidentally, this is most likely the same bug as Bug #2752 and #3480 
> >>from bugme.osdl.org :-).
> >>(And also #133249 from bugzilla.redhat.com :-).
> >>
> >>The attached patch corrects this.
> >>Please apply.
> >
> >
> >I'ts not that easy.  If we cancel the host first we won't get our write
> >caches flushed because the drivers don't accept the SYNCRHONIZE_CACHE.
> >command in cancelled state.  Mike just changed the order to what it is
> >now a short while ago.
> >
> Yeah, Jens Axboe just pointed that out.
> 
> >So we'll have to find a way to send a SYNCHRNOZIE_CACHE command even
> >in canncelled state.
> >
> >In fact I can't see how these problems could happen, and that they only
> >happen with usb-storage seems strange.
> Well, the thing is: When usb-storage calls scsi_remove_host() the device 
> is already gone; whether or not we can synchronize the cache is a moot 
> point there.
> 
> And if I understood the comment to the Changeset properly, the patch was 
> just to remove the 'Synchronizing SCSI cache' message.
> I can live with that. Kernel Oops is much worse.
> 

Just a clarification. The patch was also to allow the sending of
the 'Synchronizing SCSI cache' message on rmmod. Prior to the change not
only was the message generated, but also no command was sent either for
devices that wanted one. 

The scsi_remove_host interface does not have a method to distinguish
between clean and unexpected removals.

A pointer to the archives that has a partial discussion on a previously
more complicated change and the current change of reordering.
http://marc.theaimsgroup.com/?t=108701426000002&r=1&w=2

While James patch looks like it will address the issues in the error
handler ref counting. It would be best not to enter the error handler at
all. 

We may want to reconsider a method to distinguish unexpected removals
from clean removals.

-andmike
--
Michael Anderson
andmike@us.ibm.com

