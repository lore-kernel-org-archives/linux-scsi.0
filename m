From: Jan Kara <jack@suse.cz>
Subject: Re: BUG: KASAN: use-after-free in scsi_exit_rq
Date: Tue, 2 May 2017 16:41:25 +0200
Message-ID: <20170502144125.GK13916@quack2.suse.cz>
References: <20170420211849.GB7387@sbauer-Z170X-UD5>
 <1492811357.2499.9.camel@sandisk.com>
 <20170428214647.GG22354@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170428214647.GG22354@htj.duckdns.org>
Sender: linux-block-owner@vger.kernel.org
To: "tj@kernel.org" <tj@kernel.org>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "scott.bauer@intel.com" <scott.bauer@intel.com>, "hch@lst.de" <hch@lst.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Jan Kara <jack@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Fri 28-04-17 17:46:47, Tejun Heo wrote:
> On Fri, Apr 21, 2017 at 09:49:17PM +0000, Bart Van Assche wrote:
> > On Thu, 2017-04-20 at 15:18 -0600, Scott Bauer wrote:
> > > [  642.638860] BUG: KASAN: use-after-free in scsi_exit_rq+0xf3/0x120 at addr ffff8802b7fedf00
> > > [  642.639362] Read of size 1 by task rcuos/5/53
> > > [  642.639713] CPU: 7 PID: 53 Comm: rcuos/6 Not tainted 4.11.0-rc5+ #13
> > > [  642.640170] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
> > > [  642.640923] Call Trace:
> > > [  642.641080]  dump_stack+0x63/0x8f
> > > [  642.641289]  kasan_object_err+0x21/0x70
> > > [  642.641531]  kasan_report.part.1+0x231/0x500
> > > [  642.641823]  ? scsi_exit_rq+0xf3/0x120
> > > [  642.642054]  ? _raw_spin_unlock_irqrestore+0xe/0x10
> > > [  642.642353]  ? free_percpu+0x1b7/0x340
> > > [  642.642586]  ? put_task_stack+0x117/0x2b0
> > > [  642.642837]  __asan_report_load1_noabort+0x2e/0x30
> > > [  642.643138]  scsi_exit_rq+0xf3/0x120
> > > [  642.643366]  free_request_size+0x44/0x60
> > > [  642.643614]  mempool_destroy.part.6+0x9b/0x150
> > > [  642.643899]  ? kasan_slab_free+0x87/0xb0
> > > [  642.644152]  mempool_destroy+0x13/0x20
> > > [  642.644394]  blk_exit_rl+0x36/0x40
> > > [  642.644614]  blkg_free+0x146/0x200
> > > [  642.644836]  __blkg_release_rcu+0x121/0x220
> > > [  642.645112]  rcu_nocb_kthread+0x61f/0xca0
> > > [  642.645376]  ? get_state_synchronize_rcu+0x20/0x20
> > > [  642.645690]  ? pci_mmcfg_check_reserved+0x110/0x110
> > > [  642.646011]  kthread+0x298/0x390
> > > [  642.646224]  ? get_state_synchronize_rcu+0x20/0x20
> > > [  642.646535]  ? kthread_park+0x160/0x160
> > > [  642.646787]  ret_from_fork+0x2c/0x40
> > 
> > I'm not familiar with cgroups but seeing this makes me wonder whether it would
> > be possible to move the blk_exit_rl() calls from blk_release_queue() into
> > blk_cleanup_queue()? The SCSI core frees a SCSI host after blk_cleanup_queue()
> > has finished for all associated SCSI devices. This is why I think that calling
> > blk_exit_rl() earlier would be sufficient to avoid that scsi_exit_rq()
> > dereferences a SCSI host pointer after it has been freed.
> 
> Hmm... I see.  Didn't know request put path involved derefing those
> structs.  The blk_exit_rl() call just replaced open coded
> mempool_destroy call, so the destruction order was always like this.
> We shouldn't have any request in flight by cleanup, so moving it there
> should be fine.

So I'm also not aware of any particular breakage this would cause. However
logically the freeing of request mempools really belongs to
blk_release_queue() so it seems a bit dumb to move blk_exit_rl() just
because SCSI stores the fact from which slab cache it has allocated the
sense buffer in a structure (shost) that it frees under its hands by the
time blk_release_queue() is called. :-|

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
