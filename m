From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: initialize max_target_blocked in scsi_alloc_target
Date: Thu, 09 Apr 2009 12:46:08 -0500
Message-ID: <49DE3460.4060509@cs.wisc.edu>
References: <B1FD1A0C73AC4E46A4F95BADC77079D351A9E032@PA-EXMBX02.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50743 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762599AbZDIRqQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Apr 2009 13:46:16 -0400
In-Reply-To: <B1FD1A0C73AC4E46A4F95BADC77079D351A9E032@PA-EXMBX02.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Edward Goggin <egoggin@vmware.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Edward Goggin wrote:
> Patch 1 of 1
> 
> This patch initializes the max_target_blocked field of a scsi target structure
> so that a queuecommand return value of SCSI_MLQUEUE_TARGET_BUSY will actually
> result in having the scsi_queue_insert blocking the device queue before requeuing
> the command and running the queue.  Otherwise, can and does cause livelock on
> single CPU configurations if/when open-iSCSI software initiator's command PDU
> window fills.
> 
> Signed-off-by: Ed Goggin <egoggin@vmware.com>
> 
> --- linux-2.6.29/drivers/scsi/scsi_scan.c	2009-03-23 19:12:14.000000000 -0400
> +++ linux-2.6.29-fix/drivers/scsi/scsi_scan.c	2009-04-09 11:11:01.000000000 -0400
> @@ -427,6 +427,7 @@ static struct scsi_target *scsi_alloc_ta
>  	INIT_LIST_HEAD(&starget->devices);
>  	starget->state = STARGET_CREATED;
>  	starget->scsi_level = SCSI_2;
> +	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
>   retry:
>  	spin_lock_irqsave(shost->host_lock, flags);
> 

Thanks for finding this.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
