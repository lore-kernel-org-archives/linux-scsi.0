From: Dave Chinner <david@fromorbit.com>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at
 iscsi_tcp_segment_done+0x20d/0x2e0
Date: Thu, 22 Dec 2016 17:28:58 +1100
Message-ID: <20161222062858.GG4758@dastard>
References: <20161214222411.GH4326@dastard>
 <20161214222953.GI4326@dastard>
 <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org>
 <20161221221638.GD4758@dastard>
 <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com>
 <20161222001303.nvrtm22szn3hgxar@straylight.hirudinean.org>
 <20161222051322.GF4758@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161222051322.GF4758@dastard>
Sender: linux-block-owner@vger.kernel.org
To: Chris Leech <cleech@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 22, 2016 at 04:13:22PM +1100, Dave Chinner wrote:
> On Wed, Dec 21, 2016 at 04:13:03PM -0800, Chris Leech wrote:
> > On Wed, Dec 21, 2016 at 03:19:15PM -0800, Linus Torvalds wrote:
> > > Hi,
> > > 
> > > On Wed, Dec 21, 2016 at 2:16 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > > On Fri, Dec 16, 2016 at 10:59:06AM -0800, Chris Leech wrote:
> > > >> Thanks Dave,
> > > >>
> > > >> I'm hitting a bug at scatterlist.h:140 before I even get any iSCSI
> > > >> modules loaded (virtio block) so there's something else going on in the
> > > >> current merge window.  I'll keep an eye on it and make sure there's
> > > >> nothing iSCSI needs fixing for.
> > > >
> > > > OK, so before this slips through the cracks.....
> > > >
> > > > Linus - your tree as of a few minutes ago still panics immediately
> > > > when starting xfstests on iscsi devices. It appears to be a
> > > > scatterlist corruption and not an iscsi problem, so the iscsi guys
> > > > seem to have bounced it and no-one is looking at it.
> > > 
> > > Hmm. There's not much to go by.
> > > 
> > > Can somebody in iscsi-land please try to just bisect it - I'm not
> > > seeing a lot of clues to where this comes from otherwise.
> > 
> > Yeah, my hopes of this being quickly resolved by someone else didn't
> > work out and whatever is going on in that test VM is looking like a
> > different kind of odd.  I'm saving that off for later, and seeing if I
> > can't be a bisect on the iSCSI issue.
> 
> There may be deeper issues. I just started running scalability tests
> (e.g. 16-way fsmark create tests) and about a minute in I got a
> directory corruption reported - something I hadn't seen in the dev
> cycle at all. I unmounted the fs, mkfs'd it again, ran the
> workload again and about a minute in this fired:
> 
> [628867.607417] ------------[ cut here ]------------
> [628867.608603] WARNING: CPU: 2 PID: 16925 at mm/workingset.c:461 shadow_lru_isolate+0x171/0x220
> [628867.610702] Modules linked in:
> [628867.611375] CPU: 2 PID: 16925 Comm: kworker/2:97 Tainted: G        W       4.9.0-dgc #18
> [628867.613382] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
> [628867.616179] Workqueue: events rht_deferred_worker
> [628867.632422] Call Trace:
> [628867.634691]  dump_stack+0x63/0x83
> [628867.637937]  __warn+0xcb/0xf0
> [628867.641359]  warn_slowpath_null+0x1d/0x20
> [628867.643362]  shadow_lru_isolate+0x171/0x220
> [628867.644627]  __list_lru_walk_one.isra.11+0x79/0x110
> [628867.645780]  ? __list_lru_init+0x70/0x70
> [628867.646628]  list_lru_walk_one+0x17/0x20
> [628867.647488]  scan_shadow_nodes+0x34/0x50
> [628867.648358]  shrink_slab.part.65.constprop.86+0x1dc/0x410
> [628867.649506]  shrink_node+0x57/0x90
> [628867.650233]  do_try_to_free_pages+0xdd/0x230
> [628867.651157]  try_to_free_pages+0xce/0x1a0
> [628867.652342]  __alloc_pages_slowpath+0x2df/0x960
> [628867.653332]  ? __might_sleep+0x4a/0x80
> [628867.654148]  __alloc_pages_nodemask+0x24b/0x290
> [628867.655237]  kmalloc_order+0x21/0x50
> [628867.656016]  kmalloc_order_trace+0x24/0xc0
> [628867.656878]  __kmalloc+0x17d/0x1d0
> [628867.657644]  bucket_table_alloc+0x195/0x1d0
> [628867.658564]  ? __might_sleep+0x4a/0x80
> [628867.659449]  rht_deferred_worker+0x287/0x3c0
> [628867.660366]  ? _raw_spin_unlock_irq+0xe/0x30
> [628867.661294]  process_one_work+0x1de/0x4d0
> [628867.662208]  worker_thread+0x4b/0x4f0
> [628867.662990]  kthread+0x10c/0x140
> [628867.663687]  ? process_one_work+0x4d0/0x4d0
> [628867.664564]  ? kthread_create_on_node+0x40/0x40
> [628867.665523]  ret_from_fork+0x25/0x30
> [628867.666317] ---[ end trace 7c38634006a9955e ]---
> 
> Now, this workload does not touch the page cache at all - it's
> entirely an XFS metadata workload, so it should not really be
> affecting the working set code.

The system back up, and I haven't reproduced this problem yet.
However, benchmark results are way off where they should be, and at
times the performance is utterly abysmal. The XFS for-next tree
based on the 4.9 kernel shows none of these problems, so I don't
think there's an XFS problem here. Workload is the same 16-way
fsmark workload that I've been using for years as a performance
regression test.

The workload normally averages around 230k files/s - i'm seeing
and average of ~175k files/s on you current kernel. And there are
periods where performance just completely tanks:

#  ./fs_mark  -D  10000  -S0  -n  100000  -s  0  -L  32  -d  /mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d  /mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d  /mnt/scratch/6  -d  /mnt/scratch/7  -d  /mnt/scratch/8  -d  /mnt/scratch/9  -d  /mnt/scratch/10  -d  /mnt/scratch/11  -d  /mnt/scratch/12  -d  /mnt/scratch/13  -d  /mnt/scratch/14  -d  /mnt/scratch/15
#       Version 3.3, 16 thread(s) starting at Thu Dec 22 16:29:20 2016
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  Time based hash between directories across 10000 subdirectories with 180 seconds per subdirectory.
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
#       Files info: size 0 bytes, written with an IO size of 16384 bytes per write
#       App overhead is time in microseconds spent in the test not doing file writing related system calls.

FSUse%        Count         Size    Files/sec     App Overhead
     0      1600000            0     256964.5         10696017
     0      3200000            0     244151.9         12129380
     0      4800000            0     239929.1         11724413
     0      6400000            0     235646.5         11998954
     0      8000000            0     162537.3         15027053
     0      9600000            0     186597.4         17957243
.....
     0     43200000            0     184972.6         27911543
     0     44800000            0     141642.2         62862142
     0     46400000            0     137700.8         39018008
     0     48000000            0      92155.0         38277234
     0     49600000            0      57053.8         27810215
     0     51200000            0     178941.6         33321543

This sort of thing is normally indicative of a memory reclaim or
lock contention problem. Profile showed unusual spinlock contention,
but then I realised there was only one kswapd thread running.
Yup, sure enough, it's caused by a major change in memory reclaim
behaviour:

[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000083fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000bffdefff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x00000003bfffffff]
[    0.000000]   node   0: [mem 0x00000005c0000000-0x00000005ffffffff]
[    0.000000]   node   0: [mem 0x0000000800000000-0x000000083fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000083fffffff]

the numa=fake=4 CLI option is broken.

And, just to pile another one in - there's a massive xfs_repair
performance regression, too. It normally takes 4m30s to run over the
50 million inode filesystem created by fsmark. on 4.10:

        XFS_REPAIR Summary    Thu Dec 22 16:43:58 2016

Phase           Start           End             Duration
Phase 1:        12/22 16:35:36  12/22 16:35:38  2 seconds
Phase 2:        12/22 16:35:38  12/22 16:35:40  2 seconds
Phase 3:        12/22 16:35:40  12/22 16:39:00  3 minutes, 20 seconds
Phase 4:        12/22 16:39:00  12/22 16:40:40  1 minute, 40 seconds
Phase 5:        12/22 16:40:40  12/22 16:40:40  
Phase 6:        12/22 16:40:40  12/22 16:43:57  3 minutes, 17 seconds
Phase 7:        12/22 16:43:57  12/22 16:43:57  

Total run time: 8 minutes, 21 seconds

So, yeah, there's lots of bad stuff I'm tripping over right now.
This is all now somebody els's problem to deal with - by this time
tomorrow I'm outta here and won't be back for several months....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
