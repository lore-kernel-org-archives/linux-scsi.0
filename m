From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 29/33] infiniband: sg chaining support
Date: Mon, 16 Jul 2007 22:21:59 +0900
Message-ID: <200707161321.l6GDLxfA028923@mbox.iij4u.or.jp>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
	<11845792693361-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:60480 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289AbXGPNWT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 09:22:19 -0400
In-Reply-To: <11845792693361-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rolandd@cisco.com, fujita.tomonori@lab.ntt.co.jp

From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 29/33] infiniband: sg chaining support
Date: Mon, 16 Jul 2007 11:47:43 +0200

> @@ -226,7 +228,8 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
>  			       struct iser_page_vec *page_vec,
>  			       struct ib_device *ibdev)
>  {
> -	struct scatterlist *sg = (struct scatterlist *)data->buf;
> +	struct scatterlist *sgl = (struct scatterlist *)data->buf;
> +	struct scatterlist *sg;
>  	u64 first_addr, last_addr, page;
>  	int end_aligned;
>  	unsigned int cur_page = 0;
> @@ -234,14 +237,14 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
>  	int i;
>  
>  	/* compute the offset of first element */
> -	page_vec->offset = (u64) sg[0].offset & ~MASK_4K;
> +	page_vec->offset = (u64) sgl[0].offset & ~MASK_4K;
>  
> -	for (i = 0; i < data->dma_nents; i++) {
> -		unsigned int dma_len = ib_sg_dma_len(ibdev, &sg[i]);
> +	for_each_sg(sgl, sg, data->dma_nents, i) {
> +		unsigned int dma_len = ib_sg_dma_len(ibdev, sg);
>  
>  		total_sz += dma_len;
>  
> -		first_addr = ib_sg_dma_address(ibdev, &sg[i]);
> +		first_addr = ib_sg_dma_address(ibdev, sg);
>  		last_addr  = first_addr + dma_len;
>  
>  		end_aligned   = !(last_addr  & ~MASK_4K);
> @@ -249,9 +252,9 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
>  		/* continue to collect page fragments till aligned or SG ends */
>  		while (!end_aligned && (i + 1 < data->dma_nents)) {
>  			i++;

Do we need to replace i++ with sg = sg_next(sg) here?


> -			dma_len = ib_sg_dma_len(ibdev, &sg[i]);
> +			dma_len = ib_sg_dma_len(ibdev, sg);
>  			total_sz += dma_len;
> -			last_addr = ib_sg_dma_address(ibdev, &sg[i]) + dma_len;
> +			last_addr = ib_sg_dma_address(ibdev, sg) + dma_len;
>  			end_aligned = !(last_addr  & ~MASK_4K);
>  		}
>  
> @@ -286,25 +289,26 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
>  static unsigned int iser_data_buf_aligned_len(struct iser_data_buf *data,
>  					      struct ib_device *ibdev)
>  {
> -	struct scatterlist *sg;
> +	struct scatterlist *sgl, *sg;
>  	u64 end_addr, next_addr;
>  	int i, cnt;
>  	unsigned int ret_len = 0;
>  
> -	sg = (struct scatterlist *)data->buf;
> +	sgl = (struct scatterlist *)data->buf;
>  
> -	for (cnt = 0, i = 0; i < data->dma_nents; i++, cnt++) {
> +	cnt = 0;
> +	for_each_sg(sgl, sg, data->dma_nents, i) {
>  		/* iser_dbg("Checking sg iobuf [%d]: phys=0x%08lX "
>  		   "offset: %ld sz: %ld\n", i,
> -		   (unsigned long)page_to_phys(sg[i].page),
> -		   (unsigned long)sg[i].offset,
> -		   (unsigned long)sg[i].length); */
> -		end_addr = ib_sg_dma_address(ibdev, &sg[i]) +
> -			   ib_sg_dma_len(ibdev, &sg[i]);
> +		   (unsigned long)page_to_phys(sg->page),
> +		   (unsigned long)sg->offset,
> +		   (unsigned long)sg->length); */
> +		end_addr = ib_sg_dma_address(ibdev, sg) +
> +			   ib_sg_dma_len(ibdev, sg);
>  		/* iser_dbg("Checking sg iobuf end address "
>  		       "0x%08lX\n", end_addr); */
>  		if (i + 1 < data->dma_nents) {
> -			next_addr = ib_sg_dma_address(ibdev, &sg[i+1]);
> +			next_addr = ib_sg_dma_address(ibdev, sg_next(sg));
>  			/* are i, i+1 fragments of the same page? */
>  			if (end_addr == next_addr)
>  				continue;
> @@ -324,15 +328,16 @@ static unsigned int iser_data_buf_aligned_len(struct iser_data_buf *data,
>  static void iser_data_buf_dump(struct iser_data_buf *data,
>  			       struct ib_device *ibdev)
>  {
> -	struct scatterlist *sg = (struct scatterlist *)data->buf;
> +	struct scatterlist *sgl = (struct scatterlist *)data->buf;
> +	struct scatterlist *sg;
>  	int i;
>  
> -	for (i = 0; i < data->dma_nents; i++)
> +	for_each_sg(sgl, sg, data->dma_nents, i)
>  		iser_err("sg[%d] dma_addr:0x%lX page:0x%p "
>  			 "off:0x%x sz:0x%x dma_len:0x%x\n",
> -			 i, (unsigned long)ib_sg_dma_address(ibdev, &sg[i]),
> -			 sg[i].page, sg[i].offset,
> -			 sg[i].length, ib_sg_dma_len(ibdev, &sg[i]));
> +			 i, (unsigned long)ib_sg_dma_address(ibdev, sg),
> +			 sg->page, sg->offset,
> +			 sg->length, ib_sg_dma_len(ibdev, sg));
>  }
>  
>  static void iser_dump_page_vec(struct iser_page_vec *page_vec)
> -- 
> 1.5.3.rc0.90.gbaa79
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
