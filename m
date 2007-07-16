From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 29/33] infiniband: sg chaining support
Date: Mon, 16 Jul 2007 15:26:28 +0200
Message-ID: <20070716132627.GT5195@kernel.dk>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792693361-git-send-email-jens.axboe@oracle.com> <200707161321.l6GDLxfA028923@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:27561 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032AbXGPN1K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 09:27:10 -0400
Content-Disposition: inline
In-Reply-To: <200707161321.l6GDLxfA028923@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rolandd@cisco.com, fujita.tomonori@lab.ntt.co.jp

On Mon, Jul 16 2007, FUJITA Tomonori wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: [PATCH 29/33] infiniband: sg chaining support
> Date: Mon, 16 Jul 2007 11:47:43 +0200
> 
> > @@ -226,7 +228,8 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
> >  			       struct iser_page_vec *page_vec,
> >  			       struct ib_device *ibdev)
> >  {
> > -	struct scatterlist *sg = (struct scatterlist *)data->buf;
> > +	struct scatterlist *sgl = (struct scatterlist *)data->buf;
> > +	struct scatterlist *sg;
> >  	u64 first_addr, last_addr, page;
> >  	int end_aligned;
> >  	unsigned int cur_page = 0;
> > @@ -234,14 +237,14 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
> >  	int i;
> >  
> >  	/* compute the offset of first element */
> > -	page_vec->offset = (u64) sg[0].offset & ~MASK_4K;
> > +	page_vec->offset = (u64) sgl[0].offset & ~MASK_4K;
> >  
> > -	for (i = 0; i < data->dma_nents; i++) {
> > -		unsigned int dma_len = ib_sg_dma_len(ibdev, &sg[i]);
> > +	for_each_sg(sgl, sg, data->dma_nents, i) {
> > +		unsigned int dma_len = ib_sg_dma_len(ibdev, sg);
> >  
> >  		total_sz += dma_len;
> >  
> > -		first_addr = ib_sg_dma_address(ibdev, &sg[i]);
> > +		first_addr = ib_sg_dma_address(ibdev, sg);
> >  		last_addr  = first_addr + dma_len;
> >  
> >  		end_aligned   = !(last_addr  & ~MASK_4K);
> > @@ -249,9 +252,9 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
> >  		/* continue to collect page fragments till aligned or SG ends */
> >  		while (!end_aligned && (i + 1 < data->dma_nents)) {
> >  			i++;
> 
> Do we need to replace i++ with sg = sg_next(sg) here?

We do, updating the patch. Thanks for your review!

-- 
Jens Axboe

