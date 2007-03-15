From: Andreas Steinmetz <ast@domdv.de>
Subject: 2.6.20.3: kernel BUG at mm/slab.c:597
Date: Thu, 15 Mar 2007 10:33:29 +0100
Message-ID: <45F912E9.9030506@domdv.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933296AbXCOJdj@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Got the following on executing "tar tpf /dev/st0l" on two different
systems (x86):

kernel BUG at mm/slab.c:597!
invalid opcode: 0000 [#1]
Modules linked in: sg st sym53c8xx netconsole tg3 e1000
CPU:    0
EIP:    0060:[<c014b720>]    Not tainted VLI
EFLAGS: 00010246   (2.6.20.3-luna #1)
EIP is at kmem_cache_free+0x29/0x5a
eax: c1800000   ebx: f0ae12c0   ecx: c18f73c0   edx: c1800000
esi: c1919de0   edi: 00000000   ebp: 00001000   esp: f1fe7e14
ds: 007b   es: 007b   ss: 0068
Process tar (pid: 17153, ti=f1fe6000 task=f7106a70 task.ti=f1fe6000)
Stack: f0ae12c0 c1919de0 ffffffea c0137f97 00000000 f0ae12c0 c1919e20
c0168d45
       f0ae12c0 00001000 c0168fb9 c02a77e3 00001000 00000000 00000000
00000000
       00000000 c17bb6e0 00001000 00000000 f1b38be8 00000003 f54ac050
c1b9d6e8
Call Trace:
 [<c0137f97>] mempool_free+0x48/0x4c
 [<c0168d45>] bio_free+0x21/0x2c
 [<c0168fb9>] bio_put+0x22/0x23
 [<c02a77e3>] scsi_req_map_sg+0x150/0x19b
 [<c02a78c4>] scsi_execute_async+0x96/0x175
 [<f892a53c>] st_do_scsi+0x14d/0x19f [st]
 [<f892a3a5>] st_sleep_done+0x0/0x35 [st]
 [<f892be13>] read_tape+0x11d/0x3ad [st]
 [<f892c27a>] st_read+0x1d7/0x2d6 [st]
 [<c014d773>] vfs_read+0x8a/0x12f
 [<c014da87>] sys_read+0x41/0x67
 [<c0103b60>] syscall_call+0x7/0xb
 =======================
Code: 5f c3 57 89 c1 89 d7 8d 92 00 00 00 40 56 c1 ea 0c 53 c1 e2 05 03
15 40 5d
 5a c0 8b 02 f6 c4 40 74 03 8b 52 0c 8b 02 a8 80 75 04 <0f> 0b eb fe 39
4a 18 74
 04 0f 0b eb fe 9c 5e fa 8b 19 8b 03 3b
EIP: [<c014b720>] kmem_cache_free+0x29/0x5a SS:ESP 0068:f1fe7e14
 BUG: at drivers/scsi/st.c:2516 st_int_ioctl()
 [<f892caac>] st_int_ioctl+0x64/0x999 [st]
 [<f892b468>] st_flush+0x253/0x26d [st]
 [<c015a7b6>] dput+0x22/0x112
 [<c014d1a1>] filp_close+0x32/0x54
 [<c011c610>] close_files+0x46/0x55
 [<c011c640>] put_files_struct+0x14/0x3c
 [<c011ce9c>] do_exit+0x1c6/0x314
 [<c0104ce9>] die+0x197/0x19f
 [<c0104d67>] do_trap+0x76/0xa2
 [<c0104f85>] do_invalid_op+0x0/0x99
 [<c0105015>] do_invalid_op+0x90/0x99
 [<c014b720>] kmem_cache_free+0x29/0x5a
 [<c03a201d>] wait_for_completion+0x69/0x93
 [<c01183de>] default_wake_function+0x0/0xc
 [<c0137ed3>] mempool_alloc+0x28/0xa4
 [<c020694d>] blk_alloc_request+0x3c/0x5d
 [<c03a2e44>] error_code+0x74/0x7c
 [<c014b720>] kmem_cache_free+0x29/0x5a
 [<c0137f97>] mempool_free+0x48/0x4c
 [<c0168d45>] bio_free+0x21/0x2c
 [<c0168fb9>] bio_put+0x22/0x23
 [<c02a77e3>] scsi_req_map_sg+0x150/0x19b
 [<c02a78c4>] scsi_execute_async+0x96/0x175
 [<f892a53c>] st_do_scsi+0x14d/0x19f [st]
 [<f892a3a5>] st_sleep_done+0x0/0x35 [st]
 [<f892be13>] read_tape+0x11d/0x3ad [st]
 [<f892c27a>] st_read+0x1d7/0x2d6 [st]
 [<c014d773>] vfs_read+0x8a/0x12f
 [<c014da87>] sys_read+0x41/0x67
 [<c0103b60>] syscall_call+0x7/0xb
 =======================
------------[ cut here ]------------
kernel BUG at mm/slab.c:597!
invalid opcode: 0000 [#2]
Modules linked in: sg st sym53c8xx netconsole tg3 e1000
CPU:    0
EIP:    0060:[<c014b720>]    Not tainted VLI
EFLAGS: 00010246   (2.6.20.3-luna #1)
EIP is at kmem_cache_free+0x29/0x5a
eax: c1800000   ebx: f0ae1cc0   ecx: c18f73c0   edx: c1800000
esi: c1919de0   edi: 00000000   ebp: 00001000   esp: f1fe7afc
ds: 007b   es: 007b   ss: 0068
Process tar (pid: 17153, ti=f1fe6000 task=f7106a70 task.ti=f1fe6000)
Stack: f0ae1cc0 c1919de0 ffffffea c0137f97 00000000 f0ae1cc0 c1919e20
c0168d45
       f0ae1cc0 00001000 c0168fb9 c02a77e3 00001000 00000000 00000000
00000000
       00000000 c17bb6e0 00001000 00000000 f1b38be8 00000003 f54ac050
c1b9d298
Call Trace:
 [<c0137f97>] mempool_free+0x48/0x4c
 [<c0168d45>] bio_free+0x21/0x2c
 [<c0168fb9>] bio_put+0x22/0x23
 [<c02a77e3>] scsi_req_map_sg+0x150/0x19b
 [<c02a78c4>] scsi_execute_async+0x96/0x175
 [<f892a53c>] st_do_scsi+0x14d/0x19f [st]
 [<f892a3a5>] st_sleep_done+0x0/0x35 [st]
 [<f892d083>] st_int_ioctl+0x63b/0x999 [st]
 [<f892b468>] st_flush+0x253/0x26d [st]
 [<c015a7b6>] dput+0x22/0x112
 [<c014d1a1>] filp_close+0x32/0x54
 [<c011c610>] close_files+0x46/0x55
 [<c011c640>] put_files_struct+0x14/0x3c
 [<c011ce9c>] do_exit+0x1c6/0x314
 [<c0104ce9>] die+0x197/0x19f
 [<c0104d67>] do_trap+0x76/0xa2
 [<c0104f85>] do_invalid_op+0x0/0x99
 [<c0105015>] do_invalid_op+0x90/0x99
 [<c014b720>] kmem_cache_free+0x29/0x5a
 [<c03a201d>] wait_for_completion+0x69/0x93
 [<c01183de>] default_wake_function+0x0/0xc
 [<c0137ed3>] mempool_alloc+0x28/0xa4
 [<c020694d>] blk_alloc_request+0x3c/0x5d
 [<c03a2e44>] error_code+0x74/0x7c
 [<c014b720>] kmem_cache_free+0x29/0x5a
 [<c0137f97>] mempool_free+0x48/0x4c
 [<c0168d45>] bio_free+0x21/0x2c
 [<c0168fb9>] bio_put+0x22/0x23
 [<c02a77e3>] scsi_req_map_sg+0x150/0x19b
 [<c02a78c4>] scsi_execute_async+0x96/0x175
 [<f892a53c>] st_do_scsi+0x14d/0x19f [st]
 [<f892a3a5>] st_sleep_done+0x0/0x35 [st]
 [<f892be13>] read_tape+0x11d/0x3ad [st]
 [<f892c27a>] st_read+0x1d7/0x2d6 [st]
 [<c014d773>] vfs_read+0x8a/0x12f
 [<c014da87>] sys_read+0x41/0x67
 [<c0103b60>] syscall_call+0x7/0xb
 =======================
Code: 5f c3 57 89 c1 89 d7 8d 92 00 00 00 40 56 c1 ea 0c 53 c1 e2 05 03
15 40 5d
 5a c0 8b 02 f6 c4 40 74 03 8b 52 0c 8b 02 a8 80 75 04 <0f> 0b eb fe 39
4a 18 74
 04 0f 0b eb fe 9c 5e fa 8b 19 8b 03 3b
EIP: [<c014b720>] kmem_cache_free+0x29/0x5a SS:ESP 0068:f1fe7afc
 <1>Fixing recursive fault but reboot is needed!

-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
