From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] libata: eliminate the home grown dma padding in favour
 of	that provided by the block layer
Date: Thu, 3 Jan 2008 16:58:49 +0900
Message-ID: <20080103170148K.tomof@acm.org>
References: <1199138168.3110.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:45142 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbYACIC1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jan 2008 03:02:27 -0500
In-Reply-To: <1199138168.3110.12.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jens.Axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.orgfujita.tomonori@lab.ntt.co.jp

On Mon, 31 Dec 2007 15:56:08 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> ATA requires that all DMA transfers begin and end on word boundaries.
> Because of this, a large amount of machinery grew up in ide to adjust
> scatterlists on this basis.  However, as of 2.5, the block layer has a
> dma_alignment variable which ensures both the beginning and length of a
> DMA transfer are aligned on the dma_alignment boundary.  Although the
> block layer does adjust the beginning of the transfer to ensure this
> happens, it doesn't actually adjust the length, it merely makes sure
> that space is allocated for transfers beyond the declared length.  The
> upshot of this is that scatterlists may be padded to any size between
> the actual length and the length adjusted to the dma_alignment safely
> knowing that memory is allocated in this region.

Great!


> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 124033c..2f40d57 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -282,7 +282,7 @@ enum {
>  
>  	/* size of buffer to pad xfers ending on unaligned boundaries */
>  	ATA_DMA_PAD_SZ		= 4,
> -	ATA_DMA_PAD_BUF_SZ	= ATA_DMA_PAD_SZ * ATA_MAX_QUEUE,
> +	ATA_DMA_PAD_MASK	= ATA_DMA_PAD_SZ - 1,
>  
>  	/* ering size */
>  	ATA_ERING_SIZE		= 32,
> @@ -446,12 +446,9 @@ struct ata_queued_cmd {
>  	unsigned long		flags;		/* ATA_QCFLAG_xxx */
>  	unsigned int		tag;
>  	unsigned int		n_elem;
> -	unsigned int		n_iter;
> -	unsigned int		orig_n_elem;
>  
>  	int			dma_dir;
>  
> -	unsigned int		pad_len;
>  	unsigned int		sect_size;
>  
>  	unsigned int		nbytes;
> @@ -461,7 +458,6 @@ struct ata_queued_cmd {
>  	unsigned int		cursg_ofs;
>  
>  	struct scatterlist	sgent;
> -	struct scatterlist	pad_sgent;
>  	void			*buf_virt;
>  
>  	/* DO NOT iterate over __sg manually, use ata_for_each_sg() */
> @@ -606,9 +602,6 @@ struct ata_port {
>  	struct ata_prd		*prd;	 /* our SG list */
>  	dma_addr_t		prd_dma; /* and its DMA mapping */
>  
> -	void			*pad;	/* array of DMA pad buffers */
> -	dma_addr_t		pad_dma;
> -
>  	struct ata_ioports	ioaddr;	/* ATA cmd/ctl/dma register blocks */
>  
>  	u8			ctl;	/* cache of ATA control register */
> @@ -1080,24 +1073,15 @@ extern void ata_port_pbar_desc(struct ata_port *ap, int bar, ssize_t offset,
>  static inline struct scatterlist *
>  ata_qc_first_sg(struct ata_queued_cmd *qc)
>  {
> -	qc->n_iter = 0;
>  	if (qc->n_elem)
>  		return qc->__sg;
> -	if (qc->pad_len)
> -		return &qc->pad_sgent;
>  	return NULL;
>  }
>  
>  static inline struct scatterlist *
>  ata_qc_next_sg(struct scatterlist *sg, struct ata_queued_cmd *qc)
>  {
> -	if (sg == &qc->pad_sgent)
> -		return NULL;
> -	if (++qc->n_iter < qc->n_elem)
> -		return sg_next(sg);
> -	if (qc->pad_len)
> -		return &qc->pad_sgent;
> -	return NULL;
> +	return sg_next(sg);
>  }
>  
>  #define ata_for_each_sg(sg, qc) \

How about removing ata_qc_first_sg and ata_qc_next_sg completely?

Now we can just replace ata_qc_next_sg with sg_next. qc->__sg seems to
be always initialized to NULL so we can remove ata_qc_first_sg too.


diff --git a/include/linux/libata.h b/include/linux/libata.h
index 4f6404c..2774882 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1054,25 +1054,8 @@ extern void ata_port_pbar_desc(struct ata_port *ap, int bar, ssize_t offset,
 			       const char *name);
 #endif
 
-/*
- * qc helpers
- */
-static inline struct scatterlist *
-ata_qc_first_sg(struct ata_queued_cmd *qc)
-{
-	if (qc->n_elem)
-		return qc->__sg;
-	return NULL;
-}
-
-static inline struct scatterlist *
-ata_qc_next_sg(struct scatterlist *sg, struct ata_queued_cmd *qc)
-{
-	return sg_next(sg);
-}
-
 #define ata_for_each_sg(sg, qc) \
-	for (sg = ata_qc_first_sg(qc); sg; sg = ata_qc_next_sg(sg, qc))
+	for (sg = qc->__sg; sg; sg = sg_next(sg))
 
 static inline unsigned int ata_tag_valid(unsigned int tag)
 {
