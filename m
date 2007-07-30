From: Matthew Wilcox <matthew@wil.cx>
Subject: qla2xyz broken in current Linus tree
Date: Mon, 30 Jul 2007 10:39:47 -0600
Message-ID: <20070730163947.GF21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60131 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936376AbXG3Qjt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:39:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Seokmann Ju <seokmann.ju@qlogic.com>, Richard Lary <rlary@us.ibm.com>


Reverting 281afe1947d855661754850de29d7530b2ff18dc fixes this panic:

qla2xxx 0000:42:07.0: Found an ISP2322, irq 19, iobase 0xf8812000
qla2xxx 0000:42:07.0: Configuring PCI space...
qla2xxx 0000:42:07.0: Configure NVRAM parameters...
BUG: unable to handle kernel NULL pointer dereference at virtual address 0000000
0
 printing eip:
c02e88f6
*pde = 00000000
Oops: 0002 [#1]
PREEMPT SMP
Modules linked in:
CPU:    0
EIP:    0060:[<c02e88f6>]    Not tainted VLI
EFLAGS: 00010202   (2.6.23-rc1-g33eff927 #109)
EIP is at qla2x00_read_nvram_data+0x23/0x55
eax: 00005349   ebx: 00000000   ecx: e2de3d63   edx: 00000035
esi: c1a0e2ec   edi: 00000000   ebp: 00000000   esp: c1903da0
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 1, ti=c1902000 task=c1901670 task.ti=c1902000)
Stack: 00000000 c02e88d3 00000000 c1a0e2ec 00000000 c02d99d1 00000100 00000038
       f7e80000 00000000 00000000 00000024 c1a0e2ec c1a0e2ec c1a0e2ec c1958000
       c1aded14 c1a0e2ec c1a0e2ec f8812000 c02d8048 c050e7ad c050cf76 c1aded14
Call Trace:
 [<c02e88d3>] qla2x00_read_nvram_data+0x0/0x55
 [<c02d99d1>] qla2x00_nvram_config+0x7e/0x765
 [<c02d8048>] qla2x00_initialize_adapter+0x113/0x226
 [<c02d4ad9>] qla2x00_probe_one+0x8b0/0xc87
 [<c01961b7>] sysfs_ilookup_test+0x0/0xd
 [<c01961b7>] sysfs_ilookup_test+0x0/0xd
 [<c019669d>] sysfs_addrm_finish+0x13/0x1d9
 [<c01976bc>] sysfs_create_link+0xf1/0x149
 [<c0130a9e>] call_usermodehelper_exec+0xab/0xb5
 [<c023744a>] pci_match_device+0x84/0xa4
 [<c02374b6>] pci_device_probe+0x36/0x57
 [<c028cac3>] driver_probe_device+0xe1/0x15f
 [<c044f795>] klist_next+0x58/0x6d
 [<c028cbd3>] __driver_attach+0x0/0x7f
 [<c028cc1c>] __driver_attach+0x49/0x7f
 [<c028c076>] bus_for_each_dev+0x33/0x55
 [<c028c91b>] driver_attach+0x16/0x18
 [<c028cbd3>] __driver_attach+0x0/0x7f
 [<c028c360>] bus_add_driver+0x6d/0x170
 [<c02375ff>] __pci_register_driver+0x52/0x7e
 [<c05bf2ef>] qla2x00_module_init+0xd4/0xfe
 [<c05a746a>] kernel_init+0x140/0x2a2
 [<c0120d6e>] schedule_tail+0x2e/0x81
 [<c0103db6>] ret_from_fork+0x6/0x1c
 [<c05a732a>] kernel_init+0x0/0x2a2
 [<c05a732a>] kernel_init+0x0/0x2a2
 [<c0104ae7>] kernel_thread_helper+0x7/0x10
 =======================
Code: 83 c4 10 5b 5e 5f 5d c3 55 57 56 53 83 ec 04 89 c6 89 14 24 89 cf e8 a4 e2
 ff ff 31 ed 8b 1c 24 eb 11 89 fa 89 f0 e8 21 e1 ff ff <66> 89 03 45 83 c3 02 47
 8b 44 24 18 d1 e8 39 c5 72 e5 8b 86 88
EIP: [<c02e88f6>] qla2x00_read_nvram_data+0x23/0x55 SS:ESP 0068:c1903da0
Kernel panic - not syncing: Attempted to kill init!

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
