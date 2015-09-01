From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 19/23] scsi_dh_alua: Use workqueue for RTPG
Date: Tue, 1 Sep 2015 13:15:17 +0200
Message-ID: <20150901111517.GB10589@lst.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de> <1440679281-13234-20-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34835 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbbIALPU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 07:15:20 -0400
Content-Disposition: inline
In-Reply-To: <1440679281-13234-20-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

> +	unsigned long		expiry;
> +	unsigned long		interval;
> +	struct workqueue_struct *work_q;
> +	struct delayed_work	rtpg_work;
> +	struct delayed_work	stpg_work;
> +	struct delayed_work	qdata_work;
> +	spinlock_t		rtpg_lock;

This one also protects ->flag.  I'd just call it lock, and
introduce it at the time struct alua_port_group is introduced,
so that we can have coherent locking from the very beginning.

> +struct alua_queue_data {
> +	struct list_head	entry;
>  	activate_complete	callback_fn;
>  	void			*callback_data;

I've been looking over the active callback for a while, and I
think the model of it is fundamentally broken.  Yes, as long as
multipathing isn't in SCSI we'll need path change notifications
for dm-mpath, but I don't see how tying them into ->activate
makes any sense.

I guess for this series we're stuck with it, but in the long
run we should have a callback in the request_queue which the
consumer that has bd_claim()ed the device can set and get path
change notifications instead.

That being said after spending a lot of time reading this code I think
my orginal advice to use different work_structs for the different
kinds of events was wrong, and I'd like to apologize for making you
go down that direction.

STPG/RTPG is just too dependent to sensibly split them up, and the
qdata bit while broken can be shoe horned in for now.  So I'd suggest
to revert back to the original model with a single work_struct per
port group, and a global workqueue.

> -	if (h->pg)
> +	if (h->pg) {
> +		synchronize_rcu();
>  		return SCSI_DH_OK;
> +	}

What is this synchronize_rcu supposed to help with?

> -		h->pg = tmp_pg;
>  		kref_get(&tmp_pg->kref);
> +		spin_lock(&h->pg_lock);
> +		rcu_assign_pointer(h->pg, tmp_pg);
> +		spin_unlock(&h->pg_lock);

I think the assignment to h->ph should have been past the kref_get
from the very beginning, please fold this into the original patch.

> +	struct alua_port_group *pg = NULL;
> +	int error;
> +
> +	mutex_lock(&h->init_mutex);
> +	error = alua_check_tpgs(sdev, h);
> +	if (error == SCSI_DH_OK) {
> +		error = alua_check_vpd(sdev, h);
> +		rcu_read_lock();
> +		pg = rcu_dereference(h->pg);
> +		if (!pg) {
> +			rcu_read_unlock();
> +			h->tpgs = TPGS_MODE_NONE;
> +			error = SCSI_DH_DEV_UNSUPP;
> +		} else {
> +			WARN_ON(error != SCSI_DH_OK);
> +			kref_get(&pg->kref);
> +			rcu_read_unlock();
> +		}
> +	}

Eww. Please grab the reference to the pg inside the replacement for
alua_check_vpd, and ensure that we never return from that without a
valid h->pg.  Together with the previously suggested removal of h->tpgs,
and moving the call to alua_rtpg_queue into the alua_check_vpd replacement
that would keep alua_initialize nice and simple.

> @@ -679,6 +895,10 @@ static int alua_set_params(struct scsi_device *sdev, const char *params)
>  	unsigned int optimize = 0, argc;
>  	const char *p = params;
>  	int result = SCSI_DH_OK;
> +	unsigned long flags;
> +
> +	if (!h)
> +		return -ENXIO;

How could that happen?  Why does it beling into this patch?

> @@ -723,24 +944,46 @@ static int alua_activate(struct scsi_device *sdev,
>  {
>  	struct alua_dh_data *h = sdev->handler_data;
>  	int err = SCSI_DH_OK;
> +	struct alua_queue_data *qdata;
> +	struct alua_port_group *pg;
>  
> -	if (!h->pg)
> +	if (!h) {
> +		err = SCSI_DH_NOSYS;
>  		goto out;
> +	}

Same here.

> +	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
> +	if (!qdata) {
> +		err = SCSI_DH_RES_TEMP_UNAVAIL;
> +		goto out;
> +	}
> +	qdata->callback_fn = fn;
> +	qdata->callback_data = data;
>  
> +	mutex_lock(&h->init_mutex);
> +	rcu_read_lock();
> +	pg = rcu_dereference(h->pg);
> +	if (!pg) {
> +		rcu_read_unlock();
> +		kfree(qdata);
> +		err = h->init_error;
> +		mutex_unlock(&h->init_mutex);
>  		goto out;
>  	}
> +	mutex_unlock(&h->init_mutex);
> +	fn = NULL;
> +	kref_get(&pg->kref);
> +	rcu_read_unlock();
> +
> +	if (optimize_stpg) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&pg->rtpg_lock, flags);
> +		pg->flags |= ALUA_OPTIMIZE_STPG;
> +		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
> +	}

The optimize_stpg should have been moved towards the alua_port_group
allocation earlier in the series, please fold that in there.

> +	alua_rtpg_queue(pg, sdev, qdata);
> +	kref_put(&pg->kref, release_port_group);

Note that all alua_rtpg_queue callers already have a reference to the
PG, so I don't think we need to grab another one inside it or even
check for a NULL pg.
