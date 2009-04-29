From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH 2/3] scsi_dh: Remove the workqueue used for activate
Date: Wed, 29 Apr 2009 15:12:16 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF46EB72D9A@cosmail01.lsi.com>
References: <20090428025230.11108.88559.sendpatchset@chandra-ubuntu>
 <20090428025242.11108.43024.sendpatchset@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og53.obsmtp.com ([64.18.14.171]:36056 "EHLO
	chip3og53.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660AbZD2VMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 17:12:23 -0400
In-Reply-To: <20090428025242.11108.43024.sendpatchset@chandra-ubuntu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>

Tested by: Babu Moger <babu.moger@lsi.com>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Chandra Seetharaman
> Sent: Monday, April 27, 2009 9:53 PM
> To: linux-scsi@vger.kernel.org
> Cc: dm-devel@redhat.com; Moger, Babu; michaelc@cs.wisc.edu; Chandra
> Seetharaman
> Subject: [PATCH 2/3] scsi_dh: Remove the workqueue used for activate
> 
> Since scsi_dh_activate() has become an asynchronous function,
> we do not need a workqueue for submitting scsi_dh_activate().
> 
> This patch just removes the workqueue that submits scsi_dh_activate().
> 
> ---------
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  drivers/md/dm-mpath.c |   51 ++++----------------------------------------
> ------
>  1 file changed, 4 insertions(+), 47 deletions(-)
> 
> Index: linux-2.6.29/drivers/md/dm-mpath.c
> ===================================================================
> --- linux-2.6.29.orig/drivers/md/dm-mpath.c
> +++ linux-2.6.29/drivers/md/dm-mpath.c
> @@ -64,8 +64,6 @@ struct multipath {
>  	spinlock_t lock;
> 
>  	const char *hw_handler_name;
> -	struct work_struct activate_path;
> -	struct pgpath *pgpath_to_activate;
>  	unsigned nr_priority_groups;
>  	struct list_head priority_groups;
>  	unsigned pg_init_required;	/* pg_init needs calling? */
> @@ -110,11 +108,11 @@ typedef int (*action_fn) (struct pgpath
> 
>  static struct kmem_cache *_mpio_cache;
> 
> -static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
> +static struct workqueue_struct *kmultipathd;
>  static void process_queued_ios(struct work_struct *work);
>  static void trigger_event(struct work_struct *work);
> -static void activate_path(struct work_struct *work);
>  static void deactivate_path(struct work_struct *work);
> +static void pg_init_done(void *path, int errors);
> 
> 
>  /*-----------------------------------------------
> @@ -160,7 +158,6 @@ static struct priority_group *alloc_prio
> 
>  static void free_pgpaths(struct list_head *pgpaths, struct dm_target *ti)
>  {
> -	unsigned long flags;
>  	struct pgpath *pgpath, *tmp;
>  	struct multipath *m = ti->private;
> 
> @@ -169,10 +166,6 @@ static void free_pgpaths(struct list_hea
>  		if (m->hw_handler_name)
>  			scsi_dh_detach(bdev_get_queue(pgpath->path.dev->bdev));
>  		dm_put_device(ti, pgpath->path.dev);
> -		spin_lock_irqsave(&m->lock, flags);
> -		if (m->pgpath_to_activate == pgpath)
> -			m->pgpath_to_activate = NULL;
> -		spin_unlock_irqrestore(&m->lock, flags);
>  		free_pgpath(pgpath);
>  	}
>  }
> @@ -202,7 +195,6 @@ static struct multipath *alloc_multipath
>  		m->queue_io = 1;
>  		INIT_WORK(&m->process_queued_ios, process_queued_ios);
>  		INIT_WORK(&m->trigger_event, trigger_event);
> -		INIT_WORK(&m->activate_path, activate_path);
>  		m->mpio_pool = mempool_create_slab_pool(MIN_IOS, _mpio_cache);
>  		if (!m->mpio_pool) {
>  			kfree(m);
> @@ -446,7 +438,6 @@ static void process_queued_ios(struct wo
>  		must_queue = 0;
> 
>  	if (m->pg_init_required && !m->pg_init_in_progress && pgpath) {
> -		m->pgpath_to_activate = pgpath;
>  		m->pg_init_count++;
>  		m->pg_init_required = 0;
>  		m->pg_init_in_progress = 1;
> @@ -457,7 +448,8 @@ out:
>  	spin_unlock_irqrestore(&m->lock, flags);
> 
>  	if (init_required)
> -		queue_work(kmpath_handlerd, &m->activate_path);
> +		scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
> +						 pg_init_done, &pgpath->path);
> 
>  	if (!must_queue)
>  		dispatch_queued_ios(m);
> @@ -834,7 +826,6 @@ static void multipath_dtr(struct dm_targ
>  {
>  	struct multipath *m = (struct multipath *) ti->private;
> 
> -	flush_workqueue(kmpath_handlerd);
>  	flush_workqueue(kmultipathd);
>  	free_multipath(m);
>  }
> @@ -1116,24 +1107,6 @@ static void pg_init_done(void *data, int
>  	spin_unlock_irqrestore(&m->lock, flags);
>  }
> 
> -static void activate_path(struct work_struct *work)
> -{
> -	int ret;
> -	struct multipath *m =
> -		container_of(work, struct multipath, activate_path);
> -	struct dm_path *path;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&m->lock, flags);
> -	path = &m->pgpath_to_activate->path;
> -	m->pgpath_to_activate = NULL;
> -	spin_unlock_irqrestore(&m->lock, flags);
> -	if (!path)
> -		return;
> -	ret = scsi_dh_activate(bdev_get_queue(path->dev->bdev),
> -				pg_init_done, path);
> -}
> -
>  /*
>   * end_io handling
>   */
> @@ -1471,21 +1444,6 @@ static int __init dm_multipath_init(void
>  		return -ENOMEM;
>  	}
> 
> -	/*
> -	 * A separate workqueue is used to handle the device handlers
> -	 * to avoid overloading existing workqueue. Overloading the
> -	 * old workqueue would also create a bottleneck in the
> -	 * path of the storage hardware device activation.
> -	 */
> -	kmpath_handlerd = create_singlethread_workqueue("kmpath_handlerd");
> -	if (!kmpath_handlerd) {
> -		DMERR("failed to create workqueue kmpath_handlerd");
> -		destroy_workqueue(kmultipathd);
> -		dm_unregister_target(&multipath_target);
> -		kmem_cache_destroy(_mpio_cache);
> -		return -ENOMEM;
> -	}
> -
>  	DMINFO("version %u.%u.%u loaded",
>  	       multipath_target.version[0], multipath_target.version[1],
>  	       multipath_target.version[2]);
> @@ -1495,7 +1453,6 @@ static int __init dm_multipath_init(void
> 
>  static void __exit dm_multipath_exit(void)
>  {
> -	destroy_workqueue(kmpath_handlerd);
>  	destroy_workqueue(kmultipathd);
> 
>  	dm_unregister_target(&multipath_target);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
