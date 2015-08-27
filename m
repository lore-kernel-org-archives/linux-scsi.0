From: Calvin Owens <calvinowens@fb.com>
Subject: Re: [PATCH 1/2] mpt3sas: Refcount sas_device objects and fix unsafe
 list usage
Date: Wed, 26 Aug 2015 19:20:16 -0700
Message-ID: <20150827022016.GA12951@mail.thefacebook.com>
References: <1440562184-23945-1-git-send-email-nab@daterainc.com>
 <1440562184-23945-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1440562184-23945-2-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, "MPT-FusionLinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 08/26 at 04:09 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> These objects can be referenced concurrently throughout the driver, we
> need a way to make sure threads can't delete them out from under
> each other. This patch adds the refcount, and refactors the code to use
> it.
> 
> Additionally, we cannot iterate over the sas_device_list without
> holding the lock, or we risk corrupting random memory if items are
> added or deleted as we iterate. This patch refactors _scsih_probe_sas()
> to use the sas_device_list in a safe way.
> 
> This patch is a port of Calvin's PATCH-v4 for mpt2sas code.
> 
> Cc: Calvin Owens <calvinowens@fb.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
> Cc: MPT-FusionLinux.pdl <MPT-FusionLinux.pdl@avagotech.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.h      |  23 +-
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 476 +++++++++++++++++++++----------
>  drivers/scsi/mpt3sas/mpt3sas_transport.c |  12 +-
>  3 files changed, 355 insertions(+), 156 deletions(-)

Looks good, thanks again for this.

Reviewed-by: Calvin Owens <calvinowens@fb.com>
 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index afa8816..fe29ac0 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -209,6 +209,7 @@ struct Mpi2ManufacturingPage11_t {
>   * @flags: MPT_TARGET_FLAGS_XXX flags
>   * @deleted: target flaged for deletion
>   * @tm_busy: target is busy with TM request.
> + * @sdev: The sas_device associated with this target
>   */
>  struct MPT3SAS_TARGET {
>  	struct scsi_target *starget;
> @@ -218,6 +219,7 @@ struct MPT3SAS_TARGET {
>  	u32	flags;
>  	u8	deleted;
>  	u8	tm_busy;
> +	struct _sas_device *sdev;
>  };
>  
>  
> @@ -294,6 +296,7 @@ struct _internal_cmd {
>   * @responding: used in _scsih_sas_device_mark_responding
>   * @fast_path: fast path feature enable bit
>   * @pfa_led_on: flag for PFA LED status
> + * @refcount: reference count for deletion
>   *
>   */
>  struct _sas_device {
> @@ -315,8 +318,24 @@ struct _sas_device {
>  	u8	responding;
>  	u8	fast_path;
>  	u8	pfa_led_on;
> +	struct kref refcount;
>  };
>  
> +static inline void sas_device_get(struct _sas_device *s)
> +{
> +	kref_get(&s->refcount);
> +}
> +
> +static inline void sas_device_free(struct kref *r)
> +{
> +	kfree(container_of(r, struct _sas_device, refcount));
> +}
> +
> +static inline void sas_device_put(struct _sas_device *s)
> +{
> +	kref_put(&s->refcount, sas_device_free);
> +}
> +
>  /**
>   * struct _raid_device - raid volume link list
>   * @list: sas device list
> @@ -1043,7 +1062,9 @@ struct _sas_node *mpt3sas_scsih_expander_find_by_handle(
>  	struct MPT3SAS_ADAPTER *ioc, u16 handle);
>  struct _sas_node *mpt3sas_scsih_expander_find_by_sas_address(
>  	struct MPT3SAS_ADAPTER *ioc, u64 sas_address);
> -struct _sas_device *mpt3sas_scsih_sas_device_find_by_sas_address(
> +struct _sas_device *mpt3sas_get_sdev_by_addr(
> +	 struct MPT3SAS_ADAPTER *ioc, u64 sas_address);
> +struct _sas_device *__mpt3sas_get_sdev_by_addr(
>  	struct MPT3SAS_ADAPTER *ioc, u64 sas_address);
>  
>  void mpt3sas_port_enable_complete(struct MPT3SAS_ADAPTER *ioc);
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 5a97e32..7142e3b 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -518,8 +518,61 @@ _scsih_determine_boot_device(struct MPT3SAS_ADAPTER *ioc,
>  	}
>  }
>  
> +static struct _sas_device *
> +__mpt3sas_get_sdev_from_target(struct MPT3SAS_ADAPTER *ioc,
> +	struct MPT3SAS_TARGET *tgt_priv)
> +{
> +	struct _sas_device *ret;
> +
> +	assert_spin_locked(&ioc->sas_device_lock);
> +
> +	ret = tgt_priv->sdev;
> +	if (ret)
> +		sas_device_get(ret);
> +
> +	return ret;
> +}
> +
> +static struct _sas_device *
> +mpt3sas_get_sdev_from_target(struct MPT3SAS_ADAPTER *ioc,
> +	struct MPT3SAS_TARGET *tgt_priv)
> +{
> +	struct _sas_device *ret;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> +	ret = __mpt3sas_get_sdev_from_target(ioc, tgt_priv);
> +	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +
> +	return ret;
> +}
> +
> +struct _sas_device *
> +__mpt3sas_get_sdev_by_addr(struct MPT3SAS_ADAPTER *ioc,
> +	u64 sas_address)
> +{
> +	struct _sas_device *sas_device;
> +
> +	assert_spin_locked(&ioc->sas_device_lock);
> +
> +	list_for_each_entry(sas_device, &ioc->sas_device_list, list)
> +		if (sas_device->sas_address == sas_address)
> +			goto found_device;
> +
> +	list_for_each_entry(sas_device, &ioc->sas_device_init_list, list)
> +		if (sas_device->sas_address == sas_address)
> +			goto found_device;
> +
> +	return NULL;
> +
> +found_device:
> +	sas_device_get(sas_device);
> +	return sas_device;
> +}
> +
> +
>  /**
> - * mpt3sas_scsih_sas_device_find_by_sas_address - sas device search
> + * mpt3sas_get_sdev_by_addr - sas device search
>   * @ioc: per adapter object
>   * @sas_address: sas address
>   * Context: Calling function should acquire ioc->sas_device_lock
> @@ -528,24 +581,44 @@ _scsih_determine_boot_device(struct MPT3SAS_ADAPTER *ioc,
>   * object.
>   */
>  struct _sas_device *
> -mpt3sas_scsih_sas_device_find_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
> +mpt3sas_get_sdev_by_addr(struct MPT3SAS_ADAPTER *ioc,
>  	u64 sas_address)
>  {
>  	struct _sas_device *sas_device;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> +	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
> +			sas_address);
> +	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +
> +	return sas_device;
> +}
> +
> +static struct _sas_device *
> +__mpt3sas_get_sdev_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
> +{
> +	struct _sas_device *sas_device;
> +
> +	assert_spin_locked(&ioc->sas_device_lock);
>  
>  	list_for_each_entry(sas_device, &ioc->sas_device_list, list)
> -		if (sas_device->sas_address == sas_address)
> -			return sas_device;
> +		if (sas_device->handle == handle)
> +			goto found_device;
>  
>  	list_for_each_entry(sas_device, &ioc->sas_device_init_list, list)
> -		if (sas_device->sas_address == sas_address)
> -			return sas_device;
> +		if (sas_device->handle == handle)
> +			goto found_device;
>  
>  	return NULL;
> +
> +found_device:
> +	sas_device_get(sas_device);
> +	return sas_device;
>  }
>  
>  /**
> - * _scsih_sas_device_find_by_handle - sas device search
> + * mpt3sas_get_sdev_by_handle - sas device search
>   * @ioc: per adapter object
>   * @handle: sas device handle (assigned by firmware)
>   * Context: Calling function should acquire ioc->sas_device_lock
> @@ -554,19 +627,16 @@ mpt3sas_scsih_sas_device_find_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
>   * object.
>   */
>  static struct _sas_device *
> -_scsih_sas_device_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
> +mpt3sas_get_sdev_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
>  {
>  	struct _sas_device *sas_device;
> +	unsigned long flags;
>  
> -	list_for_each_entry(sas_device, &ioc->sas_device_list, list)
> -		if (sas_device->handle == handle)
> -			return sas_device;
> -
> -	list_for_each_entry(sas_device, &ioc->sas_device_init_list, list)
> -		if (sas_device->handle == handle)
> -			return sas_device;
> +	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> +	sas_device = __mpt3sas_get_sdev_by_handle(ioc, handle);
> +	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  
> -	return NULL;
> +	return sas_device;
>  }
>  
>  /**
> @@ -575,7 +645,7 @@ _scsih_sas_device_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
>   * @sas_device: the sas_device object
>   * Context: This function will acquire ioc->sas_device_lock.
>   *
> - * Removing object and freeing associated memory from the ioc->sas_device_list.
> + * If sas_device is on the list, remove it and decrement its reference count.
>   */
>  static void
>  _scsih_sas_device_remove(struct MPT3SAS_ADAPTER *ioc,
> @@ -585,10 +655,15 @@ _scsih_sas_device_remove(struct MPT3SAS_ADAPTER *ioc,
>  
>  	if (!sas_device)
>  		return;
> -
> +	/*
> +	 * The lock serializes access to the list, but we still need to verify
> +	 * that nobody removed the entry while we were waiting on the lock.
> +	 */
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	list_del(&sas_device->list);
> -	kfree(sas_device);
> +	if (!list_empty(&sas_device->list)) {
> +		list_del_init(&sas_device->list);
> +		sas_device_put(sas_device);
> +	}
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  }
>  
> @@ -609,12 +684,17 @@ _scsih_device_remove_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
>  		return;
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> -	if (sas_device)
> -		list_del(&sas_device->list);
> +	sas_device = __mpt3sas_get_sdev_by_handle(ioc, handle);
> +	if (sas_device) {
> +		list_del_init(&sas_device->list);
> +		sas_device_put(sas_device);
> +	}
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -	if (sas_device)
> +
> +	if (sas_device) {
>  		_scsih_remove_device(ioc, sas_device);
> +		sas_device_put(sas_device);
> +	}
>  }
>  
>  /**
> @@ -635,13 +715,17 @@ mpt3sas_device_remove_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
>  		return;
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
> -	    sas_address);
> -	if (sas_device)
> -		list_del(&sas_device->list);
> +	sas_device = __mpt3sas_get_sdev_by_addr(ioc, sas_address);
> +	if (sas_device) {
> +		list_del_init(&sas_device->list);
> +		sas_device_put(sas_device);
> +	}
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -	if (sas_device)
> +
> +	if (sas_device) {
>  		_scsih_remove_device(ioc, sas_device);
> +		sas_device_put(sas_device);
> +	}
>  }
>  
>  /**
> @@ -664,6 +748,7 @@ _scsih_sas_device_add(struct MPT3SAS_ADAPTER *ioc,
>  		(unsigned long long)sas_device->sas_address));
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> +	sas_device_get(sas_device);
>  	list_add_tail(&sas_device->list, &ioc->sas_device_list);
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  
> @@ -705,6 +790,7 @@ _scsih_sas_device_init_add(struct MPT3SAS_ADAPTER *ioc,
>  		(unsigned long long)sas_device->sas_address));
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> +	sas_device_get(sas_device);
>  	list_add_tail(&sas_device->list, &ioc->sas_device_init_list);
>  	_scsih_determine_boot_device(ioc, sas_device, 0);
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> @@ -1083,12 +1169,15 @@ _scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
>  		goto not_sata;
>  	if ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME))
>  		goto not_sata;
> +
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
> -	   sas_device_priv_data->sas_target->sas_address);
> -	if (sas_device && sas_device->device_info &
> -	    MPI2_SAS_DEVICE_INFO_SATA_DEVICE)
> -		max_depth = MPT3SAS_SATA_QUEUE_DEPTH;
> +	sas_device = __mpt3sas_get_sdev_from_target(ioc, sas_target_priv_data);
> +	if (sas_device) {
> +		if (sas_device->device_info & MPI2_SAS_DEVICE_INFO_SATA_DEVICE)
> +			max_depth = MPT3SAS_SATA_QUEUE_DEPTH;
> +
> +		sas_device_put(sas_device);
> +	}
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  
>   not_sata:
> @@ -1145,12 +1234,13 @@ _scsih_target_alloc(struct scsi_target *starget)
>  	/* sas/sata devices */
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
>  	rphy = dev_to_rphy(starget->dev.parent);
> -	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
> +	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
>  	   rphy->identify.sas_address);
>  
>  	if (sas_device) {
>  		sas_target_priv_data->handle = sas_device->handle;
>  		sas_target_priv_data->sas_address = sas_device->sas_address;
> +		sas_target_priv_data->sdev = sas_device;
>  		sas_device->starget = starget;
>  		sas_device->id = starget->id;
>  		sas_device->channel = starget->channel;
> @@ -1200,13 +1290,21 @@ _scsih_target_destroy(struct scsi_target *starget)
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
>  	rphy = dev_to_rphy(starget->dev.parent);
> -	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
> -	   rphy->identify.sas_address);
> +	sas_device = __mpt3sas_get_sdev_from_target(ioc, sas_target_priv_data);
>  	if (sas_device && (sas_device->starget == starget) &&
>  	    (sas_device->id == starget->id) &&
>  	    (sas_device->channel == starget->channel))
>  		sas_device->starget = NULL;
>  
> +	if (sas_device) {
> +		/*
> +		 * Corresponding get() is in _scsih_target_alloc()
> +		 */
> +		sas_target_priv_data->sdev = NULL;
> +		sas_device_put(sas_device);
> +
> +		sas_device_put(sas_device);
> +	}
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  
>   out:
> @@ -1262,7 +1360,7 @@ _scsih_slave_alloc(struct scsi_device *sdev)
>  
>  	if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
>  		spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -		sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
> +		sas_device = __mpt3sas_get_sdev_by_addr(ioc,
>  					sas_target_priv_data->sas_address);
>  		if (sas_device && (sas_device->starget == NULL)) {
>  			sdev_printk(KERN_INFO, sdev,
> @@ -1270,6 +1368,10 @@ _scsih_slave_alloc(struct scsi_device *sdev)
>  				__func__, __LINE__);
>  			sas_device->starget = starget;
>  		}
> +
> +		if (sas_device)
> +			sas_device_put(sas_device);
> +
>  		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  	}
>  
> @@ -1304,10 +1406,14 @@ _scsih_slave_destroy(struct scsi_device *sdev)
>  
>  	if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
>  		spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -		sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
> -		   sas_target_priv_data->sas_address);
> +		sas_device = __mpt3sas_get_sdev_from_target(ioc,
> +				sas_target_priv_data);
>  		if (sas_device && !sas_target_priv_data->num_luns)
>  			sas_device->starget = NULL;
> +
> +		if (sas_device)
> +			sas_device_put(sas_device);
> +
>  		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  	}
>  
> @@ -1743,7 +1849,7 @@ _scsih_slave_configure(struct scsi_device *sdev)
>  	}
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
> +	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
>  	   sas_device_priv_data->sas_target->sas_address);
>  	if (!sas_device) {
>  		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> @@ -1777,12 +1883,12 @@ _scsih_slave_configure(struct scsi_device *sdev)
>  		ds, (unsigned long long)
>  	    sas_device->enclosure_logical_id, sas_device->slot);
>  
> +	sas_device_put(sas_device);
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  
>  	if (!ssp_target)
>  		_scsih_display_sata_capabilities(ioc, handle, sdev);
>  
> -
>  	_scsih_change_queue_depth(sdev, qdepth);
>  
>  	if (ssp_target) {
> @@ -2173,8 +2279,7 @@ _scsih_tm_display_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd)
>  		    device_str, (unsigned long long)priv_target->sas_address);
>  	} else {
>  		spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -		sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
> -		    priv_target->sas_address);
> +		sas_device = __mpt3sas_get_sdev_from_target(ioc, priv_target);
>  		if (sas_device) {
>  			if (priv_target->flags &
>  			    MPT_TARGET_FLAGS_RAID_COMPONENT) {
> @@ -2193,6 +2298,8 @@ _scsih_tm_display_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd)
>  			    "enclosure_logical_id(0x%016llx), slot(%d)\n",
>  			   (unsigned long long)sas_device->enclosure_logical_id,
>  			    sas_device->slot);
> +
> +			sas_device_put(sas_device);
>  		}
>  		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  	}
> @@ -2268,10 +2375,11 @@ _scsih_dev_reset(struct scsi_cmnd *scmd)
>  {
>  	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
>  	struct MPT3SAS_DEVICE *sas_device_priv_data;
> -	struct _sas_device *sas_device;
> -	unsigned long flags;
> +	struct _sas_device *sas_device = NULL;
>  	u16	handle;
>  	int r;
> +	struct scsi_target *starget = scmd->device->sdev_target;
> +	struct MPT3SAS_TARGET *target_priv_data = starget->hostdata;
>  
>  	sdev_printk(KERN_INFO, scmd->device,
>  		"attempting device reset! scmd(%p)\n", scmd);
> @@ -2291,12 +2399,10 @@ _scsih_dev_reset(struct scsi_cmnd *scmd)
>  	handle = 0;
>  	if (sas_device_priv_data->sas_target->flags &
>  	    MPT_TARGET_FLAGS_RAID_COMPONENT) {
> -		spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -		sas_device = _scsih_sas_device_find_by_handle(ioc,
> -		   sas_device_priv_data->sas_target->handle);
> +		sas_device = mpt3sas_get_sdev_from_target(ioc,
> +				target_priv_data);
>  		if (sas_device)
>  			handle = sas_device->volume_handle;
> -		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  	} else
>  		handle = sas_device_priv_data->sas_target->handle;
>  
> @@ -2313,6 +2419,10 @@ _scsih_dev_reset(struct scsi_cmnd *scmd)
>   out:
>  	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(%p)\n",
>  	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +
> +	if (sas_device)
> +		sas_device_put(sas_device);
> +
>  	return r;
>  }
>  
> @@ -2327,11 +2437,11 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
>  {
>  	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
>  	struct MPT3SAS_DEVICE *sas_device_priv_data;
> -	struct _sas_device *sas_device;
> -	unsigned long flags;
> +	struct _sas_device *sas_device = NULL;
>  	u16	handle;
>  	int r;
>  	struct scsi_target *starget = scmd->device->sdev_target;
> +	struct MPT3SAS_TARGET *target_priv_data = starget->hostdata;
>  
>  	starget_printk(KERN_INFO, starget, "attempting target reset! scmd(%p)\n",
>  		scmd);
> @@ -2351,12 +2461,10 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
>  	handle = 0;
>  	if (sas_device_priv_data->sas_target->flags &
>  	    MPT_TARGET_FLAGS_RAID_COMPONENT) {
> -		spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -		sas_device = _scsih_sas_device_find_by_handle(ioc,
> -		   sas_device_priv_data->sas_target->handle);
> +		sas_device = mpt3sas_get_sdev_from_target(ioc,
> +				target_priv_data);
>  		if (sas_device)
>  			handle = sas_device->volume_handle;
> -		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  	} else
>  		handle = sas_device_priv_data->sas_target->handle;
>  
> @@ -2373,6 +2481,10 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
>   out:
>  	starget_printk(KERN_INFO, starget, "target reset: %s scmd(%p)\n",
>  	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +
> +	if (sas_device)
> +		sas_device_put(sas_device);
> +
>  	return r;
>  }
>  
> @@ -2683,15 +2795,15 @@ _scsih_block_io_to_children_attached_to_ex(struct MPT3SAS_ADAPTER *ioc,
>  
>  	list_for_each_entry(mpt3sas_port,
>  	   &sas_expander->sas_port_list, port_list) {
> -		if (mpt3sas_port->remote_identify.device_type ==
> -		    SAS_END_DEVICE) {
> +		if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
>  			spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -			sas_device =
> -			    mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
> -			   mpt3sas_port->remote_identify.sas_address);
> -			if (sas_device)
> +			sas_device = __mpt3sas_get_sdev_by_addr(ioc,
> +					mpt3sas_port->remote_identify.sas_address);
> +			if (sas_device) {
>  				set_bit(sas_device->handle,
> -				    ioc->blocking_handles);
> +					ioc->blocking_handles);
> +				sas_device_put(sas_device);
> +			}
>  			spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  		}
>  	}
> @@ -2759,7 +2871,7 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
>  {
>  	Mpi2SCSITaskManagementRequest_t *mpi_request;
>  	u16 smid;
> -	struct _sas_device *sas_device;
> +	struct _sas_device *sas_device = NULL;
>  	struct MPT3SAS_TARGET *sas_target_priv_data = NULL;
>  	u64 sas_address = 0;
>  	unsigned long flags;
> @@ -2792,7 +2904,7 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
>  		return;
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> +	sas_device = __mpt3sas_get_sdev_by_handle(ioc, handle);
>  	if (sas_device && sas_device->starget &&
>  	    sas_device->starget->hostdata) {
>  		sas_target_priv_data = sas_device->starget->hostdata;
> @@ -2814,14 +2926,14 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
>  	if (!smid) {
>  		delayed_tr = kzalloc(sizeof(*delayed_tr), GFP_ATOMIC);
>  		if (!delayed_tr)
> -			return;
> +			goto out;
>  		INIT_LIST_HEAD(&delayed_tr->list);
>  		delayed_tr->handle = handle;
>  		list_add_tail(&delayed_tr->list, &ioc->delayed_tr_list);
>  		dewtprintk(ioc, pr_info(MPT3SAS_FMT
>  		    "DELAYED:tr:handle(0x%04x), (open)\n",
>  		    ioc->name, handle));
> -		return;
> +		goto out;
>  	}
>  
>  	dewtprintk(ioc, pr_info(MPT3SAS_FMT
> @@ -2835,6 +2947,9 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
>  	mpi_request->TaskType = MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
>  	mpt3sas_base_put_smid_hi_priority(ioc, smid);
>  	mpt3sas_trigger_master(ioc, MASTER_TRIGGER_DEVICE_REMOVAL);
> +out:
> +	if (sas_device)
> +		sas_device_put(sas_device);
>  }
>  
>  /**
> @@ -3685,7 +3800,6 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
>  	char *desc_scsi_state = ioc->tmp_string;
>  	u32 log_info = le32_to_cpu(mpi_reply->IOCLogInfo);
>  	struct _sas_device *sas_device = NULL;
> -	unsigned long flags;
>  	struct scsi_target *starget = scmd->device->sdev_target;
>  	struct MPT3SAS_TARGET *priv_target = starget->hostdata;
>  	char *device_str = NULL;
> @@ -3813,9 +3927,7 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
>  		pr_warn(MPT3SAS_FMT "\t%s wwid(0x%016llx)\n", ioc->name,
>  		    device_str, (unsigned long long)priv_target->sas_address);
>  	} else {
> -		spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -		sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
> -		    priv_target->sas_address);
> +		sas_device = mpt3sas_get_sdev_from_target(ioc, priv_target);
>  		if (sas_device) {
>  			pr_warn(MPT3SAS_FMT
>  				"\tsas_address(0x%016llx), phy(%d)\n",
> @@ -3825,8 +3937,9 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
>  			    "\tenclosure_logical_id(0x%016llx), slot(%d)\n",
>  			    ioc->name, (unsigned long long)
>  			    sas_device->enclosure_logical_id, sas_device->slot);
> +
> +			sas_device_put(sas_device);
>  		}
> -		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  	}
>  
>  	pr_warn(MPT3SAS_FMT
> @@ -3878,7 +3991,7 @@ _scsih_turn_on_pfa_led(struct MPT3SAS_ADAPTER *ioc, u16 handle)
>  	Mpi2SepRequest_t mpi_request;
>  	struct _sas_device *sas_device;
>  
> -	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> +	sas_device = mpt3sas_get_sdev_by_handle(ioc, handle);
>  	if (!sas_device)
>  		return;
>  
> @@ -3893,7 +4006,7 @@ _scsih_turn_on_pfa_led(struct MPT3SAS_ADAPTER *ioc, u16 handle)
>  	    &mpi_request)) != 0) {
>  		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n", ioc->name,
>  		__FILE__, __LINE__, __func__);
> -		return;
> +		goto out;
>  	}
>  	sas_device->pfa_led_on = 1;
>  
> @@ -3902,8 +4015,10 @@ _scsih_turn_on_pfa_led(struct MPT3SAS_ADAPTER *ioc, u16 handle)
>  			"enclosure_processor: ioc_status (0x%04x), loginfo(0x%08x)\n",
>  			ioc->name, le16_to_cpu(mpi_reply.IOCStatus),
>  		    le32_to_cpu(mpi_reply.IOCLogInfo)));
> -		return;
> +		goto out;
>  	}
> +out:
> +	sas_device_put(sas_device);
>  }
>  /**
>   * _scsih_turn_off_pfa_led - turn off Fault LED
> @@ -3986,19 +4101,17 @@ _scsih_smart_predicted_fault(struct MPT3SAS_ADAPTER *ioc, u16 handle)
>  
>  	/* only handle non-raid devices */
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> +	sas_device = __mpt3sas_get_sdev_by_handle(ioc, handle);
>  	if (!sas_device) {
> -		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -		return;
> +		goto out_unlock;
>  	}
>  	starget = sas_device->starget;
>  	sas_target_priv_data = starget->hostdata;
>  
>  	if ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_RAID_COMPONENT) ||
> -	   ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME))) {
> -		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -		return;
> -	}
> +	   ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)))
> +		goto out_unlock;
> +
>  	starget_printk(KERN_WARNING, starget, "predicted fault\n");
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  
> @@ -4012,7 +4125,7 @@ _scsih_smart_predicted_fault(struct MPT3SAS_ADAPTER *ioc, u16 handle)
>  	if (!event_reply) {
>  		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
>  		    ioc->name, __FILE__, __LINE__, __func__);
> -		return;
> +		goto out;
>  	}
>  
>  	event_reply->Function = MPI2_FUNCTION_EVENT_NOTIFICATION;
> @@ -4029,6 +4142,14 @@ _scsih_smart_predicted_fault(struct MPT3SAS_ADAPTER *ioc, u16 handle)
>  	event_data->SASAddress = cpu_to_le64(sas_target_priv_data->sas_address);
>  	mpt3sas_ctl_add_to_event_log(ioc, event_reply);
>  	kfree(event_reply);
> +out:
> +	if (sas_device)
> +		sas_device_put(sas_device);
> +	return;
> +
> +out_unlock:
> +	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +	goto out;
>  }
>  
>  /**
> @@ -4772,13 +4893,11 @@ _scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
>  	sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
> -	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
> +	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
>  	    sas_address);
>  
> -	if (!sas_device) {
> -		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -		return;
> -	}
> +	if (!sas_device)
> +		goto out_unlock;
>  
>  	if (unlikely(sas_device->handle != handle)) {
>  		starget = sas_device->starget;
> @@ -4796,20 +4915,24 @@ _scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
>  		pr_err(MPT3SAS_FMT
>  			"device is not present handle(0x%04x), flags!!!\n",
>  			ioc->name, handle);
> -		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -		return;
> +		goto out_unlock;
>  	}
>  
>  	/* check if there were any issues with discovery */
>  	if (_scsih_check_access_status(ioc, sas_address, handle,
> -	    sas_device_pg0.AccessStatus)) {
> -		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -		return;
> -	}
> +	    sas_device_pg0.AccessStatus))
> +		goto out_unlock;
>  
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  	_scsih_ublock_io_device(ioc, sas_address);
> +	if (sas_device)
> +		sas_device_put(sas_device);
> +	return;
>  
> +out_unlock:
> +	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +	if (sas_device)
> +		sas_device_put(sas_device);
>  }
>  
>  /**
> @@ -4834,7 +4957,6 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
>  	u32 ioc_status;
>  	u64 sas_address;
>  	u32 device_info;
> -	unsigned long flags;
>  
>  	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
>  	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
> @@ -4870,13 +4992,11 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
>  	    sas_device_pg0.AccessStatus))
>  		return -1;
>  
> -	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
> -	    sas_address);
> -	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -
> -	if (sas_device)
> +	sas_device = mpt3sas_get_sdev_by_addr(ioc, sas_address);
> +	if (sas_device) {
> +		sas_device_put(sas_device);
>  		return -1;
> +	}
>  
>  	sas_device = kzalloc(sizeof(struct _sas_device),
>  	    GFP_KERNEL);
> @@ -4886,6 +5006,7 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
>  		return 0;
>  	}
>  
> +	kref_init(&sas_device->refcount);
>  	sas_device->handle = handle;
>  	if (_scsih_get_sas_address(ioc,
>  	    le16_to_cpu(sas_device_pg0.ParentDevHandle),
> @@ -4917,6 +5038,7 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
>  	else
>  		_scsih_sas_device_add(ioc, sas_device);
>  
> +	sas_device_put(sas_device);
>  	return 0;
>  }
>  
> @@ -4965,8 +5087,6 @@ _scsih_remove_device(struct MPT3SAS_ADAPTER *ioc,
>  		ioc->name, __func__,
>  	    sas_device->handle, (unsigned long long)
>  	    sas_device->sas_address));
> -
> -	kfree(sas_device);
>  }
>  
>  #ifdef CONFIG_SCSI_MPT3SAS_LOGGING
> @@ -5291,25 +5411,25 @@ _scsih_sas_device_status_change_event(struct MPT3SAS_ADAPTER *ioc,
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
>  	sas_address = le64_to_cpu(event_data->SASAddress);
> -	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
> -	    sas_address);
> +	sas_device = __mpt3sas_get_sdev_by_addr(ioc, sas_address);
>  
> -	if (!sas_device || !sas_device->starget) {
> -		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -		return;
> -	}
> +	if (!sas_device || !sas_device->starget)
> +		goto out;
>  
>  	target_priv_data = sas_device->starget->hostdata;
> -	if (!target_priv_data) {
> -		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -		return;
> -	}
> +	if (!target_priv_data)
> +		goto out;
>  
>  	if (event_data->ReasonCode ==
>  	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET)
>  		target_priv_data->tm_busy = 1;
>  	else
>  		target_priv_data->tm_busy = 0;
> +
> +out:
> +	if (sas_device)
> +		sas_device_put(sas_device);
> +
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  }
>  
> @@ -5793,7 +5913,7 @@ _scsih_sas_pd_expose(struct MPT3SAS_ADAPTER *ioc,
>  	u16 handle = le16_to_cpu(element->PhysDiskDevHandle);
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> +	sas_device = __mpt3sas_get_sdev_by_handle(ioc, handle);
>  	if (sas_device) {
>  		sas_device->volume_handle = 0;
>  		sas_device->volume_wwid = 0;
> @@ -5812,6 +5932,8 @@ _scsih_sas_pd_expose(struct MPT3SAS_ADAPTER *ioc,
>  	/* exposing raid component */
>  	if (starget)
>  		starget_for_each_device(starget, NULL, _scsih_reprobe_lun);
> +
> +	sas_device_put(sas_device);
>  }
>  
>  /**
> @@ -5840,7 +5962,7 @@ _scsih_sas_pd_hide(struct MPT3SAS_ADAPTER *ioc,
>  		    &volume_wwid);
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> +	sas_device = __mpt3sas_get_sdev_by_handle(ioc, handle);
>  	if (sas_device) {
>  		set_bit(handle, ioc->pd_handles);
>  		if (sas_device->starget && sas_device->starget->hostdata) {
> @@ -5860,6 +5982,8 @@ _scsih_sas_pd_hide(struct MPT3SAS_ADAPTER *ioc,
>  	_scsih_ir_fastpath(ioc, handle, element->PhysDiskNum);
>  	if (starget)
>  		starget_for_each_device(starget, (void *)1, _scsih_reprobe_lun);
> +
> +	sas_device_put(sas_device);
>  }
>  
>  /**
> @@ -5892,7 +6016,6 @@ _scsih_sas_pd_add(struct MPT3SAS_ADAPTER *ioc,
>  	Mpi2EventIrConfigElement_t *element)
>  {
>  	struct _sas_device *sas_device;
> -	unsigned long flags;
>  	u16 handle = le16_to_cpu(element->PhysDiskDevHandle);
>  	Mpi2ConfigReply_t mpi_reply;
>  	Mpi2SasDevicePage0_t sas_device_pg0;
> @@ -5902,11 +6025,10 @@ _scsih_sas_pd_add(struct MPT3SAS_ADAPTER *ioc,
>  
>  	set_bit(handle, ioc->pd_handles);
>  
> -	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> -	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +	sas_device = mpt3sas_get_sdev_by_handle(ioc, handle);
>  	if (sas_device) {
>  		_scsih_ir_fastpath(ioc, handle, element->PhysDiskNum);
> +		sas_device_put(sas_device);
>  		return;
>  	}
>  
> @@ -6183,7 +6305,6 @@ _scsih_sas_ir_physical_disk_event(struct MPT3SAS_ADAPTER *ioc,
>  	u16 handle, parent_handle;
>  	u32 state;
>  	struct _sas_device *sas_device;
> -	unsigned long flags;
>  	Mpi2ConfigReply_t mpi_reply;
>  	Mpi2SasDevicePage0_t sas_device_pg0;
>  	u32 ioc_status;
> @@ -6212,12 +6333,12 @@ _scsih_sas_ir_physical_disk_event(struct MPT3SAS_ADAPTER *ioc,
>  	case MPI2_RAID_PD_STATE_HOT_SPARE:
>  
>  		set_bit(handle, ioc->pd_handles);
> -		spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -		sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> -		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  
> -		if (sas_device)
> +		sas_device = mpt3sas_get_sdev_by_handle(ioc, handle);
> +		if (sas_device) {
> +			sas_device_put(sas_device);
>  			return;
> +		}
>  
>  		if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply,
>  		    &sas_device_pg0, MPI2_SAS_DEVICE_PGAD_FORM_HANDLE,
> @@ -6673,6 +6794,7 @@ _scsih_remove_unresponding_sas_devices(struct MPT3SAS_ADAPTER *ioc)
>  	struct _raid_device *raid_device, *raid_device_next;
>  	struct list_head tmp_list;
>  	unsigned long flags;
> +	LIST_HEAD(head);
>  
>  	pr_info(MPT3SAS_FMT "removing unresponding devices: start\n",
>  	    ioc->name);
> @@ -6680,14 +6802,29 @@ _scsih_remove_unresponding_sas_devices(struct MPT3SAS_ADAPTER *ioc)
>  	/* removing unresponding end devices */
>  	pr_info(MPT3SAS_FMT "removing unresponding devices: end-devices\n",
>  	    ioc->name);
> +
> +	/*
> +	 * Iterate, pulling off devices marked as non-responding. We become the
> +	 * owner for the reference the list had on any object we prune.
> +	 */
> +	spin_lock_irqsave(&ioc->sas_device_lock, flags);
>  	list_for_each_entry_safe(sas_device, sas_device_next,
> -	    &ioc->sas_device_list, list) {
> +				 &ioc->sas_device_list, list) {
>  		if (!sas_device->responding)
> -			mpt3sas_device_remove_by_sas_address(ioc,
> -			    sas_device->sas_address);
> +			list_move_tail(&sas_device->list, &head);
>  		else
>  			sas_device->responding = 0;
>  	}
> +	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +
> +	/*
> +	 * Now, uninitialize and remove the unresponding devices we pruned.
> +	 */
> +	list_for_each_entry_safe(sas_device, sas_device_next, &head, list) {
> +		_scsih_remove_device(ioc, sas_device);
> +		list_del_init(&sas_device->list);
> +		sas_device_put(sas_device);
> +	}
>  
>  	/* removing unresponding volumes */
>  	if (ioc->ir_firmware) {
> @@ -6841,11 +6978,11 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
>  		}
>  		phys_disk_num = pd_pg0.PhysDiskNum;
>  		handle = le16_to_cpu(pd_pg0.DevHandle);
> -		spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -		sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> -		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -		if (sas_device)
> +		sas_device = mpt3sas_get_sdev_by_handle(ioc, handle);
> +		if (sas_device) {
> +			sas_device_put(sas_device);
>  			continue;
> +		}
>  		if (mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply,
>  		    &sas_device_pg0, MPI2_SAS_DEVICE_PGAD_FORM_HANDLE,
>  		    handle) != 0)
> @@ -6966,12 +7103,12 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
>  		if (!(_scsih_is_end_device(
>  		    le32_to_cpu(sas_device_pg0.DeviceInfo))))
>  			continue;
> -		spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -		sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
> +		sas_device = mpt3sas_get_sdev_by_addr(ioc,
>  		    le64_to_cpu(sas_device_pg0.SASAddress));
> -		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -		if (sas_device)
> +		if (sas_device) {
> +			sas_device_put(sas_device);
>  			continue;
> +		}
>  		parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
>  		if (!_scsih_get_sas_address(ioc, parent_handle, &sas_address)) {
>  			pr_info(MPT3SAS_FMT "\tBEFORE adding end device: " \
> @@ -7598,6 +7735,48 @@ _scsih_probe_raid(struct MPT3SAS_ADAPTER *ioc)
>  	}
>  }
>  
> +static struct _sas_device *get_next_sas_device(struct MPT3SAS_ADAPTER *ioc)
> +{
> +	struct _sas_device *sas_device = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> +	if (!list_empty(&ioc->sas_device_init_list)) {
> +		sas_device = list_first_entry(&ioc->sas_device_init_list,
> +				struct _sas_device, list);
> +		sas_device_get(sas_device);
> +	}
> +	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +
> +	return sas_device;
> +}
> +
> +static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
> +		struct _sas_device *sas_device)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> +
> +	/*
> +	 * Since we dropped the lock during the call to port_add(), we need to
> +	 * be careful here that somebody else didn't move or delete this item
> +	 * while we were busy with other things.
> +	 *
> +	 * If it was on the list, we need a put() for the reference the list
> +	 * had. Either way, we need a get() for the destination list.
> +	 */
> +	if (!list_empty(&sas_device->list)) {
> +		list_del_init(&sas_device->list);
> +		sas_device_put(sas_device);
> +	}
> +
> +	sas_device_get(sas_device);
> +	list_add_tail(&sas_device->list, &ioc->sas_device_list);
> +
> +	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +}
> +
>  /**
>   * _scsih_probe_sas - reporting sas devices to sas transport
>   * @ioc: per adapter object
> @@ -7607,17 +7786,13 @@ _scsih_probe_raid(struct MPT3SAS_ADAPTER *ioc)
>  static void
>  _scsih_probe_sas(struct MPT3SAS_ADAPTER *ioc)
>  {
> -	struct _sas_device *sas_device, *next;
> -	unsigned long flags;
> -
> -	/* SAS Device List */
> -	list_for_each_entry_safe(sas_device, next, &ioc->sas_device_init_list,
> -	    list) {
> +	struct _sas_device *sas_device;
>  
> +	while ((sas_device = get_next_sas_device(ioc))) {
>  		if (!mpt3sas_transport_port_add(ioc, sas_device->handle,
> -		    sas_device->sas_address_parent)) {
> -			list_del(&sas_device->list);
> -			kfree(sas_device);
> +				sas_device->sas_address_parent)) {
> +			_scsih_sas_device_remove(ioc, sas_device);
> +			sas_device_put(sas_device);
>  			continue;
>  		} else if (!sas_device->starget) {
>  			/*
> @@ -7628,17 +7803,16 @@ _scsih_probe_sas(struct MPT3SAS_ADAPTER *ioc)
>  			 */
>  			if (!ioc->is_driver_loading) {
>  				mpt3sas_transport_port_remove(ioc,
> -				    sas_device->sas_address,
> -				    sas_device->sas_address_parent);
> -				list_del(&sas_device->list);
> -				kfree(sas_device);
> +						sas_device->sas_address,
> +						sas_device->sas_address_parent);
> +				_scsih_sas_device_remove(ioc, sas_device);
> +				sas_device_put(sas_device);
>  				continue;
>  			}
>  		}
>  
> -		spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -		list_move_tail(&sas_device->list, &ioc->sas_device_list);
> -		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +		sas_device_make_active(ioc, sas_device);
> +		sas_device_put(sas_device);
>  	}
>  }
>  
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
> index efb98af..2f9d038 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
> @@ -1306,15 +1306,17 @@ _transport_get_enclosure_identifier(struct sas_rphy *rphy, u64 *identifier)
>  	int rc;
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
> +	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
>  	    rphy->identify.sas_address);
>  	if (sas_device) {
>  		*identifier = sas_device->enclosure_logical_id;
>  		rc = 0;
> +		sas_device_put(sas_device);
>  	} else {
>  		*identifier = 0;
>  		rc = -ENXIO;
>  	}
> +
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  	return rc;
>  }
> @@ -1334,12 +1336,14 @@ _transport_get_bay_identifier(struct sas_rphy *rphy)
>  	int rc;
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
> +	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
>  	    rphy->identify.sas_address);
> -	if (sas_device)
> +	if (sas_device) {
>  		rc = sas_device->slot;
> -	else
> +		sas_device_put(sas_device);
> +	} else {
>  		rc = -ENXIO;
> +	}
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  	return rc;
>  }
> -- 
> 1.9.1
> 
