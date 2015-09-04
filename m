From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH v4] mpt2sas: setpci reset kernel oops fix
Date: Fri, 4 Sep 2015 20:07:18 +0530
Message-ID: <CAK=zhgp-u7X5=j+r6OL+rLzZE0+ov3Q-U_24QC61G_2S_5tTEg@mail.gmail.com>
References: <20150818075710.GA11947@nagalsi.ban.indi.seagate.com>
	<mqdbndmft10.fsf@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:35868 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759140AbbIDOhT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2015 10:37:19 -0400
Received: by obqa2 with SMTP id a2so18251386obq.3
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2015 07:37:18 -0700 (PDT)
In-Reply-To: <mqdbndmft10.fsf@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Sathya Prakash <sathya.prakash@avagotech.com>, Chaitra Basappa <chaitra.basappa@avagotech.com>, Krishnaraddi Mankani <krishnaraddi.mankani@avagotech.com>

On Tue, Sep 1, 2015 at 1:52 PM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com> writes:
>
>> mpt2sas: setpci reset on nytro warpdrive card along with sysfs access and
>> cli ioctl access resulted in kernel oops
>>
>> 1. pci_access_mutex lock added to provide synchronization between IOCTL,
>>    sysfs, PCI resource handling path
>>
>> 2. gioc_lock spinlock to protect list operations over multiple
>> controllers
>>
>>
>> From c53a1cff4c07528b8b9ec7f6716e94950283e8f9 Mon Sep 17 00:00:00 2001
>> From: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com>
>> Date: Tue, 18 Aug 2015 11:58:13 +0530
>> Subject: [PATCH] mpt2sas setpci reset oops fix
>>
>> In mpt2sas driver due to lack of synchronization between ioctl,
>> BRM status access through sysfs, pci resource removal kernel oops
>> happen as ioctl path and BRM status sysfs access path still tries
>> to access the removed resources
>>
>> Two locks added to provide syncrhonization
>>
>> 1. pci_access_mutex: Mutex to synchronize ioctl,sysfs show path and
>> pci resource handling. PCI resource freeing will lead to free
>> vital hardware/memory resource, which might be in use by cli/sysfs
>> path functions resulting in Null pointer reference followed by kernel
>> crash. To avoid the above race condition we use mutex syncrhonization
>> which ensures the syncrhonization between cli/sysfs_show path
>>
>> Note: pci_access_mutex is used only if nytro warpdrive cards
>> (ioc->is_warpdrive based on device id) are used
>> as we could not test this case with other SAS2 HBA cards
>> We can remove this check if this behaviour confirmed from other
>> cards.
>>
>> 2. spinlock on list operations over IOCs
>>
>> Case: when multiple warpdrive cards(IOCs) are in use
>> Each IOC will added to the ioc list stucture on initialization.
>> Watchdog threads run at regular intervals to check IOC for any
>> fault conditions which will trigger the dead_ioc thread to
>> deallocate pci resource, resulting deleting the IOC netry from list,
>> this deletion need to protected by spinlock to enusre that
>> ioc removal is syncrhonized, if not synchronized it might lead to
>> list_del corruption as the ioc list is traversed in cli path
>>
>> Signed-off-by: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com>
>> ---
>> * v4
>> - spinlock function moved from spinlock_irqsave to spinlock on gioc lock
>>   as it was not   used in interrupt context
>> - added common exit point for pci_access_mutex unlock
>>
>> * v3
>> - fixed lock imbalance, moved acquiring mutex lock out of if condition
>>
>> * v2
>> - removed is_warpdrive condition for pci_access_mutex lock
>>
>> * v1
>> - using DEFINE_SPINLOCK() to initialize the lock at compile time instead
>>   of using spin_lock_init
>>  drivers/scsi/mpt2sas/mpt2sas_base.c  |    6 +++++
>>  drivers/scsi/mpt2sas/mpt2sas_base.h  |   19 ++++++++++++++++-
>>  drivers/scsi/mpt2sas/mpt2sas_ctl.c   |   38 +++++++++++++++++++++++++++------
>>  drivers/scsi/mpt2sas/mpt2sas_scsih.c |   13 ++++++++++-
>>  4 files changed, 67 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
>> index 11248de..60fefca 100644
>> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
>> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
>> @@ -112,9 +112,12 @@ _scsih_set_fwfault_debug(const char *val, struct kernel_param *kp)
>>       if (ret)
>>               return ret;
>>
>> +     /* global ioc spinlock to protect controller list on list operations */
>>       printk(KERN_INFO "setting fwfault_debug(%d)\n", mpt2sas_fwfault_debug);
>> +     spin_lock(&gioc_lock);
>>       list_for_each_entry(ioc, &mpt2sas_ioc_list, list)
>>               ioc->fwfault_debug = mpt2sas_fwfault_debug;
>> +     spin_unlock(&gioc_lock);
>>       return 0;
>>  }
>>
>> @@ -4435,6 +4438,8 @@ mpt2sas_base_free_resources(struct MPT2SAS_ADAPTER *ioc)
>>       dexitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
>>           __func__));
>>
>> +     /* synchronizing freeing resource with pci_access_mutex lock */
>> +     mutex_lock(&ioc->pci_access_mutex);
>>       if (ioc->chip_phys && ioc->chip) {
>>               _base_mask_interrupts(ioc);
>>               ioc->shost_recovery = 1;
>> @@ -4454,6 +4459,7 @@ mpt2sas_base_free_resources(struct MPT2SAS_ADAPTER *ioc)
>>               pci_disable_pcie_error_reporting(pdev);
>>               pci_disable_device(pdev);
>>       }
>> +     mutex_unlock(&ioc->pci_access_mutex);
>>       return;
>>  }
>>
>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
>> index caff8d1..c82bdb3 100644
>> --- a/drivers/scsi/mpt2sas/mpt2sas_base.h
>> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
>> @@ -799,6 +799,12 @@ typedef void (*MPT2SAS_FLUSH_RUNNING_CMDS)(struct MPT2SAS_ADAPTER *ioc);
>>   * @delayed_tr_list: target reset link list
>>   * @delayed_tr_volume_list: volume target reset link list
>>   * @@temp_sensors_count: flag to carry the number of temperature sensors
>> + * @pci_access_mutex: Mutex to synchronize ioctl,sysfs show path and
>> + * pci resource handling. PCI resource freeing will lead to free
>> + * vital hardware/memory resource, which might be in use by cli/sysfs
>> + * path functions resulting in Null pointer reference followed by kernel
>> + * crash. To avoid the above race condition we use mutex syncrhonization
>> + * which ensures the syncrhonization between cli/sysfs_show path
>>   */
>>  struct MPT2SAS_ADAPTER {
>>       struct list_head list;
>> @@ -1015,6 +1021,7 @@ struct MPT2SAS_ADAPTER {
>>       u8              mfg_pg10_hide_flag;
>>       u8              hide_drives;
>>
>> +     struct mutex pci_access_mutex;
>>  };
>>
>>  typedef u8 (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
>> @@ -1023,6 +1030,17 @@ typedef u8 (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
>>
>>  /* base shared API */
>>  extern struct list_head mpt2sas_ioc_list;
>> +/* spinlock on list operations over IOCs
>> + * Case: when multiple warpdrive cards(IOCs) are in use
>> + * Each IOC will added to the ioc list stucture on initialization.
>> + * Watchdog threads run at regular intervals to check IOC for any
>> + * fault conditions which will trigger the dead_ioc thread to
>> + * deallocate pci resource, resulting deleting the IOC netry from list,
>> + * this deletion need to protected by spinlock to enusre that
>> + * ioc removal is syncrhonized, if not synchronized it might lead to
>> + * list_del corruption as the ioc list is traversed in cli path
>> + */
>> +extern spinlock_t gioc_lock;
>>  void mpt2sas_base_start_watchdog(struct MPT2SAS_ADAPTER *ioc);
>>  void mpt2sas_base_stop_watchdog(struct MPT2SAS_ADAPTER *ioc);
>>
>> @@ -1099,7 +1117,6 @@ struct _sas_device *mpt2sas_scsih_sas_device_find_by_sas_address(
>>      struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
>>
>>  void mpt2sas_port_enable_complete(struct MPT2SAS_ADAPTER *ioc);
>> -
>>  void mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase);
>>
>>  /* config shared API */
>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
>> index 4e50960..3694b63 100644
>> --- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
>> +++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
>> @@ -427,13 +427,16 @@ static int
>>  _ctl_verify_adapter(int ioc_number, struct MPT2SAS_ADAPTER **iocpp)
>>  {
>>       struct MPT2SAS_ADAPTER *ioc;
>> -
>> +     /* global ioc lock to protect controller on list operations */
>> +     spin_lock(&gioc_lock);
>>       list_for_each_entry(ioc, &mpt2sas_ioc_list, list) {
>>               if (ioc->id != ioc_number)
>>                       continue;
>> +             spin_unlock(&gioc_lock);
>>               *iocpp = ioc;
>>               return ioc_number;
>>       }
>> +     spin_unlock(&gioc_lock);
>>       *iocpp = NULL;
>>       return -1;
>>  }
>> @@ -522,10 +525,15 @@ _ctl_poll(struct file *filep, poll_table *wait)
>>
>>       poll_wait(filep, &ctl_poll_wait, wait);
>>
>> +     /* global ioc lock to protect controller on list operations */
>> +     spin_lock(&gioc_lock);
>>       list_for_each_entry(ioc, &mpt2sas_ioc_list, list) {
>> -             if (ioc->aen_event_read_flag)
>> +             if (ioc->aen_event_read_flag) {
>> +                     spin_unlock(&gioc_lock);
>>                       return POLLIN | POLLRDNORM;
>> +             }
>>       }
>> +     spin_unlock(&gioc_lock);
>>       return 0;
>>  }
>>
>> @@ -2168,16 +2176,23 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
>>
>>       if (_ctl_verify_adapter(ioctl_header.ioc_number, &ioc) == -1 || !ioc)
>>               return -ENODEV;
>> +     /* pci_access_mutex lock acquired by ioctl path */
>> +     mutex_lock(&ioc->pci_access_mutex);
>>       if (ioc->shost_recovery || ioc->pci_error_recovery ||
>> -         ioc->is_driver_loading)
>> -             return -EAGAIN;
>> +             ioc->is_driver_loading || ioc->remove_host) {
>> +             ret = -EAGAIN;
>> +             goto out_unlock_pciaccess;
>> +     }
>>
>>       state = (file->f_flags & O_NONBLOCK) ? NON_BLOCKING : BLOCKING;
>>       if (state == NON_BLOCKING) {
>> -             if (!mutex_trylock(&ioc->ctl_cmds.mutex))
>> -                     return -EAGAIN;
>> +             if (!mutex_trylock(&ioc->ctl_cmds.mutex)) {
>> +                     ret = -EAGAIN;
>> +                     goto out_unlock_pciaccess;
>> +             }
>>       } else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex)) {
>> -             return -ERESTARTSYS;
>> +             ret = -ERESTARTSYS;
>> +             goto out_unlock_pciaccess;
>>       }
>>
>>       switch (cmd) {
>> @@ -2258,6 +2273,8 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
>>       }
>>
>>       mutex_unlock(&ioc->ctl_cmds.mutex);
>> +out_unlock_pciaccess:
>> +     mutex_unlock(&ioc->pci_access_mutex);
>>       return ret;
>>  }
>>
>> @@ -2711,6 +2728,12 @@ _ctl_BRM_status_show(struct device *cdev, struct device_attribute *attr,
>>                   "warpdrive\n", ioc->name, __func__);
>>               goto out;
>>       }
>> +     /* pci_access_mutex lock acquired by sysfs show path */
>> +     mutex_lock(&ioc->pci_access_mutex);
>> +     if (ioc->pci_error_recovery || ioc->remove_host) {
>> +             mutex_unlock(&ioc->pci_access_mutex);
>> +             return 0;
>> +     }
>>
>>       /* allocate upto GPIOVal 36 entries */
>>       sz = offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);
>> @@ -2749,6 +2772,7 @@ _ctl_BRM_status_show(struct device *cdev, struct device_attribute *attr,
>>
>>   out:
>>       kfree(io_unit_pg3);
>> +     mutex_unlock(&ioc->pci_access_mutex);
>>       return rc;
>>  }
>>  static DEVICE_ATTR(BRM_status, S_IRUGO, _ctl_BRM_status_show, NULL);
>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
>> index 3f26147..2124e08 100644
>> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
>> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
>> @@ -79,7 +79,8 @@ static int _scsih_scan_finished(struct Scsi_Host *shost, unsigned long time);
>>
>>  /* global parameters */
>>  LIST_HEAD(mpt2sas_ioc_list);
>> -
>> +/* global ioc lock for list operations */
>> +DEFINE_SPINLOCK(gioc_lock);
>>  /* local parameters */
>>  static u8 scsi_io_cb_idx = -1;
>>  static u8 tm_cb_idx = -1;
>> @@ -293,8 +294,10 @@ _scsih_set_debug_level(const char *val, struct kernel_param *kp)
>>               return ret;
>>
>>       printk(KERN_INFO "setting logging_level(0x%08x)\n", logging_level);
>> +     spin_lock(&gioc_lock);
>>       list_for_each_entry(ioc, &mpt2sas_ioc_list, list)
>>               ioc->logging_level = logging_level;
>> +     spin_unlock(&gioc_lock);
>>       return 0;
>>  }
>>  module_param_call(logging_level, _scsih_set_debug_level, param_get_int,
>> @@ -7867,7 +7870,9 @@ _scsih_remove(struct pci_dev *pdev)
>>       sas_remove_host(shost);
>>       scsi_remove_host(shost);
>>       mpt2sas_base_detach(ioc);
>> +     spin_lock(&gioc_lock);
>>       list_del(&ioc->list);
>> +     spin_unlock(&gioc_lock);
>>       scsi_host_put(shost);
>>  }
>>
>> @@ -8142,7 +8147,9 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>       ioc = shost_priv(shost);
>>       memset(ioc, 0, sizeof(struct MPT2SAS_ADAPTER));
>>       INIT_LIST_HEAD(&ioc->list);
>> +     spin_lock(&gioc_lock);
>>       list_add_tail(&ioc->list, &mpt2sas_ioc_list);
>> +     spin_unlock(&gioc_lock);
>>       ioc->shost = shost;
>>       ioc->id = mpt_ids++;
>>       sprintf(ioc->name, "%s%d", MPT2SAS_DRIVER_NAME, ioc->id);
>> @@ -8167,6 +8174,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>       ioc->schedule_dead_ioc_flush_running_cmds = &_scsih_flush_running_cmds;
>>       /* misc semaphores and spin locks */
>>       mutex_init(&ioc->reset_in_progress_mutex);
>> +     /* initializing pci_access_mutex lock */
>> +     mutex_init(&ioc->pci_access_mutex);
>>       spin_lock_init(&ioc->ioc_reset_in_progress_lock);
>>       spin_lock_init(&ioc->scsi_lookup_lock);
>>       spin_lock_init(&ioc->sas_device_lock);
>> @@ -8269,7 +8278,9 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>   out_attach_fail:
>>       destroy_workqueue(ioc->firmware_event_thread);
>>   out_thread_fail:
>> +     spin_lock(&gioc_lock);
>>       list_del(&ioc->list);
>> +     spin_unlock(&gioc_lock);
>>       scsi_host_put(shost);
>>       return rv;
>>  }
>
>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

ACK-by: Sreekanth Reddy <sreekanth.reddy@avagotech.com>

>
> --
