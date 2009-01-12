From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 7/9] exofs: mkexofs
Date: Mon, 12 Jan 2009 13:56:30 -0600
Message-ID: <1231790190.15161.29.camel@localhost.localdomain>
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>
	 <20081229121423.efde9d06.akpm@linux-foundation.org>
	 <495B8D90.1090004@panasas.com>
	 <1230739053.3408.74.camel@localhost.localdomain>
	 <4960D3CA.2000202@panasas.com>
	 <1231783926.3256.29.camel@localhost.localdomain>
	 <496B989F.7050907@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52981 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754831AbZALT4h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2009 14:56:37 -0500
In-Reply-To: <496B989F.7050907@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Matthew Wilcox <matthew@wil.cx>, Benny Halevy <bhalevy@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Avishay Traeger <avishay@gmail.com>, open-osd development <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, 2009-01-12 at 14:23 -0500, Jeff Garzik wrote:
> > It's an indicator of one.  If you buy my premise that OSD cannot be
> > relevant without compelling user cases, then the lack of a user API can
> > be viewed as a symptom of this.
> 
> If having a compelling user case was a prereq for kernel inclusion, well 
> over half the code would be gone.

I'm not holding this against inclusion ... I'm saying it's a symptom of
the generic relevance to user issues problem that OSD has.

> > I think your choice of using a character device will turn out to be a
> > design mistake because the migration path of existing filesystems is
> > bound to be a block device with extra features (which they may or may
> > not make use of) but only if there's a way to make ODS relevant to
> > users.
> 
> It is fantasy to think we will be migrating ext4 to OSD.  That fantasy 
> is not a compelling reason to block OSD development.

OK, so your quote managed to miss this bit:

"Right, so I'm reasonably happy to accept libosd for what it is:  an
enabler for a few specialised applications. "

I can't see how that can be construed as "blocking OSD development".
The word "accept" is conventionally used in Linux parlance to mean "will
send upstream".

> To sum,
> 
> * exofs needs a userspace library, around which the standard filesystem 
> tools will be built, most notably mkfs, dump, restore, fsck
> 
> * talk of migrating existing filesystems is wildly premature (and a bit 
> of a silly argument, since you are also arguing that OSD lacks 
> compelling use cases)

So criticising lacking compelling use cases while at the same time
suggesting how to find them is wrong?

Actually, If the only use case OSD can bring to the table is requiring
new filesystems, then there's nothing of general user relevance for it
on the horizon ... anywhere.  There's never going to be a compelling
reason to move the consumer OSDs in the various development labs to
production because nothing would be able to use them on a mass scale.

If we could derive a benefit from OSD in existing filesystems, then they
do have user relevance, and Seagate and the others might just consider
releasing the devices.

Note that "providing benefit to" does not equate to "rewriting the
filesystem for" ... and it shouldn't; the benefit really should be
incremental.  And that's the crux of my criticism.  While OSD are
separate things that we have to rewrite whole filesystems for, they're
never going to set the world on fire.  If they could be used with only
incremental effort, they might.  The bridge for the incremental effort
will come from a properly designed kernel API.

> * an in-kernel OSD-based filesystem needs some sort of generic in-kernel 
> libosd API, so that multiple OSD filesystems do not reinvent the wheel 
> each time.
> 
> * OSD was bound to be annoying, because it forces the kernel filesystem 
> to either (a) talk SCSI or (b) use messages that can be converted to 
> SCSI OSD commands, like existing drivers convert the block layer's READ 
> and WRITE to device-specific commands.

OK, so what you're arguing is that unlike block devices where we can
produce a useful generic abstraction that is protocol agnostic, for OSD
we can't?  As I've said before, I think this might be true, but fear it
dooms OSD to being too difficult to use.

> * Trying to force OSD to export a block device is pushing a square peg 
> through a round hole.  Thus, the best (and only) alternative is 
> character device.  What you really want is a Third Way(tm):  a mmap'able 
> message device, since you really want to export an API to userspace.

only allowing a character tap raises the effort bar on getting other
filesystems to use it, because they're all block based ... that's what I
think is the mistake.

James


