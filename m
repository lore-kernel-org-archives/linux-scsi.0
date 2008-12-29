From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH] sym53c8xx_2: slave_alloc/destroy safety (2.6.27.5)
Date: Mon, 29 Dec 2008 15:20:28 -0500
Message-ID: <4959310C.1010406@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:1029 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbYL2UU3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Dec 2008 15:20:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aaro.koskinen@nsn.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

This patch can cause a NULL-pointer dereference and kernel oops.  In
sym53c8xx_slave_alloc(), there are starget_printk()s that use
tp->starget, e.g.:

starget_printk(KERN_INFO, tp->starget, "Scan at boot disabled in NVRAM\n");
...
starget_printk(KERN_INFO, tp->starget, "Multiple LUNs disabled in NVRAM\n");

However, you moved the setting of tp->starget to the end of the
function, so the starget_printk() above tries to dereference an
uninitialized pointer.

BUG: unable to handle kernel NULL pointer dereference at 0000015c
IP: [<c0243e13>] dev_driver_string+0x3/0x30
*pde = 00000000 
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in: sym53c8xx(+) sg scsi_transport_spi mptsas mptscsih
scsi_transport_sas tms_iscsi tms mptctl mptbase w83781d hwmon_vid
i2c_piix4 i2c_core e1000 emlog ftdi_sio usbserial [last unloaded:
sym53c8xx]
 
Pid: 1145, comm: insmod Not tainted (2.6.27.10 #2)
EIP: 0060:[<c0243e13>] EFLAGS: 00010002 CPU: 0
EIP is at dev_driver_string+0x3/0x30
EAX: 00000014 EBX: 00000110 ECX: 00000007 EDX: 00000014
ESI: ce62d7f0 EDI: 00000000 EBP: ce4f1a08 ESP: ce4f19e0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process insmod (pid: 1145, ti=ce4f0000 task=ce55d788 task.ti=ce4f0000)
Stack: ce4f1a08 d092ec70 00000005 00000000 00000000 ce402000 00000292
ce62d7f0 
       cf0a2bf0 cf0a2c04 ce4f1a2c c026236f 00000000 c025aac0 00000000
ce5ec7f0 
       ce5ec7f0 00000000 ce5ec958 ce4f1ae8 c026254d c0145ccd c0411cc0
c0411ce0 
Call Trace:
 [<d092ec70>] ? sym53c8xx_slave_alloc+0x160/0x190 [sym53c8xx]
 [<c026236f>] ? scsi_alloc_sdev+0x18f/0x200
 [<c025aac0>] ? scsi_device_lookup_by_target+0x60/0x80
 [<c026254d>] ? scsi_probe_and_add_lun+0xcd/0xb40
 [<c0145ccd>] ? trace_hardirqs_on_caller+0xbd/0x140
 [<c0145d5b>] ? trace_hardirqs_on+0xb/0x10
 [<c03275f8>] ? mutex_unlock+0x8/0x10
 [<c0145ccd>] ? trace_hardirqs_on_caller+0xbd/0x140
 [<c01d8702>] ? kobject_get+0x12/0x20
 [<c0244653>] ? get_device+0x13/0x20
 [<c0262026>] ? scsi_alloc_target+0x1e6/0x270
 [<c02631b8>] ? __scsi_scan_target+0xe8/0x6c0
 [<c0145d5b>] ? trace_hardirqs_on+0xb/0x10
 [<c0145b55>] ? mark_held_locks+0x65/0x80
 [<c0145d5b>] ? trace_hardirqs_on+0xb/0x10
 [<c0145ccd>] ? trace_hardirqs_on_caller+0xbd/0x140
 [<c0327302>] ? __mutex_lock_common+0x1f2/0x2f0
 [<c026386b>] ? scsi_scan_host_selected+0x4b/0x140
 [<c0263802>] ? scsi_scan_channel+0x72/0x90
 [<c02638ed>] ? scsi_scan_host_selected+0xcd/0x140
 [<c0265eaa>] ? scsi_proc_host_add+0x4a/0xa0
 [<c02639d6>] ? do_scsi_scan_host+0x76/0x80
 [<c0263c8a>] ? scsi_scan_host+0x15a/0x190
 [<c0328ab9>] ? _spin_unlock_irqrestore+0x49/0x60
 [<d0937c8a>] ? sym2_probe+0x89a/0x92e [sym53c8xx]
 [<c01f4e2e>] ? pci_device_probe+0x5e/0x80
 [<c024717e>] ? driver_probe_device+0x7e/0x170
 [<c02472e5>] ? __driver_attach+0x75/0x80
 [<c0246a59>] ? bus_for_each_dev+0x49/0x70
 [<c0246ff9>] ? driver_attach+0x19/0x20
 [<c0247270>] ? __driver_attach+0x0/0x80
 [<c024635c>] ? bus_add_driver+0xac/0x220
 [<c01f4a40>] ? pci_device_remove+0x0/0x40
 [<c024747f>] ? driver_register+0x4f/0x120
 [<c01eb9b2>] ? __spin_lock_init+0x32/0x60
 [<d0864000>] ? sym2_init+0x0/0xf6 [sym53c8xx]
 [<c01f4cae>] ? __pci_register_driver+0x5e/0xa0
 [<d0864000>] ? sym2_init+0x0/0xf6 [sym53c8xx]
 [<d0864087>] ? sym2_init+0x87/0xf6 [sym53c8xx]
 [<c0145ccd>] ? trace_hardirqs_on_caller+0xbd/0x140
 [<d0864000>] ? sym2_init+0x0/0xf6 [sym53c8xx]
 [<c010102a>] ? _stext+0x2a/0x140
 [<c0145d5b>] ? trace_hardirqs_on+0xb/0x10
 [<c0145ccd>] ? trace_hardirqs_on_caller+0xbd/0x140
 [<c014d725>] ? sys_init_module+0x85/0x1b0
 [<c0145ccd>] ? trace_hardirqs_on_caller+0xbd/0x140
 [<c01ddb94>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0103031>] ? sysenter_do_call+0x12/0x35
 =======================
Code: ff ff e9 6c fe ff ff 8b 45 cc bf ed ff ff ff e8 d4 7b f2 ff e9 5a
fe ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 89 c2 <8b> 80
48 01 00 00 89 e5 85 c0 74 04 8b 00 5d c3 8b 82 44 01 00 
EIP: [<c0243e13>] dev_driver_string+0x3/0x30 SS:ESP 0068:ce4f19e0
---[ end trace 856efca87f217e80 ]---

Tony Battersby
Cybernetics

