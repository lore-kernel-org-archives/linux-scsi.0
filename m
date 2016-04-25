From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] qla1280: Reduce can_queue to 512
Date: Mon, 25 Apr 2016 07:31:39 -0700
Message-ID: <1461594699.2392.1.camel@linux.vnet.ibm.com>
References: <1461568618-18963-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1461568618-18963-1-git-send-email-jthumshirn@suse.de>
Sender: stable-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Laurence Oberman <loberman@redhat.com>, Laura Abbott <labbott@redhat.com>, Michael Reed <mdr@sgi.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2016-04-25 at 09:16 +0200, Johannes Thumshirn wrote:
> The qla1280 driver sets the scsi_host_template's can_queue field to
> 0xfffff
> which results in an allocation failure when allocating the block
> layer tags
> for the driver's queues like the one shown below:
> 
> [    4.804166] scsi host0: QLogic QLA1040 PCI to SCSI Host Adapter
> Firmware version:  7.65.06, Driver version 3.27.1
> [    4.804174] ------------[ cut here ]------------
> [    4.804184] WARNING: CPU: 2 PID: 305 at mm/page_alloc.c:2989
> alloc_pages_nodemask+0xae8/0xbc0()
> [    4.804186] Modules linked in: amdkfd amd_iommu_v2 radeon
> i2c_algo_bit m_kms_helper ttm drm megaraid_sas serio_raw 8021q garp
> bnx2 stp llc mrp nhme qla1280(+) fjes
> [    4.804208] CPU: 2 PID: 305 Comm: systemd-udevd Not tainted 4.6
> -201.fc22.x86_64 #1
> [    4.804210] Hardware name: Google Enterprise Search
> Appliance/0DT021, OS 1.1.2 08/14/2006
> [    4.804212]  0000000000000286 000000002f01064c ffff88042985b710
> ffffff813b542e
> [    4.804216]  0000000000000000 ffffffff81a75024 ffff88042985b748
> ffffff810a40f2
> [    4.804220]  0000000000000000 0000000000000000 000000000000000b
> 00000000000000
> [    4.804223] Call Trace:
> [    4.804231]  [<ffffffff813b542e>] dump_stack+0x63/0x85
> [    4.804236]  [<ffffffff810a40f2>] warn_slowpath_common+0x82/0xc0
> [    4.804239]  [<ffffffff810a423a>] warn_slowpath_null+0x1a/0x20
> [    4.804242]  [<ffffffff811b75e8>]
> __alloc_pages_nodemask+0xae8/0xbc0
> [    4.804247]  [<ffffffff817a002e>] ?
> _raw_spin_unlock_irqrestore+0xe/0x10
> [    4.804251]  [<ffffffff811908be>] ? irq_work_queue+0x8e/0xa0
> [    4.804256]  [<ffffffff810fa10a>] ? console_unlock+0x20a/0x540
> [    4.804262]  [<ffffffff812029cc>] alloc_pages_current+0x8c/0x110
> [    4.804265]  [<ffffffff811b5159>] alloc_kmem_pages+0x19/0x90
> [    4.804268]  [<ffffffff811d2efe>] kmalloc_order_trace+0x2e/0xe0
> [    4.804272]  [<ffffffff8120e6d2>] __kmalloc+0x232/0x260
> [    4.804277]  [<ffffffff8138990d>] init_tag_map+0x3d/0xc0
> [    4.804290]  [<ffffffff813899d5>] __blk_queue_init_tags+0x45/0x80
> [    4.804293]  [<ffffffff81389a24>] blk_init_tags+0x14/0x20
> [    4.804298]  [<ffffffff81520e60>]
> scsi_add_host_with_dma+0x80/0x300
> [    4.804305]  [<ffffffffa000fec3>] qla1280_probe_one+0x683/0x9ef
> [qla1280]
> [    4.804309]  [<ffffffff81401115>] local_pci_probe+0x45/0xa0
> [    4.804312]  [<ffffffff814024fd>] pci_device_probe+0xfd/0x140
> [    4.804316]  [<ffffffff814ef1d2>] driver_probe_device+0x222/0x490
> [    4.804319]  [<ffffffff814ef4c4>] __driver_attach+0x84/0x90
> [    4.804321]  [<ffffffff814ef440>] ?
> driver_probe_device+0x490/0x490
> [    4.804324]  [<ffffffff814eccac>] bus_for_each_dev+0x6c/0xc0
> [    4.804326]  [<ffffffff814ee98e>] driver_attach+0x1e/0x20
> [    4.804328]  [<ffffffff814ee4cb>] bus_add_driver+0x1eb/0x280
> [    4.804331]  [<ffffffffa0015000>] ? 0xffffffffa0015000
> [    4.804333]  [<ffffffff814efd80>] driver_register+0x60/0xe0
> [    4.804336]  [<ffffffff81400a5c>] __pci_register_driver+0x4c/0x50
> [    4.804339]  [<ffffffffa00151ce>] qla1280_init+0x1ce/0x1000
> [qla1280]
> [    4.804341]  [<ffffffffa0015000>] ? 0xffffffffa0015000
> [    4.804345]  [<ffffffff81002123>] do_one_initcall+0xb3/0x200
> [    4.804348]  [<ffffffff8120d086>] ?
> kmem_cache_alloc_trace+0x196/0x210
> [    4.804352]  [<ffffffff811aba7e>] ? do_init_module+0x27/0x1cb
> [    4.804354]  [<ffffffff811abab6>] do_init_module+0x5f/0x1cb
> [    4.804358]  [<ffffffff8112a6e0>] load_module+0x2040/0x2680
> [    4.804360]  [<ffffffff81126e40>] ? __symbol_put+0x60/0x60
> [    4.804363]  [<ffffffff8112ae69>] SYSC_init_module+0x149/0x190
> [    4.804366]  [<ffffffff8112af9e>] SyS_init_module+0xe/0x10
> [    4.804369]  [<ffffffff817a05ae>]
> entry_SYSCALL_64_fastpath+0x12/0x71
> [    4.804371] ---[ end trace 0ea3b625f86705f7 ]---
> [    4.804581] qla1280: probe of 0000:11:04.0 failed with error -12
> 
> Reduce can_queue to 512 to solve the allocation error.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Fixes: 64d513ac31b - "scsi: use host wide tags by default"
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: Michael Reed <mdr@sgi.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Laurence Oberman <loberman@redhat.com>
> ---
> Changes to v2:
> * Change can_queue to 512 upon James' request
> 
> 
>  drivers/scsi/qla1280.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 5d0ec42..6abd6ca 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -4214,7 +4214,7 @@ static struct scsi_host_template
> qla1280_driver_template = {
>  	.eh_bus_reset_handler	= qla1280_eh_bus_reset,
>  	.eh_host_reset_handler	= qla1280_eh_adapter_reset,
>  	.bios_param		= qla1280_biosparam,
> -	.can_queue		= 0xfffff,
> +	.can_queue		= 512,

Actually, if you read the driver, it turns out there's a name for this:
MAX_OUTSTANDING_COMMANDS.  That's the constant that bounds the internal
per-host issue queue and what should be used for can_queue.

James
