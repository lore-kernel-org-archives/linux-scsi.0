From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/20] scsi_dh_alua: Recheck state on unit attention
Date: Wed, 30 Dec 2015 14:22:58 +0100
Message-ID: <20151230132258.GC15270@lst.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de> <1449560260-53407-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49477 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738AbbL3NXA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Dec 2015 08:23:00 -0500
Content-Disposition: inline
In-Reply-To: <1449560260-53407-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Tue, Dec 08, 2015 at 08:37:33AM +0100, Hannes Reinecke wrote:
> When we receive a unit attention code of 'ALUA state changed'
> we should recheck the state, as it might be due to an implicit
> ALUA state transition. This allows us to return NEEDS_RETRY
> instead of ADD_TO_MLQUEUE, allowing to terminate the retries
> after a certain time.
> At the same time a workqueue item might already be queued, which
> should be started immediately to avoid any delays.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 58 ++++++++++++++++++++++++------
>  1 file changed, 47 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 525449f..04a3a543 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -121,7 +121,8 @@ struct alua_queue_data {
>  static void alua_rtpg_work(struct work_struct *work);
>  static void alua_rtpg_queue(struct alua_port_group *pg,
>  			    struct scsi_device *sdev,
> -			    struct alua_queue_data *qdata);
> +			    struct alua_queue_data *qdata, bool force);
> +static void alua_check(struct scsi_device *sdev, bool force);
>  
>  static void release_port_group(struct kref *kref)
>  {
> @@ -386,7 +387,7 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
>  		rcu_assign_pointer(h->pg, pg);
>  		pg_found = true;
>  	}
> -	alua_rtpg_queue(h->pg, sdev, NULL);
> +	alua_rtpg_queue(h->pg, sdev, NULL, true);
>  	spin_unlock(&h->pg_lock);
>  
>  	if (pg_found)
> @@ -427,18 +428,24 @@ static int alua_check_sense(struct scsi_device *sdev,
>  {
>  	switch (sense_hdr->sense_key) {
>  	case NOT_READY:
> -		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a)
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
>  			/*
>  			 * LUN Not Accessible - ALUA state transition
>  			 */
> -			return ADD_TO_MLQUEUE;
> +			alua_check(sdev, false);
> +			return NEEDS_RETRY;
> +		}
>  		break;
>  	case UNIT_ATTENTION:
> -		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
> +		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
>  			/*
> -			 * Power On, Reset, or Bus Device Reset, just retry.
> +			 * Power On, Reset, or Bus Device Reset.
> +			 * Might have obscured a state transition,
> +			 * so schedule a recheck.
>  			 */
> +			alua_check(sdev, true);
>  			return ADD_TO_MLQUEUE;
> +		}
>  		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x04)
>  			/*
>  			 * Device internal reset
> @@ -449,16 +456,20 @@ static int alua_check_sense(struct scsi_device *sdev,
>  			 * Mode Parameters Changed
>  			 */
>  			return ADD_TO_MLQUEUE;
> -		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06)
> +		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06) {
>  			/*
>  			 * ALUA state changed
>  			 */
> +			alua_check(sdev, true);
>  			return ADD_TO_MLQUEUE;
> -		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x07)
> +		}
> +		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x07) {
>  			/*
>  			 * Implicit ALUA state transition failed
>  			 */
> +			alua_check(sdev, true);
>  			return ADD_TO_MLQUEUE;
> +		}
>  		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x03)
>  			/*
>  			 * Inquiry data has changed
> @@ -777,7 +788,7 @@ static void alua_rtpg_work(struct work_struct *work)
>  
>  static void alua_rtpg_queue(struct alua_port_group *pg,
>  			    struct scsi_device *sdev,
> -			    struct alua_queue_data *qdata)
> +			    struct alua_queue_data *qdata, bool force)
>  {
>  	int start_queue = 0;
>  	unsigned long flags;
> @@ -797,7 +808,9 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
>  		pg->rtpg_sdev = sdev;
>  		scsi_device_get(sdev);
>  		start_queue = 1;
> -	}
> +	} else if (!(pg->flags & ALUA_PG_RUN_RTPG) && force)
> +		start_queue = 1;
> +
>  	spin_unlock_irqrestore(&pg->lock, flags);
>  
>  	if (start_queue &&
> @@ -912,7 +925,7 @@ static int alua_activate(struct scsi_device *sdev,
>  	kref_get(&pg->kref);
>  	rcu_read_unlock();
>  
> -	alua_rtpg_queue(pg, sdev, qdata);
> +	alua_rtpg_queue(pg, sdev, qdata, true);
>  	kref_put(&pg->kref, release_port_group);
>  out:
>  	if (fn)
> @@ -921,6 +934,29 @@ out:
>  }
>  
>  /*
> + * alua_check - check path status
> + * @sdev: device on the path to be checked
> + *
> + * Check the device status
> + */
> +static void alua_check(struct scsi_device *sdev, bool force)
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

What protects us from pg->kref beeing released?  I think the whole
refcounting scheme needs an audit to see where kref_get is called
without synchronization and use kref_get_unless_zero where needed.
