From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 12/17] scsi: avoid taking host_lock in scsi_run_queue
 unless nessecary
Date: Wed, 05 Feb 2014 15:54:17 -0800
Message-ID: <1391644457.2213.68.camel@dabdike.int.hansenpartnership.com>
References: <20140205123930.150608699@bombadil.infradead.org>
	 <20140205124021.085634649@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46424 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753066AbaBEXyU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 18:54:20 -0500
In-Reply-To: <20140205124021.085634649@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Wed, 2014-02-05 at 04:39 -0800, Christoph Hellwig wrote:

> If we don't have starved devices we don't need to take the host lock
> to iterate over them.  Also split the function up to be more clear.

This looks reasonable and can potentially go separately too.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_lib.c |   31 ++++++++++++-------------------
>  1 file changed, 12 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 216be71..44740c0 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -363,29 +363,12 @@ static inline int scsi_host_is_busy(struct Scsi_Host *shost)
>  	return 0;
>  }
>  
> -/*
> - * Function:	scsi_run_queue()
> - *
> - * Purpose:	Select a proper request queue to serve next
> - *
> - * Arguments:	q	- last request's queue
> - *
> - * Returns:     Nothing
> - *
> - * Notes:	The previous command was completely finished, start
> - *		a new one if possible.
> - */

Instead of dumping the description, how about converting it to docbook
and making it match the new function?

> -static void scsi_run_queue(struct request_queue *q)
> +static void scsi_starved_list_run(struct Scsi_Host *shost)
>  {
> -	struct scsi_device *sdev = q->queuedata;
> -	struct Scsi_Host *shost;
>  	LIST_HEAD(starved_list);
> +	struct scsi_device *sdev;
>  	unsigned long flags;
>  
> -	shost = sdev->host;
> -	if (scsi_target(sdev)->single_lun)
> -		scsi_single_lun_run(sdev);
> -
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	list_splice_init(&shost->starved_list, &starved_list);
>  
> @@ -437,6 +420,16 @@ static void scsi_run_queue(struct request_queue *q)
>  	/* put any unprocessed entries back */
>  	list_splice(&starved_list, &shost->starved_list);
>  	spin_unlock_irqrestore(shost->host_lock, flags);
> +}

And reinsert either the original or a docbook formatted version of the description.

Thanks,

James

> +static void scsi_run_queue(struct request_queue *q)
> +{
> +	struct scsi_device *sdev = q->queuedata;
> +
> +	if (scsi_target(sdev)->single_lun)
> +		scsi_single_lun_run(sdev);
> +	if (!list_empty(&sdev->host->starved_list))
> +		scsi_starved_list_run(sdev->host);
>  
>  	blk_run_queue(q);
>  }
> -- 
> 1.7.10.4
> 

