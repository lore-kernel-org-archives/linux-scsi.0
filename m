Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4743C2D
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 00:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774224550; cv=none; b=f1C3CdZJJSHdk0RIkgDJZhN0gNtkDVsx2zmh0CQBm1+4XozMEt5zGzLcsJsJjpOFgrYOxS827yL0A8VbbvO1V6cislrefE1+TXxR2Z+zUgigsM0FYX8oiT7OxWKWOqrZT2D3dmWtsUv+uZHuYhLs2fyhKUZ5eyCqobabXJBcvfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774224550; c=relaxed/simple;
	bh=/oUipvVSHJ0t2sUG5+2FLpQkCv9CgZn7y/JxE0m9RsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cfmgi7Bx33BIjf5CIljXHQ/AylswMPyWENHo5zxk8p/2BAZH6/ZEF9tSQtUa8AlEi+SB94r7s1zckHjO6N+j6WoFn2X+M9C7DzFKlE4zbmIuTkkenKib4YEnFpKMWkAKiEpjPFJxVF+GBinWg/sN647L7+f2y+lmlsaYL6TPV34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LXrJCl2G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LXrJCl2G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774224546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fl3chWDvm53lVP5T7G39zgiz/TM/yMg8UKiJd3JRd+4=;
	b=LXrJCl2GjIRA/MeTd9qoR7ExjgaSfX1tksI2Su4Z+Jv2yhUV+H0E72necXDk/zdYEhuO/A
	sQwn9FmnE1V4rO4Y209ArPCnztivBcVxh0u6q/tRAFtyc6UmQHhukdKc80IheO2IAkQqj5
	pR00sxkLFvMfXgXFkoOFqvOA3WEn0Rw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-496-QnjA3rz-NouujkUe-u53ag-1; Sun,
 22 Mar 2026 20:09:01 -0400
X-MC-Unique: QnjA3rz-NouujkUe-u53ag-1
X-Mimecast-MFC-AGG-ID: QnjA3rz-NouujkUe-u53ag_1774224539
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E226A180044D;
	Mon, 23 Mar 2026 00:08:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC8061800764;
	Mon, 23 Mar 2026 00:08:57 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62N08uED1000725
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 22 Mar 2026 20:08:56 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62N08uPZ1000724;
	Sun, 22 Mar 2026 20:08:56 -0400
Date: Sun, 22 Mar 2026 20:08:56 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/13] scsi: scsi_dh_alua: Delete alua_port_group
Message-ID: <acCEmFgVgxr8qx39@redhat.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317120703.3702387-2-john.g.garry@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, Mar 17, 2026 at 12:06:51PM +0000, John Garry wrote:
> Delete the alua_port_group usage, as it is more accurate to manage the
> port group info per-scsi device - see [0]
> 
> [0] https://lore.kernel.org/linux-scsi/20260310114925.1222263-1-john.g.garry@oracle.com/T/#m4ffc0d07f169b70b8fd2407bae9632aa0f8c1f9a
> 
> For now, the handler data will be used to hold the ALUA-related info.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 663 ++++++---------------
>  1 file changed, 180 insertions(+), 483 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index efb08b9b145a1..067021fffc16f 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -54,41 +54,27 @@ static uint optimize_stpg;
>  module_param(optimize_stpg, uint, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(optimize_stpg, "Allow use of a non-optimized path, rather than sending a STPG, when implicit TPGS is supported (0=No,1=Yes). Default is 0.");
>  
> -static LIST_HEAD(port_group_list);
> -static DEFINE_SPINLOCK(port_group_lock);
>  static struct workqueue_struct *kaluad_wq;
>  
> -struct alua_port_group {
> -	struct kref		kref;
> -	struct rcu_head		rcu;
> -	struct list_head	node;
> -	struct list_head	dh_list;
> -	unsigned char		device_id_str[256];
> -	int			device_id_len;
> +struct alua_dh_data {
>  	int			group_id;
> -	int			tpgs;
> +	struct scsi_device	*sdev;
> +	int			init_error;
> +	struct mutex		init_mutex;
> +	bool			disabled;

disabled doesn't have a use anymore, since you aren't retrying RTPGs on
different devices.

> +	unsigned		flags; /* used for optimizing STPG */
> +	spinlock_t		lock;
> +
> +	/* alua stuff */
>  	int			state;
>  	int			pref;
>  	int			valid_states;
> -	unsigned		flags; /* used for optimizing STPG */
> +	int			tpgs;
>  	unsigned char		transition_tmo;
>  	unsigned long		expiry;
>  	unsigned long		interval;
>  	struct delayed_work	rtpg_work;
> -	spinlock_t		lock;
>  	struct list_head	rtpg_list;
> -	struct scsi_device	*rtpg_sdev;
> -};
> -
> -struct alua_dh_data {
> -	struct list_head	node;
> -	struct alua_port_group __rcu *pg;
> -	int			group_id;
> -	spinlock_t		pg_lock;
> -	struct scsi_device	*sdev;
> -	int			init_error;
> -	struct mutex		init_mutex;
> -	bool			disabled;
>  };
>  
>  struct alua_queue_data {
> @@ -101,24 +87,10 @@ struct alua_queue_data {
>  #define ALUA_POLICY_SWITCH_ALL		1
>  
>  static void alua_rtpg_work(struct work_struct *work);
> -static bool alua_rtpg_queue(struct alua_port_group *pg,
> -			    struct scsi_device *sdev,
> +static bool alua_rtpg_queue(struct scsi_device *sdev,
>  			    struct alua_queue_data *qdata, bool force);
>  static void alua_check(struct scsi_device *sdev, bool force);
>  
> -static void release_port_group(struct kref *kref)
> -{
> -	struct alua_port_group *pg;
> -
> -	pg = container_of(kref, struct alua_port_group, kref);
> -	if (pg->rtpg_sdev)
> -		flush_delayed_work(&pg->rtpg_work);
> -	spin_lock(&port_group_lock);
> -	list_del(&pg->node);
> -	spin_unlock(&port_group_lock);
> -	kfree_rcu(pg, rcu);
> -}
> -
>  /*
>   * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
>   * @sdev: sdev the command should be sent to
> @@ -182,88 +154,6 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
>  				ALUA_FAILOVER_RETRIES, &exec_args);
>  }
>  
> -static struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_size,
> -						int group_id)
> -{
> -	struct alua_port_group *pg;
> -
> -	if (!id_str || !id_size || !strlen(id_str))
> -		return NULL;
> -
> -	list_for_each_entry(pg, &port_group_list, node) {
> -		if (pg->group_id != group_id)
> -			continue;
> -		if (!pg->device_id_len || pg->device_id_len != id_size)
> -			continue;
> -		if (strncmp(pg->device_id_str, id_str, id_size))
> -			continue;
> -		if (!kref_get_unless_zero(&pg->kref))
> -			continue;
> -		return pg;
> -	}
> -
> -	return NULL;
> -}
> -
> -/*
> - * alua_alloc_pg - Allocate a new port_group structure
> - * @sdev: scsi device
> - * @group_id: port group id
> - * @tpgs: target port group settings
> - *
> - * Allocate a new port_group structure for a given
> - * device.
> - */
> -static struct alua_port_group *alua_alloc_pg(struct scsi_device *sdev,
> -					     int group_id, int tpgs)
> -{
> -	struct alua_port_group *pg, *tmp_pg;
> -
> -	pg = kzalloc_obj(struct alua_port_group);
> -	if (!pg)
> -		return ERR_PTR(-ENOMEM);
> -
> -	pg->device_id_len = scsi_vpd_lun_id(sdev, pg->device_id_str,
> -					    sizeof(pg->device_id_str));
> -	if (pg->device_id_len <= 0) {
> -		/*
> -		 * TPGS supported but no device identification found.
> -		 * Generate private device identification.
> -		 */
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: No device descriptors found\n",
> -			    ALUA_DH_NAME);
> -		pg->device_id_str[0] = '\0';
> -		pg->device_id_len = 0;
> -	}
> -	pg->group_id = group_id;
> -	pg->tpgs = tpgs;
> -	pg->state = SCSI_ACCESS_STATE_OPTIMAL;
> -	pg->valid_states = TPGS_SUPPORT_ALL;
> -	if (optimize_stpg)
> -		pg->flags |= ALUA_OPTIMIZE_STPG;
> -	kref_init(&pg->kref);
> -	INIT_DELAYED_WORK(&pg->rtpg_work, alua_rtpg_work);
> -	INIT_LIST_HEAD(&pg->rtpg_list);
> -	INIT_LIST_HEAD(&pg->node);
> -	INIT_LIST_HEAD(&pg->dh_list);
> -	spin_lock_init(&pg->lock);
> -
> -	spin_lock(&port_group_lock);
> -	tmp_pg = alua_find_get_pg(pg->device_id_str, pg->device_id_len,
> -				  group_id);
> -	if (tmp_pg) {
> -		spin_unlock(&port_group_lock);
> -		kfree(pg);
> -		return tmp_pg;
> -	}
> -
> -	list_add(&pg->node, &port_group_list);
> -	spin_unlock(&port_group_lock);
> -
> -	return pg;
> -}
> -
>  /*
>   * alua_check_tpgs - Evaluate TPGS setting
>   * @sdev: device to be checked
> @@ -326,13 +216,10 @@ static int alua_check_tpgs(struct scsi_device *sdev)
>  static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
>  			  int tpgs)
>  {
> -	int rel_port = -1, group_id;
> -	struct alua_port_group *pg, *old_pg = NULL;
> -	bool pg_updated = false;
> -	unsigned long flags;
> +	int rel_port = -1;
>  
> -	group_id = scsi_vpd_tpg_id(sdev, &rel_port);
> -	if (group_id < 0) {
> +	h->group_id = scsi_vpd_tpg_id(sdev, &rel_port);
> +	if (h->group_id < 0) {
>  		/*
>  		 * Internal error; TPGS supported but required
>  		 * VPD identification descriptors not present.
> @@ -343,51 +230,9 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
>  			    ALUA_DH_NAME);
>  		return SCSI_DH_DEV_UNSUPP;
>  	}
> +	h->tpgs = tpgs;
>  
> -	pg = alua_alloc_pg(sdev, group_id, tpgs);
> -	if (IS_ERR(pg)) {
> -		if (PTR_ERR(pg) == -ENOMEM)
> -			return SCSI_DH_NOMEM;
> -		return SCSI_DH_DEV_UNSUPP;
> -	}
> -	if (pg->device_id_len)
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: device %s port group %x rel port %x\n",
> -			    ALUA_DH_NAME, pg->device_id_str,
> -			    group_id, rel_port);
> -	else
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: port group %x rel port %x\n",
> -			    ALUA_DH_NAME, group_id, rel_port);
> -
> -	kref_get(&pg->kref);
> -
> -	/* Check for existing port group references */
> -	spin_lock(&h->pg_lock);
> -	old_pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
> -	if (old_pg != pg) {
> -		/* port group has changed. Update to new port group */
> -		if (h->pg) {
> -			spin_lock_irqsave(&old_pg->lock, flags);
> -			list_del_rcu(&h->node);
> -			spin_unlock_irqrestore(&old_pg->lock, flags);
> -		}
> -		rcu_assign_pointer(h->pg, pg);
> -		pg_updated = true;
> -	}
> -
> -	spin_lock_irqsave(&pg->lock, flags);
> -	if (pg_updated)
> -		list_add_rcu(&h->node, &pg->dh_list);
> -	spin_unlock_irqrestore(&pg->lock, flags);
> -
> -	spin_unlock(&h->pg_lock);
> -
> -	alua_rtpg_queue(pg, sdev, NULL, true);
> -	kref_put(&pg->kref, release_port_group);
> -
> -	if (old_pg)
> -		kref_put(&old_pg->kref, release_port_group);
> +	alua_rtpg_queue(sdev, NULL, true);
>  
>  	return SCSI_DH_OK;
>  }
> @@ -417,14 +262,8 @@ static char print_alua_state(unsigned char state)
>  static void alua_handle_state_transition(struct scsi_device *sdev)
>  {
>  	struct alua_dh_data *h = sdev->handler_data;
> -	struct alua_port_group *pg;
> -
> -	rcu_read_lock();
> -	pg = rcu_dereference(h->pg);
> -	if (pg)
> -		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
> -	rcu_read_unlock();
> -	alua_check(sdev, false);
> +
> +	h->state = SCSI_ACCESS_STATE_TRANSITIONING;
>  }
>  
>  static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
> @@ -532,10 +371,10 @@ static int alua_tur(struct scsi_device *sdev)
>   * Returns SCSI_DH_DEV_OFFLINED if the path is
>   * found to be unusable.
>   */
> -static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
> +static int alua_rtpg(struct scsi_device *sdev)
>  {
>  	struct scsi_sense_hdr sense_hdr;
> -	struct alua_port_group *tmp_pg;
> +	struct alua_dh_data *h = sdev->handler_data;
>  	int len, k, off, bufflen = ALUA_RTPG_SIZE;
>  	int group_id_old, state_old, pref_old, valid_states_old;
>  	unsigned char *desc, *buff;
> @@ -545,19 +384,32 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  	unsigned char orig_transition_tmo;
>  	unsigned long flags;
>  	bool transitioning_sense = false;
> +	int rel_port, group_id = scsi_vpd_tpg_id(sdev, &rel_port);
> +
> +	if (group_id < 0) {
> +		/*
> +		 * Internal error; TPGS supported but required
> +		 * VPD identification descriptors not present.
> +		 * Disable ALUA support
> +		 */
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: No target port descriptors found\n",
> +			    ALUA_DH_NAME);
> +		return SCSI_DH_DEV_UNSUPP;
> +	}
>  
> -	group_id_old = pg->group_id;
> -	state_old = pg->state;
> -	pref_old = pg->pref;
> -	valid_states_old = pg->valid_states;
> +	group_id_old = h->group_id;
> +	state_old = h->state;
> +	pref_old = h->pref;
> +	valid_states_old = h->valid_states;
>  
> -	if (!pg->expiry) {
> +	if (!h->expiry) {
>  		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
>  
> -		if (pg->transition_tmo)
> -			transition_tmo = pg->transition_tmo * HZ;
> +		if (h->transition_tmo)
> +			transition_tmo = h->transition_tmo * HZ;
>  
> -		pg->expiry = round_jiffies_up(jiffies + transition_tmo);
> +		h->expiry = round_jiffies_up(jiffies + transition_tmo);
>  	}
>  
>  	buff = kzalloc(bufflen, GFP_KERNEL);
> @@ -566,7 +418,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  
>   retry:
>  	err = 0;
> -	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, pg->flags);
> +	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, h->flags);
>  
>  	if (retval) {
>  		/*
> @@ -578,7 +430,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  		 * So ignore any errors to avoid spurious failures during
>  		 * path failover.
>  		 */
> -		if ((pg->valid_states & ~TPGS_SUPPORT_OPTIMIZED) == 0) {
> +		if ((h->valid_states & ~TPGS_SUPPORT_OPTIMIZED) == 0) {
>  			sdev_printk(KERN_INFO, sdev,
>  				    "%s: ignoring rtpg result %d\n",
>  				    ALUA_DH_NAME, retval);
> @@ -607,9 +459,9 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  		 * Note:  some arrays return a sense key of ILLEGAL_REQUEST
>  		 * with ASC 00h if they don't support the extended header.
>  		 */
> -		if (!(pg->flags & ALUA_RTPG_EXT_HDR_UNSUPP) &&
> +		if (!(h->flags & ALUA_RTPG_EXT_HDR_UNSUPP) &&
>  		    sense_hdr.sense_key == ILLEGAL_REQUEST) {
> -			pg->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
> +			h->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
>  			goto retry;
>  		}
>  		/*
> @@ -628,7 +480,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  		if (sense_hdr.sense_key == UNIT_ATTENTION)
>  			err = SCSI_DH_RETRY;
>  		if (err == SCSI_DH_RETRY &&
> -		    pg->expiry != 0 && time_before(jiffies, pg->expiry)) {
> +		    h->expiry != 0 && time_before(jiffies, h->expiry)) {
>  			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
>  				    ALUA_DH_NAME);
>  			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
> @@ -639,7 +491,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  			    ALUA_DH_NAME);
>  		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
>  		kfree(buff);
> -		pg->expiry = 0;
> +		h->expiry = 0;
>  		return SCSI_DH_IO;
>  	}
>  
> @@ -654,23 +506,23 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  			sdev_printk(KERN_WARNING, sdev,
>  				    "%s: kmalloc buffer failed\n",__func__);
>  			/* Temporary failure, bypass */
> -			pg->expiry = 0;
> +			h->expiry = 0;
>  			return SCSI_DH_DEV_TEMP_BUSY;
>  		}
>  		goto retry;
>  	}
>  
> -	orig_transition_tmo = pg->transition_tmo;
> +	orig_transition_tmo = h->transition_tmo;
>  	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && buff[5] != 0)
> -		pg->transition_tmo = buff[5];
> +		h->transition_tmo = buff[5];
>  	else
> -		pg->transition_tmo = ALUA_FAILOVER_TIMEOUT;
> +		h->transition_tmo = ALUA_FAILOVER_TIMEOUT;
>  
> -	if (orig_transition_tmo != pg->transition_tmo) {
> +	if (orig_transition_tmo != h->transition_tmo) {
>  		sdev_printk(KERN_INFO, sdev,
>  			    "%s: transition timeout set to %d seconds\n",
> -			    ALUA_DH_NAME, pg->transition_tmo);
> -		pg->expiry = jiffies + pg->transition_tmo * HZ;
> +			    ALUA_DH_NAME, h->transition_tmo);
> +		h->expiry = jiffies + h->transition_tmo * HZ;
>  	}
>  
>  	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
> @@ -681,95 +533,71 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  	for (k = tpg_desc_tbl_off, desc = buff + tpg_desc_tbl_off;
>  	     k < len;
>  	     k += off, desc += off) {
> -		u16 group_id = get_unaligned_be16(&desc[2]);
> -
> -		spin_lock_irqsave(&port_group_lock, flags);
> -		tmp_pg = alua_find_get_pg(pg->device_id_str, pg->device_id_len,
> -					  group_id);
> -		spin_unlock_irqrestore(&port_group_lock, flags);
> -		if (tmp_pg) {
> -			if (spin_trylock_irqsave(&tmp_pg->lock, flags)) {
> -				if ((tmp_pg == pg) ||
> -				    !(tmp_pg->flags & ALUA_PG_RUNNING)) {
> -					struct alua_dh_data *h;
> -
> -					tmp_pg->state = desc[0] & 0x0f;
> -					tmp_pg->pref = desc[0] >> 7;
> -					rcu_read_lock();
> -					list_for_each_entry_rcu(h,
> -						&tmp_pg->dh_list, node) {
> -						if (!h->sdev)
> -							continue;
> -						h->sdev->access_state = desc[0];
> -					}
> -					rcu_read_unlock();
> -				}
> -				if (tmp_pg == pg)
> -					tmp_pg->valid_states = desc[1];
> -				spin_unlock_irqrestore(&tmp_pg->lock, flags);
> -			}
> -			kref_put(&tmp_pg->kref, release_port_group);
> +		u16 group_id_desc = get_unaligned_be16(&desc[2]);
> +
> +		spin_lock_irqsave(&h->lock, flags);
> +		if (group_id_desc == group_id) {
> +			h->group_id = group_id;
> +			WRITE_ONCE(h->state, desc[0] & 0x0f);
> +			h->pref = desc[0] >> 7;
> +			WRITE_ONCE(sdev->access_state, desc[0]);
> +			h->valid_states = desc[1];

instead of alua_rtpg() updating the access_state all of the devices in
all the port groups, and the state and pref of all the port groups. It
now just sets these for one device. It seems like it's wasting a lot of
information that it used to use. For instance, now when a scsi command
returns a unit attention that the ALUA state has changed, it won't get
updated on all the devices, just the one that got the unit attention.

>  		}
> +		spin_unlock_irqrestore(&h->lock, flags);
>  		off = 8 + (desc[7] * 4);
>  	}
>  
>   skip_rtpg:
> -	spin_lock_irqsave(&pg->lock, flags);
> +	spin_lock_irqsave(&h->lock, flags);
>  	if (transitioning_sense)
> -		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
> +		h->state = SCSI_ACCESS_STATE_TRANSITIONING;
>  
> -	if (group_id_old != pg->group_id || state_old != pg->state ||
> -		pref_old != pg->pref || valid_states_old != pg->valid_states)
> +	if (group_id_old != h->group_id || state_old != h->state ||
> +		pref_old != h->pref || valid_states_old != h->valid_states)
>  		sdev_printk(KERN_INFO, sdev,
>  			"%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
> -			ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
> -			pg->pref ? "preferred" : "non-preferred",
> -			pg->valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
> -			pg->valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
> -			pg->valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
> -			pg->valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
> -			pg->valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
> -			pg->valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
> -			pg->valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
> -
> -	switch (pg->state) {
> +			ALUA_DH_NAME, h->group_id, print_alua_state(h->state),
> +			h->pref ? "preferred" : "non-preferred",
> +			h->valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
> +			h->valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
> +			h->valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
> +			h->valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
> +			h->valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
> +			h->valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
> +			h->valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
> +
> +	switch (h->state) {
>  	case SCSI_ACCESS_STATE_TRANSITIONING:
> -		if (time_before(jiffies, pg->expiry)) {
> +		if (time_before(jiffies, h->expiry)) {
>  			/* State transition, retry */
> -			pg->interval = ALUA_RTPG_RETRY_DELAY;
> +			h->interval = ALUA_RTPG_RETRY_DELAY;
>  			err = SCSI_DH_RETRY;
>  		} else {
>  			struct alua_dh_data *h;
> +			unsigned char access_state;
>  
>  			/* Transitioning time exceeded, set port to standby */
>  			err = SCSI_DH_IO;
> -			pg->state = SCSI_ACCESS_STATE_STANDBY;
> -			pg->expiry = 0;
> -			rcu_read_lock();
> -			list_for_each_entry_rcu(h, &pg->dh_list, node) {
> -				if (!h->sdev)
> -					continue;
> -				h->sdev->access_state =
> -					(pg->state & SCSI_ACCESS_STATE_MASK);
> -				if (pg->pref)
> -					h->sdev->access_state |=
> -						SCSI_ACCESS_STATE_PREFERRED;
> -			}
> -			rcu_read_unlock();
> +			h->state = SCSI_ACCESS_STATE_STANDBY;
> +			h->expiry = 0;
> +			access_state = h->state & SCSI_ACCESS_STATE_MASK;
> +			if (h->pref)
> +				access_state |= SCSI_ACCESS_STATE_PREFERRED;
> +			WRITE_ONCE(sdev->access_state, access_state);
>  		}
>  		break;
>  	case SCSI_ACCESS_STATE_OFFLINE:
>  		/* Path unusable */
>  		err = SCSI_DH_DEV_OFFLINED;
> -		pg->expiry = 0;
> +		h->expiry = 0;
>  		break;
>  	default:
>  		/* Useable path if active */
>  		err = SCSI_DH_OK;
> -		pg->expiry = 0;
> +		h->expiry = 0;
>  		break;
>  	}
> -	spin_unlock_irqrestore(&pg->lock, flags);
> +	spin_unlock_irqrestore(&h->lock, flags);
>  	kfree(buff);
>  	return err;
>  }
> @@ -782,22 +610,23 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>   * a re-evaluation of the target group state or SCSI_DH_OK
>   * if no further action needs to be taken.
>   */
> -static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
> +static unsigned alua_stpg(struct scsi_device *sdev)
>  {
>  	int retval;
>  	struct scsi_sense_hdr sense_hdr;
> +	struct alua_dh_data *h = sdev->handler_data;
>  
> -	if (!(pg->tpgs & TPGS_MODE_EXPLICIT)) {
> +	if (!(h->tpgs & TPGS_MODE_EXPLICIT)) {
>  		/* Only implicit ALUA supported, retry */
>  		return SCSI_DH_RETRY;
>  	}
> -	switch (pg->state) {
> +	switch (h->state) {
>  	case SCSI_ACCESS_STATE_OPTIMAL:
>  		return SCSI_DH_OK;
>  	case SCSI_ACCESS_STATE_ACTIVE:
> -		if ((pg->flags & ALUA_OPTIMIZE_STPG) &&
> -		    !pg->pref &&
> -		    (pg->tpgs & TPGS_MODE_IMPLICIT))
> +		if ((h->flags & ALUA_OPTIMIZE_STPG) &&
> +		    !h->pref &&
> +		    (h->tpgs & TPGS_MODE_IMPLICIT))
>  			return SCSI_DH_OK;
>  		break;
>  	case SCSI_ACCESS_STATE_STANDBY:
> @@ -810,10 +639,10 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  	default:
>  		sdev_printk(KERN_INFO, sdev,
>  			    "%s: stpg failed, unhandled TPGS state %d",
> -			    ALUA_DH_NAME, pg->state);
> +			    ALUA_DH_NAME, h->state);
>  		return SCSI_DH_NOSYS;
>  	}
> -	retval = submit_stpg(sdev, pg->group_id, &sense_hdr);
> +	retval = submit_stpg(sdev, h->group_id, &sense_hdr);
>  
>  	if (retval) {
>  		if (retval < 0 || !scsi_sense_valid(&sense_hdr)) {
> @@ -832,144 +661,75 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  	return SCSI_DH_RETRY;
>  }
>  
> -/*
> - * The caller must call scsi_device_put() on the returned pointer if it is not
> - * NULL.
> - */
> -static struct scsi_device * __must_check
> -alua_rtpg_select_sdev(struct alua_port_group *pg)
> -{
> -	struct alua_dh_data *h;
> -	struct scsi_device *sdev = NULL, *prev_sdev;
> -
> -	lockdep_assert_held(&pg->lock);
> -	if (WARN_ON(!pg->rtpg_sdev))
> -		return NULL;
> -
> -	/*
> -	 * RCU protection isn't necessary for dh_list here
> -	 * as we hold pg->lock, but for access to h->pg.
> -	 */
> -	rcu_read_lock();
> -	list_for_each_entry_rcu(h, &pg->dh_list, node) {
> -		if (!h->sdev)
> -			continue;
> -		if (h->sdev == pg->rtpg_sdev) {
> -			h->disabled = true;
> -			continue;
> -		}
> -		if (rcu_dereference(h->pg) == pg &&
> -		    !h->disabled &&
> -		    !scsi_device_get(h->sdev)) {
> -			sdev = h->sdev;
> -			break;
> -		}
> -	}
> -	rcu_read_unlock();
> -
> -	if (!sdev) {
> -		pr_warn("%s: no device found for rtpg\n",
> -			(pg->device_id_len ?
> -			 (char *)pg->device_id_str : "(nameless PG)"));
> -		return NULL;
> -	}
> -
> -	sdev_printk(KERN_INFO, sdev, "rtpg retry on different device\n");
> -
> -	prev_sdev = pg->rtpg_sdev;
> -	pg->rtpg_sdev = sdev;
> -
> -	return prev_sdev;
> -}
> -
>  static void alua_rtpg_work(struct work_struct *work)
>  {
> -	struct alua_port_group *pg =
> -		container_of(work, struct alua_port_group, rtpg_work.work);
> -	struct scsi_device *sdev, *prev_sdev = NULL;
> +	struct alua_dh_data *h =
> +		container_of(work, struct alua_dh_data, rtpg_work.work);
> +	struct scsi_device *sdev = h->sdev;
>  	LIST_HEAD(qdata_list);
>  	int err = SCSI_DH_OK;
>  	struct alua_queue_data *qdata, *tmp;
> -	struct alua_dh_data *h;
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&pg->lock, flags);
> -	sdev = pg->rtpg_sdev;
> -	if (!sdev) {
> -		WARN_ON(pg->flags & ALUA_PG_RUN_RTPG);
> -		WARN_ON(pg->flags & ALUA_PG_RUN_STPG);
> -		spin_unlock_irqrestore(&pg->lock, flags);
> -		kref_put(&pg->kref, release_port_group);
> -		return;
> -	}
> -	pg->flags |= ALUA_PG_RUNNING;
> -	if (pg->flags & ALUA_PG_RUN_RTPG) {
> -		int state = pg->state;
> +	spin_lock_irqsave(&h->lock, flags);
> +	h->flags |= ALUA_PG_RUNNING;
> +	if (h->flags & ALUA_PG_RUN_RTPG) {
> +		int state = h->state;
>  
> -		pg->flags &= ~ALUA_PG_RUN_RTPG;
> -		spin_unlock_irqrestore(&pg->lock, flags);
> +		h->flags &= ~ALUA_PG_RUN_RTPG;
> +		spin_unlock_irqrestore(&h->lock, flags);
>  		if (state == SCSI_ACCESS_STATE_TRANSITIONING) {
>  			if (alua_tur(sdev) == SCSI_DH_RETRY) {
> -				spin_lock_irqsave(&pg->lock, flags);
> -				pg->flags &= ~ALUA_PG_RUNNING;
> -				pg->flags |= ALUA_PG_RUN_RTPG;
> -				if (!pg->interval)
> -					pg->interval = ALUA_RTPG_RETRY_DELAY;
> -				spin_unlock_irqrestore(&pg->lock, flags);
> -				queue_delayed_work(kaluad_wq, &pg->rtpg_work,
> -						   pg->interval * HZ);
> +				spin_lock_irqsave(&h->lock, flags);
> +				h->flags &= ~ALUA_PG_RUNNING;
> +				h->flags |= ALUA_PG_RUN_RTPG;
> +				if (!h->interval)
> +					h->interval = ALUA_RTPG_RETRY_DELAY;
> +				spin_unlock_irqrestore(&h->lock, flags);
> +				queue_delayed_work(kaluad_wq, &h->rtpg_work,
> +						   h->interval * HZ);
>  				return;
>  			}
>  			/* Send RTPG on failure or if TUR indicates SUCCESS */
>  		}
> -		err = alua_rtpg(sdev, pg);
> -		spin_lock_irqsave(&pg->lock, flags);
> +		err = alua_rtpg(sdev);
> +		spin_lock_irqsave(&h->lock, flags);
>  
> -		/* If RTPG failed on the current device, try using another */
> -		if (err == SCSI_DH_RES_TEMP_UNAVAIL &&
> -		    (prev_sdev = alua_rtpg_select_sdev(pg)))
> -			err = SCSI_DH_IMM_RETRY;

Previously, if the rtpg failed on a device, another device would be
tried, and the unusable device's alua state would get updated, along
with all the other device's states. Now I don't see how a failed device
gets its state updated.

-Ben

> -
> -		if (err == SCSI_DH_RETRY || err == SCSI_DH_IMM_RETRY ||
> -		    pg->flags & ALUA_PG_RUN_RTPG) {
> -			pg->flags &= ~ALUA_PG_RUNNING;
> +		if (err == SCSI_DH_RETRY || h->flags & ALUA_PG_RUN_RTPG) {
> +			h->flags &= ~ALUA_PG_RUNNING;
>  			if (err == SCSI_DH_IMM_RETRY)
> -				pg->interval = 0;
> -			else if (!pg->interval && !(pg->flags & ALUA_PG_RUN_RTPG))
> -				pg->interval = ALUA_RTPG_RETRY_DELAY;
> -			pg->flags |= ALUA_PG_RUN_RTPG;
> -			spin_unlock_irqrestore(&pg->lock, flags);
> +				h->interval = 0;
> +			else if (!h->interval && !(h->flags & ALUA_PG_RUN_RTPG))
> +				h->interval = ALUA_RTPG_RETRY_DELAY;
> +			h->flags |= ALUA_PG_RUN_RTPG;
> +			spin_unlock_irqrestore(&h->lock, flags);
>  			goto queue_rtpg;
>  		}
>  		if (err != SCSI_DH_OK)
> -			pg->flags &= ~ALUA_PG_RUN_STPG;
> +			h->flags &= ~ALUA_PG_RUN_STPG;
>  	}
> -	if (pg->flags & ALUA_PG_RUN_STPG) {
> -		pg->flags &= ~ALUA_PG_RUN_STPG;
> -		spin_unlock_irqrestore(&pg->lock, flags);
> -		err = alua_stpg(sdev, pg);
> -		spin_lock_irqsave(&pg->lock, flags);
> -		if (err == SCSI_DH_RETRY || pg->flags & ALUA_PG_RUN_RTPG) {
> -			pg->flags |= ALUA_PG_RUN_RTPG;
> -			pg->interval = 0;
> -			pg->flags &= ~ALUA_PG_RUNNING;
> -			spin_unlock_irqrestore(&pg->lock, flags);
> +	if (h->flags & ALUA_PG_RUN_STPG) {
> +		h->flags &= ~ALUA_PG_RUN_STPG;
> +		spin_unlock_irqrestore(&h->lock, flags);
> +		err = alua_stpg(sdev);
> +		spin_lock_irqsave(&h->lock, flags);
> +		if (err == SCSI_DH_RETRY || h->flags & ALUA_PG_RUN_RTPG) {
> +			h->flags |= ALUA_PG_RUN_RTPG;
> +			h->interval = 0;
> +			h->flags &= ~ALUA_PG_RUNNING;
> +			spin_unlock_irqrestore(&h->lock, flags);
>  			goto queue_rtpg;
>  		}
>  	}
>  
> -	list_splice_init(&pg->rtpg_list, &qdata_list);
> +	list_splice_init(&h->rtpg_list, &qdata_list);
>  	/*
>  	 * We went through an RTPG, for good or bad.
> -	 * Re-enable all devices for the next attempt.
> +	 * Re-enable the device for the next attempt.
>  	 */
> -	list_for_each_entry(h, &pg->dh_list, node)
> -		h->disabled = false;
> -	pg->rtpg_sdev = NULL;
> -	spin_unlock_irqrestore(&pg->lock, flags);
> +	h->disabled = false;
> +	spin_unlock_irqrestore(&h->lock, flags);
>  
> -	if (prev_sdev)
> -		scsi_device_put(prev_sdev);
>  
>  	list_for_each_entry_safe(qdata, tmp, &qdata_list, entry) {
>  		list_del(&qdata->entry);
> @@ -977,22 +737,19 @@ static void alua_rtpg_work(struct work_struct *work)
>  			qdata->callback_fn(qdata->callback_data, err);
>  		kfree(qdata);
>  	}
> -	spin_lock_irqsave(&pg->lock, flags);
> -	pg->flags &= ~ALUA_PG_RUNNING;
> -	spin_unlock_irqrestore(&pg->lock, flags);
> +	spin_lock_irqsave(&h->lock, flags);
> +	h->flags &= ~ALUA_PG_RUNNING;
> +	spin_unlock_irqrestore(&h->lock, flags);
>  	scsi_device_put(sdev);
> -	kref_put(&pg->kref, release_port_group);
> +
>  	return;
>  
>  queue_rtpg:
> -	if (prev_sdev)
> -		scsi_device_put(prev_sdev);
> -	queue_delayed_work(kaluad_wq, &pg->rtpg_work, pg->interval * HZ);
> +	queue_delayed_work(kaluad_wq, &h->rtpg_work, h->interval * HZ);
>  }
>  
>  /**
>   * alua_rtpg_queue() - cause RTPG to be submitted asynchronously
> - * @pg: ALUA port group associated with @sdev.
>   * @sdev: SCSI device for which to submit an RTPG.
>   * @qdata: Information about the callback to invoke after the RTPG.
>   * @force: Whether or not to submit an RTPG if a work item that will submit an
> @@ -1004,51 +761,34 @@ static void alua_rtpg_work(struct work_struct *work)
>   * Context: may be called from atomic context (alua_check()) only if the caller
>   *	holds an sdev reference.
>   */
> -static bool alua_rtpg_queue(struct alua_port_group *pg,
> -			    struct scsi_device *sdev,
> +static bool alua_rtpg_queue(struct scsi_device *sdev,
>  			    struct alua_queue_data *qdata, bool force)
>  {
>  	int start_queue = 0;
> +	struct alua_dh_data *h = sdev->handler_data;
>  	unsigned long flags;
>  
> -	if (WARN_ON_ONCE(!pg) || scsi_device_get(sdev))
> +	if (scsi_device_get(sdev))
>  		return false;
>  
> -	spin_lock_irqsave(&pg->lock, flags);
> +	spin_lock_irqsave(&h->lock, flags);
>  	if (qdata) {
> -		list_add_tail(&qdata->entry, &pg->rtpg_list);
> -		pg->flags |= ALUA_PG_RUN_STPG;
> +		list_add_tail(&qdata->entry, &h->rtpg_list);
> +		h->flags |= ALUA_PG_RUN_STPG;
>  		force = true;
>  	}
> -	if (pg->rtpg_sdev == NULL) {
> -		struct alua_dh_data *h = sdev->handler_data;
> -
> -		rcu_read_lock();
> -		if (h && rcu_dereference(h->pg) == pg) {
> -			pg->interval = 0;
> -			pg->flags |= ALUA_PG_RUN_RTPG;
> -			kref_get(&pg->kref);
> -			pg->rtpg_sdev = sdev;
> -			start_queue = 1;
> -		}
> -		rcu_read_unlock();
> -	} else if (!(pg->flags & ALUA_PG_RUN_RTPG) && force) {
> -		pg->flags |= ALUA_PG_RUN_RTPG;
> +	if (!(h->flags & ALUA_PG_RUN_RTPG) && force) {
> +		h->flags |= ALUA_PG_RUN_RTPG;
>  		/* Do not queue if the worker is already running */
> -		if (!(pg->flags & ALUA_PG_RUNNING)) {
> -			kref_get(&pg->kref);
> +		if (!(h->flags & ALUA_PG_RUNNING))
>  			start_queue = 1;
> -		}
>  	}
>  
> -	spin_unlock_irqrestore(&pg->lock, flags);
> -
> +	spin_unlock_irqrestore(&h->lock, flags);
>  	if (start_queue) {
> -		if (queue_delayed_work(kaluad_wq, &pg->rtpg_work,
> +		if (queue_delayed_work(kaluad_wq, &h->rtpg_work,
>  				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS)))
>  			sdev = NULL;
> -		else
> -			kref_put(&pg->kref, release_port_group);
>  	}
>  	if (sdev)
>  		scsi_device_put(sdev);
> @@ -1088,7 +828,6 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
>  static int alua_set_params(struct scsi_device *sdev, const char *params)
>  {
>  	struct alua_dh_data *h = sdev->handler_data;
> -	struct alua_port_group *pg = NULL;
>  	unsigned int optimize = 0, argc;
>  	const char *p = params;
>  	int result = SCSI_DH_OK;
> @@ -1102,19 +841,12 @@ static int alua_set_params(struct scsi_device *sdev, const char *params)
>  	if ((sscanf(p, "%u", &optimize) != 1) || (optimize > 1))
>  		return -EINVAL;
>  
> -	rcu_read_lock();
> -	pg = rcu_dereference(h->pg);
> -	if (!pg) {
> -		rcu_read_unlock();
> -		return -ENXIO;
> -	}
> -	spin_lock_irqsave(&pg->lock, flags);
> +	spin_lock_irqsave(&h->lock, flags);
>  	if (optimize)
> -		pg->flags |= ALUA_OPTIMIZE_STPG;
> +		h->flags |= ALUA_OPTIMIZE_STPG;
>  	else
> -		pg->flags &= ~ALUA_OPTIMIZE_STPG;
> -	spin_unlock_irqrestore(&pg->lock, flags);
> -	rcu_read_unlock();
> +		h->flags &= ~ALUA_OPTIMIZE_STPG;
> +	spin_unlock_irqrestore(&h->lock, flags);
>  
>  	return result;
>  }
> @@ -1132,10 +864,8 @@ static int alua_set_params(struct scsi_device *sdev, const char *params)
>  static int alua_activate(struct scsi_device *sdev,
>  			activate_complete fn, void *data)
>  {
> -	struct alua_dh_data *h = sdev->handler_data;
>  	int err = SCSI_DH_OK;
>  	struct alua_queue_data *qdata;
> -	struct alua_port_group *pg;
>  
>  	qdata = kzalloc_obj(*qdata);
>  	if (!qdata) {
> @@ -1145,26 +875,12 @@ static int alua_activate(struct scsi_device *sdev,
>  	qdata->callback_fn = fn;
>  	qdata->callback_data = data;
>  
> -	mutex_lock(&h->init_mutex);
> -	rcu_read_lock();
> -	pg = rcu_dereference(h->pg);
> -	if (!pg || !kref_get_unless_zero(&pg->kref)) {
> -		rcu_read_unlock();
> -		kfree(qdata);
> -		err = h->init_error;
> -		mutex_unlock(&h->init_mutex);
> -		goto out;
> -	}
> -	rcu_read_unlock();
> -	mutex_unlock(&h->init_mutex);
> -
> -	if (alua_rtpg_queue(pg, sdev, qdata, true)) {
> +	if (alua_rtpg_queue(sdev, qdata, true)) {
>  		fn = NULL;
>  	} else {
>  		kfree(qdata);
>  		err = SCSI_DH_DEV_OFFLINED;
>  	}
> -	kref_put(&pg->kref, release_port_group);
>  out:
>  	if (fn)
>  		fn(data, err);
> @@ -1179,18 +895,7 @@ static int alua_activate(struct scsi_device *sdev,
>   */
>  static void alua_check(struct scsi_device *sdev, bool force)
>  {
> -	struct alua_dh_data *h = sdev->handler_data;
> -	struct alua_port_group *pg;
> -
> -	rcu_read_lock();
> -	pg = rcu_dereference(h->pg);
> -	if (!pg || !kref_get_unless_zero(&pg->kref)) {
> -		rcu_read_unlock();
> -		return;
> -	}
> -	rcu_read_unlock();
> -	alua_rtpg_queue(pg, sdev, NULL, force);
> -	kref_put(&pg->kref, release_port_group);
> +	alua_rtpg_queue(sdev, NULL, force);
>  }
>  
>  /*
> @@ -1202,14 +907,12 @@ static void alua_check(struct scsi_device *sdev, bool force)
>  static blk_status_t alua_prep_fn(struct scsi_device *sdev, struct request *req)
>  {
>  	struct alua_dh_data *h = sdev->handler_data;
> -	struct alua_port_group *pg;
> -	unsigned char state = SCSI_ACCESS_STATE_OPTIMAL;
> +	unsigned long flags;
> +	unsigned char state;
>  
> -	rcu_read_lock();
> -	pg = rcu_dereference(h->pg);
> -	if (pg)
> -		state = pg->state;
> -	rcu_read_unlock();
> +	spin_lock_irqsave(&h->lock, flags);
> +	state = h->state;
> +	spin_unlock_irqrestore(&h->lock, flags);
>  
>  	switch (state) {
>  	case SCSI_ACCESS_STATE_OPTIMAL:
> @@ -1242,20 +945,26 @@ static int alua_bus_attach(struct scsi_device *sdev)
>  	h = kzalloc_obj(*h);
>  	if (!h)
>  		return SCSI_DH_NOMEM;
> -	spin_lock_init(&h->pg_lock);
> -	rcu_assign_pointer(h->pg, NULL);
> +	spin_lock_init(&h->lock);
>  	h->init_error = SCSI_DH_OK;
>  	h->sdev = sdev;
> -	INIT_LIST_HEAD(&h->node);
> +	INIT_DELAYED_WORK(&h->rtpg_work, alua_rtpg_work);
> +	INIT_LIST_HEAD(&h->rtpg_list);
>  
>  	mutex_init(&h->init_mutex);
> +
> +	h->state = SCSI_ACCESS_STATE_OPTIMAL;
> +	h->valid_states = TPGS_SUPPORT_ALL;
> +	if (optimize_stpg)
> +		h->flags |= ALUA_OPTIMIZE_STPG;
> +
> +	sdev->handler_data = h;
>  	err = alua_initialize(sdev, h);
>  	if (err != SCSI_DH_OK && err != SCSI_DH_DEV_OFFLINED)
>  		goto failed;
> -
> -	sdev->handler_data = h;
>  	return SCSI_DH_OK;
>  failed:
> +	sdev->handler_data = NULL;
>  	kfree(h);
>  	return err;
>  }
> @@ -1267,20 +976,8 @@ static int alua_bus_attach(struct scsi_device *sdev)
>  static void alua_bus_detach(struct scsi_device *sdev)
>  {
>  	struct alua_dh_data *h = sdev->handler_data;
> -	struct alua_port_group *pg;
> -
> -	spin_lock(&h->pg_lock);
> -	pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
> -	rcu_assign_pointer(h->pg, NULL);
> -	spin_unlock(&h->pg_lock);
> -	if (pg) {
> -		spin_lock_irq(&pg->lock);
> -		list_del_rcu(&h->node);
> -		spin_unlock_irq(&pg->lock);
> -		kref_put(&pg->kref, release_port_group);
> -	}
> +
>  	sdev->handler_data = NULL;
> -	synchronize_rcu();
>  	kfree(h);
>  }
>  
> -- 
> 2.43.5

