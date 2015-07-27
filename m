From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: fix memory leak with scsi-mq
Date: Mon, 27 Jul 2015 13:52:04 -0400
Message-ID: <1438019524.1921.369.camel@localhost.localdomain>
References: <55A7D079.9010706@cybernetics.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55A7D079.9010706@cybernetics.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <JBottomley@Odin.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-07-16 at 11:40 -0400, Tony Battersby wrote:
> Fix a memory leak with scsi-mq triggered by commands with large data
> transfer length.
> 
> __sg_alloc_table() sets both table->nents and table->orig_nents to the
> same value.  When the scatterlist is DMA-mapped, table->nents is
> overwritten with the (possibly smaller) size of the DMA-mapped
> scatterlist, while table->orig_nents retains the original size of the
> allocated scatterlist.  scsi_free_sgtable() should therefore check
> orig_nents instead of nents, and all code that initializes sdb->table
> without calling __sg_alloc_table() should set both nents and orig_nents.
> 
> Fixes: d285203cf647 ("scsi: add support for a blk-mq based I/O path.")
> Cc: <stable@vger.kernel.org> # 3.17+
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
> 
> For immediate inclusion.
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 106884a..cfadcce 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -944,7 +944,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
>  			    scmd->sdb.length);
>  		scmd->sdb.table.sgl = &ses->sense_sgl;
>  		scmd->sc_data_direction = DMA_FROM_DEVICE;
> -		scmd->sdb.table.nents = 1;
> +		scmd->sdb.table.nents = scmd->sdb.table.orig_nents = 1;
>  		scmd->cmnd[0] = REQUEST_SENSE;
>  		scmd->cmnd[4] = scmd->sdb.length;
>  		scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b1a2631..448ebda 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -583,7 +583,7 @@ static struct scatterlist *scsi_sg_alloc(unsigned int nents, gfp_t gfp_mask)
>  
>  static void scsi_free_sgtable(struct scsi_data_buffer *sdb, bool mq)
>  {
> -	if (mq && sdb->table.nents <= SCSI_MAX_SG_SEGMENTS)
> +	if (mq && sdb->table.orig_nents <= SCSI_MAX_SG_SEGMENTS)
>  		return;
>  	__sg_free_table(&sdb->table, SCSI_MAX_SG_SEGMENTS, mq, scsi_sg_free);
>  }
> @@ -597,8 +597,8 @@ static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
>  
>  	if (mq) {
>  		if (nents <= SCSI_MAX_SG_SEGMENTS) {
> -			sdb->table.nents = nents;
> -			sg_init_table(sdb->table.sgl, sdb->table.nents);
> +			sdb->table.nents = sdb->table.orig_nents = nents;
> +			sg_init_table(sdb->table.sgl, nents);
>  			return 0;
>  		}
>  		first_chunk = sdb->table.sgl;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks good.  James, can we get this in please?

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
