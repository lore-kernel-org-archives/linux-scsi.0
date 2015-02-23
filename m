From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 37/43] hpsa: use block layer tag for command allocation
Date: Mon, 23 Feb 2015 12:25:26 -0800
Message-ID: <20150223202526.GE11037@infradead.org>
References: <20150221221553.21954.32599.stgit@brunhilda>
 <20150221222049.21954.27282.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40996 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbbBWUZ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Feb 2015 15:25:27 -0500
Content-Disposition: inline
In-Reply-To: <20150221222049.21954.27282.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com, linux-scsi@vger.kernel.org

> @@ -4691,27 +4701,31 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
>  
>  	/* Get the ptr to our adapter structure out of cmd->host. */
>  	h = sdev_to_hba(cmd->device);
> -	dev = cmd->device->hostdata;
> -	if (!dev) {
> +
> +	if (cmd->request->tag < 0) {
> +		dev_crit(&h->pdev->dev,
> +			 "sdev %p scmd %p: bad tag %d -- rejecting\n",
> +			 cmd->device, cmd, cmd->request->tag);
>  		cmd->result = DID_NO_CONNECT << 16;
>  		cmd->scsi_done(cmd);
>  		return 0;

Shouldn't happen with a modern kernel, but if you really want to
assert this I'd recommend a BUG_ON().

> -	if (unlikely(lockup_detected(h))) {
> +	dev = cmd->device->hostdata;
> +	if (!dev) {
>  		cmd->result = DID_NO_CONNECT << 16;
>  		cmd->scsi_done(cmd);
>  		return 0;
>  	}

How could this happen (see my earlier question in one of the first
patches).

> @@ -4838,6 +4852,11 @@ static int hpsa_register_scsi(struct ctlr_info *h)
>  	sh->hostdata[0] = (unsigned long) h;
>  	sh->irq = h->intr[h->intr_mode];
>  	sh->unique_id = sh->irq;
> +	if (!shost_use_blk_mq(sh)) {
> +		error = scsi_init_shared_tag_map(sh, sh->can_queue);
> +		if (error)
> +			goto fail_host_put;
> +	}

scsi_init_shared_tag_map alredy has the blk-mq check, so you can call
it unconditionally.

> +static void hpsa_print_scsi_cmd(struct ctlr_info *h, struct scsi_cmnd *scmd,
> +			   char *prefix)

Maybe just use scsi_print_command?

> +static void cmd_tagged_free(struct ctlr_info *h, struct CommandList *c)
> +{
> +	/*
> +	 * Release our reference to the block.  We don't need to do anything
> +	 * else to free it, because it is accessed by index.  (There's no point
> +	 * in checking the result of the decrement, since we cannot guarantee
> +	 * that there isn't a concurrent abort which is also accessing it.)
> +	 */
> +	(void)atomic_dec_and_test(&c->refcount);

Just use atomic_dec().

Any reason you're implementing your own allocator instead of setting
->cmd_size?

