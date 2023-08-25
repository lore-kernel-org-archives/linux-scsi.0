Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B055DC3DA66
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 17:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244890AbjHYRJs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Aug 2023 13:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344245AbjHYRJ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2023 13:09:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F962109;
        Fri, 25 Aug 2023 10:09:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A65D66D80;
        Fri, 25 Aug 2023 17:09:21 +0000 (UTC)
Received: from rdvivi-mobl4 (unknown [192.55.55.52])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp.kernel.org (Postfix) with ESMTPSA id 8A0E4C433C8;
        Fri, 25 Aug 2023 17:09:16 +0000 (UTC)
Date:   Fri, 25 Aug 2023 13:09:15 -0400
From:   Rodrigo Vivi <rodrigo.vivi@kernel.org>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        TW <dalzot@gmail.com>, regressions@lists.linux.dev,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
Message-ID: <ZOjgJl4nlieu3+kL@rdvivi-mobl4>
References: <20230731003956.572414-1-dlemoal@kernel.org>
 <ZOehTysWO+U3mVvK@rdvivi-mobl4>
 <40adc06d-0835-2786-0bfb-83239f546d92@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40adc06d-0835-2786-0bfb-83239f546d92@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 25, 2023 at 08:42:13AM +0900, Damien Le Moal wrote:
> On 8/25/23 03:28, Rodrigo Vivi wrote:
> > On Mon, Jul 31, 2023 at 09:39:56AM +0900, Damien Le Moal wrote:
> >> During system resume, ata_port_pm_resume() triggers ata EH to
> >> 1) Resume the controller
> >> 2) Reset and rescan the ports
> >> 3) Revalidate devices
> >> This EH execution is started asynchronously from ata_port_pm_resume(),
> >> which means that when sd_resume() is executed, none or only part of the
> >> above processing may have been executed. However, sd_resume() issues a
> >> START STOP UNIT to wake up the drive from sleep mode. This command is
> >> translated to ATA with ata_scsi_start_stop_xlat() and issued to the
> >> device. However, depending on the state of execution of the EH process
> >> and revalidation triggerred by ata_port_pm_resume(), two things may
> >> happen:
> >> 1) The START STOP UNIT fails if it is received before the controller has
> >>    been reenabled at the beginning of the EH execution. This is visible
> >>    with error messages like:
> >>
> >> ata10.00: device reported invalid CHS sector 0
> >> sd 9:0:0:0: [sdc] Start/Stop Unit failed: Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> >> sd 9:0:0:0: [sdc] Sense Key : Illegal Request [current]
> >> sd 9:0:0:0: [sdc] Add. Sense: Unaligned write command
> >> sd 9:0:0:0: PM: dpm_run_callback(): scsi_bus_resume+0x0/0x90 returns -5
> >> sd 9:0:0:0: PM: failed to resume async: error -5
> >>
> >> 2) The START STOP UNIT command is received while the EH process is
> >>    on-going, which mean that it is stopped and must wait for its
> >>    completion, at which point the command is rather useless as the drive
> >>    is already fully spun up already. This case results also in a
> >>    significant delay in sd_resume() which is observable by users as
> >>    the entire system resume completion is delayed.
> >>
> >> Given that ATA devices will be woken up by libata activity on resume,
> >> sd_resume() has no need to issue a START STOP UNIT command, which solves
> >> the above mentioned problems. Do not issue this command by introducing
> >> the new scsi_device flag no_start_on_resume and setting this flag to 1
> >> in ata_scsi_dev_config(). sd_resume() is modified to issue a START STOP
> >> UNIT command only if this flag is not set.
> > 
> > Hi Damien,
> > 
> > Last week I noticed that a basic test in our validation started failing,
> > then I noticed that it was subsequent quick suspend and autoresume using
> > rtcwake that was problematic.
> 
> Arg... Again... Since the change of scsi layer to use async PM operations for
> suspend/resume, ATA side has been a constant source of issues. When the change
> was done, I did not notice any issue but several users reported problems.
> 
> > I couldn't collect any specific log that was pointing to some useful direction.
> > After a painful bisect I got to this patch. After reverting in from the
> > top of our tree, the tests are back to life.
> > 
> > The issue was that the subsequent quick suspend-resume (sometimes the
> > second, sometimes third or even sixth) was simply hanging the machine
> > in different points at Suspend.
> 
> I would have expected issues on the resume side. But it seems you are getting a
> hang on suspend, which is new. How quick are your suspend/resume cycles ? I did
> use rtcqake for my tests as well, but I was setting the wake timer at +5s or
> more and suspending with "systemctl suspend".

I meant resume. It hangs during random parts at the resume sequence.
Brain thought resume, fingers typed 'Suspend', I'm sorry!

> 
> > So, maybe we have some kind of disks/configuration out there where this
> > start upon resume is needed? Maybe it is just a matter of timming to
> > ensure some firmware underneath is up and back to life?
> 
> I do not think so. Suspend will issue a start stop unit command to put the drive
> to sleep and resume will reset the port (which should wake up the drive) and
> then issue an IDENTIFY command (which will also wake up the drive) and other
> read logs etc to rescan the drive.
> In both cases, if the commands do not complete, we would see errors/timeout and
> likely port reset/drive gone events. So I think this is likely another subtle
> race between scsi suspend and ata suspend that is causing a deadlock.
> 
> The main issue I think is that there is no direct ancestry between the ata port
> (device) and scsi device, so the change to scsi async pm ops made a mess of the
> suspend/resume operations ordering. For suspend, scsi device (child of ata port)
> should be first, then ata port device (parent). For resume, the reverse order is
> needed. PM normally ensures that parent/child ordering, but we lack that
> parent/child relationship. I am working on fixing that but it is very slow
> progress because I have been so far enable to recreate any of the issues that
> have been reported. I am patching "blind"...

I believe your suspicious makes sense. And on these lines, that patch you
attached earlier would fix that. However my initial tries of that didn't
help. I'm going to run more tests and get back to you.

> 
> Any chance you could get a thread stack dump when the system hangs ?
> 
> echo t > /proc/sysrq-trigger
> 
> And:
> 
> echo d > /proc/sysrq-trigger
> 
> would be useful as well...
> 
> That is, unless you really have a hard lockup...

no chance... it is a hard lockup.

> 
> > Well, please let me know the best way to report this issue to you and what
> > kind of logs I should get.
> 
> If you can get the above ? dmesg output as well with PM debug messages turned on.

I have the CONFIG_PM_DEBUG here with no_console_suspend.
If you remember any other config or parameter that would help, please let
me know that I collect it again:

[  104.571459] PM: suspend entry (deep)
[  104.585967] Filesystems sync: 0.010 seconds
[  104.618685] Freezing user space processes
[  104.625374] Freezing user space processes completed (elapsed 0.002 seconds)
[  104.632448] OOM killer disabled.
[  104.635712] Freezing remaining freezable tasks
[  104.641899] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
[  104.669767] wlp6s0: deauthenticating from 08:36:c9:85:df:ef by local choice (Reason: 3=DEAUTH_LEAVING)
[  104.679812] serial 00:01: disabled
[  104.683466] sd 7:0:0:0: [sdc] Synchronizing SCSI cache
[  104.688902] sd 7:0:0:0: [sdc] Stopping disk
[  104.693176] sd 5:0:0:0: [sdb] Synchronizing SCSI cache
[  104.698419] sd 4:0:0:0: [sda] Synchronizing SCSI cache
[  104.703730] sd 4:0:0:0: [sda] Stopping disk
[  104.885912] sd 5:0:0:0: [sdb] Stopping disk
[  106.163215] PM: suspend devices took 1.514 seconds
[  107.003217] serial 00:01: activated
[  107.076779] nvme nvme0: 16/0/0 default/read/poll queues
[  107.123917] r8169 0000:07:00.0 enp7s0: Link is Down
[  107.208945] PM: resume devices took 0.241 seconds
[  107.214746] pcieport 0000:00:1c.0: PCI bridge to [bus 06]
[  107.220274] pcieport 0000:00:1c.0:   bridge window [mem 0x43700000-0x437fffff]
[  107.227538] OOM killer enabled.
[  107.230710] Restarting tasks ...
[  107.231803] pcieport 0000:00:1c.2: PCI bridge to [bus 07]
[  107.236474] done.
[  107.240599] pcieport 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[  107.242574] random: crng reseeded on system resumption
[  107.249119] pcieport 0000:00:1c.2:   bridge window [mem 0x43600000-0x436fffff]
[  107.249405] pcieport 0000:00:1c.6: PCI bridge to [bus 08]
[  107.259714] PM: suspend exit
[  107.261623] pcieport 0000:00:1c.6:   bridge window [io  0x3000-0x3fff]
[  107.276554] pcieport 0000:00:1c.6:   bridge window [mem 0x43500000-0x435fffff]
[  107.283849] pcieport 0000:00:1c.6:   bridge window [mem 0x70900000-0x709fffff 64bit pref]
[  107.293567] ata7: SATA link down (SStatus 4 SControl 300)
[  107.304150] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  107.310975] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  107.319173] ata5.00: configured for UDMA/133
[  107.324620] ata5.00: Enabling discard_zeroes_data
[  107.398370] ata6.00: configured for UDMA/133
[  108.563229] PM: suspend entry (deep)
[  108.573610] Filesystems sync: 0.006 seconds
[  108.580617] Freezing user space processes
[  108.586774] Freezing user space processes completed (elapsed 0.002 seconds)
[  108.593793] OOM killer disabled.
[  108.597055] Freezing remaining freezable tasks
[  108.603246] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
[  108.621515] sd 7:0:0:0: [sdc] Synchronizing SCSI cache
[  108.621522] sd 5:0:0:0: [sdb] Synchronizing SCSI cache
[  108.622018] serial 00:01: disabled
[  108.635420] sd 4:0:0:0: [sda] Synchronizing SCSI cache
[  108.640747] sd 4:0:0:0: [sda] Stopping disk
[  108.644148] sd 5:0:0:0: [sdb] Stopping disk
[  108.983487] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  108.991923] ata8.00: configured for UDMA/133
[  108.996423] sd 7:0:0:0: [sdc] Stopping disk
[  109.973722] PM: suspend devices took 1.363 seconds
[  110.721600] serial 00:01: activated
[  110.802094] nvme nvme0: 16/0/0 default/read/poll queues
[  110.873036] r8169 0000:07:00.0 enp7s0: Link is Down
[  111.032278] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  111.038583] ata7: SATA link down (SStatus 4 SControl 300)
[  111.044065] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  111.051326] ata5.00: configured for UDMA/133
[  111.056118] ata5.00: Enabling discard_zeroes_data
[  111.131795] ata6.00: configured for UDMA/133
[  112.713764] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  112.724250] ata8.00: configured for UDMA/133


> 
> Also, what is your setup ? What machine, adapter and drive are you using ?

$ sudo lshw -class disk
  *-namespace:0
       description: NVMe disk
       physical id: 0
       logical name: hwmon1
  *-namespace:1
       description: NVMe disk
       physical id: 2
       logical name: /dev/ng0n1
  *-namespace:2
       description: NVMe disk
       physical id: 1
       bus info: nvme@0:1
       logical name: /dev/nvme0n1
       size: 465GiB (500GB)
       capabilities: gpt-1.00 partitioned partitioned:gpt
       configuration: guid=fd1cdad8-4a22-4fc9-8479-cce1748e78d5 logicalsectorsize=512 sectorsize=512 wwid=eui.e8238fa6bf530001001b448b45c5252c
  *-disk:0
       description: ATA Disk
       product: INTEL SSDSC2BB48
       physical id: 0
       bus info: scsi@4:0.0.0
       logical name: /dev/sda
       version: 0370
       serial: BTWL409509Q6480QGN
       size: 447GiB (480GB)
       capabilities: partitioned partitioned:dos
       configuration: ansiversion=5 logicalsectorsize=512 sectorsize=4096 signature=000226cf
  *-disk:1
       description: ATA Disk
       product: INTEL SSDSC2BW48
       physical id: 1
       bus info: scsi@5:0.0.0
       logical name: /dev/sdb
       version: DC32
       serial: PHDA4166003M4805GN
       size: 447GiB (480GB)
       capabilities: gpt-1.00 partitioned partitioned:gpt
       configuration: ansiversion=5 guid=b6c93ada-cbb1-412e-92e9-d644a476cacc logicalsectorsize=512 sectorsize=512
  *-disk:2
       description: ATA Disk
       product: ST1000DM010-2EP1
       physical id: 0.0.0
       bus info: scsi@7:0.0.0
       logical name: /dev/sdc
       version: CC46
       serial: ZN1VGAFZ
       size: 931GiB (1TB)
       capabilities: gpt-1.00 partitioned partitioned:gpt
       configuration: ansiversion=5 guid=8bd323ef-07b9-49c6-99c9-6581274d2f65 logicalsectorsize=512 sectorsize=4096

$ lspci -vv
00:00.0 Host bridge: Intel Corporation 12th Gen Core Processor Host Bridge/DRAM Registers (rev 02)
	DeviceName: Onboard - Other
	Subsystem: Gigabyte Technology Co., Ltd Device 5000
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:01.0 PCI bridge: Intel Corporation 12th Gen Core Processor PCI Express x16 Controller #1 (rev 02) (prog-if 00 [Normal decode])
	Subsystem: Gigabyte Technology Co., Ltd Device 5000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 120
	Bus: primary=00, secondary=01, subordinate=04, sec-latency=0
	I/O behind bridge: [disabled] [16-bit]
	Memory behind bridge: 42000000-433fffff [size=20M] [32-bit]
	Prefetchable memory behind bridge: 60000000-707fffff [size=264M] [32-bit]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:02.0 Display controller: Intel Corporation AlderLake-S GT1 (rev 0c)
	DeviceName: Onboard - Video
	Subsystem: Gigabyte Technology Co., Ltd Device d000
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 255
	Region 0: Memory at 41000000 (64-bit, non-prefetchable) [size=16M]
	Region 2: Memory at 50000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 5000 [disabled] [size=64]
	Capabilities: <access denied>
	Kernel modules: i915, xe

00:06.0 PCI bridge: Intel Corporation 12th Gen Core Processor PCI Express x4 Controller #0 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin D routed to IRQ 121
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: [disabled] [16-bit]
	Memory behind bridge: 43800000-438fffff [size=1M] [32-bit]
	Prefetchable memory behind bridge: [disabled] [64-bit]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:0a.0 Signal processing controller: Intel Corporation Platform Monitoring Technology (rev 01)
	DeviceName: Onboard - Other
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at 43910000 (64-bit, non-prefetchable) [size=32K]
	Capabilities: <access denied>
	Kernel driver in use: intel_vsec
	Kernel modules: intel_vsec

00:14.0 USB controller: Intel Corporation Alder Lake-S PCH USB 3.2 Gen 2x2 XHCI Controller (rev 11) (prog-if 30 [XHCI])
	DeviceName: Onboard - Other
	Subsystem: Gigabyte Technology Co., Ltd Device 5007
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 126
	Region 0: Memory at 43900000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>
	Kernel driver in use: xhci_hcd

00:14.2 RAM memory: Intel Corporation Alder Lake-S PCH Shared SRAM (rev 11)
	DeviceName: Onboard - Other
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at 4391c000 (64-bit, non-prefetchable) [disabled] [size=16K]
	Region 2: Memory at 4392b000 (64-bit, non-prefetchable) [disabled] [size=4K]
	Capabilities: <access denied>

00:15.0 Serial bus controller: Intel Corporation Alder Lake-S PCH Serial IO I2C Controller #0 (rev 11)
	DeviceName: Onboard - Other
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 27
	Region 0: Memory at 40400000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: intel-lpss

00:15.1 Serial bus controller: Intel Corporation Alder Lake-S PCH Serial IO I2C Controller #1 (rev 11)
	DeviceName: Onboard - Other
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 40
	Region 0: Memory at 40401000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: intel-lpss

00:15.2 Serial bus controller: Intel Corporation Alder Lake-S PCH Serial IO I2C Controller #2 (rev 11)
	DeviceName: Onboard - Other
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 29
	Region 0: Memory at 40402000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: intel-lpss

00:15.3 Serial bus controller: Intel Corporation Alder Lake-S PCH Serial IO I2C Controller #3 (rev 11)
	DeviceName: Onboard - Other
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin D routed to IRQ 43
	Region 0: Memory at 40403000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: intel-lpss

00:16.0 Communication controller: Intel Corporation Alder Lake-S PCH HECI Controller #1 (rev 11)
	DeviceName: Onboard - Other
	Subsystem: Gigabyte Technology Co., Ltd Device 1c3a
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 146
	Region 0: Memory at 43927000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: mei_me
	Kernel modules: mei_me

00:17.0 SATA controller: Intel Corporation Alder Lake-S PCH SATA Controller [AHCI Mode] (rev 11) (prog-if 01 [AHCI 1.0])
	DeviceName: Onboard - SATA
	Subsystem: Gigabyte Technology Co., Ltd Device b005
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 125
	Region 0: Memory at 43920000 (32-bit, non-prefetchable) [size=8K]
	Region 1: Memory at 43926000 (32-bit, non-prefetchable) [size=256]
	Region 2: I/O ports at 5090 [size=8]
	Region 3: I/O ports at 5080 [size=4]
	Region 4: I/O ports at 5060 [size=32]
	Region 5: Memory at 43925000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: ahci

00:19.0 Serial bus controller: Intel Corporation Alder Lake-S PCH Serial IO I2C Controller #4 (rev 11)
	DeviceName: Onboard - Other
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 31
	Region 0: Memory at 40404000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: intel-lpss

00:19.1 Serial bus controller: Intel Corporation Alder Lake-S PCH Serial IO I2C Controller #5 (rev 11)
	DeviceName: Onboard - Other
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 32
	Region 0: Memory at 40405000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: intel-lpss

00:1c.0 PCI bridge: Intel Corporation Alder Lake-S PCH PCI Express Root Port #1 (rev 11) (prog-if 00 [Normal decode])
	Subsystem: Gigabyte Technology Co., Ltd Device 5001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 122
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: [disabled] [16-bit]
	Memory behind bridge: 43700000-437fffff [size=1M] [32-bit]
	Prefetchable memory behind bridge: [disabled] [64-bit]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation Device 7aba (rev 11) (prog-if 00 [Normal decode])
	Subsystem: Gigabyte Technology Co., Ltd Device 5001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 123
	Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
	I/O behind bridge: 4000-4fff [size=4K] [16-bit]
	Memory behind bridge: 43600000-436fffff [size=1M] [32-bit]
	Prefetchable memory behind bridge: [disabled] [64-bit]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.6 PCI bridge: Intel Corporation Device 7abe (rev 11) (prog-if 00 [Normal decode])
	Subsystem: Gigabyte Technology Co., Ltd Device 5001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 124
	Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
	I/O behind bridge: 3000-3fff [size=4K] [16-bit]
	Memory behind bridge: 43500000-435fffff [size=1M] [32-bit]
	Prefetchable memory behind bridge: 70900000-709fffff [size=1M] [32-bit]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1f.0 ISA bridge: Intel Corporation Device 7a86 (rev 11)
	DeviceName: Onboard - Other
	Subsystem: Gigabyte Technology Co., Ltd Device 5001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:1f.3 Audio device: Intel Corporation Alder Lake-S HD Audio Controller (rev 11)
	DeviceName: Onboard - Sound
	Subsystem: Gigabyte Technology Co., Ltd Device a194
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 148
	Region 0: Memory at 43918000 (64-bit, non-prefetchable) [size=16K]
	Region 4: Memory at 43400000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd_hda_intel, snd_sof_pci_intel_tgl

00:1f.4 SMBus: Intel Corporation Alder Lake-S PCH SMBus Controller (rev 11)
	DeviceName: Onboard - Other
	Subsystem: Gigabyte Technology Co., Ltd Device 5001
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at 43922000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at efa0 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c_i801

00:1f.5 Serial bus controller: Intel Corporation Alder Lake-S PCH SPI Controller (rev 11)
	DeviceName: Onboard - Other
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at 40406000 (32-bit, non-prefetchable) [size=4K]

01:00.0 PCI bridge: Intel Corporation Device 4fa0 (rev 01) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at 70000000 (64-bit, prefetchable) [size=8M]
	Bus: primary=01, secondary=02, subordinate=04, sec-latency=0
	I/O behind bridge: [disabled] [32-bit]
	Memory behind bridge: 42000000-433fffff [size=20M] [32-bit]
	Prefetchable memory behind bridge: 60000000-6fffffff [size=256M] [32-bit]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

02:01.0 PCI bridge: Intel Corporation Device 4fa4 (prog-if 00 [Normal decode])
	Subsystem: Intel Corporation Device 4fa4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=02, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: [disabled] [16-bit]
	Memory behind bridge: 42000000-431fffff [size=18M] [32-bit]
	Prefetchable memory behind bridge: 60000000-6fffffff [size=256M] [32-bit]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

02:04.0 PCI bridge: Intel Corporation Device 4fa4 (prog-if 00 [Normal decode])
	Subsystem: Intel Corporation Device 0000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=02, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: [disabled] [16-bit]
	Memory behind bridge: 43300000-433fffff [size=1M] [32-bit]
	Prefetchable memory behind bridge: [disabled] [64-bit]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

03:00.0 VGA compatible controller: Intel Corporation DG2 [Arc A750] (rev 08) (prog-if 00 [VGA controller])
	Subsystem: ASRock Incorporation Device 6002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin ? routed to IRQ 145
	Region 0: Memory at 42000000 (64-bit, non-prefetchable) [size=16M]
	Region 2: Memory at 60000000 (64-bit, prefetchable) [size=256M]
	Expansion ROM at 43000000 [disabled] [size=2M]
	Capabilities: <access denied>
	Kernel driver in use: xe
	Kernel modules: i915, xe

04:00.0 Audio device: Intel Corporation DG2 Audio Controller
	Subsystem: ASRock Incorporation Device 6002
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin ? routed to IRQ 149
	Region 0: Memory at 43300000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd_hda_intel

05:00.0 Non-Volatile memory controller: Sandisk Corp Device 501e (prog-if 02 [NVM Express])
	Subsystem: Sandisk Corp Device 501e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	NUMA node: 0
	Region 0: Memory at 43800000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: nvme
	Kernel modules: nvme

06:00.0 Network controller: Intel Corporation Dual Band Wireless-AC 3168NGW [Stone Peak] (rev 10)
	Subsystem: Intel Corporation Device 2110
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 147
	Region 0: Memory at 43700000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>
	Kernel driver in use: iwlwifi
	Kernel modules: iwlwifi

07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 16)
	Subsystem: Gigabyte Technology Co., Ltd Onboard Ethernet
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 4000 [size=256]
	Region 2: Memory at 43604000 (64-bit, non-prefetchable) [size=4K]
	Region 4: Memory at 43600000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: r8169
	Kernel modules: r8169

08:00.0 Serial controller: Device 1c00:3253 (rev 10) (prog-if 05 [16850])
	Subsystem: Device 1c00:3253
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 3000 [size=256]
	Region 1: Memory at 70900000 (32-bit, prefetchable) [size=32K]
	Region 2: I/O ports at 3100 [size=4]
	Expansion ROM at 43500000 [disabled] [size=32K]
	Capabilities: <access denied>
	Kernel driver in use: serial

anything else or more specific?

Thanks,
Rodrigo.

> 
> -- 
> Damien Le Moal
> Western Digital Research
> 
