From: Johannes Thumshirn <jthmshirn@suse.de>
Subject: Re: [PATCH] qla1280: Reduce can_queue to 32
Date: Fri, 22 Apr 2016 16:01:48 +0200
Message-ID: <20160422140148.GV28402@c203.arch.suse.de>
References: <1461310270-8945-1-git-send-email-jthumshirn@suse.de>
 <668592243.31153125.1461327404017.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <668592243.31153125.1461327404017.JavaMail.zimbra@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Laura Abbott <labbott@redhat.com>, Michael Reed <mdr@sgi.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 22, 2016 at 08:16:44AM -0400, Laurence Oberman wrote:
> The change looks fine, I see its hard-coded to 32 in qla1280_set_defa=
ults()
> Would it be better to create a #define like other drivers and use tha=
t in both.
> Also did the below patch resolve this for the bug reporter.

Yes, that's probably a reasonable idea, I'll re-send.

> I ask because if I check 4.3 it was also set to the same value of 0xf=
ffff and that is reported as working.
> So other changes in 4.4 must be "abusing" this high value.

I think it was introduced with commit 64d513ac31b - "scsi: use host wid=
e
tags by default". Since this commit scsi_add_host_with_dma() directly c=
alls
blk_init_tags() instead of scsi_init_shared_tag_map(). The qla1280 driv=
er
has never set up the block tags though, so the bogus value was not a pr=
oblem.
That at least is my analysis, feel free to correct my assumptions.

>=20
> Reviewed-by Laurence Oberman <loberman@redhat.com>
>=20
> Laurence Oberman
> Principal Software Maintenance Engineer
> Red Hat Global Support Services
>=20
> ----- Original Message -----
> From: "Johannes Thumshirn" <jthumshirn@suse.de>
> To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J =
=2E Bottomley" <jejb@linux.vnet.ibm.com>
> Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Johann=
es Thumshirn" <jthumshirn@suse.de>, "Laura Abbott" <labbott@redhat.com>=
, "Michael Reed" <mdr@sgi.com>, stable@vger.kernel.org
> Sent: Friday, April 22, 2016 3:31:10 AM
> Subject: [PATCH] qla1280: Reduce can_queue to 32
>=20
> It was reported in https://bugzilla.redhat.com/show_bug.cgi?id=3D1321=
033,
> that the qla1280 driver sets the scsi_host_template's can_queue field
> to 0xfffff which results in an allocation failure when allocating the
> block layer tags for the driver's queues like the one shown below:
>=20
> [    4.804166] scsi host0: QLogic QLA1040 PCI to SCSI Host Adapter Fi=
rmware version:  7.65.06, Driver version 3.27.1
> [    4.804174] ------------[ cut here ]------------
> [    4.804184] WARNING: CPU: 2 PID: 305 at mm/page_alloc.c:2989 alloc=
_pages_nodemask+0xae8/0xbc0()
> [    4.804186] Modules linked in: amdkfd amd_iommu_v2 radeon i2c_algo=
_bit m_kms_helper ttm drm megaraid_sas serio_raw 8021q garp bnx2 stp ll=
c mrp nhme qla1280(+) fjes
> [    4.804208] CPU: 2 PID: 305 Comm: systemd-udevd Not tainted 4.6-20=
1.fc22.x86_64 #1
> [    4.804210] Hardware name: Google Enterprise Search Appliance/0DT0=
21, OS 1.1.2 08/14/2006
> [    4.804212]  0000000000000286 000000002f01064c ffff88042985b710 ff=
ffff813b542e
> [    4.804216]  0000000000000000 ffffffff81a75024 ffff88042985b748 ff=
ffff810a40f2
> [    4.804220]  0000000000000000 0000000000000000 000000000000000b 00=
000000000000
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
> In qla1280_set_defaults() the maximum queue depth is
> set to 32 so adopt the scsi_host_template to it as well.
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: Michael Reed <mdr@sgi.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/qla1280.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 5d0ec42..6bd748e 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -4214,7 +4214,7 @@ static struct scsi_host_template qla1280_driver=
_template =3D {
>  	.eh_bus_reset_handler	=3D qla1280_eh_bus_reset,
>  	.eh_host_reset_handler	=3D qla1280_eh_adapter_reset,
>  	.bios_param		=3D qla1280_biosparam,
> -	.can_queue		=3D 0xfffff,
> +	.can_queue		=3D 32,
>  	.this_id		=3D -1,
>  	.sg_tablesize		=3D SG_ALL,
>  	.use_clustering		=3D ENABLE_CLUSTERING,
> --=20
> 2.8.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
