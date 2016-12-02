From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: scsi: use-after-free in bio_copy_from_iter
Date: Fri, 2 Dec 2016 17:50:39 +0100
Message-ID: <CACT4Y+auCpJbXhmxbr4OmSHbiVkatyWmDxGGShs=WvO=HCXRKA@mail.gmail.com>
References: <CACT4Y+aBd+1pssnsVx2x145n7Q1nDMU=xc7NAiOCtpy-MA-EDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+aBd+1pssnsVx2x145n7Q1nDMU=xc7NAiOCtpy-MA-EDg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, axboe@kernel.dk, linux-block@vger.kernel.org, David Rientjes <rientjes@google.com>
Cc: syzkaller <syzkaller@googlegroups.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 25, 2016 at 8:08 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
> Hello,
>
> The following program triggers use-after-free in bio_copy_from_iter:
> https://gist.githubusercontent.com/dvyukov/80cd94b4e4c288f16ee4c787d404118b/raw/10536069562444da51b758bb39655b514ff93b45/gistfile1.txt
>
>
> ==================================================================
> BUG: KASAN: use-after-free in copy_from_iter+0xf30/0x15e0 at addr
> ffff880062c6e02a
> Read of size 4096 by task a.out/8529
> page:ffffea00018b1b80 count:2 mapcount:0 mapping:ffff88006c80e9d0 index:0x1695
> flags: 0x5fffc0000000864(referenced|lru|active|private)
> page dumped because: kasan: bad access detected
> page->mem_cgroup:ffff88003ebcea00
> CPU: 1 PID: 8529 Comm: a.out Not tainted 4.9.0-rc6+ #55
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
>  ffff880039ca6770 ffffffff834c3bb9 ffffffff00000001 1ffff10007394c81
>  ffffed0007394c79 0000000041b58ab3 ffffffff89575c30 ffffffff834c38cb
>  0000000000000000 0000000000000000 0000000000000001 0000000000000000
> Call Trace:
>  [<     inline     >] __dump_stack lib/dump_stack.c:15
>  [<ffffffff834c3bb9>] dump_stack+0x2ee/0x3f5 lib/dump_stack.c:51
>  [<     inline     >] print_address_description mm/kasan/report.c:211
>  [<     inline     >] kasan_report_error mm/kasan/report.c:285
>  [<ffffffff819f18b8>] kasan_report+0x418/0x440 mm/kasan/report.c:305
>  [<     inline     >] check_memory_region_inline mm/kasan/kasan.c:308
>  [<ffffffff819f0509>] check_memory_region+0x139/0x190 mm/kasan/kasan.c:315
>  [<ffffffff819f0a43>] memcpy+0x23/0x50 mm/kasan/kasan.c:350
>  [<ffffffff83525d10>] copy_from_iter+0xf30/0x15e0 lib/iov_iter.c:559
>  [<ffffffff83526834>] copy_page_from_iter+0x474/0x860 lib/iov_iter.c:614
>  [<     inline     >] bio_copy_from_iter block/bio.c:1025
>  [<ffffffff833dfc10>] bio_copy_user_iov+0xb50/0xf10 block/bio.c:1226
>  [<     inline     >] __blk_rq_map_user_iov block/blk-map.c:56
>  [<ffffffff83421c15>] blk_rq_map_user_iov+0x295/0x930 block/blk-map.c:130
>  [<ffffffff834223e9>] blk_rq_map_user+0x139/0x1e0 block/blk-map.c:159
>  [<     inline     >] sg_start_req drivers/scsi/sg.c:1757
>  [<ffffffff8470269a>] sg_common_write.isra.20+0x12da/0x1b20
> drivers/scsi/sg.c:772
>  [<ffffffff8470774a>] sg_write+0x78a/0xda0 drivers/scsi/sg.c:675
>  [<ffffffff81a6fabe>] __vfs_write+0x65e/0x830 fs/read_write.c:510
>  [<ffffffff81a6fd7c>] __kernel_write+0xec/0x340 fs/read_write.c:532
>  [<ffffffff81b41e7c>] write_pipe_buf+0x19c/0x260 fs/splice.c:814
>  [<     inline     >] splice_from_pipe_feed fs/splice.c:519
>  [<ffffffff81b426af>] __splice_from_pipe+0x31f/0x750 fs/splice.c:643
>  [<ffffffff81b45dcc>] splice_from_pipe+0x1dc/0x300 fs/splice.c:678
>  [<ffffffff81b45f95>] default_file_splice_write+0x45/0x90 fs/splice.c:826
>  [<     inline     >] do_splice_from fs/splice.c:868
>  [<ffffffff81b3e2ba>] direct_splice_actor+0x12a/0x190 fs/splice.c:1035
>  [<ffffffff81b40706>] splice_direct_to_actor+0x2c6/0x840 fs/splice.c:990
>  [<ffffffff81b40f4e>] do_splice_direct+0x2ce/0x470 fs/splice.c:1078
>  [<ffffffff81a7459f>] do_sendfile+0x73f/0x1060 fs/read_write.c:1401
>  [<     inline     >] SYSC_sendfile64 fs/read_write.c:1456
>  [<ffffffff81a7677e>] SyS_sendfile64+0xee/0x1a0 fs/read_write.c:1448
>  [<ffffffff8814cf85>] entry_SYSCALL_64_fastpath+0x23/0xc6
> arch/x86/entry/entry_64.S:209
> Memory state around the buggy address:
>  ffff880062c6ef00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff880062c6ef80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>ffff880062c6f000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>                    ^
>  ffff880062c6f080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff880062c6f100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ==================================================================
> Disabling lock debugging due to kernel taint
> BUG: unable to handle kernel paging request at ffff880062c6f000
> IP: [<ffffffff835051c2>] __memcpy+0x12/0x20 arch/x86/lib/memcpy_64.S:37
> PGD c53d067 [  494.351750] PUD c540067
> PMD 7fdea067 [  494.351750] PTE 8000000062c6f060
>
> Oops: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN
> Modules linked in:
> CPU: 1 PID: 8529 Comm: a.out Tainted: G    B           4.9.0-rc6+ #55
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> task: ffff88003c54e3c0 task.stack: ffff880039ca0000
> RIP: 0010:[<ffffffff835051c2>]  [<ffffffff835051c2>]
> __memcpy+0x12/0x20 arch/x86/lib/memcpy_64.S:37
> RSP: 0018:ffff880039ca6838  EFLAGS: 00010246
> RAX: ffff880031b99000 RBX: 0000000000001000 RCX: 0000000000000006
> RDX: 0000000000000000 RSI: ffff880062c6effa RDI: ffff880031b99fd0
> RBP: ffff880039ca6858 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000200 R11: ffffed00063733ff R12: ffff880031b99000
> R13: ffff880062c6e02a R14: ffff880039ca6f70 R15: ffff880039ca6d18
> FS:  00007f7a78013700(0000) GS:ffff88003ed00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff880062c6f000 CR3: 000000006411f000 CR4: 00000000000006e0
> Stack:
>  ffffffff819f0a65 ffff880039ca71a0 0000000000001000 0000000000002000
>  ffff880039ca6d40 ffffffff83525d10 0000000041b58ab3 ffffffff89576240
>  ffffffff00000001 0000000000000000 0000000041b58ab3 ffffffff894d07b0
> Call Trace:
>  [<ffffffff83525d10>] copy_from_iter+0xf30/0x15e0 lib/iov_iter.c:559
>  [<ffffffff83526834>] copy_page_from_iter+0x474/0x860 lib/iov_iter.c:614
>  [<     inline     >] bio_copy_from_iter block/bio.c:1025
>  [<ffffffff833dfc10>] bio_copy_user_iov+0xb50/0xf10 block/bio.c:1226
>  [<     inline     >] __blk_rq_map_user_iov block/blk-map.c:56
>  [<ffffffff83421c15>] blk_rq_map_user_iov+0x295/0x930 block/blk-map.c:130
>  [<ffffffff834223e9>] blk_rq_map_user+0x139/0x1e0 block/blk-map.c:159
>  [<     inline     >] sg_start_req drivers/scsi/sg.c:1757
>  [<ffffffff8470269a>] sg_common_write.isra.20+0x12da/0x1b20
> drivers/scsi/sg.c:772
>  [<ffffffff8470774a>] sg_write+0x78a/0xda0 drivers/scsi/sg.c:675
>  [<ffffffff81a6fabe>] __vfs_write+0x65e/0x830 fs/read_write.c:510
>  [<ffffffff81a6fd7c>] __kernel_write+0xec/0x340 fs/read_write.c:532
>  [<ffffffff81b41e7c>] write_pipe_buf+0x19c/0x260 fs/splice.c:814
>  [<     inline     >] splice_from_pipe_feed fs/splice.c:519
>  [<ffffffff81b426af>] __splice_from_pipe+0x31f/0x750 fs/splice.c:643
>  [<ffffffff81b45dcc>] splice_from_pipe+0x1dc/0x300 fs/splice.c:678
>  [<ffffffff81b45f95>] default_file_splice_write+0x45/0x90 fs/splice.c:826
>  [<     inline     >] do_splice_from fs/splice.c:868
>  [<ffffffff81b3e2ba>] direct_splice_actor+0x12a/0x190 fs/splice.c:1035
>  [<ffffffff81b40706>] splice_direct_to_actor+0x2c6/0x840 fs/splice.c:990
>  [<ffffffff81b40f4e>] do_splice_direct+0x2ce/0x470 fs/splice.c:1078
>  [<ffffffff81a7459f>] do_sendfile+0x73f/0x1060 fs/read_write.c:1401
>  [<     inline     >] SYSC_sendfile64 fs/read_write.c:1456
>  [<ffffffff81a7677e>] SyS_sendfile64+0xee/0x1a0 fs/read_write.c:1448
>  [<ffffffff8814cf85>] entry_SYSCALL_64_fastpath+0x23/0xc6
> arch/x86/entry/entry_64.S:209
> Code: 4e fe e9 4d ff ff ff e8 9d c7 4e fe eb 8f e8 96 c7 4e fe e9 66
> ff ff ff 90 0f 1f 44 00 00 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 <f3>
> 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 f3
> RIP  [<ffffffff835051c2>] __memcpy+0x12/0x20 arch/x86/lib/memcpy_64.S:37
>  RSP <ffff880039ca6838>
> CR2: ffff880062c6f000
> ---[ end trace 13b61a6864c2c008 ]---
> ==================================================================
>
>
> There are no alloc/free stacks in the report, so maybe it is not
> use-after-free but rather an out-of-bounds.
>
> On commit 16ae16c6e5616c084168740990fc508bda6655d4 (Nov 24).


+David did some debugging of a similar case. His 0x400 at location
0x2000efdc refers to 0xffff at 0x20012fdc in the provided reproducer:
    NONFAILING(*(uint32_t*)0x20012fdc = (uint32_t)0xffff);
Here is his explanation:
=====
That's not nice, it's passing a reply_len mismatch of 0x400 which is going
to cause an sg_write warning (in 988 bytes, out 38 bytes).  input_size
will be 74 since count == 80, the mxsize is 0x400 (!) so after subtracting
SZ_SG_HEADER we get the 988 bytes in.  This forces SG_DXFER_TO_FROM_DEV
when we really want SG_DXFER_TO_DEV.  If you set the value at 0x2000efdc
to 0x24 rather than 0x400 so there's a legitimate reply_len equal to
SG_DXFER_TO_FROM_DEV, I'd assume this passes just fine, assuming your
container can get enough memory.
=====

I've tried to replace 0xffff in the provided reproducer with 0x24 and
it indeed does not crash.
