From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_device list_lock (take 2)
Date: Thu, 08 May 2003 13:18:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EBA915C.5020505@rogers.com>
References: <20030506175918.A22717@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep04-mail.bloor.is.net.cable.rogers.com ([66.185.86.74]:22513
	"EHLO fep04-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S261878AbTEHRF5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2003 13:05:57 -0400
In-Reply-To: <20030506175918.A22717@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

In this patch you're not really just changing the list_lock
to dev_lock, but you're messing with the allocation code.

The allocation code was intended to be called from
anywhere, call from any context, scsi_get/put_command() to
get/put a command.  It really is THAT simple.  Please leave it
alone.

A few pointers:
- leave the allocation code alone, and subsequently lay off
of the spare-cmd-per-device idea,
- when submitting patches, please write a complete (even if
redundant) summary of _everything_ the patch does, in clear
and precise manner, just like the rest of us.  This will make
the maintainers more likely to actually look at your patch,
rather than them look through you code and try to unravel
the patch.

A few more comments of general nature are inlined in your patch:

Patrick Mansfield wrote:
> Revised patch (against scsi-misc-2.5) based on comments to use the
> sdev->sdev_lock instead of the sdev->list_lock.
> 
> diff -purN -X /home/patman/dontdiff 2.5-cur/drivers/scsi/dpt_i2o.c rmcmd_lock-2.5-cur/drivers/scsi/dpt_i2o.c
> --- 2.5-cur/drivers/scsi/dpt_i2o.c	Tue May  6 16:22:34 2003
> +++ rmcmd_lock-2.5-cur/drivers/scsi/dpt_i2o.c	Tue May  6 17:23:14 2003
> @@ -2510,7 +2510,7 @@ static void adpt_fail_posted_scbs(adpt_h
>  
>  	list_for_each_entry(d, &pHba->host->my_devices, siblings) {
>  		unsigned long flags;
> -		spin_lock_irqsave(&d->list_lock, flags);
> +		spin_lock_irqsave(&d->sdev_lock, flags);
>  		list_for_each_entry(cmd, &d->cmd_list, list) {
>  			if(cmd->serial_number == 0){
>  				continue;
> @@ -2518,7 +2518,7 @@ static void adpt_fail_posted_scbs(adpt_h
>  			cmd->result = (DID_OK << 16) | (QUEUE_FULL <<1);
>  			cmd->scsi_done(cmd);
>  		}
> -		spin_unlock_irqrestore(&d->list_lock, flags);
> +		spin_unlock_irqrestore(&d->sdev_lock, flags);
>  	}
>  }
>  
> diff -purN -X /home/patman/dontdiff 2.5-cur/drivers/scsi/hosts.c rmcmd_lock-2.5-cur/drivers/scsi/hosts.c
> --- 2.5-cur/drivers/scsi/hosts.c	Tue May  6 16:22:34 2003
> +++ rmcmd_lock-2.5-cur/drivers/scsi/hosts.c	Tue May  6 17:23:14 2003
> @@ -204,7 +204,7 @@ static int scsi_check_device_busy(struct
>  	 * device.  If any of them are busy, then set the state
>  	 * back to inactive and bail.
>  	 */
> -	spin_lock_irqsave(&sdev->list_lock, flags);
> +	spin_lock_irqsave(&sdev->sdev_lock, flags);
>  	list_for_each_entry(scmd, &sdev->cmd_list, list) {
>  		if (scmd->request && scmd->request->rq_status != RQ_INACTIVE)
>  			goto active;
> @@ -217,7 +217,7 @@ static int scsi_check_device_busy(struct
>  		if (scmd->request)
>  			scmd->request->rq_status = RQ_SCSI_DISCONNECTING;
>  	}
> -	spin_unlock_irqrestore(&sdev->list_lock, flags);
> +	spin_unlock_irqrestore(&sdev->sdev_lock, flags);
>  
>  	return 0;
>  
> @@ -234,7 +234,7 @@ active:
>  		}
>  	}
>  
> -	spin_unlock_irqrestore(&sdev->list_lock, flags);
> +	spin_unlock_irqrestore(&sdev->sdev_lock, flags);
>  	printk(KERN_ERR "Device busy???\n");
>  	return 1;
>  }
> diff -purN -X /home/patman/dontdiff 2.5-cur/drivers/scsi/scsi.c rmcmd_lock-2.5-cur/drivers/scsi/scsi.c
> --- 2.5-cur/drivers/scsi/scsi.c	Tue Apr 29 12:24:04 2003
> +++ rmcmd_lock-2.5-cur/drivers/scsi/scsi.c	Tue May  6 17:23:14 2003
> @@ -219,8 +219,8 @@ static struct scsi_host_cmd_pool scsi_cm
>  
>  static DECLARE_MUTEX(host_cmd_pool_mutex);
>  
> -static struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost,
> -					    int gfp_mask)
> +static struct scsi_cmnd *scsi_alloc_cmd(struct Scsi_Host *shost,
> +					       int gfp_mask)

Please lay off of this already.

The choice of PUT and GET is intentional.  Just leave
this code alone.

>  {
>  	struct scsi_cmnd *cmd;
>  
> @@ -242,71 +242,114 @@ static struct scsi_cmnd *__scsi_get_comm
>  	return cmd;
>  }
>  
> -/*
> - * Function:	scsi_get_command()
> - *
> - * Purpose:	Allocate and setup a scsi command block
> - *
> - * Arguments:	dev	- parent scsi device
> - *		gfp_mask- allocator flags
> - *
> - * Returns:	The allocated scsi command structure.
> - */
> -struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, int gfp_mask)
> +static void scsi_init_cmd(struct scsi_device *dev, struct scsi_cmnd *cmd)
>  {
> -	struct scsi_cmnd *cmd = __scsi_get_command(dev->host, gfp_mask);
> -
>  	if (likely(cmd != NULL)) {
> -		unsigned long flags;
> -
>  		memset(cmd, 0, sizeof(*cmd));
>  		cmd->device = dev;
>  		cmd->state = SCSI_STATE_UNUSED;
>  		cmd->owner = SCSI_OWNER_NOBODY;
>  		init_timer(&cmd->eh_timeout);
>  		INIT_LIST_HEAD(&cmd->list);
> -		spin_lock_irqsave(&dev->list_lock, flags);
>  		list_add_tail(&cmd->list, &dev->cmd_list);
> -		spin_unlock_irqrestore(&dev->list_lock, flags);
>  	}
> +}
> +
> +/*
> + * Function:	__scsi_get_command()
> + *
> + * Purpose:	Allocate and setup a scsi command block. This function is
> + * 		extern but not exported outside of scsi.
> + *
> + * Arguments:	dev	- parent scsi device
> + *		gfp_mask- allocator flags
> + *
> + * Locks:	Called with sdev_lock held.

I don't like this in principle.

Spinlocks, especially IRQ ones, are supposed to take the absolute
possible minimum amount of code-area.  And here you're grabbing the
lock elsewhere (in your new version of scsi_get_cmnd()) and then
call this fn.

While the current AND BETTER code preserved the above rule.  It is
nice, succinct and straight to the point.  Let's leave it like this,
please.

There is *no reason* to span boundaries for IRQ locks for such
a simple and straightforward thing as the cmnd allocator.
Unless of course...

> + *
> + * Returns:	The allocated scsi command structure.
> + */
> +struct scsi_cmnd *__scsi_get_command(struct scsi_device *dev, int gfp_mask)
> +{
> +	struct scsi_cmnd *cmd = scsi_alloc_cmd(dev->host, gfp_mask);
>  
> +	scsi_init_cmd(dev, cmd);
>  	return cmd;
>  }				

What is the advantage here?  What if scsi_alloc_cmd() fails?
Then scsi_init_cmd() oopses because you removed the checks...

Please lay off of this code already.

Plus, you're making the nesting level TOO deep for something
as trivial as an allocator.
  
>  /*
> - * Function:	scsi_put_command()
> + * Function:	scsi_get_command()
> + *
> + * Purpose:	Allocate and setup a scsi command block. This function is
> + * 		exported.
> + *
> + * Arguments:	dev	- parent scsi device
> + *		gfp_mask- allocator flags
> + *
> + * Returns:	Nothing.
> + */
> +struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, int gfp_mask)
> +{
> +	struct scsi_cmnd *cmd = scsi_alloc_cmd(dev->host, gfp_mask);
> +	unsigned long flags;
> +	
> +	spin_lock_irqsave(&dev->sdev_lock, flags);
> +	scsi_init_cmd(dev, cmd);
> +	spin_unlock_irqrestore(&dev->sdev_lock, flags);
> +	return cmd;
> +}
> +
> +/*
> + * Function:	__scsi_put_command()
>   *
> - * Purpose:	Free a scsi command block
> + * Purpose:	Free a scsi command block. This function is extern but not
> + * 		exported outside of scsi.
>   *
>   * Arguments:	cmd	- command block to free
>   *
>   * Returns:	Nothing.
>   *
> + * Locks:	Called with sdev_lock held.
> + *
>   * Notes:	The command must not belong to any lists.
>   */
> -void scsi_put_command(struct scsi_cmnd *cmd)
> +void __scsi_put_command(struct scsi_cmnd *cmd)
>  {
>  	struct Scsi_Host *shost = cmd->device->host;
> -	unsigned long flags;
>  	
>  	/* serious error if the command hasn't come from a device list */
> -	spin_lock_irqsave(&cmd->device->list_lock, flags);
>  	BUG_ON(list_empty(&cmd->list));
>  	list_del_init(&cmd->list);
> -	spin_unlock(&cmd->device->list_lock);
> -	/* changing locks here, don't need to restore the irq state */
>  	spin_lock(&shost->free_list_lock);
>  	if (unlikely(list_empty(&shost->free_list))) {
>  		list_add(&cmd->list, &shost->free_list);
>  		cmd = NULL;
>  	}
> -	spin_unlock_irqrestore(&shost->free_list_lock, flags);
> +	spin_unlock(&shost->free_list_lock);
>  
>  	if (likely(cmd != NULL))
>  		kmem_cache_free(shost->cmd_pool->slab, cmd);
>  }

You see, here you're assuming that the sdev_lock is held
with IRQ... just like you're assuming in your code
that the request queue lock is the same as the sdev lock...

Assumptions like this make for a messy code.  Think modularization.

While I see why you _might_ want a separate allocation
for holding and NOT-holding the spinlock,
with the given structure of the scsi_prep_fn, you DON'T
need it.

>  /*
> + * Function:	scsi_put_command()
> + *
> + * Purpose:	Free a scsi command block. This function is exported.
> + *
> + * Arguments:	cmd	- command block to free
> + *
> + * Returns:	Nothing.
> + */
> +void scsi_put_command(struct scsi_cmnd *cmd)
> +{
> +	struct scsi_device *sdev = cmd->device;
> +	unsigned long flags;
> +	
> +	spin_lock_irqsave(&sdev->sdev_lock, flags);
> +	__scsi_put_command(cmd);
> +	spin_unlock_irqrestore(&sdev->sdev_lock, flags);
> +}
> +

Similar comments as the ones above for the spin_lock
being held accross boundaries, *for no particular reason*.

> +/*
>   * Function:	scsi_setup_command_freelist()
>   *
>   * Purpose:	Setup the command freelist for a scsi host.
> @@ -1240,7 +1283,7 @@ void scsi_device_put(struct scsi_device 
>   * scsi_set_device_offline - set scsi_device offline
>   * @sdev:	pointer to struct scsi_device to offline. 
>   *
> - * Locks:	host_lock held on entry.
> + * Locks:	No scsi locks should be held on entry.
>   **/
>  void scsi_set_device_offline(struct scsi_device *sdev)
>  {
> @@ -1251,7 +1294,7 @@ void scsi_set_device_offline(struct scsi
>  
>  	sdev->online = 0;
>  
> -	spin_lock_irqsave(&sdev->list_lock, flags);
> +	spin_lock_irqsave(&sdev->sdev_lock, flags);
>  	list_for_each_entry(scmd, &sdev->cmd_list, list) {
>  		if (scmd->request && scmd->request->rq_status != RQ_INACTIVE) {
>  			/*
> @@ -1264,7 +1307,7 @@ void scsi_set_device_offline(struct scsi
>  			list_add_tail(&scmd->eh_entry, &active_list);
>  		}
>  	}
> -	spin_unlock_irqrestore(&sdev->list_lock, flags);
> +	spin_unlock_irqrestore(&sdev->sdev_lock, flags);
>  
>  	if (!list_empty(&active_list)) {
>  		list_for_each_safe(lh, lh_sf, &active_list) {
> diff -purN -X /home/patman/dontdiff 2.5-cur/drivers/scsi/scsi.h rmcmd_lock-2.5-cur/drivers/scsi/scsi.h
> --- 2.5-cur/drivers/scsi/scsi.h	Tue Apr 29 11:14:15 2003
> +++ rmcmd_lock-2.5-cur/drivers/scsi/scsi.h	Tue May  6 17:23:14 2003
> @@ -327,7 +327,6 @@ struct scsi_device {
>  	request_queue_t *request_queue;
>  	volatile unsigned short device_busy;	/* commands actually active on low-level */
>  	spinlock_t sdev_lock;           /* also the request queue_lock */

Now comments like this should be gone.  This shows structural flaw
and should be corrected with fixing the code.  Even if it means
two separate locks (we can jump the IRQ as we already do in so many
places in SCSI Core).

In the future *this* comment might NOT be true, but having it here
like this, shifts SCSI Core's structural design into cr*p, i.e.
let's NOT bias developers into thinking that this will be true
forever.

> -	spinlock_t list_lock;
>  	struct list_head cmd_list;	/* queue of in use SCSI Command structures */
>  	struct list_head starved_entry;
>          Scsi_Cmnd *current_cmnd;	/* currently active command */
> diff -purN -X /home/patman/dontdiff 2.5-cur/drivers/scsi/scsi_lib.c rmcmd_lock-2.5-cur/drivers/scsi/scsi_lib.c
> --- 2.5-cur/drivers/scsi/scsi_lib.c	Tue Apr 29 11:14:15 2003
> +++ rmcmd_lock-2.5-cur/drivers/scsi/scsi_lib.c	Tue May  6 17:23:14 2003
> @@ -528,13 +528,13 @@ static struct scsi_cmnd *scsi_end_reques
>  	if (blk_rq_tagged(req))
>  		blk_queue_end_tag(q, req);
>  	end_that_request_last(req);
> +	__scsi_put_command(cmd);
>  	spin_unlock_irqrestore(q->queue_lock, flags);
>  
>  	/*
>  	 * This will goose the queue request function at the end, so we don't
>  	 * need to worry about launching another command.
>  	 */
> -	scsi_put_command(cmd);
>  	scsi_queue_next_request(q, NULL);
>  	return NULL;
>  }
> @@ -950,7 +950,7 @@ static int scsi_init_io(struct scsi_cmnd
>  			req->current_nr_sectors);
>  
>  	/* release the command and kill it */
> -	scsi_put_command(cmd);
> +	__scsi_put_command(cmd);
>  	return BLKPREP_KILL;
>  }
>  
> @@ -974,7 +974,7 @@ static int scsi_prep_fn(struct request_q
>  		struct scsi_request *sreq = req->special;
>  
>  		if (sreq->sr_magic == SCSI_REQ_MAGIC) {
> -			cmd = scsi_get_command(sreq->sr_device, GFP_ATOMIC);
> +			cmd = __scsi_get_command(sreq->sr_device, GFP_ATOMIC);
>  			if (unlikely(!cmd))
>  				goto defer;
>  			scsi_init_cmd_from_req(cmd, sreq);
> @@ -985,7 +985,7 @@ static int scsi_prep_fn(struct request_q
>  		 * Now try and find a command block that we can use.
>  		 */
>  		if (!req->special) {
> -			cmd = scsi_get_command(sdev, GFP_ATOMIC);
> +			cmd = __scsi_get_command(sdev, GFP_ATOMIC);
>  			if (unlikely(!cmd))
>  				goto defer;
>  		} else
> @@ -1006,10 +1006,10 @@ static int scsi_prep_fn(struct request_q
>  	
>  	/*
>  	 * FIXME: drop the lock here because the functions below
> -	 * expect to be called without the queue lock held.  Also,
> -	 * previously, we dequeued the request before dropping the
> -	 * lock.  We hope REQ_STARTED prevents anything untoward from
> -	 * happening now.
> +	 * expect to be called without the queue lock held (except
> +	 * __scsi_put_command). Also, previously, we dequeued the request
> +	 * before dropping the lock. We hope REQ_STARTED prevents
> +	 * anything untoward from happening now.
>  	 */
>  	if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
>  		int ret;
> @@ -1042,7 +1042,7 @@ static int scsi_prep_fn(struct request_q
>  		 */
>  		if (unlikely(!sdt->init_command(cmd))) {
>  			scsi_release_buffers(cmd);
> -			scsi_put_command(cmd);
> +			__scsi_put_command(cmd);
>  			return BLKPREP_KILL;
>  		}
>  	}
> diff -purN -X /home/patman/dontdiff 2.5-cur/drivers/scsi/scsi_priv.h rmcmd_lock-2.5-cur/drivers/scsi/scsi_priv.h
> --- 2.5-cur/drivers/scsi/scsi_priv.h	Tue Apr 29 12:24:04 2003
> +++ rmcmd_lock-2.5-cur/drivers/scsi/scsi_priv.h	Tue May  6 17:23:14 2003
> @@ -61,6 +61,8 @@ extern void scsi_host_init(void);
>  
>  /* scsi.c */
>  extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
> +extern struct scsi_cmnd *__scsi_get_command(struct scsi_device *dev, int flags);
> +extern void __scsi_put_command(struct scsi_cmnd *cmd);
>  extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
>  extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
>  extern void scsi_done(struct scsi_cmnd *cmd);
> diff -purN -X /home/patman/dontdiff 2.5-cur/drivers/scsi/scsi_scan.c rmcmd_lock-2.5-cur/drivers/scsi/scsi_scan.c
> --- 2.5-cur/drivers/scsi/scsi_scan.c	Tue May  6 16:22:34 2003
> +++ rmcmd_lock-2.5-cur/drivers/scsi/scsi_scan.c	Tue May  6 17:23:14 2003
> @@ -408,7 +408,6 @@ static struct scsi_device *scsi_alloc_sd
>  	INIT_LIST_HEAD(&sdev->same_target_siblings);
>  	INIT_LIST_HEAD(&sdev->cmd_list);
>  	INIT_LIST_HEAD(&sdev->starved_entry);
> -	spin_lock_init(&sdev->list_lock);
>  
>  	/*
>  	 * Some low level driver could use device->type
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Luben


