From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] scsi_requeuest_fn
Date: Sun, 27 Apr 2003 11:07:11 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030427110711.A21878@beaverton.ibm.com>
References: <20030427170440.A29493@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:33270 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S263239AbTD0R6p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 13:58:45 -0400
Content-Disposition: inline
In-Reply-To: <20030427170440.A29493@lst.de>; from hch@lst.de on Sun, Apr 27, 2003 at 05:04:40PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Sun, Apr 27, 2003 at 05:04:40PM +0200, Christoph Hellwig wrote:

> --- 1.84/drivers/scsi/scsi_lib.c	Mon Apr 21 10:17:33 2003
> +++ edited/drivers/scsi/scsi_lib.c	Sun Apr 27 14:19:35 2003
> @@ -1140,66 +1128,61 @@
>   *
>   * Lock status: IO request lock assumed to be held when called.
>   */
> -static void scsi_request_fn(request_queue_t *q)
> +static void scsi_request_fn(struct request_queue *q)
>  {
>  	struct scsi_device *sdev = q->queuedata;
>  	struct Scsi_Host *shost = sdev->host;
>  	struct scsi_cmnd *cmd;
>  	struct request *req;
> -	unsigned long flags;
>  
>  	/*
>  	 * To start with, we keep looping until the queue is empty, or until
>  	 * the host is no longer able to accept any more requests.
>  	 */

You might as well remove all or most of the comments, none of them add
much information, the comments might as well say "we are about to
loop" or "we are about to call scsi_dispatch_cmd".

> -		BUG_ON(!cmd);
> +		spin_unlock_irq(shost->host_lock);
> +
> +		cmd = req->special;
> +		if (unlikely(cmd == NULL)) {
> +			printk(KERN_CRIT "impossible request in %s.\n"
> +					 "please mail a stack trace to "
> +					 "linux-scsi@vger.kernel.org",
> +					 __FUNCTION__);
> +			BUG();
> +		}

The scsi_init_cmd_errh(cmd) will oops anyway if cmd == NULL, so just remove
the check.

Also - do you have a patch rollup somewhere (in case these recent
patches aren't applied soon)?

-- Patrick Mansfield
