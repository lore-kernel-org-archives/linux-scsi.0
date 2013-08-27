From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch|rfc] block: fix race between request completion and timeout
 handling
Date: Tue, 27 Aug 2013 16:49:05 +0200
Message-ID: <521CBC61.2030904@suse.de>
References: <x49ppszqkbg.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x49ppszqkbg.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, JBottomley@parallels.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/27/2013 04:28 PM, Jeff Moyer wrote:
> Hi,
>=20
> We have several reports (against a distro kernel) of panics in
> blk_requeue_request that look like this:
>=20
> kernel BUG at block/blk-core.c:1045!
> invalid opcode: 0000 [#1] SMP
> last sysfs file: /sys/devices/pci0000:40/0000:40:03.0/0000:55:00.0/in=
finiband_mad/umad0/port
> CPU 0
> Modules linked in: ipmi_si ipmi_devintf ipmi_msghandler bonding rdma_=
ucm(U) rdma_cm(U) iw_cm(U) ib_addr(U) ib_ipoib(U) ib_cm(U) ib_sa(U) ipv=
6 ib_uverbs(U) ib_umad(U) iw_nes(U) libcrc32c mlx4_ib(U) mlx4_en(U) mlx=
4_core(U) ib_mthca(U) ib_mad(U) ib_core(U) cdc_ether usbnet mii microco=
de i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support shpchp ioatdma dca be=
2net sg ses enclosure ext4 mbcache jbd2 sd_mod crc_t10dif ahci megaraid=
_sas(U) dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_wai=
t_scan]
>=20
> Pid: 491, comm: scsi_eh_0 Tainted: G        W  ----------------   2.6=
=2E32-220.13.1.el6.x86_64 #1 IBM  -[8722PAX]-/00D1461
> RIP: 0010:[<ffffffff8124e424>]  [<ffffffff8124e424>] blk_requeue_requ=
est+0x94/0xa0
> RSP: 0018:ffff881057eefd60  EFLAGS: 00010012
> RAX: ffff881d99e3e8a8 RBX: ffff881d99e3e780 RCX: ffff881d99e3e8a8
> RDX: ffff881d99e3e8a8 RSI: ffff881d99e3e780 RDI: ffff881d99e3e780
> RBP: ffff881057eefd80 R08: ffff881057eefe90 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff881057f92338
> R13: 0000000000000000 R14: ffff881057f92338 R15: ffff883058188000
> FS:  0000000000000000(0000) GS:ffff880040200000(0000) knlGS:000000000=
0000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00000000006d3ec0 CR3: 000000302cd7d000 CR4: 00000000000406b0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process scsi_eh_0 (pid: 491, threadinfo ffff881057eee000, task ffff88=
1057e29540)
> Stack:
>  0000000000001057 0000000000000286 ffff8810275efdc0 ffff881057f16000
> <0> ffff881057eefdd0 ffffffff81362323 ffff881057eefe20 ffffffff8135f3=
93
> <0> ffff881057e29af8 ffff8810275efdc0 ffff881057eefe78 ffff881057eefe=
90
> Call Trace:
>  [<ffffffff81362323>] __scsi_queue_insert+0xa3/0x150
>  [<ffffffff8135f393>] ? scsi_eh_ready_devs+0x5e3/0x850
>  [<ffffffff81362a23>] scsi_queue_insert+0x13/0x20
>  [<ffffffff8135e4d4>] scsi_eh_flush_done_q+0x104/0x160
>  [<ffffffff8135fb6b>] scsi_error_handler+0x35b/0x660
>  [<ffffffff8135f810>] ? scsi_error_handler+0x0/0x660
>  [<ffffffff810908c6>] kthread+0x96/0xa0
>  [<ffffffff8100c14a>] child_rip+0xa/0x20
>  [<ffffffff81090830>] ? kthread+0x0/0xa0
>  [<ffffffff8100c140>] ? child_rip+0x0/0x20
> Code: 00 00 eb d1 4c 8b 2d 3c 8f 97 00 4d 85 ed 74 bf 49 8b 45 00 49 =
83 c5 08 48 89 de 4c 89 e7 ff d0 49 8b 45 00 48 85 c0 75 eb eb a4 <0f> =
0b eb fe 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f 44 00 00
> RIP  [<ffffffff8124e424>] blk_requeue_request+0x94/0xa0
>  RSP <ffff881057eefd60>
>=20
> The RIP is this line:
>         BUG_ON(blk_queued_rq(rq));
>=20
> After digging through the code, I think there may be a race between t=
he
> request completion and the timer handler running.
>=20
> A timer is started for each request put on the device's queue (see
> blk_start_request->blk_add_timer).  If the request does not complete
> before the timer expires, the timer handler (blk_rq_timed_out_timer)
> will mark the request complete atomically:
>=20
> static inline int blk_mark_rq_complete(struct request *rq)
> {
>         return test_and_set_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags)=
;
> }
>=20
> and then call blk_rq_timed_out.  The latter function will call
> scsi_times_out, which will return one of BLK_EH_HANDLED,
> BLK_EH_RESET_TIMER or BLK_EH_NOT_HANDLED.  If BLK_EH_RESET_TIMER is
> returned, blk_clear_rq_complete is called, and blk_add_timer is again
> called to simply wait longer for the request to complete.
>=20
> Now, if the request happens to complete while this is going on, what
> happens?  Given that we know the completion handler will bail if it
> finds the REQ_ATOM_COMPLETE bit set, we need to focus on the completi=
on
> handler running after that bit is cleared.  So, from the above
> paragraph, after the call to blk_clear_rq_complete.  If the completio=
n
> sets REQ_ATOM_COMPLETE before the BUG_ON in blk_add_timer, we go boom
> there (I haven't seen this in the cores).  Next, if we get the
> completion before the call to list_add_tail, then the timer will
> eventually fire for an old req, which may either be freed or realloca=
ted
> (there is evidence that this might be the case).  Finally, if the
> completion comes in *after* the addition to the timeout list, I think
> it's harmless.  The request will be removed from the timeout list,
> req_atom_complete will be set, and all will be well.
>=20
> This RFC patch moves the BUG_ON(test_bit(REQ_ATOM_COMPLETE,
> &req->atomic_flags)); from blk_add_timer to the only caller that coul=
d
> trip over it (blk_start_request).  It then inverts the calls to
> blk_clear_rq_complete and blk_add_timer in blk_rq_timed_out to addres=
s
> the race.  I've boot tested this patch, but nothing more.
>=20
> Jens, James, others, what do you think?
>=20
Hmm. I've been chasing down a similar if not identical issue for
several months now. So it looks a likely candidate.
I'll give it some more thought.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
