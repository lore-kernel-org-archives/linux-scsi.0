From: Tony Battersby <tonyb@cybernetics.com>
Subject: Unexpected IRQ trap when reloading mptspi with MSI
Date: Thu, 24 Jan 2008 12:08:46 -0500
Message-ID: <4798C61E.1050503@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([70.169.137.4]:4772 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760768AbYAXRIn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jan 2008 12:08:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com

I get "unexpected IRQ trap at vector dd" when reloading mptspi with MSI
enabled.  This seems to happen only on dual-channel HBAs; single-channel
HBAs are unaffected.  It looks like the second channel is generating a
bogus MSI interrupt while the first channel is being brought up.

modprobe mpt_base mpt_msi_enable=1
Jan 24 11:09:16 kernel: Fusion MPT base driver 3.04.06
Jan 24 11:09:16 kernel: Copyright (c) 1999-2007 LSI Corporation

modprobe mptspi
Jan 24 11:09:36 kernel: Fusion MPT SPI Host driver 3.04.06
Jan 24 11:09:36 kernel: ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 22 (level, low) -> IRQ 19
Jan 24 11:09:36 kernel: mptbase: ioc0: Initiating bringup
Jan 24 11:09:37 kernel: ioc0: LSI53C1030T A0: Capabilities={Initiator,Target}
Jan 24 11:09:37 kernel: mptbase: ioc0: PCI-MSI enabled
Jan 24 11:09:37 kernel: scsi0 : ioc0: LSI53C1030T A0, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=222
Jan 24 11:09:42 kernel: ACPI: PCI Interrupt 0000:03:04.1[B] -> GSI 23 (level, low) -> IRQ 20
Jan 24 11:09:42 kernel: mptbase: ioc1: Initiating bringup
Jan 24 11:09:42 kernel: ioc1: LSI53C1030T A0: Capabilities={Initiator,Target}
Jan 24 11:09:42 kernel: mptbase: ioc1: PCI-MSI enabled
Jan 24 11:09:43 kernel: scsi1 : ioc1: LSI53C1030T A0, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=221

rmmod mptspi

modprobe mptspi
Jan 24 11:11:05 kernel: Fusion MPT SPI Host driver 3.04.06
Jan 24 11:11:05 kernel: mptbase: ioc2: Initiating bringup
Jan 24 11:11:05 kernel: ioc2: LSI53C1030T A0: Capabilities={Initiator,Target}
Jan 24 11:11:05 kernel: mptbase: ioc2: PCI-MSI enabled
Jan 24 11:11:06 kernel: irq 221, desc: c03a9c00, depth: 0, count: 45, unhandled: 0
Jan 24 11:11:06 kernel: ->handle_irq():  c01400b0, handle_bad_irq+0x0/0x290
Jan 24 11:11:06 kernel: ->chip(): c03873c0, 0xc03873c0
Jan 24 11:11:06 kernel: ->action(): 00000000
Jan 24 11:11:06 kernel:   IRQ_DISABLED set
Jan 24 11:11:06 kernel: unexpected IRQ trap at vector dd
Jan 24 11:11:06 kernel: scsi2 : ioc2: LSI53C1030T A0, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=222
Jan 24 11:11:10 kernel: mptbase: ioc3: Initiating bringup
Jan 24 11:11:11 kernel: ioc3: LSI53C1030T A0: Capabilities={Initiator,Target}
Jan 24 11:11:11 kernel: mptbase: ioc3: PCI-MSI enabled
Jan 24 11:11:11 kernel: scsi3 : ioc3: LSI53C1030T A0, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=221

uname -a
Linux monster 2.6.24-rc8-git7 #1 SMP Thu Jan 24 11:26:53 EST 2008 i686 unknown

cat /proc/mpt/ioc0/info
ioc0:
  ProductID = 0x020b (LSI53C1030T A0)
  FWVersion = 0x01032700 (fw_size=42804)
  MsgVersion = 0x0102
  FirstWhoInit = 0x00
  EventState = 0x01
  CurrentHostMfaHighAddr = 0x00000000
  CurrentSenseBufferHighAddr = 0x00000000
  MaxChainDepth = 0x30 frames
  MinBlockSize = 0x20 bytes
  RequestFrames @ 0xf6402800 (Dma @ 0x36402800)
    {CurReqSz=96} x {CurReqDepth=255} = 24480 bytes ^= 0x7000
    {MaxReqSz=96}   {MaxReqDepth=255}
  Frames   @ 0xf6400000 (Dma @ 0x36400000)
    {CurRepSz=80} x {CurRepDepth=128} = 10240 bytes ^= 0x2880
    {MaxRepSz=0}   {MaxRepDepth=511}
  MaxDevices = 16
  MaxBuses = 1
  PortNumber = 1 (of 1)

cat /proc/mpt/ioc1/info
ioc1:
  ProductID = 0x020b (LSI53C1030T A0)
  FWVersion = 0x01032700 (fw_size=42804)
  MsgVersion = 0x0102
  FirstWhoInit = 0x00
  EventState = 0x01
  CurrentHostMfaHighAddr = 0x00000000
  CurrentSenseBufferHighAddr = 0x00000000
  MaxChainDepth = 0x30 frames
  MinBlockSize = 0x20 bytes
  RequestFrames @ 0xf6442800 (Dma @ 0x36442800)
    {CurReqSz=96} x {CurReqDepth=255} = 24480 bytes ^= 0x7000
    {MaxReqSz=96}   {MaxReqDepth=255}
  Frames   @ 0xf6440000 (Dma @ 0x36440000)
    {CurRepSz=80} x {CurRepDepth=128} = 10240 bytes ^= 0x2880
    {MaxRepSz=0}   {MaxRepDepth=511}
  MaxDevices = 16
  MaxBuses = 1
  PortNumber = 1 (of 1)

cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3       
  0:        129          0          0          1   IO-APIC-edge      timer
  1:        125          0          0          1   IO-APIC-edge      i8042
  3:         14          0          0          1   IO-APIC-edge      serial
  8:          0          0          0          0   IO-APIC-edge      rtc
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 10:          0          0          0         23   IO-APIC-fasteoi   ehci_hcd:usb1, ohci_hcd:usb2, ohci_hcd:usb3
 12:          1          0          0          2   IO-APIC-edge      i8042
 14:        432          0          0          8   IO-APIC-edge      ide0
 18:        231          0          0          1   IO-APIC-fasteoi   eth2
221:          0          0          1         44   PCI-MSI-edge      ioc1
222:          0          0          0         46   PCI-MSI-edge      ioc0
223:          0          0          0          2   PCI-MSI-edge      eth0
NMI:          0          0          0          0   Non-maskable interrupts
LOC:       2160        823        677       1009   Local timer interrupts
RES:        716        417        179        370   Rescheduling interrupts
CAL:         35         88         86         58   function call interrupts
TLB:         40         46         70         42   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
SPU:          0          0          0          0   Spurious interrupts
ERR:          0
MIS:          0


