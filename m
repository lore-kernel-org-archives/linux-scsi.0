From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Wed, 16 Mar 2005 08:58:39 +0100
Message-ID: <20050316075839.GC7842@suse.de>
References: <200503160209.j2G29cAf010870@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ns.virtualhost.dk ([195.184.98.160]:26337 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262290AbVCPH6l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 02:58:41 -0500
Content-Disposition: inline
In-Reply-To: <200503160209.j2G29cAf010870@hera.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: g.liakhovetski@gmx.de

On Thu, Mar 03 2005, Linux Kernel Mailing List wrote:
> ChangeSet 1.1982.29.77, 2005/03/03 10:41:40+02:00, lenehan@twibble.org
> 
> 	[PATCH] dc395x: Fix support for highmem
> 	
> 	From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 	
> 	Removes the page_to_virt and maps sg lists dynamically.
> 	This makes the driver work with highmem pages.
> 	
> 	Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 	Signed-off-by: Jamie Lenehan <lenehan@twibble.org>
> 	Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

Guys, who reviewed this? It looks completely bogus, using kmap() for tha
entire sg list is just wrong and can deadlock easily. The proper way is
of course to skip the virtual address requirement and dma map the sg
array properly.

>  dc395x.c |   48 +++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 35 insertions(+), 13 deletions(-)
> 
> 
> diff -Nru a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> --- a/drivers/scsi/dc395x.c	2005-03-15 18:09:50 -08:00
> +++ b/drivers/scsi/dc395x.c	2005-03-15 18:09:50 -08:00
> @@ -182,7 +182,7 @@
>   * cross a page boundy.
>   */
>  #define SEGMENTX_LEN	(sizeof(struct SGentry)*DC395x_MAX_SG_LISTENTRY)
> -
> +#define VIRTX_LEN	(sizeof(void *) * DC395x_MAX_SG_LISTENTRY)
>  
>  struct SGentry {
>  	u32 address;		/* bus! address */
> @@ -234,6 +234,7 @@
>  	u8 sg_count;			/* No of HW sg entries for this request */
>  	u8 sg_index;			/* Index of HW sg entry for this request */
>  	u32 total_xfer_length;		/* Total number of bytes remaining to be transfered */
> +	void **virt_map;
>  	unsigned char *virt_addr;	/* Virtual address of current transfer position */
>  
>  	/*
> @@ -1020,14 +1021,14 @@
>  			reqlen, cmd->request_buffer, cmd->use_sg,
>  			srb->sg_count);
>  
> -		srb->virt_addr = page_address(sl->page);
>  		for (i = 0; i < srb->sg_count; i++) {
> -			u32 busaddr = (u32)sg_dma_address(&sl[i]);
> -			u32 seglen = (u32)sl[i].length;
> -			sgp[i].address = busaddr;
> +			u32 seglen = (u32)sg_dma_len(sl + i);
> +			sgp[i].address = (u32)sg_dma_address(sl + i);
>  			sgp[i].length = seglen;
>  			srb->total_xfer_length += seglen;
> +			srb->virt_map[i] = kmap(sl[i].page);
>  		}
> +		srb->virt_addr = srb->virt_map[0];
>  		sgp += srb->sg_count - 1;
>  
>  		/*
> @@ -1964,6 +1965,7 @@
>  	int segment = cmd->use_sg;
>  	u32 xferred = srb->total_xfer_length - left; /* bytes transfered */
>  	struct SGentry *psge = srb->segment_x + srb->sg_index;
> +	void **virt = srb->virt_map;
>  
>  	dprintkdbg(DBG_0,
>  		"sg_update_list: Transfered %i of %i bytes, %i remain\n",
> @@ -2003,16 +2005,16 @@
>  
>  	/* We have to walk the scatterlist to find it */
>  	sg = (struct scatterlist *)cmd->request_buffer;
> +	idx = 0;
>  	while (segment--) {
>  		unsigned long mask =
>  		    ~((unsigned long)sg->length - 1) & PAGE_MASK;
>  		if ((sg_dma_address(sg) & mask) == (psge->address & mask)) {
> -			srb->virt_addr = (page_address(sg->page)
> -					   + psge->address -
> -					   (psge->address & PAGE_MASK));
> +			srb->virt_addr = virt[idx] + (psge->address & ~PAGE_MASK);
>  			return;
>  		}
>  		++sg;
> +		++idx;
>  	}
>  
>  	dprintkl(KERN_ERR, "sg_update_list: sg_to_virt failed\n");
> @@ -2138,7 +2140,7 @@
>  				DC395x_read32(acb, TRM_S1040_DMA_CXCNT));
>  		}
>  		/*
> -		 * calculate all the residue data that not yet tranfered
> +		 * calculate all the residue data that not yet transfered
>  		 * SCSI transfer counter + left in SCSI FIFO data
>  		 *
>  		 * .....TRM_S1040_SCSI_COUNTER (24bits)
> @@ -3256,6 +3258,7 @@
>  	struct scsi_cmnd *cmd = srb->cmd;
>  	enum dma_data_direction dir = cmd->sc_data_direction;
>  	if (cmd->use_sg && dir != PCI_DMA_NONE) {
> +		int i;
>  		/* unmap DC395x SG list */
>  		dprintkdbg(DBG_SG, "pci_unmap_srb: list=%08x(%05x)\n",
>  			srb->sg_bus_addr, SEGMENTX_LEN);
> @@ -3265,6 +3268,8 @@
>  		dprintkdbg(DBG_SG, "pci_unmap_srb: segs=%i buffer=%p\n",
>  			cmd->use_sg, cmd->request_buffer);
>  		/* unmap the sg segments */
> +		for (i = 0; i < srb->sg_count; i++)
> +			kunmap(virt_to_page(srb->virt_map[i]));
>  		pci_unmap_sg(acb->dev,
>  			     (struct scatterlist *)cmd->request_buffer,
>  			     cmd->use_sg, dir);
> @@ -3311,7 +3316,7 @@
>  
>  	if (cmd->use_sg) {
>  		struct scatterlist* sg = (struct scatterlist *)cmd->request_buffer;
> -		ptr = (struct ScsiInqData *)(page_address(sg->page) + sg->offset);
> +		ptr = (struct ScsiInqData *)(srb->virt_map[0] + sg->offset);
>  	} else {
>  		ptr = (struct ScsiInqData *)(cmd->request_buffer);
>  	}
> @@ -4246,8 +4251,9 @@
>  	const unsigned srbs_per_page = PAGE_SIZE/SEGMENTX_LEN;
>  
>  	for (i = 0; i < DC395x_MAX_SRB_CNT; i += srbs_per_page)
> -		if (acb->srb_array[i].segment_x)
> -			kfree(acb->srb_array[i].segment_x);
> +		kfree(acb->srb_array[i].segment_x);
> +
> +	vfree(acb->srb_array[0].virt_map);
>  }
>  
>  
> @@ -4263,9 +4269,12 @@
>  	int srb_idx = 0;
>  	unsigned i = 0;
>  	struct SGentry *ptr;
> +	void **virt_array;
>  
> -	for (i = 0; i < DC395x_MAX_SRB_CNT; i++)
> +	for (i = 0; i < DC395x_MAX_SRB_CNT; i++) {
>  		acb->srb_array[i].segment_x = NULL;
> +		acb->srb_array[i].virt_map = NULL;
> +	}
>  
>  	dprintkdbg(DBG_1, "Allocate %i pages for SG tables\n", pages);
>  	while (pages--) {
> @@ -4286,6 +4295,19 @@
>  		    ptr + (i * DC395x_MAX_SG_LISTENTRY);
>  	else
>  		dprintkl(KERN_DEBUG, "No space for tmsrb SG table reserved?!\n");
> +
> +	virt_array = vmalloc((DC395x_MAX_SRB_CNT + 1) * DC395x_MAX_SG_LISTENTRY * sizeof(void*));
> +
> +	if (!virt_array) {
> +		adapter_sg_tables_free(acb);
> +		return 1;
> +	}
> +
> +	for (i = 0; i < DC395x_MAX_SRB_CNT + 1; i++) {
> +		acb->srb_array[i].virt_map = virt_array;
> +		virt_array += DC395x_MAX_SG_LISTENTRY;
> +	}
> +
>  	return 0;
>  }
>  
> -
> To unsubscribe from this list: send the line "unsubscribe bk-commits-head" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Jens Axboe

