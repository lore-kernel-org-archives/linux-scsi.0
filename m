From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: IO buffer alignment for block devices
Date: Mon, 13 Sep 2004 22:56:11 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0409132217370.1972@kai.makisara.local>
References: <41459729.5060106@il.marvell.com> <1095084876.1762.8.camel@mulgrave>
 <4145B9DF.7020408@il.marvell.com> <1095089305.1762.73.camel@mulgrave>
 <Pine.LNX.4.58.0409131952170.4529@kai.makisara.local> <20040913190257.GD18883@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep07-0.kolumbus.fi ([193.229.0.51]:28084 "EHLO
	fep07-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S268907AbUIMT4N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 15:56:13 -0400
In-Reply-To: <20040913190257.GD18883@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Saeed Bishara <Saeed.Bishara@il.marvell.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 13 Sep 2004, Jens Axboe wrote:

> On Mon, Sep 13 2004, Kai Makisara wrote:
...
> > Any driver can change this restriction in slave_configure(). I have for 
> > some time had the following patch in my system to change the alignment for 
> > my tape drive to 8 bytes:
> 
> I'm not sure 8 is a safe alignment at all, at least for ide-cd there
> were cases that simply didn't work well with 8-byte alignment.
> 
I agree. That is why I have not objected to the patch that changed the 
default back to 512. That is why I reviewed sym53c8xx_2 and, to me, it 
seemed safe to to try 8 byte alignment with this driver. The proper way is 
to have safe default and let the LLDDs relax the alignment. The only 
practical problem is how to get this done but we probably have to live 
with this. Besides we were talking about SCSI.

> > --- linux-2.6.9-rc1-bk1/drivers/scsi/sym53c8xx_2/sym_glue.c~	2004-08-27 19:33:34.000000000 +0300
> > +++ linux-2.6.9-rc1-bk1/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-08-28 12:54:49.000000000 +0300
> > @@ -1097,6 +1097,8 @@
> >  
> >  	spi_dv_device(device);
> >  
> > +	blk_queue_dma_alignment(device->request_queue, 7);
> > +
> >  	return 0;
> >  }
> 
> Why don't you just do this in st? Not that it matters, since it's just
> your private hack - just wondering.
> 
Because the high-level driver should not guess what the low-level driver 
requirements are.

> And finally (and most importantly), why do you care so much?

I do care because the non-bounced transfers give measurable decrease in 
cpu time and bus use. And I don't like the situation where portable 
software has to have special alignment code just for Linux when there is 
no real technical reason for that. In practice, this code often does not 
exist. Then the question is, why does writing to tape in Linux use, say, 
30 % CPU time when the same thing in xxx Unix uses 1 % CPU time.

>                                                               You should
> rip some of that manual data mapping out of st completely. Add a
> scsi_rq_map_user or something that returns a struct scsi_request, and
> uses blk_rq_map_user (which will do bio_map_user() or bio_copy_user())
> to map the user data into your SCSI request. I seriously doubt that st
> will see any performance difference between the two at all, and st
> really should be using proper infrastructure for this. sg as well, but
> since it's dying anyways...
> 
The manual data mapping exists in st and sg because when the code was 
made, nothing better was available. It was meant to be a proof of concept 
and it still is. However, it has at least one good property: it works.

I don't think you can get around the alignment by using bio_map_user(): it 
tests alignment for both the buffer start and the transfer length. So, 
converting the data mapping does not change the alignment handling which 
is what we were talking about.

I have sometimes looked at the bio code and thought about changing to use 
it. The problem has been that it is too limited for use in st. It has 
become better but it still is not good enough to replace both the data 
mapping and the driver's buffering. A quick look through the code suggests 
that it still can't handle big requests (up to 6 MB). Please tell me if I 
am wrong.

-- 
Kai
