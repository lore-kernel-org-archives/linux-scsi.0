From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH]: Fix old SCSI adapter crashes with CD-ROM (take 2)
Date: Tue, 08 May 2007 11:52:31 -0500
Message-ID: <1178643151.3737.44.camel@mulgrave.il.steeleye.com>
References: <20070508171710.1ac730cd@the-village.bc.nu>
	 <20070508161444.GA4163@kernel.dk>
	 <1178642376.3737.36.camel@mulgrave.il.steeleye.com>
	 <20070508164059.GD4163@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:54039 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965693AbXEHQxu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 12:53:50 -0400
In-Reply-To: <20070508164059.GD4163@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 18:40 +0200, Jens Axboe wrote:
> On Tue, May 08 2007, James Bottomley wrote:
> > On Tue, 2007-05-08 at 18:14 +0200, Jens Axboe wrote:
> > > On Tue, May 08 2007, Alan Cox wrote:
> > > > The CD-ROM layer doesn't bounce requests for old ISA controllers (and
> > > > nor should it). However they get injected into the SCSI layer via
> > > > sr_ioctl which also doesn't bounce them and SCSI then passes the buffer
> > > > along to a device with unchecked_isa_dma set which either panics or
> > > > truncates the buffer to 24bits.
> > > > 
> > > > According to Jens the right long term fix is for the CD layer to route
> > > > the requests differently but in the mean time this has been tested by a
> > > > victim and verified to sort the problem out. For the other 99.9% of users
> > > > it's a no-op and doesn't bounce data.
> > > > 
> > > > Signed-off-by: Alan Cox <alan@redhat.com>
> > > 
> > > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > > 
> > > Christoph passed me his patch to get rid of ->generic_packet() in the
> > > cdrom layer, so the work is almost complete. This patch is fine as a
> > > work-around until that gets merged, though.
> > 
> > Actually, I think the new scsi request infrastructure should be doing
> > the bouncing (rather than have it done in each problem path we
> > discover).
> 
> Of course, bouncing should only be done in one layer (the block layer).
> >
> > Mike Christie tells me we're missing bouncing by accident in the
> > scsi_execute path (but not the scsi_execute_async path).  He says this
> > is the fix he proposed:
> > 
> > http://marc.info/?l=linux-scsi&m=115981479822790&w=2
> > 
> > Can we just merge this instead?
> 
> That's another issue. The problem here are requests (cgc's) initiated by
> the cdrom.c layer. Those _should_ get mapped to a request and put on the
> queue for the device, and thus get bounced by the block layer if
> appropriate.
> 
> Mike's fix looks legit and should be merged as well, but it wont fix
> this issue.

It won't?  I thought the issue (from the fix) is that cgc->buffer is
outside of the device accessibility mask.  The scsi_execute path
allocates a request and then calls blk_rq_map_kern on the buffer (in
this case cgc->buffer) ... the problem is that blk_rq_map_kern() doesn't
currently bounce the buffer, but if it did (which is the functionality
Mike's patch adds), surely the need to bounce it in the ioctl path would
go away?

James


