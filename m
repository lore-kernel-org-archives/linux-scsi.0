From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH resend] mpt2sas: setpci reset kernel panic fix
Date: Fri, 19 Jun 2015 13:38:33 +0200
Message-ID: <20150619113833.GC10784@c203.arch.suse.de>
References: <20150619111644.GA25830@nagalsi.ban.indi.seagate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbbFSLig (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 07:38:36 -0400
Content-Disposition: inline
In-Reply-To: <20150619111644.GA25830@nagalsi.ban.indi.seagate.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com>
Cc: linux-scsi@vger.kernel.org

Hi Nagarajkumar,

On Fri, Jun 19, 2015 at 04:46:44PM +0530, Nagarajkumar Narayanan wrote:
> Issue Descrition:=20
> Lack of syncrhonization between  ioctl, BRM status access, PCI resour=
ce handling results in kernel oops
> please refer bugzilla ID: 95101
>=20
> Patch Descrition:
>=20
> To provide syncrhonization locks were introduced
>=20
> 1. pci_access_mutex: mutex to sycnronize ioctl, sysfs show path and p=
ci resource handling
>=20
>=20
> 2. gioc_lock : global spin lock over mulitple warp drive controllers =
to protect list operations on ioc(controller) list

This part ^^
>=20
>=20
> From ba692140278e6e2b660896c32206b26dac98d215 Mon Sep 17 00:00:00 200=
1
> From: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com>
> Date: Thu, 19 Mar 2015 12:02:07 +0530
> Subject: [PATCH] mpt2sas setpci kernel oops fix

Belongs in here.

>=20
> Signed-off-by: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate=
=2Ecom>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_base.c  |   10 +++++++
>  drivers/scsi/mpt2sas/mpt2sas_base.h  |   20 +++++++++++++-
>  drivers/scsi/mpt2sas/mpt2sas_ctl.c   |   48 ++++++++++++++++++++++++=
+++++----
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c |   32 ++++++++++++++++++++++-
>  4 files changed, 102 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2s=
as/mpt2sas_base.c
> index 11248de..d2a498c 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -108,13 +108,18 @@ _scsih_set_fwfault_debug(const char *val, struc=
t kernel_param *kp)
>  {
>  	int ret =3D param_set_int(val, kp);
>  	struct MPT2SAS_ADAPTER *ioc;
> +	unsigned long flags;
> =20
>  	if (ret)
>  		return ret;
> =20
> +	/* global ioc spinlock to protect controller list on list operation=
s */
> +	mpt2sas_initialize_gioc_lock();
>  	printk(KERN_INFO "setting fwfault_debug(%d)\n", mpt2sas_fwfault_deb=
ug);
> +	spin_lock_irqsave(&gioc_lock, flags);
>  	list_for_each_entry(ioc, &mpt2sas_ioc_list, list)
>  		ioc->fwfault_debug =3D mpt2sas_fwfault_debug;
> +	spin_unlock_irqrestore(&gioc_lock, flags);
>  	return 0;
>  }
> =20
> @@ -4436,6 +4441,9 @@ mpt2sas_base_free_resources(struct MPT2SAS_ADAP=
TER *ioc)
>  	    __func__));
> =20
>  	if (ioc->chip_phys && ioc->chip) {
> +		/* synchronizing freeing resource with pci_access_mutex lock */
> +		if (ioc->is_warpdrive)
> +			mutex_lock(&ioc->pci_access_mutex);
>  		_base_mask_interrupts(ioc);
>  		ioc->shost_recovery =3D 1;
>  		_base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESET);
> @@ -4454,6 +4462,8 @@ mpt2sas_base_free_resources(struct MPT2SAS_ADAP=
TER *ioc)
>  		pci_disable_pcie_error_reporting(pdev);
>  		pci_disable_device(pdev);
>  	}
> +	if (ioc->is_warpdrive)
> +		mutex_unlock(&ioc->pci_access_mutex);
>  	return;
>  }
> =20
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2s=
as/mpt2sas_base.h
> index caff8d1..a0d26f0 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.h
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
> @@ -799,6 +799,12 @@ typedef void (*MPT2SAS_FLUSH_RUNNING_CMDS)(struc=
t MPT2SAS_ADAPTER *ioc);
>   * @delayed_tr_list: target reset link list
>   * @delayed_tr_volume_list: volume target reset link list
>   * @@temp_sensors_count: flag to carry the number of temperature sen=
sors
> + * @pci_access_mutex: Mutex to synchronize ioctl,sysfs show path and
> + * pci resource handling. PCI resource freeing will lead to free
> + * vital hardware/memory resource, which might be in use by cli/sysf=
s
> + * path functions resulting in Null pointer reference followed by ke=
rnel
> + * crash. To avoid the above race condition we use mutex syncrhoniza=
tion
> + * which ensures the syncrhonization between cli/sysfs_show path
>   */
>  struct MPT2SAS_ADAPTER {
>  	struct list_head list;
> @@ -1015,6 +1021,7 @@ struct MPT2SAS_ADAPTER {
>  	u8		mfg_pg10_hide_flag;
>  	u8		hide_drives;
> =20
> +	struct mutex pci_access_mutex;
>  };
> =20
>  typedef u8 (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8=
 msix_index,
> @@ -1023,6 +1030,17 @@ typedef u8 (*MPT_CALLBACK)(struct MPT2SAS_ADAP=
TER *ioc, u16 smid, u8 msix_index,
> =20
>  /* base shared API */
>  extern struct list_head mpt2sas_ioc_list;
> +/* spinlock on list operations over IOCs
> ++ * Case: when multiple warpdrive cards(IOCs) are in use
> ++ * Each IOC will added to the ioc list stucture on initialization.
> ++ * Watchdog threads run at regular intervals to check IOC for any
> ++ * fault conditions which will trigger the dead_ioc thread to
> ++ * deallocate pci resource, resulting deleting the IOC netry from l=
ist,
> ++ * this deletion need to protected by spinlock to enusre that
> ++ * ioc removal is syncrhonized, if not synchronized it might lead t=
o
> ++ * list_del corruption as the ioc list is traversed in cli path
> ++ */

There are some '++' instead of '+'

> +extern spinlock_t gioc_lock;
>  void mpt2sas_base_start_watchdog(struct MPT2SAS_ADAPTER *ioc);
>  void mpt2sas_base_stop_watchdog(struct MPT2SAS_ADAPTER *ioc);
> =20
> @@ -1099,7 +1117,7 @@ struct _sas_device *mpt2sas_scsih_sas_device_fi=
nd_by_sas_address(
>      struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
> =20
>  void mpt2sas_port_enable_complete(struct MPT2SAS_ADAPTER *ioc);
> -
> +void mpt2sas_initialize_gioc_lock(void);
>  void mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int re=
set_phase);
> =20
>  /* config shared API */
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sa=
s/mpt2sas_ctl.c
> index 4e50960..5345368 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> @@ -427,13 +427,17 @@ static int
>  _ctl_verify_adapter(int ioc_number, struct MPT2SAS_ADAPTER **iocpp)
>  {
>  	struct MPT2SAS_ADAPTER *ioc;
> -
> +	unsigned long flags;
> +	/* global ioc lock to protect controller on list operations */
> +	spin_lock_irqsave(&gioc_lock, flags);
>  	list_for_each_entry(ioc, &mpt2sas_ioc_list, list) {
>  		if (ioc->id !=3D ioc_number)
>  			continue;
> +		spin_unlock_irqrestore(&gioc_lock, flags);
>  		*iocpp =3D ioc;
>  		return ioc_number;
>  	}
> +	spin_unlock_irqrestore(&gioc_lock, flags);
>  	*iocpp =3D NULL;
>  	return -1;
>  }
> @@ -519,13 +523,19 @@ static unsigned int
>  _ctl_poll(struct file *filep, poll_table *wait)
>  {
>  	struct MPT2SAS_ADAPTER *ioc;
> +	unsigned long flags;
> =20
>  	poll_wait(filep, &ctl_poll_wait, wait);
> =20
> +	/* global ioc lock to protect controller on list operations */
> +	spin_lock_irqsave(&gioc_lock, flags);
>  	list_for_each_entry(ioc, &mpt2sas_ioc_list, list) {
> -		if (ioc->aen_event_read_flag)
> +		if (ioc->aen_event_read_flag) {
> +			spin_unlock_irqrestore(&gioc_lock, flags);
>  			return POLLIN | POLLRDNORM;
> +		}
>  	}
> +	spin_unlock_irqrestore(&gioc_lock, flags);
>  	return 0;
>  }
> =20
> @@ -2168,15 +2178,30 @@ _ctl_ioctl_main(struct file *file, unsigned i=
nt cmd, void __user *arg,
> =20
>  	if (_ctl_verify_adapter(ioctl_header.ioc_number, &ioc) =3D=3D -1 ||=
 !ioc)
>  		return -ENODEV;
> -	if (ioc->shost_recovery || ioc->pci_error_recovery ||
> -	    ioc->is_driver_loading)
> -		return -EAGAIN;
> +	if (!ioc->is_warpdrive) {
> +		if (ioc->shost_recovery || ioc->pci_error_recovery ||
> +			ioc->is_driver_loading)
> +			return -EAGAIN;
> +	} else {
> +		/* pci_access_mutex lock acquired by ioctl path */
> +		mutex_lock(&ioc->pci_access_mutex);
> +		if (ioc->shost_recovery || ioc->pci_error_recovery ||
> +			ioc->is_driver_loading || ioc->remove_host) {
> +			mutex_unlock(&ioc->pci_access_mutex);
> +			return -EAGAIN;
> +		}
> +	}
> =20
>  	state =3D (file->f_flags & O_NONBLOCK) ? NON_BLOCKING : BLOCKING;
>  	if (state =3D=3D NON_BLOCKING) {
> -		if (!mutex_trylock(&ioc->ctl_cmds.mutex))
> +		if (!mutex_trylock(&ioc->ctl_cmds.mutex)) {
> +			if (ioc->is_warpdrive)
> +				mutex_unlock(&ioc->pci_access_mutex);
>  			return -EAGAIN;
> +		}
>  	} else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex)) {
> +		if (ioc->is_warpdrive)
> +			mutex_unlock(&ioc->pci_access_mutex);
>  		return -ERESTARTSYS;
>  	}
> =20
> @@ -2258,6 +2283,8 @@ _ctl_ioctl_main(struct file *file, unsigned int=
 cmd, void __user *arg,
>  	}
> =20
>  	mutex_unlock(&ioc->ctl_cmds.mutex);
> +	if (ioc->is_warpdrive)
> +		mutex_unlock(&ioc->pci_access_mutex);
>  	return ret;
>  }
> =20
> @@ -2710,6 +2737,13 @@ _ctl_BRM_status_show(struct device *cdev, stru=
ct device_attribute *attr,
>  		printk(MPT2SAS_ERR_FMT "%s: BRM attribute is only for"\
>  		    "warpdrive\n", ioc->name, __func__);
>  		goto out;
> +	} else {
> +		/* pci_access_mutex lock acquired by sysfs show path */
> +		mutex_lock(&ioc->pci_access_mutex);
> +		if (ioc->pci_error_recovery || ioc->remove_host) {
> +			mutex_unlock(&ioc->pci_access_mutex);
> +			return 0;
> +		}
>  	}
> =20
>  	/* allocate upto GPIOVal 36 entries */
> @@ -2749,6 +2783,8 @@ _ctl_BRM_status_show(struct device *cdev, struc=
t device_attribute *attr,
> =20
>   out:
>  	kfree(io_unit_pg3);
> +	if (ioc->is_warpdrive)
> +		mutex_unlock(&ioc->pci_access_mutex);
>  	return rc;
>  }
>  static DEVICE_ATTR(BRM_status, S_IRUGO, _ctl_BRM_status_show, NULL);
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2=
sas/mpt2sas_scsih.c
> index 3f26147..ef20ed3 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -79,7 +79,8 @@ static int _scsih_scan_finished(struct Scsi_Host *s=
host, unsigned long time);
> =20
>  /* global parameters */
>  LIST_HEAD(mpt2sas_ioc_list);
> -
> +/* global ioc lock for list operations */
> +spinlock_t gioc_lock;
>  /* local parameters */
>  static u8 scsi_io_cb_idx =3D -1;
>  static u8 tm_cb_idx =3D -1;
> @@ -279,6 +280,20 @@ static struct pci_device_id scsih_pci_table[] =3D=
 {
>  MODULE_DEVICE_TABLE(pci, scsih_pci_table);
> =20
>  /**
> + * mpt2sas_initialize_gioc_lock - initialize the gobal ioc lock
> + */
> +void
> +mpt2sas_initialize_gioc_lock(void)
> +{
> +	static int gioc_lock_initialize;
> +
> +	if (!gioc_lock_initialize) {
> +		spin_lock_init(&gioc_lock);
> +		gioc_lock_initialize =3D 1;
> +	}
> +}
> +
> +/**
>   * _scsih_set_debug_level - global setting of ioc->logging_level.
>   *
>   * Note: The logging levels are defined in mpt2sas_debug.h.
> @@ -288,13 +303,17 @@ _scsih_set_debug_level(const char *val, struct =
kernel_param *kp)
>  {
>  	int ret =3D param_set_int(val, kp);
>  	struct MPT2SAS_ADAPTER *ioc;
> +	unsigned long flags;
> =20
>  	if (ret)
>  		return ret;
> =20
> +	mpt2sas_initialize_gioc_lock();
>  	printk(KERN_INFO "setting logging_level(0x%08x)\n", logging_level);
> +	spin_lock_irqsave(&gioc_lock, flags);
>  	list_for_each_entry(ioc, &mpt2sas_ioc_list, list)
>  		ioc->logging_level =3D logging_level;
> +	spin_unlock_irqrestore(&gioc_lock, flags);
>  	return 0;
>  }
>  module_param_call(logging_level, _scsih_set_debug_level, param_get_i=
nt,
> @@ -7867,7 +7886,9 @@ _scsih_remove(struct pci_dev *pdev)
>  	sas_remove_host(shost);
>  	scsi_remove_host(shost);
>  	mpt2sas_base_detach(ioc);
> +	spin_lock_irqsave(&gioc_lock, flags);
>  	list_del(&ioc->list);
> +	spin_unlock_irqrestore(&gioc_lock, flags);
>  	scsi_host_put(shost);
>  }
> =20
> @@ -8132,6 +8153,7 @@ _scsih_probe(struct pci_dev *pdev, const struct=
 pci_device_id *id)
>  	struct MPT2SAS_ADAPTER *ioc;
>  	struct Scsi_Host *shost;
>  	int rv;
> +	unsigned long flags;
> =20
>  	shost =3D scsi_host_alloc(&scsih_driver_template,
>  	    sizeof(struct MPT2SAS_ADAPTER));
> @@ -8142,7 +8164,9 @@ _scsih_probe(struct pci_dev *pdev, const struct=
 pci_device_id *id)
>  	ioc =3D shost_priv(shost);
>  	memset(ioc, 0, sizeof(struct MPT2SAS_ADAPTER));
>  	INIT_LIST_HEAD(&ioc->list);
> +	spin_lock_irqsave(&gioc_lock, flags);
>  	list_add_tail(&ioc->list, &mpt2sas_ioc_list);
> +	spin_unlock_irqrestore(&gioc_lock, flags);
>  	ioc->shost =3D shost;
>  	ioc->id =3D mpt_ids++;
>  	sprintf(ioc->name, "%s%d", MPT2SAS_DRIVER_NAME, ioc->id);
> @@ -8167,6 +8191,9 @@ _scsih_probe(struct pci_dev *pdev, const struct=
 pci_device_id *id)
>  	ioc->schedule_dead_ioc_flush_running_cmds =3D &_scsih_flush_running=
_cmds;
>  	/* misc semaphores and spin locks */
>  	mutex_init(&ioc->reset_in_progress_mutex);
> +	/* initializing pci_access_mutex lock */
> +	if (ioc->is_warpdrive)
> +		mutex_init(&ioc->pci_access_mutex);
>  	spin_lock_init(&ioc->ioc_reset_in_progress_lock);
>  	spin_lock_init(&ioc->scsi_lookup_lock);
>  	spin_lock_init(&ioc->sas_device_lock);
> @@ -8269,7 +8296,9 @@ _scsih_probe(struct pci_dev *pdev, const struct=
 pci_device_id *id)
>   out_attach_fail:
>  	destroy_workqueue(ioc->firmware_event_thread);
>   out_thread_fail:
> +	spin_lock_irqsave(&gioc_lock, flags);
>  	list_del(&ioc->list);
> +	spin_unlock_irqrestore(&gioc_lock, flags);
>  	scsi_host_put(shost);
>  	return rv;
>  }
> @@ -8506,6 +8535,7 @@ _scsih_init(void)
>  		return -ENODEV;
>  	}
> =20
> +	mpt2sas_initialize_gioc_lock();
>  	mpt2sas_base_initialize_callback_handler();
> =20
>  	 /* queuecommand callback hander */
> --=20
> 1.7.1
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in

Generally, would it be sufficiant to have _one_ call to
mpt2sas_initialize_gioc_lock() (per instance)? This way a) everbody (re=
ad
people debugging it) knew it will be already initialized and b) you don=
't need
is already initialized check any more.


Thanks,
	Johannes

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
