From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 3/7 consolidate single_lun code
Date: Tue, 25 Mar 2003 15:36:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E80BDC3.7000503@splentec.com>
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

Here is parth of your comment:
	A single_lun (single_lu:1) marked target can handle a single
	active LU at a time.

> +static int scsi_single_lun_check(struct scsi_device *current_sdev)

Here is the name:

static int scsi_single_lun_active(struct scsi_device *dev);

The reason is that this makes sense:

	if (scsi_single_lun_active(dev)) {
		/* then there is an active lu */
	} else {
		/* No, there's no active devices or
		the target is NOT a single lun. */
	}

or the negation:

	if (!scsi_single_lun_active(dev)) {
		/* no active lun devices or target is not a single
		LU, -- either way we can continue here: */
		...
	}

And you comment continues:
	Returns 1 if the target has an active LU at this time,
	else 0.

Ideally you'd do this:

static int scsi_lu_active(struct scsi_target *target);

Then go over the list of LUs of the target.
(You'd have to add things to the scsi_target structure, etc...,
see next emails.)

{
	if (!target->single_lun)
		return 0;
	for all devices
		if an LU is busy
			return 1;
	return 0;
} /* end scsi_lu_active() */


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

Now here I've got a problem.  This just pulls out the old logic
into a separate fn.

I'd rather you did this: in the request fn put the single_lun device
into the starved devices list, just as you'd do for other devices.

If you want you to discern between devices, you can add single_lun
devices to the front and fully capable devices into the tail of the
starved devices list -- this would make the starved devices list
into a priority queue.

Then have a general function to run the starved devices queues
as follows:

/**
  * Function:	scsi_run_starved_devs()
  * Purpose:	Run the request queue of starved devices of a host.
  * Arguments:	shost, pointer to struct Scsi_Host.
  * Returns:	Nothing.
  * Notes:	This function may not necessarily empty the starved device
  *		list.  For this reason the following should be observed:
  *		- One shot prioritization: if the caller prioritizes
  *		the starved device list, then the caller has to prioritize
  *		it _before_ a call to this fn.
  *		- Priority queue: if the starved device list is treated as
  *		a priority queue, no prior arrangements are necessary.  The
  *		reason is that if any entries are inserted in due time
  *		of running of this function, the leftovers are added at
  *		the front of the starved list, thus ordering them by time.
  */
static inline void scsi_run_starved_devs(struct Scsi_Host *shost)
{
	unsigned long flags;
	LIST_HEAD(starved);
	
	spin_lock_irqsave(&shost->starved_devs_lock, flags);
	list_splice_init(&shost->starved_devs, &starved);
	spin_unlock_irqrestore(&shost->starved_devs_lock, flags);
	
	while (!list_empty(&starved)) {
		struct scsi_device *dev;

		if (shost->host_blocked || shost->host_self_blocked ||
		    (shost->can_queue > 0 &&
		     shost->host_busy >= shost->can_queue))
			break;
	
		dev=list_entry(starved.next,struct scsi_device,starved_entry);
		list_del_init(dev->starved_entry);
		spin_lock_irqsave(dev->request_queue->queue_lock, flags);
		__blk_run_queue(dev->request_queue);
		spin_unlock_irqrestore(dev->request_queue->queue_lock, flags);
	}
	
	if (!list_empty(&starved)) {
		spin_lock_irqsave(&shost->starved_devs_lock, flags);
		list_splice_init(&starved, &shost->starved_devs);
		spin_unlock_irqrestore(&shost->starved_devs_lock, flags);
	}
}


Now since __blk_run_queue(q) call the scsi_request_fn() it MAY
add the device back to the starved list, but that's no problem
as it is already emtpy.  If the host blocks in due time, then
the left over devices are added to the front and we get
prioritization by time (submittal).

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

And this is how scsi_queue_next_request() might look like:
(i.e. a more general form)

static void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd)
{
	struct scsi_device *sdev, *sdev2;
	struct Scsi_Host *shost;
	unsigned long flags;

	ASSERT_LOCK(q->queue_lock, 0);

	sdev = q->queuedata;
	shost = sdev->host;

	scsi_run_starved_devs(shost);

	spin_lock_irqsave(q->queue_lock, flags);
	if (cmd != NULL) {

		/*
		 * For some reason, we are not done with this request.
		 * This happens for I/O errors in the middle of the request,
		 * in which case we need to request the blocks that come after
		 * the bad sector.
		 */
		cmd->request->special = cmd;
		if (blk_rq_tagged(cmd->request))
			blk_queue_end_tag(q, cmd->request);

		/*
		 * set REQ_SPECIAL - we have a command
		 * clear REQ_DONTPREP - we assume the sg table has been
		 *	nuked so we need to set it up again.
		 */
		cmd->request->flags |= REQ_SPECIAL;
		cmd->request->flags &= ~REQ_DONTPREP;
		__elv_add_request(q, cmd->request, 0, 0);
	}

	__blk_run_queue(q);

	spin_unlock_irqrestore(q->queue_lock, flags);
}

And then in scsi_request_fn() you'd genrally include
starved devices in the starved list.

So to summarize, overall, you'd get single_lun devices to the
front of the starved list, others enqueue at the end.
This will give leverage and will give way to sinle_lun target devices
as they are more finicky.


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

