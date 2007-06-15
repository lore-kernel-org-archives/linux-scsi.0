From: "Lee Webb" <lwebb@clear2pay.com.au>
Subject: RE: RAID1 can't be written after pulling out the secondary hard disk
Date: Fri, 15 Jun 2007 12:05:12 +1000
Message-ID: <E564CC29982232499B35D3C15964CE68016EF45B@exchange.clear2pay.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [203.63.43.242] ([203.63.43.242]:9103 "EHLO
	mail.clear2pay.com.au" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbXFOCFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 22:05:14 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi Eric, Zhao,

Can I ask which kernel version the fix for this issue was introduced in?

I have recently installed CentOS5 running a 2.6.18-8.1.4.el5 kernel on a
new Dell PowerEdge SC1435 & appear to be having the same issue as that
reported by Zhao. I'm trying to track down the fix for it, but am having
trouble.

Details:

Machine:
	Dell PowerEdge SC1435

Raid config:
	Hardware RAID 1, 2 SATA disks 250GB each

lspci output for the controller:
07:08.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X
Fusion-MPT SAS (rev 01)
        Subsystem: Dell Unknown device 1f09
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 72 (16000ns min, 2500ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 193
        Region 0: I/O ports at dc00 [disabled] [size=256]
        Region 1: Memory at effec000 (64-bit, non-prefetchable)
[size=16K]
        Region 3: Memory at efff0000 (64-bit, non-prefetchable)
[size=64K]
        Expansion ROM at efe00000 [disabled] [size=1M]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [98] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=512 OST=16
                Status: Dev=07:08.0 64bit+ 133MHz+ SCD- USC- DC=simple
DMMRBC=2048 DMOST=16 DMCRS=128 RSCEM- 266MHz- 533MHz-
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
                Vector table: BAR=1 offset=00002000
                PBA: BAR=1 offset=00003000

Reproduction steps:
	1 Run the Dell SAS RAID Storage Manager utility on a remote X
console:
	2 DISPLAY=xxx:0.0 /usr/local/Dell\ SAS\ RAID\ Storage\
Manager/startupui.sh
	3 Select the secondary drive & force it to be offline
	4 Review the kernel logging to indicate that the ext3 filesystem
has called for ext3_abort
	
References:
	
http://article.gmane.org/gmane.linux.scsi/30838/match=mptsas+ext3+abort
	
http://news.gmane.org/find-root.php?message_id=%3cac8af0be0704100200v631
94731i91c9125ff7bff951%40mail.gmail.com%3e

Kernel Logging:
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x30050000): Originator={IOP}, Code={Task
Terminated}, SubCode(0x0000)
mptsas: ioc0: removing sata device, channel 0, id 1, phy 1
sd 0:1:0:0: SCSI error: return code = 0x00010000
end_request: I/O error, dev sda, sector 382084455
Buffer I/O error on device sda6, logical block 46170114
lost page write due to I/O error on sda6
sd 0:1:0:0: SCSI error: return code = 0x00010000
end_request: I/O error, dev sda, sector 12812135
Buffer I/O error on device sda6, logical block 11074
lost page write due to I/O error on sda6
Aborting journal on device sda6.
journal commit I/O error
ext3_abort called.
EXT3-fs error (device sda6): ext3_journal_start_sb: Detected aborted
journal
Remounting filesystem read-only
mptscsih: ioc0: ERROR - Received a mf that was already freed
mptscsih: ioc0: ERROR - req_idx=9680 req_idx_MR=9680 mf=ffff81007fbe4980
mr=0000000000000000 sc=0000000000000001
mptscsih: ioc0: ERROR - Received a mf that was already freed
mptscsih: ioc0: ERROR - req_idx=4980 req_idx_MR=4980 mf=ffff81007fbe9b80
mr=0000000000000000 sc=0000000000000004
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 0
mptbase: ioc0:   PhysDisk is now online, out of sync
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now degraded, enabled, resync in progress
mptsas: ioc0: attaching sata device, channel 0, id 1, phy 0
  Vendor: ATA       Model: WDC WD2500JS-75N  Rev: 2E04
  Type:   Direct-Access                      ANSI SCSI revision: 05
scsi 0:0:2:0: Attached scsi generic sg1 type 0

Cheers
Lee Webb
E: lwebb@clear2pay.com.au
T: ext 186
