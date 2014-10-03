From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 18/24] scsi: Remove scsi_print_command when calling abort
Date: Fri, 3 Oct 2014 02:11:07 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCBEA3@G4W3202.americas.hpqcorp.net>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-19-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:41714 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaJCCMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 22:12:53 -0400
In-Reply-To: <1412144580-72880-19-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Wednesday, 01 October, 2014 1:23 AM
> To: James Bottomley
> Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; Elliott, Robert (Server
> Storage); Hannes Reinecke
> Subject: [PATCH 18/24] scsi: Remove scsi_print_command when calling abort
> 
> Calling scsi_print_command should not be necessary during abort;
> if the information is required one should enable scsi logging.
> 
...
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 45da3c8..50873bb 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -2666,9 +2666,8 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
>  	struct Scsi_Host *instance = cmd->device->host;
>  	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *)
> instance->hostdata;
>  	Scsi_Cmnd *tmp, **prev;
> -
> -	printk(KERN_WARNING "scsi%d : aborting command\n", instance->host_no);
> -	scsi_print_command(cmd);
> +
> +	scmd_printk(KERN_WARNING, cmd, "aborting command\n");
> 
>  	NCR5380_print_status(instance);
> 
> diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
> index b2fd18e..c16aca1 100644
> --- a/drivers/scsi/arm/fas216.c
> +++ b/drivers/scsi/arm/fas216.c
> @@ -2425,14 +2425,11 @@ int fas216_eh_abort(struct scsi_cmnd *SCpnt)
> 
>  	info->stats.aborts += 1;
> 
> -	printk(KERN_WARNING "scsi%d: abort command ", info->host->host_no);
> -	__scsi_print_command(SCpnt->cmnd);
> +	sdev_printk(KERN_WARNING, SCpnt, "abort command\n");

That should be scmd_printk.

It'd be nice if the s*_printk macros could typecheck 
that pointer.

> 
>  	print_debug_list();
>  	fas216_dumpstate(info);
> 
> -	printk(KERN_WARNING "scsi%d: abort %p ", info->host->host_no, SCpnt);
> -
>  	switch (fas216_find_command(info, SCpnt)) {
>  	/*
>  	 * We found the command, and cleared it out.  Either
> @@ -2440,7 +2437,7 @@ int fas216_eh_abort(struct scsi_cmnd *SCpnt)
>  	 * target, or the busylun bit is not set.
>  	 */
>  	case res_success:
> -		printk("success\n");
> +		sdev_printk(KERN_WARNING, SCpnt, "abort %p success\n", SCpnt);

That should be scmd_printk, dropping the %p and the extra SCpnt
argument.

>  		result = SUCCESS;
>  		break;
> 
> @@ -2450,14 +2447,13 @@ int fas216_eh_abort(struct scsi_cmnd *SCpnt)
>  	 * if the bus is free.
>  	 */
>  	case res_hw_abort:
> -
> 
>  	/*
>  	 * We are unable to abort the command for some reason.
>  	 */
>  	default:
>  	case res_failed:
> -		printk("failed\n");
> +		sdev_printk(KERN_WARNING, SCpnt, "abort %p failed\n", SCpnt);

That should be scmd_printk, dropping the %p and the extra SCpnt
argument.

>  		break;
>  	}
> 
> diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
> index 79e6f04..322f361 100644
> --- a/drivers/scsi/atari_NCR5380.c
> +++ b/drivers/scsi/atari_NCR5380.c
> @@ -2623,8 +2623,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
>  	Scsi_Cmnd *tmp, **prev;
>  	unsigned long flags;
> 
> -	printk(KERN_NOTICE "scsi%d: aborting command\n", HOSTNO);
> -	scsi_print_command(cmd);
> +	sdev_printk(KERN_NOTICE, cmd, "aborting command\n");

That should be scmd_printk.

...
> diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
> index 1a2367a..68d0e1a 100644
> --- a/drivers/scsi/sun3_NCR5380.c
> +++ b/drivers/scsi/sun3_NCR5380.c
> @@ -2608,8 +2608,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
>      struct scsi_cmnd *tmp, **prev;
>      unsigned long flags;
> 
> -    printk(KERN_NOTICE "scsi%d: aborting command\n", HOSTNO);
> -    scsi_print_command(cmd);
> +    sdev_printk(KERN_NOTICE, cmd, "aborting command\n");

That should be scmd_printk.


---
Rob Elliott    HP Server Storage



