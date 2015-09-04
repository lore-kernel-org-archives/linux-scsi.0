From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH v4 1/2] mpt2sas: Refcount sas_device objects and fix
 unsafe list usage
Date: Fri, 4 Sep 2015 20:04:57 +0530
Message-ID: <CAK=zhgrZk2tGga2K2VXUg2+FN7aAtb37YTvDMkbpAfOUph2i2w@mail.gmail.com>
References: <1438405334-1153698-1-git-send-email-calvinowens@fb.com>
	<1439516890-3548744-1-git-send-email-calvinowens@fb.com>
	<c4742680984986864719f36e691883815e6b5d55.1439510240.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35273 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbbIDOe6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2015 10:34:58 -0400
Received: by obuk4 with SMTP id k4so18268352obu.2
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2015 07:34:57 -0700 (PDT)
In-Reply-To: <c4742680984986864719f36e691883815e6b5d55.1439510240.git.calvinowens@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: "MPT-FusionLinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Joe Lawrence <joe.lawrence@stratus.com>, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Krishnaraddi Mankani <krishnaraddi.mankani@avagotech.com>, Sathya Prakash <sathya.prakash@avagotech.com>, Chaitra Basappa <chaitra.basappa@avagotech.com>

On Fri, Aug 14, 2015 at 7:18 AM, Calvin Owens <calvinowens@fb.com> wrote:
> These objects can be referenced concurrently throughout the driver, we
> need a way to make sure threads can't delete them out from under each
> other. This patch adds the refcount, and refactors the code to use it.
>
> Additionally, we cannot iterate over the sas_device_list without
> holding the lock, or we risk corrupting random memory if items are
> added or deleted as we iterate. This patch refactors _scsih_probe_sas()
> to use the sas_device_list in a safe way.
>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Joe Lawrence <joe.lawrence@stratus.com>
> Signed-off-by: Calvin Owens <calvinowens@fb.com>

Tested-by: Chaitra Basappa <chaitra.basappa@avagotech.com>
ACK-by: Sreekanth Reddy <sreekanth.reddy@avagotech.com>

> ---
> Changes in v4:
>         * Fix lack of put() in non-SATA case in _scsih_change_queue_depth()
>         * Fix lack of put() in the non-error case in _scsih_check_device()
>         * Add missing put() at bottom of _scsih_add_device()
>         * Add put for ->hostdata pointer in _scsih_target_destroy() for the
>           get() in _scsih_target_alloc()
>
> Changes in v3:
>         * Drop the sas_device_lock while enabling devices, and leave the
>           sas_device object on the list, since it may need to be looked up there
>           while it is being enabled.
>         * Drop put() in _scsih_add_device(), because the ->hostdata now keeps a
>           reference (this was an oversight in v2).
>         * Be consistent about calling sas_device_put() while holding the
>           sas_device_lock where feasible.
>         * Take and assert_spin_locked() on the sas_device_lock from the newly
>           added __get_sdev_from_target(), add wrapper similar to other lookups
>           for callers which do not explicitly take the lock.
>
> Changes in v2:
>         * Squished patches 1-3 into this one
>         * s/BUG_ON(!spin_is_locked/assert_spin_locked/g
>         * Store a pointer to the sas_device object in ->hostdata, to eliminate
>           the need for several lookups on the lists.
>
>  drivers/scsi/mpt2sas/mpt2sas_base.h      |  22 +-
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c     | 480 +++++++++++++++++++++----------
>  drivers/scsi/mpt2sas/mpt2sas_transport.c |  12 +-
>  3 files changed, 360 insertions(+), 154 deletions(-)
>
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
> index caff8d1..78f41ac 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.h
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
> @@ -238,6 +238,7 @@
>   * @flags: MPT_TARGET_FLAGS_XXX flags
>   * @deleted: target flaged for deletion
>   * @tm_busy: target is busy with TM request.
> + * @sdev: The sas_device associated with this target
>   */
>  struct MPT2SAS_TARGET {
>         struct scsi_target *starget;
> @@ -248,6 +249,7 @@ struct MPT2SAS_TARGET {
>         u32     flags;
>         u8      deleted;
>         u8      tm_busy;
> +       struct _sas_device *sdev;
>  };
>
>
> @@ -376,8 +378,24 @@ struct _sas_device {
>         u8      phy;
>         u8      responding;
>         u8      pfa_led_on;
> +       struct kref refcount;
>  };
>
> +static inline void sas_device_get(struct _sas_device *s)
> +{
> +       kref_get(&s->refcount);
> +}
> +
> +static inline void sas_device_free(struct kref *r)
> +{
> +       kfree(container_of(r, struct _sas_device, refcount));
> +}
> +
> +static inline void sas_device_put(struct _sas_device *s)
> +{
> +       kref_put(&s->refcount, sas_device_free);
> +}
> +
>  /**
>   * struct _raid_device - raid volume link list
>   * @list: sas device list
> @@ -1095,7 +1113,9 @@ struct _sas_node *mpt2sas_scsih_expander_find_by_handle(struct MPT2SAS_ADAPTER *
>      u16 handle);
>  struct _sas_node *mpt2sas_scsih_expander_find_by_sas_address(struct MPT2SAS_ADAPTER
>      *ioc, u64 sas_address);
> -struct _sas_device *mpt2sas_scsih_sas_device_find_by_sas_address(
> +struct _sas_device *mpt2sas_get_sdev_by_addr(
> +    struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
> +struct _sas_device *__mpt2sas_get_sdev_by_addr(
>      struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
>
>  void mpt2sas_port_enable_complete(struct MPT2SAS_ADAPTER *ioc);
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index 3f26147..5eca3a4 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -526,8 +526,61 @@ _scsih_determine_boot_device(struct MPT2SAS_ADAPTER *ioc,
>         }
>  }
>
> +static struct _sas_device *
> +__mpt2sas_get_sdev_from_target(struct MPT2SAS_ADAPTER *ioc,
> +               struct MPT2SAS_TARGET *tgt_priv)
> +{
> +       struct _sas_device *ret;
> +
> +       assert_spin_locked(&ioc->sas_device_lock);
> +
> +       ret = tgt_priv->sdev;
> +       if (ret)
> +               sas_device_get(ret);
> +
> +       return ret;
> +}
> +
> +static struct _sas_device *
> +mpt2sas_get_sdev_from_target(struct MPT2SAS_ADAPTER *ioc,
> +               struct MPT2SAS_TARGET *tgt_priv)
> +{
> +       struct _sas_device *ret;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&ioc->sas_device_lock, flags);
> +       ret = __mpt2sas_get_sdev_from_target(ioc, tgt_priv);
> +       spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +
> +       return ret;
> +}
> +
> +
> +struct _sas_device *
> +__mpt2sas_get_sdev_by_addr(struct MPT2SAS_ADAPTER *ioc,
> +    u64 sas_address)
> +{
> +       struct _sas_device *sas_device;
> +
> +       assert_spin_locked(&ioc->sas_device_lock);
> +
> +       list_for_each_entry(sas_device, &ioc->sas_device_list, list)
> +               if (sas_device->sas_address == sas_address)
> +                       goto found_device;
> +
> +       list_for_each_entry(sas_device, &ioc->sas_device_init_list, list)
> +               if (sas_device->sas_address == sas_address)
> +                       goto found_device;
> +
> +       return NULL;
> +
> +found_device:
> +       sas_device_get(sas_device);
> +       return sas_device;
> +}
> +
>  /**
> - * mpt2sas_scsih_sas_device_find_by_sas_address - sas device search
> + * mpt2sas_get_sdev_by_addr - sas device search
>   * @ioc: per adapter object
>   * @sas_address: sas address
>   * Context: Calling function should acquire ioc->sas_device_lock
> @@ -536,24 +589,44 @@ _scsih_determine_boot_device(struct MPT2SAS_ADAPTER *ioc,
>   * object.
>   */
>  struct _sas_device *
> -mpt2sas_scsih_sas_device_find_by_sas_address(struct MPT2SAS_ADAPTER *ioc,
> +mpt2sas_get_sdev_by_addr(struct MPT2SAS_ADAPTER *ioc,
>      u64 sas_address)
>  {
>         struct _sas_device *sas_device;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&ioc->sas_device_lock, flags);
> +       sas_device = __mpt2sas_get_sdev_by_addr(ioc,
> +                       sas_address);
> +       spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +
> +       return sas_device;
> +}
> +
> +static struct _sas_device *
> +__mpt2sas_get_sdev_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
> +{
> +       struct _sas_device *sas_device;
> +
> +       assert_spin_locked(&ioc->sas_device_lock);
>
>         list_for_each_entry(sas_device, &ioc->sas_device_list, list)
> -               if (sas_device->sas_address == sas_address)
> -                       return sas_device;
> +               if (sas_device->handle == handle)
> +                       goto found_device;
>
>         list_for_each_entry(sas_device, &ioc->sas_device_init_list, list)
> -               if (sas_device->sas_address == sas_address)
> -                       return sas_device;
> +               if (sas_device->handle == handle)
> +                       goto found_device;
>
>         return NULL;
> +
> +found_device:
> +       sas_device_get(sas_device);
> +       return sas_device;
>  }
>
>  /**
> - * _scsih_sas_device_find_by_handle - sas device search
> + * mpt2sas_get_sdev_by_handle - sas device search
>   * @ioc: per adapter object
>   * @handle: sas device handle (assigned by firmware)
>   * Context: Calling function should acquire ioc->sas_device_lock
> @@ -562,19 +635,16 @@ mpt2sas_scsih_sas_device_find_by_sas_address(struct MPT2SAS_ADAPTER *ioc,
>   * object.
>   */
>  static struct _sas_device *
> -_scsih_sas_device_find_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
> +mpt2sas_get_sdev_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>  {
>         struct _sas_device *sas_device;
> +       unsigned long flags;
>
> -       list_for_each_entry(sas_device, &ioc->sas_device_list, list)
> -               if (sas_device->handle == handle)
> -                       return sas_device;
> -
> -       list_for_each_entry(sas_device, &ioc->sas_device_init_list, list)
> -               if (sas_device->handle == handle)
> -                       return sas_device;
> +       spin_lock_irqsave(&ioc->sas_device_lock, flags);
> +       sas_device = __mpt2sas_get_sdev_by_handle(ioc, handle);
> +       spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>
> -       return NULL;
> +       return sas_device;
>  }
>
>  /**
> @@ -583,7 +653,7 @@ _scsih_sas_device_find_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>   * @sas_device: the sas_device object
>   * Context: This function will acquire ioc->sas_device_lock.
>   *
> - * Removing object and freeing associated memory from the ioc->sas_device_list.
> + * If sas_device is on the list, remove it and decrement its reference count.
>   */
>  static void
>  _scsih_sas_device_remove(struct MPT2SAS_ADAPTER *ioc,
> @@ -594,9 +664,15 @@ _scsih_sas_device_remove(struct MPT2SAS_ADAPTER *ioc,
>         if (!sas_device)
>                 return;
>
> +       /*
> +        * The lock serializes access to the list, but we still need to verify
> +        * that nobody removed the entry while we were waiting on the lock.
> +        */
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -       list_del(&sas_device->list);
> -       kfree(sas_device);
> +       if (!list_empty(&sas_device->list)) {
> +               list_del_init(&sas_device->list);
> +               sas_device_put(sas_device);
> +       }
>         spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  }
>
> @@ -620,6 +696,7 @@ _scsih_sas_device_add(struct MPT2SAS_ADAPTER *ioc,
>             sas_device->handle, (unsigned long long)sas_device->sas_address));
>
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
> +       sas_device_get(sas_device);
>         list_add_tail(&sas_device->list, &ioc->sas_device_list);
>         spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>
> @@ -659,6 +736,7 @@ _scsih_sas_device_init_add(struct MPT2SAS_ADAPTER *ioc,
>             sas_device->handle, (unsigned long long)sas_device->sas_address));
>
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
> +       sas_device_get(sas_device);
>         list_add_tail(&sas_device->list, &ioc->sas_device_init_list);
>         _scsih_determine_boot_device(ioc, sas_device, 0);
>         spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> @@ -1208,12 +1286,15 @@ _scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
>                 goto not_sata;
>         if ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME))
>                 goto not_sata;
> +
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -       sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> -          sas_device_priv_data->sas_target->sas_address);
> -       if (sas_device && sas_device->device_info &
> -           MPI2_SAS_DEVICE_INFO_SATA_DEVICE)
> -               max_depth = MPT2SAS_SATA_QUEUE_DEPTH;
> +       sas_device = __mpt2sas_get_sdev_from_target(ioc, sas_target_priv_data);
> +       if (sas_device) {
> +               if (sas_device->device_info & MPI2_SAS_DEVICE_INFO_SATA_DEVICE)
> +                       max_depth = MPT2SAS_SATA_QUEUE_DEPTH;
> +
> +               sas_device_put(sas_device);
> +       }
>         spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>
>   not_sata:
> @@ -1271,18 +1352,20 @@ _scsih_target_alloc(struct scsi_target *starget)
>         /* sas/sata devices */
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
>         rphy = dev_to_rphy(starget->dev.parent);
> -       sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> +       sas_device = __mpt2sas_get_sdev_by_addr(ioc,
>            rphy->identify.sas_address);
>
>         if (sas_device) {
>                 sas_target_priv_data->handle = sas_device->handle;
>                 sas_target_priv_data->sas_address = sas_device->sas_address;
> +               sas_target_priv_data->sdev = sas_device;
>                 sas_device->starget = starget;
>                 sas_device->id = starget->id;
>                 sas_device->channel = starget->channel;
>                 if (test_bit(sas_device->handle, ioc->pd_handles))
>                         sas_target_priv_data->flags |=
>                             MPT_TARGET_FLAGS_RAID_COMPONENT;
> +
>         }
>         spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>
> @@ -1324,13 +1407,21 @@ _scsih_target_destroy(struct scsi_target *starget)
>
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
>         rphy = dev_to_rphy(starget->dev.parent);
> -       sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> -          rphy->identify.sas_address);
> +       sas_device = __mpt2sas_get_sdev_from_target(ioc, sas_target_priv_data);
>         if (sas_device && (sas_device->starget == starget) &&
>             (sas_device->id == starget->id) &&
>             (sas_device->channel == starget->channel))
>                 sas_device->starget = NULL;
>
> +       if (sas_device) {
> +               /*
> +                * Corresponding get() is in _scsih_target_alloc()
> +                */
> +               sas_target_priv_data->sdev = NULL;
> +               sas_device_put(sas_device);
> +
> +               sas_device_put(sas_device);
> +       }
>         spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>
>   out:
> @@ -1386,7 +1477,7 @@ _scsih_slave_alloc(struct scsi_device *sdev)
>
>         if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
>                 spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -               sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> +               sas_device = __mpt2sas_get_sdev_by_addr(ioc,
>                                 sas_target_priv_data->sas_address);
>                 if (sas_device && (sas_device->starget == NULL)) {
>                         sdev_printk(KERN_INFO, sdev,
> @@ -1394,6 +1485,10 @@ _scsih_slave_alloc(struct scsi_device *sdev)
>                              __func__, __LINE__);
>                         sas_device->starget = starget;
>                 }
> +
> +               if (sas_device)
> +                       sas_device_put(sas_device);
> +
>                 spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>         }
>
> @@ -1428,10 +1523,13 @@ _scsih_slave_destroy(struct scsi_device *sdev)
>
>         if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
>                 spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -               sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> -                  sas_target_priv_data->sas_address);
> +               sas_device = __mpt2sas_get_sdev_from_target(ioc,
> +                               sas_target_priv_data);
>                 if (sas_device && !sas_target_priv_data->num_luns)
>                         sas_device->starget = NULL;
> +
> +               if (sas_device)
> +                       sas_device_put(sas_device);
>                 spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>         }
>
> @@ -2078,7 +2176,7 @@ _scsih_slave_configure(struct scsi_device *sdev)
>         }
>
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -       sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> +       sas_device = __mpt2sas_get_sdev_by_addr(ioc,
>            sas_device_priv_data->sas_target->sas_address);
>         if (!sas_device) {
>                 spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> @@ -2112,17 +2210,18 @@ _scsih_slave_configure(struct scsi_device *sdev)
>             (unsigned long long) sas_device->enclosure_logical_id,
>             sas_device->slot);
>
> +       sas_device_put(sas_device);
>         spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>         if (!ssp_target)
>                 _scsih_display_sata_capabilities(ioc, handle, sdev);
>
> -
>         _scsih_change_queue_depth(sdev, qdepth);
>
>         if (ssp_target) {
>                 sas_read_port_mode_page(sdev);
>                 _scsih_enable_tlr(ioc, sdev);
>         }
> +
>         return 0;
>  }
>
> @@ -2509,8 +2608,7 @@ _scsih_tm_display_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd)
>                     device_str, (unsigned long long)priv_target->sas_address);
>         } else {
>                 spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -               sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> -                   priv_target->sas_address);
> +               sas_device = __mpt2sas_get_sdev_from_target(ioc, priv_target);
>                 if (sas_device) {
>                         if (priv_target->flags &
>                             MPT_TARGET_FLAGS_RAID_COMPONENT) {
> @@ -2529,6 +2627,8 @@ _scsih_tm_display_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd)
>                             "enclosure_logical_id(0x%016llx), slot(%d)\n",
>                            (unsigned long long)sas_device->enclosure_logical_id,
>                             sas_device->slot);
> +
> +                       sas_device_put(sas_device);
>                 }
>                 spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>         }
> @@ -2604,12 +2704,12 @@ _scsih_dev_reset(struct scsi_cmnd *scmd)
>  {
>         struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
>         struct MPT2SAS_DEVICE *sas_device_priv_data;
> -       struct _sas_device *sas_device;
> -       unsigned long flags;
> +       struct _sas_device *sas_device = NULL;
>         u16     handle;
>         int r;
>
>         struct scsi_target *starget = scmd->device->sdev_target;
> +       struct MPT2SAS_TARGET *target_priv_data = starget->hostdata;
>
>         starget_printk(KERN_INFO, starget, "attempting device reset! "
>             "scmd(%p)\n", scmd);
> @@ -2629,12 +2729,10 @@ _scsih_dev_reset(struct scsi_cmnd *scmd)
>         handle = 0;
>         if (sas_device_priv_data->sas_target->flags &
>             MPT_TARGET_FLAGS_RAID_COMPONENT) {
> -               spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -               sas_device = _scsih_sas_device_find_by_handle(ioc,
> -                  sas_device_priv_data->sas_target->handle);
> +               sas_device = mpt2sas_get_sdev_from_target(ioc,
> +                               target_priv_data);
>                 if (sas_device)
>                         handle = sas_device->volume_handle;
> -               spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>         } else
>                 handle = sas_device_priv_data->sas_target->handle;
>
> @@ -2651,6 +2749,10 @@ _scsih_dev_reset(struct scsi_cmnd *scmd)
>   out:
>         sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(%p)\n",
>             ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +
> +       if (sas_device)
> +               sas_device_put(sas_device);
> +
>         return r;
>  }
>
> @@ -2665,11 +2767,11 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
>  {
>         struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
>         struct MPT2SAS_DEVICE *sas_device_priv_data;
> -       struct _sas_device *sas_device;
> -       unsigned long flags;
> +       struct _sas_device *sas_device = NULL;
>         u16     handle;
>         int r;
>         struct scsi_target *starget = scmd->device->sdev_target;
> +       struct MPT2SAS_TARGET *target_priv_data = starget->hostdata;
>
>         starget_printk(KERN_INFO, starget, "attempting target reset! "
>             "scmd(%p)\n", scmd);
> @@ -2689,12 +2791,10 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
>         handle = 0;
>         if (sas_device_priv_data->sas_target->flags &
>             MPT_TARGET_FLAGS_RAID_COMPONENT) {
> -               spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -               sas_device = _scsih_sas_device_find_by_handle(ioc,
> -                  sas_device_priv_data->sas_target->handle);
> +               sas_device = mpt2sas_get_sdev_from_target(ioc,
> +                               target_priv_data);
>                 if (sas_device)
>                         handle = sas_device->volume_handle;
> -               spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>         } else
>                 handle = sas_device_priv_data->sas_target->handle;
>
> @@ -2711,6 +2811,10 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
>   out:
>         starget_printk(KERN_INFO, starget, "target reset: %s scmd(%p)\n",
>             ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +
> +       if (sas_device)
> +               sas_device_put(sas_device);
> +
>         return r;
>  }
>
> @@ -3002,15 +3106,15 @@ _scsih_block_io_to_children_attached_to_ex(struct MPT2SAS_ADAPTER *ioc,
>
>         list_for_each_entry(mpt2sas_port,
>            &sas_expander->sas_port_list, port_list) {
> -               if (mpt2sas_port->remote_identify.device_type ==
> -                   SAS_END_DEVICE) {
> +               if (mpt2sas_port->remote_identify.device_type == SAS_END_DEVICE) {
>                         spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -                       sas_device =
> -                           mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> -                          mpt2sas_port->remote_identify.sas_address);
> -                       if (sas_device)
> +                       sas_device = __mpt2sas_get_sdev_by_addr(ioc,
> +                                       mpt2sas_port->remote_identify.sas_address);
> +                       if (sas_device) {
>                                 set_bit(sas_device->handle,
> -                                   ioc->blocking_handles);
> +                                               ioc->blocking_handles);
> +                               sas_device_put(sas_device);
> +                       }
>                         spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>                 }
>         }
> @@ -3080,7 +3184,7 @@ _scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>  {
>         Mpi2SCSITaskManagementRequest_t *mpi_request;
>         u16 smid;
> -       struct _sas_device *sas_device;
> +       struct _sas_device *sas_device = NULL;
>         struct MPT2SAS_TARGET *sas_target_priv_data = NULL;
>         u64 sas_address = 0;
>         unsigned long flags;
> @@ -3110,7 +3214,7 @@ _scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>                 return;
>
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -       sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> +       sas_device = __mpt2sas_get_sdev_by_handle(ioc, handle);
>         if (sas_device && sas_device->starget &&
>              sas_device->starget->hostdata) {
>                 sas_target_priv_data = sas_device->starget->hostdata;
> @@ -3131,14 +3235,14 @@ _scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>         if (!smid) {
>                 delayed_tr = kzalloc(sizeof(*delayed_tr), GFP_ATOMIC);
>                 if (!delayed_tr)
> -                       return;
> +                       goto out;
>                 INIT_LIST_HEAD(&delayed_tr->list);
>                 delayed_tr->handle = handle;
>                 list_add_tail(&delayed_tr->list, &ioc->delayed_tr_list);
>                 dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
>                     "DELAYED:tr:handle(0x%04x), (open)\n",
>                     ioc->name, handle));
> -               return;
> +               goto out;
>         }
>
>         dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "tr_send:handle(0x%04x), "
> @@ -3150,6 +3254,9 @@ _scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>         mpi_request->DevHandle = cpu_to_le16(handle);
>         mpi_request->TaskType = MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
>         mpt2sas_base_put_smid_hi_priority(ioc, smid);
> +out:
> +       if (sas_device)
> +               sas_device_put(sas_device);
>  }
>
>
> @@ -4068,7 +4175,6 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
>         char *desc_scsi_state = ioc->tmp_string;
>         u32 log_info = le32_to_cpu(mpi_reply->IOCLogInfo);
>         struct _sas_device *sas_device = NULL;
> -       unsigned long flags;
>         struct scsi_target *starget = scmd->device->sdev_target;
>         struct MPT2SAS_TARGET *priv_target = starget->hostdata;
>         char *device_str = NULL;
> @@ -4200,9 +4306,7 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
>                 printk(MPT2SAS_WARN_FMT "\t%s wwid(0x%016llx)\n", ioc->name,
>                     device_str, (unsigned long long)priv_target->sas_address);
>         } else {
> -               spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -               sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> -                   priv_target->sas_address);
> +               sas_device = mpt2sas_get_sdev_from_target(ioc, priv_target);
>                 if (sas_device) {
>                         printk(MPT2SAS_WARN_FMT "\tsas_address(0x%016llx), "
>                             "phy(%d)\n", ioc->name, sas_device->sas_address,
> @@ -4211,8 +4315,9 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
>                             "\tenclosure_logical_id(0x%016llx), slot(%d)\n",
>                             ioc->name, sas_device->enclosure_logical_id,
>                             sas_device->slot);
> +
> +                       sas_device_put(sas_device);
>                 }
> -               spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>         }
>
>         printk(MPT2SAS_WARN_FMT "\thandle(0x%04x), ioc_status(%s)(0x%04x), "
> @@ -4259,7 +4364,7 @@ _scsih_turn_on_pfa_led(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>         Mpi2SepRequest_t mpi_request;
>         struct _sas_device *sas_device;
>
> -       sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> +       sas_device = mpt2sas_get_sdev_by_handle(ioc, handle);
>         if (!sas_device)
>                 return;
>
> @@ -4274,7 +4379,7 @@ _scsih_turn_on_pfa_led(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>             &mpi_request)) != 0) {
>                 printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n", ioc->name,
>                 __FILE__, __LINE__, __func__);
> -               return;
> +               goto out;
>         }
>         sas_device->pfa_led_on = 1;
>
> @@ -4284,8 +4389,10 @@ _scsih_turn_on_pfa_led(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>                  "enclosure_processor: ioc_status (0x%04x), loginfo(0x%08x)\n",
>                  ioc->name, le16_to_cpu(mpi_reply.IOCStatus),
>                  le32_to_cpu(mpi_reply.IOCLogInfo)));
> -               return;
> +               goto out;
>         }
> +out:
> +       sas_device_put(sas_device);
>  }
>
>  /**
> @@ -4370,19 +4477,17 @@ _scsih_smart_predicted_fault(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>
>         /* only handle non-raid devices */
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -       sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> +       sas_device = __mpt2sas_get_sdev_by_handle(ioc, handle);
>         if (!sas_device) {
> -               spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -               return;
> +               goto out_unlock;
>         }
>         starget = sas_device->starget;
>         sas_target_priv_data = starget->hostdata;
>
>         if ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_RAID_COMPONENT) ||
> -          ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME))) {
> -               spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -               return;
> -       }
> +          ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)))
> +               goto out_unlock;
> +
>         starget_printk(KERN_WARNING, starget, "predicted fault\n");
>         spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>
> @@ -4396,7 +4501,7 @@ _scsih_smart_predicted_fault(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>         if (!event_reply) {
>                 printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
>                     ioc->name, __FILE__, __LINE__, __func__);
> -               return;
> +               goto out;
>         }
>
>         event_reply->Function = MPI2_FUNCTION_EVENT_NOTIFICATION;
> @@ -4413,6 +4518,14 @@ _scsih_smart_predicted_fault(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>         event_data->SASAddress = cpu_to_le64(sas_target_priv_data->sas_address);
>         mpt2sas_ctl_add_to_event_log(ioc, event_reply);
>         kfree(event_reply);
> +out:
> +       if (sas_device)
> +               sas_device_put(sas_device);
> +       return;
> +
> +out_unlock:
> +       spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +       goto out;
>  }
>
>  /**
> @@ -5148,14 +5261,13 @@ _scsih_check_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
>         sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
> -       sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> +       sas_device = __mpt2sas_get_sdev_by_addr(ioc,
>             sas_address);
>
>         if (!sas_device) {
>                 printk(MPT2SAS_ERR_FMT "device is not present "
>                     "handle(0x%04x), no sas_device!!!\n", ioc->name, handle);
> -               spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -               return;
> +               goto out_unlock;
>         }
>
>         if (unlikely(sas_device->handle != handle)) {
> @@ -5172,19 +5284,24 @@ _scsih_check_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>             MPI2_SAS_DEVICE0_FLAGS_DEVICE_PRESENT)) {
>                 printk(MPT2SAS_ERR_FMT "device is not present "
>                     "handle(0x%04x), flags!!!\n", ioc->name, handle);
> -               spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -               return;
> +               goto out_unlock;
>         }
>
>         /* check if there were any issues with discovery */
>         if (_scsih_check_access_status(ioc, sas_address, handle,
> -           sas_device_pg0.AccessStatus)) {
> -               spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -               return;
> -       }
> +           sas_device_pg0.AccessStatus))
> +               goto out_unlock;
> +
>         spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>         _scsih_ublock_io_device(ioc, sas_address);
> +       if (sas_device)
> +               sas_device_put(sas_device);
> +       return;
>
> +out_unlock:
> +       spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +       if (sas_device)
> +               sas_device_put(sas_device);
>  }
>
>  /**
> @@ -5208,7 +5325,6 @@ _scsih_add_device(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 phy_num, u8 is_pd)
>         u32 ioc_status;
>         __le64 sas_address;
>         u32 device_info;
> -       unsigned long flags;
>
>         if ((mpt2sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
>             MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
> @@ -5250,14 +5366,13 @@ _scsih_add_device(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 phy_num, u8 is_pd)
>                 return -1;
>         }
>
> -
> -       spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -       sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> +       sas_device = mpt2sas_get_sdev_by_addr(ioc,
>             sas_address);
> -       spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>
> -       if (sas_device)
> +       if (sas_device) {
> +               sas_device_put(sas_device);
>                 return 0;
> +       }
>
>         sas_device = kzalloc(sizeof(struct _sas_device),
>             GFP_KERNEL);
> @@ -5267,6 +5382,7 @@ _scsih_add_device(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 phy_num, u8 is_pd)
>                 return -1;
>         }
>
> +       kref_init(&sas_device->refcount);
>         sas_device->handle = handle;
>         if (_scsih_get_sas_address(ioc, le16_to_cpu
>                 (sas_device_pg0.ParentDevHandle),
> @@ -5296,6 +5412,7 @@ _scsih_add_device(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 phy_num, u8 is_pd)
>         else
>                 _scsih_sas_device_add(ioc, sas_device);
>
> +       sas_device_put(sas_device);
>         return 0;
>  }
>
> @@ -5344,7 +5461,6 @@ _scsih_remove_device(struct MPT2SAS_ADAPTER *ioc,
>             "handle(0x%04x), sas_addr(0x%016llx)\n", ioc->name, __func__,
>             sas_device->handle, (unsigned long long)
>             sas_device->sas_address));
> -       kfree(sas_device);
>  }
>  /**
>   * _scsih_device_remove_by_handle - removing device object by handle
> @@ -5363,12 +5479,17 @@ _scsih_device_remove_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>                 return;
>
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -       sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> -       if (sas_device)
> -               list_del(&sas_device->list);
> +       sas_device = __mpt2sas_get_sdev_by_handle(ioc, handle);
> +       if (sas_device) {
> +               list_del_init(&sas_device->list);
> +               sas_device_put(sas_device);
> +       }
>         spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -       if (sas_device)
> +
> +       if (sas_device) {
>                 _scsih_remove_device(ioc, sas_device);
> +               sas_device_put(sas_device);
> +       }
>  }
>
>  /**
> @@ -5389,13 +5510,17 @@ mpt2sas_device_remove_by_sas_address(struct MPT2SAS_ADAPTER *ioc,
>                 return;
>
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -       sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> -           sas_address);
> -       if (sas_device)
> -               list_del(&sas_device->list);
> +       sas_device = __mpt2sas_get_sdev_by_addr(ioc, sas_address);
> +       if (sas_device) {
> +               list_del_init(&sas_device->list);
> +               sas_device_put(sas_device);
> +       }
>         spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -       if (sas_device)
> +
> +       if (sas_device) {
>                 _scsih_remove_device(ioc, sas_device);
> +               sas_device_put(sas_device);
> +       }
>  }
>  #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
>  /**
> @@ -5716,26 +5841,28 @@ _scsih_sas_device_status_change_event(struct MPT2SAS_ADAPTER *ioc,
>
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
>         sas_address = le64_to_cpu(event_data->SASAddress);
> -       sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> +       sas_device = __mpt2sas_get_sdev_by_addr(ioc,
>             sas_address);
>
> -       if (!sas_device || !sas_device->starget) {
> -               spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -               return;
> -       }
> +       if (!sas_device || !sas_device->starget)
> +               goto out;
>
>         target_priv_data = sas_device->starget->hostdata;
> -       if (!target_priv_data) {
> -               spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -               return;
> -       }
> +       if (!target_priv_data)
> +               goto out;
>
>         if (event_data->ReasonCode ==
>             MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET)
>                 target_priv_data->tm_busy = 1;
>         else
>                 target_priv_data->tm_busy = 0;
> +
> +out:
> +       if (sas_device)
> +               sas_device_put(sas_device);
> +
>         spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +
>  }
>
>  #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
> @@ -6123,7 +6250,7 @@ _scsih_sas_pd_expose(struct MPT2SAS_ADAPTER *ioc,
>         u16 handle = le16_to_cpu(element->PhysDiskDevHandle);
>
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -       sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> +       sas_device = __mpt2sas_get_sdev_by_handle(ioc, handle);
>         if (sas_device) {
>                 sas_device->volume_handle = 0;
>                 sas_device->volume_wwid = 0;
> @@ -6142,6 +6269,8 @@ _scsih_sas_pd_expose(struct MPT2SAS_ADAPTER *ioc,
>         /* exposing raid component */
>         if (starget)
>                 starget_for_each_device(starget, NULL, _scsih_reprobe_lun);
> +
> +       sas_device_put(sas_device);
>  }
>
>  /**
> @@ -6170,7 +6299,7 @@ _scsih_sas_pd_hide(struct MPT2SAS_ADAPTER *ioc,
>                     &volume_wwid);
>
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -       sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> +       sas_device = __mpt2sas_get_sdev_by_handle(ioc, handle);
>         if (sas_device) {
>                 set_bit(handle, ioc->pd_handles);
>                 if (sas_device->starget && sas_device->starget->hostdata) {
> @@ -6189,6 +6318,8 @@ _scsih_sas_pd_hide(struct MPT2SAS_ADAPTER *ioc,
>         /* hiding raid component */
>         if (starget)
>                 starget_for_each_device(starget, (void *)1, _scsih_reprobe_lun);
> +
> +       sas_device_put(sas_device);
>  }
>
>  /**
> @@ -6221,7 +6352,6 @@ _scsih_sas_pd_add(struct MPT2SAS_ADAPTER *ioc,
>      Mpi2EventIrConfigElement_t *element)
>  {
>         struct _sas_device *sas_device;
> -       unsigned long flags;
>         u16 handle = le16_to_cpu(element->PhysDiskDevHandle);
>         Mpi2ConfigReply_t mpi_reply;
>         Mpi2SasDevicePage0_t sas_device_pg0;
> @@ -6231,11 +6361,11 @@ _scsih_sas_pd_add(struct MPT2SAS_ADAPTER *ioc,
>
>         set_bit(handle, ioc->pd_handles);
>
> -       spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -       sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> -       spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -       if (sas_device)
> +       sas_device = mpt2sas_get_sdev_by_handle(ioc, handle);
> +       if (sas_device) {
> +               sas_device_put(sas_device);
>                 return;
> +       }
>
>         if ((mpt2sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
>             MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
> @@ -6509,7 +6639,6 @@ _scsih_sas_ir_physical_disk_event(struct MPT2SAS_ADAPTER *ioc,
>         u16 handle, parent_handle;
>         u32 state;
>         struct _sas_device *sas_device;
> -       unsigned long flags;
>         Mpi2ConfigReply_t mpi_reply;
>         Mpi2SasDevicePage0_t sas_device_pg0;
>         u32 ioc_status;
> @@ -6542,12 +6671,11 @@ _scsih_sas_ir_physical_disk_event(struct MPT2SAS_ADAPTER *ioc,
>                 if (!ioc->is_warpdrive)
>                         set_bit(handle, ioc->pd_handles);
>
> -               spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -               sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> -               spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -
> -               if (sas_device)
> +               sas_device = mpt2sas_get_sdev_by_handle(ioc, handle);
> +               if (sas_device) {
> +                       sas_device_put(sas_device);
>                         return;
> +               }
>
>                 if ((mpt2sas_config_get_sas_device_pg0(ioc, &mpi_reply,
>                     &sas_device_pg0, MPI2_SAS_DEVICE_PGAD_FORM_HANDLE,
> @@ -7015,6 +7143,7 @@ _scsih_remove_unresponding_sas_devices(struct MPT2SAS_ADAPTER *ioc)
>         struct _raid_device *raid_device, *raid_device_next;
>         struct list_head tmp_list;
>         unsigned long flags;
> +       LIST_HEAD(head);
>
>         printk(MPT2SAS_INFO_FMT "removing unresponding devices: start\n",
>             ioc->name);
> @@ -7022,14 +7151,29 @@ _scsih_remove_unresponding_sas_devices(struct MPT2SAS_ADAPTER *ioc)
>         /* removing unresponding end devices */
>         printk(MPT2SAS_INFO_FMT "removing unresponding devices: end-devices\n",
>             ioc->name);
> +
> +       /*
> +        * Iterate, pulling off devices marked as non-responding. We become the
> +        * owner for the reference the list had on any object we prune.
> +        */
> +       spin_lock_irqsave(&ioc->sas_device_lock, flags);
>         list_for_each_entry_safe(sas_device, sas_device_next,
> -           &ioc->sas_device_list, list) {
> +                       &ioc->sas_device_list, list) {
>                 if (!sas_device->responding)
> -                       mpt2sas_device_remove_by_sas_address(ioc,
> -                               sas_device->sas_address);
> +                       list_move_tail(&sas_device->list, &head);
>                 else
>                         sas_device->responding = 0;
>         }
> +       spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +
> +       /*
> +        * Now, uninitialize and remove the unresponding devices we pruned.
> +        */
> +       list_for_each_entry_safe(sas_device, sas_device_next, &head, list) {
> +               _scsih_remove_device(ioc, sas_device);
> +               list_del_init(&sas_device->list);
> +               sas_device_put(sas_device);
> +       }
>
>         /* removing unresponding volumes */
>         if (ioc->ir_firmware) {
> @@ -7179,11 +7323,11 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
>                 }
>                 phys_disk_num = pd_pg0.PhysDiskNum;
>                 handle = le16_to_cpu(pd_pg0.DevHandle);
> -               spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -               sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> -               spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -               if (sas_device)
> +               sas_device = mpt2sas_get_sdev_by_handle(ioc, handle);
> +               if (sas_device) {
> +                       sas_device_put(sas_device);
>                         continue;
> +               }
>                 if (mpt2sas_config_get_sas_device_pg0(ioc, &mpi_reply,
>                     &sas_device_pg0, MPI2_SAS_DEVICE_PGAD_FORM_HANDLE,
>                     handle) != 0)
> @@ -7302,12 +7446,12 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
>                 if (!(_scsih_is_end_device(
>                     le32_to_cpu(sas_device_pg0.DeviceInfo))))
>                         continue;
> -               spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -               sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> +               sas_device = mpt2sas_get_sdev_by_addr(ioc,
>                     le64_to_cpu(sas_device_pg0.SASAddress));
> -               spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -               if (sas_device)
> +               if (sas_device) {
> +                       sas_device_put(sas_device);
>                         continue;
> +               }
>                 parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
>                 if (!_scsih_get_sas_address(ioc, parent_handle, &sas_address)) {
>                         printk(MPT2SAS_INFO_FMT "\tBEFORE adding end device: "
> @@ -7966,6 +8110,48 @@ _scsih_probe_raid(struct MPT2SAS_ADAPTER *ioc)
>         }
>  }
>
> +static struct _sas_device *get_next_sas_device(struct MPT2SAS_ADAPTER *ioc)
> +{
> +       struct _sas_device *sas_device = NULL;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&ioc->sas_device_lock, flags);
> +       if (!list_empty(&ioc->sas_device_init_list)) {
> +               sas_device = list_first_entry(&ioc->sas_device_init_list,
> +                               struct _sas_device, list);
> +               sas_device_get(sas_device);
> +       }
> +       spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +
> +       return sas_device;
> +}
> +
> +static void sas_device_make_active(struct MPT2SAS_ADAPTER *ioc,
> +               struct _sas_device *sas_device)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&ioc->sas_device_lock, flags);
> +
> +       /*
> +        * Since we dropped the lock during the call to port_add(), we need to
> +        * be careful here that somebody else didn't move or delete this item
> +        * while we were busy with other things.
> +        *
> +        * If it was on the list, we need a put() for the reference the list
> +        * had. Either way, we need a get() for the destination list.
> +        */
> +       if (!list_empty(&sas_device->list)) {
> +               list_del_init(&sas_device->list);
> +               sas_device_put(sas_device);
> +       }
> +
> +       sas_device_get(sas_device);
> +       list_add_tail(&sas_device->list, &ioc->sas_device_list);
> +
> +       spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +}
> +
>  /**
>   * _scsih_probe_sas - reporting sas devices to sas transport
>   * @ioc: per adapter object
> @@ -7975,34 +8161,30 @@ _scsih_probe_raid(struct MPT2SAS_ADAPTER *ioc)
>  static void
>  _scsih_probe_sas(struct MPT2SAS_ADAPTER *ioc)
>  {
> -       struct _sas_device *sas_device, *next;
> -       unsigned long flags;
> -
> -       /* SAS Device List */
> -       list_for_each_entry_safe(sas_device, next, &ioc->sas_device_init_list,
> -           list) {
> +       struct _sas_device *sas_device;
>
> -               if (ioc->hide_drives)
> -                       continue;
> +       if (ioc->hide_drives)
> +               return;
>
> +       while ((sas_device = get_next_sas_device(ioc))) {
>                 if (!mpt2sas_transport_port_add(ioc, sas_device->handle,
> -                   sas_device->sas_address_parent)) {
> -                       list_del(&sas_device->list);
> -                       kfree(sas_device);
> +                               sas_device->sas_address_parent)) {
> +                       _scsih_sas_device_remove(ioc, sas_device);
> +                       sas_device_put(sas_device);
>                         continue;
>                 } else if (!sas_device->starget) {
>                         if (!ioc->is_driver_loading) {
>                                 mpt2sas_transport_port_remove(ioc,
> -                                       sas_device->sas_address,
> -                                       sas_device->sas_address_parent);
> -                               list_del(&sas_device->list);
> -                               kfree(sas_device);
> +                                               sas_device->sas_address,
> +                                               sas_device->sas_address_parent);
> +                               _scsih_sas_device_remove(ioc, sas_device);
> +                               sas_device_put(sas_device);
>                                 continue;
>                         }
>                 }
> -               spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -               list_move_tail(&sas_device->list, &ioc->sas_device_list);
> -               spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +
> +               sas_device_make_active(ioc, sas_device);
> +               sas_device_put(sas_device);
>         }
>  }
>
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
> index ff2500a..af86800 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
> @@ -1323,15 +1323,17 @@ _transport_get_enclosure_identifier(struct sas_rphy *rphy, u64 *identifier)
>         int rc;
>
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -       sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> +       sas_device = __mpt2sas_get_sdev_by_addr(ioc,
>             rphy->identify.sas_address);
>         if (sas_device) {
>                 *identifier = sas_device->enclosure_logical_id;
>                 rc = 0;
> +               sas_device_put(sas_device);
>         } else {
>                 *identifier = 0;
>                 rc = -ENXIO;
>         }
> +
>         spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>         return rc;
>  }
> @@ -1351,12 +1353,14 @@ _transport_get_bay_identifier(struct sas_rphy *rphy)
>         int rc;
>
>         spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -       sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> +       sas_device = __mpt2sas_get_sdev_by_addr(ioc,
>             rphy->identify.sas_address);
> -       if (sas_device)
> +       if (sas_device) {
>                 rc = sas_device->slot;
> -       else
> +               sas_device_put(sas_device);
> +       } else {
>                 rc = -ENXIO;
> +       }
>         spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>         return rc;
>  }
> --
> 2.5.0
>
