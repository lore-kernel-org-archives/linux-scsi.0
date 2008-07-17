From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3 of 6] scsi: Support devices with protection
	information
Date: Thu, 17 Jul 2008 12:53:11 -0500
Message-ID: <1216317191.5515.53.camel@localhost.localdomain>
References: <9b588aeb5c5b9b618fca.1216283312@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46209 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757721AbYGQRxP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2008 13:53:15 -0400
In-Reply-To: <9b588aeb5c5b9b618fca.1216283312@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-07-17 at 04:28 -0400, Martin K. Petersen wrote:
> -struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
> +struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask, int protection)
>  {
>  	struct scsi_cmnd *cmd;
>  	unsigned char *buf;
>  
>  	cmd = scsi_pool_alloc_command(shost->cmd_pool, gfp_mask);
>  
> -	if (unlikely(!cmd)) {
> +	if (protection)
> +		cmd->prot_sdb = kmem_cache_zalloc(scsi_sdb_cache, gfp_mask);

Really, no.  if cmd is NULL, this will cause an immediate oops.

> +
> +	if (unlikely(!cmd) || unlikely(protection && cmd->prot_sdb == NULL)) {

And here, too ...

>  		unsigned long flags;
>  		spin_lock_irqsave(&shost->free_list_lock, flags);

In general, you're on the right lines, the problem is with this
protection flag.  To use the poll like this, the protection is going to
have to be always on or always off.  If you try and gate it by a flag,
the command on the free list is going to lose the protection buffer
eventually (because it can get allocated on low memory, but it won't
necessarily be the command returned to the free list, and if the
returned command is allocated without protection, we lose the buffer).

James


