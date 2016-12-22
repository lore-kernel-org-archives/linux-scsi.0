From: Dave Chinner <david@fromorbit.com>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at
 iscsi_tcp_segment_done+0x20d/0x2e0
Date: Thu, 22 Dec 2016 16:13:22 +1100
Message-ID: <20161222051322.GF4758@dastard>
References: <20161214222411.GH4326@dastard>
 <20161214222953.GI4326@dastard>
 <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org>
 <20161221221638.GD4758@dastard>
 <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com>
 <20161222001303.nvrtm22szn3hgxar@straylight.hirudinean.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:33066 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753977AbcLVFN2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 00:13:28 -0500
Content-Disposition: inline
In-Reply-To: <20161222001303.nvrtm22szn3hgxar@straylight.hirudinean.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Leech <cleech@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Dec 21, 2016 at 04:13:03PM -0800, Chris Leech wrote:
> On Wed, Dec 21, 2016 at 03:19:15PM -0800, Linus Torvalds wrote:
> > Hi,
> > 
> > On Wed, Dec 21, 2016 at 2:16 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > On Fri, Dec 16, 2016 at 10:59:06AM -0800, Chris Leech wrote:
> > >> Thanks Dave,
> > >>
> > >> I'm hitting a bug at scatterlist.h:140 before I even get any iSCSI
> > >> modules loaded (virtio block) so there's something else going on in the
> > >> current merge window.  I'll keep an eye on it and make sure there's
> > >> nothing iSCSI needs fixing for.
> > >
> > > OK, so before this slips through the cracks.....
> > >
> > > Linus - your tree as of a few minutes ago still panics immediately
> > > when starting xfstests on iscsi devices. It appears to be a
> > > scatterlist corruption and not an iscsi problem, so the iscsi guys
> > > seem to have bounced it and no-one is looking at it.
> > 
> > Hmm. There's not much to go by.
> > 
> > Can somebody in iscsi-land please try to just bisect it - I'm not
> > seeing a lot of clues to where this comes from otherwise.
> 
> Yeah, my hopes of this being quickly resolved by someone else didn't
> work out and whatever is going on in that test VM is looking like a
> different kind of odd.  I'm saving that off for later, and seeing if I
> can't be a bisect on the iSCSI issue.

There may be deeper issues. I just started running scalability tests
(e.g. 16-way fsmark create tests) and about a minute in I got a
directory corruption reported - something I hadn't seen in the dev
cycle at all. I unmounted the fs, mkfs'd it again, ran the
workload again and about a minute in this fired:

[628867.607417] ------------[ cut here ]------------
[628867.608603] WARNING: CPU: 2 PID: 16925 at mm/workingset.c:461 shadow_lru_isolate+0x171/0x220
[628867.610702] Modules linked in:
[628867.611375] CPU: 2 PID: 16925 Comm: kworker/2:97 Tainted: G        W       4.9.0-dgc #18
[628867.613382] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
[628867.616179] Workqueue: events rht_deferred_worker
[628867.632422] Call Trace:
[628867.634691]  dump_stack+0x63/0x83
[628867.637937]  __warn+0xcb/0xf0
[628867.641359]  warn_slowpath_null+0x1d/0x20
[628867.643362]  shadow_lru_isolate+0x171/0x220
[628867.644627]  __list_lru_walk_one.isra.11+0x79/0x110
[628867.645780]  ? __list_lru_init+0x70/0x70
[628867.646628]  list_lru_walk_one+0x17/0x20
[628867.647488]  scan_shadow_nodes+0x34/0x50
[628867.648358]  shrink_slab.part.65.constprop.86+0x1dc/0x410
[628867.649506]  shrink_node+0x57/0x90
[628867.650233]  do_try_to_free_pages+0xdd/0x230
[628867.651157]  try_to_free_pages+0xce/0x1a0
[628867.652342]  __alloc_pages_slowpath+0x2df/0x960
[628867.653332]  ? __might_sleep+0x4a/0x80
[628867.654148]  __alloc_pages_nodemask+0x24b/0x290
[628867.655237]  kmalloc_order+0x21/0x50
[628867.656016]  kmalloc_order_trace+0x24/0xc0
[628867.656878]  __kmalloc+0x17d/0x1d0
[628867.657644]  bucket_table_alloc+0x195/0x1d0
[628867.658564]  ? __might_sleep+0x4a/0x80
[628867.659449]  rht_deferred_worker+0x287/0x3c0
[628867.660366]  ? _raw_spin_unlock_irq+0xe/0x30
[628867.661294]  process_one_work+0x1de/0x4d0
[628867.662208]  worker_thread+0x4b/0x4f0
[628867.662990]  kthread+0x10c/0x140
[628867.663687]  ? process_one_work+0x4d0/0x4d0
[628867.664564]  ? kthread_create_on_node+0x40/0x40
[628867.665523]  ret_from_fork+0x25/0x30
[628867.666317] ---[ end trace 7c38634006a9955e ]---

Now, this workload does not touch the page cache at all - it's
entirely an XFS metadata workload, so it should not really be
affecting the working set code.

And worse, on that last error, the /host/ is now going into meltdown
(running 4.7.5) with 32 CPUs all burning down in ACPI code:

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
35074 root      -2   0       0      0      0 R  99.0  0.0  12:38.92 acpi_pad/12
35079 root      -2   0       0      0      0 R  99.0  0.0  12:39.40 acpi_pad/16
35080 root      -2   0       0      0      0 R  99.0  0.0  12:39.29 acpi_pad/17
35085 root      -2   0       0      0      0 R  99.0  0.0  12:39.35 acpi_pad/22
35087 root      -2   0       0      0      0 R  99.0  0.0  12:39.13 acpi_pad/24
35090 root      -2   0       0      0      0 R  99.0  0.0  12:38.89 acpi_pad/27
35093 root      -2   0       0      0      0 R  99.0  0.0  12:38.88 acpi_pad/30
35063 root      -2   0       0      0      0 R  98.1  0.0  12:40.64 acpi_pad/1
35065 root      -2   0       0      0      0 R  98.1  0.0  12:40.38 acpi_pad/3
35066 root      -2   0       0      0      0 R  98.1  0.0  12:40.30 acpi_pad/4
35067 root      -2   0       0      0      0 R  98.1  0.0  12:40.82 acpi_pad/5
35077 root      -2   0       0      0      0 R  98.1  0.0  12:39.65 acpi_pad/14
35078 root      -2   0       0      0      0 R  98.1  0.0  12:39.58 acpi_pad/15
35081 root      -2   0       0      0      0 R  98.1  0.0  12:39.32 acpi_pad/18
35072 root      -2   0       0      0      0 R  96.2  0.0  12:40.14 acpi_pad/10
35073 root      -2   0       0      0      0 R  96.2  0.0  12:39.39 acpi_pad/11
35076 root      -2   0       0      0      0 R  96.2  0.0  12:39.39 acpi_pad/13
35084 root      -2   0       0      0      0 R  96.2  0.0  12:39.06 acpi_pad/21
35092 root      -2   0       0      0      0 R  96.2  0.0  12:39.14 acpi_pad/29
35069 root      -2   0       0      0      0 R  95.2  0.0  12:40.71 acpi_pad/7
35068 root      -2   0       0      0      0 R  94.2  0.0  12:40.29 acpi_pad/6
35062 root      -2   0       0      0      0 D  93.3  0.0  12:40.56 acpi_pad/0
35064 root      -2   0       0      0      0 D  92.3  0.0  12:40.18 acpi_pad/2
35082 root      -2   0       0      0      0 R  92.3  0.0  12:39.64 acpi_pad/19
35083 root      -2   0       0      0      0 R  92.3  0.0  12:38.98 acpi_pad/20
35086 root      -2   0       0      0      0 R  92.3  0.0  12:40.11 acpi_pad/23
35088 root      -2   0       0      0      0 R  92.3  0.0  12:39.45 acpi_pad/25
35089 root      -2   0       0      0      0 R  92.3  0.0  12:39.11 acpi_pad/26
35070 root      -2   0       0      0      0 D  91.3  0.0  12:40.21 acpi_pad/8
35071 root      -2   0       0      0      0 D  91.3  0.0  12:39.98 acpi_pad/9
35091 root      -2   0       0      0      0 D  91.3  0.0  12:39.33 acpi_pad/28

perf top says:

  65.98%  [kernel]  [k] power_saving_thread
   3.27%  [kernel]  [k] native_queued_spin_lock_slowpath
   1.61%  [kernel]  [k] native_write_msr
   1.39%  [kernel]  [k] update_curr_rt
   1.20%  [kernel]  [k] intel_pstate_update_util
   1.01%  [kernel]  [k] __do_softirq
   1.01%  [kernel]  [k] ktime_get
   0.99%  [kernel]  [k] ktime_get_update_offsets_now
   0.93%  [kernel]  [k] rcu_check_callbacks
   0.90%  [kernel]  [k] _raw_spin_lock
   0.88%  [kernel]  [k] perf_event_task_tick
   0.82%  [kernel]  [k] native_irq_return_iret
   0.81%  [kernel]  [k] run_timer_softirq
   0.75%  [kernel]  [k] trigger_load_balance

No idea how to recover this, so I'm just going to reboot it. Back in
a bit.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
