From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
 kmem_cache_create+0x1a9/0x330()
Date: Fri, 18 Jul 2014 17:21:04 +0400
Message-ID: <20140718132104.GK27940@esperanza>
References: <53C8DF7F.5060707@gmail.com>
 <53C8FD95.5020302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:58604 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030296AbaGRNVT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jul 2014 09:21:19 -0400
Content-Disposition: inline
In-Reply-To: <53C8FD95.5020302@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: poma <pomidorabelisima@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>, Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

Slab warns, because the name of the cache being created contains spaces.
The "bad" cache is created by scsi_get_host_cmd_pool. Its name
(pool->cmd_name) is initialized by scsi_alloc_host_cmd_pool as follows:

	pool->cmd_name = kasprintf(GFP_KERNEL, "%s_cmd", hostt->name);

So, if hostt->name contains spaces, the cache name will also contain
spaces and we'll get the warning. And hostt->name can contain spaces,
e.g. virtscsi_host_template_single.name="Virtio SCSI HBA".

The issue was introduced by commit 89d9a567952ba ("[SCSI] add support
for per-host cmd pools"). It can be fixed e.g. by substituting spaces
with underscores in cache names.

Adding the patch author and reviewers to Cc.

On Fri, Jul 18, 2014 at 12:57:25PM +0200, poma wrote:
> 
> I guess someone working over the summertime. :)
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69 kmem_cache_create+0x1a9/0x330()
> Modules linked in: virtio_net virtio_scsi(+) drm virtio_pci i2c_core virtio_ring ata_generic pata_acpi virtio sunrpc dm_crypt dm_round_robin linear raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 iscsi_ibft iscsi_boot_sysfs floppy iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi squashfs cramfs edd dm_multipath
> CPU: 1 PID: 495 Comm: systemd-udevd Not tainted 3.16.0-0.rc5.git0.1.fc21.x86_64 #1
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>   0000000000000000 00000000bfd3b05a ffff88007f55fa40 ffffffff8171b4e3
>   0000000000000000 ffff88007f55fa78 ffffffff8108f30d ffff880079175d40
>   ffff88007f55ffd8 ffffffff81c6de08 ffff88007f55ffd8 ffff88007f55ffd8
> Call Trace:
>   [<ffffffff8171b4e3>] dump_stack+0x45/0x56
>   [<ffffffff8108f30d>] warn_slowpath_common+0x7d/0xa0
>   [<ffffffff8108f43a>] warn_slowpath_null+0x1a/0x20
>   [<ffffffff811a7c59>] kmem_cache_create+0x1a9/0x330
>   [<ffffffff814a4070>] scsi_setup_command_freelist+0x120/0x270
>   [<ffffffff814a4d90>] scsi_add_host_with_dma+0x60/0x2b0
>   [<ffffffffa017b9c9>] virtscsi_probe+0x269/0x2af [virtio_scsi]
>   [<ffffffffa01877c0>] ? vp_reset+0x90/0x90 [virtio_pci]
>   [<ffffffffa010e1d9>] virtio_dev_probe+0xe9/0x160 [virtio]
>   [<ffffffff81483d83>] driver_probe_device+0xa3/0x400
>   [<ffffffff814841ab>] __driver_attach+0x8b/0x90
>   [<ffffffff81484120>] ? __device_attach+0x40/0x40
>   [<ffffffff81481b23>] bus_for_each_dev+0x73/0xc0
>   [<ffffffff8148381e>] driver_attach+0x1e/0x20
>   [<ffffffff814833f0>] bus_add_driver+0x180/0x250
>   [<ffffffffa0180000>] ? 0xffffffffa017ffff
>   [<ffffffff81484974>] driver_register+0x64/0xf0
>   [<ffffffffa010e550>] register_virtio_driver+0x20/0x40 [virtio]
>   [<ffffffffa0180085>] init+0x85/0x1000 [virtio_scsi]
>   [<ffffffff81002148>] do_one_initcall+0xd8/0x210
>   [<ffffffff811c3952>] ? __vunmap+0xa2/0x100
>   [<ffffffff8110d951>] load_module+0x2061/0x2600
>   [<ffffffff811092f0>] ? store_uevent+0x70/0x70
>   [<ffffffff8110dfbd>] SyS_init_module+0xcd/0x120
>   [<ffffffff817223a9>] system_call_fastpath+0x16/0x1b
> ---[ end trace 64d7cf025fd3bf4a ]---
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1121092
> 
> 
> poma
> 
> 
