From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] fixes and cleanups for the new command allocation code
Date: Tue, 4 Feb 2003 08:16:16 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030204081616.A24105@beaverton.ibm.com>
References: <20030204162326.A30755@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030204162326.A30755@lst.de>; from hch@lst.de on Tue, Feb 04, 2003 at 04:23:27PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Feb 04, 2003 at 04:23:27PM +0100, Christoph Hellwig wrote:

> -static int check_all_luns(struct Scsi_Host *shost, struct scsi_device *myself)
> -{
> -	struct scsi_device *sdev;
> -
> -	list_for_each_entry(sdev, &myself->same_target_siblings,
> -		       	same_target_siblings) {
> -		if (atomic_read(&sdev->device_active))
> -			return 1;
> -	}
> -
> -	return 0;
> -}

We should still be calling the above from somewhere.

> -struct scsi_cmnd *scsi_allocate_device(struct scsi_device *sdev, int wait)
> -{
> -	DECLARE_WAITQUEUE(wq, current);
> -	struct Scsi_Host *shost = sdev->host;
> -	struct scsi_cmnd *scmnd;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&device_request_lock, flags);
> -	while (1) {
> -		if (sdev->device_blocked)
> -			goto busy;
> -		if (sdev->single_lun && check_all_luns(shost, sdev))
> -			goto busy;
> -
> -		/*
> -		 * Now we can check for a free command block for this device.
> -		 */
> -		for (scmnd = sdev->device_queue; scmnd; scmnd = scmnd->next)
> -			if (!scmnd->request)
> -				goto found;
> -
> -busy:
> -		if (!wait)
> -			goto fail;
> -
> -		/*
> -		 * We need to wait for a free commandblock.  We need to
> -		 * insert ourselves into the list before we release the
> -		 * lock.  This way if a block were released the same
> -		 * microsecond that we released the lock, the call
> -		 * to schedule() wouldn't block (well, it might switch,
> -		 * but the current task will still be schedulable.
> -		 */
> -		add_wait_queue(&sdev->scpnt_wait, &wq);
> -		set_current_state(TASK_UNINTERRUPTIBLE);

We are missing the above checks and functionallity in scsi_get_command.

The limit previously imposed by current_queue_depth via the number of
scmnd's allocated is not checked - scsi_get_command should check
device_busy < new_queue_depth.

I was trying to fix/hit this - surprisingly, I did not see performance
problems (i.e. getting tons of QUEUE_FULLs), probably because my request
queue limits are 128, and the disks are not old.

Also the above did not properly get the host_lock/queue_lock when wait != 0
(the caller does not lock, so just when we might sleep we also need to
get/release a lock).

> +struct scsi_host_cmd_pool {
> +	kmem_cache_t	*slab;
> +	unsigned int	users;
> +	char		*name;
> +	unsigned int	slab_flags;
> +	unsigned int	gfp_mask;
> +};

> +static struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost,
> +					    int gfp_mask)
> +{
> +	struct scsi_cmnd *cmd;
> +	
> +	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
> +			gfp_mask | shost->cmd_pool->gfp_mask);
> +
> +	if (unlikely(!cmd)) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&shost->free_list_lock, flags);
> +		if (likely(!list_empty(&shost->free_list))) {
> +			cmd = list_entry(shost->free_list.next,
> +					 struct scsi_cmnd, list);
> +			list_del_init(&cmd->list);
> +		}
> +		spin_unlock_irqrestore(&shost->free_list_lock, flags);
> +	}
> +
> +	return cmd;
> +}
> +
> +/*
> + * Function:	scsi_get_command()
> + *
> + * Purpose:	Allocate and setup a scsi command block
> + *
> + * Arguments:	dev	- parent scsi device
> + *		gfp_mask- allocator flags
> + *
> + * Returns:	The allocated scsi command structure.
> + */
> +struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, int gfp_mask)
> +{
> +	struct scsi_cmnd *cmd = __scsi_get_command(dev->host, gfp_mask);
> +
> +	if (likely(cmd)) {
> +		memset(cmd, 0, sizeof(*cmd));
> +		cmd->device = dev;
> +		cmd->state = SCSI_STATE_UNUSED;
> +		cmd->owner = SCSI_OWNER_NOBODY;
> +		init_timer(&cmd->eh_timeout);
> +		INIT_LIST_HEAD(&cmd->list);
> +	}
> +
> +	return cmd;
> +}				

So one of the above needs to (conditionally ... based on gfp_mask?) get
host/queue_lock, check limits, and conditionally add_wait_queue().

> +int scsi_setup_command_freelist(struct Scsi_Host *shost)
> +{
> +	struct scsi_host_cmd_pool *pool;
> +	struct scsi_cmnd *cmd;
> +
> +	spin_lock_init(&shost->free_list_lock);
> +	INIT_LIST_HEAD(&shost->free_list);
> +
> +	/*
> +	 * Select a command slab for this host and create it if not
> +	 * yet existant.
> +	 */
> +	pool = (shost->unchecked_isa_dma ? &scsi_cmd_dma_pool : &scsi_cmd_pool);
> +	if (!pool->users) {
> +		pool->slab = kmem_cache_create(pool->name,
> +				sizeof(struct scsi_cmnd), 0,
> +				pool->slab_flags, NULL, NULL);
> +		if (!pool->slab)
> +			return -ENOMEM;
> +	}
> +
> +	pool->users++;
> +	shost->cmd_pool = pool;
> +
> +	/*
> +	 * Get one backup command for this host.
> +	 */
> +	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
> +			GFP_KERNEL | shost->cmd_pool->gfp_mask);
> +	if (!cmd)
> +		goto fail;
> +	list_add(&cmd->list, &shost->free_list);		
> +	return 0;
> +
> +fail:
> +	if (!--pool->users)
> +		kmem_cache_destroy(pool->slab);
> +	return -ENOMEM;
> +
> +}

What protects pool->users?

-- Patrick Mansfield
