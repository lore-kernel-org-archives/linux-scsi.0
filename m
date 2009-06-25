From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out
	of the 'queue' sysfs directory.
Date: Thu, 25 Jun 2009 21:40:15 +0200
Message-ID: <20090625194015.GB31415@kernel.dk>
References: <19010.62951.886231.96622@notabene.brown> <yq11vp8spxo.fsf@sermon.lab.mkp.net> <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 25 2009, NeilBrown wrote:
> > You seem to be hung up on the fact that you don't queue things.  I think
> > that's beside the point.  You *do* have a request_queue thanks to
> > calling blk_queue_make_request() in md.c.  And there is more to
> > request_queue than the values you brought up.  Like the callback
> > functions.  I'm not saying that all the values in request_queue apply to
> > MD, but I really don't understand what all the fuss is about.  Other
> > than the presence of the string "queue" in the choice of naming.
> >
> 
> Well names are very important.  And as I said later we could possibly keep
> them in 'queue' and make 'queue' a more generic directory.  I don't like
> that but it is probably better than the current situation.

Sorry to ask the obvious question, but what would the point of all this
pain be? The existing values can't go anywhere else, so you'd have to
add symlinks back into queue/ anyway.

> As you say, I do currently have a request_queue, but that is an internal
> detail, not part of the externally visible interface, and it is something
> that is very much in my sights as something I want to change.  I'm
> still working out the details so I'm a fair way from a concrete proposal
> and a long way from some code.  That change certainly doesn't have
> to happen in any rush.  But we should get the externally visible
> names "right" if we can.

What crack are you smoking? :-)

A block device must have a request_queue, that's pretty much spread
throughout the kernel. The fact that md/dm is only using a subset of the
functionality is not a very good reason for re-writing large parts of
that design. We could save some space, but whether the queue is 200
bytes or 1400 bytes doesn't really make a whole lot of real-world
difference. It's not like we allocate/deallocate these all the time,
they are mostly static structures.

-- 
Jens Axboe

