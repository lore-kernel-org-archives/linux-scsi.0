From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 4/7 cleanup/consolidate code in scsi_request_fn
Date: Tue, 25 Mar 2003 16:32:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E80CB02.8010909@splentec.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <20030324180304.C15047@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> Cleanup and consolidate scsi_device and scsi_host checks in
> scsi_request_fn.
> 
> diff -purN -X /home/patman/dontdiff lun-single-25/drivers/scsi/scsi_lib.c req_fn-cleanup-25/drivers/scsi/scsi_lib.c
> --- lun-single-25/drivers/scsi/scsi_lib.c	Mon Mar 24 12:14:55 2003
> +++ req_fn-cleanup-25/drivers/scsi/scsi_lib.c	Mon Mar 24 12:15:01 2003
> @@ -1043,6 +1043,79 @@ static int scsi_prep_fn(struct request_q
>  }
>  
>  /*
> + * scsi_check_sdev: if we can send requests to sdev, return 0 else return 1.
> + *
> + * Called with the queue_lock held.
> + */
> +static inline int scsi_check_sdev(struct request_queue *q,
> +				  struct scsi_device *sdev)

scsi_check_sdev: clearly every function is C does a check, or a computation,
or a modificaiton, or some permutation of those.  So this name is too trivial
and doesn't mean what the function does.

Further more since the function outcome is logical in nature, i.e. it does
NOT return an error code, you can can return 1 on success, and 0 on fault.

How about this:
/**
  * scsi_dev_ok2queue:  Return non-zero if we can queue to the
  * device, else 0.
  */
static inline int scsi_dev_ok2queue(struct scsi_device *sdev)
{
	...
}

So that statments like this are logical:

	if (scsi_dev_ok2queue(dev)) {
		/* let's queue */
	} else {
		/* no, will have to defer */
	}

and the negation:
	if (!scsi_dev_ok2queue(dev)) {
		...
	}

> +{
> +	if (sdev->device_busy >= sdev->queue_depth)
> +		return 1;
> +	if (sdev->device_busy == 0 && sdev->device_blocked) {
> +		/*
> +		 * unblock after device_blocked iterates to zero
> +		 */
> +		if (--sdev->device_blocked == 0) {
> +			SCSI_LOG_MLQUEUE(3,
> +				printk("scsi%d (%d:%d) unblocking device at"
> +				       " zero depth\n", sdev->host->host_no,
> +				       sdev->id, sdev->lun));
> +		} else {
> +			blk_plug_device(q);
> +			return 1;
> +		}
> +	}
> +	if (sdev->device_blocked)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +/*
> + * scsi_check_shost: if we can send requests to shost, return 0 else return 1.
> + *
> + * Called with the queue_lock held.
> + */
> +static inline int scsi_check_shost(struct request_queue *q,
> +				   struct Scsi_Host *shost,
> +				   struct scsi_device *sdev)

Abosulutely the same story here, as above.

scsi_host_ok2queue() -- please do not use ``shost'' in function names,
``host'' I think is descriptive enough.

> +{
> +	if (shost->in_recovery)
> +		return 1;
> +	if (shost->host_busy == 0 && shost->host_blocked) {
> +		/*
> +		 * unblock after host_blocked iterates to zero
> +		 */
> +		if (--shost->host_blocked == 0) {
> +			SCSI_LOG_MLQUEUE(3,
> +				printk("scsi%d unblocking host at zero depth\n",
> +					shost->host_no));
> +		} else {
> +			blk_plug_device(q);
> +			return 1;
> +		}
> +	}
> +	if (!list_empty(&sdev->starved_entry))
> +		return 1;
> +	if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
> +	    shost->host_blocked || shost->host_self_blocked) {
> +		SCSI_LOG_MLQUEUE(3,
> +			printk("add starved dev <%d,%d,%d,%d>; host "
> +			       "limit %d, busy %d, blocked %d selfblocked %d\n",
> +			       sdev->host->host_no, sdev->channel,
> +			       sdev->id, sdev->lun,
> +			       shost->can_queue, shost->host_busy,
> +			       shost->host_blocked, shost->host_self_blocked));
> +		list_add_tail(&sdev->starved_entry,
> +			      &shost->starved_list);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
>   * Function:    scsi_request_fn()
>   *
>   * Purpose:     Main strategy routine for SCSI.
> @@ -1067,13 +1140,8 @@ static void scsi_request_fn(request_queu
>  	 * the host is no longer able to accept any more requests.
>  	 */
>  	for (;;) {
> -		/*
> -		 * Check this again - each time we loop through we will have
> -		 * released the lock and grabbed it again, so each time
> -		 * we need to check to see if the queue is plugged or not.
> -		 */
> -		if (shost->in_recovery || blk_queue_plugged(q))
> -			return;
> +		if (blk_queue_plugged(q))
> +			break;
>  
>  		/*
>  		 * get next queueable request.  We do this early to make sure
> @@ -1083,48 +1151,11 @@ static void scsi_request_fn(request_queu
>  		 */
>  		req = elv_next_request(q);
>  
> -		if (sdev->device_busy >= sdev->queue_depth)
> -			break;
> -
> -		if (shost->host_busy == 0 && shost->host_blocked) {
> -			/* unblock after host_blocked iterates to zero */
> -			if (--shost->host_blocked == 0) {
> -				SCSI_LOG_MLQUEUE(3,
> -					printk("scsi%d unblocking host at zero depth\n",
> -						shost->host_no));
> -			} else {
> -				blk_plug_device(q);
> -				break;
> -			}
> -		}
> -
> -		if (sdev->device_busy == 0 && sdev->device_blocked) {
> -			/* unblock after device_blocked iterates to zero */
> -			if (--sdev->device_blocked == 0) {
> -				SCSI_LOG_MLQUEUE(3,
> -					printk("scsi%d (%d:%d) unblocking device at zero depth\n",
> -						shost->host_no, sdev->id, sdev->lun));
> -			} else {
> -				blk_plug_device(q);
> -				break;
> -			}
> -		}
> -
> -		/*
> -		 * If the device cannot accept another request, then quit.
> -		 */
> -		if (sdev->device_blocked)
> -			break;
> -
> -		if (!list_empty(&sdev->starved_entry))
> +		if (scsi_check_sdev(q, sdev))
>  			break;
>  
> -		if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
> -		    shost->host_blocked || shost->host_self_blocked) {
> -			list_add_tail(&sdev->starved_entry,
> -				      &shost->starved_list);
> +		if (scsi_check_shost(q, shost, sdev))
>  			break;
> -		}
>  
>  		if (sdev->single_lun && scsi_single_lun_check(sdev))
>  			break;
> @@ -1140,7 +1171,7 @@ static void scsi_request_fn(request_queu
>  			/* If the device is busy, a returning I/O
>  			 * will restart the queue.  Otherwise, we have
>  			 * to plug the queue */
> -			if(sdev->device_busy == 0)
> +			if (sdev->device_busy == 0)
>  				blk_plug_device(q);
>  			break;
>  		}
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Luben Tuikov, Senior Software Engineer, Splentec Ltd.
Bus: +1-905-707-1954x112, 9-5 EDT. Fax: +1-905-707-1974.

