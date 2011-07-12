From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] block: Check that queue is alive in
 blk_insert_cloned_request()
Date: Tue, 12 Jul 2011 14:02:38 -0400
Message-ID: <20110712180238.GJ1293@redhat.com>
References: <CAG4TOxMjuntpd3Q5jgn+xDa2tgB9tq+jLcDquM_eAdFHXLDrWA@mail.gmail.com>
 <1310166270-23196-1-git-send-email-roland@kernel.org>
 <CAMM=eLfzKuw-2vbERV6D7dAHb1BWopOKZ=dB7vWxcxSCoj6Tkw@mail.gmail.com>
 <20110712170658.GF1293@redhat.com>
 <1310492490.16900.20.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405Ab1GLSDM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2011 14:03:12 -0400
Content-Disposition: inline
In-Reply-To: <1310492490.16900.20.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Roland Dreier <roland@kernel.org>, Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>

On Tue, Jul 12, 2011 at 12:41:30PM -0500, James Bottomley wrote:
> On Tue, 2011-07-12 at 13:06 -0400, Vivek Goyal wrote:
> > On Mon, Jul 11, 2011 at 06:40:11PM -0400, Mike Snitzer wrote:
> > > [cc'ing dm-devel, vivek and tejun]
> > > 
> > > On Fri, Jul 8, 2011 at 7:04 PM, Roland Dreier <roland@kernel.org> wrote:
> > > > From: Roland Dreier <roland@purestorage.com>
> > > >
> > > > This fixes crashes such as the below that I see when the storage
> > > > underlying a dm-multipath device is hot-removed.  The problem is that
> > > > dm requeues a request to a device whose block queue has already been
> > > > cleaned up, and blk_insert_cloned_request() doesn't check if the queue
> > > > is alive, but rather goes ahead and tries to queue the request.  This
> > > > ends up dereferencing the elevator that was already freed in
> > > > blk_cleanup_queue().
> > > 
> > > Your patch looks fine to me:
> > > Acked-by: Mike Snitzer <snitzer@redhat.com>
> > > 
> > > And I looked at various code paths to arrive at the references DM takes.
> > > 
> > > A reference is taken on the underlying devices' block_device via
> > > drivers/md/dm-table.c:open_dev() with blkdev_get_by_dev().  open_dev()
> > > also does bd_link_disk_holder(), resulting in the mpath device
> > > becoming a holder of the underlying devices. e.g.:
> > > /sys/block/sda/holders/dm-4
> > > 
> > > But at no point does DM-mpath get a reference to the underlying
> > > devices' request_queue that gets assigned to clone->q (in
> > > drivers/md/dm-mpath.c:map_io).
> > > 
> > > Seems we should, though AFAIK it won't help with the issue you've
> > > pointed out (because the hotplugged device's driver already called
> > > blk_cleanup_queue and nuked the elevator).
> > 
> > [Thinking loud]
> > 
> > Could it be a driver specific issue that it cleaned up the request
> > queue too early?
> 
> One could glibly answer yes to this.  However, the fact is that it's
> currently SCSI which manages the queue, so SCSI cleans it up.  Now, the
> only real thing dm is interested in is the queue itself, hence the need
> to take a reference to the queue.  However, queue references don't pin
> SCSI devices, so you can hold a queue reference all you like and SCSI
> will still clean up the queue.
> 
> I think a better question is what should cleaning up the queue do?  SCSI
> uses it to indicate that we're no longer processing requests, which
> happens when the device goes into a DEL state, but queue cleanup tears
> down the elevators and really makes the request queue non functional.
> In this case, holding a reference isn't particularly helpful.
> 
> I'm starting to wonder if there's actually any value to
> blk_cleanup_queue() and whether its functionality wouldn't be better
> assumed by the queue release function on last put.

I think one problem point is q->queue_lock. If driver drops its reference
on queue and cleans up its data structures, then it will free up memory
associated with q->queue_lock too. (If driver provided its own queue
lock). In that case anything which is dependent on queue lock, needs
to be freed up on blk_cleanup_queue().

If we can make sure that request queue reference will keep the spin lock
alive, then i guess all cleanup part might be able to go in release
queue function.

Thanks
Vivek
