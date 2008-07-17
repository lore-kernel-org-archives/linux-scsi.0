From: Michael Hernandez <michael.hernandez@qlogic.com>
Subject: Re: [PATCH 3 of 6] scsi: Support devices with protection information
Date: Thu, 17 Jul 2008 13:42:58 -0700
Message-ID: <C4A4FCE2.2CCA%michael.hernandez@qlogic.com>
References: <9b588aeb5c5b9b618fca.1216283312@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:19450 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280AbYGQUm7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jul 2008 16:42:59 -0400
In-Reply-To: <9b588aeb5c5b9b618fca.1216283312@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org



On 7/17/08 1:28 AM, "Martin K. Petersen" <martin.petersen@oracle.com> wrote:

> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -199,24 +199,60 @@ scsi_pool_free_command(struct scsi_host_
>  {
> kmem_cache_free(pool->sense_slab, cmd->sense_buffer);
> kmem_cache_free(pool->cmd_slab, cmd);
> +
> + if (cmd->prot_sdb)
> +  kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
> +}
> +

Shouldn't this check (and potential kmem_cache_free call) get done before
freeing the cmd to the cmd_slab?

Mike

