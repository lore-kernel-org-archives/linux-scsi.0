From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] scsi: isci: remove the SAS host after the SCSI host
Date: Wed, 29 Mar 2017 12:17:12 +0200
Message-ID: <a52fbdcd-8454-cd54-6259-feb3a3916887@suse.de>
References: <cover.1490775958.git.jthumshirn@suse.de>
 <8e1f09349eede72eaa7322413f90a80109a8b43b.1490775958.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8e1f09349eede72eaa7322413f90a80109a8b43b.1490775958.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, Dan Williams <dan.j.williams@intel.com>, John Garry <john.garry@huawei.com>, Jack Wang <jinpu.wang@profitbricks.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 03/29/2017 11:41 AM, Johannes Thumshirn wrote:
> After commit bcdde7e ("sysfs: make __sysfs_remove_dir() recursive") changed the
> removal path of kernfs to make it recursive we have to remove the SAS host
> before the SCSI host or we will see sysfs warnings like the below when
> triggering the the removal of the SAS HBA PCI device like with writing to the
> sysfs pci remove file:
> 
> echo 1 > /sys/module/isci/drivers/pci:isci/<device>/remove
> 
> WARNING: CPU: 2 PID: 5 at fs/sysfs/group.c:241 sysfs_remove_group+0xc3/0xd0
> sysfs group 'power' not found for kobject 'end_device-6:0'
> CPU: 16 PID: 5884 Comm: echo Not tainted 4.11.0-rc3-libsas+ #504
> Call Trace:
>  dump_stack+0x85/0xc2
>  __warn+0xc6/0xe0
>  warn_slowpath_fmt+0x4a/0x50
>  sysfs_remove_group+0xc3/0xd0
>  dpm_sysfs_remove+0x52/0x60
>  device_del+0x13c/0x360
>  ? device_remove_file+0x14/0x20
>  attribute_container_class_device_del+0x15/0x20
>  transport_remove_classdev+0x4c/0x60
>  ? transport_add_class_device+0x40/0x40
>  attribute_container_device_trigger+0xb3/0xc0
>  transport_remove_device+0x10/0x20
>  sas_port_delete+0x12d/0x160 [scsi_transport_sas]
>  sas_deform_port+0x1bf/0x1d0 [libsas]
>  sas_unregister_ports+0x36/0x50 [libsas]
>  sas_unregister_ha+0x1b/0x40 [libsas]
>  isci_unregister+0x2a/0x40 [isci]
>  isci_pci_remove+0x52/0xb0 [isci]
>  ? __pm_runtime_resume+0x56/0x80
>  pci_device_remove+0x34/0xb0
>  device_release_driver_internal+0x158/0x210
>  device_release_driver+0xd/0x10
>  pci_stop_bus_device+0x85/0x90
>  pci_stop_and_remove_bus_device_locked+0x15/0x30
>  remove_store+0x59/0x70
>  dev_attr_store+0x13/0x20
>  sysfs_kf_write+0x40/0x50
>  kernfs_fop_write+0x130/0x1b0
>  __vfs_write+0x23/0x130
>  ? rcu_read_lock_sched_held+0x6d/0x80
>  ? rcu_sync_lockdep_assert+0x2a/0x50
>  ? __sb_start_write+0xd7/0x1e0
>  ? vfs_write+0x1a4/0x1f0
>  vfs_write+0xc6/0x1f0
>  SyS_write+0x44/0xa0
>  entry_SYSCALL_64_fastpath+0x23/0xc6
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/isci/init.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
