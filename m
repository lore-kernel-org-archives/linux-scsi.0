From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/4] libata: consolidate ata_dev_classify()
Date: Sat, 6 Sep 2014 08:42:41 +0900
Message-ID: <20140905234241.GH15723@mtj.dyndns.org>
References: <1406706911-79510-1-git-send-email-hare@suse.de>
 <1406706911-79510-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62113 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaIEXmq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 19:42:46 -0400
Content-Disposition: inline
In-Reply-To: <1406706911-79510-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

Hello, Hannes.

Sorry about the delay.

On Wed, Jul 30, 2014 at 09:55:08AM +0200, Hannes Reinecke wrote:
> ata_dev_classify() just uses the 'lbah' and 'lbam'
> fields from the taskfile, so we can as well use those
> as arguments and rip out the custom code from sas_ata.

I wonder whether it'd easier to just make sas code pass in
ata_taskfile instead?  The interface which takes three consecutive
u8's is kinda error-prone.

> --- a/drivers/scsi/aic94xx/aic94xx_task.c
> +++ b/drivers/scsi/aic94xx/aic94xx_task.c
> @@ -373,10 +373,10 @@ static int asd_build_ata_ascb(struct asd_ascb *ascb, struct sas_task *task,
>  
>  	if (unlikely(task->ata_task.device_control_reg_update))
>  		scb->header.opcode = CONTROL_ATA_DEV;
> -	else if (dev->sata_dev.command_set == ATA_COMMAND_SET)
> -		scb->header.opcode = INITIATE_ATA_TASK;
> -	else
> +	else if (dev->sata_dev.class == ATA_DEV_ATAPI)
>  		scb->header.opcode = INITIATE_ATAPI_TASK;
> +	else
> +		scb->header.opcode = INITIATE_ATA_TASK;

Are these changes covered by the patch description?  Looks like the
patch is mixing two separate logical changes.

Thanks.

-- 
tejun
