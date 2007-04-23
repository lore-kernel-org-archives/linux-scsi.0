From: Vivek Goyal <vgoyal@in.ibm.com>
Subject: AACRAID fails to initialize after an kexec operation
Date: Mon, 23 Apr 2007 13:19:13 +0530
Message-ID: <20070423074913.GC14664@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:35317 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965663AbXDWHt7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Apr 2007 03:49:59 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3N7nugF023872
	for <linux-scsi@vger.kernel.org>; Mon, 23 Apr 2007 03:49:56 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3N7nkDP118674
	for <linux-scsi@vger.kernel.org>; Mon, 23 Apr 2007 01:49:56 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3N7nkXx010714
	for <linux-scsi@vger.kernel.org>; Mon, 23 Apr 2007 01:49:46 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, aacraid@adaptec.com
Cc: Kexec Mailing List <kexec@lists.infradead.org>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>

Hi,

I am trying to kexec into 2.6.21-rc6-mm1 kernel on an x86_64 machine and
aacraid panics in the second kernel. Following is the panic message.

Any idea what's going on? Please let me know if more details are required.

Adaptec aacraid driver (1.1-5[2437]-mh4)
ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 25 (level, low) -> IRQ 25
Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
 [<0000000000000000>]
PGD 0
Oops: 0000 [1] SMP
last sysfs file:
CPU 4
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.21-rc6-mm1 #2
RIP: 0010:[<0000000000000000>]  [<0000000000000000>]
RSP: 0018:ffff810100c9fc78  EFLAGS: 00010246
RAX: ffff810100c9fcc4 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000001001 RDI: ffff810100e02d30
RBP: ffff810100e02d30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000002 R12: ffff810100e02800
R13: 0000000000000000 R14: ffffffff80690ee1 R15: 000000000000002d
FS:  0000000000000000(0000) GS:ffff810100cf6440(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
Process swapper (pid: 1, threadinfo ffff810100c9e000, task ffff810100c9d450)
Stack:  ffffffff8045952f 0000000000000000 ffffffff00000000 ffff810100c9fcc4
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
 ffffffff80690ee1 000000000000002d ffff810100e02d30 0000000000000001
Call Trace:
Inexact backtrace:
 [<ffffffff8045952f>] aac_rx_restart_adapter+0x7e/0x169
 [<ffffffff80459a0a>] _aac_rx_init+0x70/0x2f6
 [<ffffffff80280ee4>] cache_alloc_refill+0xdb/0x1db
 [<ffffffff8045317f>] aac_probe_one+0x1a9/0x462
 [<ffffffff8035f3a0>] pci_device_probe+0xd1/0x138
 [<ffffffff803b3251>] driver_probe_device+0xf7/0x174
 [<ffffffff803b33e4>] __driver_attach+0x6f/0xae
 [<ffffffff803b3375>] __driver_attach+0x0/0xae
 [<ffffffff803b3375>] __driver_attach+0x0/0xae
 [<ffffffff803b261e>] bus_for_each_dev+0x43/0x6e
 [<ffffffff803b2993>] bus_add_driver+0x78/0x19a
 [<ffffffff8035f578>] __pci_register_driver+0x58/0x8d
 [<ffffffff8084a909>] aac_init+0x35/0x70
 [<ffffffff8082d8ad>] kernel_init+0x167/0x2d1
 [<ffffffff8020a998>] child_rip+0xa/0x12
 [<ffffffff8036bd60>] acpi_ds_init_one_object+0x0/0x7c
 [<ffffffff8082d746>] kernel_init+0x0/0x2d1
 [<ffffffff8020a98e>] child_rip+0x0/0x12


Code:  Bad RIP value.
RIP  [<0000000000000000>]
 RSP <ffff810100c9fc78>
CR2: 0000000000000000
Kernel panic - not syncing: Attempted to kill init!

Thanks
Vivek
