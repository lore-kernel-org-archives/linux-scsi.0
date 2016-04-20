From: Johannes Thumshirn <jthmshirn@suse.de>
Subject: Re: alloc failure in qla1280 probe -- need to decrease can_queue?
Date: Wed, 20 Apr 2016 16:15:35 +0200
Message-ID: <20160420141535.GF28402@c203.arch.suse.de>
References: <57155A93.7090604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbcDTOPk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2016 10:15:40 -0400
Content-Disposition: inline
In-Reply-To: <57155A93.7090604@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laura Abbott <labbott@redhat.com>
Cc: Michael Reed <mdr@sgi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

[+Cc Michael Reed as get_maintainer.pl lists him as qla1280 maintainer =
]

On Mon, Apr 18, 2016 at 03:07:15PM -0700, Laura Abbott wrote:
> Hi,
>=20
> We received a bug report https://bugzilla.redhat.com/show_bug.cgi?id=3D=
1321033
> of qla1280 scsi host failure on 4.4 based kernels that looks to be ca=
used
> by page alloc failure:
>=20
> [    4.804166] scsi host0: QLogic QLA1040 PCI to SCSI Host Adapter
>                       Firmware version:  7.65.06, Driver version 3.27=
=2E1
> [    4.804174] ------------[ cut here ]------------
> [    4.804184] WARNING: CPU: 2 PID: 305 at mm/page_alloc.c:2989 __all=
oc_pages_nodemask+0xae8/0xbc0()
> [    4.804186] Modules linked in: amdkfd amd_iommu_v2 radeon i2c_algo=
_bit drm_kms_helper ttm drm megaraid_sas serio_raw 8021q garp bnx2 stp =
llc mrp sunhme qla1280(+) fjes
> [    4.804208] CPU: 2 PID: 305 Comm: systemd-udevd Not tainted 4.4.6-=
201.fc22.x86_64 #1
> [    4.804210] Hardware name: Google Enterprise Search Appliance/0DT0=
21, BIOS 1.1.2 08/14/2006
> [    4.804212]  0000000000000286 000000002f01064c ffff88042985b710 ff=
ffffff813b542e
> [    4.804216]  0000000000000000 ffffffff81a75024 ffff88042985b748 ff=
ffffff810a40f2
> [    4.804220]  0000000000000000 0000000000000000 000000000000000b 00=
00000000000000
> [    4.804223] Call Trace:
> [    4.804231]  [<ffffffff813b542e>] dump_stack+0x63/0x85
> [    4.804236]  [<ffffffff810a40f2>] warn_slowpath_common+0x82/0xc0
> [    4.804239]  [<ffffffff810a423a>] warn_slowpath_null+0x1a/0x20
> [    4.804242]  [<ffffffff811b75e8>] __alloc_pages_nodemask+0xae8/0xb=
c0
> [    4.804247]  [<ffffffff817a002e>] ? _raw_spin_unlock_irqrestore+0x=
e/0x10
> [    4.804251]  [<ffffffff811908be>] ? irq_work_queue+0x8e/0xa0
> [    4.804256]  [<ffffffff810fa10a>] ? console_unlock+0x20a/0x540
> [    4.804262]  [<ffffffff812029cc>] alloc_pages_current+0x8c/0x110
> [    4.804265]  [<ffffffff811b5159>] alloc_kmem_pages+0x19/0x90
> [    4.804268]  [<ffffffff811d2efe>] kmalloc_order_trace+0x2e/0xe0
> [    4.804272]  [<ffffffff8120e6d2>] __kmalloc+0x232/0x260
> [    4.804277]  [<ffffffff8138990d>] init_tag_map+0x3d/0xc0
> [    4.804290]  [<ffffffff813899d5>] __blk_queue_init_tags+0x45/0x80
> [    4.804293]  [<ffffffff81389a24>] blk_init_tags+0x14/0x20
> [    4.804298]  [<ffffffff81520e60>] scsi_add_host_with_dma+0x80/0x30=
0
> [    4.804305]  [<ffffffffa000fec3>] qla1280_probe_one+0x683/0x9ef [q=
la1280]
> [    4.804309]  [<ffffffff81401115>] local_pci_probe+0x45/0xa0
> [    4.804312]  [<ffffffff814024fd>] pci_device_probe+0xfd/0x140
> [    4.804316]  [<ffffffff814ef1d2>] driver_probe_device+0x222/0x490
> [    4.804319]  [<ffffffff814ef4c4>] __driver_attach+0x84/0x90
> [    4.804321]  [<ffffffff814ef440>] ? driver_probe_device+0x490/0x49=
0
> [    4.804324]  [<ffffffff814eccac>] bus_for_each_dev+0x6c/0xc0
> [    4.804326]  [<ffffffff814ee98e>] driver_attach+0x1e/0x20
> [    4.804328]  [<ffffffff814ee4cb>] bus_add_driver+0x1eb/0x280
> [    4.804331]  [<ffffffffa0015000>] ? 0xffffffffa0015000
> [    4.804333]  [<ffffffff814efd80>] driver_register+0x60/0xe0
> [    4.804336]  [<ffffffff81400a5c>] __pci_register_driver+0x4c/0x50
> [    4.804339]  [<ffffffffa00151ce>] qla1280_init+0x1ce/0x1000 [qla12=
80]
> [    4.804341]  [<ffffffffa0015000>] ? 0xffffffffa0015000
> [    4.804345]  [<ffffffff81002123>] do_one_initcall+0xb3/0x200
> [    4.804348]  [<ffffffff8120d086>] ? kmem_cache_alloc_trace+0x196/0=
x210
> [    4.804352]  [<ffffffff811aba7e>] ? do_init_module+0x27/0x1cb
> [    4.804354]  [<ffffffff811abab6>] do_init_module+0x5f/0x1cb
> [    4.804358]  [<ffffffff8112a6e0>] load_module+0x2040/0x2680
> [    4.804360]  [<ffffffff81126e40>] ? __symbol_put+0x60/0x60
> [    4.804363]  [<ffffffff8112ae69>] SYSC_init_module+0x149/0x190
> [    4.804366]  [<ffffffff8112af9e>] SyS_init_module+0xe/0x10
> [    4.804369]  [<ffffffff817a05ae>] entry_SYSCALL_64_fastpath+0x12/0=
x71
> [    4.804371] ---[ end trace 0ea3b625f86705f7 ]---
> [    4.804581] qla1280: probe of 0000:11:04.0 failed with error -12
>=20
> This looks very similar to http://www.spinics.net/lists/linux-usb/msg=
136998.html
> which was fixed by 55ff8cfbc4e1 ("USB: uas: Reduce can_queue to MAX_C=
MNDS").
> Does a similar fix need to be applied here?
>=20
> Thanks,
> Laura

Can you (or better the reporter) try below? Unfortunately I don't have =
a
qla1280 setup here, so I couldn't test it myself.

Byte,
	Johannes

=46rom f95e82e7e5f675c9869ea1da78021aa6abc7972b Mon Sep 17 00:00:00 200=
1
=46rom: Johannes Thumshirn <jthumshirn@suse.de>
Date: Wed, 20 Apr 2016 16:07:37 +0200
Subject: [PATCH] qla1280: Reduce can_queue to 32

The qla1280 driver sets the scsi_host_template's can_queue field to 0xf=
ffff
which results in an allocation failure when allocating the block layer =
tags
for the driver's queues like the one shown below:

[    4.804166] scsi host0: QLogic QLA1040 PCI to SCSI Host Adapter Firm=
ware version:  7.65.06, Driver version 3.27.1
[    4.804174] ------------[ cut here ]------------
[    4.804184] WARNING: CPU: 2 PID: 305 at mm/page_alloc.c:2989 alloc_p=
ages_nodemask+0xae8/0xbc0()
[    4.804186] Modules linked in: amdkfd amd_iommu_v2 radeon i2c_algo_b=
it m_kms_helper ttm drm megaraid_sas serio_raw 8021q garp bnx2 stp llc =
mrp nhme qla1280(+) fjes
[    4.804208] CPU: 2 PID: 305 Comm: systemd-udevd Not tainted 4.6-201.=
fc22.x86_64 #1
[    4.804210] Hardware name: Google Enterprise Search Appliance/0DT021=
, OS 1.1.2 08/14/2006
[    4.804212]  0000000000000286 000000002f01064c ffff88042985b710 ffff=
ff813b542e
[    4.804216]  0000000000000000 ffffffff81a75024 ffff88042985b748 ffff=
ff810a40f2
[    4.804220]  0000000000000000 0000000000000000 000000000000000b 0000=
0000000000
[    4.804223] Call Trace:
[    4.804231]  [<ffffffff813b542e>] dump_stack+0x63/0x85
[    4.804236]  [<ffffffff810a40f2>] warn_slowpath_common+0x82/0xc0
[    4.804239]  [<ffffffff810a423a>] warn_slowpath_null+0x1a/0x20
[    4.804242]  [<ffffffff811b75e8>] __alloc_pages_nodemask+0xae8/0xbc0
[    4.804247]  [<ffffffff817a002e>] ? _raw_spin_unlock_irqrestore+0xe/=
0x10
[    4.804251]  [<ffffffff811908be>] ? irq_work_queue+0x8e/0xa0
[    4.804256]  [<ffffffff810fa10a>] ? console_unlock+0x20a/0x540
[    4.804262]  [<ffffffff812029cc>] alloc_pages_current+0x8c/0x110
[    4.804265]  [<ffffffff811b5159>] alloc_kmem_pages+0x19/0x90
[    4.804268]  [<ffffffff811d2efe>] kmalloc_order_trace+0x2e/0xe0
[    4.804272]  [<ffffffff8120e6d2>] __kmalloc+0x232/0x260
[    4.804277]  [<ffffffff8138990d>] init_tag_map+0x3d/0xc0
[    4.804290]  [<ffffffff813899d5>] __blk_queue_init_tags+0x45/0x80
[    4.804293]  [<ffffffff81389a24>] blk_init_tags+0x14/0x20
[    4.804298]  [<ffffffff81520e60>] scsi_add_host_with_dma+0x80/0x300
[    4.804305]  [<ffffffffa000fec3>] qla1280_probe_one+0x683/0x9ef [qla=
1280]
[    4.804309]  [<ffffffff81401115>] local_pci_probe+0x45/0xa0
[    4.804312]  [<ffffffff814024fd>] pci_device_probe+0xfd/0x140
[    4.804316]  [<ffffffff814ef1d2>] driver_probe_device+0x222/0x490
[    4.804319]  [<ffffffff814ef4c4>] __driver_attach+0x84/0x90
[    4.804321]  [<ffffffff814ef440>] ? driver_probe_device+0x490/0x490
[    4.804324]  [<ffffffff814eccac>] bus_for_each_dev+0x6c/0xc0
[    4.804326]  [<ffffffff814ee98e>] driver_attach+0x1e/0x20
[    4.804328]  [<ffffffff814ee4cb>] bus_add_driver+0x1eb/0x280
[    4.804331]  [<ffffffffa0015000>] ? 0xffffffffa0015000
[    4.804333]  [<ffffffff814efd80>] driver_register+0x60/0xe0
[    4.804336]  [<ffffffff81400a5c>] __pci_register_driver+0x4c/0x50
[    4.804339]  [<ffffffffa00151ce>] qla1280_init+0x1ce/0x1000 [qla1280=
]
[    4.804341]  [<ffffffffa0015000>] ? 0xffffffffa0015000
[    4.804345]  [<ffffffff81002123>] do_one_initcall+0xb3/0x200
[    4.804348]  [<ffffffff8120d086>] ? kmem_cache_alloc_trace+0x196/0x2=
10
[    4.804352]  [<ffffffff811aba7e>] ? do_init_module+0x27/0x1cb
[    4.804354]  [<ffffffff811abab6>] do_init_module+0x5f/0x1cb
[    4.804358]  [<ffffffff8112a6e0>] load_module+0x2040/0x2680
[    4.804360]  [<ffffffff81126e40>] ? __symbol_put+0x60/0x60
[    4.804363]  [<ffffffff8112ae69>] SYSC_init_module+0x149/0x190
[    4.804366]  [<ffffffff8112af9e>] SyS_init_module+0xe/0x10
[    4.804369]  [<ffffffff817a05ae>] entry_SYSCALL_64_fastpath+0x12/0x7=
1
[    4.804371] ---[ end trace 0ea3b625f86705f7 ]---
[    4.804581] qla1280: probe of 0000:11:04.0 failed with error -12

In qla1280_set_defaults() the maximum queue depth is
set to 32 so adopt the scsi_host_template to it as well.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/qla1280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 5d0ec42..6bd748e 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4214,7 +4214,7 @@ static struct scsi_host_template qla1280_driver_t=
emplate =3D {
 	.eh_bus_reset_handler	=3D qla1280_eh_bus_reset,
 	.eh_host_reset_handler	=3D qla1280_eh_adapter_reset,
 	.bios_param		=3D qla1280_biosparam,
-	.can_queue		=3D 0xfffff,
+	.can_queue		=3D 32,
 	.this_id		=3D -1,
 	.sg_tablesize		=3D SG_ALL,
 	.use_clustering		=3D ENABLE_CLUSTERING,
--=20
2.8.1


--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
