From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_device list_lock
Date: Fri, 25 Apr 2003 11:12:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030425111212.A28577@infradead.org>
References: <20030424100229.A32098@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:64265 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262914AbTDYKAG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 06:00:06 -0400
Content-Disposition: inline
In-Reply-To: <20030424100229.A32098@beaverton.ibm.com>; from patmans@us.ibm.com on Thu, Apr 24, 2003 at 10:02:29AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

> -		spin_lock_irqsave(&d->list_lock, flags);
> +		spin_lock_irqsave(&d->sdev_lock, flags);
>  		list_for_each_entry(cmd, &d->cmd_list, list) {
>  			if(cmd->serial_number == 0){

<snip>

> -	spin_lock_irqsave(&sdev->list_lock, flags);
> +	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>  	list_for_each_entry(scmd, &sdev->cmd_list, list) {


Oh, please, please use the lock consistantly.  Yes, I know that the
two are the same currently, but it might not be obvious to every reader
and queue_lock might change to something else in the future.

> -void scsi_put_command(struct scsi_cmnd *cmd)
> +void __scsi_put_command(struct scsi_cmnd *cmd)
>  {
>  	struct Scsi_Host *shost = cmd->device->host;
>  	unsigned long flags;
>  	
>  	/* serious error if the command hasn't come from a device list */
> -	spin_lock_irqsave(&cmd->device->list_lock, flags);
>  	BUG_ON(list_empty(&cmd->list));
>  	list_del_init(&cmd->list);
> -	spin_unlock(&cmd->device->list_lock);
> -	/* changing locks here, don't need to restore the irq state */
> -	spin_lock(&shost->free_list_lock);
> +	spin_lock_irqsave(&shost->free_list_lock, flags);

As this is always called under sdev_lock you don't need to care for
irq disabling here.

