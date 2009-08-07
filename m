From: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 3/3] drivers/scsi: Add kmalloc NULL tests
Date: Fri, 7 Aug 2009 06:39:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0908070639020.1956@ask.diku.dk>
References: <Pine.LNX.4.64.0908062205190.19100@ask.diku.dk>
 <1249593604.10463.18.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:39891 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbZHGEjl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Aug 2009 00:39:41 -0400
In-Reply-To: <1249593604.10463.18.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Thu, 6 Aug 2009, James Bottomley wrote:

> On Thu, 2009-08-06 at 22:06 +0200, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Check that the result of kmalloc is not NULL before passing it to other
> > functions.
> > 
> > The semantic match that finds this problem is as follows:
> > (http://coccinelle.lip6.fr/)
> > 
> > // <smpl>
> > @@
> > expression *x;
> > identifier f;
> > constant char *C;
> > @@
> > 
> > x = \(kmalloc\|kcalloc\|kzalloc\)(...);
> > ... when != x == NULL
> >     when != x != NULL
> >     when != (x || ...)
> > (
> > kfree(x)
> > |
> > f(...,C,...,x,...)
> > |
> > *f(...,x,...)
> > |
> > *x->f
> > )
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> >  drivers/scsi/sr.c                   |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> > index cce0fe4..3fbf42e 100644
> > --- a/drivers/scsi/sr.c
> > +++ b/drivers/scsi/sr.c
> > @@ -211,6 +211,8 @@ static int sr_media_change(struct cdrom_device_info *cdi, int slot)
> >  	}
> >  
> >  	sshdr =  kzalloc(sizeof(*sshdr), GFP_KERNEL);
> > +	if (!sshdr)
> > +		return -ENOMEM;
> 
> this isn't necessary; sr_test_unit_ready is designed to take a NULL
> pointer for sshdr ... it's just slightly less useful when this happens,
> but it still returns some status.

OK, I agree.  Thanks.

julia
