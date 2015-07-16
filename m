From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] mpt2sas: setpci reset kernel oops fix
Date: Thu, 16 Jul 2015 13:19:42 +0200
Message-ID: <55A7934E.4070503@suse.de>
References: <20150714112336.GA9785@nagalsi.ban.indi.seagate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59725 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbbGPLTp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jul 2015 07:19:45 -0400
In-Reply-To: <20150714112336.GA9785@nagalsi.ban.indi.seagate.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com>, linux-scsi@vger.kernel.org
Cc: hch@infradead.org, jthumshirn@suse.de

On 07/14/2015 01:23 PM, Nagarajkumar Narayanan wrote:
>=20
> Patch Description:
>=20
> In mpt2sas driver due to lack of synchronization between ioctl,
> BRM status access through sysfs, pci resource removal kernel oops
> happen as ioctl path and BRM status sysfs access path still tries
> to access the removed resources
>=20
> kernel: BUG: unable to handle kernel paging request at ffffc900171e00=
00
>=20
> Oops: 0000 [#1] SMP
>=20
> Two locks added to provide syncrhonization
>=20
> 1. pci_access_mutex: Mutex to synchronize ioctl,sysfs show path and
> pci resource handling. PCI resource freeing will lead to free
> vital hardware/memory resource, which might be in use by cli/sysfs
> path functions resulting in Null pointer reference followed by kernel
> crash. To avoid the above race condition we use mutex syncrhonization
> which ensures the syncrhonization between cli/sysfs_show path
>=20
> 2. spinlock on list operations over IOCs
>=20
> Case: when multiple warpdrive cards(IOCs) are in use
> Each IOC will added to the ioc list stucture on initialization.
> Watchdog threads run at regular intervals to check IOC for any
> fault conditions which will trigger the dead_ioc thread to
> deallocate pci resource, resulting deleting the IOC netry from list,
> this deletion need to protected by spinlock to enusre that
> ioc removal is syncrhonized, if not synchronized it might lead to
> list_del corruption as the ioc list is traversed in cli path
>=20
>=20
> From 8db4d8194276ba420a4e93de4b09df6da5a934e4 Mon Sep 17 00:00:00 200=
1
> From: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com>
> Date: Tue, 14 Jul 2015 16:33:56 +0530
> Subject: [PATCH] mpt2sas setpci reset oops fix
>=20
> setpci reset on nytro warpdrive card along with sysfs access and
> cli ioctl access resulted in kernel oops
>=20
> 1. pci_access_mutex lock added to provide synchronization between IOC=
TL,
>    sysfs, PCI resource handling path
>=20
> 2. gioc_lock spinlock to protect list operations over multiple
> controllers
>=20
> Signed-off-by: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate=
=2Ecom>
> ---
> * v2
> - removed is_warpdrive condition for pci_access_mutex lock
>=20
> * v1
> - using DEFINE_SPINLOCK() to initialize the lock at compile time inst=
ead
>   of using spin_lock_init
>=20
>  drivers/scsi/mpt2sas/mpt2sas_base.c  |    7 +++++++
>  drivers/scsi/mpt2sas/mpt2sas_base.h  |   19 ++++++++++++++++++-
>  drivers/scsi/mpt2sas/mpt2sas_ctl.c   |   33 ++++++++++++++++++++++++=
+++++----
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c |   15 ++++++++++++++-
>  4 files changed, 68 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2s=
as/mpt2sas_base.c
> index 11248de..f04dcc0 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -108,13 +108,17 @@ _scsih_set_fwfault_debug(const char *val, struc=
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
>  	printk(KERN_INFO "setting fwfault_debug(%d)\n", mpt2sas_fwfault_deb=
ug);
> +	spin_lock_irqsave(&gioc_lock, flags);
>  	list_for_each_entry(ioc, &mpt2sas_ioc_list, list)
>  		ioc->fwfault_debug =3D mpt2sas_fwfault_debug;
> +	spin_unlock_irqrestore(&gioc_lock, flags);
>  	return 0;
>  }
> =20
> @@ -4436,6 +4440,8 @@ mpt2sas_base_free_resources(struct MPT2SAS_ADAP=
TER *ioc)
>  	    __func__));
> =20
>  	if (ioc->chip_phys && ioc->chip) {
> +		/* synchronizing freeing resource with pci_access_mutex lock */
> +		mutex_lock(&ioc->pci_access_mutex);
>  		_base_mask_interrupts(ioc);
>  		ioc->shost_recovery =3D 1;
>  		_base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESET);
> @@ -4454,6 +4460,7 @@ mpt2sas_base_free_resources(struct MPT2SAS_ADAP=
TER *ioc)
>  		pci_disable_pcie_error_reporting(pdev);
>  		pci_disable_device(pdev);
>  	}
> +	mutex_unlock(&ioc->pci_access_mutex);
>  	return;
>  }
> =20
Lock imbalance. Please move the call to 'mutex_lock()' out of the
'if' clause.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
