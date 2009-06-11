From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 4/7] sg_io: don't perform unneeded copy in compat code
Date: Thu, 11 Jun 2009 12:53:37 +0200
Message-ID: <20090611105337.GM11363@kernel.dk>
References: <200906101956.n5AJuvuQ009909@imap1.linux-foundation.org> <20090611193102F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:56580 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761964AbZFKKxf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2009 06:53:35 -0400
Content-Disposition: inline
In-Reply-To: <20090611193102F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, alexey.zaytsev@gmail.com, dgilbert@interlog.com

On Thu, Jun 11 2009, FUJITA Tomonori wrote:
> On Wed, 10 Jun 2009 12:56:56 -0700
> akpm@linux-foundation.org wrote:
> 
> > From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> > 
> > The members from 'status' in struct sg_io_hdr to the last are used to
> > transfer information from kernel to user space.  The values that user
> > space sets are just ignored.
> > 
> > Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> > Cc: Douglas Gilbert <dgilbert@interlog.com>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Cc: Jens Axboe <jens.axboe@oracle.com>
> > Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  fs/compat_ioctl.c |    6 ------
> >  1 file changed, 6 deletions(-)
> > 
> > diff -puN fs/compat_ioctl.c~sg_io-dont-perform-unneeded-copy-in-compat-code fs/compat_ioctl.c
> > --- a/fs/compat_ioctl.c~sg_io-dont-perform-unneeded-copy-in-compat-code
> > +++ a/fs/compat_ioctl.c
> > @@ -787,12 +787,6 @@ static int sg_ioctl_trans(unsigned int f
> >  	if (put_user(compat_ptr(data), &sgio->usr_ptr))
> >  		return -EFAULT;
> >  
> > -	if (copy_in_user(&sgio->status, &sgio32->status,
> > -			 (4 * sizeof(unsigned char)) +
> > -			 (2 * sizeof(unsigned short)) +
> > -			 (3 * sizeof(int))))
> > -		return -EFAULT;
> > -
> >  	err = sys_ioctl(fd, cmd, (unsigned long) sgio);
> >  
> >  	if (err >= 0) {
> 
> Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Ditto from me.

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

