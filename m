From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2] libsas: fix "sysfs group not found" warnings at port
 teardown time
Date: Fri, 24 Mar 2017 17:53:54 +0100
Message-ID: <20170324165354.GJ3571@linux-x5ow.site>
References: <20150520230012.15322.1013.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170319124437.GA15094@linux-x5ow.site>
 <b98e90a0-4914-0277-4aca-03a897b59ac0@huawei.com>
 <20170321135154.GF30013@linux-x5ow.site>
 <5f350965-017b-fd5b-8fad-eba01682d72e@huawei.com>
 <20170324112347.GE3571@linux-x5ow.site>
 <8415e37f-4d96-4b92-a967-cf41a4291e8f@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33807 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936445AbdCXQx7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Mar 2017 12:53:59 -0400
Content-Disposition: inline
In-Reply-To: <8415e37f-4d96-4b92-a967-cf41a4291e8f@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

[ +Cc Tejun ]

On Fri, Mar 24, 2017 at 11:44:55AM +0000, John Garry wrote:
> To be clear, was this the same test with isci which you initially reported?

Yes, just echo into the PCI device's sysfs remove file and it'll trigger the
problem.

I did some archeology and it seems as if commit bcdde7e ("sysfs: make
__sysfs_remove_dir() recursive") introduced/uncovered this behavior.

For reference, here's one of my calltraces (the first of 40!):
------------[ cut here ]------------
WARNING: CPU: 2 PID: 5 at fs/sysfs/group.c:241 sysfs_remove_group+0xc3/0xd0
sysfs group 'power' not found for kobject 'end_device-6:0'
CPU: 16 PID: 5884 Comm: repro.sh Not tainted 4.11.0-rc3-libsas+ #504
Call Trace:
 dump_stack+0x85/0xc2
 __warn+0xc6/0xe0
 warn_slowpath_fmt+0x4a/0x50
 sysfs_remove_group+0xc3/0xd0
 dpm_sysfs_remove+0x52/0x60
 device_del+0x13c/0x360
 ? device_remove_file+0x14/0x20
 attribute_container_class_device_del+0x15/0x20
 transport_remove_classdev+0x4c/0x60
 ? transport_add_class_device+0x40/0x40
 attribute_container_device_trigger+0xb3/0xc0
 transport_remove_device+0x10/0x20
 sas_port_delete+0x12d/0x160 [scsi_transport_sas]
 sas_deform_port+0x1bf/0x1d0 [libsas]
 sas_unregister_ports+0x36/0x50 [libsas]
 sas_unregister_ha+0x1b/0x40 [libsas]
 isci_unregister+0x2a/0x40 [isci]
 isci_pci_remove+0x52/0xb0 [isci]
 ? __pm_runtime_resume+0x56/0x80
 pci_device_remove+0x34/0xb0
 device_release_driver_internal+0x158/0x210
 device_release_driver+0xd/0x10
 pci_stop_bus_device+0x85/0x90
 pci_stop_and_remove_bus_device_locked+0x15/0x30
 remove_store+0x59/0x70
 dev_attr_store+0x13/0x20
 sysfs_kf_write+0x40/0x50
 kernfs_fop_write+0x130/0x1b0
 __vfs_write+0x23/0x130
 ? rcu_read_lock_sched_held+0x6d/0x80
 ? rcu_sync_lockdep_assert+0x2a/0x50
 ? __sb_start_write+0xd7/0x1e0
 ? vfs_write+0x1a4/0x1f0
 vfs_write+0xc6/0x1f0
 SyS_write+0x44/0xa0
 entry_SYSCALL_64_fastpath+0x23/0xc6

But as I said, I don't belive this is a problem in the SAS transport or the
SAS drivers, but a device core or transport class.

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
