From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: sas transport layer oops - mpt fusion
Date: Mon, 19 Dec 2005 12:18:43 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1199E4@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:57006 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964885AbVLSTTK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Dec 2005 14:19:10 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Kernel: 2.6.15-rc5
MPT fusion driver version: 3.03.04

Reproduce:  Compile the fusion drivers as module.  load driver,
then unload and reload => OOPS => transport_setup_device() => 
attribute_container_add_device.

Something is not being cleaned up properly when the driver is unloaded.
Any ideas?

Here is the oops (running kdb):


Fusion MPT SAS Host driver 3.03.04
PCI: Enabling device 0000:03:02.0 (0106
-> 0107)
ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 52 (level, low) -> IRQ 22
mptbase: Initiating ioc1 bringup
ioc1: SAS1068: Capabilities={Initiator}
Oops: 0000 [#1]
SMP
eMmoore-test2 keodules linked in:ne l: scsi1 : iomptsas 1: LSISAS1068,
mptscsih mptbasewR ev=01080100h,scsi_transport_sas P2
exportfs snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device
snd_pcm_oss snd_mixer_oss snd_intel8x0 snd_ac9s
CPU:    1
EIP:    0060:[<00000000>]    Not tainted VLI
EFLAGS: 00010246   (2.6.15-rc5)
EIP is at 0x0
eax: d01e5e68   ebx: d01e5e68   ecx: 00000000   edx: dbf1e8e4
esi: dbf1e800   edi: 00000000   ebp: ca28be74   esp: ca28be54
ds: 007b   es: 007b   ss: 0068
Process modprobe (pid: 16893, threadinfo=ca28a000 task=ca0b9030)
Stack: c0277f40 c81aedac c03f74cc c0278490 dbf1e8e4 dbf1e8e4 dbf1e800
00000000
       ca28be7c c02784cd ca28be90 c02aed2a e0da4da0 dbf1e800 00000000
ca28beb0
       c02a67bb dbf1ea18 dbf1e8e4 dfe9d044 00000100 00000000 dc254000
ca28bee4
Call Trace:
 [<c010539b>] show_stack+0x9b/0xb0
 [<c01054ec>] show_registers+0x11c/0x190
 [<c01056bd>] die+0xdd/0x170
 [<c0356aa7>] do_page_fault+0x357/0x5b4
 [<c0104fff>] error_code+0x4f/0x60
 [<c02784cd>] transport_setup_device+0xd/0x10
 [<c02aed2a>] scsi_sysfs_add_host+0x9a/0xb0
 [<c02a67bb>] scsi_add_host+0x10b/0x1c0
 [<e0da2561>] mptsas_probe+0x361/0x3f0 [mptsas]
 [<c021fc1d>] pci_call_probe+0xd/0x10
 [<c021fc5a>] __pci_device_probe+0x3a/0x50
 [<c021fc91>] pci_device_probe+0x21/0x40
 [<c027544d>] driver_probe_device+0x2d/0xb0
 [<c027557a>] __driver_attach+0x3a/0x40
 [<c0274bb9>] bus_for_each_dev+0x49/0x70
 [<c0275594>] driver_attach+0x14/0x20
 [<c0275007>] bus_add_driver+0x67/0xb0
 [<c0275929>] driver_register+0x39/0x40
 [<c021feaf>] __pci_register_driver+0x6f/0xa0
 [<e0b5e0af>] mptsas_init+0xaf/0xb5 [mptsas]
 [<c0139efa>] sys_init_module+0x12a/0x1c0
 [<c0103e7b>] sysenter_past_esp+0x54/0x79
Code:  Bad EIP value.

Entering kdb (current=0xca0b9030, pid 16893) on processor 1 Oops: Oops
due to oops @ 0x0
eax = 0xd01e5e68 ebx = 0xd01e5e68 ecx = 0x00000000 edx = 0xdbf1e8e4
esi = 0xdbf1e800 edi = 0x00000000 esp = 0xca28be54 eip = 0x00000000
ebp = 0xca28be74 xss = 0xc02c0068 xcs = 0x00000060 eflags = 0x00010246
xds = 0xdbf1007b xes = 0xc019007b origeax = 0xffffffff &regs =
0xca28be20
[1]kdb> bt
Stack traceback for pid 16893
0xca0b9030    16893    14834  1    1   R  0xca0b91f0 *modprobe
EBP        EIP        Function (args)
0xca28be74 0x00000000 <unknown>
           0xca28bd4c <unknown>+0xb (0x4, 0xca28be20, 0x5, 0xca28a000,
0x5)
           0xc02cbb09 kdba_main_loop+0x29 (0x4, 0xca28be20, 0x0, 0x4,
0x0)
0xca28bd80 0xc020b111 kdb+0x301 (0x5, 0x0, 0xca28be20, 0x0, 0xca28be20)
0xca28bdc4 0xc01056e9 die+0x109 (0xc0383373, 0x0, 0x0, 0x30001, 0x0)
0xca28be18 0xc0356aa7 do_page_fault+0x357 (0xd01e5e68, 0x0, 0xdbf1e8e4,
0xdbf1e800, 0x0)
           0xc0104fff error_code+0x4f
Interrupt registers:
eax = 0xd01e5e68 ebx = 0xd01e5e68 ecx = 0x00000000 edx = 0xdbf1e8e4
esi = 0xdbf1e800 edi = 0x00000000 esp = 0xca28be54 eip = 0x00000000
ebp = 0xca28be74 xss = 0xc02c0068 xcs = 0x00000060 eflags = 0x00010246
xds = 0xdbf1007b xes = 0xc019007b origeax = 0xffffffff &regs =
0xca28be20
           0x00010246 <unknown> (0xc81aedac, 0xc03f74cc, 0xc0278490,
0xdbf1e8e4, 0xdbf1e8e4)
           0xc0277f40 attribute_container_add_device+0x50
0xca28be7c 0xc02784cd transport_setup_device+0xd (0xe0da4da0,
0xdbf1e800,
0x0)
0xca28be90 0xc02aed2a scsi_sysfs_add_host+0x9a (0xdbf1ea18, 0xdbf1e8e4,
0xdfe9d044, 0x100, 0x0)
0xca28beb0 0xc02a67bb scsi_add_host+0x10b (0x80, 0xcd7bf580, 0xdc254000,
0xfffffff4, 0x282)
0xca28bee4 0xe0da2561 [mptsas]mptsas_probe+0x361 (0xdfe9d000)
0xca28bef0 0xc021fc1d pci_call_probe+0xd (0xe0da4f20, 0xdfe9d000, 0x0)
[1]more>



