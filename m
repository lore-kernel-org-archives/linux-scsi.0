From: Mark Nelson <markn@au1.ibm.com>
Subject: ipr and "Badness at kernel/lockdep.c:2193"
Date: Tue, 9 Dec 2008 17:57:51 +1100
Message-ID: <200812091757.51481.markn@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:52669 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbYLIG4y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Dec 2008 01:56:54 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id mB96tRVW022686
	for <linux-scsi@vger.kernel.org>; Tue, 9 Dec 2008 17:55:27 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB96unHU269320
	for <linux-scsi@vger.kernel.org>; Tue, 9 Dec 2008 17:56:52 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB96unBn029100
	for <linux-scsi@vger.kernel.org>; Tue, 9 Dec 2008 17:56:49 +1100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Hi Brian,

Booting one of our JS21 blades with 2.6.28-rc7 leads to the following:

ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
ipr 0000:01:01.0: Found IOA with IRQ: 26
ipr 0000:01:01.0: Starting IOA initialization sequence.
ipr 0000:01:01.0: Adapter firmware version: 06160039
ipr 0000:01:01.0: IOA initialized.
------------[ cut here ]------------
Badness at kernel/lockdep.c:2193
NIP: c0000000000855d0 LR: c0000000000855b4 CTR: c0000000000482d0
REGS: c00000000fffb8d0 TRAP: 0700   Not tainted  (2.6.28-rc5-autokern1)
MSR: 8000000000021032 <ME,IR,DR>  CR: 28000022  XER: 00000004
TASK = c00000000091fa80[0] 'swapper' THREAD: c000000000a3c000 CPU: 0
GPR00: 0000000000000000 c00000000fffbb50 c000000000a3c2e0 0000000000000001
GPR04: 000000000000a580 c0000000003870d4 0000000000000000 0000000000000001
GPR08: 0000000000000000 c00000000112fdf0 c0000000008ed918 c000000000abcfd0
GPR12: 0000000048000088 c000000000a7f300 0000000000000000 0000000002100000
GPR16: c000000000644bd0 c000000000643390 0000000000000000 00000000003d0c00
GPR20: 00000000028372d8 c0000000007372d8 0000000002837548 c000000000737548
GPR24: c000000000644660 00000000028372d8 000000000000001a c000000076760000
GPR28: 0000000000000004 c0000000004e8450 c0000000009aafb0 c00000000091fa80
NIP [c0000000000855d0] .trace_hardirqs_on_caller+0x10c/0x194
LR [c0000000000855b4] .trace_hardirqs_on_caller+0xf0/0x194
Call Trace:
[c00000000fffbb50] [c00000000fffbbe0] 0xc00000000fffbbe0 (unreliable)
[c00000000fffbbe0] [c0000000004e8450] ._spin_unlock_irq+0x38/0x5c
[c00000000fffbc70] [c0000000003870d4] .ipr_ioa_reset_done+0x204/0x284
[c00000000fffbd10] [c00000000037d234] .ipr_reset_ioa_job+0xc4/0xec
[c00000000fffbda0] [c000000000385ce0] .ipr_isr+0x208/0x484
[c00000000fffbe50] [c0000000000aaf3c] .handle_IRQ_event+0x58/0xd4
[c00000000fffbef0] [c0000000000ad978] .handle_fasteoi_irq+0x110/0x1ac
[c00000000fffbf90] [c000000000025214] .call_handle_irq+0x1c/0x2c
[c000000000a3f9a0] [c00000000000d168] .do_IRQ+0x120/0x210
[c000000000a3fa40] [c000000000004804] hardware_interrupt_entry+0x1c/0x98
--- Exception: 501 at .pseries_dedicated_idle_sleep+0xec/0x1cc
    LR = .pseries_dedicated_idle_sleep+0xdc/0x1cc
[c000000000a3fd30] [c000000000038208] .pseries_dedicated_idle_sleep+0x74/0x1cc (unreliable)
[c000000000a3fdd0] [c000000000012134] .cpu_idle+0x114/0x1dc
[c000000000a3fe60] [c0000000004ecb18] .rest_init+0x7c/0x94
[c000000000a3fee0] [c000000000700a40] .start_kernel+0x4b8/0x4e0
[c000000000a3ff90] [c000000000008368] .start_here_common+0x1c/0x34
Instruction dump:
e92d01b0 80090894 2f800000 41be002c 481ed1d1 60000000 2fa30000 419e0080
e93e8090 80090000 2f800000 409e0070 <0fe00000> 48000068 7fe3fb78 38800001
scsi0 : IBM 572E Storage Adapter
scsi 0:0:1:0: Direct-Access     IBM-ESXS MAY2036RC        T106 PQ: 0 ANSI: 5
scsi: unknown device type 31
scsi 0:255:255:255: No Device         IBM      572E001          0150 PQ: 0 ANSI: 0
vio_register_driver: driver ibmvscsi registering
st: Version 20080504, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:1:0: [sda] 71096640 512-byte hardware sectors: (36.4 GB/33.9 GiB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Mode Sense: d7 00 00 08
sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:1:0: [sda] 71096640 512-byte hardware sectors: (36.4 GB/33.9 GiB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Mode Sense: d7 00 00 08
sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
sd 0:0:1:0: [sda] Attached SCSI disk
Driver 'sr' needs updating - please use bus_type methods
sd 0:0:1:0: Attached scsi generic sg0 type 0
scsi 0:255:255:255: Attached scsi generic sg1 type 31


Is this an issue with the ipr driver or a lockdep issue?

Thanks!

Mark
