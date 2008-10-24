From: Matthias Kaehlcke <mkaehlcke@e2s.net>
Subject: [ep93xx] Oops when inserting USB storage in 2.6.27
Date: Fri, 24 Oct 2008 09:05:53 +0200
Message-ID: <490173D1.80308@e2s.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------030400030209090802040105"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:24830 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbYJXHIM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2008 03:08:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kernel@wantstofly.org

--------------030400030209090802040105
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

hi,

inserting a Verbatim 4GB USB stick in a ep9307 based device running 
kernel 2.6.27 results in the following Oops:

[42949395.050000] usb 1-3: new full speed USB device using ep93xx-ohci
and address 2
[42949395.250000] usb 1-3: configuration #1 chosen from 1 choice
[42949395.260000] scsi0 : SCSI emulation for USB Mass Storage devices
[42949395.270000] usb 1-3: New USB device found, idVendor=13fe,
idProduct=1f23
[42949395.280000] usb 1-3: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[42949395.280000] usb 1-3: Product: STORE N GO
[42949395.300000] usb 1-3: Manufacturer: Verbatim
[42949395.310000] usb 1-3: SerialNumber: 078813D90478
[42949400.280000] Unable to handle kernel NULL pointer dereference at
virtual address 00000003
[42949400.280000] pgd = c0648000
[42949400.300000] [00000003] *pgd=c0647031, *pte=00000000, *ppte=00000000
[42949400.300000] Internal error: Oops: 13 [#1] PREEMPT
[42949400.300000] Modules linked in:
[42949400.300000] CPU: 0    Not tainted  (2.6.27 #3)
[42949400.300000] PC is at scsi_calculate_bounce_limit+0x3c/0x44
[42949400.300000] LR is at __scsi_alloc_queue+0x50/0xc8
[42949400.300000] pc : [<c01a9f40>]    lr : [<c01aabd0>]    psr: a0000013
[42949400.300000] sp : c0549d68  ip : c0549d78  fp : c0549d74
[42949400.300000] r10: 00000000  r9 : 00000000  r8 : 00000000
[42949400.300000] r7 : c0545000  r6 : c057641c  r5 : c0545000  r4 : c053d960
[42949400.300000] r3 : ffffffff  r2 : c0545000  r1 : 00000000  r0 : ffffffff
[42949400.300000] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[42949400.300000] Control: c000717f  Table: c0648000  DAC: 00000017
[42949400.300000] Process usb-stor-scan (pid: 692, stack limit = 0xc0548260)
[42949400.300000] Stack: (0xc0549d68 to 0xc054a000)
[42949400.300000] 9d60:                   c0549d90 c0549d78 c01aabd0
c01a9f14 c05a5614 c0565400
[42949400.300000] 9d80: c05a5600 c0549da4 c0549d94 c01aac60 c01aab90
c05a5614 c0549dd0 c0549da8
[42949400.300000] 9da0: c01ad310 c01aac58 00000000 c0545000 00000000
c05450e0 c05a5600 c05a5600
[42949400.300000] 9dc0: 00000000 c0549e5c c0549dd4 c01ad628 c01ad1f0
c0549e08 c0549de4 c019fe3c
[42949400.300000] 9de0: c02a8490 c05a567c c0549e08 c0549df8 c0158074
c0158ec4 00000000 c0549ed8
[42949400.300000] 9e00: 00000000 c019a6f4 c015806c c0545000 c0549e1c
c01ad0e0 c019a6e8 00000000
[42949400.300000] 9e20: c0549e50 c05450e0 c0545000 c05a5614 c05a5600
00000000 00000000 c05450e0
[42949400.300000] 9e40: c05a5600 ffffffff 00000000 00000000 c0549f04
c0549e60 c01ae168 c01ad574
[42949400.300000] 9e60: 00000000 00000000 c00724c4 c05a7e00 c0548000
c0549eac c0549e84 c0549eb0
[42949400.300000] 9e80: 00000064 c0549eb0 c0549eac c0549e98 c0061260
c00611c0 a0000013 ffff95e0
[42949400.300000] 9ea0: c0549ee4 c0549eb0 c02a812c c006123c 00000000
00200200 ffff95e0 c0061958
[42949400.300000] 9ec0: c1c543a0 c0370280 c0548000 00000064 00000001
c0549f2c 00000000 00000000
[42949400.300000] 9ee0: c0545000 c05450e0 ffffffff 00000000 00000000
00000000 c0549f30 c0549f08
[42949400.300000] 9f00: c01ae658 c01ae0a8 00000000 00000000 c0545000
ffffffff ffffffff c0545028
[42949400.300000] 9f20: 00000000 c0549f5c c0549f34 c01ae6f0 c01ae5f4
00000000 c0545000 00000000
[42949400.300000] 9f40: c0548000 c05453cc c0545328 c0549fa4 c0549f7c
c0549f60 c01ae7fc c01ae67c
[42949400.300000] 9f60: 00000000 c0545000 00000000 c0548000 c0549fa0
c0549f80 c01aee44 c01ae784
[42949400.300000] 9f80: c054530c 00000000 c0548000 c05453cc c0545328
c0549fdc c0549fa4 c01ebb28
[42949400.300000] 9fa0: c01aecf4 00000000 c1c543a0 c006d430 c0549fb0
c0549fb0 fffffffc c01ebad4
[42949400.300000] 9fc0: 00000000 00000000 00000000 00000000 c0549ff4
c0549fe0 c006d074 c01ebae4
[42949400.300000] 9fe0: 00000000 00000000 00000000 c0549ff8 c0059b30
c006d030 00000000 00000000
[42949400.300000] Backtrace:
[42949400.300000] [<c01a9f04>] (scsi_calculate_bounce_limit+0x0/0x44)
from [<c01aabd0>] (__scsi_alloc_queue+0x50/0xc8)
[42949400.300000] [<c01aab80>] (__scsi_alloc_queue+0x0/0xc8) from
[<c01aac60>] (scsi_alloc_queue+0x18/0x48)
[42949400.300000]  r6:c05a5600 r5:c0565400 r4:c05a5614
[42949400.300000] [<c01aac48>] (scsi_alloc_queue+0x0/0x48) from
[<c01ad310>] (scsi_alloc_sdev+0x130/0x1f0)
[42949400.300000]  r4:c05a5614
[42949400.300000] [<c01ad1e0>] (scsi_alloc_sdev+0x0/0x1f0) from
[<c01ad628>] (scsi_probe_and_add_lun+0xc4/0x8e4)
[42949400.300000] [<c01ad564>] (scsi_probe_and_add_lun+0x0/0x8e4) from
[<c01ae168>] (__scsi_scan_target+0xd0/0x54c)
[42949400.300000] [<c01ae098>] (__scsi_scan_target+0x0/0x54c) from
[<c01ae658>] (scsi_scan_channel+0x74/0x88)
[42949400.300000] [<c01ae5e4>] (scsi_scan_channel+0x0/0x88) from
[<c01ae6f0>] (scsi_scan_host_selected+0x84/0x108)
[42949400.300000] [<c01ae66c>] (scsi_scan_host_selected+0x0/0x108) from
[<c01ae7fc>] (do_scsi_scan_host+0x88/0x90)
[42949400.300000] [<c01ae774>] (do_scsi_scan_host+0x0/0x90) from
[<c01aee44>] (scsi_scan_host+0x160/0x1d0)
[42949400.300000]  r6:c0548000 r5:00000000 r4:c0545000
[42949400.300000] [<c01aece4>] (scsi_scan_host+0x0/0x1d0) from
[<c01ebb28>] (usb_stor_scan_thread+0x54/0x150)
[42949400.300000]  r8:c0545328 r7:c05453cc r6:c0548000 r5:00000000
r4:c054530c
[42949400.300000] [<c01ebad4>] (usb_stor_scan_thread+0x0/0x150) from
[<c006d074>] (kthread+0x54/0x80)
[42949400.300000] [<c006d020>] (kthread+0x0/0x80) from [<c0059b30>]
(do_exit+0x0/0x880)
[42949400.300000]  r5:00000000 r4:00000000
[42949400.300000] Code: 089da800 e59330d4 e3530000 089da800 (e8930003)
[42949400.710000] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
[42949400.710000] ---[ end trace ef8d373e910a1283 ]---
[42949400.750000] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
[42949401.000000] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
[42949401.250000] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
[42949401.500000] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
[42949401.750000] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
[42949402.000000] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
[42949402.250000] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
[42949402.500000] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
[42949402.750000] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
[42949403.000000] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
[42949403.250000] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0008
[42949403.250000] ep93xx-ohci ep93xx-ohci: GetStatus roothub.portstatus
[2] = 0x00030100 PESC CSC PPS
[42949403.270000] hub 1-0:1.0: port 3, status 0100, change 0003, 12 Mb/s
[42949403.270000] usb 1-3: USB disconnect, address 2
[42949403.270000] usb 1-3: unregistering device
[42949403.280000] usb 1-3: usb_disable_device nuking all URBs
[42949403.280000] usb 1-3: unregistering interface 1-3:1.0

the same hardware works fine with a 2.6.26.3 kernel

any idea what could be the problem?

--------------030400030209090802040105
Content-Type: text/x-vcard; charset="utf-8"; name="mkaehlcke.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="mkaehlcke.vcf"

begin:vcard
fn:Matthias Kaehlcke
n:Kaehlcke;Matthias
org:Electronic Engineering Solutions;Dept. de Software
adr:;;C/ Sant Ferran, 10-16 bajos;Barcelona;;08031;Spain
email;internet:mkaehlcke@e2s.net
title:Ingeniero de Firmware
tel;work:93 407 30 80
tel;fax:93 433 56 71
x-mozilla-html:FALSE
url:http://www.e2s.net
version:2.1
end:vcard


--------------030400030209090802040105--
