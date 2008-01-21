From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v3] use dynamically allocated sense buffer
Date: Mon, 21 Jan 2008 12:59:36 +0900
Message-ID: <20080121125936R.fujita.tomonori@lab.ntt.co.jp>
References: <20080116133217D.fujita.tomonori@lab.ntt.co.jp>
	<1200847016.3105.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:46326 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264AbYAUEAD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Jan 2008 23:00:03 -0500
In-Reply-To: <1200847016.3105.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, linux-scsi@vger.kernel.org, tomof@acm.org

On Sun, 20 Jan 2008 10:36:56 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> 
> On Wed, 2008-01-16 at 13:32 +0900, FUJITA Tomonori wrote:
> > This is the third version of:
> > 
> > http://marc.info/?l=linux-scsi&m=120038907123706&w=2
> [...]
> > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > index 54ff611..0a4a5b8 100644
> > --- a/drivers/scsi/scsi.c
> > +++ b/drivers/scsi/scsi.c
> > @@ -186,6 +190,21 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
> >  			list_del_init(&cmd->list);
> >  		}
> >  		spin_unlock_irqrestore(&shost->free_list_lock, flags);
> > +
> > +		if (cmd) {
> > +			buf = cmd->sense_buffer;
> > +			memset(cmd, 0, sizeof(*cmd));
> > +			cmd->sense_buffer = buf;
> > +		}
> > +	} else {
> > +		buf = kmem_cache_alloc(sense_buffer_slab, __GFP_DMA|gfp_mask);
> 
> This is going to cause the enterprise some angst because ZONE_DMA can be
> very small, and the enterprise requrements for commands in flight very
> large.  I also think its unnecessary if we know the host isn't requiring
> ISA DMA.

Yes, I should have done properly.


>  How about the below to fix this, it's based on the existing
> infrastructure for solving the very same problem.

Looks nice. Integrating sense_buffer_pool into struct
scsi_host_cmd_pool looks much better.


> James
> 
> ---
> 
> >From e7ffbd81684779f5eb41d66d5f499b82af40e12b Mon Sep 17 00:00:00 2001
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Sun, 20 Jan 2008 09:28:24 -0600
> Subject: [SCSI] don't use __GFP_DMA for sense buffers if not required
> 
> Only hosts which actually have ISA DMA requirements need sense buffers
> coming out of ZONE_DMA, so only use the __GFP_DMA flag for that case
> to avoid allocating this scarce resource if it's not necessary.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/hosts.c     |    9 +----
>  drivers/scsi/scsi.c      |  106 +++++++++++++++++++--------------------------
>  drivers/scsi/scsi_priv.h |    2 -
>  3 files changed, 46 insertions(+), 71 deletions(-)
> 

(snip)

> @@ -310,7 +313,6 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
>  {
>  	struct scsi_host_cmd_pool *pool;
>  	struct scsi_cmnd *cmd;
> -	unsigned char *sense_buffer;
>  
>  	spin_lock_init(&shost->free_list_lock);
>  	INIT_LIST_HEAD(&shost->free_list);
> @@ -322,10 +324,13 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
>  	mutex_lock(&host_cmd_pool_mutex);
>  	pool = (shost->unchecked_isa_dma ? &scsi_cmd_dma_pool : &scsi_cmd_pool);
>  	if (!pool->users) {
> -		pool->slab = kmem_cache_create(pool->name,
> -				sizeof(struct scsi_cmnd), 0,
> -				pool->slab_flags, NULL);
> -		if (!pool->slab)
> +		pool->cmd_slab = kmem_cache_create(pool->cmd_name,
> +						   sizeof(struct scsi_cmnd), 0,
> +						   pool->slab_flags, NULL);
> +		pool->sense_slab = kmem_cache_create(pool->sense_name,
> +						     SCSI_SENSE_BUFFERSIZE, 0,
> +						     pool->slab_flags, NULL);
> +		if (!pool->cmd_slab || !pool->sense_slab)
>  			goto fail;


If one of the above allocations fails, the allocated slab leaks?


diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 045e69d..1a9fba6 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -327,11 +327,16 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 		pool->cmd_slab = kmem_cache_create(pool->cmd_name,
 						   sizeof(struct scsi_cmnd), 0,
 						   pool->slab_flags, NULL);
+		if (!pool->cmd_slab)
+			goto fail;
+
 		pool->sense_slab = kmem_cache_create(pool->sense_name,
 						     SCSI_SENSE_BUFFERSIZE, 0,
 						     pool->slab_flags, NULL);
-		if (!pool->cmd_slab || !pool->sense_slab)
+		if (!pool->sense_slab) {
+			kmem_cache_destroy(pool->cmd_slab);
 			goto fail;
+		}
 	}
 
 	pool->users++;
