From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kernel exception in Fusion MPT base driver 3.04.06
 (linux-2.6.24.3)
Date: Tue, 18 Mar 2008 00:25:02 -0700
Message-ID: <20080318002502.852d0f12.akpm@linux-foundation.org>
References: <e64671580803171629g534ebf34l89adbb14bb985dc7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751697AbYCRHZf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Mar 2008 03:25:35 -0400
In-Reply-To: <e64671580803171629g534ebf34l89adbb14bb985dc7@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sabuj Pattanayek <sabujp@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Moore, Eric Dean" <Eric.Moore@lsil.com>

On Mon, 17 Mar 2008 18:29:28 -0500 "Sabuj Pattanayek" <sabujp@gmail.com> wrote:

> Hi,

Let's add some cc's.

> I'm running (uname -a):
> 
> Linux porpoise 2.6.24.3 #11 Mon Mar 17 17:24:30 CDT 2008 ppc64
> PPC970FX, altivec supported RackMac3,1 GNU/Linux
> 
> on an Apple Xserve G5. With the following fibre channel card (lspci
> -vvv, it has two fibre connections):
> 
> 0001:06:03.0 Fibre Channel: LSI Logic / Symbios Logic FC929X Fibre
> Channel Adapter (rev 81)
>         Subsystem: LSI Logic / Symbios Logic Unknown device 10d0
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR+ INTx-
>         Latency: 16 (16000ns min, 2500ns max), Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 53
>         Region 0: I/O ports at 0400 [size=256]
>         Region 1: Memory at 90030000 (64-bit, non-prefetchable) [size=64K]
>         Region 3: Memory at 90020000 (64-bit, non-prefetchable) [size=64K]
>         Expansion ROM at 90200000 [disabled] [size=1M]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/0 Enable-
>                 Address: 0000000000000000  Data: 0000
>         Capabilities: [68] PCI-X non-bridge device
>                 Command: DPERE- ERO- RBC=2048 OST=8
>                 Status: Dev=ff:1f.0 64bit+ 133MHz+ SCD- USC- DC=simple
> DMMRBC=2048 DMOST=8 DMCRS=64 RSCEM- 266MHz- 533MHz-
> 
> 0001:06:03.1 Fibre Channel: LSI Logic / Symbios Logic FC929X Fibre
> Channel Adapter (rev 81)
>         Subsystem: LSI Logic / Symbios Logic Unknown device 10d0
>         Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 16 (16000ns min, 2500ns max), Cache Line Size: 64 bytes
>         Interrupt: pin B routed to IRQ 53
>         Region 0: I/O ports at <unassigned> [disabled]
>         Region 1: Memory at 90010000 (64-bit, non-prefetchable)
> [disabled] [size=64K]
>         Region 3: Memory at 90000000 (64-bit, non-prefetchable)
> [disabled] [size=64K]
>         Expansion ROM at 90100000 [disabled] [size=1M]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/0 Enable-
>                 Address: 0000000000000000  Data: 0000
>         Capabilities: [68] PCI-X non-bridge device
>                 Command: DPERE- ERO- RBC=2048 OST=8
>                 Status: Dev=ff:1f.1 64bit+ 133MHz+ SCD- USC- DC=simple
> DMMRBC=2048 DMOST=8 DMCRS=64 RSCEM- 266MHz- 533MHz-
> 
> After doing "modprobe mptfc" I get the following kernel exception
> (dmesg output):
> 
> Fusion MPT base driver 3.04.06
> Copyright (c) 1999-2007 LSI Corporation
> Fusion MPT FC Host driver 3.04.06
> PCI: Enabling device: (0001:06:03.0), cmd 7
> mptbase: ioc0: Initiating bringup
> ioc0: LSIFC929XL A1: Capabilities={Initiator,Target,LAN}
> scsi4 : ioc0: LSIFC929XL A1, FwRev=01020e00h, Ports=1, MaxQ=1023, IRQ=53
> mptfc: ioc0: FC Link Established, Speed = 2 Gbps
> Oops: Exception in kernel mode, sig: 4 [#1]
> PowerMac
> Modules linked in: mptfc mptscsih mptbase
> NIP: d000000000144984 LR: d00000000014923c CTR: 0000000000000000
> REGS: c0000001387ef8f0 TRAP: 0700   Not tainted  (2.6.24.3)
> MSR: 9000000000089032 <EE,ME,IR,DR>  CR: 24002028  XER: 00000000
> TASK = c0000001388db040[12431] 'mptfc_wq_4' THREAD: c0000001387ec000
> GPR00: 00000000000000d3 c0000001387efb70 d000000000163b70 c000000138a8af1c
> GPR04: 00000000d3000000 00000000ffffffff 0000000000000000 c000000138a8af00
> GPR08: fffffffffffffffd 00000000000000ff 0000000000000000 00000000ffffffff
> GPR12: d000000000150040 c0000000006f8280 000000000023fb28 c0000000005e25e0
> GPR16: c0000001387efcb0 c0000001380dd758 c0000001387efcc0 c000000138978000
> GPR20: 0000000000000000 c0000001387da000 000000000000067d c0000001380dd454
> GPR24: c0000001387dd3e8 0000000000010000 d000000000159b87 c0000001380dd000
> GPR28: c0000001387efcc0 c0000001387efcd0 d000000000162500 c000000138a8af00
> NIP [d000000000144984] .mpt_add_sge+0x14/0x50 [mptbase]
> LR [d00000000014923c] .mpt_config+0x16c/0x3b0 [mptbase]
> Call Trace:
> [c0000001387efb70] [d000000000149120] .mpt_config+0x50/0x3b0 [mptbase]
> (unreliable)
> [c0000001387efc40] [d00000000015ec8c] .mptfc_rescan_devices+0x17c/0x780 [mptfc]
> [c0000001387efda0] [c0000000000548ac] .run_workqueue+0xec/0x1d0
> [c0000001387efe40] [c0000000000556cc] .worker_thread+0xdc/0x190
> [c0000001387eff00] [c00000000005a2e8] .kthread+0xc8/0xe0
> [c0000001387eff90] [c0000000000217cc] .kernel_thread+0x4c/0x68
> Instruction dump:
> 200000d0 230fff00 210000d0 00010000 02010010 08002500 09200100 03090006
> 230fff00 200000d0 230fff00 210000d0 <00010000> 02010010 08002500 09200100
> ---[ end trace 45fe87d4d747696e ]---

OK, mtp-fusion seems to have gone splat.

> Unable to handle kernel paging request for data at address 0x230fff00210000d0
> Faulting instruction address: 0xc000000000077658
> Oops: Kernel access of bad area, sig: 11 [#2]
> PowerMac
> Modules linked in: mptfc mptscsih mptbase
> NIP: c000000000077658 LR: c000000000077624 CTR: 000000000000000c
> REGS: c00000013a3b7530 TRAP: 0300   Tainted: G      D  (2.6.24.3)
> MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 24002028  XER: 00000000
> DAR: 230fff00210000d0, DSISR: 0000000040000000
> TASK = c00000013a38a810[156] 'pdflush' THREAD: c00000013a3b4000
> GPR00: 0000000000000010 c00000013a3b77b0 c0000000007e8218 000000000000000e
> GPR04: 000000000000000e 00000000000008e8 c00000013897e6b8 0000000000024000
> GPR08: 0000000000000002 0000000000000002 230fff00210000d0 0000000000000003
> GPR12: 0000000000000010 c0000000006f8280 000000000023fb28 c0000000005e25e0
> GPR16: c0000000006c6460 c00000013924fb28 0000000000000000 c00000013a3b7948
> GPR20: c00000000078e2a0 0000000000000000 c0000001381dd440 c00000013924fb28
> GPR24: ffffffffffffffff 000000000000000e 0000000000000000 c00000013a3b7da8
> GPR28: c00000013a3b7940 000000000000000e c000000000765818 c00000013a3b7958
> NIP [c000000000077658] .find_get_pages_tag+0x78/0x100
> LR [c000000000077624] .find_get_pages_tag+0x44/0x100
> Call Trace:
> [c00000013a3b77b0] [c000000000110330]
> .ext3_ordered_writepage+0x180/0x1e0 (unreliable)
> [c00000013a3b7840] [c0000000000825fc] .pagevec_lookup_tag+0x2c/0x50
> [c00000013a3b78d0] [c000000000080150] .write_cache_pages+0x1d0/0x450
> [c00000013a3b7a50] [c0000000000804b4] .do_writepages+0xa4/0xb0
> [c00000013a3b7ad0] [c0000000000cbf60] .__writeback_single_inode+0xb0/0x3c0
> [c00000013a3b7bd0] [c0000000000cc724] .sync_sb_inodes+0x224/0x390
> [c00000013a3b7c90] [c0000000000ccbb4] .writeback_inodes+0xe4/0x110
> [c00000013a3b7d30] [c0000000000810f0] .wb_kupdate+0xf0/0x190
> [c00000013a3b7e30] [c000000000081a28] .pdflush+0x178/0x280
> [c00000013a3b7f00] [c00000000005a2e8] .kthread+0xc8/0xe0
> [c00000013a3b7f90] [c0000000000217cc] .kernel_thread+0x4c/0x68
> Instruction dump:
> 7c7d1b79 41820074 393dffff 3ce00002 39000000 79290020 60e74000 39290001
> 7d2903a6 60000000 79001f24 7d5f002a <e92a0000> 7d293838 7fa93800 41de0068
> ---[ end trace 45fe87d4d747696e ]---

And that's a totally, wildly different part of the kernel.  ANd it's a
code-patch which millions of machines run all the time.

It's hard to see how oops #2 could be a consequence of oops #1.  Weird.

> Any ideas what's going on here? Attempting to run any further commands
> (e.g. reboot) causes a segfault or hang of the command (e.g. ls). I
> can send the enabled/modularized options of the .config in another
> email if required. Please CC replies to sabujp@gmail.com since I'm not
> on the list.
> 

Did any earlier kernel work OK?  If so, which?  2.6.23??

Thanks.
