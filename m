From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out
	of the 'queue' sysfs directory.
Date: Fri, 26 Jun 2009 14:50:38 +0200
Message-ID: <20090626125037.GO23611@kernel.dk>
References: <19010.62951.886231.96622@notabene.brown> <yq11vp8spxo.fsf@sermon.lab.mkp.net> <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name> <20090625194015.GB31415@kernel.dk> <19012.49673.454853.975682@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19012.49673.454853.975682@notabene.brown>
Sender: linux-ide-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 26 2009, Neil Brown wrote:
> On Thursday June 25, jens.axboe@oracle.com wrote:
> > On Thu, Jun 25 2009, NeilBrown wrote:
> > > > You seem to be hung up on the fact that you don't queue things.  I think
> > > > that's beside the point.  You *do* have a request_queue thanks to
> > > > calling blk_queue_make_request() in md.c.  And there is more to
> > > > request_queue than the values you brought up.  Like the callback
> > > > functions.  I'm not saying that all the values in request_queue apply to
> > > > MD, but I really don't understand what all the fuss is about.  Other
> > > > than the presence of the string "queue" in the choice of naming.
> > > >
> > > 
> > > Well names are very important.  And as I said later we could possibly keep
> > > them in 'queue' and make 'queue' a more generic directory.  I don't like
> > > that but it is probably better than the current situation.
> > 
> > Sorry to ask the obvious question, but what would the point of all this
> > pain be? The existing values can't go anywhere else, so you'd have to
> > add symlinks back into queue/ anyway.
> 
> Why cannot the existing values go any where else?  I don't understand
> that assertion at all.

Because it's an exported interface, we can't just move things around at
will.

> > > As you say, I do currently have a request_queue, but that is an internal
> > > detail, not part of the externally visible interface, and it is something
> > > that is very much in my sights as something I want to change.  I'm
> > > still working out the details so I'm a fair way from a concrete proposal
> > > and a long way from some code.  That change certainly doesn't have
> > > to happen in any rush.  But we should get the externally visible
> > > names "right" if we can.
> > 
> > What crack are you smoking? :-)
> 
> I have a special mix of crack that helps me see Patterns everywhere,
> even in C code.  Some patterns are bright, shiny, and elegant.  Others
> are muddy and confused.  struct request_queue has a distinct shadow
> over it just now.
> 
> > 
> > A block device must have a request_queue, that's pretty much spread
> > throughout the kernel. The fact that md/dm is only using a subset of the
> > functionality is not a very good reason for re-writing large parts of
> > that design. We could save some space, but whether the queue is 200
> > bytes or 1400 bytes doesn't really make a whole lot of real-world
> > difference. It's not like we allocate/deallocate these all the time,
> > they are mostly static structures.
> 
> It isn't about saving space.  It is about maintainability.  To be
> maintainable, the code must be easy to understand.  For that, it must
> be well structured.
> 
> Every block device has a 'gendisk' (aka generic disk).
> Every block device also (currently) has a request_queue.

I don't know why you keep saying currently. It has always had a queue,
and I don't see a good reason why that should change for "special" block
devices like md/dm/loop/whatnot.

> If I have generic data that is applicable to all disks, where should I
> put it?  One would think "gendisk".
> If I have data that is related to request handling (as in uses of 
> 'struct request'), where should that go?  in request_queue I suspect.
> But there are several fields in request_queue that are not related to
> requests, and are generic to all disks.

It is indeed a bit of a toss-up there, since we do a queue associated
with each gendisk.

> I think "generic data goes in gendisk" is something that it would be
> easy for people to understand.
> The current 'topology' values are intended to be generic to all disks
> so they should ideally go in gendisk.  I'm not pushing for that now.
> Longer term, that would be my aim, but for now I'm just focussing on
> restoring the 'queue' subdirectory to it's previous non-generic state.
> 
> i.e. revert the change that made 'queue' appear for md and dm and loop
> and nbd and .... which have all never needed it before.
> And find somewhere else to put the topology data - probably just the
> top level.
> i.e. add the names as DEVICE_ATTRs in genhd.c, and write the 'show'
> routine to dereference ->queue carefully, just like
> disk_alignment_offset_show.
> (oooo... just noticed that the 'alignment_offset' attribute can
>  contain the string '-1'.... while I have been guilty of that sort of
>  thing myself, I would much rather it said "misaligned".)
> 
> 
> As for how intrusive vs beneficial it would be to move all the generic
> fields out of request_queue and allow md to not have a request queue,
> that will have to be a discussion for another day.  I do hope to
> eventually present you with a series of patches which does just that.
> My aim would be to make sure each one was clearly beneficial.  And I
> do have a grand vision involving this which is more than just tidying
> up some small in-elegances.  Only time will tell how it eventuates.
> 
> 
> But for now, please please please can we revert the change which made
> 'queue' appear in md and dm devices, (and loop and ...) and put these
> generic values somewhere ... generic?

No we cannot, not without a time machine. 2.6.30 is released, so it's
too late to revert things like that, even if we wanted.

-- 
Jens Axboe

