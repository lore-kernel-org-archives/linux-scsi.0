From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 3/7 consolidate single_lun code
Date: Tue, 25 Mar 2003 15:50:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E80C12E.2000405@splentec.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> Consolidate scsi single_lun code.
> 
> diff -purN -X /home/patman/dontdiff put_cmd-25/drivers/scsi/scsi_lib.c lun-single-25/drivers/scsi/scsi_lib.c
> --- put_cmd-25/drivers/scsi/scsi_lib.c	Mon Mar 24 12:14:51 2003
> +++ lun-single-25/drivers/scsi/scsi_lib.c	Mon Mar 24 12:14:55 2003
> @@ -323,6 +323,49 @@ void scsi_setup_cmd_retry(struct scsi_cm
>  }
>  
>  /*
> + * Called for single_lun devices. The target associated with current_sdev can
> + * only handle one active command at a time. Scan through all of the luns
> + * on the same target as current_sdev, return 1 if any are active.
> + */
> +static int scsi_single_lun_check(struct scsi_device *current_sdev)

This is such a general name, that it does not mean anything.
What kind of ``check'' is this?

Why not like this:

/**
  * scsi_target_ok2queue: return non-zero if it is ok to queue
  * to this target, else 0.
  */

<< but a nicely formatted comment>>

static int scsi_target_ok2queue(struct scsi_target *target)
{
	if (!target->single_lu)
		return 1;
	for all devices of the target
		if an LU is active
			return 0;
	return 1;
}

That is, 0 is returned when there is NO error code.
Since this function does NOT return error codes, but performes
a LOGICAL nature test, you'd return 1 and 0, so that this makes sense:

	if (scsi_target_ok2queue(target)) {
		/* we're ok to queue, go! */
	} else {
		/* no we're not ok to queue */
	}

and the negation:
	if (!scsi_target_ok2queue(target)) {
	...

I'd rather have it named int scsi_target_canqueue(), but there
might be some confusion with the can_queue struct member.

> +{
> +	struct scsi_device *sdev;
> +
> +	list_for_each_entry(sdev, &current_sdev->same_target_siblings,
> +			    same_target_siblings)
> +		if (sdev->device_busy)
> +			return 1;
> +	return 0;
> +}
> +
> +/*
> + * Called for single_lun devices on IO completion. If no requests
> + * outstanding for current_sdev, call __blk_run_queue for the next
> + * scsi_device on the same target that has requests.
> + *
> + * Called with queue_lock held.
> + */
> +static void scsi_single_lun_run(struct scsi_device *current_sdev,
> +				 struct request_queue *q)

This will be incorporated by default by the starved_devs list
priority queue.

I.e. you should try not to have a partucular function for this but
arrange the infrastructure in such a way that this is handled
by default (via the infrastructure itself).

> +{
> +	struct scsi_device *sdev;
> +	struct Scsi_Host *shost;
> +
> +	shost = current_sdev->host;
> +	if (blk_queue_empty(q) && current_sdev->device_busy == 0 &&
> +	    !shost->host_blocked && !shost->host_self_blocked &&
> +	    !((shost->can_queue > 0) &&
> +	      (shost->host_busy >= shost->can_queue)))
> +		list_for_each_entry(sdev, &current_sdev->same_target_siblings,
> +				    same_target_siblings)
> +			if (!sdev->device_blocked &&
> +			    !blk_queue_empty(sdev->request_queue)) {
> +				__blk_run_queue(sdev->request_queue);
> +				break;
> +			}
> +}
> +
> +/*
>   * Function:    scsi_queue_next_request()
>   *
>   * Purpose:     Handle post-processing of completed commands.
> @@ -390,29 +433,11 @@ void scsi_queue_next_request(request_que
>  	}
>  
>  	sdev = q->queuedata;
> -	shost = sdev->host;
>  
> -	/*
> -	 * If this is a single-lun device, and we are currently finished
> -	 * with this device, then see if we need to get another device
> -	 * started.  FIXME(eric) - if this function gets too cluttered
> -	 * with special case code, then spin off separate versions and
> -	 * use function pointers to pick the right one.
> -	 */
> -	if (sdev->single_lun && blk_queue_empty(q) && sdev->device_busy ==0 &&
> -			!shost->host_blocked && !shost->host_self_blocked &&
> -			!((shost->can_queue > 0) && (shost->host_busy >=
> -				       		     shost->can_queue))) {
> -		list_for_each_entry(sdev2, &sdev->same_target_siblings,
> -			       same_target_siblings) {
> -			if (!sdev2->device_blocked &&
> -			    !blk_queue_empty(sdev2->request_queue)) {
> -				__blk_run_queue(sdev2->request_queue);
> -				break;
> -			}
> -		}
> -	}
> +	if (sdev->single_lun)
> +		scsi_single_lun_run(sdev, q);
>  
> +	shost = sdev->host;
>  	while (!list_empty(&shost->starved_list) &&
>  	       !shost->host_blocked && !shost->host_self_blocked &&
>  		!((shost->can_queue > 0) &&
> @@ -917,22 +942,6 @@ static int scsi_init_io(struct scsi_cmnd
>  	return BLKPREP_KILL;
>  }
>  
> -/*
> - * The target associated with myself can only handle one active command at
> - * a time. Scan through all of the luns on the same target as myself,
> - * return 1 if any are active.
> - */
> -static int check_all_luns(struct scsi_device *myself)
> -{
> -	struct scsi_device *sdev;
> -
> -	list_for_each_entry(sdev, &myself->same_target_siblings,
> -			    same_target_siblings)
> -		if (sdev->device_busy)
> -			return 1;
> -	return 0;
> -}
> -
>  static int scsi_prep_fn(struct request_queue *q, struct request *req)
>  {
>  	struct Scsi_Device_Template *sdt;
> @@ -1077,9 +1086,6 @@ static void scsi_request_fn(request_queu
>  		if (sdev->device_busy >= sdev->queue_depth)
>  			break;
>  
> -		if (sdev->single_lun && check_all_luns(sdev))
> -			break;
> -
>  		if (shost->host_busy == 0 && shost->host_blocked) {
>  			/* unblock after host_blocked iterates to zero */
>  			if (--shost->host_blocked == 0) {
> @@ -1120,6 +1126,9 @@ static void scsi_request_fn(request_queu
>  			break;
>  		}
>  
> +		if (sdev->single_lun && scsi_single_lun_check(sdev))
> +			break;
> +
>  		/*
>  		 * If we couldn't find a request that could be queued, then we
>  		 * can also quit.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Luben Tuikov, Senior Software Engineer, Splentec Ltd.
Bus: +1-905-707-1954x112, 9-5 EDT. Fax: +1-905-707-1974.

