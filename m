From: Christoph Hellwig <hch@infradead.org>
Subject: Re: hot scsi disk resize
Date: Mon, 17 Mar 2003 16:30:26 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030317163026.A12423@infradead.org>
References: <m3bs0s9xij.fsf@lexa.home.net> <20030303181536.A30199@infradead.org> <m365qz8vlp.fsf@lexa.home.net> <1047918111.1632.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1047918111.1632.3.camel@mulgrave>; from James.Bottomley@steeleye.com on Mon, Mar 17, 2003 at 10:21:41AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: alexey@technomagesinc.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>, Dennis Gerasimov <denis@technomagesinc.com>, viro@math.psu.edu

On Mon, Mar 17, 2003 at 10:21:41AM -0600, James Bottomley wrote:
> > --- linux/fs/block_dev.c	Mon Jan 20 02:23:49 2003
> > +++ edited/fs/block_dev.c	Mon Mar  3 18:49:47 2003
> > @@ -623,6 +623,8 @@
> >  			up(&whole->bd_sem);
> >  		}
> >  	} else {
> > +		if (!part)
> > +			bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
> >  		put_disk(disk);
> >  		module_put(owner);
> >  		if (bdev->bd_contains == bdev) {
> > 
> > 
> 
> Because adding this in will break the initial ramdisk.  Thus, although
> the SCSI layer does resize, the block layer may not.

What about moving the size setting into ->open?

