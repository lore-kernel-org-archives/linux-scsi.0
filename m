From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/3] scsi_data_buffer
Date: Thu, 8 Nov 2007 14:54:37 +0100
Message-ID: <20071108135437.GP5011@kernel.dk>
References: <4730ACAA.2060007@panasas.com> <4730B034.6050309@panasas.com> <473312AE.3000605@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:1624 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682AbXKHNyo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Nov 2007 08:54:44 -0500
Content-Disposition: inline
In-Reply-To: <473312AE.3000605@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, Benny Halevy <bhalevy@panasas.com>

On Thu, Nov 08 2007, Boaz Harrosh wrote:
> James, Jens please note the question below
> It is something that bothers me about sr.c 
> 
> On Tue, Nov 06 2007 at 20:19 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> >   In preparation for bidi we abstract all IO members of scsi_cmnd,
> >   that will need to duplicate, into a substructure.
> > 
> <snip>
> > 
> >   - sd.c and sr.c
> >     * sd and sr would adjust IO size to align on device's block
> >       size so code needs to change once we move to scsi_data_buff
> >       implementation.
> >     * Convert code to use scsi_for_each_sg
> >     * Use data accessors where appropriate.
> >     * Remove dead code (req_data_dir() != READ && != WRITE)
> > 
> <snip>
> > diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> > index 7702681..6d3bf41 100644
> > --- a/drivers/scsi/sr.c
> > +++ b/drivers/scsi/sr.c
> > @@ -226,7 +226,7 @@ out:
> >  static int sr_done(struct scsi_cmnd *SCpnt)
> >  {
> >  	int result = SCpnt->result;
> > -	int this_count = SCpnt->request_bufflen;
> > +	int this_count = scsi_bufflen(SCpnt);
> >  	int good_bytes = (result == 0 ? this_count : 0);
> >  	int block_sectors = 0;
> >  	long error_sector;
> > @@ -368,23 +368,21 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
> >  	} else if (rq_data_dir(rq) == READ) {
> >  		SCpnt->cmnd[0] = READ_10;
> >  		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
> > -	} else {
> > -		blk_dump_rq_flags(rq, "Unknown sr command");
> > -		goto out;
> >  	}
> >  
> >  	{
> > -		struct scatterlist *sg = SCpnt->request_buffer;
> > -		int i, size = 0;
> > -		for (i = 0; i < SCpnt->use_sg; i++)
> > -			size += sg[i].length;
> > +		struct scatterlist *sg;
> > +		int i, size = 0, sg_count = scsi_sg_count(SCpnt);
> > +
> > +		scsi_for_each_sg (SCpnt, sg, sg_count, i)
> > +			size += sg->length;
> >  
> > -		if (size != SCpnt->request_bufflen && SCpnt->use_sg) {
> > +		if (size != scsi_bufflen(SCpnt)) {
> >  			scmd_printk(KERN_ERR, SCpnt,
> >  				"mismatch count %d, bytes %d\n",
> > -				size, SCpnt->request_bufflen);
> > -			if (SCpnt->request_bufflen > size)
> > -				SCpnt->request_bufflen = size;
> > +				size, scsi_bufflen(SCpnt));
> > +			if (scsi_bufflen(SCpnt) > size)
> > +				SCpnt->sdb.length = size;
> >  		}
> >  	}
> >  
> > @@ -392,12 +390,12 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
> >  	 * request doesn't start on hw block boundary, add scatter pads
> >  	 */
> >  	if (((unsigned int)rq->sector % (s_size >> 9)) ||
> > -	    (SCpnt->request_bufflen % s_size)) {
> > +	    (scsi_bufflen(SCpnt) % s_size)) {
> >  		scmd_printk(KERN_NOTICE, SCpnt, "unaligned transfer\n");
> >  		goto out;
> >  	}
> Here we check I/O is "large-block" aligned. Both start and size
> 
> >  
> > -	this_count = (SCpnt->request_bufflen >> 9) / (s_size >> 9);
> > +	this_count = (scsi_bufflen(SCpnt) >> 9) / (s_size >> 9);
> >  
> Number of "large-blocks"
> 
> >  
> >  	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%ld 512 byte blocks.\n",
> > @@ -411,7 +409,7 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
> >  
> >  	if (this_count > 0xffff) {
> >  		this_count = 0xffff;
> > -		SCpnt->request_bufflen = this_count * s_size;
> > +		SCpnt->sdb.length = this_count * s_size;
> >  	}
> >  
> Here is my problem:
> In the case that the transfer is bigger than 0xffff * s_size
> (512/1024/2048) we modify ->request_bufflen. Now this has two bad
> effects, the way I understand it, please fix me in my
> misunderstanding.
> 
> 1. Later in sr_done doing return good_bytes=cmd->request_bufflen will
> only complete the cut-out bytes. Meaning possible BIO leak, since the
> original request_bufflen was lost. (not all bytes are completed)
>
> 
> 2. What mechanics will re-send, or even knows, that not the complete
> request was transfered? The way I understand it, a cmnd->resid must be
> set, in this case.  Now the normal cmnd->resid is not enough because
> it will be written by drivers, sr needs to stash a resid somewhere and
> add it to cmnd->resid in sr_done(). But ...
> 

It's not lost, the request will be requeued in scsi_end_request(). The
original state is in the request structure, and end_that_request_chunk()
will return not-done when you complete this first part.

-- 
Jens Axboe

