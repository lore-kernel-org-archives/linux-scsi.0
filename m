From: Dave Chinner <david@fromorbit.com>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at
 iscsi_tcp_segment_done+0x20d/0x2e0
Date: Thu, 22 Dec 2016 17:50:12 +1100
Message-ID: <20161222065012.GI4758@dastard>
References: <20161214222411.GH4326@dastard>
 <20161214222953.GI4326@dastard>
 <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org>
 <20161221221638.GD4758@dastard>
 <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com>
 <20161222001303.nvrtm22szn3hgxar@straylight.hirudinean.org>
 <20161222051322.GF4758@dastard>
 <CA+55aFza=cv6TGYh+Be1xz2x-G-U=vruhbmfGpHSqY1ocZrBeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFza=cv6TGYh+Be1xz2x-G-U=vruhbmfGpHSqY1ocZrBeg@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Leech <cleech@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 21, 2016 at 09:46:37PM -0800, Linus Torvalds wrote:
> On Wed, Dec 21, 2016 at 9:13 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > There may be deeper issues. I just started running scalability tests
> > (e.g. 16-way fsmark create tests) and about a minute in I got a
> > directory corruption reported - something I hadn't seen in the dev
> > cycle at all.
> 
> By "in the dev cycle", do you mean your XFS changes, or have you been
> tracking the merge cycle at least for some testing?

I mean the three months leading up to the 4.10 merge, when all the
XFS changes were being tested against 4.9-rc kernels.

The iscsi problem showed up when I updated the base kernel from
4.9 to 4.10-current last week to test the pullreq I was going to
send you. I've been bust with other stuff until now, so I didn't
upgrade my working trees again until today in the hope the iscsi
problem had already been found and fixed.

> > I unmounted the fs, mkfs'd it again, ran the
> > workload again and about a minute in this fired:
> >
> > [628867.607417] ------------[ cut here ]------------
> > [628867.608603] WARNING: CPU: 2 PID: 16925 at mm/workingset.c:461 shadow_lru_isolate+0x171/0x220
> 
> Well, part of the changes during the merge window were the shadow
> entry tracking changes that came in through Andrew's tree. Adding
> Johannes Weiner to the participants.
> 
> > Now, this workload does not touch the page cache at all - it's
> > entirely an XFS metadata workload, so it should not really be
> > affecting the working set code.
> 
> Well, I suspect that anything that creates memory pressure will end up
> triggering the working set code, so ..
> 
> That said, obviously memory corruption could be involved and result in
> random issues too, but I wouldn't really expect that in this code.
> 
> It would probably be really useful to get more data points - is the
> problem reliably in this area, or is it going to be random and all
> over the place.

The iscsi problem is 100% reproducable. create a pair of iscsi luns,
mkfs, run xfstests on them. iscsi fails a second after xfstests mounts
the filesystems.

The test machine I'm having all these other problems on? stable and
steady as a rock using PMEM devices. Moment I go to use /dev/vdc
(i.e. run load/perf benchmarks) it starts falling over left, right
and center.

And I just smacked into this in the bulkstat phase of the benchmark
(mkfs, fsmark, xfs_repair, mount, bulkstat, find, grep, rm):

[ 2729.750563] BUG: Bad page state in process bstat  pfn:14945
[ 2729.751863] page:ffffea0000525140 count:-1 mapcount:0 mapping:          (null) index:0x0
[ 2729.753763] flags: 0x4000000000000000()
[ 2729.754671] raw: 4000000000000000 0000000000000000 0000000000000000 ffffffffffffffff
[ 2729.756469] raw: dead000000000100 dead000000000200 0000000000000000 0000000000000000
[ 2729.758276] page dumped because: nonzero _refcount
[ 2729.759393] Modules linked in:
[ 2729.760137] CPU: 7 PID: 25902 Comm: bstat Tainted: G    B           4.9.0-dgc #18
[ 2729.761888] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
[ 2729.763943] Call Trace:
[ 2729.764523]  <IRQ>
[ 2729.765004]  dump_stack+0x63/0x83
[ 2729.765784]  bad_page+0xc4/0x130
[ 2729.766552]  free_pages_check_bad+0x4f/0x70
[ 2729.767531]  free_pcppages_bulk+0x3c5/0x3d0
[ 2729.768513]  ? page_alloc_cpu_dead+0x30/0x30
[ 2729.769510]  drain_pages_zone+0x41/0x60
[ 2729.770417]  drain_pages+0x3e/0x60
[ 2729.771215]  drain_local_pages+0x24/0x30
[ 2729.772138]  flush_smp_call_function_queue+0x88/0x160
[ 2729.773317]  generic_smp_call_function_single_interrupt+0x13/0x30
[ 2729.774742]  smp_call_function_single_interrupt+0x27/0x40
[ 2729.776000]  smp_call_function_interrupt+0xe/0x10
[ 2729.777102]  call_function_interrupt+0x8e/0xa0
[ 2729.778147] RIP: 0010:delay_tsc+0x41/0x90
[ 2729.779085] RSP: 0018:ffffc9000f0cf500 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff03
[ 2729.780852] RAX: 0000000077541291 RBX: ffff88008b5efe40 RCX: 000000000000002e
[ 2729.782514] RDX: 0000057700000000 RSI: 0000057777541291 RDI: 0000000000000001
[ 2729.784167] RBP: ffffc9000f0cf500 R08: 0000000000000007 R09: ffffc9000f0cf678
[ 2729.785818] R10: 0000000000000006 R11: 0000000000001000 R12: 0000000000000061
[ 2729.787480] R13: 0000000000000001 R14: 0000000083214e30 R15: 0000000000000080
[ 2729.789124]  </IRQ>
[ 2729.789626]  __delay+0xf/0x20
[ 2729.790333]  do_raw_spin_lock+0x8c/0x160
[ 2729.791255]  _raw_spin_lock+0x15/0x20
[ 2729.792112]  list_lru_add+0x1a/0x70
[ 2729.792932]  xfs_buf_rele+0x3e7/0x410
[ 2729.793792]  xfs_buftarg_shrink_scan+0x6b/0x80
[ 2729.794841]  shrink_slab.part.65.constprop.86+0x1dc/0x410
[ 2729.796099]  shrink_node+0x57/0x90
[ 2729.796905]  do_try_to_free_pages+0xdd/0x230
[ 2729.797914]  try_to_free_pages+0xce/0x1a0
[ 2729.798852]  __alloc_pages_slowpath+0x2df/0x960
[ 2729.799908]  __alloc_pages_nodemask+0x24b/0x290
[ 2729.800963]  new_slab+0x2ac/0x380
[ 2729.801743]  ___slab_alloc.constprop.82+0x336/0x440
[ 2729.802890]  ? kmem_zone_alloc+0x81/0x120
[ 2729.803830]  ? xfs_buf_read_map+0x2d/0x1a0
[ 2729.804785]  ? kmem_zone_alloc+0x81/0x120
[ 2729.805723]  __slab_alloc.isra.78.constprop.81+0x2b/0x40
[ 2729.806970]  kmem_cache_alloc+0x142/0x180
[ 2729.807905]  kmem_zone_alloc+0x81/0x120
[ 2729.808807]  xfs_inode_alloc+0x29/0x1d0
[ 2729.809707]  xfs_iget+0x3cd/0x9d0
[ 2729.810496]  ? xfs_iflush+0x350/0x350
[ 2729.811358]  xfs_bulkstat_one_int+0x87/0x370
[ 2729.812359]  xfs_bulkstat_one+0x20/0x30
[ 2729.813259]  xfs_bulkstat+0x485/0x690
[ 2729.814125]  ? xfs_bulkstat_one_int+0x370/0x370
[ 2729.815183]  xfs_ioc_bulkstat+0xfa/0x1d0
[ 2729.816105]  xfs_file_ioctl+0x8e4/0xc70
[ 2729.817006]  ? _raw_spin_unlock_irq+0xe/0x30
[ 2729.818011]  ? finish_task_switch+0xab/0x240
[ 2729.819007]  ? __schedule+0x265/0x760
[ 2729.819866]  ? _raw_spin_unlock+0xe/0x20
[ 2729.820783]  ? preempt_schedule_irq+0x59/0xb0
[ 2729.821797]  ? retint_kernel+0x1b/0x1d
[ 2729.822685]  do_vfs_ioctl+0x94/0x700
[ 2729.823523]  ? __fget+0x77/0xb0
[ 2729.824263]  SyS_ioctl+0x79/0x90
[ 2729.825022]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[ 2729.826105] RIP: 0033:0x7fd25ff088e7
[ 2729.826943] RSP: 002b:00007fcfc4757e18 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 2729.828714] RAX: ffffffffffffffda RBX: 00007fd0d4000020 RCX: 00007fd25ff088e7
[ 2729.830372] RDX: 00007fcfc4757e60 RSI: ffffffffc0205865 RDI: 0000000000000003
[ 2729.832020] RBP: 0000000000022010 R08: ffffffffffffffff R09: 0000000000000400
[ 2729.833670] R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000023000
[ 2729.835327] R13: 0000000000022010 R14: 0000000000001000 R15: 00007fd0d4000020

> That said:
> 
> > And worse, on that last error, the /host/ is now going into meltdown
> > (running 4.7.5) with 32 CPUs all burning down in ACPI code:
> 
> The obvious question here is how much you trust the environment if the
> host ends up also showing problems. Maybe you do end up having hw
> issues pop up too.

I trust the hardware way more than I trust the software running on
it....

> The primary suspect would presumably be the development kernel you're
> testing triggering something, but it has to be asked..

I've seen a couple of guest panics in RCU related code take down the
parent QEMU process recently - asserts in console handling code IIRC
- but that's the only signs I've ever had of host side problems.
That both the host and guest went whacky in new and interesting ways
at exactly the same time might be coincidence, but Occam's Razor
suggests they are linked in some way...


> 
>                      Linus
> 

-- 
Dave Chinner
david@fromorbit.com
