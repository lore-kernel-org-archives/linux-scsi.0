From: Jens Axboe <axboe@suse.de>
Subject: Re: IO buffer alignment for block devices
Date: Mon, 13 Sep 2004 21:02:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040913190257.GD18883@suse.de>
References: <41459729.5060106@il.marvell.com> <1095084876.1762.8.camel@mulgrave> <4145B9DF.7020408@il.marvell.com> <1095089305.1762.73.camel@mulgrave> <Pine.LNX.4.58.0409131952170.4529@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:18334 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S268670AbUIMTEG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 15:04:06 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0409131952170.4529@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Saeed Bishara <Saeed.Bishara@il.marvell.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Sep 13 2004, Kai Makisara wrote:
> On Mon, 13 Sep 2004, James Bottomley wrote:
> 
> > On Mon, 2004-09-13 at 11:16, Saeed Bishara wrote:
> > >     isn't the default 512, this is what I see in blk_queue_make_request.
> > > 
> > > <http://lxr.linux.no/ident?v=2.6.8.1;i=blk_queue_make_request>
> > 
> > In the block layer, yes.  In SCSI we tune that down to be 8 for backward
> > compatibility with 2.4, I think, but LLDs can tune it up again.
> > 
> We don't. The alignment has been 512 bytes after this patch in 2.6.4:
> 
> <James.Bottomley@SteelEye.com>
>         [PATCH] Undo SCSI 8-byte alignment relaxation
>         
>         This makes the default alignment requirements be 512 bytes for SCSI,
>         the way it used to be.
>         
>         Jens will fix the SCSI layer problems, but low-level drivers might have
>         other restrictions on alignment.
> 
> As you can guess, I have not been too happy with this situation ;-)
> 
> Any driver can change this restriction in slave_configure(). I have for 
> some time had the following patch in my system to change the alignment for 
> my tape drive to 8 bytes:

I'm not sure 8 is a safe alignment at all, at least for ide-cd there
were cases that simply didn't work well with 8-byte alignment.

> --- linux-2.6.9-rc1-bk1/drivers/scsi/sym53c8xx_2/sym_glue.c~	2004-08-27 19:33:34.000000000 +0300
> +++ linux-2.6.9-rc1-bk1/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-08-28 12:54:49.000000000 +0300
> @@ -1097,6 +1097,8 @@
>  
>  	spi_dv_device(device);
>  
> +	blk_queue_dma_alignment(device->request_queue, 7);
> +
>  	return 0;
>  }

Why don't you just do this in st? Not that it matters, since it's just
your private hack - just wondering.

And finally (and most importantly), why do you care so much? You should
rip some of that manual data mapping out of st completely. Add a
scsi_rq_map_user or something that returns a struct scsi_request, and
uses blk_rq_map_user (which will do bio_map_user() or bio_copy_user())
to map the user data into your SCSI request. I seriously doubt that st
will see any performance difference between the two at all, and st
really should be using proper infrastructure for this. sg as well, but
since it's dying anyways...

-- 
Jens Axboe

