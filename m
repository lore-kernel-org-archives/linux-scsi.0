From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] Refactor code to use new sas_device refcount
Date: Fri, 3 Jul 2015 08:38:03 -0700
Message-ID: <20150703153803.GB4472@infradead.org>
References: <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
 <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
 <1433821856-2815280-3-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1433821856-2815280-3-git-send-email-calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

>  
> +struct _sas_device *
> +mpt2sas_scsih_sas_device_get_by_sas_address_nolock(struct MPT2SAS_ADAPTER *ioc,
> +    u64 sas_address)

Any chance to use a shorter name for this function? E.g.
__mpt2sas_get_sdev_by_addr ?

> +{
> +	struct _sas_device *sas_device;
> +
> +	BUG_ON(!spin_is_locked(&ioc->sas_device_lock));

This will blow on UP builds.  Please use assert_spin_locked or
lockdep_assert_held instead.  And don't ask me which of the two,
that's a mystery I don't understand myself either.

>  struct _sas_device *
> -mpt2sas_scsih_sas_device_find_by_sas_address(struct MPT2SAS_ADAPTER *ioc,
> +mpt2sas_scsih_sas_device_get_by_sas_address(struct MPT2SAS_ADAPTER *ioc,
>      u64 sas_address)
>  {

> +static struct _sas_device *
> +_scsih_sas_device_get_by_handle_nolock(struct MPT2SAS_ADAPTER *ioc, u16 handle)

>  static struct _sas_device *
> -_scsih_sas_device_find_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
> +_scsih_sas_device_get_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)

Same comments about the function names as above.

> +	struct _sas_device *sas_device;
> +
> +	BUG_ON(!spin_is_locked(&ioc->sas_device_lock));

Same comment about the right assert helpers as above.

> @@ -594,9 +634,15 @@ _scsih_sas_device_remove(struct MPT2SAS_ADAPTER *ioc,
>  	if (!sas_device)
>  		return;
>  
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

This looks odd to me.  Normally you'd have the lock from the list
iteration that finds the device.  From looking at the code it seems
like this only called from probe failure paths, though.  It seems like
for this case the device simplify shouldn't be added until the probe
succeeds and this function should go away?

> @@ -1208,12 +1256,15 @@ _scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
>  		goto not_sata;
>  	if ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME))
>  		goto not_sata;
> +
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> +	sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
>  	   sas_device_priv_data->sas_target->sas_address);
> -	if (sas_device && sas_device->device_info &
> -	    MPI2_SAS_DEVICE_INFO_SATA_DEVICE)
> +	if (sas_device && sas_device->device_info
> +			& MPI2_SAS_DEVICE_INFO_SATA_DEVICE) {
>  		max_depth = MPT2SAS_SATA_QUEUE_DEPTH;
> +		sas_device_put(sas_device);
> +	}

Please store a pointer to the sas_device in struct scsi_target ->hostdata
in _scsih_target_alloc and avoid the need for this and other runtime
lookups where we have a scsi_device or scsi_target structure available.

> @@ -1324,13 +1377,15 @@ _scsih_target_destroy(struct scsi_target *starget)
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
>  	rphy = dev_to_rphy(starget->dev.parent);
> -	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> +	sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
>  	   rphy->identify.sas_address);
>  	if (sas_device && (sas_device->starget == starget) &&
>  	    (sas_device->id == starget->id) &&
>  	    (sas_device->channel == starget->channel))
>  		sas_device->starget = NULL;
>  
> +	if (sas_device)
> +		sas_device_put(sas_device);
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);

.. like this one.

>   out:
> @@ -1386,7 +1441,7 @@ _scsih_slave_alloc(struct scsi_device *sdev)
>  
>  	if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
>  		spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -		sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> +		sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
>  				sas_target_priv_data->sas_address);
>  		if (sas_device && (sas_device->starget == NULL)) {
>  			sdev_printk(KERN_INFO, sdev,

.. or this one ..

> @@ -1428,10 +1487,13 @@ _scsih_slave_destroy(struct scsi_device *sdev)
>  
>  	if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
>  		spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -		sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> +		sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
>  		   sas_target_priv_data->sas_address);
>  		if (sas_device && !sas_target_priv_data->num_luns)
>  			sas_device->starget = NULL;
> +
> +		if (sas_device)
> +			sas_device_put(sas_device);
>  		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);

.. and this, and many more.
