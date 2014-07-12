From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: mpt2sas stuck installing
Date: Fri, 11 Jul 2014 22:53:06 -0400
Message-ID: <20140711225306.3ce78324@jlaw-desktop.mno.stratus.com>
References: <20140704013250.088477de@jlaw-desktop.mno.stratus.com>
 <53B649A6.60501@julianfamily.org>
 <alpine.DEB.2.02.1407072149190.10980@jlaw-desktop.mno.stratus.com>
 <53BDBB3A.5060906@julianfamily.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o144.mxlogic.net ([208.65.145.67]:44950 "EHLO
	p01c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaGLCxP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jul 2014 22:53:15 -0400
In-Reply-To: <53BDBB3A.5060906@julianfamily.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Julian <joe@julianfamily.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>

[ +cc linux-scsi and Sreekanth ]

On Wed, 9 Jul 2014 14:59:22 -0700
Joe Julian <joe@julianfamily.org> wrote:
> On 07/07/2014 06:52 PM, Joe Lawrence wrote:
> > On Fri, 4 Jul 2014, Joe Julian wrote:
> >> On 07/03/2014 10:32 PM, Joe Lawrence wrote:
> >>> On Thu, Jul 3 2014 Joe Julian wrote:
> >>>> I have a knox enclosure with an unresponsive drive. When the mpt2sas
> >>>> module is loaded the module loading process hangs. modprobe/insmod is
> >>>> stuck and any further attempts to load modules also hang. By
> >>>> blacklisting the module and loading it last, I can get the computer to
> >>>> boot, but attempting to manually load the module will still hang. When I
> >>>> shut down, I get the following:
> >>>>
> >>>> [55473.508343] mpt2sas1: _config_request: timeout
> >>>> [55474.510395] BUG: unable to handle kernel paging request at ffffc90020ae0000
> >>>> [55474.513048] IP: [<ffffffffa03c00f0>] mpt2sas_base_get_iocstate+0x10/0x30 [mpt2sas]
> >>>> [55474.525196] PGD 103f80c067 PUD 203f003067 PMD 1026dca067 PTE 0
> >>>> [55474.526115] Oops: 0000 [#1] SMP
> >>>> [55474.527837] Modules linked in: raid456 async_pq async_xor xor
> >>>> async_memcpy async_raid6_recov raid6_pq async_tx ses enclosure mpt2sas
> >>>> raid_class rdma_ucm ib_ucm rdma_cm iw_cm ib_addr ib_ipoib ib_cm ib_uverbs
> >>>> ib_umad mlx4_en mlx4_ib(-) ib_sa ib_mad ib_core coretemp mlx4_core
> >>>> kvm_intel kvm 8021q garp stp ghash_clmulni_intel llc aesni_intel
> >>>> ablk_helper cryptd nfsd lrw aes_x86_64 xts psmouse gf128mul sb_edac
> >>>> nfs_acl auth_rpcgss edac_core mei microcode serio_raw mac_hid lp lpc_ich
> >>>> nfs fscache parport lockd sunrpc ext2 isci libsas ahci libahci e1000e
> >>>> scsi_transport_sas [last unloaded: mlx4_core]
> >>>> [55474.538831] CPU 2
> >>>> [55474.539218] Pid: 3516, comm: scsi_eh_10 Not tainted 3.8.0-38-generic
> >>>> #56~precise1-Ubuntu Quanta F03R /Winterfell
> >>>> [55474.541004] RIP: 0010:[<ffffffffa03c00f0>] [<ffffffffa03c00f0>]
> >>>> mpt2sas_base_get_iocstate+0x10/0x30 [mpt2sas]
> >>>> [55474.542772] RSP: 0018:ffff881019a39ae8  EFLAGS: 00010246
> >>>> [55474.543590] RAX: ffffc90020ae0000 RBX: ffff88100fd1e6b0 RCX:
> >>>> 0000000000000000
> >>>> [55474.546285] RDX: ffff881019a39fd8 RSI: 0000000000000001 RDI:
> >>>> ffff88100fd1e6b0
> >>>> [55474.548451] RBP: ffff881019a39ae8 R08: 0000000000000000 R09:
> >>>> 0000000000000000
> >>>> [55474.549585] R10: 00000000000007db R11: 00000000000007da R12:
> >>>> 0000000000000001
> >>>> [55474.550689] R13: ffff881019a39bbc R14: 000000000000ffff R15:
> >>>> ffff881019a39c80
> >>>> [55474.551791] FS:  0000000000000000(0000) GS:ffff88103fc40000(0000)
> >>>> knlGS:0000000000000000
> >>>> [55474.553044] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>>> [55474.553928] CR2: ffffc90020ae0000 CR3: 0000000001c0d000 CR4:
> >>>> 00000000000407e0
> >>>> [55474.555187] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> >>>> 0000000000000000
> >>>> [55474.557030] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> >>>> 0000000000000400
> >>>> [55474.558139] Process scsi_eh_10 (pid: 3516, threadinfo ffff881019a38000,
> >>>> task ffff8810257b5d00)
> >>>> [55474.560748] Stack:
> >>>> [55474.561069]  ffff881019a39b98 ffffffffa03c183a 0000000000000006
> >>>> 0000000000000006
> >>>> [55474.562218]  ffff88100fd1eb00 ffff88100fd1eaf8 ffff88100fd1e6d0
> >>>> 0000000000000000
> >>>> [55474.563343]  ffff881019a30000 ffffffff8105b3ea ffff88100fd1ead8
> >>>> 0000000000000000
> >>>> [55474.564595] Call Trace:
> >>>> [55474.565003]  [<ffffffffa03c183a>]
> >>>> _config_request.constprop.5+0x15a/0x590 [mpt2sas]
> >>>> [55474.568223]  [<ffffffff8105b3ea>] ? console_unlock+0x1a/0x30
> >>>> [55474.569896]  [<ffffffffa03c2a3a>]
> >>>> mpt2sas_config_get_expander_pg0+0x8a/0xf0 [mpt2sas]
> >>>> [55474.571322]  [<ffffffffa03c589c>]
> >>>> _scsih_search_responding_expanders+0x5c/0xe0 [mpt2sas]
> >>>> [55474.572582]  [<ffffffffa03c4599>] ?
> >>>> _scsih_search_responding_sas_devices+0xa9/0xc0 [mpt2sas]
> >>>> [55474.573912]  [<ffffffffa03cd43e>]
> >>>> mpt2sas_scsih_reset_handler+0xbe/0x1a0 [mpt2sas]
> >>>> [55474.575191]  [<ffffffffa03bf91f>] _base_reset_handler+0x1f/0x40
> >>>> [mpt2sas]
> >>>> [55474.576250]  [<ffffffffa03c0d9e>]
> >>>> mpt2sas_base_hard_reset_handler+0x1ae/0x1e0 [mpt2sas]
> >>>> [55474.577500]  [<ffffffffa03c499c>] _scsih_host_reset+0x5c/0xb0 [mpt2sas]
> >>>> [55474.578554]  [<ffffffff814ac2f3>] scsi_try_host_reset+0x53/0x110
> >>>> [55474.579729]  [<ffffffff814adbbc>] scsi_eh_host_reset+0x4c/0x170
> >>>> [55474.580764]  [<ffffffff814ae532>] scsi_eh_ready_devs+0x82/0xa0
> >>>> [55474.581866]  [<ffffffff814aef2d>] scsi_unjam_host+0xed/0x1d0
> >>>> [55474.584848]  [<ffffffff814af175>] scsi_error_handler+0x165/0x1c0
> >>>> [55474.585984]  [<ffffffff814af010>] ? scsi_unjam_host+0x1d0/0x1d0
> >>>> [55474.592375]  [<ffffffff8107f2e0>] kthread+0xc0/0xd0
> >>>> [55474.594325]  [<ffffffff8107f220>] ? flush_kthread_worker+0xb0/0xb0
> >>>> [55474.595654]  [<ffffffff816ff1ac>] ret_from_fork+0x7c/0xb0
> >>>> [55474.598729]  [<ffffffff8107f220>] ? flush_kthread_worker+0xb0/0xb0
> >>>> [55474.607501] Code: c7 c2 f8 7d 3d a0 48 c7 c7 52 ac 3d a0 31 c0 e8 f1 de
> >>>> 31 e1 e9 f6 fe ff ff 66 90 66 66 66 66 90 55 48 8b 87 88 00 00 00 48 89 e5
> >>>> <8b> 00 89 c2 81 e2 00 00 00 f0 85 f6 0f 45 c2 5d c3 66 66 66 66
> >>>> [55474.611823] RIP  [<ffffffffa03c00f0>]
> >>>> mpt2sas_base_get_iocstate+0x10/0x30 [mpt2sas]
> >>>> [55474.613007]  RSP <ffff881019a39ae8>
> >>>> [55474.613548] CR2: ffffc90020ae0000
> >>>> [55474.614183] ---[ end trace a817d8e30eb9f07c ]---
> >>> Hi Joe,
> >>>
> >>> I was investigating a crash inside mpt2sas_base_get_iocstate just
> >>> earlier today.  In my case, it appeared that ioc->chip had been cleared
> >>> when mpt2sas_base_get_iocstate tried to reference through it.  This was
> >>> with a newer kernel on RHEL7, but it also occured early in
> >>> mpt2sas_base_get_iocstate and EAX held the bogo address.
> >>>
> >>> A few follow up questions:
> >>>
> >>> Do you happen to have kdump enabled?
> >>> Were there any other interesting log messages after loading the driver?
> >>> Is this crash easily reproducible?
> >>>
> >>> Regards,
> >>>
> >>> -- Joe
> >> This was a production server, so no kdump enabled. There's no relevant log
> >> messages.
> >>
> >> I do have a staging environment I can test in, and yes, I think I can easily
> >> repro this.
> > Any chance of posting the rest of the kernel log?  (Or at least those
> > lines containing "mpt2sas" ?
> >
> > Thanks,
> >
> > -- Joe
> Here's everything from loading the module to the hung task notifications:
> 
> Jul  3 00:31:49 storage02 kernel: [   82.644759] mpt2sas version 14.100.00.00 loaded
> Jul  3 00:31:49 storage02 kernel: [   82.644940] scsi9 : Fusion MPT SAS Host
> Jul  3 00:31:49 storage02 kernel: [   82.645230] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (132013252 kB)
> Jul  3 00:31:49 storage02 kernel: [   82.645422] mpt2sas 0000:05:00.0: irq 122 for MSI/MSI-X
> Jul  3 00:31:49 storage02 kernel: [   82.645431] mpt2sas 0000:05:00.0: irq 123 for MSI/MSI-X
> Jul  3 00:31:49 storage02 kernel: [   82.645438] mpt2sas 0000:05:00.0: irq 124 for MSI/MSI-X
> Jul  3 00:31:49 storage02 kernel: [   82.645446] mpt2sas 0000:05:00.0: irq 125 for MSI/MSI-X
> Jul  3 00:31:49 storage02 kernel: [   82.645455] mpt2sas 0000:05:00.0: irq 126 for MSI/MSI-X
> Jul  3 00:31:49 storage02 kernel: [   82.645463] mpt2sas 0000:05:00.0: irq 127 for MSI/MSI-X
> Jul  3 00:31:49 storage02 kernel: [   82.645471] mpt2sas 0000:05:00.0: irq 128 for MSI/MSI-X
> Jul  3 00:31:49 storage02 kernel: [   82.645479] mpt2sas 0000:05:00.0: irq 129 for MSI/MSI-X
> Jul  3 00:31:49 storage02 kernel: [   82.645486] mpt2sas 0000:05:00.0: irq 130 for MSI/MSI-X
> Jul  3 00:31:49 storage02 kernel: [   82.645494] mpt2sas 0000:05:00.0: irq 131 for MSI/MSI-X
> Jul  3 00:31:49 storage02 kernel: [   82.645501] mpt2sas 0000:05:00.0: irq 132 for MSI/MSI-X
> Jul  3 00:31:49 storage02 kernel: [   82.645509] mpt2sas 0000:05:00.0: irq 133 for MSI/MSI-X
> Jul  3 00:31:49 storage02 kernel: [   82.645516] mpt2sas 0000:05:00.0: irq 134 for MSI/MSI-X
> Jul  3 00:31:49 storage02 kernel: [   82.645524] mpt2sas 0000:05:00.0: irq 135 for MSI/MSI-X
> Jul  3 00:31:49 storage02 kernel: [   82.645533] mpt2sas 0000:05:00.0: irq 136 for MSI/MSI-X
> Jul  3 00:31:49 storage02 kernel: [   82.645541] mpt2sas 0000:05:00.0: irq 137 for MSI/MSI-X
> Jul  3 00:31:49 storage02 kernel: [   82.645700] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 122
> Jul  3 00:31:49 storage02 kernel: [   82.645702] mpt2sas0-msix1: PCI-MSI-X enabled: IRQ 123
> Jul  3 00:31:49 storage02 kernel: [   82.645703] mpt2sas0-msix2: PCI-MSI-X enabled: IRQ 124
> Jul  3 00:31:49 storage02 kernel: [   82.645704] mpt2sas0-msix3: PCI-MSI-X enabled: IRQ 125
> Jul  3 00:31:49 storage02 kernel: [   82.645706] mpt2sas0-msix4: PCI-MSI-X enabled: IRQ 126
> Jul  3 00:31:49 storage02 kernel: [   82.645707] mpt2sas0-msix5: PCI-MSI-X enabled: IRQ 127
> Jul  3 00:31:49 storage02 kernel: [   82.645708] mpt2sas0-msix6: PCI-MSI-X enabled: IRQ 128
> Jul  3 00:31:49 storage02 kernel: [   82.645710] mpt2sas0-msix7: PCI-MSI-X enabled: IRQ 129
> Jul  3 00:31:49 storage02 kernel: [   82.645711] mpt2sas0-msix8: PCI-MSI-X enabled: IRQ 130
> Jul  3 00:31:49 storage02 kernel: [   82.645712] mpt2sas0-msix9: PCI-MSI-X enabled: IRQ 131
> Jul  3 00:31:49 storage02 kernel: [   82.645714] mpt2sas0-msix10: PCI-MSI-X enabled: IRQ 132
> Jul  3 00:31:49 storage02 kernel: [   82.645715] mpt2sas0-msix11: PCI-MSI-X enabled: IRQ 133
> Jul  3 00:31:49 storage02 kernel: [   82.645717] mpt2sas0-msix12: PCI-MSI-X enabled: IRQ 134
> Jul  3 00:31:49 storage02 kernel: [   82.645718] mpt2sas0-msix13: PCI-MSI-X enabled: IRQ 135
> Jul  3 00:31:49 storage02 kernel: [   82.645719] mpt2sas0-msix14: PCI-MSI-X enabled: IRQ 136
> Jul  3 00:31:49 storage02 kernel: [   82.645721] mpt2sas0-msix15: PCI-MSI-X enabled: IRQ 137
> Jul  3 00:31:49 storage02 kernel: [   82.645723] mpt2sas0: iomem(0x00000000df940000), mapped(0xffffc90020ac0000), size(65536)
> Jul  3 00:31:49 storage02 kernel: [   82.645725] mpt2sas0: ioport(0x0000000000006000), size(256)
> Jul  3 00:31:49 storage02 kernel: [   82.931466] mpt2sas0: sending message unit reset !!
> Jul  3 00:31:49 storage02 kernel: [   82.939418] mpt2sas0: message unit reset: SUCCESS
> Jul  3 00:31:50 storage02 kernel: [   83.132725] mpt2sas0: Allocated physical memory: size(17336 kB)
> Jul  3 00:31:50 storage02 kernel: [   83.132729] mpt2sas0: Current Controller Queue Depth(9979), Max Controller Queue Depth(10240)
> Jul  3 00:31:50 storage02 kernel: [   83.132730] mpt2sas0: Scatter Gather Elements per IO(128)
> Jul  3 00:31:50 storage02 kernel: [   83.355152] mpt2sas0: LSISAS2308: FWVersion(19.00.00.00), ChipRevision(0x05), BiosVersion(07.37.00.00)
> Jul  3 00:31:50 storage02 kernel: [   83.355155] mpt2sas0: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
> Jul  3 00:31:50 storage02 kernel: [   83.355313] mpt2sas0: sending port enable !!
> Jul  3 00:31:50 storage02 kernel: [   83.355342] scsi10 : Fusion MPT SAS Host
> Jul  3 00:31:50 storage02 kernel: [   83.355666] mpt2sas1: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (132013252 kB)
> Jul  3 00:31:50 storage02 kernel: [   83.355965] mpt2sas 0000:07:00.0: irq 138 for MSI/MSI-X
> Jul  3 00:31:50 storage02 kernel: [   83.355973] mpt2sas 0000:07:00.0: irq 139 for MSI/MSI-X
> Jul  3 00:31:50 storage02 kernel: [   83.355981] mpt2sas 0000:07:00.0: irq 140 for MSI/MSI-X
> Jul  3 00:31:50 storage02 kernel: [   83.355989] mpt2sas 0000:07:00.0: irq 141 for MSI/MSI-X
> Jul  3 00:31:50 storage02 kernel: [   83.355996] mpt2sas 0000:07:00.0: irq 142 for MSI/MSI-X
> Jul  3 00:31:50 storage02 kernel: [   83.356007] mpt2sas 0000:07:00.0: irq 143 for MSI/MSI-X
> Jul  3 00:31:50 storage02 kernel: [   83.356015] mpt2sas 0000:07:00.0: irq 144 for MSI/MSI-X
> Jul  3 00:31:50 storage02 kernel: [   83.356022] mpt2sas 0000:07:00.0: irq 145 for MSI/MSI-X
> Jul  3 00:31:50 storage02 kernel: [   83.356030] mpt2sas 0000:07:00.0: irq 146 for MSI/MSI-X
> Jul  3 00:31:50 storage02 kernel: [   83.356039] mpt2sas 0000:07:00.0: irq 147 for MSI/MSI-X
> Jul  3 00:31:50 storage02 kernel: [   83.356047] mpt2sas 0000:07:00.0: irq 148 for MSI/MSI-X
> Jul  3 00:31:50 storage02 kernel: [   83.356057] mpt2sas 0000:07:00.0: irq 149 for MSI/MSI-X
> Jul  3 00:31:50 storage02 kernel: [   83.356064] mpt2sas 0000:07:00.0: irq 150 for MSI/MSI-X
> Jul  3 00:31:50 storage02 kernel: [   83.356072] mpt2sas 0000:07:00.0: irq 151 for MSI/MSI-X
> Jul  3 00:31:50 storage02 kernel: [   83.356079] mpt2sas 0000:07:00.0: irq 152 for MSI/MSI-X
> Jul  3 00:31:50 storage02 kernel: [   83.356087] mpt2sas 0000:07:00.0: irq 153 for MSI/MSI-X
> Jul  3 00:31:50 storage02 kernel: [   83.356265] mpt2sas1-msix0: PCI-MSI-X enabled: IRQ 138
> Jul  3 00:31:50 storage02 kernel: [   83.356266] mpt2sas1-msix1: PCI-MSI-X enabled: IRQ 139
> Jul  3 00:31:50 storage02 kernel: [   83.356268] mpt2sas1-msix2: PCI-MSI-X enabled: IRQ 140
> Jul  3 00:31:50 storage02 kernel: [   83.356269] mpt2sas1-msix3: PCI-MSI-X enabled: IRQ 141
> Jul  3 00:31:50 storage02 kernel: [   83.356270] mpt2sas1-msix4: PCI-MSI-X enabled: IRQ 142
> Jul  3 00:31:50 storage02 kernel: [   83.356272] mpt2sas1-msix5: PCI-MSI-X enabled: IRQ 143
> Jul  3 00:31:50 storage02 kernel: [   83.356273] mpt2sas1-msix6: PCI-MSI-X enabled: IRQ 144
> Jul  3 00:31:50 storage02 kernel: [   83.356274] mpt2sas1-msix7: PCI-MSI-X enabled: IRQ 145
> Jul  3 00:31:50 storage02 kernel: [   83.356276] mpt2sas1-msix8: PCI-MSI-X enabled: IRQ 146
> Jul  3 00:31:50 storage02 kernel: [   83.356277] mpt2sas1-msix9: PCI-MSI-X enabled: IRQ 147
> Jul  3 00:31:50 storage02 kernel: [   83.356281] mpt2sas1-msix10: PCI-MSI-X enabled: IRQ 148
> Jul  3 00:31:50 storage02 kernel: [   83.356283] mpt2sas1-msix11: PCI-MSI-X enabled: IRQ 149
> Jul  3 00:31:50 storage02 kernel: [   83.356284] mpt2sas1-msix12: PCI-MSI-X enabled: IRQ 150
> Jul  3 00:31:50 storage02 kernel: [   83.356285] mpt2sas1-msix13: PCI-MSI-X enabled: IRQ 151
> Jul  3 00:31:50 storage02 kernel: [   83.356287] mpt2sas1-msix14: PCI-MSI-X enabled: IRQ 152
> Jul  3 00:31:50 storage02 kernel: [   83.356288] mpt2sas1-msix15: PCI-MSI-X enabled: IRQ 153
> Jul  3 00:31:50 storage02 kernel: [   83.356290] mpt2sas1: iomem(0x00000000df740000), mapped(0xffffc90020ae0000), size(65536)
> Jul  3 00:31:50 storage02 kernel: [   83.356292] mpt2sas1: ioport(0x0000000000005000), size(256)
> Jul  3 00:31:50 storage02 kernel: [   83.358061] mpt2sas0: host_add: handle(0x0001), sas_addr(0x500605b00752bab0), phys(8)
> Jul  3 00:31:50 storage02 kernel: [   83.360597] mpt2sas0: expander_add: handle(0x0009), parent(0x0001), sas_addr(0x5000ae41fd5b20ff), phys(30)
> Jul  3 00:31:50 storage02 kernel: [   83.368012] scsi 9:0:0:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.368019] scsi 9:0:0:0: SSP: handle(0x000a), sas_addr(0x50000c0f01c60987), phy(0), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.368022] scsi 9:0:0:0: SSP: enclosure_logical_id(0x5000ae41fd5b20ff), slot(0)
> Jul  3 00:31:50 storage02 kernel: [   83.368025] scsi 9:0:0:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.370869] scsi 9:0:1:0: Direct-Access     WD       WD4001FYYG-01SL3 VR07 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.370876] scsi 9:0:1:0: SSP: handle(0x000b), sas_addr(0x50000c0f01c9a733), phy(1), device_name(0x50000c0f01c9a731)
> Jul  3 00:31:50 storage02 kernel: [   83.370879] scsi 9:0:1:0: SSP: enclosure_logical_id(0x5000ae41fd5b20ff), slot(1)
> Jul  3 00:31:50 storage02 kernel: [   83.370882] scsi 9:0:1:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.373647] scsi 9:0:2:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.373651] scsi 9:0:2:0: SSP: handle(0x000c), sas_addr(0x50000c0f01c686cb), phy(2), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.373654] scsi 9:0:2:0: SSP: enclosure_logical_id(0x5000ae41fd5b20ff), slot(2)
> Jul  3 00:31:50 storage02 kernel: [   83.373657] scsi 9:0:2:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.376652] scsi 9:0:3:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.376658] scsi 9:0:3:0: SSP: handle(0x000d), sas_addr(0x50000c0f011dc303), phy(3), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.376661] scsi 9:0:3:0: SSP: enclosure_logical_id(0x5000ae41fd5b20ff), slot(3)
> Jul  3 00:31:50 storage02 kernel: [   83.376664] scsi 9:0:3:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.379396] scsi 9:0:4:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.379401] scsi 9:0:4:0: SSP: handle(0x000e), sas_addr(0x50000c0f01c68d93), phy(4), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.379403] scsi 9:0:4:0: SSP: enclosure_logical_id(0x5000ae41fd5b20ff), slot(4)
> Jul  3 00:31:50 storage02 kernel: [   83.379406] scsi 9:0:4:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.382183] scsi 9:0:5:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.382187] scsi 9:0:5:0: SSP: handle(0x000f), sas_addr(0x50000c0f01c68c07), phy(5), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.382190] scsi 9:0:5:0: SSP: enclosure_logical_id(0x5000ae41fd5b20ff), slot(5)
> Jul  3 00:31:50 storage02 kernel: [   83.382192] scsi 9:0:5:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.385043] scsi 9:0:6:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.385051] scsi 9:0:6:0: SSP: handle(0x0010), sas_addr(0x50000c0f021895bb), phy(6), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.385066] scsi 9:0:6:0: SSP: enclosure_logical_id(0x5000ae41fd5b20ff), slot(6)
> Jul  3 00:31:50 storage02 kernel: [   83.385068] scsi 9:0:6:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.387864] scsi 9:0:7:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.387869] scsi 9:0:7:0: SSP: handle(0x0011), sas_addr(0x50000c0f01c675cb), phy(7), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.387871] scsi 9:0:7:0: SSP: enclosure_logical_id(0x5000ae41fd5b20ff), slot(7)
> Jul  3 00:31:50 storage02 kernel: [   83.387874] scsi 9:0:7:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.390651] scsi 9:0:8:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.390656] scsi 9:0:8:0: SSP: handle(0x0012), sas_addr(0x50000c0f01c6c1ef), phy(8), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.390658] scsi 9:0:8:0: SSP: enclosure_logical_id(0x5000ae41fd5b20ff), slot(8)
> Jul  3 00:31:50 storage02 kernel: [   83.390661] scsi 9:0:8:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.393510] scsi 9:0:9:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.393514] scsi 9:0:9:0: SSP: handle(0x0013), sas_addr(0x50000c0f011dbaa7), phy(9), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.393516] scsi 9:0:9:0: SSP: enclosure_logical_id(0x5000ae41fd5b20ff), slot(9)
> Jul  3 00:31:50 storage02 kernel: [   83.393519] scsi 9:0:9:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.396358] scsi 9:0:10:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.396363] scsi 9:0:10:0: SSP: handle(0x0014), sas_addr(0x50000c0f02751ce7), phy(10), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.396365] scsi 9:0:10:0: SSP: enclosure_logical_id(0x5000ae41fd5b20ff), slot(10)
> Jul  3 00:31:50 storage02 kernel: [   83.396367] scsi 9:0:10:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.399217] scsi 9:0:11:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.399222] scsi 9:0:11:0: SSP: handle(0x0015), sas_addr(0x50000c0f01c675eb), phy(11), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.399224] scsi 9:0:11:0: SSP: enclosure_logical_id(0x5000ae41fd5b20ff), slot(11)
> Jul  3 00:31:50 storage02 kernel: [   83.399227] scsi 9:0:11:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.402069] scsi 9:0:12:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.402073] scsi 9:0:12:0: SSP: handle(0x0016), sas_addr(0x50000c0f01c55ca7), phy(12), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.402075] scsi 9:0:12:0: SSP: enclosure_logical_id(0x5000ae41fd5b20ff), slot(12)
> Jul  3 00:31:50 storage02 kernel: [   83.402078] scsi 9:0:12:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.404934] scsi 9:0:13:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.404942] scsi 9:0:13:0: SSP: handle(0x0017), sas_addr(0x50000c0f01c66ef3), phy(13), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.404945] scsi 9:0:13:0: SSP: enclosure_logical_id(0x5000ae41fd5b20ff), slot(13)
> Jul  3 00:31:50 storage02 kernel: [   83.404950] scsi 9:0:13:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.407769] scsi 9:0:14:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.407773] scsi 9:0:14:0: SSP: handle(0x0018), sas_addr(0x50000c0f01bad1eb), phy(14), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.407775] scsi 9:0:14:0: SSP: enclosure_logical_id(0x5000ae41fd5b20ff), slot(14)
> Jul  3 00:31:50 storage02 kernel: [   83.407778] scsi 9:0:14:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.411863] scsi 9:0:15:0: Enclosure         Wiwynn   Knox2U           0e3  PQ: 0 ANSI: 5
> Jul  3 00:31:50 storage02 kernel: [   83.411872] scsi 9:0:15:0: SSP: handle(0x0019), sas_addr(0x5000ae41fd5b20fd), phy(28), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.411874] scsi 9:0:15:0: SSP: enclosure_logical_id(0x5000ae41fd5b20ff), slot(16)
> Jul  3 00:31:50 storage02 kernel: [   83.411877] scsi 9:0:15:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.415137] mpt2sas0: expander_add: handle(0x001a), parent(0x0002), sas_addr(0x5000ae41fd73f0ff), phys(30)
> Jul  3 00:31:50 storage02 kernel: [   83.423962] scsi 9:0:16:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.423968] scsi 9:0:16:0: SSP: handle(0x001b), sas_addr(0x50000c0f01c5818f), phy(0), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.423971] scsi 9:0:16:0: SSP: enclosure_logical_id(0x5000ae41fd73f0ff), slot(0)
> Jul  3 00:31:50 storage02 kernel: [   83.423974] scsi 9:0:16:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.431895] scsi 9:0:17:0: Direct-Access     WD       WD4001FYYG-01SL3 VR07 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.431901] scsi 9:0:17:0: SSP: handle(0x001c), sas_addr(0x50000c0f012e8657), phy(1), device_name(0x50000c0f012e8655)
> Jul  3 00:31:50 storage02 kernel: [   83.431904] scsi 9:0:17:0: SSP: enclosure_logical_id(0x5000ae41fd73f0ff), slot(1)
> Jul  3 00:31:50 storage02 kernel: [   83.431907] scsi 9:0:17:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.434720] scsi 9:0:18:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.434725] scsi 9:0:18:0: SSP: handle(0x001d), sas_addr(0x50000c0f01b30fe3), phy(2), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.434727] scsi 9:0:18:0: SSP: enclosure_logical_id(0x5000ae41fd73f0ff), slot(2)
> Jul  3 00:31:50 storage02 kernel: [   83.434730] scsi 9:0:18:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.440893] scsi 9:0:19:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.440916] scsi 9:0:19:0: SSP: handle(0x001e), sas_addr(0x50000c0f01c678f3), phy(3), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.440918] scsi 9:0:19:0: SSP: enclosure_logical_id(0x5000ae41fd73f0ff), slot(3)
> Jul  3 00:31:50 storage02 kernel: [   83.440921] scsi 9:0:19:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.447029] scsi 9:0:20:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.447037] scsi 9:0:20:0: SSP: handle(0x001f), sas_addr(0x50000c0f0116656b), phy(4), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.447052] scsi 9:0:20:0: SSP: enclosure_logical_id(0x5000ae41fd73f0ff), slot(4)
> Jul  3 00:31:50 storage02 kernel: [   83.447055] scsi 9:0:20:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.452958] scsi 9:0:21:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.452964] scsi 9:0:21:0: SSP: handle(0x0020), sas_addr(0x50000c0f01b75ecb), phy(5), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.452966] scsi 9:0:21:0: SSP: enclosure_logical_id(0x5000ae41fd73f0ff), slot(5)
> Jul  3 00:31:50 storage02 kernel: [   83.452969] scsi 9:0:21:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.460249] scsi 9:0:22:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.460255] scsi 9:0:22:0: SSP: handle(0x0021), sas_addr(0x50000c0f0114a1e7), phy(6), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.460258] scsi 9:0:22:0: SSP: enclosure_logical_id(0x5000ae41fd73f0ff), slot(6)
> Jul  3 00:31:50 storage02 kernel: [   83.460261] scsi 9:0:22:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.466028] scsi 9:0:23:0: Direct-Access     WD       WD4001FYYG-01SL3 VR07 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.466034] scsi 9:0:23:0: SSP: handle(0x0022), sas_addr(0x50000c0f01d2ce7b), phy(7), device_name(0x50000c0f01d2ce79)
> Jul  3 00:31:50 storage02 kernel: [   83.466036] scsi 9:0:23:0: SSP: enclosure_logical_id(0x5000ae41fd73f0ff), slot(7)
> Jul  3 00:31:50 storage02 kernel: [   83.466039] scsi 9:0:23:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.469667] scsi 9:0:24:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.469687] scsi 9:0:24:0: SSP: handle(0x0023), sas_addr(0x50000c0f01154353), phy(8), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.469689] scsi 9:0:24:0: SSP: enclosure_logical_id(0x5000ae41fd73f0ff), slot(8)
> Jul  3 00:31:50 storage02 kernel: [   83.469692] scsi 9:0:24:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.475750] scsi 9:0:25:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.475771] scsi 9:0:25:0: SSP: handle(0x0024), sas_addr(0x50014ee5aaaaeffb), phy(9), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.475774] scsi 9:0:25:0: SSP: enclosure_logical_id(0x5000ae41fd73f0ff), slot(9)
> Jul  3 00:31:50 storage02 kernel: [   83.475777] scsi 9:0:25:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.482455] scsi 9:0:26:0: Direct-Access     WD       WD4001FYYG-01SL3 VR07 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.482462] scsi 9:0:26:0: SSP: handle(0x0025), sas_addr(0x50000c0f0123c37b), phy(10), device_name(0x50000c0f0123c379)
> Jul  3 00:31:50 storage02 kernel: [   83.482465] scsi 9:0:26:0: SSP: enclosure_logical_id(0x5000ae41fd73f0ff), slot(10)
> Jul  3 00:31:50 storage02 kernel: [   83.482468] scsi 9:0:26:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.485638] scsi 9:0:27:0: Direct-Access     WD       WD4001FYYG-01SL3 VR07 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.485644] scsi 9:0:27:0: SSP: handle(0x0026), sas_addr(0x50000c0f0128ef0f), phy(11), device_name(0x50000c0f0128ef0d)
> Jul  3 00:31:50 storage02 kernel: [   83.485647] scsi 9:0:27:0: SSP: enclosure_logical_id(0x5000ae41fd73f0ff), slot(11)
> Jul  3 00:31:50 storage02 kernel: [   83.485650] scsi 9:0:27:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.489575] scsi 9:0:28:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.489596] scsi 9:0:28:0: SSP: handle(0x0027), sas_addr(0x50000c0f0116691f), phy(12), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.489598] scsi 9:0:28:0: SSP: enclosure_logical_id(0x5000ae41fd73f0ff), slot(12)
> Jul  3 00:31:50 storage02 kernel: [   83.489601] scsi 9:0:28:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.497481] scsi 9:0:29:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.497488] scsi 9:0:29:0: SSP: handle(0x0028), sas_addr(0x50000c0f0113e61f), phy(13), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.497490] scsi 9:0:29:0: SSP: enclosure_logical_id(0x5000ae41fd73f0ff), slot(13)
> Jul  3 00:31:50 storage02 kernel: [   83.497493] scsi 9:0:29:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.500555] scsi 9:0:30:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:50 storage02 kernel: [   83.500574] scsi 9:0:30:0: SSP: handle(0x0029), sas_addr(0x50000c0f0117b6d7), phy(14), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.500577] scsi 9:0:30:0: SSP: enclosure_logical_id(0x5000ae41fd73f0ff), slot(14)
> Jul  3 00:31:50 storage02 kernel: [   83.500579] scsi 9:0:30:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.507548] scsi 9:0:31:0: Enclosure         Wiwynn   Knox2U           0e3  PQ: 0 ANSI: 5
> Jul  3 00:31:50 storage02 kernel: [   83.507553] scsi 9:0:31:0: SSP: handle(0x002a), sas_addr(0x5000ae41fd73f0fd), phy(28), device_name(0x0000000000000000)
> Jul  3 00:31:50 storage02 kernel: [   83.507555] scsi 9:0:31:0: SSP: enclosure_logical_id(0x5000ae41fd73f0ff), slot(16)
> Jul  3 00:31:50 storage02 kernel: [   83.507558] scsi 9:0:31:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
> Jul  3 00:31:50 storage02 kernel: [   83.514336] mpt2sas0: port enable: SUCCESS
> Jul  3 00:31:50 storage02 kernel: [   83.514641] sd 9:0:0:0: Attached scsi generic sg1 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.514874] sd 9:0:0:0: [sdb] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.515014] sd 9:0:1:0: Attached scsi generic sg2 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.515200] sd 9:0:1:0: [sdc] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.515395] sd 9:0:2:0: Attached scsi generic sg3 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.515665] sd 9:0:2:0: [sdd] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.515931] sd 9:0:3:0: Attached scsi generic sg4 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.516022] sd 9:0:3:0: [sde] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.516376] sd 9:0:4:0: Attached scsi generic sg5 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.516485] sd 9:0:4:0: [sdf] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.516817] sd 9:0:5:0: Attached scsi generic sg6 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.517029] sd 9:0:5:0: [sdg] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.517032] sd 9:0:6:0: Attached scsi generic sg7 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.517230] sd 9:0:6:0: [sdh] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.517461] sd 9:0:0:0: [sdb] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.517466] sd 9:0:0:0: [sdb] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.517532] sd 9:0:7:0: Attached scsi generic sg8 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.517711] sd 9:0:7:0: [sdi] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.517737] sd 9:0:1:0: [sdc] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.517742] sd 9:0:1:0: [sdc] Mode Sense: df 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.518208] sd 9:0:8:0: [sdj] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.518228] sd 9:0:2:0: [sdd] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.518233] sd 9:0:2:0: [sdd] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.518547] sd 9:0:3:0: [sde] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.518550] sd 9:0:3:0: [sde] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.518742] sd 9:0:8:0: Attached scsi generic sg9 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.519016] sd 9:0:4:0: [sdf] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.519020] sd 9:0:4:0: [sdf] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.519552] sd 9:0:5:0: [sdg] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.519555] sd 9:0:5:0: [sdg] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.519826] sd 9:0:6:0: [sdh] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.519828] sd 9:0:6:0: [sdh] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.520240] sd 9:0:7:0: [sdi] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.520243] sd 9:0:7:0: [sdi] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.520749] sd 9:0:8:0: [sdj] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.520754] sd 9:0:8:0: [sdj] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.520862] sd 9:0:0:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.521038] sd 9:0:9:0: Attached scsi generic sg10 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.521095] sd 9:0:1:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.521125] sd 9:0:9:0: [sdk] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.521683] sd 9:0:2:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.521991] sd 9:0:3:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.522473] sd 9:0:4:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.523012] sd 9:0:5:0: [sdg] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.523268] sd 9:0:6:0: [sdh] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.523667] sd 9:0:10:0: Attached scsi generic sg11 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.523685] sd 9:0:9:0: [sdk] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.523688] sd 9:0:7:0: [sdi] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.523692] sd 9:0:9:0: [sdk] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.523783] sd 9:0:10:0: [sdl] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.524200] sd 9:0:8:0: [sdj] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.524853] sd 9:0:11:0: Attached scsi generic sg12 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.524982] sd 9:0:11:0: [sdm] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.526097] sd 9:0:12:0: Attached scsi generic sg13 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.526232] sd 9:0:12:0: [sdn] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.526341] sd 9:0:10:0: [sdl] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.526346] sd 9:0:10:0: [sdl] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.527127] sd 9:0:9:0: [sdk] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.527524] sd 9:0:11:0: [sdm] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.527529] sd 9:0:11:0: [sdm] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.527852] sd 9:0:13:0: [sdo] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.528116] sd 9:0:13:0: Attached scsi generic sg14 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.528729] sd 9:0:14:0: Attached scsi generic sg15 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.528750] sd 9:0:14:0: [sdp] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.528773] sd 9:0:12:0: [sdn] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.528777] sd 9:0:12:0: [sdn] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.529606] scsi 9:0:15:0: Attached scsi generic sg16 type 13
> Jul  3 00:31:50 storage02 kernel: [   83.529780] sd 9:0:10:0: [sdl] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.530296] sd 9:0:16:0: Attached scsi generic sg17 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.530400] sd 9:0:16:0: [sdq] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.530415] sd 9:0:13:0: [sdo] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.530417] sd 9:0:13:0: [sdo] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.530568] sd 9:0:17:0: Attached scsi generic sg18 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.530764] sd 9:0:17:0: [sdr] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.530979] sd 9:0:11:0: [sdm] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.531266] sd 9:0:14:0: [sdp] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.531269] sd 9:0:14:0: [sdp] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.531894] sd 9:0:18:0: Attached scsi generic sg19 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.532020] sd 9:0:18:0: [sds] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.532219] sd 9:0:12:0: [sdn] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.532268] sd 9:0:19:0: Attached scsi generic sg20 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.532445] sd 9:0:19:0: [sdt] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.532926] sd 9:0:16:0: [sdq] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.532931] sd 9:0:20:0: [sdu] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.532934] sd 9:0:16:0: [sdq] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.533048] sd 9:0:20:0: Attached scsi generic sg21 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.533236] sd 9:0:17:0: [sdr] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.533239] sd 9:0:17:0: [sdr] Mode Sense: df 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.533734] sd 9:0:21:0: Attached scsi generic sg22 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.533884] sd 9:0:21:0: [sdv] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.533887] sd 9:0:13:0: [sdo] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.534501] sd 9:0:22:0: [sdw] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.534560] sd 9:0:18:0: [sds] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.534562] sd 9:0:18:0: [sds] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.534721] sd 9:0:14:0: [sdp] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.534847] sd 9:0:22:0: Attached scsi generic sg23 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.534973] sd 9:0:19:0: [sdt] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.534976] sd 9:0:19:0: [sdt] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.535441] sd 9:0:20:0: [sdu] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.535446] sd 9:0:20:0: [sdu] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.535914] sd 9:0:23:0: Attached scsi generic sg24 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.536147] sd 9:0:23:0: [sdx] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.536374] sd 9:0:16:0: [sdq] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.536422] sd 9:0:21:0: [sdv] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.536426] sd 9:0:21:0: [sdv] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.536620] sd 9:0:17:0: [sdr] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.536640] sd 9:0:24:0: Attached scsi generic sg25 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.536668] sd 9:0:24:0: [sdy] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.537064] sd 9:0:22:0: [sdw] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.537067] sd 9:0:22:0: [sdw] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.537559] sd 9:0:25:0: [sdz] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.537745] sd 9:0:25:0: Attached scsi generic sg26 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.538127] sd 9:0:18:0: [sds] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.538422] sd 9:0:19:0: [sdt] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.538538] sd 9:0:26:0: Attached scsi generic sg27 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.538640] sd 9:0:23:0: [sdx] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.538644] sd 9:0:23:0: [sdx] Mode Sense: df 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.538722] sd 9:0:26:0: [sdaa] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.538887] sd 9:0:20:0: [sdu] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.539028] sd 9:0:27:0: Attached scsi generic sg28 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.539187] sd 9:0:24:0: [sdy] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.539191] sd 9:0:24:0: [sdy] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.539195] sd 9:0:27:0: [sdab] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.539884] sd 9:0:21:0: [sdv] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.539957] sd 9:0:28:0: Attached scsi generic sg29 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.540114] sd 9:0:28:0: [sdac] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.540116] sd 9:0:25:0: [sdz] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.540120] sd 9:0:25:0: [sdz] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.540506] sd 9:0:22:0: [sdw] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.541009] sd 9:0:29:0: [sdad] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.541178] sd 9:0:29:0: Attached scsi generic sg30 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.541229] sd 9:0:26:0: [sdaa] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.541232] sd 9:0:26:0: [sdaa] Mode Sense: df 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.541675] sd 9:0:27:0: [sdab] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.541678] sd 9:0:27:0: [sdab] Mode Sense: df 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.542009] sd 9:0:23:0: [sdx] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.542652] sd 9:0:24:0: [sdy] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.542661] sd 9:0:28:0: [sdac] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.542664] sd 9:0:28:0: [sdac] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.543279] sd 9:0:30:0: Attached scsi generic sg31 type 0
> Jul  3 00:31:50 storage02 kernel: [   83.543392] sd 9:0:30:0: [sdae] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> Jul  3 00:31:50 storage02 kernel: [   83.543564] sd 9:0:29:0: [sdad] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.543568] sd 9:0:29:0: [sdad] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.543596] sd 9:0:25:0: [sdz] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.543649] scsi 9:0:31:0: Attached scsi generic sg32 type 13
> Jul  3 00:31:50 storage02 kernel: [   83.544586] sd 9:0:26:0: [sdaa] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.545047] sd 9:0:27:0: [sdab] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.545411]  sde: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.545921] sd 9:0:30:0: [sdae] Write Protect is off
> Jul  3 00:31:50 storage02 kernel: [   83.545924] sd 9:0:30:0: [sdae] Mode Sense: cf 00 10 08
> Jul  3 00:31:50 storage02 kernel: [   83.546093] sd 9:0:28:0: [sdac] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.547033] sd 9:0:29:0: [sdad] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.547619]  sdd: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.548110]  sdc: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.549377] sd 9:0:30:0: [sdae] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Jul  3 00:31:50 storage02 kernel: [   83.551216]  sdi: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.553189]  sdb: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.554001]  sdg: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.557150]  sdm: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.557183] sd 9:0:3:0: [sde] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.558974]  sdh: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.559473]  sdk: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.559684]  sdf: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.560318]  sdj: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.560690] sd 9:0:2:0: [sdd] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.560831]  sdn: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.562408] sd 9:0:1:0: [sdc] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.562583]  sdl: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.563070] sd 9:0:7:0: [sdi] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.565339]  sdq: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.566064]  sdo: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.566378] sd 9:0:0:0: [sdb] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.566451]  sdz: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.566814]  sdp: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.567061] sd 9:0:5:0: [sdg] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.568893] sd 9:0:11:0: [sdm] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.570759] sd 9:0:6:0: [sdh] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.570774]  sdv: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.571190]  sdad: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.571217]  sdx: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.571220] sd 9:0:9:0: [sdk] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.571978]  sdw: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.572054] sd 9:0:8:0: [sdj] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.572203] sd 9:0:4:0: [sdf] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.572978] sd 9:0:12:0: [sdn] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.574198]  sdr: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.574453] sd 9:0:10:0: [sdl] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.575109]  sdy: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.575807]  sdaa: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.577174] sd 9:0:16:0: [sdq] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.577965] sd 9:0:13:0: [sdo] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.578344] sd 9:0:25:0: [sdz] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.578582] sd 9:0:14:0: [sdp] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.582026]  sdac: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.582587] sd 9:0:21:0: [sdv] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.583409]  sds: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.583709] sd 9:0:29:0: [sdad] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.584252]  sdab: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.585325]  sdt: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.586695]  sdu: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.586908] sd 9:0:23:0: [sdx] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.587235]  sdae: unknown partition table
> Jul  3 00:31:50 storage02 kernel: [   83.587730] sd 9:0:24:0: [sdy] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.588652] sd 9:0:17:0: [sdr] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.593017] sd 9:0:26:0: [sdaa] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.593767] sd 9:0:28:0: [sdac] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.595166] sd 9:0:18:0: [sds] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.597120] sd 9:0:19:0: [sdt] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.599017] sd 9:0:30:0: [sdae] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.599220] sd 9:0:20:0: [sdu] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.599366] sd 9:0:22:0: [sdw] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.601829] sd 9:0:27:0: [sdab] Attached SCSI disk
> Jul  3 00:31:50 storage02 kernel: [   83.642042] mpt2sas1: sending message unit reset !!
> Jul  3 00:31:50 storage02 kernel: [   83.643713] md: bind<sde>
> Jul  3 00:31:50 storage02 kernel: [   83.646381] md: bind<sdg>
> Jul  3 00:31:50 storage02 kernel: [   83.648697] md: bind<sdo>
> Jul  3 00:31:50 storage02 kernel: [   83.650030] mpt2sas1: message unit reset: SUCCESS
> Jul  3 00:31:50 storage02 kernel: [   83.651774] md: bind<sdz>
> Jul  3 00:31:50 storage02 kernel: [   83.668803] md: bind<sdb>
> Jul  3 00:31:50 storage02 kernel: [   83.673296] md: bind<sds>
> Jul  3 00:31:50 storage02 kernel: [   83.676232] md: bind<sdh>
> Jul  3 00:31:50 storage02 kernel: [   83.679750] md: bind<sdy>
> Jul  3 00:31:50 storage02 kernel: [   83.682966] md: bind<sdc>
> Jul  3 00:31:50 storage02 kernel: [   83.686661] md: bind<sdt>
> Jul  3 00:31:50 storage02 kernel: [   83.690209] md: bind<sdq>
> Jul  3 00:31:50 storage02 kernel: [   83.694055] md: bind<sdk>
> Jul  3 00:31:50 storage02 kernel: [   83.698203] md: bind<sdn>
> Jul  3 00:31:50 storage02 kernel: [   83.702418] md: bind<sdr>
> Jul  3 00:31:50 storage02 kernel: [   83.706126] md: bind<sdaa>
> Jul  3 00:31:50 storage02 kernel: [   83.710213] md: bind<sdj>
> Jul  3 00:31:50 storage02 kernel: [   83.714886] md: bind<sdf>
> Jul  3 00:31:50 storage02 kernel: [   83.719982] md: bind<sdm>
> Jul  3 00:31:50 storage02 kernel: [   83.724944] md: bind<sdac>
> Jul  3 00:31:50 storage02 kernel: [   83.729285] md: bind<sdad>
> Jul  3 00:31:50 storage02 kernel: [   83.734026] md: bind<sdw>
> Jul  3 00:31:50 storage02 kernel: [   83.739043] md: bind<sdv>
> Jul  3 00:31:50 storage02 kernel: [   83.744178] md: bind<sdae>
> Jul  3 00:31:50 storage02 kernel: [   83.828458] ses 9:0:15:0: Attached Enclosure device
> Jul  3 00:31:50 storage02 kernel: [   83.828476] ses 9:0:31:0: Attached Enclosure device
> Jul  3 00:31:50 storage02 kernel: [   83.852009] mpt2sas1: Allocated physical memory: size(17336 kB)
> Jul  3 00:31:50 storage02 kernel: [   83.852013] mpt2sas1: Current Controller Queue Depth(9979), Max Controller Queue Depth(10240)
> Jul  3 00:31:50 storage02 kernel: [   83.852014] mpt2sas1: Scatter Gather Elements per IO(128)
> Jul  3 00:31:51 storage02 kernel: [   83.948846] md: bind<sdp>
> Jul  3 00:31:51 storage02 kernel: [   84.079753] md: bind<sdl>
> Jul  3 00:31:51 storage02 kernel: [   84.085511] mpt2sas1: LSISAS2308: FWVersion(19.00.00.00), ChipRevision(0x05), BiosVersion(07.37.00.00)
> Jul  3 00:31:51 storage02 kernel: [   84.085514] mpt2sas1: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
> Jul  3 00:31:51 storage02 kernel: [   84.085598] mpt2sas1: sending port enable !!
> Jul  3 00:31:51 storage02 kernel: [   84.088453] mpt2sas1: host_add: handle(0x0001), sas_addr(0x500605b00752bac0), phys(8)
> Jul  3 00:31:51 storage02 kernel: [   84.091112] mpt2sas1: expander_add: handle(0x0009), parent(0x0001), sas_addr(0x5000ae41fc3b00ff), phys(30)
> Jul  3 00:31:51 storage02 kernel: [   84.106364] mpt2sas1: expander_add: handle(0x001a), parent(0x0002), sas_addr(0x5000ae41fd5c00ff), phys(30)
> Jul  3 00:31:51 storage02 kernel: [   84.127177] md: bind<sdu>
> Jul  3 00:31:51 storage02 kernel: [   84.133098] mpt2sas1: port enable: SUCCESS
> Jul  3 00:31:51 storage02 kernel: [   84.134033] scsi 10:0:0:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:51 storage02 kernel: [   84.134056] scsi 10:0:0:0: SSP: handle(0x000a), sas_addr(0x50000c0f01151e3f), phy(0), device_name(0x0000000000000000)
> Jul  3 00:31:51 storage02 kernel: [   84.134059] scsi 10:0:0:0: SSP: enclosure_logical_id(0x5000ae41fc3b00ff), slot(0)
> Jul  3 00:31:51 storage02 kernel: [   84.134061] scsi 10:0:0:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:51 storage02 kernel: [   84.139828] scsi 10:0:1:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:51 storage02 kernel: [   84.139836] scsi 10:0:1:0: SSP: handle(0x000b), sas_addr(0x50000c0f011de013), phy(1), device_name(0x0000000000000000)
> Jul  3 00:31:51 storage02 kernel: [   84.139839] scsi 10:0:1:0: SSP: enclosure_logical_id(0x5000ae41fc3b00ff), slot(1)
> Jul  3 00:31:51 storage02 kernel: [   84.139844] scsi 10:0:1:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:51 storage02 kernel: [   84.142645] scsi 10:0:2:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:51 storage02 kernel: [   84.142651] scsi 10:0:2:0: SSP: handle(0x000c), sas_addr(0x50000c0f01c5facf), phy(2), device_name(0x0000000000000000)
> Jul  3 00:31:51 storage02 kernel: [   84.142653] scsi 10:0:2:0: SSP: enclosure_logical_id(0x5000ae41fc3b00ff), slot(2)
> Jul  3 00:31:51 storage02 kernel: [   84.142656] scsi 10:0:2:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:51 storage02 kernel: [   84.147790] scsi 10:0:3:0: Direct-Access     WD       WD4001FYYG-01SL3 VR02 PQ: 0 ANSI: 6
> Jul  3 00:31:51 storage02 kernel: [   84.147798] scsi 10:0:3:0: SSP: handle(0x000d), sas_addr(0x50000c0f01b8496f), phy(3), device_name(0x0000000000000000)
> Jul  3 00:31:51 storage02 kernel: [   84.147812] scsi 10:0:3:0: SSP: enclosure_logical_id(0x5000ae41fc3b00ff), slot(3)
> Jul  3 00:31:51 storage02 kernel: [   84.147815] scsi 10:0:3:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> Jul  3 00:31:51 storage02 kernel: [   84.323814] md: bind<sdi>
> Jul  3 00:31:51 storage02 kernel: [   84.340927] md: bind<sdx>
> Jul  3 00:31:51 storage02 kernel: [   84.405373] md: bind<sdd>
> Jul  3 00:31:51 storage02 kernel: [   84.439782] async_tx: api initialized (async)
> Jul  3 00:31:51 storage02 kernel: [   84.528288] raid6: sse2x1 5369 MB/s
> Jul  3 00:31:51 storage02 kernel: [   84.596157] raid6: sse2x2 6618 MB/s
> Jul  3 00:31:51 storage02 kernel: [   84.664026] raid6: sse2x4 7633 MB/s
> Jul  3 00:31:51 storage02 kernel: [   84.664029] raid6: using algorithm sse2x4 (7633 MB/s)
> Jul  3 00:31:51 storage02 kernel: [   84.664031] raid6: using ssse3x2 recovery algorithm
> Jul  3 00:31:51 storage02 kernel: [   84.682722] xor: automatically using best checksumming function:
> Jul  3 00:31:51 storage02 kernel: [   84.719914]    avx       : 15218.000 MB/sec
> Jul  3 00:31:51 storage02 kernel: [   84.751876] md: raid6 personality registered for level 6
> Jul  3 00:31:51 storage02 kernel: [   84.751879] md: raid5 personality registered for level 5
> Jul  3 00:31:51 storage02 kernel: [   84.751880] md: raid4 personality registered for level 4
> Jul  3 00:31:51 storage02 kernel: [   84.752152] md/raid:md2: device sdd operational as raid disk 9
> Jul  3 00:31:51 storage02 kernel: [   84.752155] md/raid:md2: device sdi operational as raid disk 1
> Jul  3 00:31:51 storage02 kernel: [   84.752157] md/raid:md2: device sdl operational as raid disk 6
> Jul  3 00:31:51 storage02 kernel: [   84.752159] md/raid:md2: device sdp operational as raid disk 12
> Jul  3 00:31:51 storage02 kernel: [   84.752161] md/raid:md2: device sdm operational as raid disk 5
> Jul  3 00:31:51 storage02 kernel: [   84.752162] md/raid:md2: device sdf operational as raid disk 2
> Jul  3 00:31:51 storage02 kernel: [   84.752163] md/raid:md2: device sdj operational as raid disk 0
> Jul  3 00:31:51 storage02 kernel: [   84.752165] md/raid:md2: device sdn operational as raid disk 10
> Jul  3 00:31:51 storage02 kernel: [   84.752166] md/raid:md2: device sdk operational as raid disk 13
> Jul  3 00:31:51 storage02 kernel: [   84.752168] md/raid:md2: device sdc operational as raid disk 4
> Jul  3 00:31:51 storage02 kernel: [   84.752169] md/raid:md2: device sdh operational as raid disk 7
> Jul  3 00:31:51 storage02 kernel: [   84.752170] md/raid:md2: device sdb operational as raid disk 14
> Jul  3 00:31:51 storage02 kernel: [   84.752172] md/raid:md2: device sdo operational as raid disk 11
> Jul  3 00:31:51 storage02 kernel: [   84.752173] md/raid:md2: device sdg operational as raid disk 8
> Jul  3 00:31:51 storage02 kernel: [   84.752175] md/raid:md2: device sde operational as raid disk 3
> Jul  3 00:31:51 storage02 kernel: [   84.753413] md/raid:md2: allocated 15954kB
> Jul  3 00:31:51 storage02 kernel: [   84.753471] md/raid:md2: raid level 6 active with 15 out of 15 devices, algorithm 2
> Jul  3 00:31:51 storage02 kernel: [   84.753473] RAID conf printout:
> Jul  3 00:31:51 storage02 kernel: [   84.753474]  --- level:6 rd:15 wd:15
> Jul  3 00:31:51 storage02 kernel: [   84.753476]  disk 0, o:1, dev:sdj
> Jul  3 00:31:51 storage02 kernel: [   84.753478]  disk 1, o:1, dev:sdi
> Jul  3 00:31:51 storage02 kernel: [   84.753479]  disk 2, o:1, dev:sdf
> Jul  3 00:31:51 storage02 kernel: [   84.753480]  disk 3, o:1, dev:sde
> Jul  3 00:31:51 storage02 kernel: [   84.753482]  disk 4, o:1, dev:sdc
> Jul  3 00:31:51 storage02 kernel: [   84.753487]  disk 5, o:1, dev:sdm
> Jul  3 00:31:51 storage02 kernel: [   84.753488]  disk 6, o:1, dev:sdl
> Jul  3 00:31:51 storage02 kernel: [   84.753490]  disk 7, o:1, dev:sdh
> Jul  3 00:31:51 storage02 kernel: [   84.753491]  disk 8, o:1, dev:sdg
> Jul  3 00:31:51 storage02 kernel: [   84.753493]  disk 9, o:1, dev:sdd
> Jul  3 00:31:51 storage02 kernel: [   84.753494]  disk 10, o:1, dev:sdn
> Jul  3 00:31:51 storage02 kernel: [   84.753496]  disk 11, o:1, dev:sdo
> Jul  3 00:31:51 storage02 kernel: [   84.753497]  disk 12, o:1, dev:sdp
> Jul  3 00:31:51 storage02 kernel: [   84.753499]  disk 13, o:1, dev:sdk
> Jul  3 00:31:51 storage02 kernel: [   84.753500]  disk 14, o:1, dev:sdb
> Jul  3 00:31:51 storage02 kernel: [   84.753535] md2: detected capacity change from 0 to 52008483684352
> Jul  3 00:31:51 storage02 kernel: [   84.756451]  md2: unknown partition table
> Jul  3 00:31:51 storage02 kernel: [   84.776502] md: bind<sdab>
> Jul  3 00:31:52 storage02 kernel: [   85.005541] md/raid:md3: device sdab operational as raid disk 5
> Jul  3 00:31:52 storage02 kernel: [   85.005544] md/raid:md3: device sdx operational as raid disk 1
> Jul  3 00:31:52 storage02 kernel: [   85.005546] md/raid:md3: device sdu operational as raid disk 2
> Jul  3 00:31:52 storage02 kernel: [   85.005548] md/raid:md3: device sdae operational as raid disk 12
> Jul  3 00:31:52 storage02 kernel: [   85.005549] md/raid:md3: device sdv operational as raid disk 8
> Jul  3 00:31:52 storage02 kernel: [   85.005551] md/raid:md3: device sdw operational as raid disk 7
> Jul  3 00:31:52 storage02 kernel: [   85.005552] md/raid:md3: device sdad operational as raid disk 11
> Jul  3 00:31:52 storage02 kernel: [   85.005554] md/raid:md3: device sdac operational as raid disk 10
> Jul  3 00:31:52 storage02 kernel: [   85.005555] md/raid:md3: device sdaa operational as raid disk 6
> Jul  3 00:31:52 storage02 kernel: [   85.005557] md/raid:md3: device sdr operational as raid disk 4
> Jul  3 00:31:52 storage02 kernel: [   85.005558] md/raid:md3: device sdq operational as raid disk 14
> Jul  3 00:31:52 storage02 kernel: [   85.005560] md/raid:md3: device sdt operational as raid disk 3
> Jul  3 00:31:52 storage02 kernel: [   85.005561] md/raid:md3: device sdy operational as raid disk 0
> Jul  3 00:31:52 storage02 kernel: [   85.005562] md/raid:md3: device sds operational as raid disk 9
> Jul  3 00:31:52 storage02 kernel: [   85.005564] md/raid:md3: device sdz operational as raid disk 13
> Jul  3 00:31:52 storage02 kernel: [   85.006640] md/raid:md3: allocated 15954kB
> Jul  3 00:31:52 storage02 kernel: [   85.006805] md/raid:md3: raid level 6 active with 15 out of 15 devices, algorithm 2
> Jul  3 00:31:52 storage02 kernel: [   85.006807] RAID conf printout:
> Jul  3 00:31:52 storage02 kernel: [   85.006808]  --- level:6 rd:15 wd:15
> Jul  3 00:31:52 storage02 kernel: [   85.006810]  disk 0, o:1, dev:sdy
> Jul  3 00:31:52 storage02 kernel: [   85.006811]  disk 1, o:1, dev:sdx
> Jul  3 00:31:52 storage02 kernel: [   85.006813]  disk 2, o:1, dev:sdu
> Jul  3 00:31:52 storage02 kernel: [   85.006814]  disk 3, o:1, dev:sdt
> Jul  3 00:31:52 storage02 kernel: [   85.006816]  disk 4, o:1, dev:sdr
> Jul  3 00:31:52 storage02 kernel: [   85.006817]  disk 5, o:1, dev:sdab
> Jul  3 00:31:52 storage02 kernel: [   85.006819]  disk 6, o:1, dev:sdaa
> Jul  3 00:31:52 storage02 kernel: [   85.006820]  disk 7, o:1, dev:sdw
> Jul  3 00:31:52 storage02 kernel: [   85.006822]  disk 8, o:1, dev:sdv
> Jul  3 00:31:52 storage02 kernel: [   85.006823]  disk 9, o:1, dev:sds
> Jul  3 00:31:52 storage02 kernel: [   85.006825]  disk 10, o:1, dev:sdac
> Jul  3 00:31:52 storage02 kernel: [   85.006827]  disk 11, o:1, dev:sdad
> Jul  3 00:31:52 storage02 kernel: [   85.006828]  disk 12, o:1, dev:sdae
> Jul  3 00:31:52 storage02 kernel: [   85.006830]  disk 13, o:1, dev:sdz
> Jul  3 00:31:52 storage02 kernel: [   85.006831]  disk 14, o:1, dev:sdq
> Jul  3 00:31:52 storage02 kernel: [   85.006870] md3: detected capacity change from 0 to 52008483684352
> Jul  3 00:31:52 storage02 kernel: [   85.014908]  md3: unknown partition table
> Jul  3 00:31:52 storage02 kernel: [   85.767430] mpt2sas1: log_info(0x3112011a): originator(PL), code(0x12), sub_code(0x011a)
> Jul  3 00:32:13 storage02 kernel: [  106.788334] scsi 10:0:4:0: attempting task abort! scmd(ffff8810218ff700)
> Jul  3 00:32:13 storage02 kernel: [  106.788342] scsi 10:0:4:0: CDB:
> Jul  3 00:32:13 storage02 kernel: [  106.788345] Inquiry: 12 00 00 00 24 00
> Jul  3 00:32:13 storage02 kernel: [  106.788359] scsi target10:0:4: handle(0x000e), sas_address(0x50000c0f011d86e3), phy(4)
> Jul  3 00:32:13 storage02 kernel: [  106.788363] scsi target10:0:4: enclosure_logical_id(0x5000ae41fc3b00ff), slot(4)
> Jul  3 00:32:17 storage02 kernel: [  110.717976] scsi 10:0:4:0: task abort: SUCCESS scmd(ffff8810218ff700)
> Jul  3 00:32:19 storage02 kernel: [  112.464615] mpt2sas1: log_info(0x3112011a): originator(PL), code(0x12), sub_code(0x011a)
> Jul  3 00:32:19 storage02 kernel: [  112.464665] scsi target10:0:4: attempting device reset! scmd(ffff8810218ff700)
> Jul  3 00:32:19 storage02 kernel: [  112.464671] scsi 10:0:4:0: CDB:
> Jul  3 00:32:19 storage02 kernel: [  112.464673] Inquiry: 12 00 00 00 24 00
> Jul  3 00:32:19 storage02 kernel: [  112.464686] scsi target10:0:4: handle(0x000e), sas_address(0x50000c0f011d86e3), phy(4)
> Jul  3 00:32:19 storage02 kernel: [  112.464690] scsi target10:0:4: enclosure_logical_id(0x5000ae41fc3b00ff), slot(4)
> Jul  3 00:32:23 storage02 kernel: [  116.456612] scsi 10:0:4:0: device reset: SUCCESS scmd(ffff8810218ff700)
> Jul  3 00:32:33 storage02 kernel: [  126.433657] scsi 10:0:4:0: attempting task abort! scmd(ffff8810218ff700)
> Jul  3 00:32:33 storage02 kernel: [  126.433666] scsi 10:0:4:0: CDB:
> Jul  3 00:32:33 storage02 kernel: [  126.433669] Test Unit Ready: 00 00 00 00 00 00
> Jul  3 00:32:33 storage02 kernel: [  126.433683] scsi target10:0:4: handle(0x000e), sas_address(0x50000c0f011d86e3), phy(4)
> Jul  3 00:32:33 storage02 kernel: [  126.433687] scsi target10:0:4: enclosure_logical_id(0x5000ae41fc3b00ff), slot(4)
> Jul  3 00:32:37 storage02 kernel: [  130.179378] scsi 10:0:4:0: task abort: SUCCESS scmd(ffff8810218ff700)
> Jul  3 00:32:37 storage02 kernel: [  130.179389] scsi target10:0:4: attempting target reset! scmd(ffff8810218ff700)
> Jul  3 00:32:37 storage02 kernel: [  130.179392] scsi 10:0:4:0: CDB:
> Jul  3 00:32:37 storage02 kernel: [  130.179395] Inquiry: 12 00 00 00 24 00
> Jul  3 00:32:37 storage02 kernel: [  130.179407] scsi target10:0:4: handle(0x000e), sas_address(0x50000c0f011d86e3), phy(4)
> Jul  3 00:32:37 storage02 kernel: [  130.179411] scsi target10:0:4: enclosure_logical_id(0x5000ae41fc3b00ff), slot(4)
> Jul  3 00:32:37 storage02 kernel: [  130.678880] scsi target10:0:4: target reset: SUCCESS scmd(ffff8810218ff700)
> Jul  3 00:32:47 storage02 kernel: [  140.657511] scsi 10:0:4:0: attempting task abort! scmd(ffff8810218ff700)
> Jul  3 00:32:47 storage02 kernel: [  140.657520] scsi 10:0:4:0: CDB:
> Jul  3 00:32:47 storage02 kernel: [  140.657523] Test Unit Ready: 00 00 00 00 00 00
> Jul  3 00:32:47 storage02 kernel: [  140.657537] scsi target10:0:4: handle(0x000e), sas_address(0x50000c0f011d86e3), phy(4)
> Jul  3 00:32:47 storage02 kernel: [  140.657541] scsi target10:0:4: enclosure_logical_id(0x5000ae41fc3b00ff), slot(4)
> Jul  3 00:32:51 storage02 kernel: [  144.401334] scsi 10:0:4:0: task abort: SUCCESS scmd(ffff8810218ff700)
> Jul  3 00:32:51 storage02 kernel: [  144.401343] mpt2sas1: attempting host reset! scmd(ffff8810218ff700)
> Jul  3 00:32:51 storage02 kernel: [  144.401347] scsi 10:0:4:0: CDB:
> Jul  3 00:32:51 storage02 kernel: [  144.401349] Inquiry: 12 00 00 00 24 00
> Jul  3 00:32:51 storage02 kernel: [  144.401458] mpt2sas1: sending diag reset !!
> Jul  3 00:32:52 storage02 kernel: [  145.292361] mpt2sas1: diag reset: SUCCESS
> Jul  3 00:32:52 storage02 kernel: [  145.524903] mpt2sas1: LSISAS2308: FWVersion(19.00.00.00), ChipRevision(0x05), BiosVersion(07.37.00.00)
> Jul  3 00:32:52 storage02 kernel: [  145.524910] mpt2sas1: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
> Jul  3 00:32:52 storage02 kernel: [  145.525126] mpt2sas1: search for end-devices: start
> Jul  3 00:34:28 storage02 kernel: [  240.942699] INFO: task modprobe:3512 blocked for more than 120 seconds.
> Jul  3 00:34:28 storage02 kernel: [  240.945311] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jul  3 00:34:28 storage02 kernel: [  240.946511] modprobe        D ffff881025ffada0     0  3512   3194 0x00000000
> Jul  3 00:34:28 storage02 kernel: [  240.946518]  ffff8810221b1d88 0000000000000082 ffff881029099fe0 ffff88103fc13ec0
> Jul  3 00:34:28 storage02 kernel: [  240.946526]  ffff8810221b1fd8 ffff8810221b1fd8 ffff8810221b1fd8 0000000000013ec0
> Jul  3 00:34:28 storage02 kernel: [  240.946534]  ffffffff81c15440 ffff8810241aae80 ffff8810221b1d78 ffffffff81c34080
> Jul  3 00:34:28 storage02 kernel: [  240.946542] Call Trace:
> Jul  3 00:34:28 storage02 kernel: [  240.946560] [<ffffffff816f54d9>] schedule+0x29/0x70
> Jul  3 00:34:28 storage02 kernel: [  240.946571] [<ffffffff81086f85>] async_synchronize_cookie_domain+0xa5/0x140
> Jul  3 00:34:28 storage02 kernel: [  240.946581] [<ffffffff8107fea0>] ?  add_wait_queue+0x60/0x60
> Jul  3 00:34:28 storage02 kernel: [  240.946587] [<ffffffff810874fe>] async_synchronize_full+0x6e/0x90
> Jul  3 00:34:28 storage02 kernel: [  240.946628] [<ffffffff816dffc8>] do_init_module+0x121/0x1d1
> Jul  3 00:34:28 storage02 kernel: [  240.946638] [<ffffffff810c30a5>] load_module+0x485/0x690
> Jul  3 00:34:28 storage02 kernel: [  240.946645] [<ffffffff810c0770>] ?  show_initstate+0x50/0x50
> Jul  3 00:34:28 storage02 kernel: [  240.946666] [<ffffffff810befa0>] ?  module_sect_show+0x30/0x30
> Jul  3 00:34:28 storage02 kernel: [  240.946685] [<ffffffff813604f0>] ?  copy_user_generic_string+0x30/0x40
> Jul  3 00:34:28 storage02 kernel: [  240.946694] [<ffffffff810c0839>] ?  copy_module_from_user.isra.44+0x89/0xb0
> Jul  3 00:34:28 storage02 kernel: [  240.946701] [<ffffffff810c332b>] sys_init_module+0x7b/0x80
> Jul  3 00:34:28 storage02 kernel: [  240.946711] [<ffffffff816ff25d>] system_call_fastpath+0x1a/0x1f
> Jul  3 00:36:28 storage02 kernel: [  360.709311] INFO: task modprobe:3512 blocked for more than 120 seconds.
> Jul  3 00:36:28 storage02 kernel: [  360.712270] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jul  3 00:36:28 storage02 kernel: [  360.713645] modprobe        D ffff881025ffada0     0  3512   3194 0x00000000
> Jul  3 00:36:28 storage02 kernel: [  360.713653]  ffff8810221b1d88 0000000000000082 ffff881029099fe0 ffff88103fc13ec0
> Jul  3 00:36:28 storage02 kernel: [  360.713661]  ffff8810221b1fd8 ffff8810221b1fd8 ffff8810221b1fd8 0000000000013ec0
> Jul  3 00:36:28 storage02 kernel: [  360.713680]  ffffffff81c15440 ffff8810241aae80 ffff8810221b1d78 ffffffff81c34080
> Jul  3 00:36:28 storage02 kernel: [  360.713689] Call Trace:
> Jul  3 00:36:28 storage02 kernel: [  360.713706] [<ffffffff816f54d9>] schedule+0x29/0x70
> Jul  3 00:36:28 storage02 kernel: [  360.713717] [<ffffffff81086f85>] async_synchronize_cookie_domain+0xa5/0x140
> Jul  3 00:36:28 storage02 kernel: [  360.713727] [<ffffffff8107fea0>] ?  add_wait_queue+0x60/0x60
> Jul  3 00:36:28 storage02 kernel: [  360.713733] [<ffffffff810874fe>] async_synchronize_full+0x6e/0x90
> Jul  3 00:36:28 storage02 kernel: [  360.713755] [<ffffffff816dffc8>] do_init_module+0x121/0x1d1
> Jul  3 00:36:28 storage02 kernel: [  360.713765] [<ffffffff810c30a5>] load_module+0x485/0x690
> Jul  3 00:36:28 storage02 kernel: [  360.713772] [<ffffffff810c0770>] ?  show_initstate+0x50/0x50
> Jul  3 00:36:28 storage02 kernel: [  360.713779] [<ffffffff810befa0>] ?  module_sect_show+0x30/0x30
> Jul  3 00:36:28 storage02 kernel: [  360.713788] [<ffffffff813604f0>] ?  copy_user_generic_string+0x30/0x40
> Jul  3 00:36:28 storage02 kernel: [  360.713794] [<ffffffff810c0839>] ?  copy_module_from_user.isra.44+0x89/0xb0
> Jul  3 00:36:28 storage02 kernel: [  360.713801] [<ffffffff810c332b>] sys_init_module+0x7b/0x80
> Jul  3 00:36:28 storage02 kernel: [  360.713811] [<ffffffff816ff25d>] system_call_fastpath+0x1a/0x1f

Hi Joe, Sreekanth,

I'm not sure why the driver doesn't like the enclosure, I suspect that
the modprobe hung task messages stem from the asynchronous target scan
taking a very long time.  The mpt2sas driver may wait up to 300 seconds
before giving up, more than long enough for any other waiting async
tasks to start complaining.  Hopefully Sreekanth can help you debug
that end of the problem.

The crash that occured when you issued a shutdown command was also
interesting and very similar to a bug that I was hunting down here at
Stratus.  Both of our instances crashed in the same code, but via
different paths.  In each case, it appears that the underlying adapter
resources had been cleaned up while other parts of the driver were
still actively referencing them.

In your crash stack trace, the scsi error handler has issued a host
reset, but then crashed in mpt2sas_base_get_iocstate.  Reading through
_scsih_shutdown, I don't believe that the mpt2sas .shutdown path takes
any precaution before heading down mpt2sas_base_detach to free adapter
resources.  The ordinary .remove path looks similar, though it does
call sas_remove_host before freeing resources, *then* scsi_remove_host
and scsi_host_put.

I wonder if this ordering needs to be reversed (and added to
_scsih_shutdown) to properly de-register from the SCSI midlayer prior
to removing the controller instance.

Regards,

-- Joe
