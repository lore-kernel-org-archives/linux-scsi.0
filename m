From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 13/23] scsi_dh_alua: Use separate alua_port_group
 structure
Date: Tue, 22 Sep 2015 14:57:38 -0400
Message-ID: <1442948258.4132.28.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-14-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934212AbbIVS5j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 14:57:39 -0400
In-Reply-To: <1440679281-13234-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
> The port group needs to be a separate structure as several
> LUNs might belong to the same group.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 211 +++++++++++++++++++----------
>  1 file changed, 139 insertions(+), 72 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index ef4363a..d1010dd 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -64,9 +64,13 @@
>  #define ALUA_OPTIMIZE_STPG		1
>  #define ALUA_RTPG_EXT_HDR_UNSUPP	2
>  
> -struct alua_dh_data {
> +static LIST_HEAD(port_group_list);
> +static DEFINE_SPINLOCK(port_group_lock);
> +
> +struct alua_port_group {
> +	struct kref		kref;
> +	struct list_head	node;
>  	int			group_id;
> -	int			rel_port;
>  	int			tpgs;
>  	int			state;
>  	int			pref;
> @@ -75,6 +79,12 @@ struct alua_dh_data {
>  	unsigned char		*buff;
>  	int			bufflen;
>  	unsigned char		transition_tmo;
> +};
> +
> +struct alua_dh_data {
> +	struct alua_port_group	*pg;
> +	int			rel_port;
> +	int			tpgs;
>  	struct scsi_device	*sdev;
>  	activate_complete	callback_fn;
>  	void			*callback_data;
> @@ -86,21 +96,35 @@ struct alua_dh_data {
>  static char print_alua_state(int);
>  static int alua_check_sense(struct scsi_device *, struct scsi_sense_hdr *);
>  
> -static int realloc_buffer(struct alua_dh_data *h, unsigned len)
> +static int realloc_buffer(struct alua_port_group *pg, unsigned len)
>  {
> -	if (h->buff && h->buff != h->inq)
> -		kfree(h->buff);
> +	if (pg->buff && pg->buff != pg->inq)
> +		kfree(pg->buff);
>  
> -	h->buff = kmalloc(len, GFP_NOIO);
> -	if (!h->buff) {
> -		h->buff = h->inq;
> -		h->bufflen = ALUA_INQUIRY_SIZE;
> +	pg->buff = kmalloc(len, GFP_NOIO);
> +	if (!pg->buff) {
> +		pg->buff = pg->inq;
> +		pg->bufflen = ALUA_INQUIRY_SIZE;
>  		return 1;
>  	}
> -	h->bufflen = len;
> +	pg->bufflen = len;
>  	return 0;
>  }
>  
> +static void release_port_group(struct kref *kref)
> +{
> +	struct alua_port_group *pg;
> +
> +	pg = container_of(kref, struct alua_port_group, kref);
> +	printk(KERN_WARNING "alua: release port group %d\n", pg->group_id);
> +	spin_lock(&port_group_lock);
> +	list_del(&pg->node);
> +	spin_unlock(&port_group_lock);
> +	if (pg->buff && pg->inq != pg->buff)
> +		kfree(pg->buff);
> +	kfree(pg);
> +}
> +
>  /*
>   * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
>   * @sdev: sdev the command should be sent to
> @@ -225,6 +249,8 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
>  static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
>  {
>  	unsigned char *d;
> +	int group_id = -1;
> +	struct alua_port_group *pg = NULL;
>  
>  	if (!sdev->vpd_pg83)
>  		return SCSI_DH_DEV_UNSUPP;
> @@ -241,7 +267,7 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
>  			break;
>  		case 0x5:
>  			/* Target port group */
> -			h->group_id = get_unaligned_be16(&d[6]);
> +			group_id = get_unaligned_be16(&d[6]);
>  			break;
>  		default:
>  			break;
> @@ -249,7 +275,7 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
>  		d += d[3] + 4;
>  	}
>  
> -	if (h->group_id == -1) {
> +	if (group_id == -1) {
>  		/*
>  		 * Internal error; TPGS supported but required
>  		 * VPD identification descriptors not present.
> @@ -258,15 +284,33 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
>  		sdev_printk(KERN_INFO, sdev,
>  			    "%s: No target port descriptors found\n",
>  			    ALUA_DH_NAME);
> -		h->state = TPGS_STATE_OPTIMIZED;
>  		h->tpgs = TPGS_MODE_NONE;
>  		return SCSI_DH_DEV_UNSUPP;
>  	}
>  	sdev_printk(KERN_INFO, sdev,
>  		    "%s: port group %02x rel port %02x\n",
> -		    ALUA_DH_NAME, h->group_id, h->rel_port);
> +		    ALUA_DH_NAME, group_id, h->rel_port);
>  
> -	return 0;
> +	pg = kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
> +	if (!pg) {
> +		sdev_printk(KERN_WARNING, sdev,
> +			    "%s: kzalloc port group failed\n",
> +			    ALUA_DH_NAME);
> +		/* Temporary failure, bypass */
> +		return SCSI_DH_DEV_TEMP_BUSY;
> +	}
> +	pg->group_id = group_id;
> +	pg->buff = pg->inq;
> +	pg->bufflen = ALUA_INQUIRY_SIZE;
> +	pg->tpgs = h->tpgs;
> +	pg->state = TPGS_STATE_OPTIMIZED;
> +	kref_init(&pg->kref);
> +	spin_lock(&port_group_lock);
> +	list_add(&pg->node, &port_group_list);
> +	h->pg = pg;
> +	spin_unlock(&port_group_lock);
> +
> +	return SCSI_DH_OK;
>  }
>  
>  static char print_alua_state(int state)
> @@ -377,7 +421,7 @@ static int alua_check_sense(struct scsi_device *sdev,
>   * Returns SCSI_DH_DEV_OFFLINED if the path is
>   * found to be unusable.
>   */
> -static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_for_transition)
> +static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int wait_for_transition)
>  {
>  	struct scsi_sense_hdr sense_hdr;
>  	int len, k, off, valid_states = 0;
> @@ -387,13 +431,14 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
>  	unsigned int tpg_desc_tbl_off;
>  	unsigned char orig_transition_tmo;
>  
> -	if (!h->transition_tmo)
> +	if (!pg->transition_tmo)
>  		expiry = round_jiffies_up(jiffies + ALUA_FAILOVER_TIMEOUT * HZ);
>  	else
> -		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
> +		expiry = round_jiffies_up(jiffies + pg->transition_tmo * HZ);
>  
>   retry:
> -	retval = submit_rtpg(sdev, h->buff, h->bufflen, &sense_hdr, h->flags);
> +	retval = submit_rtpg(sdev, pg->buff, pg->bufflen,
> +			     &sense_hdr, pg->flags);
>  
>  	if (retval) {
>  		if (!scsi_sense_valid(&sense_hdr)) {
> @@ -415,10 +460,10 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
>  		 * The retry without rtpg_ext_hdr_req set
>  		 * handles this.
>  		 */
> -		if (!(h->flags & ALUA_RTPG_EXT_HDR_UNSUPP) &&
> +		if (!(pg->flags & ALUA_RTPG_EXT_HDR_UNSUPP) &&
>  		    sense_hdr.sense_key == ILLEGAL_REQUEST &&
>  		    sense_hdr.asc == 0x24 && sense_hdr.ascq == 0) {
> -			h->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
> +			pg->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
>  			goto retry;
>  		}
>  
> @@ -435,11 +480,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
>  		return SCSI_DH_IO;
>  	}
>  
> -	len = get_unaligned_be32(&h->buff[0]) + 4;
> +	len = get_unaligned_be32(&pg->buff[0]) + 4;
>  
> -	if (len > h->bufflen) {
> +	if (len > pg->bufflen) {
>  		/* Resubmit with the correct length */
> -		if (realloc_buffer(h, len)) {
> +		if (realloc_buffer(pg, len)) {
>  			sdev_printk(KERN_WARNING, sdev,
>  				    "%s: kmalloc buffer failed\n",__func__);
>  			/* Temporary failure, bypass */
> @@ -448,31 +493,33 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
>  		goto retry;
>  	}
>  
> -	orig_transition_tmo = h->transition_tmo;
> -	if ((h->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && h->buff[5] != 0)
> -		h->transition_tmo = h->buff[5];
> +	orig_transition_tmo = pg->transition_tmo;
> +	if ((pg->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR &&
> +	    pg->buff[5] != 0)
> +		pg->transition_tmo = pg->buff[5];
>  	else
> -		h->transition_tmo = ALUA_FAILOVER_TIMEOUT;
> +		pg->transition_tmo = ALUA_FAILOVER_TIMEOUT;
>  
> -	if (wait_for_transition && (orig_transition_tmo != h->transition_tmo)) {
> +	if (wait_for_transition &&
> +	    (orig_transition_tmo != pg->transition_tmo)) {
>  		sdev_printk(KERN_INFO, sdev,
>  			    "%s: transition timeout set to %d seconds\n",
> -			    ALUA_DH_NAME, h->transition_tmo);
> -		expiry = jiffies + h->transition_tmo * HZ;
> +			    ALUA_DH_NAME, pg->transition_tmo);
> +		expiry = jiffies + pg->transition_tmo * HZ;
>  	}
>  
> -	if ((h->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
> +	if ((pg->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
>  		tpg_desc_tbl_off = 8;
>  	else
>  		tpg_desc_tbl_off = 4;
>  
> -	for (k = tpg_desc_tbl_off, ucp = h->buff + tpg_desc_tbl_off;
> +	for (k = tpg_desc_tbl_off, ucp = pg->buff + tpg_desc_tbl_off;
>  	     k < len;
>  	     k += off, ucp += off) {
>  
> -		if (h->group_id == get_unaligned_be16(&ucp[2])) {
> -			h->state = ucp[0] & 0x0f;
> -			h->pref = ucp[0] >> 7;
> +		if (pg->group_id == get_unaligned_be16(&ucp[2])) {
> +			pg->state = ucp[0] & 0x0f;
> +			pg->pref = ucp[0] >> 7;
>  			valid_states = ucp[1];
>  		}
>  		off = 8 + (ucp[7] * 4);
> @@ -480,8 +527,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
>  
>  	sdev_printk(KERN_INFO, sdev,
>  		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
> -		    ALUA_DH_NAME, h->group_id, print_alua_state(h->state),
> -		    h->pref ? "preferred" : "non-preferred",
> +		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
> +		    pg->pref ? "preferred" : "non-preferred",
>  		    valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
>  		    valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
>  		    valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
> @@ -490,7 +537,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
>  		    valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
>  		    valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
>  
> -	switch (h->state) {
> +	switch (pg->state) {
>  	case TPGS_STATE_TRANSITIONING:
>  		if (wait_for_transition) {
>  			if (time_before(jiffies, expiry)) {
> @@ -505,7 +552,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
>  		}
>  
>  		/* Transitioning time exceeded, set port to standby */
> -		h->state = TPGS_STATE_STANDBY;
> +		pg->state = TPGS_STATE_STANDBY;
>  		break;
>  	case TPGS_STATE_OFFLINE:
>  		/* Path unusable */
> @@ -526,22 +573,22 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
>   * response. Returns SCSI_DH_RETRY per default to trigger
>   * a re-evaluation of the target group state.
>   */
> -static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
> +static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  {
>  	int retval;
>  	struct scsi_sense_hdr sense_hdr;
>  
> -	if (!(h->tpgs & TPGS_MODE_EXPLICIT)) {
> +	if (!(pg->tpgs & TPGS_MODE_EXPLICIT)) {
>  		/* Only implicit ALUA supported, retry */
>  		return SCSI_DH_RETRY;
>  	}
> -	switch (h->state) {
> +	switch (pg->state) {
>  	case TPGS_STATE_OPTIMIZED:
>  		return SCSI_DH_OK;
>  	case TPGS_STATE_NONOPTIMIZED:
> -		if ((h->flags & ALUA_OPTIMIZE_STPG) &&
> -		    !h->pref &&
> -		    (h->tpgs & TPGS_MODE_IMPLICIT))
> +		if ((pg->flags & ALUA_OPTIMIZE_STPG) &&
> +		    !pg->pref &&
> +		    (pg->tpgs & TPGS_MODE_IMPLICIT))
>  			return SCSI_DH_OK;
>  		break;
>  	case TPGS_STATE_STANDBY:
> @@ -555,13 +602,13 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
>  	default:
>  		sdev_printk(KERN_INFO, sdev,
>  			    "%s: stpg failed, unhandled TPGS state %d",
> -			    ALUA_DH_NAME, h->state);
> +			    ALUA_DH_NAME, pg->state);
>  		return SCSI_DH_NOSYS;
>  		break;
>  	}
>  	/* Set state to transitioning */
> -	h->state = TPGS_STATE_TRANSITIONING;
> -	retval = submit_stpg(sdev, h->group_id, &sense_hdr);
> +	pg->state = TPGS_STATE_TRANSITIONING;
> +	retval = submit_stpg(sdev, pg->group_id, &sense_hdr);
>  
>  	if (retval) {
>  		if (!scsi_sense_valid(&sense_hdr)) {
> @@ -571,7 +618,7 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
>  			if (driver_byte(retval) == DRIVER_ERROR)
>  				return SCSI_DH_DEV_TEMP_BUSY;
>  		} else {
> -			sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed\n",
> +			sdev_printk(KERN_INFO, sdev, "%s: stpg failed\n",
>  				    ALUA_DH_NAME);
>  			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
>  		}
> @@ -596,13 +643,12 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
>  		goto out;
>  
>  	err = alua_check_vpd(sdev, h);
> -	if (err != SCSI_DH_OK)
> -		goto out;
> -
> -	err = alua_rtpg(sdev, h, 0);
> -	if (err != SCSI_DH_OK)
> +	if (err != SCSI_DH_OK || !h->pg)
>  		goto out;
>  
> +	kref_get(&h->pg->kref);
> +	err = alua_rtpg(sdev, h->pg, 0);
> +	kref_put(&h->pg->kref, release_port_group);
>  out:
>  	return err;
>  }
> @@ -618,6 +664,7 @@ out:
>  static int alua_set_params(struct scsi_device *sdev, const char *params)
>  {
>  	struct alua_dh_data *h = sdev->handler_data;
> +	struct alua_port_group *pg = NULL;
>  	unsigned int optimize = 0, argc;
>  	const char *p = params;
>  	int result = SCSI_DH_OK;
> @@ -630,10 +677,18 @@ static int alua_set_params(struct scsi_device *sdev, const char *params)
>  	if ((sscanf(p, "%u", &optimize) != 1) || (optimize > 1))
>  		return -EINVAL;
>  
> +	rcu_read_lock();
> +	pg = rcu_dereference(h->pg);
> +	if (!pg) {
> +		rcu_read_unlock();
> +		return -ENXIO;
> +	}
> +
>  	if (optimize)
> -		h->flags |= ALUA_OPTIMIZE_STPG;
> +		pg->flags |= ALUA_OPTIMIZE_STPG;
>  	else
> -		h->flags &= ~ALUA_OPTIMIZE_STPG;
> +		pg->flags |= ~ALUA_OPTIMIZE_STPG;
> +	rcu_read_unlock();
>  
>  	return result;
>  }
> @@ -658,16 +713,23 @@ static int alua_activate(struct scsi_device *sdev,
>  	struct alua_dh_data *h = sdev->handler_data;
>  	int err = SCSI_DH_OK;
>  
> -	err = alua_rtpg(sdev, h, 1);
> -	if (err != SCSI_DH_OK)
> +	if (!h->pg)
>  		goto out;
>  
> +	kref_get(&h->pg->kref);
> +
>  	if (optimize_stpg)
> -		h->flags |= ALUA_OPTIMIZE_STPG;
> +		h->pg->flags |= ALUA_OPTIMIZE_STPG;
>  
> -	err = alua_stpg(sdev, h);
> +	err = alua_rtpg(sdev, h->pg, 1);
> +	if (err != SCSI_DH_OK) {
> +		kref_put(&h->pg->kref, release_port_group);
> +		goto out;
> +	}
> +	err = alua_stpg(sdev, h->pg);
>  	if (err == SCSI_DH_RETRY)
> -		err = alua_rtpg(sdev, h, 1);
> +		err = alua_rtpg(sdev, h->pg, 1);
> +	kref_put(&h->pg->kref, release_port_group);
>  out:
>  	if (fn)
>  		fn(data, err);
> @@ -683,13 +745,19 @@ out:
>  static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
>  {
>  	struct alua_dh_data *h = sdev->handler_data;
> +	int state;
>  	int ret = BLKPREP_OK;
>  
> -	if (h->state == TPGS_STATE_TRANSITIONING)
> +	if (!h->pg)
> +		return ret;
> +	kref_get(&h->pg->kref);
> +	state = h->pg->state;
> +	kref_put(&h->pg->kref, release_port_group);
> +	if (state == TPGS_STATE_TRANSITIONING)
>  		ret = BLKPREP_DEFER;
> -	else if (h->state != TPGS_STATE_OPTIMIZED &&
> -		 h->state != TPGS_STATE_NONOPTIMIZED &&
> -		 h->state != TPGS_STATE_LBA_DEPENDENT) {
> +	else if (state != TPGS_STATE_OPTIMIZED &&
> +		 state != TPGS_STATE_NONOPTIMIZED &&
> +		 state != TPGS_STATE_LBA_DEPENDENT) {
>  		ret = BLKPREP_KILL;
>  		req->cmd_flags |= REQ_QUIET;
>  	}
> @@ -710,11 +778,8 @@ static int alua_bus_attach(struct scsi_device *sdev)
>  	if (!h)
>  		return -ENOMEM;
>  	h->tpgs = TPGS_MODE_UNINITIALIZED;
> -	h->state = TPGS_STATE_OPTIMIZED;
> -	h->group_id = -1;
> +	h->pg = NULL;
>  	h->rel_port = -1;
> -	h->buff = h->inq;
> -	h->bufflen = ALUA_INQUIRY_SIZE;
>  	h->sdev = sdev;
>  
>  	err = alua_initialize(sdev, h);
> @@ -736,8 +801,10 @@ static void alua_bus_detach(struct scsi_device *sdev)
>  {
>  	struct alua_dh_data *h = sdev->handler_data;
>  
> -	if (h->buff && h->inq != h->buff)
> -		kfree(h->buff);
> +	if (h->pg) {
> +		kref_put(&h->pg->kref, release_port_group);
> +		h->pg = NULL;
> +	}
>  	sdev->handler_data = NULL;
>  	kfree(h);
>  }

#include <linux/rcupdate.h> and RCU write side locking is not added until patch 19/23.
This patch uses rcu_read_lock()/rcu_read_unlock()/rcu_dereference() and should have
the #include added.

Note:  lookup of existing alua_port_group object is not added until patch 17/23.

Note that in alua_check_vpd(), returning SCSI_DH_DEV_TEMP_BUSY if kmalloc() or pg
or alloc_ordered_workqueue() fails will cause alua_bus_attach to fail with -EINVAL.
i.e. "temp busy" will not get retried so this is kind of misleading.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>




