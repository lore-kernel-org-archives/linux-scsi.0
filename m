From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sg: increase sglist_len of the sg_scatter_hold
 structure
Date: Mon, 06 Aug 2007 13:09:44 +0900
Message-ID: <20070806130944R.fujita.tomonori@lab.ntt.co.jp>
References: <200708051531.l75FVnjP011717@mbox.iij4u.or.jp>
	<46B600F4.7020601@torque.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:51893 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbXHFEKP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Aug 2007 00:10:15 -0400
In-Reply-To: <46B600F4.7020601@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: tomof@acm.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp

On Sun, 05 Aug 2007 12:55:16 -0400
Douglas Gilbert <dougg@torque.net> wrote:

> FUJITA Tomonori wrote:
> > unsigned short is too small for sizeof(struct scatterlist) *
> > min(q->max_hw_segments, q->max_phys_segments).
> > 
> > This fixes memory leak with 4096 segments since 16 (likely sg size
> > with x86) * 4096 sets sglist_len to zero.
> > 
> > This might not happen without sg chaining support.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  drivers/scsi/sg.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> > index 2fc24e7..2c44bb0 100644
> > --- a/drivers/scsi/sg.c
> > +++ b/drivers/scsi/sg.c
> > @@ -114,7 +114,7 @@ static struct class_interface sg_interface = {
> >  
> >  typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
> >  	unsigned short k_use_sg; /* Count of kernel scatter-gather pieces */
> > -	unsigned short sglist_len; /* size of malloc'd scatter-gather list ++ */
> > +	unsigned sglist_len; /* size of malloc'd scatter-gather list ++ */
> >  	unsigned bufflen;	/* Size of (aggregate) data buffer */
> >  	unsigned b_malloc_len;	/* actual len malloc'ed in buffer */
> >  	struct scatterlist *buffer;/* scatter list */
> 
> Tomo,
> Thanks.
> 
> Signed-off-by: Douglas Gilbert <dougg@torque.net>

Thanks for the quick reply.

Allocating 64K contiguous memory is not good so the next thing to do
is converting sg to use the sg chaining support fully. Or it might be
time to finish the overdue task, to convert sg to use the block layer
functions.
