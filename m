From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 7/7] scsi_dh: attach to hardware handler from dm-mpath
Date: Wed, 14 May 2008 19:50:01 -0700
Message-ID: <1210819801.21974.266.camel@chandra-ubuntu>
References: <20080514144338.714F910B5DF@craiglockhart-ipmi.suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:57787 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbYEOCsU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 May 2008 22:48:20 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4F2mJiE003332
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2008 22:48:19 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4F2mJ05080598
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2008 20:48:19 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4F2mJ5I016882
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2008 20:48:19 -0600
In-Reply-To: <20080514144338.714F910B5DF@craiglockhart-ipmi.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, dm-devel <dm-devel@redhat.com>

What is the purpose of this feature ?

With dh_state functionality, one could associate a handler to a new
device and then if one does "multipath", the hardware handler would be
associated with the multipath device. What are we achieving by this ?

The review comments below are on the assumption that this is a needed
feature.
---

Shouldn't we provide a detach also ?

On Wed, 2008-05-14 at 16:43 +0200, Hannes Reinecke wrote:
> multipath keeps a separate device table which may be
> more current than the built-in one.
> So we should allow to override the multipath settings
> by calling ->attach for each device.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-mpath.c                 |   10 ++++++
>  drivers/scsi/device_handler/scsi_dh.c |   52 ++++++++++++++++++++++++++++++--
>  include/scsi/scsi_dh.h                |    1 +
>  3 files changed, 59 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index e8f704a..b69cd87 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -546,6 +546,7 @@ static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
>  {
>  	int r;
>  	struct pgpath *p;
> +	struct multipath *m = (struct multipath *) ti->private;
> 
>  	/* we need at least a path arg */
>  	if (as->argc < 1) {
> @@ -564,6 +565,15 @@ static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
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
> index 2dbf84b..dfca3db 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -113,8 +113,12 @@ int scsi_dh_handler_attach(struct scsi_device *sdev,
>  {
>  	int err = -EBUSY;
> 
> -	if (sdev->scsi_dh_data)
> -		return err;
> +	if (sdev->scsi_dh_data) {
> +		if (sdev->scsi_dh_data->scsi_dh != scsi_dh)
> +			return err;
> +		else
> +			return 0;
> +	}

This need to be moved to an earlier patch.
> 
>  	err = scsi_dh->attach(sdev);
> 
> @@ -163,8 +167,11 @@ static int scsi_dh_notifier(struct notifier_block *nb,
>  		goto out;
> 
>  	if (action == BUS_NOTIFY_ADD_DEVICE) {
> -		scsi_dh_handler_attach(sdev, devinfo->handler);
> -		device_create_file(dev, &scsi_dh_state_attr);
> +		int err;
> +
> +		err = scsi_dh_handler_attach(sdev, devinfo->handler);
> +		if (!err)
> +			err = device_create_file(dev, &scsi_dh_state_attr);

This too.

>  	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
>  		if (sdev->scsi_dh_data == NULL)
>  			goto out;
> @@ -345,6 +352,43 @@ int scsi_dh_handler_exist(const char *name)
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

This code seems to do incorrect things (run the case with sdev == NULL
or sdev->scsi_dh_data->scsi_dh != scsi_dh).

This function can be simplified to just call scsi_dh_handler_attach()
after getting scsi_dh and a get_device.

We can avoid calling scsi_dh->attach directly. instead call
scsi_dh_device_handler(), which would do all the necessary checking.

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
> +	if (sdev && sdev->scsi_dh_data) {
> +		if (sdev->scsi_dh_data->scsi_dh != scsi_dh) {
> +			err = -EBUSY;
> +		} else {
> +			spin_unlock_irqrestore(q->queue_lock, flags);
> +			return 0;
> +		}
> +	}
> +	if (!err || !get_device(&sdev->sdev_gendev))
> +		err = -ENODEV;
> +	spin_unlock_irqrestore(q->queue_lock, flags);
> +
> +	if (scsi_dh->attach)
> +		err = scsi_dh->attach(sdev);
> +	put_device(&sdev->sdev_gendev);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(scsi_dh_attach);
> +
>  static struct notifier_block scsi_dh_nb = {
>  	.notifier_call = scsi_dh_notifier
>  };
> diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
> index 5d05ac0..567bd38 100644
> --- a/include/scsi/scsi_dh.h
> +++ b/include/scsi/scsi_dh.h
> @@ -59,3 +59,4 @@ enum {
> 
>  extern int scsi_dh_activate(struct request_queue *);
>  extern int scsi_dh_handler_exist(const char *);
> +extern int scsi_dh_attach(struct request_queue *, const char *);

