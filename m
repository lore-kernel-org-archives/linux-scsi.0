From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] FC pass thru - Rev IV
Date: Thu, 27 Nov 2008 20:01:41 -0600
Message-ID: <1227837701.3914.6.camel@localhost.localdomain>
References: <1227043498.4949.21.camel@ogier>
	 <20081127160331I.fujita.tomonori@lab.ntt.co.jp>
	 <492E6143.2080407@panasas.com>
	 <20081127185406L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40558 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbYK1CBp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Nov 2008 21:01:45 -0500
In-Reply-To: <20081127185406L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bharrosh@panasas.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, seokmann.ju@qlogic.com, andrew.vasquez@qlogic.com, sven@linux.vnet.ibm.com

On Thu, 2008-11-27 at 18:53 +0900, FUJITA Tomonori wrote:
> > +	blk_end_bidi_request(job->req, err, blk_rq_bytes(job->req), bytes_requested);
> > 
> > The residual count is left in req->data_len. Does bsg have a way to return the
> > residual to user-mode? It must, since Pete was using that for sure. Note that
> > you are looking for the bidi_read residual count.
> 
> Yeah, bsg has. struct sg_io_v4 has:
> 
> __s32 din_resid;	/* [o] din_xfer_len - actual_din_xfer_len */
> __s32 dout_resid;	/* [o] dout_xfer_len - actual_dout_xfer_len */
> 
> 
> > As was said by people. You must complete ALL bytes on both sides. Residual information
> > is passed through req->data_len. Other wise the request is still active.
> > 
> > (And yes blk_end_request uses blk_end_bidi_request internally)
> 
> We always complete all bytes on both sides. So why we do something
> like:
> 
> int blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
> {
> 	unsigned int bidi_bytes	= 0;
> 
> 	if (blk_bidi_rq(rq))
> 		bidi_bytes = req->next_rq->data_len;
> 
> 	return blk_end_io(rq, error, nr_bytes, bidi_bytes, NULL);
> }

That looks good ... care to patch it up (including conversion of all the
users) and send it to Jens for consideration?

> The callers can do something like:
> 
> blk_end_request(rq, err, rq->data_len);
> rq-->next_rq->data_len = resid;

Um ... I see what you're trying to do, but I don't think it works like
this.  The residual could be collected in the end_io call back which is
inline in the blk_end_request().

James


