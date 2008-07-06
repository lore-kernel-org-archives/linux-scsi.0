From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 11045] New: Bug in MPT Fusion 2.6.26-rc7
 unbootable
Date: Sun, 6 Jul 2008 12:34:17 -0700
Message-ID: <20080706123417.c1e2bebc.akpm@linux-foundation.org>
References: <bug-11045-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677AbYGFTex (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jul 2008 15:34:53 -0400
In-Reply-To: <bug-11045-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, "Moore, Eric Dean" <Eric.Moore@lsi.com>, support@lsi.com


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Sun,  6 Jul 2008 11:22:08 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11045
> 
>            Summary: Bug in MPT Fusion 2.6.26-rc7 unbootable
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.26-rc7
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: drivers_other@kernel-bugs.osdl.org
>         ReportedBy: kurk@shiftmail.org
> 
> 
> Latest working kernel version: 2.6.25
> Earliest failing kernel version: 2.6.26-rc7
> Distribution: Debian (but vanilla kernel)
> Hardware Environment: IBM xSeries 335
> Software Environment: error and hangup at boot
> Problem Description: MPT Fusion error, unbootable, see below
> Steps to reproduce: see below

We have two bugs here.  One in mpt-fusion and what I suspect is a
post-2.6.25 regression in ACPI.


> Detailed description:
> 
> Hi all,
> I'm no kernel expert, I hope I made no mistakes in this report. It seems to me
> that a bug was added to the MPT Fusion driver in 2.6.26 (rc7).
> 
> I compiled 2.6.26-rc7 on a machine with controller LSI53C1080 and it cannot
> boot. Doing the same with 2.6.25, basically the same config file, boots without
> problems.
> 
> I tried to forward-port the Fusion driver from 2.6.25 to 2.6.26-rc7 by simply
> copying over the directory drivers/message/fusion/ from 2.6.25 to 2.6.26-rc7
> but unfortunately this doesn't compile, so I am stuck not being able to use
> 2.6.26 on this machine (actually I have not tried versions of 2.6.26 earlier
> than rc7... I don't have much time now).
> 
> I connected a serial cable in order to obtain the boot error message. I
> obtained two of those on different boots. I will paste these at the end of this
> post.
> 
> 
> This is the verbose lspci of the controller (obtained with 2.6.25):
> ----------------------------------------
> 01:01.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X
> Fusion-MPT Dual Ultra320 SCSI (rev 07)
>         Subsystem: IBM Unknown device 026d
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+
> Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 72 (4250ns min, 4500ns max), Cache Line Size: 32 bytes
>         Interrupt: pin A routed to IRQ 22
>         Region 0: I/O ports at 2300 [size=256]
>         Region 1: Memory at fbff0000 (64-bit, non-prefetchable) [size=64K]
>         Region 3: Memory at fbfe0000 (64-bit, non-prefetchable) [size=64K]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
> Enable-
>                 Address: 0000000000000000  Data: 0000
>         Capabilities: [68] PCI-X non-bridge device
>                 Command: DPERE- ERO- RBC=512 OST=1
>                 Status: Dev=01:01.0 64bit+ 133MHz+ SCD- USC- DC=simple
> DMMRBC=2048 DMOST=8 DMCRS=16 RSCEM- 266MHz- 533MHz-
>         Kernel driver in use: mptspi
>         Kernel modules: mptspi
> ----------------------------------------
> 
> 
> This is an excerpt of the dmesg on 2.6.25 where the controller WORKS:
> --------------------------------------------------------------------
> Fusion MPT base driver 3.04.06
> Copyright (c) 1999-2007 LSI Corporation
> Fusion MPT SPI Host driver 3.04.06
> ...
> mptbase: ioc0: Initiating bringup
> ...
> ioc0: LSI53C1030 B2: Capabilities={Initiator}
> Probing IDE interface ide1...
> hdc: LG CD-ROM CRN-8245B, ATAPI CD/DVD-ROM drive
> scsi0 : ioc0: LSI53C1030 B2, FwRev=01000e00h, Ports=1, MaxQ=222, IRQ=22
> ...
> scsi0 : ioc0: LSI53C1030 B2, FwRev=01000e00h, Ports=1, MaxQ=222, IRQ=22
> hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> hdc: UDMA/33 mode selected
> ide1 at 0x170-0x177,0x376 on irq 15
> tg3.c:v3.90 (April 12, 2008)
> ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 24 (level, low) -> IRQ 24
> scsi 0:0:0:0: Direct-Access     IBM-ESXS DTN018C1UCDY10F  S23J PQ: 0 ANSI: 3
>  target0:0:0: Beginning Domain Validation
>  target0:0:0: Ending Domain Validation
>  target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
> scsi 0:0:1:0: Direct-Access     IBM-ESXS DTN018C1UCDY10F  S23J PQ: 0 ANSI: 3
>  target0:0:1: Beginning Domain Validation
> ...
> ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 25 (level, low) -> IRQ 25
>  target0:0:1: Ending Domain Validation
>  target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
> ...
> hdc: ATAPI 24X CD-ROM drive, 128kB Cache
> Uniform CD-ROM driver Revision: 3.20
> scsi 0:0:8:0: Processor         IBM      25P3495a S320  1 1    PQ: 0 ANSI: 2
>  target0:0:8: Beginning Domain Validation
>  target0:0:8: Ending Domain Validation
>  target0:0:8: asynchronous
> Driver 'sd' needs updating - please use bus_type methods
> sd 0:0:0:0: [sda] 35548320 512-byte hardware sectors (18201 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: cb 00 00 08
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> scsi 0:0:1:0: Attached scsi generic sg1 type 0
> scsi 0:0:8:0: Attached scsi generic sg2 type 3
> --------------------------------------------------------------------
> 
> 
> It is an x86 32bit PC compile. This is the excerpt of the .config file grepping
> for FUSION
> ------------------------------------
> CONFIG_FUSION=y
> CONFIG_FUSION_SPI=m
> CONFIG_FUSION_FC=m
> CONFIG_FUSION_SAS=m
> CONFIG_FUSION_MAX_SGE=40
> CONFIG_FUSION_CTL=m
> CONFIG_FUSION_LAN=m
> # CONFIG_FUSION_LOGGING is not set
> ------------------------------------
> 
> 
> 
> This is the boot error message obtained with serial cable. I left it running
> for 8 minutes for this. It loops so the message never ends.
> --------------------------------------------------------------------
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry
> 
> ACPI: Resource is not an IRQ entry

The acpi problem.

> mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000009!
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000034c
> 
> IP: [<f885cc5e>] :mptspi:mptspi_dv_renegotiate_work+0xa/0x9f
> 
> Oops: 0000 [#1] SMP
> 
> Modules linked in: ide_pci_generic(+) floppy mptspi(+) mptscsih ohci_hcd tg3
> mptbase scsi_transport_spi usbcore serverworks ide_core ata_generic libata
> scsi_mod dock thermal processor fan thermal_sys
> 
> 
> 
> Pid: 9, comm: events/0 Not tainted (2.6.26-rc7 #1)
> 
> EIP: 0060:[<f885cc5e>] EFLAGS: 00010282 CPU: 0
> 
> EIP is at mptspi_dv_renegotiate_work+0xa/0x9f [mptspi]
> 
> EAX: f7a447c0 EBX: f7429900 ECX: f7a447c4 EDX: c1908988
> 
> ESI: f7a447c0 EDI: 0000034c EBP: f7429904 ESP: f7477f80
> 
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> 
> Process events/0 (pid: 9, ti=f7476000 task=f744d770 task.ti=f7476000)
> 
> Stack: f744d8e0 c190b260 00000000 c1908984 f7429900 f7a447c0 f885cc54 f7429904
> 
>        c012f253 f7429900 c012f934 f742990c 00000000 c012f9e8 00000000 f744d770
> 
>        c0131bdc f7477fc4 f7477fc4 f7429900 c012f934 00000000 c0131b1b c0131ae3
> 
> Call Trace:
> 
>  [<f885cc54>] mptspi_dv_renegotiate_work+0x0/0x9f [mptspi]
> 
>  [<c012f253>] run_workqueue+0x75/0xf6
> 
>  [<c012f934>] worker_thread+0x0/0xbf
> 
>  [<c012f9e8>] worker_thread+0xb4/0xbf
> 
>  [<c0131bdc>] autoremove_wake_function+0x0/0x2b
> 
>  [<c012f934>] worker_thread+0x0/0xbf
> 
>  [<c0131b1b>] kthread+0x38/0x5d
> 
>  [<c0131ae3>] kthread+0x0/0x5d
> 
>  [<c0104573>] kernel_thread_helper+0x7/0x10
> 
>  =======================
> 
> Code: 70 e8 9e f8 ff ff 8b 47 70 e8 44 b7 fe ff 8b 47 70 5a 5b 5e 5f 5d e9 89
> f8 ff ff 58 5b 5e 5f 5d c3 55 57 56 53 83 ec 10 8b 78 10 <8b> 2f e8 c7 98 90 c7
> 66 83 bf 96 02 00 00 00 8b 85 3c 01 00 00
> 
> EIP: [<f885cc5e>] mptspi_dv_renegotiate_work+0xa/0x9f [mptspi] SS:ESP
> 0068:f7477f80
> 
> ---[ end trace e311270f757682e4 ]---

mpt-fusion shouldn't oops, no matter what acpi did to it.

