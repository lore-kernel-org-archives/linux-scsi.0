From: Andrew Morton <akpm@digeo.com>
Subject: possible use-after-free in 2.5.44 scsi changes
Date: Thu, 24 Oct 2002 18:39:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DB8A0CC.1804DF79@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id SAA27699
	for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2002 18:39:26 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Jens Axboe <axboe@suse.de>, Doug Ledford <dledford@redhat.com>


Gents,

we have some code in the -mm patchsets which adds a per-cpu
LIFO pool which frontends the page allocator.  To return pages
which are cache-warm on the calling CPU.

That code has been stable and unchanging since 2.5.40.  But in
2.5.44, Badari's machines are crashing when those patches are
applied.  Memory corruption deep in the scsi softirq callbacks.

There were no significant memory allocator changes between 2.5.43
and 2.5.44, but there were a lot of scsi changes.

These LIFO pools have a significant sideeffect: is a CPU frees
a page and then allocates a page it will get the same page back.
So if some code is using some memory for a few microseconds after
freeing it, there's a good chance that this bug will not exhibit
with the stock kernel's allocator but _will_ exhibit when the
per-cpu LIFO queues are present.

I'm suspecting that this is what is happening.  A use-after-free
bug may have been introduced in the 2.5.44 SCSI changes.

Here are some of Badari's oops traces.  Jens has commented:

> Seems to me, that blk_rq_map_sg() is being passed q == NULL, which means
> that scsi_init_io() has a request that has req->q == NULL. Badari,
> please do something like the following in
> drivers/scsi/scsi_merge.c:scsi_init_io():
> 
>         req->buffer = NULL;
> +
> +       if (!req->q) {
> +               blk_dump_rq_flags(req, "scsi_init_io");
> +               BUG();
> +       }
> +
>         /*
>          * Next, walk the list, and fill in the addresses and sizes of
> 
> right before calling blk_rq_map_sg(). And then make blk_dump_rq_flags()
> like the one I attach, just replace the one in ll_rw_blk.c

But I don't think Badari has got onto that yet.

In a word: Help!

Thanks.

CPU:    2
EIP:    0060:[<f89d0cd7>]    Not tainted
EFLAGS: 00010002
EIP is at qla2x00_process_completed_request+0x67/0x150 [qla2200]
eax: 00000000   ebx: f663646c   ecx: 00000000   edx: 00000000
esi: f661c17c   edi: 00000000   ebp: f70f3d7b   esp: f70f3cfc
ds: 0068   es: 0068   ss: 0068
Process syslogd (pid: 542, threadinfo=f70f2000 task=f70d1060)
Stack: f661c17c 0000711a 00007100 f89d0efb f661c17c 000000cc 00008020 c013a348 
       00008020 00007100 00ccaaa4 00000000 c0139641 c03c1e89 f7fff060 f7298c90 
       00000246 c013a348 00000001 000000d0 0000005c c03c4294 f661c17c f661c17c 
Call Trace:
 [<f89d0efb>] qla2x00_isr+0x13b/0x610 [qla2200]
 [<c013a348>] kmalloc+0xb8/0x150
 [<c0139641>] kmem_flagcheck+0x21/0x60
 [<c013a348>] kmalloc+0xb8/0x150
 [<f89cc17b>] qla2x00_intr_handler+0x9b/0x250 [qla2200]
 [<c01094ea>] handle_IRQ_event+0x3a/0x60
 [<c0109802>] do_IRQ+0x122/0x200
 [<c0107f38>] common_interrupt+0x18/0x20
 [<c0130068>] unmap_page_range+0x8/0x60
 [<c01359c1>] generic_file_write_nolock+0x6a1/0xa00
 [<c01924ec>] journal_stop+0x19c/0x1b0
 [<c0354531>] sys_recvfrom+0xa1/0x100
 [<c035457c>] sys_recvfrom+0xec/0x100
 [<c013e526>] __get_free_pages+0x36/0x40
 [<c015d673>] __pollwait+0x33/0xa0



EIP:    0060:[<f89d0ac8>]    Not tainted
EFLAGS: 00010002
EIP is at qla2x00_process_completed_request+0x68/0x150 [qla2200]
eax: 00000000   ebx: f6599574   ecx: 00000000   edx: 00000000
esi: f65f017c   edi: 00000000   ebp: f65f9d0c   esp: f65f9d00
ds: 0068   es: 0068   ss: 0068
Process dd (pid: 1594, threadinfo=f65f8000 task=e26350c0)
Stack: f65f017c 0000711a 00007100 f65f9d6c f89d0ceb f65f017c 00000114 00008020 
       f65f9d60 00008020 f61e34c4 00007100 0114c160 00000000 c0134fe7 f61e34c8 
       0000c160 0000c160 f65f9d68 c014fbe4 f61e34c4 0000c160 00000000 00000008 
Call Trace:
 [<f89d0ceb>] qla2x00_isr+0x13b/0x610 [qla2200]
 [<c0134fe7>] find_get_page+0x37/0x50
 [<c014fbe4>] __find_get_block_slow+0x34/0x120
 [<f89cbffe>] qla2x00_intr_handler+0x9e/0x250 [qla2200]
 [<c01095fd>] handle_IRQ_event+0x2d/0x60
 [<c0109924>] do_IRQ+0x124/0x200




elm3b81 login: Oops: 0000
qla2200  
CPU:    2
EIP:    0060:[<c0287d88>]    Not tainted
EFLAGS: 00010292
EIP is at blk_rq_map_sg+0x18/0x1f0
eax: 00000000   ebx: df3d6800   ecx: f631c270   edx: df3d6800
esi: f631c270   edi: 00000000   ebp: c6149c80   esp: c6149c38
ds: 0068   es: 0068   ss: 0068
Process dd (pid: 1590, threadinfo=c6148000 task=dfcba0c0)
Stack: 00000000 dfcba0c0 c0119c50 c6149c44 c6149c44 c6149c60 c01521c4 f0dfeba4 
       00000000 f7edc464 00000010 c6149c84 00000000 f7edc464 00000020 df3d6800 
       f631c270 00000000 c6149ca0 c02c5f41 00000000 f631c270 f6fb85a4 df3d6800 
Call Trace:
 [<c0119c50>] autoremove_wake_function+0x0/0x40
 [<c01521c4>] bio_destructor+0x44/0x50
 [<c02c5f41>] scsi_init_io+0xb1/0x130
 [<c02c5bdd>] scsi_request_fn+0x2ad/0x480
 [<c02c526e>] scsi_queue_next_request+0x7e/0x1b0
 [<c02c549f>] __scsi_end_request+0xff/0x110
 [<c02c569d>] scsi_io_completion+0x15d/0x3a0
 [<f89cce4f>] qla2x00_done+0x2bf/0x2f0 [qla2200]
 [<c02e0d2f>] sd_rw_intr+0x16f/0x180
 [<c02bf746>] scsi_finish_command+0x96/0xa0
 [<c02bf606>] scsi_softirq+0x86/0x100
 [<c012211b>] do_softirq+0x6b/0xd0
 [<c01099e2>] do_IRQ+0x1e2/0x200
 [<c0107fd8>] common_interrupt+0x18/0x20
 [<c020e28c>] __copy_from_user+0x4c/0x70
 [<c01364e7>] generic_file_write_nolock+0x817/0xb70
 [<c02c526e>] scsi_queue_next_request+0x7e/0x1b0
 [<c0130343>] pte_alloc_map+0x133/0x140
 [<c0131352>] zeromap_page_range+0xe2/0x180
 [<c025a6b1>] read_zero+0x1c1/0x1f0
 [<c01368b6>] generic_file_write+0x56/0x70
 [<c014d2ae>] vfs_write+0xbe/0x160
 [<c01174ca>] do_schedule+0x38a/0x480
 [<c014d3ba>] sys_write+0x2a/0x40



elm3b81 login: Oops: 0002
qla2200  
CPU:    2
EIP:    0060:[<f89d0ac8>]    Not tainted
EFLAGS: 00010002
EIP is at qla2x00_process_completed_request+0x68/0x150 [qla2200]
eax: 00000000   ebx: f6791c7c   ecx: 00000000   edx: 00000000
esi: f678c17c   edi: 00000000   ebp: dfe53d0c   esp: dfe53d00
ds: 0068   es: 0068   ss: 0068
Process dd (pid: 1623, threadinfo=dfe52000 task=c390d140)
Stack: f678c17c 0000421a 00004200 dfe53d6c f89d0ceb f678c17c 000000c6 00008020 
       dfe53d60 00008020 f6265254 00004200 00c6f17c 00000000 c01347a7 f6265258 
       0000f17c 0000f17c dfe53d68 c014f164 f6265254 0000f17c 00000000 00000008 
Call Trace:
 [<f89d0ceb>] qla2x00_isr+0x13b/0x610 [qla2200]
 [<c01347a7>] find_get_page+0x37/0x50
 [<c014f164>] __find_get_block_slow+0x34/0x120
 [<f89cbffe>] qla2x00_intr_handler+0x9e/0x250 [qla2200]
 [<c01095fd>] handle_IRQ_event+0x2d/0x60
 [<c0109924>] do_IRQ+0x124/0x200
 [<c0107fd8>] common_interrupt+0x18/0x20
 [<c020bcdc>] __copy_from_user+0x4c/0x70
 [<c01364f7>] generic_file_write_nolock+0x817/0xb70
 [<c0125cb6>] update_wall_time+0x16/0x50
 [<c0130313>] pte_alloc_map+0x133/0x140
 [<c0131322>] zeromap_page_range+0xe2/0x180
 [<c0258101>] read_zero+0x1c1/0x1f0
 [<c01368c6>] generic_file_write+0x56/0x70
 [<c014d2ce>] vfs_write+0xbe/0x160
 [<c01174ca>] do_schedule+0x38a/0x480
 [<c014d3da>] sys_write+0x2a/0x40
 [<c0107693>] syscall_call+0x7/0xb


 kEerIPn:el    NU L0L06 0p:o[in<tce0r2 8d6e81r9e>f]e r e n cNeot< 4t> aaitn tveidr
tuEaFlL AadGdSr: es0s0 00100029002
b0                                0
IP  prisin taitn gb lkei_prq:_
acp0_2s8g+608x1199            m
0*xp2d10e         /
= 0e0a0x0: 00000000
000   ebx: de731800   ecx: f67290c4   edx: de731800
esi: f67290c4   edi: 00000000   ebp: cc879ebc   esp: cc879e38
ds: 0068   es: 0068   ss: 0068
Process db2sysc (pid: 2034, threadinfo=cc878000 task=dd088820)
Stack: 00000000 dd088820 c0119850 cc879e44 cc879e44 00000001 c0151603 ce514ae4 
       cc878000 00000040 00000000 00000000 c02bdf6d f7ec4344 de731800 f67290c4 
       00000000 cc879ebc c02c390f 00000000 f67290c4 d28c9de4 de731800 00000000 
Call Trace:
 [<c0119850>] autoremove_wake_function+0x0/0x40
 [<c0151603>] bio_destructor+0x43/0x50
 [<c02bdf6d>] scsi_alloc_sgtable+0xbd/0x100
 [<c02c390f>] scsi_init_io+0xaf/0x130
 [<c02c35bd>] scsi_request_fn+0x2ad/0x480
 [<c02c2c6e>] scsi_queue_next_request+0x7e/0x1b0
 [<c02c2e9d>] __scsi_end_request+0xfd/0x110
 [<c02c3099>] scsi_io_completion+0x159/0x380
 [<f89ccf9e>] qla2x00_done+0x2be/0x2f0 [qla2200]
 [<c02de38f>] sd_rw_intr+0x15f/0x170
 [<c02bd292>] scsi_finish_command+0x82/0x90
 [<c02bd166>] scsi_softirq+0x86/0x100
 [<c0121a5b>] do_softirq+0x5b/0xc0
 [<c01098c2>] do_IRQ+0x1e2/0x200
 [<c0107f38>] common_interrupt+0x18/0x20
