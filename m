From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 19/23] scsi_dh_alua: Use workqueue for RTPG
Date: Tue, 22 Sep 2015 15:49:43 -0400
Message-ID: <1442951383.4132.65.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-20-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758363AbbIVTtp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 15:49:45 -0400
In-Reply-To: <1440679281-13234-20-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
> The current ALUA device_handler has two drawbacks:
> - We're sending a 'SET TARGET PORT GROUP' command to every LUN,
>   disregarding the fact that several LUNs might be in a port group
>   and will be automatically switched whenever _any_ LUN within
>   that port group receives the command.
> - Whenever a LUN is in 'transitioning' mode we cannot block I/O
>   to that LUN, instead the controller has to abort the command.
>   This leads to increased traffic across the wire and heavy load
>   on the controller during switchover.

I'm not sure I understand what this means - why couldn't we block I/O?
and what does 'heavy load' mean?  Aborting commands is 'heavy load'?

> 
> With this patch the RTPG handling is moved to a per-portgroup
> workqueue. This reduces the number of 'REPORT TARGET PORT GROUP'
> and 'SET TARGET PORT GROUPS' sent to the controller as we're sending
> them now per port group, and not per device as previously.
> It also allows us to block I/O to any LUN / port group found to be
> in 'transitioning' ALUA mode, as the workqueue item will be requeued
> until the controller moves out of transitioning.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 414 ++++++++++++++++++++++++-----
>  1 file changed, 349 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index b52db8b..85fd597 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -22,6 +22,8 @@
>  #include <linux/slab.h>
>  #include <linux/delay.h>
>  #include <linux/module.h>
> +#include <linux/workqueue.h>
> +#include <linux/rcupdate.h>
>  #include <asm/unaligned.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_dbg.h>
> @@ -59,10 +61,15 @@
>  #define ALUA_RTPG_SIZE			128
>  #define ALUA_FAILOVER_TIMEOUT		60
>  #define ALUA_FAILOVER_RETRIES		5
> +#define ALUA_RTPG_DELAY_MSECS		5
>  
>  /* device handler flags */
> -#define ALUA_OPTIMIZE_STPG		1
> -#define ALUA_RTPG_EXT_HDR_UNSUPP	2
> +#define ALUA_OPTIMIZE_STPG		0x01
> +#define ALUA_RTPG_EXT_HDR_UNSUPP	0x02
> +/* State machine flags */
> +#define ALUA_PG_RUN_RTPG		0x10
> +#define ALUA_PG_RUN_STPG		0x20
> +
>  
>  static LIST_HEAD(port_group_list);
>  static DEFINE_SPINLOCK(port_group_lock);
> @@ -78,13 +85,28 @@ struct alua_port_group {
>  	int			pref;
>  	unsigned		flags; /* used for optimizing STPG */
>  	unsigned char		transition_tmo;
> +	unsigned long		expiry;
> +	unsigned long		interval;
> +	struct workqueue_struct *work_q;
> +	struct delayed_work	rtpg_work;
> +	struct delayed_work	stpg_work;
> +	struct delayed_work	qdata_work;
> +	spinlock_t		rtpg_lock;
> +	struct list_head	rtpg_list;
> +	struct scsi_device	*rtpg_sdev;
>  };
>  
>  struct alua_dh_data {
>  	struct alua_port_group	*pg;
> +	spinlock_t		pg_lock;
>  	int			rel_port;
>  	int			tpgs;
> -	struct scsi_device	*sdev;
> +	int			init_error;
> +	struct mutex		init_mutex;
> +};
> +
> +struct alua_queue_data {
> +	struct list_head	entry;
>  	activate_complete	callback_fn;
>  	void			*callback_data;
>  };
> @@ -93,6 +115,10 @@ struct alua_dh_data {
>  #define ALUA_POLICY_SWITCH_ALL		1
>  
>  static char print_alua_state(int);
> +static void alua_rtpg_work(struct work_struct *work);
> +static void alua_stpg_work(struct work_struct *work);
> +static void alua_qdata_work(struct work_struct *work);
> +static void alua_check(struct scsi_device *sdev);
>  
>  static void release_port_group(struct kref *kref)
>  {
> @@ -103,6 +129,9 @@ static void release_port_group(struct kref *kref)
>  	spin_lock(&port_group_lock);
>  	list_del(&pg->node);
>  	spin_unlock(&port_group_lock);
> +	WARN_ON(pg->rtpg_sdev);
> +	if (pg->work_q)
> +		destroy_workqueue(pg->work_q);
>  	kfree(pg);
>  }
>  
> @@ -296,13 +325,17 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
>  		if (strncmp(tmp_pg->device_id_str, device_id_str,
>  			    device_id_size))
>  			continue;
> -		h->pg = tmp_pg;
>  		kref_get(&tmp_pg->kref);
> +		spin_lock(&h->pg_lock);
> +		rcu_assign_pointer(h->pg, tmp_pg);
> +		spin_unlock(&h->pg_lock);
>  		break;
>  	}
>  	spin_unlock(&port_group_lock);
> -	if (h->pg)
> +	if (h->pg) {
> +		synchronize_rcu();
>  		return SCSI_DH_OK;
> +	}
>  
>  	pg = kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
>  	if (!pg) {
> @@ -322,6 +355,19 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
>  	pg->tpgs = h->tpgs;
>  	pg->state = TPGS_STATE_OPTIMIZED;
>  	kref_init(&pg->kref);
> +	INIT_DELAYED_WORK(&pg->rtpg_work, alua_rtpg_work);
> +	INIT_DELAYED_WORK(&pg->stpg_work, alua_stpg_work);
> +	INIT_DELAYED_WORK(&pg->qdata_work, alua_qdata_work);
> +	INIT_LIST_HEAD(&pg->rtpg_list);
> +	INIT_LIST_HEAD(&pg->node);
> +	spin_lock_init(&pg->rtpg_lock);
> +	pg->work_q = alloc_ordered_workqueue("alua_wp_%s_%d", WQ_MEM_RECLAIM,
> +					     pg->device_id_str, pg->group_id);
> +	if (!pg->work_q) {
> +		kref_put(&pg->kref, release_port_group);
> +		/* Temporary failure, bypass */
> +		return SCSI_DH_DEV_TEMP_BUSY;
> +	}
>  	spin_lock(&port_group_lock);
>  	/*
>  	 * Re-check list again to catch
> @@ -335,15 +381,19 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
>  		if (strncmp(tmp_pg->device_id_str, pg->device_id_str,
>  			    device_id_size))
>  			continue;
> -		h->pg = tmp_pg;
>  		kref_get(&tmp_pg->kref);
> +		spin_lock(&h->pg_lock);
> +		rcu_assign_pointer(h->pg, tmp_pg);
> +		spin_unlock(&h->pg_lock);
>  		kfree(pg);
>  		pg = NULL;
>  		break;
>  	}
>  	if (pg) {
>  		list_add(&pg->node, &port_group_list);
> -		h->pg = pg;
> +		spin_lock(&h->pg_lock);
> +		rcu_assign_pointer(h->pg, pg);
> +		spin_unlock(&h->pg_lock);
>  	}
>  	spin_unlock(&port_group_lock);
>  
> @@ -377,11 +427,14 @@ static int alua_check_sense(struct scsi_device *sdev,
>  {
>  	switch (sense_hdr->sense_key) {
>  	case NOT_READY:
> -		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a)
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
>  			/*
>  			 * LUN Not Accessible - ALUA state transition
> +			 * Kickoff worker to update internal state.
>  			 */
> +			alua_check(sdev);
>  			return ADD_TO_MLQUEUE;
> +		}
>  		break;
>  	case UNIT_ATTENTION:
>  		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
> @@ -429,14 +482,15 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  	int len, k, off, valid_states = 0, bufflen = ALUA_RTPG_SIZE;
>  	unsigned char *ucp, *buff;
>  	unsigned err, retval;
> -	unsigned long expiry, interval = 0;
>  	unsigned int tpg_desc_tbl_off;
>  	unsigned char orig_transition_tmo;
>  
> -	if (!pg->transition_tmo)
> -		expiry = round_jiffies_up(jiffies + ALUA_FAILOVER_TIMEOUT * HZ);
> -	else
> -		expiry = round_jiffies_up(jiffies + pg->transition_tmo * HZ);
> +	if (!pg->expiry) {
> +		if (!pg->transition_tmo)
> +			pg->expiry = round_jiffies_up(jiffies + ALUA_FAILOVER_TIMEOUT * HZ);
> +		else
> +			pg->expiry = round_jiffies_up(jiffies + pg->transition_tmo * HZ);
> +	}
>  
>  	buff = kzalloc(bufflen, GFP_KERNEL);
>  	if (!buff)
> @@ -455,6 +509,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  			else
>  				err = SCSI_DH_IO;
>  			kfree(buff);
> +			pg->expiry = 0;
>  			return err;
>  		}
>  
> @@ -481,16 +536,18 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  			err = SCSI_DH_RETRY;
>  		else if (sense_hdr.sense_key == UNIT_ATTENTION)
>  			err = SCSI_DH_RETRY;
> -		if (err == SCSI_DH_RETRY && time_before(jiffies, expiry)) {
> +		if (err == SCSI_DH_RETRY &&
> +		    pg->expiry != 0 && time_before(jiffies, pg->expiry)) {
>  			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
>  				    ALUA_DH_NAME);
>  			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
> -			goto retry;
> +			return err;
>  		}
>  		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
>  			    ALUA_DH_NAME);
>  		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
>  		kfree(buff);
> +		pg->expiry = 0;
>  		return SCSI_DH_IO;
>  	}
>  
> @@ -505,6 +562,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  			sdev_printk(KERN_WARNING, sdev,
>  				    "%s: kmalloc buffer failed\n",__func__);
>  			/* Temporary failure, bypass */
> +			pg->expiry = 0;
>  			return SCSI_DH_DEV_TEMP_BUSY;
>  		}
>  		goto retry;
> @@ -520,7 +578,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  		sdev_printk(KERN_INFO, sdev,
>  			    "%s: transition timeout set to %d seconds\n",
>  			    ALUA_DH_NAME, pg->transition_tmo);
> -		expiry = jiffies + pg->transition_tmo * HZ;
> +		pg->expiry = jiffies + pg->transition_tmo * HZ;
>  	}
>  
>  	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
> @@ -554,23 +612,26 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  
>  	switch (pg->state) {
>  	case TPGS_STATE_TRANSITIONING:
> -		if (time_before(jiffies, expiry)) {
> +		if (time_before(jiffies, pg->expiry)) {
>  			/* State transition, retry */
> -			interval += 2000;
> -			msleep(interval);
> -			goto retry;
> +			pg->interval = 2;
> +			err = SCSI_DH_RETRY;
> +		} else {
> +			/* Transitioning time exceeded, set port to standby */
> +			err = SCSI_DH_IO;
> +			pg->state = TPGS_STATE_STANDBY;
> +			pg->expiry = 0;
>  		}
> -		/* Transitioning time exceeded, set port to standby */
> -		err = SCSI_DH_RETRY;
> -		pg->state = TPGS_STATE_STANDBY;
>  		break;
>  	case TPGS_STATE_OFFLINE:
>  		/* Path unusable */
>  		err = SCSI_DH_DEV_OFFLINED;
> +		pg->expiry = 0;
>  		break;
>  	default:
>  		/* Useable path if active */
>  		err = SCSI_DH_OK;
> +		pg->expiry = 0;
>  		break;
>  	}
>  	kfree(buff);
> @@ -590,8 +651,8 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  	struct scsi_sense_hdr sense_hdr;
>  
>  	if (!(pg->tpgs & TPGS_MODE_EXPLICIT)) {
> -		/* Only implicit ALUA supported, retry */
> -		return SCSI_DH_RETRY;
> +		/* Only implicit ALUA supported */
> +		return SCSI_DH_OK;
>  	}
>  	switch (pg->state) {
>  	case TPGS_STATE_OPTIMIZED:
> @@ -617,8 +678,6 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  		return SCSI_DH_NOSYS;
>  		break;
>  	}
> -	/* Set state to transitioning */
> -	pg->state = TPGS_STATE_TRANSITIONING;
>  	retval = submit_stpg(sdev, pg->group_id, &sense_hdr);
>  
>  	if (retval) {
> @@ -638,6 +697,150 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  	return SCSI_DH_RETRY;
>  }
>  
> +static void alua_rtpg_work(struct work_struct *work)
> +{
> +	struct alua_port_group *pg =
> +		container_of(work, struct alua_port_group, rtpg_work.work);
> +	struct scsi_device *sdev;
> +	int err = SCSI_DH_OK;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pg->rtpg_lock, flags);
> +	sdev = pg->rtpg_sdev;
> +	if (!sdev) {
> +		WARN_ON(pg->flags & ALUA_PG_RUN_RTPG ||
> +			pg->flags & ALUA_PG_RUN_STPG);
> +		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
> +		return;
> +	}
> +	if (pg->flags & ALUA_PG_RUN_RTPG) {
> +		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
> +		err = alua_rtpg(sdev, pg);
> +		if (err == SCSI_DH_RETRY) {
> +			queue_delayed_work(pg->work_q, &pg->rtpg_work,
> +					   pg->interval * HZ);
> +			return;
> +		}
> +		spin_lock_irqsave(&pg->rtpg_lock, flags);
> +		pg->flags &= ~ALUA_PG_RUN_RTPG;
> +		if (err != SCSI_DH_OK)
> +			pg->flags &= ~ALUA_PG_RUN_STPG;
> +	}
> +	if (pg->flags & ALUA_PG_RUN_STPG) {
> +		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
> +		queue_delayed_work(pg->work_q, &pg->stpg_work, 0);
> +		return;
> +	}
> +	spin_unlock_irqrestore(&pg->rtpg_lock, flags);
> +	queue_delayed_work(pg->work_q, &pg->qdata_work, 0);
> +}
> +
> +static void alua_stpg_work(struct work_struct *work)
> +{
> +	struct alua_port_group *pg =
> +		container_of(work, struct alua_port_group, stpg_work.work);
> +	struct scsi_device *sdev;
> +	int err = SCSI_DH_OK;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pg->rtpg_lock, flags);
> +	sdev = pg->rtpg_sdev;
> +	if (!sdev) {
> +		WARN_ON(pg->flags & ALUA_PG_RUN_STPG);
> +		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
> +		return;
> +	}
> +
> +	if (pg->flags & ALUA_PG_RUN_STPG) {
> +		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
> +		err = alua_stpg(sdev, pg);
> +		spin_lock_irqsave(&pg->rtpg_lock, flags);
> +		pg->flags &= ~ALUA_PG_RUN_STPG;
> +		if (err == SCSI_DH_RETRY) {
> +			pg->flags |= ALUA_PG_RUN_RTPG;
> +			pg->interval = 0;
> +		}
> +	}
> +	if (pg->flags & ALUA_PG_RUN_RTPG) {
> +		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
> +		queue_delayed_work(pg->work_q, &pg->rtpg_work,
> +				   msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));
> +		return;
> +	}
> +
> +	spin_unlock_irqrestore(&pg->rtpg_lock, flags);
> +	queue_delayed_work(pg->work_q, &pg->qdata_work, 0);
> +}
> +
> +static void alua_qdata_work(struct work_struct *work)
> +{
> +	struct alua_port_group *pg =
> +		container_of(work, struct alua_port_group, qdata_work.work);
> +	struct scsi_device *sdev;
> +	LIST_HEAD(qdata_list);
> +	int err = SCSI_DH_OK;
> +	struct alua_queue_data *qdata, *tmp;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pg->rtpg_lock, flags);
> +	sdev = pg->rtpg_sdev;
> +	if (WARN_ON(!sdev)) {
> +		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
> +		return;
> +	}
> +	if (pg->flags & ALUA_PG_RUN_RTPG) {
> +		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
> +		queue_delayed_work(pg->work_q, &pg->rtpg_work,
> +				   msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));
> +		return;
> +	}
> +
> +	list_splice_init(&pg->rtpg_list, &qdata_list);
> +	pg->rtpg_sdev = NULL;
> +	spin_unlock_irqrestore(&pg->rtpg_lock, flags);
> +
> +	list_for_each_entry_safe(qdata, tmp, &qdata_list, entry) {
> +		list_del(&qdata->entry);
> +		if (qdata->callback_fn)
> +			qdata->callback_fn(qdata->callback_data, err);
> +		kfree(qdata);
> +	}
> +	kref_put(&pg->kref, release_port_group);
> +	scsi_device_put(sdev);
> +}
> +
> +static void alua_rtpg_queue(struct alua_port_group *pg,
> +			    struct scsi_device *sdev,
> +			    struct alua_queue_data *qdata)
> +{
> +	int start_queue = 0;
> +	unsigned long flags;
> +
> +	if (!pg)
> +		return;
> +
> +	kref_get(&pg->kref);
> +	spin_lock_irqsave(&pg->rtpg_lock, flags);
> +	if (qdata) {
> +		list_add_tail(&qdata->entry, &pg->rtpg_list);
> +		pg->flags |= ALUA_PG_RUN_STPG;
> +	}
> +	if (pg->rtpg_sdev == NULL) {
> +		pg->interval = 0;
> +		pg->flags |= ALUA_PG_RUN_RTPG;
> +		kref_get(&pg->kref);
> +		pg->rtpg_sdev = sdev;
> +		scsi_device_get(sdev);
> +		start_queue = 1;
> +	}
> +	spin_unlock_irqrestore(&pg->rtpg_lock, flags);
> +
> +	if (start_queue)
> +		queue_delayed_work(pg->work_q, &pg->rtpg_work,
> +				   msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));
> +	kref_put(&pg->kref, release_port_group);
> +}
> +
>  /*
>   * alua_initialize - Initialize ALUA state
>   * @sdev: the device to be initialized
> @@ -647,22 +850,35 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
>   */
>  static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
>  {
> -	int err;
> -
> -	err = alua_check_tpgs(sdev, h);
> -	if (err != SCSI_DH_OK)
> -		goto out;
> -
> -	err = alua_check_vpd(sdev, h);
> -	if (err != SCSI_DH_OK || !h->pg)
> -		goto out;
> -
> -	kref_get(&h->pg->kref);
> -	err = alua_rtpg(sdev, h->pg);
> -	kref_put(&h->pg->kref, release_port_group);
> -out:
> -	return err;
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
> +	h->init_error = error;
> +	mutex_unlock(&h->init_mutex);
> +	if (pg) {
> +		pg->expiry = 0;
> +		alua_rtpg_queue(pg, sdev, NULL);
> +		kref_put(&pg->kref, release_port_group);
> +	}
> +	return error;
>  }
> +
>  /*
>   * alua_set_params - set/unset the optimize flag
>   * @sdev: device on the path to be activated
> @@ -679,6 +895,10 @@ static int alua_set_params(struct scsi_device *sdev, const char *params)
>  	unsigned int optimize = 0, argc;
>  	const char *p = params;
>  	int result = SCSI_DH_OK;
> +	unsigned long flags;
> +
> +	if (!h)
> +		return -ENXIO;
>  
>  	if ((sscanf(params, "%u", &argc) != 1) || (argc != 1))
>  		return -EINVAL;
> @@ -694,11 +914,12 @@ static int alua_set_params(struct scsi_device *sdev, const char *params)
>  		rcu_read_unlock();
>  		return -ENXIO;
>  	}
> -
> +	spin_lock_irqsave(&pg->rtpg_lock, flags);
>  	if (optimize)
>  		pg->flags |= ALUA_OPTIMIZE_STPG;
>  	else
>  		pg->flags |= ~ALUA_OPTIMIZE_STPG;
> +	spin_unlock_irqrestore(&pg->rtpg_lock, flags);
>  	rcu_read_unlock();
>  
>  	return result;
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
>  
> -	kref_get(&h->pg->kref);
> -
> -	if (optimize_stpg)
> -		h->pg->flags |= ALUA_OPTIMIZE_STPG;
> +	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
> +	if (!qdata) {
> +		err = SCSI_DH_RES_TEMP_UNAVAIL;
> +		goto out;
> +	}
> +	qdata->callback_fn = fn;
> +	qdata->callback_data = data;
>  
> -	err = alua_rtpg(sdev, h->pg);
> -	if (err != SCSI_DH_OK) {
> -		kref_put(&h->pg->kref, release_port_group);
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
> -	err = alua_stpg(sdev, h->pg);
> -	if (err == SCSI_DH_RETRY)
> -		err = alua_rtpg(sdev, h->pg);
> -	kref_put(&h->pg->kref, release_port_group);
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
> +	alua_rtpg_queue(pg, sdev, qdata);
> +	kref_put(&pg->kref, release_port_group);
>  out:
>  	if (fn)
>  		fn(data, err);
> @@ -748,6 +991,30 @@ out:
>  }
>  
>  /*
> + * alua_check - check path status
> + * @sdev: device on the path to be checked
> + *
> + * Check the device status
> + */
> +static void alua_check(struct scsi_device *sdev)
> +{
> +	struct alua_dh_data *h = sdev->handler_data;
> +	struct alua_port_group *pg;
> +
> +	rcu_read_lock();
> +	pg = rcu_dereference(h->pg);
> +	if (!pg) {
> +		rcu_read_unlock();
> +		return;
> +	}
> +	kref_get(&pg->kref);
> +	rcu_read_unlock();
> +	alua_rtpg_queue(pg, sdev, NULL);
> +	kref_put(&pg->kref, release_port_group);
> +	rcu_read_unlock();
> +}
> +
> +/*
>   * alua_prep_fn - request callback
>   *
>   * Fail I/O to all paths not in state
> @@ -756,14 +1023,22 @@ out:
>  static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
>  {
>  	struct alua_dh_data *h = sdev->handler_data;
> -	int state;
> +	struct alua_port_group *pg;
> +	int state = TPGS_STATE_OPTIMIZED;
>  	int ret = BLKPREP_OK;
>  
> -	if (!h->pg)
> +	if (!h)
>  		return ret;
> -	kref_get(&h->pg->kref);
> -	state = h->pg->state;
> -	kref_put(&h->pg->kref, release_port_group);
> +
> +	rcu_read_lock();
> +	pg = rcu_dereference(h->pg);
> +	if (pg) {
> +		state = pg->state;
> +		/* Defer I/O while rtpg_work is active */
> +		if (pg->rtpg_sdev)
> +			state = TPGS_STATE_TRANSITIONING;
> +	}
> +	rcu_read_unlock();
>  	if (state == TPGS_STATE_TRANSITIONING)
>  		ret = BLKPREP_DEFER;
>  	else if (state != TPGS_STATE_OPTIMIZED &&
> @@ -788,11 +1063,13 @@ static int alua_bus_attach(struct scsi_device *sdev)
>  	h = kzalloc(sizeof(*h) , GFP_KERNEL);
>  	if (!h)
>  		return -ENOMEM;
> +	spin_lock_init(&h->pg_lock);
>  	h->tpgs = TPGS_MODE_UNINITIALIZED;
> -	h->pg = NULL;
> +	rcu_assign_pointer(h->pg, NULL);
>  	h->rel_port = -1;
> -	h->sdev = sdev;
> +	h->init_error = SCSI_DH_OK;
>  
> +	mutex_init(&h->init_mutex);
>  	err = alua_initialize(sdev, h);
>  	if (err != SCSI_DH_OK && err != SCSI_DH_DEV_OFFLINED)
>  		goto failed;
> @@ -811,10 +1088,17 @@ failed:
>  static void alua_bus_detach(struct scsi_device *sdev)
>  {
>  	struct alua_dh_data *h = sdev->handler_data;
> +	struct alua_port_group *pg;
>  
> -	if (h->pg) {
> -		kref_put(&h->pg->kref, release_port_group);
> -		h->pg = NULL;
> +	spin_lock(&h->pg_lock);
> +	pg = h->pg;
> +	rcu_assign_pointer(h->pg, NULL);
> +	spin_unlock(&h->pg_lock);
> +	synchronize_rcu();
> +	if (pg) {
> +		if (pg->rtpg_sdev)
> +			flush_workqueue(pg->work_q);
> +		kref_put(&pg->kref, release_port_group);
>  	}
>  	sdev->handler_data = NULL;
>  	kfree(h);

So, you've already had a bit of discussion with Christoph about this,
the main portion of your ALUA rewrite, and I won't go over all of that,
except to say that I'd have to agree that having separate work queues
for the different RTPG/STPG functions and having them manipulate each
other's flags seems like we'd be better off having just one work
function that did everything.  Less messy and easier to maintain.

Also, it seems like wrong ordering of kref_get() vs. scsi_device_get(),
in alua_rtpg_queue() since they are released as kref_put() then
scsi_device_put()?

Reviewed-by: Ewan D. Milne <emilne@redhat.com>






