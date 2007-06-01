From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: 2.6.22-rc3-mm1
Date: Fri, 1 Jun 2007 09:09:55 +0200
Message-ID: <20070601090955.272806d8@gondolin.boeblingen.de.ibm.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<20070531140922.2e55aefb@gondolin.boeblingen.de.ibm.com>
	<20070531121557.GQ23968@parisc-linux.org>
	<20070531142048.05edf133@gondolin.boeblingen.de.ibm.com>
	<465EC101.7010105@garzik.org>
	<20070531151338.GA759@infradead.org>
	<20070531151005.5c5db8af.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:1863 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbXFAHJ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jun 2007 03:09:59 -0400
In-Reply-To: <20070531151005.5c5db8af.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Dan Williams <dan.j.williams@intel.com>

On Thu, 31 May 2007 15:10:05 -0700,
Andrew Morton <akpm@linux-foundation.org> wrote:

> Cornelia, afaict your patch has no actual delendency upon Dan's
> dma-mapping-prevent-dma-dependent-code-from-linking-on.patch, correct?  If
> so, I can merge it via James and then merge Dan's patch once James has
> merged.

AFAICS there's no dependency in that direction.

> diff -puN include/scsi/scsi_cmnd.h~scsi-dont-build-scsi_dma_mapunmap-for-has_dma include/scsi/scsi_cmnd.h
> --- a/include/scsi/scsi_cmnd.h~scsi-dont-build-scsi_dma_mapunmap-for-has_dma
> +++ a/include/scsi/scsi_cmnd.h
> @@ -135,8 +135,10 @@ extern void scsi_kunmap_atomic_sg(void *
>  extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
>  extern void scsi_free_sgtable(struct scatterlist *, int);
> 
> +#ifdef CONFIG_SCSI_DMA
>  extern int scsi_dma_map(struct scsi_cmnd *cmd);
>  extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
> +#endif
> 
>  #define scsi_sg_count(cmd) ((cmd)->use_sg)
>  #define scsi_sglist(cmd) ((struct scatterlist *)(cmd)->request_buffer)
> 
> We don't really need the ifdefs here.  If someone incorrectly calls these
> functions then they'll get a link-time failure anyway.  The downside of
> removing these ifdefs is that they won't get a compile-time warning, but I
> tend to think that this small cost is worth it.

OK, fine with me.
