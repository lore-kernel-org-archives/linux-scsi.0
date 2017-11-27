From: Meelis Roos <mroos@linux.ee>
Subject: News UBSAN warnings in aacraid
Date: Mon, 27 Nov 2017 21:17:03 +0200 (EET)
Message-ID: <alpine.LRH.2.21.1711272112050.5402@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Carroll <david.carroll@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Tried 4.15-rc1 on an old 32-bit HP Netserver with aacraid card. Compared 
to 4.14, there are new UBSAN warnings with timer related backtraces, so 
the timespec64 change seems suspicious:

[   12.228058] ================================================================================
[   12.228155] UBSAN: Undefined behaviour in drivers/scsi/aacraid/commsup.c:2514:49
[   12.228229] signed integer overflow:
[   12.228283] 964297611 * 250 cannot be represented in type 'long int'
[   12.228347] CPU: 1 PID: 276 Comm: aacraid Not tainted 4.15.0-rc1 #80
[   12.228404] Hardware name: Hewlett Packard HP NetServer/HP System Board, BIOS 4.06.46 PW 06/25/2003
[   12.228477] Call Trace:
[   12.228560]  dump_stack+0x48/0x65
[   12.228620]  ubsan_epilogue+0xe/0x40
[   12.228677]  handle_overflow+0xad/0xc0
[   12.228754]  ? del_timer_sync+0x39/0x50
[   12.228818]  ? __getnstimeofday64+0x4d/0x200
[   12.228877]  __ubsan_handle_mul_overflow+0x12/0x20
[   12.229037]  aac_command_thread+0x1243/0x1290 [aacraid]
[   12.229109]  ? pick_next_task_fair+0x27f/0x760
[   12.229175]  ? __schedule+0x1b1/0x8e0
[   12.229245]  ? wake_up_q+0xa0/0xa0
[   12.229311]  kthread+0x13d/0x1f0
[   12.229390]  ? aac_send_hosttime+0xf0/0xf0 [aacraid]
[   12.229449]  ? __kthread_create_worker+0x110/0x110
[   12.229516]  ret_from_fork+0x19/0x24
[   12.229571] ================================================================================
[   12.292055] ================================================================================
[   12.292130] UBSAN: Undefined behaviour in drivers/scsi/aacraid/commsup.c:2515:7
[   12.292200] signed integer overflow:
[   12.292252] 1734571608 + 500000000 cannot be represented in type 'long int'
[   12.292312] CPU: 1 PID: 276 Comm: aacraid Not tainted 4.15.0-rc1 #80
[   12.292368] Hardware name: Hewlett Packard HP NetServer/HP System Board, BIOS 4.06.46 PW 06/25/2003
[   12.292439] Call Trace:
[   12.292494]  dump_stack+0x48/0x65
[   12.292550]  ubsan_epilogue+0xe/0x40
[   12.292606]  handle_overflow+0xad/0xc0
[   12.292665]  ? del_timer_sync+0x39/0x50
[   12.292722]  ? __getnstimeofday64+0x4d/0x200
[   12.292780]  __ubsan_handle_add_overflow+0x12/0x20
[   12.292861]  aac_command_thread+0x1259/0x1290 [aacraid]
[   12.292922]  ? pick_next_task_fair+0x27f/0x760
[   12.292980]  ? __schedule+0x1b1/0x8e0
[   12.293037]  ? wake_up_q+0xa0/0xa0
[   12.293094]  kthread+0x13d/0x1f0
[   12.293172]  ? aac_send_hosttime+0xf0/0xf0 [aacraid]
[   12.293231]  ? __kthread_create_worker+0x110/0x110
[   12.293289]  ret_from_fork+0x19/0x24
[   12.293345] ================================================================================


-- 
Meelis Roos (mroos@linux.ee)
