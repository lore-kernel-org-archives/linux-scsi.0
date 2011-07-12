From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] block: Check that queue is alive in
 blk_insert_cloned_request()
Date: Tue, 12 Jul 2011 12:41:30 -0500
Message-ID: <1310492490.16900.20.camel@mulgrave>
References: <CAG4TOxMjuntpd3Q5jgn+xDa2tgB9tq+jLcDquM_eAdFHXLDrWA@mail.gmail.com>
	 <1310166270-23196-1-git-send-email-roland@kernel.org>
	 <CAMM=eLfzKuw-2vbERV6D7dAHb1BWopOKZ=dB7vWxcxSCoj6Tkw@mail.gmail.com>
	 <20110712170658.GF1293@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51882 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753288Ab1GLRld (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2011 13:41:33 -0400
In-Reply-To: <20110712170658.GF1293@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Roland Dreier <roland@kernel.org>, Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>

On Tue, 2011-07-12 at 13:06 -0400, Vivek Goyal wrote:
> On Mon, Jul 11, 2011 at 06:40:11PM -0400, Mike Snitzer wrote:
> > [cc'ing dm-devel, vivek and tejun]
> > 
> > On Fri, Jul 8, 2011 at 7:04 PM, Roland Dreier <roland@kernel.org> wrote:
> > > From: Roland Dreier <roland@purestorage.com>
> > >
> > > This fixes crashes such as the below that I see when the storage
> > > underlying a dm-multipath device is hot-removed.  The problem is that
> > > dm requeues a request to a device whose block queue has already been
> > > cleaned up, and blk_insert_cloned_request() doesn't check if the queue
> > > is alive, but rather goes ahead and tries to queue the request.  This
> > > ends up dereferencing the elevator that was already freed in
> > > blk_cleanup_queue().
> > 
> > Your patch looks fine to me:
> > Acked-by: Mike Snitzer <snitzer@redhat.com>
> > 
> > And I looked at various code paths to arrive at the references DM takes.
> > 
> > A reference is taken on the underlying devices' block_device via
> > drivers/md/dm-table.c:open_dev() with blkdev_get_by_dev().  open_dev()
> > also does bd_link_disk_holder(), resulting in the mpath device
> > becoming a holder of the underlying devices. e.g.:
> > /sys/block/sda/holders/dm-4
> > 
> > But at no point does DM-mpath get a reference to the underlying
> > devices' request_queue that gets assigned to clone->q (in
> > drivers/md/dm-mpath.c:map_io).
> > 
> > Seems we should, though AFAIK it won't help with the issue you've
> > pointed out (because the hotplugged device's driver already called
> > blk_cleanup_queue and nuked the elevator).
> 
> [Thinking loud]
> 
> Could it be a driver specific issue that it cleaned up the request
> queue too early?

One could glibly answer yes to this.  However, the fact is that it's
currently SCSI which manages the queue, so SCSI cleans it up.  Now, the
only real thing dm is interested in is the queue itself, hence the need
to take a reference to the queue.  However, queue references don't pin
SCSI devices, so you can hold a queue reference all you like and SCSI
will still clean up the queue.

I think a better question is what should cleaning up the queue do?  SCSI
uses it to indicate that we're no longer processing requests, which
happens when the device goes into a DEL state, but queue cleanup tears
down the elevators and really makes the request queue non functional.
In this case, holding a reference isn't particularly helpful.

I'm starting to wonder if there's actually any value to
blk_cleanup_queue() and whether its functionality wouldn't be better
assumed by the queue release function on last put.

> Is there any notion of device reference which higher layers take and
> that should make sure request queue is intact till somebody is holding
> device reference.
> 
> If yes, what't the connection between device reference and request
> queue reference. IOW, why request queue reference is needed and why
> device reference is not sufficient. (Because there is not necessarily
> one to one mapping between request queue and device?)

For the model, these need to be independent but related.  Trying to
subordinate one to the other is going to lead to layering problems.

James


> I seem to just have lots of question about devices and referencing.
> Hopefully somebody with more knowledge in this area be able to
> shed some light on it.
> 
> Thanks
> Vivek


