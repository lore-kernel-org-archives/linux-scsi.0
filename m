From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 1/7 starved changes - use a list_head for starved queue's
Date: Tue, 25 Mar 2003 14:39:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E80B058.5000801@splentec.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> Use a list_head per scsi_host to store a list of scsi request queues
> that were "starved" (they were not able to send IO because of per host
> limitations).

This patch has been discussed already!

The only meaningful piece is the adding of the starved_entry
and starved_list, which should probably be incorporated
logically in your latter patches.

This will make the job of the maintaners a lot easier and
the patch(es) alot more logically bound.


> diff -purN -X /home/patman/dontdiff 25-bk-base/drivers/scsi/hosts.c starve-25/drivers/scsi/hosts.c
> --- 25-bk-base/drivers/scsi/hosts.c	Thu Mar  6 12:34:47 2003
> +++ starve-25/drivers/scsi/hosts.c	Mon Mar 24 12:14:28 2003
> @@ -383,6 +383,7 @@ struct Scsi_Host * scsi_register(Scsi_Ho
>  	scsi_assign_lock(shost, &shost->default_lock);
>  	INIT_LIST_HEAD(&shost->my_devices);
>  	INIT_LIST_HEAD(&shost->eh_cmd_q);
> +	INIT_LIST_HEAD(&shost->starved_list);
>  
>  	init_waitqueue_head(&shost->host_wait);
>  	shost->dma_channel = 0xff;
> diff -purN -X /home/patman/dontdiff 25-bk-base/drivers/scsi/hosts.h starve-25/drivers/scsi/hosts.h
> --- 25-bk-base/drivers/scsi/hosts.h	Tue Mar 18 12:53:33 2003
> +++ starve-25/drivers/scsi/hosts.h	Mon Mar 24 12:14:28 2003
> @@ -380,6 +380,7 @@ struct Scsi_Host
>      struct scsi_host_cmd_pool *cmd_pool;
>      spinlock_t            free_list_lock;
>      struct list_head      free_list;   /* backup store of cmd structs */
> +    struct list_head      starved_list;
>  
>      spinlock_t		  default_lock;
>      spinlock_t		  *host_lock;
> @@ -471,12 +472,6 @@ struct Scsi_Host
>      unsigned reverse_ordering:1;
>  
>      /*
> -     * Indicates that one or more devices on this host were starved, and
> -     * when the device becomes less busy that we need to feed them.
> -     */
> -    unsigned some_device_starved:1;
> -   
> -    /*
>       * Host has rejected a command because it was busy.
>       */
>      unsigned int host_blocked;
> diff -purN -X /home/patman/dontdiff 25-bk-base/drivers/scsi/scsi.h starve-25/drivers/scsi/scsi.h
> --- 25-bk-base/drivers/scsi/scsi.h	Mon Mar 24 11:57:13 2003
> +++ starve-25/drivers/scsi/scsi.h	Mon Mar 24 12:14:28 2003
> @@ -555,6 +555,7 @@ struct scsi_device {
>  	volatile unsigned short device_busy;	/* commands actually active on low-level */
>  	spinlock_t list_lock;
>  	struct list_head cmd_list;	/* queue of in use SCSI Command structures */
> +	struct list_head starved_entry;
>          Scsi_Cmnd *current_cmnd;	/* currently active command */
>  	unsigned short queue_depth;	/* How deep of a queue we want */
>  	unsigned short last_queue_full_depth; /* These two are used by */
> @@ -615,8 +616,6 @@ struct scsi_device {
>  					 * because we did a bus reset. */
>  	unsigned ten:1;		/* support ten byte read / write */
>  	unsigned remap:1;	/* support remapping  */
> -	unsigned starved:1;	/* unable to process commands because
> -				   host busy */
>  //	unsigned sync:1;	/* Sync transfer state, managed by host */
>  //	unsigned wide:1;	/* WIDE transfer state, managed by host */
>  
> diff -purN -X /home/patman/dontdiff 25-bk-base/drivers/scsi/scsi_lib.c starve-25/drivers/scsi/scsi_lib.c
> --- 25-bk-base/drivers/scsi/scsi_lib.c	Tue Mar 18 12:53:33 2003
> +++ starve-25/drivers/scsi/scsi_lib.c	Mon Mar 24 12:14:28 2003
> @@ -356,7 +356,6 @@ static void scsi_queue_next_request(requ
>  	struct scsi_device *sdev, *sdev2;
>  	struct Scsi_Host *shost;
>  	unsigned long flags;
> -	int all_clear;
>  
>  	ASSERT_LOCK(q->queue_lock, 0);
>  
> @@ -383,11 +382,6 @@ static void scsi_queue_next_request(requ
>  		__elv_add_request(q, cmd->request, 0, 0);
>  	}
>  
> -	/*
> -	 * Just hit the requeue function for the queue.
> -	 */
> -	__blk_run_queue(q);
> -
>  	sdev = q->queuedata;
>  	shost = sdev->host;
>  
> @@ -412,31 +406,24 @@ static void scsi_queue_next_request(requ
>  		}
>  	}
>  
> -	/*
> -	 * Now see whether there are other devices on the bus which
> -	 * might be starved.  If so, hit the request function.  If we
> -	 * don't find any, then it is safe to reset the flag.  If we
> -	 * find any device that it is starved, it isn't safe to reset the
> -	 * flag as the queue function releases the lock and thus some
> -	 * other device might have become starved along the way.
> -	 */
> -	all_clear = 1;
> -	if (shost->some_device_starved) {
> -		list_for_each_entry(sdev, &shost->my_devices, siblings) {
> -			if (shost->can_queue > 0 &&
> -			    shost->host_busy >= shost->can_queue)
> -				break;
> -			if (shost->host_blocked || shost->host_self_blocked)
> -				break;
> -			if (sdev->device_blocked || !sdev->starved)
> -				continue;
> -			__blk_run_queue(sdev->request_queue);
> -			all_clear = 0;
> -		}
> -
> -		if (sdev == NULL && all_clear)
> -			shost->some_device_starved = 0;
> +	while (!list_empty(&shost->starved_list) &&
> +	       !shost->host_blocked && !shost->host_self_blocked &&
> +		!((shost->can_queue > 0) &&
> +		  (shost->host_busy >= shost->can_queue))) {
> +		/*
> +		 * As long as shost is accepting commands and we have
> +		 * starved queues, call __blk_run_queue. scsi_request_fn
> +		 * drops the queue_lock and can add us back to the
> +		 * starved_list.
> +		 */
> +		sdev2 = list_entry(shost->starved_list.next,
> +					  struct scsi_device, starved_entry);
> +		list_del_init(&sdev2->starved_entry);
> +		__blk_run_queue(sdev2->request_queue);
>  	}
> +
> +	__blk_run_queue(q);
> +
>  	spin_unlock_irqrestore(q->queue_lock, flags);
>  }
>  
> @@ -1115,23 +1102,16 @@ static void scsi_request_fn(request_queu
>  		 */
>  		if (sdev->device_blocked)
>  			break;
> +
> +		if (!list_empty(&sdev->starved_entry))
> +			break;
> +
>  		if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
>  		    shost->host_blocked || shost->host_self_blocked) {
> -			/*
> -			 * If we are unable to process any commands at all for
> -			 * this device, then we consider it to be starved.
> -			 * What this means is that there are no outstanding
> -			 * commands for this device and hence we need a
> -			 * little help getting it started again
> -			 * once the host isn't quite so busy.
> -			 */
> -			if (sdev->device_busy == 0) {
> -				sdev->starved = 1;
> -				shost->some_device_starved = 1;
> -			}
> +			list_add_tail(&sdev->starved_entry,
> +				      &shost->starved_list);
>  			break;
> -		} else
> -			sdev->starved = 0;
> +		}
>  
>  		/*
>  		 * If we couldn't find a request that could be queued, then we
> diff -purN -X /home/patman/dontdiff 25-bk-base/drivers/scsi/scsi_scan.c starve-25/drivers/scsi/scsi_scan.c
> --- 25-bk-base/drivers/scsi/scsi_scan.c	Mon Mar 24 11:57:13 2003
> +++ starve-25/drivers/scsi/scsi_scan.c	Mon Mar 24 12:14:28 2003
> @@ -400,6 +400,7 @@ static struct scsi_device *scsi_alloc_sd
>  	INIT_LIST_HEAD(&sdev->siblings);
>  	INIT_LIST_HEAD(&sdev->same_target_siblings);
>  	INIT_LIST_HEAD(&sdev->cmd_list);
> +	INIT_LIST_HEAD(&sdev->starved_entry);
>  	spin_lock_init(&sdev->list_lock);
>  
>  	/*
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Luben Tuikov, Senior Software Engineer, Splentec Ltd.
Bus: +1-905-707-1954x112, 9-5 EDT. Fax: +1-905-707-1974.

