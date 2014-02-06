From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/17] scsi: simplify command allocation and freeing a bit
Date: Thu, 6 Feb 2014 08:21:46 -0800
Message-ID: <20140206162146.GE16916@infradead.org>
References: <20140205123930.150608699@bombadil.infradead.org>
 <20140205124019.766741239@bombadil.infradead.org>
 <1391644295.2213.65.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58031 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaBFQVt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 11:21:49 -0500
Content-Disposition: inline
In-Reply-To: <1391644295.2213.65.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Wed, Feb 05, 2014 at 03:51:35PM -0800, James Bottomley wrote:
> On Wed, 2014-02-05 at 04:39 -0800, Christoph Hellwig wrote:
> 
> > Just have one level of alloc/free functions that take a host instead
> > of two levels for the allocation and different calling conventions
> > for the free.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/scsi/scsi.c |   77 +++++++++++++++------------------------------------
> >  1 file changed, 22 insertions(+), 55 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > index 4139486..5347f7d 100644
> > --- a/drivers/scsi/scsi.c
> > +++ b/drivers/scsi/scsi.c
> > @@ -160,79 +160,46 @@ static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
> >  
> >  static DEFINE_MUTEX(host_cmd_pool_mutex);
> >  
> > -/**
> > - * scsi_pool_alloc_command - internal function to get a fully allocated command
> > - * @pool:	slab pool to allocate the command from
> > - * @gfp_mask:	mask for the allocation
> > - *
> > - * Returns a fully allocated command (with the allied sense buffer) or
> > - * NULL on failure
> > - */
> > -static struct scsi_cmnd *
> > -scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
> > -{
> > -	struct scsi_cmnd *cmd;
> > -
> > -	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
> > -	if (!cmd)
> > -		return NULL;
> > -
> > -	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab,
> > -					     gfp_mask | pool->gfp_mask);
> > -	if (!cmd->sense_buffer) {
> > -		kmem_cache_free(pool->cmd_slab, cmd);
> > -		return NULL;
> > -	}
> > -
> > -	return cmd;
> > -}
> > -
> > -/**
> > - * scsi_pool_free_command - internal function to release a command
> > - * @pool:	slab pool to allocate the command from
> > - * @cmd:	command to release
> > - *
> > - * the command must previously have been allocated by
> > - * scsi_pool_alloc_command.
> > - */
> >  static void
> > -scsi_pool_free_command(struct scsi_host_cmd_pool *pool,
> > -			 struct scsi_cmnd *cmd)
> > +scsi_host_free_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
> 
> You lost the docbook function description here when you changed the name.

It's a static function with two callers, and it's more obvious from the
function than the comment what it does.

I'm probably one of the people with the highest comment to code ratios
in the kernel, but I'd rather explain in long comments when something
is non-obvious than putting useless boilerplates in.  If you insist on
the comment I'll put it back, but it seems utterly useless.

> This docbook elimination looks spurious; why do it?

Same as above.

