From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 6/9] tgt: convert ibmvstgt and libsrp to use scsi_data_buffer
Date: Sun, 09 Sep 2007 13:12:03 +0300
Message-ID: <46E3C6F3.6020506@panasas.com>
References: <20070906183756K.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:6303 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756173AbXIIKNR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 06:13:17 -0400
In-Reply-To: <20070906183756K.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

On Fri, Sep 07 2007 at 0:50 +0300, FUJITA Tomonori <tomof@acm.org> wrote:
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/ibmvscsi/ibmvstgt.c |    2 +-
>  drivers/scsi/libsrp.c            |   27 ++++++++++++++-------------
>  2 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
> index 8ba7dd0..ab173d4 100644
> --- a/drivers/scsi/ibmvscsi/ibmvstgt.c
> +++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
> @@ -286,7 +286,7 @@ static int ibmvstgt_cmd_done(struct scsi_cmnd *sc,
>  	dprintk("%p %p %x %u\n", iue, target, vio_iu(iue)->srp.cmd.cdb[0],
>  		cmd->usg_sg);
>  
> -	if (sc->use_sg)
> +	if (scsi_sg_count(sc))
>  		err = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd, ibmvstgt_rdma, 1, 1);
>  
>  	spin_lock_irqsave(&target->lock, flags);
> diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
> index 732446e..32e1529 100644
> --- a/drivers/scsi/libsrp.c
> +++ b/drivers/scsi/libsrp.c
> @@ -192,18 +192,18 @@ static int srp_direct_data(struct scsi_cmnd *sc, struct srp_direct_buf *md,
>  
>  	if (dma_map) {
>  		iue = (struct iu_entry *) sc->SCp.ptr;
> -		sg = sc->request_buffer;
> +		sg = scsi_sglist(sc);
>  
> -		dprintk("%p %u %u %d\n", iue, sc->request_bufflen,
> -			md->len, sc->use_sg);
> +		dprintk("%p %u %u %d\n", iue, scsi_bufflen(sc),
> +			md->len, scsi_sg_count(sc));
>  
> -		nsg = dma_map_sg(iue->target->dev, sg, sc->use_sg,
> +		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
>  				 DMA_BIDIRECTIONAL);
>  		if (!nsg) {
> -			printk("fail to map %p %d\n", iue, sc->use_sg);
> +			printk("fail to map %p %d\n", iue, scsi_sg_count(sc));
>  			return 0;
>  		}
> -		len = min(sc->request_bufflen, md->len);
> +		len = min(scsi_bufflen(sc), md->len);
>  	} else
>  		len = md->len;
>  
> @@ -229,10 +229,10 @@ static int srp_indirect_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
>  
>  	if (dma_map || ext_desc) {
>  		iue = (struct iu_entry *) sc->SCp.ptr;
> -		sg = sc->request_buffer;
> +		sg = scsi_sglist(sc);
>  
>  		dprintk("%p %u %u %d %d\n",
> -			iue, sc->request_bufflen, id->len,
> +			iue, scsi_bufflen(sc), id->len,
>  			cmd->data_in_desc_cnt, cmd->data_out_desc_cnt);
>  	}
>  
> @@ -268,13 +268,14 @@ static int srp_indirect_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
>  
>  rdma:
>  	if (dma_map) {
> -		nsg = dma_map_sg(iue->target->dev, sg, sc->use_sg, DMA_BIDIRECTIONAL);
> +		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
> +				 DMA_BIDIRECTIONAL);
>  		if (!nsg) {
> -			eprintk("fail to map %p %d\n", iue, sc->use_sg);
> +			eprintk("fail to map %p %d\n", iue, scsi_sg_count(sc));
>  			err = -EIO;
>  			goto free_mem;
>  		}
> -		len = min(sc->request_bufflen, id->len);
> +		len = min(scsi_bufflen(sc), id->len);
>  	} else
>  		len = id->len;
>  
> @@ -425,8 +426,8 @@ int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
>  
>  	sc->SCp.ptr = info;
>  	memcpy(sc->cmnd, cmd->cdb, MAX_COMMAND_SIZE);
> -	sc->request_bufflen = len;
> -	sc->request_buffer = (void *) (unsigned long) addr;
> +	sc->sdb.length = len;
> +	sc->sdb.sglist = (void *) (unsigned long) addr;
>  	sc->tag = tag;
>  	err = scsi_tgt_queue_command(sc, (struct scsi_lun *) &cmd->lun, cmd->tag);
>  	if (err)

What is done here in srp_cmd_queue() looks scary to me. even today.
What is that u64 addr that gets truncated to unsigned long and put
on sglist? What data-buffer "len" is suppose to describe? And "dir" is 
for what data? It is made to look like addr is a linear pointer with
a use_sg==0 issued command, which is no longer allowed. Only we know
it is not, because of the "(void *)(unsigned long) addr;"
which is a bug in 64-bit.

If this is a totally private message sent threw the scsi-ml. I would
rather it was done with DMA_NONE,bufflen=0,sglist=NULL and put all
the user-info into scsi_cmnd.SCp like above "void* info".

Boaz
