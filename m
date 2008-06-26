From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 7/9] scsi_dh: attach to hardware handler from dm-mpath
Date: Wed, 25 Jun 2008 18:00:06 -0700
Message-ID: <1214442006.32521.22.camel@chandra-ubuntu>
References: <20080624100519.E7BBE10B5DE@craiglockhart-ipmi.suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59607 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbYFZBAL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 21:00:11 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5Q10AEP019401
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2008 21:00:10 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5Q10AoN226266
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2008 21:00:10 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5Q109n6024461
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2008 21:00:10 -0400
In-Reply-To: <20080624100519.E7BBE10B5DE@craiglockhart-ipmi.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

On Tue, 2008-06-24 at 12:05 +0200, Hannes Reinecke wrote:
> multipath keeps a separate device table which may be
> more current than the built-in one.
> So we should make sure to always call ->attach whenever
> a multipath map with hardware handler is instantiated.
> And we should call ->detach on removal, too.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-mpath.c                 |   13 ++++++
>  drivers/scsi/device_handler/scsi_dh.c |   68 ++++++++++++++++++++++++++++++++-
>  include/scsi/scsi_dh.h                |    2 +
>  3 files changed, 81 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index e8f704a..bd2bcf4 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -147,9 +147,12 @@ static struct priority_group *alloc_priority_group(void)
>  static void free_pgpaths(struct list_head *pgpaths, struct dm_target *ti)
>  {
>  	struct pgpath *pgpath, *tmp;
> +	struct multipath *m = (struct multipath *) ti->private;
> 
>  	list_for_each_entry_safe(pgpath, tmp, pgpaths, list) {
>  		list_del(&pgpath->list);
> +		if (m->hw_handler_name)
> +			scsi_dh_detach(bdev_get_queue(pgpath->path.dev->bdev));
>  		dm_put_device(ti, pgpath->path.dev);
>  		free_pgpath(pgpath);
>  	}
> @@ -546,6 +549,7 @@ static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
>  {
>  	int r;
>  	struct pgpath *p;
> +	struct multipath *m = (struct multipath *) ti->private;
> 
>  	/* we need at least a path arg */
>  	if (as->argc < 1) {
> @@ -564,6 +568,15 @@ static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
>  		goto bad;
>  	}
> 
> +	if (m->hw_handler_name) {
> +		r = scsi_dh_attach(bdev_get_queue(p->path.dev->bdev),
> +				   m->hw_handler_name);
> +		if (r < 0) {
> +			dm_put_device(ti, p->path.dev);
> +			goto bad;
> +		}
> +	}
> +
>  	r = ps->type->add_path(ps, &p->path, as->argc, as->argv, &ti->error);
>  	if (r) {
>  		dm_put_device(ti, p->path.dev);
> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
> index 7cbd1f6..a505e83 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -95,8 +95,8 @@ static void scsi_dh_handler_detach(struct scsi_device *sdev,
>  	if (scsi_dh && scsi_dh != sdev->scsi_dh_data->scsi_dh)
>  		return;
> 
> -	if (scsi_dh->detach)
> -		scsi_dh->detach(sdev);
> +	if (sdev->scsi_dh_data->scsi_dh->detach)
> +		sdev->scsi_dh_data->scsi_dh->detach(sdev);
>  }
> 
>  /*
> @@ -366,6 +366,70 @@ int scsi_dh_handler_exist(const char *name)
>  }
>  EXPORT_SYMBOL_GPL(scsi_dh_handler_exist);
> 
> +/*
> + * scsi_dh_handler_attach - Attach device handler
> + * @sdev - sdev the handler should be attached to
> + * @name - name of the handler to attach
> + */
> +int scsi_dh_attach(struct request_queue *q, const char *name)
> +{
> +	unsigned long flags;
> +	struct scsi_device *sdev;
> +	struct scsi_device_handler *scsi_dh;
> +	int err = 0;
> +
> +	scsi_dh = get_device_handler(name);
> +	if (!scsi_dh)
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(q->queue_lock, flags);
> +	sdev = q->queuedata;
> +	if (!sdev || !get_device(&sdev->sdev_gendev))
> +		err = -ENODEV;
> +	spin_unlock_irqrestore(q->queue_lock, flags);
> +
> +	if (!err) {
> +		err = scsi_dh_handler_attach(sdev, scsi_dh);
> +
> +		put_device(&sdev->sdev_gendev);
> +	}
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(scsi_dh_attach);
> +
> +/*
> + * scsi_dh_handler_detach - Detach device handler
> + * @sdev - sdev the handler should be detached from
> + *
> + * This function will detach the device handler only
> + * if the sdev is not part of the internal list, ie
> + * if it has been attached manually.
> + */
> +void scsi_dh_detach(struct request_queue *q)
> +{
> +	unsigned long flags;
> +	struct scsi_device *sdev;
> +	struct scsi_device_handler *scsi_dh = NULL;
> +
> +	spin_lock_irqsave(q->queue_lock, flags);
> +	sdev = q->queuedata;
> +	if (!sdev || !get_device(&sdev->sdev_gendev))
> +		sdev = NULL;
> +	spin_unlock_irqrestore(q->queue_lock, flags);
> +
> +	if (!sdev)
> +		return;
> +
> +	if (sdev->scsi_dh_data) {
> +		/* if sdev is not on internal list, detach */
> +		scsi_dh = sdev->scsi_dh_data->scsi_dh;
> +		if (!device_handler_match(scsi_dh, sdev))
> +			scsi_dh_handler_detach(sdev, scsi_dh);
> +	}
> +	put_device(&sdev->sdev_gendev);
> +}
> +EXPORT_SYMBOL_GPL(scsi_dh_detach);
> +
>  static struct notifier_block scsi_dh_nb = {
>  	.notifier_call = scsi_dh_notifier
>  };
> diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
> index 5d05ac0..8032e51 100644
> --- a/include/scsi/scsi_dh.h
> +++ b/include/scsi/scsi_dh.h
> @@ -59,3 +59,5 @@ enum {
> 
>  extern int scsi_dh_activate(struct request_queue *);
>  extern int scsi_dh_handler_exist(const char *);
> +extern int scsi_dh_attach(struct request_queue *, const char *);
> +extern void scsi_dh_detach(struct request_queue *q);

