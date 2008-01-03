From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] libata: eliminate the home grown dma padding in favour
	of	that provided by the block layer
Date: Thu, 03 Jan 2008 09:12:31 -0600
Message-ID: <1199373151.3122.3.camel@localhost.localdomain>
References: <1199138168.3110.12.camel@localhost.localdomain>
	 <20080103170148K.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080103170148K.tomof@acm.org>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jens.Axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org
List-Id: linux-scsi@vger.kernel.org


On Thu, 2008-01-03 at 16:58 +0900, FUJITA Tomonori wrote:
> On Mon, 31 Dec 2007 15:56:08 -0600
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > @@ -1080,24 +1073,15 @@ extern void ata_port_pbar_desc(struct ata_port *ap, int bar, ssize_t offset,
> >  static inline struct scatterlist *
> >  ata_qc_first_sg(struct ata_queued_cmd *qc)
> >  {
> > -	qc->n_iter = 0;
> >  	if (qc->n_elem)
> >  		return qc->__sg;
> > -	if (qc->pad_len)
> > -		return &qc->pad_sgent;
> >  	return NULL;
> >  }
> >  
> >  static inline struct scatterlist *
> >  ata_qc_next_sg(struct scatterlist *sg, struct ata_queued_cmd *qc)
> >  {
> > -	if (sg == &qc->pad_sgent)
> > -		return NULL;
> > -	if (++qc->n_iter < qc->n_elem)
> > -		return sg_next(sg);
> > -	if (qc->pad_len)
> > -		return &qc->pad_sgent;
> > -	return NULL;
> > +	return sg_next(sg);
> >  }
> >  
> >  #define ata_for_each_sg(sg, qc) \
> 
> How about removing ata_qc_first_sg and ata_qc_next_sg completely?
> 
> Now we can just replace ata_qc_next_sg with sg_next. qc->__sg seems to
> be always initialized to NULL so we can remove ata_qc_first_sg too.

Sure ... I assumed (without actually looking) that the inlines were
there because they were an API used throughout the drivers.  Actually,
grep tells me they're only used in the ata_for_each_sg macro, so this
patch looks good.

Thanks,

James

> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 4f6404c..2774882 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1054,25 +1054,8 @@ extern void ata_port_pbar_desc(struct ata_port *ap, int bar, ssize_t offset,
>  			       const char *name);
>  #endif
>  
> -/*
> - * qc helpers
> - */
> -static inline struct scatterlist *
> -ata_qc_first_sg(struct ata_queued_cmd *qc)
> -{
> -	if (qc->n_elem)
> -		return qc->__sg;
> -	return NULL;
> -}
> -
> -static inline struct scatterlist *
> -ata_qc_next_sg(struct scatterlist *sg, struct ata_queued_cmd *qc)
> -{
> -	return sg_next(sg);
> -}
> -
>  #define ata_for_each_sg(sg, qc) \
> -	for (sg = ata_qc_first_sg(qc); sg; sg = ata_qc_next_sg(sg, qc))
> +	for (sg = qc->__sg; sg; sg = sg_next(sg))
>  
>  static inline unsigned int ata_tag_valid(unsigned int tag)
>  {
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

