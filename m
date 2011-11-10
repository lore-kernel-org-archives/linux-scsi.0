From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Thu, 10 Nov 2011 17:10:09 +0100
Message-ID: <20111110161008.GA15659@osiris.boeblingen.de.ibm.com>
References: <4E9D7FA8.9000000@ce.jp.nec.com>
 <20111018154542.GB3869@osiris.boeblingen.de.ibm.com>
 <1318955380.5169.15.camel@dabdike.int.hansenpartnership.com>
 <20111031100557.GA2621@osiris.boeblingen.de.ibm.com>
 <1320057746.2964.1.camel@dabdike>
 <4EAE8A7E.8000504@ce.jp.nec.com>
 <20111031130004.GB4768@osiris.boeblingen.de.ibm.com>
 <20111103182548.GA12131@redhat.com>
 <20111104091936.GB2397@osiris.boeblingen.de.ibm.com>
 <4EBA49C2.1000704@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4EBA49C2.1000704@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>, Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>, gmuelas@de.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 09, 2011 at 10:37:06AM +0100, Hannes Reinecke wrote:
> >FWIW, yet another use-after-free crash, this time however in multipath_end_io:
> >
> >[96875.870593] Unable to handle kernel pointer dereference at virtual kernel address 6b6b6b6b6b6b6000
> >[96875.870602] Oops: 0038 [#1]
> >[96875.870674] PREEMPT SMP DEBUG_PAGEALLOC
> >[96875.870683] Modules linked in: dm_round_robin sunrpc ipv6 qeth_l2 binfmt_misc dm_multipath scsi_dh dm_mod qeth ccwgroup [la\
> >st unloaded: scsi_wait_scan]
> >[96875.870722] CPU: 2 Tainted: G        W   3.0.7-50.x.20111024-s390xdefault #1
> >[96875.870728] Process udevd (pid: 36697, task: 0000000072c8a3a8, ksp: 0000000057c43868)
> >[96875.870732] Krnl PSW : 0704200180000000 000003e001347138 (multipath_end_io+0x50/0x140 [dm_multipath])
> >[96875.870746]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
> >[96875.870751] Krnl GPRS: 0000000000000000 000003e000000000 6b6b6b6b6b6b6b6b 00000000717ab940
> >[96875.870755]            0000000000000000 00000000717abab0 0000000000000002 0700000000000008
> >[96875.870759]            0000000000000002 0000000000000000 0000000058dd37a8 000000006f845478
> >[96875.870764]            000003e0012e1000 000000005613d1f0 000000007a737bf0 000000007a737ba0
> >[96875.870768] Krnl Code: 000003e00134712a: b90200dd            ltgr %r13,%r13
> >[96875.870793]            000003e00134712e: a7840017            brc 8,3e00134715c
> >[96875.870800]            000003e001347132: e320d0100004        lg %r2,16(%r13)
> >[96875.870809]>000003e001347138: e31020180004        lg %r1,24(%r2)
> >[96875.870818]            000003e00134713e: e31010580004        lg %r1,88(%r1)
> >[96875.870827]            000003e001347144: b9020011            ltgr %r1,%r1
> >[96875.870835]            000003e001347148: a784000a            brc 8,3e00134715c
> >[96875.870841]            000003e00134714c: 41202018            la %r2,24(%r2)
> >[96875.870889] Call Trace:
> >[96875.870892] ([<0700000000000008>] 0x700000000000008)
> >[96875.870897]  [<000003e0012e3662>] dm_softirq_done+0x9a/0x140 [dm_mod]
> >[96875.870915]  [<000000000040d29c>] blk_done_softirq+0xd4/0xf0
> >[96875.870925]  [<00000000001587c2>] __do_softirq+0xda/0x398
> >[96875.870932]  [<000000000010f47e>] do_softirq+0xe2/0xe8
> >[96875.870940]  [<0000000000158e2c>] irq_exit+0xc8/0xcc
> >[96875.870945]  [<00000000004ceb48>] do_IRQ+0x910/0x1bfc
> >[96875.870953]  [<000000000061a164>] io_return+0x0/0x16
> >[96875.870961]  [<000000000019c84e>] lock_acquire+0xd2/0x204
> >[96875.870969] ([<000000000019c836>] lock_acquire+0xba/0x204)
> >[96875.870974]  [<0000000000615f8e>] mutex_lock_killable_nested+0x92/0x520
> >[96875.870983]  [<0000000000292796>] vfs_readdir+0x8a/0xe4
> >[96875.870992]  [<00000000002928e0>] SyS_getdents+0x60/0xe8
> >[96875.870999]  [<0000000000619af2>] sysc_noemu+0x16/0x1c
> >[96875.871024]  [<000003fffd1ec83e>] 0x3fffd1ec83e
> >[96875.871028] INFO: lockdep is turned off.
> >[96875.871031] Last Breaking-Event-Address:
> >[96875.871037]  [<000003e0012e3660>] dm_softirq_done+0x98/0x140 [dm_mod]

[...]

> Hmm. Just to be on the safe side, could you try this one:
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 5e0090e..e6fad46 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -920,8 +920,10 @@ static int multipath_map(struct dm_target *ti,
> struct reque
> st *clone,
>         map_context->ptr = mpio;
>         clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
>         r = map_io(m, clone, mpio, 0);
> -       if (r < 0 || r == DM_MAPIO_REQUEUE)
> +       if (r < 0 || r == DM_MAPIO_REQUEUE) {
>                 mempool_free(mpio, m->mpio_pool);
> +               map_context->ptr = NULL;
> +       }
> 
>         return r;
>  }

With your patch we haven't been able to reproduce the kernel crash until now.
Now we "only" run into I/O stalls, which before your patch we also did. But
repeatedly rebooting and retrying and ignoring the I/O stalls always lead to
a crash.
Gonzalo will run a couple of extra rounds so we can have a feeling if at least
one of the bugs could be fixed with your patch ;)
