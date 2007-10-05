From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/17] sym53c8xx: Remove data_mapping and data_mapped
Date: Fri, 05 Oct 2007 16:52:17 -0400
Message-ID: <4706A401.1060308@garzik.org>
References: <11916141143747-git-send-email-matthew@wil.cx> <11916141144042-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33117 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbXJEUwT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Oct 2007 16:52:19 -0400
In-Reply-To: <11916141144042-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> Before all commands used sg, data_mapping and data_mapped were used to
> distinguish whether the command had used map_single or map_sg.  Now all
> commands are sg, so we can delete data_mapping, data_mapped and the
> wrapper functions __unmap_scsi_data, __map_scsi_sg_data, unmap_scsi_data
> and map_scsi_sg_data.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/scsi/sym53c8xx_2/sym_glue.c |   33 +++------------------------------
>  1 files changed, 3 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
> index 11e0a28..924b5dd 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_glue.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
> @@ -134,8 +134,6 @@ static struct scsi_transport_template *sym2_transport_template = NULL;
>   *  Driver private area in the SCSI command structure.
>   */
>  struct sym_ucmd {		/* Override the SCSI pointer structure */
> -	dma_addr_t	data_mapping;
> -	unsigned char	data_mapped;
>  	unsigned char	to_do;			/* For error handling */
>  	void (*old_done)(struct scsi_cmnd *);	/* For error handling */
>  	struct completion *eh_done;		/* For error handling */
> @@ -144,37 +142,12 @@ struct sym_ucmd {		/* Override the SCSI pointer structure */
>  #define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)(&(cmd)->SCp))
>  #define SYM_SOFTC_PTR(cmd) sym_get_hcb(cmd->device->host)
>  
> -static void __unmap_scsi_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
> -{
> -	if (SYM_UCMD_PTR(cmd)->data_mapped)
> -		scsi_dma_unmap(cmd);
> -
> -	SYM_UCMD_PTR(cmd)->data_mapped = 0;
> -}
> -
> -static int __map_scsi_sg_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
> -{
> -	int use_sg;
> -
> -	use_sg = scsi_dma_map(cmd);
> -	if (use_sg > 0) {
> -		SYM_UCMD_PTR(cmd)->data_mapped  = 2;
> -		SYM_UCMD_PTR(cmd)->data_mapping = use_sg;
> -	}
> -
> -	return use_sg;
> -}
> -
> -#define unmap_scsi_data(np, cmd)	\
> -		__unmap_scsi_data(np->s.device, cmd)
> -#define map_scsi_sg_data(np, cmd)	\
> -		__map_scsi_sg_data(np->s.device, cmd)
>  /*
>   *  Complete a pending CAM CCB.
>   */
>  void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *cmd)
>  {
> -	unmap_scsi_data(np, cmd);
> +	scsi_dma_unmap(cmd);
>  	cmd->scsi_done(cmd);
>  }
>  
> @@ -307,14 +280,14 @@ static int sym_scatter(struct sym_hcb *np, struct sym_ccb *cp, struct scsi_cmnd
>  
>  	cp->data_len = 0;
>  
> -	use_sg = map_scsi_sg_data(np, cmd);
> +	use_sg = scsi_dma_map(cmd);
>  	if (use_sg > 0) {
>  		struct scatterlist *sg;
>  		struct sym_tcb *tp = &np->target[cp->target];
>  		struct sym_tblmove *data;
>  
>  		if (use_sg > SYM_CONF_MAX_SG) {
> -			unmap_scsi_data(np, cmd);
> +			scsi_dma_unmap(cmd);
>  			return -1;

check scsi_dma_map() for negative return value (failure)

ACK once that is done

