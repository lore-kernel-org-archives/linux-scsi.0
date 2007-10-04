From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] [PATCH 2/2] blk request timeout handler patches
Date: Thu, 4 Oct 2007 11:32:58 -0700
Message-ID: <20071004113258.3e3f8021.randy.dunlap@oracle.com>
References: <20071004181259.GA16689@us.ibm.com>
	<20071004182003.GC16689@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:30426 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758839AbXJDSlu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Oct 2007 14:41:50 -0400
In-Reply-To: <20071004182003.GC16689@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Thu, 4 Oct 2007 11:20:03 -0700 malahal@us.ibm.com wrote:

> Fix scsi_dispatch_cmd() to stop timers.
> 
> Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
> 
> 
> diff -r 870bb598c977 drivers/scsi/scsi.c
> --- a/drivers/scsi/scsi.c	Thu Sep 27 00:25:38 2007 -0700
> +++ b/drivers/scsi/scsi.c	Thu Sep 27 01:04:10 2007 -0700
> @@ -471,14 +471,19 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
>  	unsigned long timeout;
>  	int rtn = 0;
>  
> +	/*
> +	 * We will use a queued command if possible, otherwise we will
> +	 * emulate the queuing and calling of completion function ourselves.
> +	 */
> +	atomic_inc(&cmd->device->iorequest_cnt);
> +
>  	/* check if the device is still usable */
>  	if (unlikely(cmd->device->sdev_state == SDEV_DEL)) {
>  		/* in SDEV_DEL we error all commands. DID_NO_CONNECT
>  		 * returns an immediate error upwards, and signals
>  		 * that the device is no longer present */
>  		cmd->result = DID_NO_CONNECT << 16;
> -		atomic_inc(&cmd->device->iorequest_cnt);
> -		__blk_complete_request(cmd->request);
> +		scsi_done(cmd);
>  		/* return 0 (because the command has been processed) */
>  		goto out;
>  	}
> @@ -491,7 +496,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
>  		 * future requests should not occur until the device 
>  		 * transitions out of the suspend state.
>  		 */
> -		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
> +
> +		scsi_queue_retry(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
>  
>  		SCSI_LOG_MLQUEUE(3, printk("queuecommand : device blocked \n"));
>  
> @@ -536,12 +542,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
>  	scsi_log_send(cmd);
>  
>  	/*
> -	 * We will use a queued command if possible, otherwise we will
> -	 * emulate the queuing and calling of completion function ourselves.
> -	 */
> -	atomic_inc(&cmd->device->iorequest_cnt);
> -
> -	/*
>  	 * Before we queue this command, check if the command
>  	 * length exceeds what the host adapter can handle.
>  	 */
> @@ -571,12 +571,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
>  	}
>  	spin_unlock_irqrestore(host->host_lock, flags);
>  	if (rtn) {
> -		if (blk_delete_timer(cmd->request)) {
> -			atomic_inc(&cmd->device->iodone_cnt);
> -			scsi_queue_insert(cmd,
> -					  (rtn == SCSI_MLQUEUE_DEVICE_BUSY) ?
> -					  rtn : SCSI_MLQUEUE_HOST_BUSY);
> -		}
> +		scsi_queue_retry(cmd, (rtn == SCSI_MLQUEUE_DEVICE_BUSY) ?
> +						rtn : SCSI_MLQUEUE_HOST_BUSY);
>  		SCSI_LOG_MLQUEUE(3,
>  		    printk("queuecommand : request rejected\n"));
>  	}
> diff -r 870bb598c977 drivers/scsi/scsi_lib.c
> --- a/drivers/scsi/scsi_lib.c	Thu Sep 27 00:25:38 2007 -0700
> +++ b/drivers/scsi/scsi_lib.c	Thu Sep 27 01:16:28 2007 -0700
> @@ -160,6 +160,36 @@ int scsi_queue_insert(struct scsi_cmnd *
>  
>  	return 0;
>  }
> +
> +/*
> + * Function:    scsi_queue_retry()
> + *
> + * Purpose:     Try inserting a command in the midlevel queue.
> + *
> + * Arguments:   cmd    - command that we are adding to queue.
> + *              reason - why we are inserting command to queue.
> + *
> + * Lock status: Assumed that lock is not held upon entry.
> + *
> + * Returns:     Nothing.
> + *
> + * Notes:       This is very similar to scsi_queue_insert except that we
> + *              call this function when we don't know if the blk layer timer
> + *              is active or not. We could implement this either by calling
> + *              blk_delete_timer and inserting in the midlevel queue if we
> + *              successfully delete the timer OR setting appropriate result
> + *              field in the cmd and letting it go through the normal done
> + *              routines which will retry the command. For now, We call
> + *              blk_delete_timer!
> + */

Please use kernel-doc notation for the function interface doc.
Thanks.

> +void scsi_queue_retry(struct scsi_cmnd *cmd, int reason)
> +{
> +	if (blk_delete_timer(cmd->request)) {
> +		atomic_inc(&cmd->device->iodone_cnt);
> +		scsi_queue_insert(cmd, reason);
> +	}
> +}

---
~Randy
