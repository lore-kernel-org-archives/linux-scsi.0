From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] add global timeout to the scsi mid-layer
Date: Wed, 17 Aug 2005 13:48:47 -0700
Message-ID: <20050817204847.GA11187@us.ibm.com>
References: <1123296340.5437.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:51595 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751240AbVHQUsv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Aug 2005 16:48:51 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j7HKmlpR455938
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2005 16:48:48 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7HKmOKM499736
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2005 14:48:24 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j7HKmlFZ014309
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2005 14:48:47 -0600
Content-Disposition: inline
In-Reply-To: <1123296340.5437.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Aug 05, 2005 at 09:45:40PM -0500, James Bottomley wrote:
> There are certain rogue devices (and the aic7xxx driver) that return
> BUSY or QUEUE_FULL forever.  This code will apply a global timeout (of
> the total number of retries times the per command timer) to a given
> command.  If it is exceeded, the command is completed regardless of its
> state.

Good idea ... sorry I'm late with comments ...

Move the check into scsi_decide_disposition.

It is not clear if DID_IMM_RETRY should ever get a SUCCESS.

What about completely removing cmd->allowed, and only using total time (a
new cmd->io_lifetime, wait_for in your patch) that the IO has been
outstanding as a retry limiter?

Or have allowed and io_lifetime co-exist, I'm not sure which values should
used as the lower or upper limit. 

scmd->allowed (and io_lifetime) should be modifiable from user space and
set in uppper levels, like sdev->timeout, instead of hardcoding to the
timeout * allowed.

-- Patrick Mansfield

> James
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -9200,8 +9200,8 @@ asc_prt_scsi_cmnd(struct scsi_cmnd *s)
>          (unsigned) s->serial_number, s->retries, s->allowed);
>  
>      printk(
> -" timeout_per_command %d, timeout_total %d, timeout %d\n",
> -        s->timeout_per_command, s->timeout_total, s->timeout);
> +" timeout_per_command %d\n",
> +        s->timeout_per_command);
>  
>      printk(
>  " scsi_done 0x%lx, done 0x%lx, host_scribble 0x%lx, result 0x%x\n",
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -268,6 +268,7 @@ struct scsi_cmnd *scsi_get_command(struc
>  	} else
>  		put_device(&dev->sdev_gendev);
>  
> +	cmd->jiffies_at_alloc = jiffies;
>  	return cmd;
>  }				
>  EXPORT_SYMBOL(scsi_get_command);
> @@ -798,9 +799,23 @@ static void scsi_softirq(struct softirq_
>  	while (!list_empty(&local_q)) {
>  		struct scsi_cmnd *cmd = list_entry(local_q.next,
>  						   struct scsi_cmnd, eh_entry);
> +		/* The longest time any command should be outstanding is the
> +		 * per command timeout multiplied by the number of retries.
> +		 *
> +		 * For a typical command, this is 2.5 minutes */
> +		unsigned long wait_for 
> +			= cmd->allowed * cmd->timeout_per_command;
>  		list_del_init(&cmd->eh_entry);
>  
>  		disposition = scsi_decide_disposition(cmd);
> +		if (disposition != SUCCESS &&
> +		    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
> +			dev_printk(KERN_ERR, &cmd->device->sdev_gendev, 
> +				   "timing out command, waited %ds\n",
> +				   wait_for/HZ);
> +			disposition = SUCCESS;
> +		}
> +			
>  		scsi_log_completion(cmd, disposition);
>  		switch (disposition) {
>  		case SUCCESS:
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -51,12 +51,16 @@ struct scsi_cmnd {
>  	 * printk's to use ->pid, so that we can kill this field.
>  	 */
>  	unsigned long serial_number;
> +	/*
> +	 * This is set to jiffies as it was when the command was first
> +	 * allocated.  It is used to time how long the command has
> +	 * been outstanding
> +	 */
> +	unsigned long jiffies_at_alloc;
>  
>  	int retries;
>  	int allowed;
>  	int timeout_per_command;
> -	int timeout_total;
> -	int timeout;
>  
>  	unsigned char cmd_len;
>  	unsigned char old_cmd_len;
