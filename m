From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC/RFT 1/4]  add some block layer helpers
Date: Thu, 15 Sep 2005 11:09:26 +0100
Message-ID: <20050915100926.GA24689@infradead.org>
References: <1126736384.16778.24.camel@max> <43291280.5060506@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:61899 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932444AbVIOKJ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 06:09:27 -0400
Content-Disposition: inline
In-Reply-To: <43291280.5060506@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

> > /**
> >+ * blk_rq_map_kern_iov - map kernel data to a request, for REQ_BLOCK_PC 
> >usage
> >+ * @q:		request queue where request should be inserted
> >+ * @rq:		request to fill
> >+ * @vec:	pointer to kvec
> >+ * @vec_count:	number of elements in kvec
> >+ * @gfp_mask:	memory allocation flags
> >+ *
> >+ * blk_rq_map_kern_iov maps a kvec into a multiple bio request so that
> >+ * it can create very large requests.
> >+ *
> >+ * For now we assume that each element will fit in one bio
> >+ */
> >+int blk_rq_map_kern_iov(request_queue_t *q, struct request *rq,
> >+			struct kvec *vec, int vec_count, unsigned int gfp)
> >+{
> 
> On second thought, I think this function should work on pages and not 
> kernel addresses. It also has a leak in the error path.

Passing down <page,offset,len> tuples, aka struct bio_vec sounds like
the better API indeed as all callers seem to either do virt_to_page or
allocate new pages anyway.  This should also fix the highmem problems
inherited from the old code.
