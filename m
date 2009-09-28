From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: linux-next: scsi tree boot filure
Date: Mon, 28 Sep 2009 12:08:33 -0700
Message-ID: <20090928190833.GD39415@plap4-2.local>
References: <20090927164314.9377c24c.sfr@canb.auug.org.au>
 <1254149694.4302.57.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:53587 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZI1TIa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2009 15:08:30 -0400
Content-Disposition: inline
In-Reply-To: <1254149694.4302.57.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 28 Sep 2009, James Bottomley wrote:

> linux-scsi added to cc
> 
> On Sun, 2009-09-27 at 16:43 +1000, Stephen Rothwell wrote:
> > Hi James,
> > 
> > next-20090926 does not boot on some of my PowerPC partitions:
> > 
> > calling  .ibmvscsi_module_init+0x0/0xb8 @ 1
> > ibmvscsi 30000028: SRP_VERSION: 16.a
> > scsi0 : IBM POWER Virtual SCSI Adapter 1.5.8
> > ibmvscsi 30000028: partner initialization complete
> > ibmvscsi 30000028: host srp version: 16.a, host partition 1-Didgo-VIOS (1), OS 3, max io 1048576
> > ibmvscsi 30000028: Client reserve enabled
> > ibmvscsi 30000028: sent SRP login
> > ibmvscsi 30000028: SRP_LOGIN succeeded
> > Unable to handle kernel paging request for data at address 0x00000058
> > Faulting instruction address: 0xc0000000003a6280
> > Oops: Kernel access of bad area, sig: 11 [#1]
> > SMP NR_CPUS=128 NUMA pSeries
> > Modules linked in:
> > NIP: c0000000003a6280 LR: c0000000003a63b4 CTR: 0000000000000000
> > REGS: c00000007c3f3020 TRAP: 0300   Not tainted  (2.6.31-autokern1)
> > MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24002042  XER: 00000001
> > DAR: 0000000000000058, DSISR: 0000000040000000
> > TASK = c00000007c3e8000[1] 'swapper' THREAD: c00000007c3f0000 CPU: 3
> > GPR00: 0000000000000000 c00000007c3f32a0 c000000000bc5390 c000000000a76420 
> > GPR04: c000000000b97818 c0000000015abc70 0000000000000000 c00000007c81c918 
> > GPR08: c00000007c81c888 0000000002000000 0000000000000002 c0000000014ecbcc 
> > GPR12: 0000000024000042 c000000000c1ea80 0000000003500000 c00000000074af10 
> > GPR16: c000000000749588 0000000000000000 0000000000000000 0000000000000000 
> > GPR20: c00000007c3f3600 c000000079074c00 c00000007c81c000 0000000002f1f8e0 
> > GPR24: 0000000000000000 0000000000000000 0000000000000000 c000000079074c28 
> > GPR28: c00000007c81c000 0000000000000000 c000000000b353f0 c000000000b97818 
> > NIP [c0000000003a6280] .__scsi_alloc_queue+0x2c/0x13c
> > LR [c0000000003a63b4] .scsi_alloc_queue+0x24/0x84
> > Call Trace:
> > [c00000007c3f32a0] [c00000007c3f3330] 0xc00000007c3f3330 (unreliable)
> > [c00000007c3f3330] [c0000000003a63b4] .scsi_alloc_queue+0x24/0x84
> > [c00000007c3f33b0] [c0000000003a8f78] .scsi_alloc_sdev+0x198/0x2ac
> > [c00000007c3f3470] [c0000000003a9450] .scsi_probe_and_add_lun+0x130/0xaac
> > [c00000007c3f3580] [c0000000003aa20c] .__scsi_scan_target+0xf4/0x5fc
> > [c00000007c3f36a0] [c0000000003aa768] .scsi_scan_channel+0x54/0xd0
> > [c00000007c3f3740] [c0000000003aa8b0] .scsi_scan_host_selected+0xcc/0x144
> > [c00000007c3f37f0] [c0000000003d5264] .ibmvscsi_probe+0x590/0x6e4
> > [c00000007c3f38c0] [c000000000021e88] .vio_bus_probe+0x84/0xb0
> > [c00000007c3f3960] [c00000000037cbac] .driver_probe_device+0xfc/0x1c0
> > [c00000007c3f39f0] [c00000000037cd04] .__driver_attach+0x94/0xd8
> > [c00000007c3f3a80] [c00000000037b9f8] .bus_for_each_dev+0x84/0xdc
> > [c00000007c3f3b30] [c00000000037c954] .driver_attach+0x28/0x40
> > [c00000007c3f3bb0] [c00000000037c290] .bus_add_driver+0x148/0x314
> > [c00000007c3f3c60] [c00000000037d1b0] .driver_register+0xd4/0x1a8
> > [c00000007c3f3d10] [c000000000021cbc] .vio_register_driver+0x40/0x5c
> > [c00000007c3f3da0] [c00000000084f418] .ibmvscsi_module_init+0x80/0xb8
> > [c00000007c3f3e30] [c0000000000094c8] .do_one_initcall+0x9c/0x1cc
> > [c00000007c3f3ee0] [c000000000822cc0] .kernel_init+0x21c/0x298
> > [c00000007c3f3f90] [c000000000026cb8] .kernel_thread+0x54/0x70
> > Instruction dump:
> > 4e800020 7c0802a6 fb81ffe0 fbe1fff8 fba1ffe8 7c7c1b78 f8010010 f821ff71 
> > 7c9f2378 eba302a0 48000008 ebbd0000 <e81d0058> 7fa3eb78 2fa00000 419efff0 
> > ---[ end trace 18604a042ee6e0ba ]---
> > Kernel panic - not syncing: Attempted to kill init!
> > Call Trace:
> > [c00000007c3f2c80] [c00000000001024c] .show_stack+0x70/0x184 (unreliable)
> > [c00000007c3f2d30] [c00000000006a410] .panic+0x80/0x1b4
> > [c00000007c3f2dd0] [c00000000006eca4] .do_exit+0x84/0x728
> > [c00000007c3f2e90] [c000000000024d2c] .die+0x24c/0x27c
> > [c00000007c3f2f30] [c0000000000330c8] .bad_page_fault+0xb8/0xd4
> > [c00000007c3f2fb0] [c0000000000051dc] handle_page_fault+0x3c/0x74
> > --- Exception: 300 at .__scsi_alloc_queue+0x2c/0x13c
> >     LR = .scsi_alloc_queue+0x24/0x84
> > [c00000007c3f32a0] [c00000007c3f3330] 0xc00000007c3f3330 (unreliable)
> > [c00000007c3f3330] [c0000000003a63b4] .scsi_alloc_queue+0x24/0x84
> > [c00000007c3f33b0] [c0000000003a8f78] .scsi_alloc_sdev+0x198/0x2ac
> > [c00000007c3f3470] [c0000000003a9450] .scsi_probe_and_add_lun+0x130/0xaac
> > [c00000007c3f3580] [c0000000003aa20c] .__scsi_scan_target+0xf4/0x5fc
> > [c00000007c3f36a0] [c0000000003aa768] .scsi_scan_channel+0x54/0xd0
> > [c00000007c3f3740] [c0000000003aa8b0] .scsi_scan_host_selected+0xcc/0x144
> > [c00000007c3f37f0] [c0000000003d5264] .ibmvscsi_probe+0x590/0x6e4
> > [c00000007c3f38c0] [c000000000021e88] .vio_bus_probe+0x84/0xb0
> > [c00000007c3f3960] [c00000000037cbac] .driver_probe_device+0xfc/0x1c0
> > [c00000007c3f39f0] [c00000000037cd04] .__driver_attach+0x94/0xd8
> > [c00000007c3f3a80] [c00000000037b9f8] .bus_for_each_dev+0x84/0xdc
> > [c00000007c3f3b30] [c00000000037c954] .driver_attach+0x28/0x40
> > [c00000007c3f3bb0] [c00000000037c290] .bus_add_driver+0x148/0x314
> > [c00000007c3f3c60] [c00000000037d1b0] .driver_register+0xd4/0x1a8
> > [c00000007c3f3d10] [c000000000021cbc] .vio_register_driver+0x40/0x5c
> > [c00000007c3f3da0] [c00000000084f418] .ibmvscsi_module_init+0x80/0xb8
> > [c00000007c3f3e30] [c0000000000094c8] .do_one_initcall+0x9c/0x1cc
> > [c00000007c3f3ee0] [c000000000822cc0] .kernel_init+0x21c/0x298
> > [c00000007c3f3f90] [c000000000026cb8] .kernel_thread+0x54/0x70
> > Rebooting in 180 seconds..
> > 
> > I have bisected this down to commit
> > 4acd10521ee002137b5d6791e234d7110033c782 ("[SCSI] scsi_lib_dma.c : fix
> > bug /w dma maps on virtual vc ports") which was added between
> > next-20090925 and next-20090926.
> > 
> > Reverting that single commit from next-20090926 allows it to boot.
> 
> OK, so my strongest suspicion is that the SCSI device is parented to
> some IBM specific device that has no type.  This is causing SCSI to
> wander up the tree until it hits a NULL device and panics on the deref.

Hmm, doesn't appear to be something specific to an 'IBM device', as
I'm seeing the same thing with qla2xxx registerting rports to the
FC-transport:

	Sep 28 11:40:21 elab52 kernel: [  174.440129] BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
	Sep 28 11:40:21 elab52 kernel: [  174.440280] IP: [<ffffffff81270dc3>] __scsi_alloc_queue+0x23/0x160
	Sep 28 11:40:21 elab52 kernel: [  174.440380] PGD 0 
	Sep 28 11:40:21 elab52 kernel: [  174.440481] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
	Sep 28 11:40:21 elab52 kernel: [  174.440643] last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
	Sep 28 11:40:21 elab52 kernel: [  174.440722] CPU 6 
	Sep 28 11:40:21 elab52 kernel: [  174.440809] Modules linked in: qla2xxx scsi_transport_fc [last unloaded: scsi_transport_fc]
	Sep 28 11:40:21 elab52 kernel: [  174.441031] Pid: 7079, comm: scsi_wq_0 Not tainted 2.6.32-rc2 #6 ProLiant DL370 G6
	Sep 28 11:40:21 elab52 kernel: [  174.441108] RIP: 0010:[<ffffffff81270dc3>]  [<ffffffff81270dc3>] __scsi_alloc_queue+0x23/0x160
	Sep 28 11:40:21 elab52 kernel: [  174.441225] RSP: 0018:ffff8801a4135b10  EFLAGS: 00010246
	Sep 28 11:40:21 elab52 kernel: [  174.441284] RAX: ffff880199b26e18 RBX: 0000000000000000 RCX: 0000000000000000
	Sep 28 11:40:21 elab52 kernel: [  174.442962] RDX: ffffffff815dd880 RSI: ffffffff81270840 RDI: ffff8801a66947f0
	Sep 28 11:40:21 elab52 kernel: [  174.443025] RBP: ffff8801a4135b30 R08: 0000000000000000 R09: ffff8801a54027f0
	Sep 28 11:40:21 elab52 kernel: [  174.443088] R10: ffff8801a78036c0 R11: ffff8801a7ab4ef0 R12: ffffffff81270840
	Sep 28 11:40:21 elab52 kernel: [  174.443151] R13: ffff8801a66947f0 R14: ffff8801a66947f0 R15: 0000000000000000
	Sep 28 11:40:21 elab52 kernel: [  174.443215] FS:  0000000000000000(0000) GS:ffff8800282c0000(0000) knlGS:0000000000000000
	Sep 28 11:40:21 elab52 kernel: [  174.443294] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
	Sep 28 11:40:21 elab52 kernel: [  174.443355] CR2: 0000000000000058 CR3: 0000000001001000 CR4: 00000000000006e0
	Sep 28 11:40:21 elab52 kernel: [  174.443418] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
	Sep 28 11:40:21 elab52 kernel: [  174.443481] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
	Sep 28 11:40:21 elab52 kernel: [  174.443544] Process scsi_wq_0 (pid: 7079, threadinfo ffff8801a4134000, task ffff8801a1e55968)
	Sep 28 11:40:21 elab52 kernel: [  174.443623] Stack:
	Sep 28 11:40:21 elab52 kernel: [  174.443676]  ffff8801a4135b50 ffff8801a54027f0 ffff880199b26df0 ffff880199b26e18
	Sep 28 11:40:21 elab52 kernel: [  174.443846] <0> ffff8801a4135b50 ffffffff81270f18 ffff8801a4135b50 ffff8801a54027f0
	Sep 28 11:40:21 elab52 kernel: [  174.444176] <0> ffff8801a4135b90 ffffffff812730df ffffffff00000010 0000000000000000
	Sep 28 11:40:21 elab52 kernel: [  174.444476] Call Trace:
	Sep 28 11:40:21 elab52 kernel: [  174.444533]  [<ffffffff81270f18>] scsi_alloc_queue+0x18/0x70
	Sep 28 11:40:21 elab52 kernel: [  174.444595]  [<ffffffff812730df>] scsi_alloc_sdev+0x17f/0x250
	Sep 28 11:40:21 elab52 kernel: [  174.444656]  [<ffffffff81273dda>] scsi_probe_and_add_lun+0xa0a/0xe60
	Sep 28 11:40:21 elab52 kernel: [  174.444720]  [<ffffffff811bd58a>] ? kobject_get+0x1a/0x30
	Sep 28 11:40:21 elab52 kernel: [  174.444798]  [<ffffffff8136e5b9>] ? mutex_unlock+0x9/0x10
	Sep 28 11:40:21 elab52 kernel: [  174.444860]  [<ffffffff812430b4>] ? attribute_container_add_device+0x74/0x1a0
	Sep 28 11:40:21 elab52 kernel: [  174.444925]  [<ffffffff811bd58a>] ? kobject_get+0x1a/0x30
	Sep 28 11:40:21 elab52 kernel: [  174.444986]  [<ffffffff8123c4d4>] ? get_device+0x14/0x20
	Sep 28 11:40:21 elab52 kernel: [  174.445047]  [<ffffffff81272f12>] ? scsi_alloc_target+0x2a2/0x2f0
	Sep 28 11:40:21 elab52 kernel: [  174.445110]  [<ffffffff812745a7>] __scsi_scan_target+0xe7/0x740
	Sep 28 11:40:21 elab52 kernel: [  174.445173]  [<ffffffff810cd201>] ? kfree_debugcheck+0x11/0x30
	Sep 28 11:40:21 elab52 kernel: [  174.445235]  [<ffffffff810cd457>] ? cache_free_debugcheck+0x237/0x380
	Sep 28 11:40:21 elab52 kernel: [  174.445298]  [<ffffffff812732e2>] ? scsi_complete_async_scans+0xc2/0x180
	Sep 28 11:40:21 elab52 kernel: [  174.445363]  [<ffffffff81040b80>] ? default_wake_function+0x0/0x10
	Sep 28 11:40:21 elab52 kernel: [  174.445426]  [<ffffffff81275333>] scsi_scan_target+0xc3/0xd0
	Sep 28 11:40:21 elab52 kernel: [  174.445490]  [<ffffffffa0010a60>] ? fc_scsi_scan_rport+0x0/0xc0 [scsi_transport_fc]
	Sep 28 11:40:21 elab52 kernel: [  174.445570]  [<ffffffffa0010b17>] fc_scsi_scan_rport+0xb7/0xc0 [scsi_transport_fc]
	Sep 28 11:40:21 elab52 kernel: [  174.445652]  [<ffffffff8105d1f6>] worker_thread+0x156/0x210
	Sep 28 11:40:21 elab52 kernel: [  174.445714]  [<ffffffff81061b60>] ? autoremove_wake_function+0x0/0x40
	Sep 28 11:40:21 elab52 kernel: [  174.445777]  [<ffffffff8105d0a0>] ? worker_thread+0x0/0x210
	Sep 28 11:40:21 elab52 kernel: [  174.445839]  [<ffffffff81061796>] kthread+0x96/0xb0
	Sep 28 11:40:21 elab52 kernel: [  174.445903]  [<ffffffff8100c31a>] child_rip+0xa/0x20
	Sep 28 11:40:21 elab52 kernel: [  174.445963]  [<ffffffff81061700>] ? kthread+0x0/0xb0
	Sep 28 11:40:21 elab52 kernel: [  174.446023]  [<ffffffff8100c310>] ? child_rip+0x0/0x20
	Sep 28 11:40:21 elab52 kernel: [  174.446082] Code: ff ff 66 0f 1f 44 00 00 55 48 89 e5 41 55 49 89 fd 41 54 49 89 f4 53 48 83 ec 08 48 8b 9f d8 01 00 00 eb 07 0f 1f 40 00 48 8b 1b <48> 83 7b 58 00 74 f6 48 89 df e8 4e 9c ff ff 85 c0 75 ea 31 f6 
	Sep 28 11:40:21 elab52 kernel: [  174.448539] RIP  [<ffffffff81270dc3>] __scsi_alloc_queue+0x23/0x160
	Sep 28 11:40:22 elab52 kernel: [  174.448637]  RSP <ffff8801a4135b10>
	Sep 28 11:40:22 elab52 kernel: [  174.448693] CR2: 0000000000000058
	Sep 28 11:40:22 elab52 kernel: [  174.448817] ---[ end trace d6870c1a1052d6c8 ]---

> Does this incremental diff fix it?
> 
> James
> 
> ---
> 
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 2977806..9d5bfdc 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -718,7 +718,7 @@ static inline struct Scsi_Host *dev_to_shost(struct device *dev)
>   */
>  static inline struct device *dev_to_nonscsi_dev(struct device *dev)
>  {
> -	while (dev->type == NULL || scsi_is_host_device(dev))
> +	while (dev->parent && (dev->type == NULL || scsi_is_host_device(dev)))
>  		dev = dev->parent;
>  	return dev;
>  }


Yes, your fix has kicked the tires enough to get the cart moving again.

Thanks, AV
