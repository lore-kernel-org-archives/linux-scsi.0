From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [2.5.66-bk3] sym53c8xx Oops on rmmod
Date: Fri, 28 Mar 2003 15:10:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303281510.54597@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm getting this error if I "rmmod sym53c8xx". It's reproducible and makes
always the same Oops, I tested it and got twice the same.

Eike

Unable to handle kernel paging request at virtual address c8846094
 printing eip:
c8846094
*pde = 011dd067
*pte = 00000000
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[__crc_pci_find_class+957793/3005906]    Not tainted
EIP:    0060:[<c8846094>]    Not tainted
EFLAGS: 00010286
EIP is at 0xc8846094
eax: 00000080   ebx: c6bb4000   ecx: 0000657f   edx: c8882000
esi: c6bb45d8   edi: c88e10e0   ebp: c88d158c   esp: c3263ef8
ds: 007b   es: 007b   ss: 0068
Process rmmod (pid: 1313, threadinfo=c3262000 task=c6c7e710)
Stack: c88e50b1 c8882000 00000080 c6bb4000 c88e51cf c6bb4000 0000000a c88ecc7d 
       c6bb45d8 c6bb4620 c88ecc6a c6bb45d8 c12cad60 c12cad60 c88e51eb c6bb4000 
       c88d15a7 c12cad60 c3262000 c88d150b c12cad60 c88f3900 c3262000 00000000 
Call Trace:
 [__crc_pci_find_class+1609086/3005906] sym_free_resources+0x51/0x90 [sym53c8xx]
 [<c88e50b1>] sym_free_resources+0x51/0x90 [sym53c8xx]
 [__crc_pci_find_class+1609372/3005906] sym_detach+0x4f/0x5c [sym53c8xx]
 [<c88e51cf>] sym_detach+0x4f/0x5c [sym53c8xx]
 [__crc_pci_find_class+1640778/3005906] +0xd1d/0x2180 [sym53c8xx]
 [<c88ecc7d>] +0xd1d/0x2180 [sym53c8xx]
 [__crc_pci_find_class+1640759/3005906] +0xd0a/0x2180 [sym53c8xx]
 [<c88ecc6a>] +0xd0a/0x2180 [sym53c8xx]
 [__crc_pci_find_class+1609400/3005906] sym53c8xx_release+0xf/0x15 [sym53c8xx]
 [<c88e51eb>] sym53c8xx_release+0xf/0x15 [sym53c8xx]
 [__crc_pci_find_class+1528436/3005906] scsi_remove_legacy_host+0x1b/0x24 [scsi_mod]
 [<c88d15a7>] scsi_remove_legacy_host+0x1b/0x24 [scsi_mod]
 [__crc_pci_find_class+1528280/3005906] scsi_tp_for_each_host+0x47/0x78 [scsi_mod]
 [<c88d150b>] scsi_tp_for_each_host+0x47/0x78 [scsi_mod]
 [__crc_pci_find_class+1668557/3005906] +0x0/0x100 [sym53c8xx]
 [<c88f3900>] +0x0/0x100 [sym53c8xx]
 [__crc_pci_find_class+1529971/3005906] scsi_unregister_host+0xe/0x14 [scsi_mod]
 [<c88d1ba6>] scsi_unregister_host+0xe/0x14 [scsi_mod]
 [__crc_pci_find_class+1667885/3005906] driver_template+0x0/0x80 [sym53c8xx]
 [<c88f3660>] driver_template+0x0/0x80 [sym53c8xx]
 [__crc_pci_find_class+1528409/3005906] scsi_remove_legacy_host+0x0/0x24 [scsi_mod]
 [<c88d158c>] scsi_remove_legacy_host+0x0/0x24 [scsi_mod]
 [__crc_pci_find_class+1637399/3005906] +0xa/0x20 [sym53c8xx]
 [<c88ebf4a>] +0xa/0x20 [sym53c8xx]
 [__crc_pci_find_class+1667885/3005906] driver_template+0x0/0x80 [sym53c8xx]
 [<c88f3660>] driver_template+0x0/0x80 [sym53c8xx]
 [sys_delete_module+416/452] sys_delete_module+0x1a0/0x1c4
 [<c01245c8>] sys_delete_module+0x1a0/0x1c4
 [do_IRQ+252/276] do_IRQ+0xfc/0x114
 [<c010a1a0>] do_IRQ+0xfc/0x114
 [syscall_call+7/11] syscall_call+0x7/0xb
 [<c0108b47>] syscall_call+0x7/0xb

Code:  Bad EIP value.
