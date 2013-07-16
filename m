From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Tue, 16 Jul 2013 14:38:03 -0700
Message-ID: <1374010683.7397.880.camel@haakon3.risingtidesystems.com>
References: <cover.1369155164.git.agordeev@redhat.com>
	 <20130521235003.GE6985@mtj.dyndns.org>
	 <20130522143923.GD19383@dhcp-26-207.brq.redhat.com>
	 <20130522170305.GD9563@kernel.dk>
	 <20130711102630.GA11133@dhcp-26-207.brq.redhat.com>
	 <1373583637.7397.370.camel@haakon3.risingtidesystems.com>
	 <20130712074559.GA8727@dhcp-26-207.brq.redhat.com>
	 <1373692812.7397.625.camel@haakon3.risingtidesystems.com>
	 <20130716183207.GA6402@dhcp-26-207.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130716183207.GA6402@dhcp-26-207.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-07-16 at 20:32 +0200, Alexander Gordeev wrote:
> On Fri, Jul 12, 2013 at 10:20:12PM -0700, Nicholas A. Bellinger wrote:
> > On Fri, 2013-07-12 at 09:46 +0200, Alexander Gordeev wrote:
> > > > > diff --git a/drivers/scsi/scsi-mq.c b/drivers/scsi/scsi-mq.c
> > > > > index ca6ff67..d8cc7a4 100644
> > > > > --- a/drivers/scsi/scsi-mq.c
> > > > > +++ b/drivers/scsi/scsi-mq.c
> > > > > @@ -155,6 +155,7 @@ void scsi_mq_done(struct scsi_cmnd *sc)
> > > > >  static struct blk_mq_ops scsi_mq_ops = {
> > > > >  	.queue_rq	= scsi_mq_queue_rq,
> > > > >  	.map_queue	= blk_mq_map_queue,
> > > > > +	.timeout	= scsi_times_out,
> > > > >  	.alloc_hctx	= blk_mq_alloc_single_hw_queue,
> > > > >  	.free_hctx	= blk_mq_free_single_hw_queue,
> > > > >  };
> > 
> > So your actually triggering a blk-mq timeout with ata_piix..?
> 
> No.
> That is to avoid a NULL-pointer assignment from ->timeout elsewhere.
> In fact I return -ENODEV for sr_probe() to not hit it.
> 
> > That is why scsi-mq still uses blk_execute_rq() for this reason, and
> > this will need be addressed in order to safely use blk_mq_execute_rq()
> > in the above context.
> 
> Got it.
> 
> > Do you have an OOPs backtrace handy to post w/o the last two changes in
> > place..?
> 
> Attaching the output. No oops actually (due to aforementioned .timeout).
> 

Hi Alexander,

Thanks for the logs.  I'm In-lining some of the output here for
reference:

[    7.927596] Calling blk_mq_init_queue: scsi_mq_ops: ffffffff81ca13e0, queue_depth: 64, cmd_size: 296 SCSI cmd_size: 0

Just FYI, a SCSI cmd_size of zero here means that scsi-mq will not be
providing pre-allocated LLD descriptors (located at scsi_cmnd->SCp.ptr)
for use by libata driver code.

That is fine for initial testing, but libata will eventually want to
take advantage of scsi_host_template->cmd_size = sizeof(ata_queued_cmd)
in order to remove (all) memory allocations from the I/O fast-path.

[    7.927639] blk-mq: CPU -> queue map
[    7.927640]   CPU 0 -> Queue 0
[    7.927640]   CPU 1 -> Queue 0
[    7.927640]   CPU 2 -> Queue 0
[    7.927641]   CPU 3 -> Queue 0
[    7.927641]   CPU 4 -> Queue 0
[    7.927642]   CPU 5 -> Queue 0
[    7.927642]   CPU 6 -> Queue 0
[    7.927643]   CPU 7 -> Queue 0
[    7.927643]   CPU 8 -> Queue 0
[    7.927643]   CPU 9 -> Queue 0
[    7.927644]   CPU10 -> Queue 0
[    7.927644]   CPU11 -> Queue 0
[    7.927645]   CPU12 -> Queue 0
[    7.927645]   CPU13 -> Queue 0
[    7.927646]   CPU14 -> Queue 0
[    7.927646]   CPU15 -> Queue 0
[    7.927673] Performing sc map setup on q: ffff880462430000 hctx: ffff880462a14200 i: 0
[    7.927780] scsi_mq_alloc_queue() complete !! >>>>>>>>>>>>>>>>>>>>>>>>>>>
[    7.927784] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.927785] Allocated blk-mq req: ffff88046244ad40, req->tag: 63
[    7.927790] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.927803] scsi_execute(): Calling blk_mq_free_request >>>
[    7.927815] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.927816] Allocated blk-mq req: ffff88046244ad40, req->tag: 63
[    7.927817] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.927818] scsi_execute(): Calling blk_mq_free_request >>>
[    7.927826] scsi 0:0:0:0: Direct-Access     ATA      ST9500530NS      CC03 PQ: 0 ANSI: 5

OK, so INQUIRY response payload is looking as expected here.

[    7.927944] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.927946] Allocated blk-mq req: ffff88046244a7c0, req->tag: 61
[    7.927946] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.927949] scsi_execute(): Calling blk_mq_free_request >>>
[    7.927951] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.927952] Allocated blk-mq req: ffff88046244a7c0, req->tag: 61
[    7.927955] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.927958] scsi_execute(): Calling blk_mq_free_request >>>
[    7.927960] sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
[    7.927964] sd 0:0:0:0: [sda] 1 512-byte logical blocks: (512 B/512 B)
[    7.927965] sd 0:0:0:0: [sda] 0-byte physical blocks

Strange..  READ_CAPACITY appears to be returning a payload as zeros..?

[    7.927966] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.927967] Allocated blk-mq req: ffff88046244a7c0, req->tag: 61
[    7.927968] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.927970] scsi_execute(): Calling blk_mq_free_request >>>
[    7.927970] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.927971] Allocated blk-mq req: ffff88046244a7c0, req->tag: 61
[    7.927972] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.927973] scsi_execute(): Calling blk_mq_free_request >>>
[    7.927975] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.927976] Allocated blk-mq req: ffff88046244a7c0, req->tag: 61
[    7.927977] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.927979] scsi_execute(): Calling blk_mq_free_request >>>
[    7.927981] sd 0:0:0:0: [sda] Write Protect is off
[    7.927982] sd 0:0:0:0: [sda] Mode Sense: 00 00 00 00

Ditto here..

[    7.927983] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.927984] Allocated blk-mq req: ffff88046244a7c0, req->tag: 61
[    7.927985] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.927986] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.927987] scsi_execute(): Calling blk_mq_free_request >>>
[    7.927989] sd 0:0:0:0: [sda] Asking for cache data failed
[    7.927990] sd 0:0:0:0: [sda] Assuming drive cache: write through

and here as well..

Not sure why yet some control CDBs are getting back the expected
payload, while others are returning zeros..

Also, looking at the included stack back-trace:

[    7.928394] blk-mq: CPU -> queue map
[    7.928394]   CPU 0 -> Queue 0
[    7.928395]   CPU 1 -> Queue 0
[    7.928395]   CPU 2 -> Queue 0
[    7.928396]   CPU 3 -> Queue 0
[    7.928396]   CPU 4 -> Queue 0
[    7.928396]   CPU 5 -> Queue 0
[    7.928397]   CPU 6 -> Queue 0
[    7.928397]   CPU 7 -> Queue 0
[    7.928398]   CPU 8 -> Queue 0
[    7.928398]   CPU 9 -> Queue 0
[    7.928399]   CPU10 -> Queue 0
[    7.928399]   CPU11 -> Queue 0
[    7.928399]   CPU12 -> Queue 0
[    7.928400]   CPU13 -> Queue 0
[    7.928400]   CPU14 -> Queue 0
[    7.928401]   CPU15 -> Queue 0
[    7.928420] Performing sc map setup on q: ffff8804624f08e0 hctx: ffff880462938a00 i: 0
[    7.928435] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928436] Allocated blk-mq req: ffff88046250a240, req->tag: 59
[    7.928437] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928439] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928441] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928441] Allocated blk-mq req: ffff88046250a240, req->tag: 59
[    7.928443] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928444] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928446] sd 0:0:1:0: [sdb] Sector size 0 reported, assuming 512.
[    7.928448] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928448] Allocated blk-mq req: ffff88046250a240, req->tag: 59
[    7.928450] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928451] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928452] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928452] Allocated blk-mq req: ffff88046250a240, req->tag: 59
[    7.928457] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928458] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928459] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928460] Allocated blk-mq req: ffff88046250a240, req->tag: 59
[    7.928461] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928462] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928463] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928464] Allocated blk-mq req: ffff88046250a240, req->tag: 59
[    7.928465] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928466] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928468] sd 0:0:1:0: [sdb] Asking for cache data failed
[    7.928469] sd 0:0:1:0: [sdb] Assuming drive cache: write through
[    7.928487] ------------[ cut here ]------------
[    7.928492] WARNING: at drivers/ata/libata-core.c:5038 ata_qc_issue+0x266/0x380()

Here is the code in question:

void ata_qc_issue(struct ata_queued_cmd *qc)
{
        struct ata_port *ap = qc->ap;
        struct ata_link *link = qc->dev->link;
        u8 prot = qc->tf.protocol;

        /* Make sure only one non-NCQ command is outstanding.  The
         * check is skipped for old EH because it reuses active qc to
         * request ATAPI sense.
         */
        WARN_ON_ONCE(ap->ops->error_handler && ata_tag_valid(link->active_tag));

	....
}

So I think that ata_tag_valid() is triggering this WARN_ON_ONCE due to
the default queue_depth setting in scsi-mq.c:scsi_mq_alloc_queue(),
which is queueing more than a single outstanding struct scsi_cmnd at a
time into the underlying LLD.  Note in this value is currently
hard-coded to:

        sdev->sdev_mq_reg.queue_depth = 64;

This value should actually be coming from what the hardware is
advertising, eg:

   min(scsi_host_template->cmd_per_lun, scsi_host_template->can_queue)

but I'd recommend to try to hardcode this value to 1 for the moment in
order to match what ata_piix is reporting to SCSI.

Also, just to be safe, please also disable scsi-generic
(CONFIG_CHR_DEV_SG) in your kernel config, as it's not hooked up to
scsi-mq just yet, and may be causing problems elsewhere.

Thanks!

--nab

[    7.928494] Modules linked in:
[    7.928496] CPU: 9 PID: 153 Comm: kworker/u50:5 Not tainted 3.10.0-rc5.nab+ #11
[    7.928497] Hardware name: Cisco Systems Inc R210-2121605W/R210-2121605W, BIOS C200.1.4.3j.0.020720132258 02/07/2013
[    7.928502] Workqueue: events_unbound async_run_entry_fn
[    7.928505]  0000000000000009 ffff88046241f588 ffffffff8162cc58 ffff88046241f5c8
[    7.928507]  ffffffff8104a200 ffff88046241f5d8 ffff880462b90000 0000000000000003
[    7.928509]  ffff880462b91c68 ffffffff81415450 ffff880462b90230 ffff88046241f5d8
[    7.928510] Call Trace:
[    7.928514]  [<ffffffff8162cc58>] dump_stack+0x19/0x1b
[    7.928518]  [<ffffffff8104a200>] warn_slowpath_common+0x70/0xa0
[    7.928521]  [<ffffffff81415450>] ? ata_scsi_set_sense.constprop.26+0x30/0x30
[    7.928523]  [<ffffffff8104a24a>] warn_slowpath_null+0x1a/0x20
[    7.928525]  [<ffffffff8140f586>] ata_qc_issue+0x266/0x380
[    7.928526]  [<ffffffff814155b3>] ? ata_scsi_rw_xlat+0x163/0x210
[    7.928528]  [<ffffffff81415450>] ? ata_scsi_set_sense.constprop.26+0x30/0x30
[    7.928530]  [<ffffffff814140d7>] ata_scsi_translate+0xa7/0x180
[    7.928531] scsi_mq_alloc_queue() complete !! >>>>>>>>>>>>>>>>>>>>>>>>>>>
[    7.928533]  [<ffffffff814181f9>] ata_scsi_queuecmd+0xa9/0x2b0
[    7.928534] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928537]  [<ffffffff813ed956>] scsi_dispatch_cmd+0x1c6/0x310
[    7.928537] Allocated blk-mq req: ffff88046259ad40, req->tag: 63
[    7.928540]  [<ffffffff813f63bb>] scsi_mq_queue_rq+0x17b/0x280
[    7.928541] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928546]  [<ffffffff812c15c5>] __blk_mq_run_hw_queue+0x1b5/0x3a0
[    7.928549]  [<ffffffff812c1c65>] blk_mq_run_hw_queue+0x35/0x40
[    7.928550]  [<ffffffff812c1fbb>] blk_mq_make_request+0x34b/0x4a0
[    7.928554]  [<ffffffff812b74f2>] generic_make_request+0xc2/0x110
[    7.928556]  [<ffffffff812b7a1b>] submit_bio+0x7b/0x160
[    7.928560]  [<ffffffff811baa8d>] ? bio_alloc_bioset+0x9d/0x1b0
[    7.928562]  [<ffffffff811b576e>] _submit_bh+0x13e/0x200
[    7.928564]  [<ffffffff811b5840>] submit_bh+0x10/0x20
[    7.928566]  [<ffffffff811b754d>] block_read_full_page+0x21d/0x350
[    7.928568]  [<ffffffff811bbff0>] ? I_BDEV+0x10/0x10
[    7.928571]  [<ffffffff8113be73>] ? __inc_zone_page_state+0x33/0x40
[    7.928573]  [<ffffffff8111f4bf>] ? add_to_page_cache_locked+0xdf/0x190
[    7.928575]  [<ffffffff811bc4a0>] ? blkdev_write_begin+0x30/0x30
[    7.928577]  [<ffffffff811bc4b8>] blkdev_readpage+0x18/0x20
[    7.928579]  [<ffffffff8111fcfa>] do_read_cache_page+0x7a/0x170
[    7.928581]  [<ffffffff8112837a>] ? __alloc_pages_nodemask+0x17a/0xad0
[    7.928583]  [<ffffffff8111fe09>] read_cache_page_async+0x19/0x20
[    7.928585]  [<ffffffff8112015e>] read_cache_page+0xe/0x20
[    7.928588]  [<ffffffff812c80cd>] read_dev_sector+0x2d/0x90
[    7.928590]  [<ffffffff812cdc4c>] read_lba+0xec/0x190
[    7.928592]  [<ffffffff812ce255>] ? efi_partition+0xe5/0x5f0
[    7.928594]  [<ffffffff812ce26f>] efi_partition+0xff/0x5f0
[    7.928596]  [<ffffffff812e9c34>] ? snprintf+0x34/0x40
[    7.928598]  [<ffffffff812ce170>] ? is_gpt_valid+0x480/0x480
[    7.928600]  [<ffffffff812c9138>] check_partition+0x108/0x220
[    7.928602]  [<ffffffff812c8d44>] rescan_partitions+0xb4/0x2c0
[    7.928604]  [<ffffffff811bda35>] __blkdev_get+0x375/0x4b0
[    7.928606]  [<ffffffff8119e447>] ? inode_init_always+0x107/0x1c0
[    7.928608]  [<ffffffff811bc010>] ? blkdev_get_block+0x20/0x20
[    7.928610]  [<ffffffff811bdd05>] blkdev_get+0x195/0x2e0
[    7.928612]  [<ffffffff8119f0c7>] ? unlock_new_inode+0x47/0x70
[    7.928613]  [<ffffffff811bcff0>] ? bdget+0x120/0x140
[    7.928615]  [<ffffffff812c6531>] add_disk+0x391/0x490
[    7.928618]  [<ffffffff81402c4a>] sd_probe_async+0x13a/0x230
[    7.928620]  [<ffffffff81075de6>] async_run_entry_fn+0x46/0x140
[    7.928623]  [<ffffffff810683c4>] process_one_work+0x174/0x400
[    7.928624]  [<ffffffff81068acc>] worker_thread+0x11c/0x370
[    7.928626]  [<ffffffff810689b0>] ? rescuer_thread+0x320/0x320
[    7.928629]  [<ffffffff8106f410>] kthread+0xc0/0xd0
[    7.928631]  [<ffffffff8106f350>] ? flush_kthread_worker+0x80/0x80
[    7.928633]  [<ffffffff8163b2dc>] ret_from_fork+0x7c/0xb0
[    7.928635]  [<ffffffff8106f350>] ? flush_kthread_worker+0x80/0x80
[    7.928638] ---[ end trace 9f4b3fe3fb787a07 ]---

> > I *very* much recommend doing the same if at all possible for ata_piix
> > scsi-mq development + testing, as you'll want to be very careful when
> > using a real file-system on top of this early alpha code.
> 
> Thank you for the warning.
> Getting to writing CDBs would be of success :)
> 
> > --nab
> > 
> 
