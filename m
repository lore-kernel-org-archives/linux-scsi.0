From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3] mpt2sas: setpci reset kernel oops fix
Date: Thu, 06 Aug 2015 14:14:39 +0200
Message-ID: <mqdk2t8fwb4.fsf@c203.arch.suse.de>
References: <20150717062545.GA28561@nagalsi.ban.indi.seagate.com>
	<CADcZ=zr1=g4FHSr2rngW-YFf09AoWkZubyDj2MQHZ1emaOuT9A@mail.gmail.com>
	<CADcZ=zp0QvXu6Q5uAefeDi0Cd7muFB+rn+fMVHD8Ej2quBpsvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592AbbHFMOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2015 08:14:42 -0400
In-Reply-To: <CADcZ=zp0QvXu6Q5uAefeDi0Cd7muFB+rn+fMVHD8Ej2quBpsvA@mail.gmail.com>
	(Nagarajkumar Narayanan's message of "Thu, 6 Aug 2015 08:32:44 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com>
Cc: hare@suse.de, hch@infradead.org, linux-scsi@vger.kernel.org

Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com> writes:

> Can you please review the patch
>
> Thanks,
> Nagaraj
>
> On Tue, Jul 21, 2015 at 10:11 AM, Nagarajkumar Narayanan
> <nagarajkumar.narayanan@seagate.com> wrote:
>> I have fixed the lock imbalance could anyone please review the patch
>>
>> Thanks,
>> Nagarajkumar Narayanan
>>
>>
>> On Fri, Jul 17, 2015 at 11:55 AM, Nagarajkumar Narayanan
>> <nagarajkumar.narayanan@seagate.com> wrote:
>>> Patch Description:
>>>
>>> In mpt2sas driver due to lack of synchronization between ioctl,
>>> BRM status access through sysfs, pci resource removal kernel oops
>>> happen as ioctl path and BRM status sysfs access path still tries
>>> to access the removed resources
>>>
>>> kernel: BUG: unable to handle kernel paging request at ffffc900171e=
0000
>>>
>>> Oops: 0000 [#1] SMP
>>>
>>> Two locks added to provide syncrhonization
>>>
>>> 1. pci_access_mutex: Mutex to synchronize ioctl,sysfs show path and
>>> pci resource handling. PCI resource freeing will lead to free
>>> vital hardware/memory resource, which might be in use by cli/sysfs
>>> path functions resulting in Null pointer reference followed by kern=
el
>>> crash. To avoid the above race condition we use mutex syncrhonizati=
on
>>> which ensures the syncrhonization between cli/sysfs_show path
>>>
>>> 2. spinlock on list operations over IOCs
>>>
>>> Case: when multiple warpdrive cards(IOCs) are in use
>>> Each IOC will added to the ioc list stucture on initialization.
>>> Watchdog threads run at regular intervals to check IOC for any
>>> fault conditions which will trigger the dead_ioc thread to
>>> deallocate pci resource, resulting deleting the IOC netry from list=
,
>>> this deletion need to protected by spinlock to enusre that
>>> ioc removal is syncrhonized, if not synchronized it might lead to
>>> list_del corruption as the ioc list is traversed in cli path
>>>

Why is the detailed description not included in the patch? This probabl=
y
should also be tagged for stable inclusion.

>>>
>>> From 9e54273555d9a34d0d375b91d41318b4ac69a13b Mon Sep 17 00:00:00 2=
001
>>> From: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com>
>>> Date: Fri, 17 Jul 2015 11:28:27 +0530
>>> Subject: [PATCH] mpt2sas setpci reset oops fix
>>>
>>> setpci reset on nytro warpdrive card along with sysfs access and
>>> cli ioctl access resulted in kernel oops
>>>
>>> 1. pci_access_mutex lock added to provide synchronization between I=
OCTL,
>>>    sysfs, PCI resource handling path
>>>
>>> 2. gioc_lock spinlock to protect list operations over multiple
>>>    controllers
>>>
>>> Signed-off-by: Nagarajkumar Narayanan <nagarajkumar.narayanan@seaga=
te.com>
>>> ---
>>> * v3
>>> - fixed lock imbalance, moved acquiring mutex lock out of if condit=
ion
>>>
>>> * v2
>>> - removed is_warpdrive condition for pci_access_mutex lock
>>>
>>> * v1
>>> - using DEFINE_SPINLOCK() to initialize the lock at compile time in=
stead
>>>   of using spin_lock_init
>>>
>>>  drivers/scsi/mpt2sas/mpt2sas_base.c  |    7 +++++++
>>>  drivers/scsi/mpt2sas/mpt2sas_base.h  |   19 ++++++++++++++++++-
>>>  drivers/scsi/mpt2sas/mpt2sas_ctl.c   |   33 ++++++++++++++++++++++=
+++++++----
>>>  drivers/scsi/mpt2sas/mpt2sas_scsih.c |   15 ++++++++++++++-
>>>  4 files changed, 68 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt=
2sas/mpt2sas_base.c
>>> index 11248de..c0d36b3 100644
>>> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
>>> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
>>> @@ -108,13 +108,17 @@ _scsih_set_fwfault_debug(const char *val, str=
uct kernel_param *kp)
>>>  {
>>>         int ret =3D param_set_int(val, kp);
>>>         struct MPT2SAS_ADAPTER *ioc;
>>> +       unsigned long flags;
>>>
>>>         if (ret)
>>>                 return ret;
>>>
>>> +       /* global ioc spinlock to protect controller list on list o=
perations */
>>>         printk(KERN_INFO "setting fwfault_debug(%d)\n", mpt2sas_fwf=
ault_debug);
>>> +       spin_lock_irqsave(&gioc_lock, flags);
>>>         list_for_each_entry(ioc, &mpt2sas_ioc_list, list)
>>>                 ioc->fwfault_debug =3D mpt2sas_fwfault_debug;
>>> +       spin_unlock_irqrestore(&gioc_lock, flags);
>>>         return 0;
>>>  }
>>>

I don't think you need the irqsave version here, as mpt2sas_ioc_list is
never touched in an IRQ context. But feel free to prove me wrong.

>>> @@ -4435,6 +4439,8 @@ mpt2sas_base_free_resources(struct MPT2SAS_AD=
APTER *ioc)
>>>         dexitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
>>>             __func__));
>>>
>>> +       /* synchronizing freeing resource with pci_access_mutex loc=
k */
>>> +       mutex_lock(&ioc->pci_access_mutex);
>>>         if (ioc->chip_phys && ioc->chip) {
>>>                 _base_mask_interrupts(ioc);
>>>                 ioc->shost_recovery =3D 1;
>>> @@ -4454,6 +4460,7 @@ mpt2sas_base_free_resources(struct MPT2SAS_AD=
APTER *ioc)
>>>                 pci_disable_pcie_error_reporting(pdev);
>>>                 pci_disable_device(pdev);
>>>         }
>>> +       mutex_unlock(&ioc->pci_access_mutex);
>>>         return;
>>>  }
>>>
>>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt=
2sas/mpt2sas_base.h
>>> index caff8d1..c82bdb3 100644
>>> --- a/drivers/scsi/mpt2sas/mpt2sas_base.h
>>> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
>>> @@ -799,6 +799,12 @@ typedef void (*MPT2SAS_FLUSH_RUNNING_CMDS)(str=
uct MPT2SAS_ADAPTER *ioc);
>>>   * @delayed_tr_list: target reset link list
>>>   * @delayed_tr_volume_list: volume target reset link list
>>>   * @@temp_sensors_count: flag to carry the number of temperature s=
ensors
>>> + * @pci_access_mutex: Mutex to synchronize ioctl,sysfs show path a=
nd
>>> + * pci resource handling. PCI resource freeing will lead to free
>>> + * vital hardware/memory resource, which might be in use by cli/sy=
sfs
>>> + * path functions resulting in Null pointer reference followed by =
kernel
>>> + * crash. To avoid the above race condition we use mutex syncrhoni=
zation
>>> + * which ensures the syncrhonization between cli/sysfs_show path
>>>   */
>>>  struct MPT2SAS_ADAPTER {
>>>         struct list_head list;
>>> @@ -1015,6 +1021,7 @@ struct MPT2SAS_ADAPTER {
>>>         u8              mfg_pg10_hide_flag;
>>>         u8              hide_drives;
>>>
>>> +       struct mutex pci_access_mutex;
>>>  };
>>>
>>>  typedef u8 (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid, =
u8 msix_index,
>>> @@ -1023,6 +1030,17 @@ typedef u8 (*MPT_CALLBACK)(struct MPT2SAS_AD=
APTER *ioc, u16 smid, u8 msix_index,
>>>
>>>  /* base shared API */
>>>  extern struct list_head mpt2sas_ioc_list;
>>> +/* spinlock on list operations over IOCs
>>> + * Case: when multiple warpdrive cards(IOCs) are in use
>>> + * Each IOC will added to the ioc list stucture on initialization.
>>> + * Watchdog threads run at regular intervals to check IOC for any
>>> + * fault conditions which will trigger the dead_ioc thread to
>>> + * deallocate pci resource, resulting deleting the IOC netry from =
list,
>>> + * this deletion need to protected by spinlock to enusre that
>>> + * ioc removal is syncrhonized, if not synchronized it might lead =
to
>>> + * list_del corruption as the ioc list is traversed in cli path
>>> + */
>>> +extern spinlock_t gioc_lock;
>>>  void mpt2sas_base_start_watchdog(struct MPT2SAS_ADAPTER *ioc);
>>>  void mpt2sas_base_stop_watchdog(struct MPT2SAS_ADAPTER *ioc);
>>>
>>> @@ -1099,7 +1117,6 @@ struct _sas_device *mpt2sas_scsih_sas_device_=
find_by_sas_address(
>>>      struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
>>>
>>>  void mpt2sas_port_enable_complete(struct MPT2SAS_ADAPTER *ioc);
>>> -
>>>  void mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int =
reset_phase);
>>>
>>>  /* config shared API */
>>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2=
sas/mpt2sas_ctl.c
>>> index 4e50960..8f8f2ad 100644
>>> --- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
>>> +++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
>>> @@ -427,13 +427,17 @@ static int
>>>  _ctl_verify_adapter(int ioc_number, struct MPT2SAS_ADAPTER **iocpp=
)
>>>  {
>>>         struct MPT2SAS_ADAPTER *ioc;
>>> -
>>> +       unsigned long flags;
>>> +       /* global ioc lock to protect controller on list operations=
 */
>>> +       spin_lock_irqsave(&gioc_lock, flags);
>>>         list_for_each_entry(ioc, &mpt2sas_ioc_list, list) {
>>>                 if (ioc->id !=3D ioc_number)
>>>                         continue;
>>> +               spin_unlock_irqrestore(&gioc_lock, flags);
>>>                 *iocpp =3D ioc;
>>>                 return ioc_number;
>>>         }
>>> +       spin_unlock_irqrestore(&gioc_lock, flags);
>>>         *iocpp =3D NULL;
>>>         return -1;
>>>  }


Same here.

>>> @@ -519,13 +523,19 @@ static unsigned int
>>>  _ctl_poll(struct file *filep, poll_table *wait)
>>>  {
>>>         struct MPT2SAS_ADAPTER *ioc;
>>> +       unsigned long flags;
>>>
>>>         poll_wait(filep, &ctl_poll_wait, wait);
>>>
>>> +       /* global ioc lock to protect controller on list operations=
 */
>>> +       spin_lock_irqsave(&gioc_lock, flags);
>>>         list_for_each_entry(ioc, &mpt2sas_ioc_list, list) {
>>> -               if (ioc->aen_event_read_flag)
>>> +               if (ioc->aen_event_read_flag) {
>>> +                       spin_unlock_irqrestore(&gioc_lock, flags);
>>>                         return POLLIN | POLLRDNORM;
>>> +               }
>>>         }
>>> +       spin_unlock_irqrestore(&gioc_lock, flags);
>>>         return 0;
>>>  }
>>>

And here.


Why not do:

>>> @@ -2168,15 +2178,22 @@ _ctl_ioctl_main(struct file *file, unsigned=
 int cmd, void __user *arg,
>>>
>>>         if (_ctl_verify_adapter(ioctl_header.ioc_number, &ioc) =3D=3D=
 -1 || !ioc)
>>>                 return -ENODEV;
>>> +       /* pci_access_mutex lock acquired by ioctl path */
>>> +       mutex_lock(&ioc->pci_access_mutex);
rc =3D -EAGAIN;
>>>         if (ioc->shost_recovery || ioc->pci_error_recovery ||
>>> -           ioc->is_driver_loading)
>>> +               ioc->is_driver_loading || ioc->remove_host) {
>>> +               mutex_unlock(&ioc->pci_access_mutex);
>>>                 return -EAGAIN;
>>> +       }

goto out_unlock_pciaccess;
>>>
>>>         state =3D (file->f_flags & O_NONBLOCK) ? NON_BLOCKING : BLO=
CKING;
>>>         if (state =3D=3D NON_BLOCKING) {
>>> -               if (!mutex_trylock(&ioc->ctl_cmds.mutex))
>>> +               if (!mutex_trylock(&ioc->ctl_cmds.mutex)) {
>>> +                       mutex_unlock(&ioc->pci_access_mutex);
>>>                         return -EAGAIN;
goto out_unlock_pciaccess;
>>> +               }
>>>         } else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex)) =
{
>>> +               mutex_unlock(&ioc->pci_access_mutex);
>>>                 return -ERESTARTSYS;

rc =3D -ERESTARTSYS;
goto out_unlock_pciaccess;
>>>         }
>>>
>>> @@ -2258,6 +2275,7 @@ _ctl_ioctl_main(struct file *file, unsigned i=
nt cmd, void __user *arg,
>>>         }
>>>
>>>         mutex_unlock(&ioc->ctl_cmds.mutex);
out_unlock_pciaccess;
>>> +       mutex_unlock(&ioc->pci_access_mutex);
>>>         return ret;
>>>  }

This was just a quick look at the patch, not the code itself, so you'll
need to check if you accidently leave ioc->ctl_cmds.mutex locked if you
do it this way.

But it simplifies the exit points.

>>>
>>> @@ -2711,6 +2729,12 @@ _ctl_BRM_status_show(struct device *cdev, st=
ruct device_attribute *attr,
>>>                     "warpdrive\n", ioc->name, __func__);
>>>                 goto out;
>>>         }
>>> +       /* pci_access_mutex lock acquired by sysfs show path */
>>> +       mutex_lock(&ioc->pci_access_mutex);
>>> +       if (ioc->pci_error_recovery || ioc->remove_host) {
>>> +               mutex_unlock(&ioc->pci_access_mutex);
>>> +               return 0;
>>> +       }
>>>
>>>         /* allocate upto GPIOVal 36 entries */
>>>         sz =3D offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) =
* 36);
>>> @@ -2749,6 +2773,7 @@ _ctl_BRM_status_show(struct device *cdev, str=
uct device_attribute *attr,
>>>
>>>   out:
>>>         kfree(io_unit_pg3);
>>> +       mutex_unlock(&ioc->pci_access_mutex);
>>>         return rc;
>>>  }
>>>  static DEVICE_ATTR(BRM_status, S_IRUGO, _ctl_BRM_status_show, NULL=
);
>>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mp=
t2sas/mpt2sas_scsih.c
>>> index 3f26147..9f7ed0f 100644
>>> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
>>> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
>>> @@ -79,7 +79,8 @@ static int _scsih_scan_finished(struct Scsi_Host =
*shost, unsigned long time);
>>>
>>>  /* global parameters */
>>>  LIST_HEAD(mpt2sas_ioc_list);
>>> -
>>> +/* global ioc lock for list operations */
>>> +DEFINE_SPINLOCK(gioc_lock);
>>>  /* local parameters */
>>>  static u8 scsi_io_cb_idx =3D -1;
>>>  static u8 tm_cb_idx =3D -1;
>>> @@ -288,13 +289,16 @@ _scsih_set_debug_level(const char *val, struc=
t kernel_param *kp)
>>>  {
>>>         int ret =3D param_set_int(val, kp);
>>>         struct MPT2SAS_ADAPTER *ioc;
>>> +       unsigned long flags;
>>>
>>>         if (ret)
>>>                 return ret;
>>>
>>>         printk(KERN_INFO "setting logging_level(0x%08x)\n", logging=
_level);
>>> +       spin_lock_irqsave(&gioc_lock, flags);
>>>         list_for_each_entry(ioc, &mpt2sas_ioc_list, list)
>>>                 ioc->logging_level =3D logging_level;
>>> +       spin_unlock_irqrestore(&gioc_lock, flags);
>>>         return 0;
>>>  }
>>>  module_param_call(logging_level, _scsih_set_debug_level, param_get=
_int,
>>> @@ -7867,7 +7871,9 @@ _scsih_remove(struct pci_dev *pdev)
>>>         sas_remove_host(shost);
>>>         scsi_remove_host(shost);
>>>         mpt2sas_base_detach(ioc);
>>> +       spin_lock_irqsave(&gioc_lock, flags);
>>>         list_del(&ioc->list);
>>> +       spin_unlock_irqrestore(&gioc_lock, flags);
>>>         scsi_host_put(shost);
>>>  }
>>>
>>> @@ -8132,6 +8138,7 @@ _scsih_probe(struct pci_dev *pdev, const stru=
ct pci_device_id *id)
>>>         struct MPT2SAS_ADAPTER *ioc;
>>>         struct Scsi_Host *shost;
>>>         int rv;
>>> +       unsigned long flags;
>>>
>>>         shost =3D scsi_host_alloc(&scsih_driver_template,
>>>             sizeof(struct MPT2SAS_ADAPTER));
>>> @@ -8142,7 +8149,9 @@ _scsih_probe(struct pci_dev *pdev, const stru=
ct pci_device_id *id)
>>>         ioc =3D shost_priv(shost);
>>>         memset(ioc, 0, sizeof(struct MPT2SAS_ADAPTER));
>>>         INIT_LIST_HEAD(&ioc->list);
>>> +       spin_lock_irqsave(&gioc_lock, flags);
>>>         list_add_tail(&ioc->list, &mpt2sas_ioc_list);
>>> +       spin_unlock_irqrestore(&gioc_lock, flags);

Again, is the irqsave version really needed?

>>>         ioc->shost =3D shost;
>>>         ioc->id =3D mpt_ids++;
>>>         sprintf(ioc->name, "%s%d", MPT2SAS_DRIVER_NAME, ioc->id);
>>> @@ -8167,6 +8176,8 @@ _scsih_probe(struct pci_dev *pdev, const stru=
ct pci_device_id *id)
>>>         ioc->schedule_dead_ioc_flush_running_cmds =3D &_scsih_flush=
_running_cmds;
>>>         /* misc semaphores and spin locks */
>>>         mutex_init(&ioc->reset_in_progress_mutex);
>>> +       /* initializing pci_access_mutex lock */
>>> +       mutex_init(&ioc->pci_access_mutex);
>>>         spin_lock_init(&ioc->ioc_reset_in_progress_lock);
>>>         spin_lock_init(&ioc->scsi_lookup_lock);
>>>         spin_lock_init(&ioc->sas_device_lock);
>>> @@ -8269,7 +8280,9 @@ _scsih_probe(struct pci_dev *pdev, const stru=
ct pci_device_id *id)
>>>   out_attach_fail:
>>>         destroy_workqueue(ioc->firmware_event_thread);
>>>   out_thread_fail:
>>> +       spin_lock_irqsave(&gioc_lock, flags);
>>>         list_del(&ioc->list);
>>> +       spin_unlock_irqrestore(&gioc_lock, flags);
>>>         scsi_host_put(shost);
>>>         return rv;
>>>  }
>>> --
>>> 1.7.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scs=
i" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=3D=
http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=3DAwIBAg&c=3DIGDlg0lD0=
b-nebmJJ0Kp8A&r=3DpgTjrEDGfGqPu_zr6l0Sfha_2nqkTk8bj3lFa2LT_F1MrbglgV67g=
sujNu2SE4YG&m=3DThFlxMm2uiQyfGyRg8DjB6ripUHLJepg9p5KAhR_nyw&s=3DW1BHmEd=
6ZxZX-lsL0P1VTbdAQ9zpAXLjCCl4LS3bUhI&e=3D
>>
>>
>>
>> --
>> Nagarajkumar Narayanan

Thanks,
Johannes

--=20
Johannes Thumshirn                                           Storage
jthumshirn@suse.de                                 +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600  D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
