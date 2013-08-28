From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch|rfc] block: fix race between request completion and timeout
 handling
Date: Wed, 28 Aug 2013 09:38:59 +0200
Message-ID: <521DA913.1010505@suse.de>
References: <x49ppszqkbg.fsf@segfault.boston.devel.redhat.com> <521DA0F0.7060501@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <521DA0F0.7060501@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, JBottomley@parallels.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 08/28/2013 09:04 AM, Hannes Reinecke wrote:
> On 08/27/2013 04:28 PM, Jeff Moyer wrote:
>> Hi,
>>
>> We have several reports (against a distro kernel) of panics in
>> blk_requeue_request that look like this:
>>
>> kernel BUG at block/blk-core.c:1045!
>> invalid opcode: 0000 [#1] SMP
>> last sysfs file: /sys/devices/pci0000:40/0000:40:03.0/0000:55:00.0/i=
nfiniband_mad/umad0/port
>> CPU 0
>> Modules linked in: ipmi_si ipmi_devintf ipmi_msghandler bonding rdma=
_ucm(U) rdma_cm(U) iw_cm(U) ib_addr(U) ib_ipoib(U) ib_cm(U) ib_sa(U) ip=
v6 ib_uverbs(U) ib_umad(U) iw_nes(U) libcrc32c mlx4_ib(U) mlx4_en(U) ml=
x4_core(U) ib_mthca(U) ib_mad(U) ib_core(U) cdc_ether usbnet mii microc=
ode i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support shpchp ioatdma dca b=
e2net sg ses enclosure ext4 mbcache jbd2 sd_mod crc_t10dif ahci megarai=
d_sas(U) dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_wa=
it_scan]
>>
>> Pid: 491, comm: scsi_eh_0 Tainted: G        W  ----------------   2.=
6.32-220.13.1.el6.x86_64 #1 IBM  -[8722PAX]-/00D1461
>> RIP: 0010:[<ffffffff8124e424>]  [<ffffffff8124e424>] blk_requeue_req=
uest+0x94/0xa0
>> RSP: 0018:ffff881057eefd60  EFLAGS: 00010012
>> RAX: ffff881d99e3e8a8 RBX: ffff881d99e3e780 RCX: ffff881d99e3e8a8
>> RDX: ffff881d99e3e8a8 RSI: ffff881d99e3e780 RDI: ffff881d99e3e780
>> RBP: ffff881057eefd80 R08: ffff881057eefe90 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000000 R12: ffff881057f92338
>> R13: 0000000000000000 R14: ffff881057f92338 R15: ffff883058188000
>> FS:  0000000000000000(0000) GS:ffff880040200000(0000) knlGS:00000000=
00000000
>> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>> CR2: 00000000006d3ec0 CR3: 000000302cd7d000 CR4: 00000000000406b0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process scsi_eh_0 (pid: 491, threadinfo ffff881057eee000, task ffff8=
81057e29540)
>> Stack:
>>  0000000000001057 0000000000000286 ffff8810275efdc0 ffff881057f16000
>> <0> ffff881057eefdd0 ffffffff81362323 ffff881057eefe20 ffffffff8135f=
393
>> <0> ffff881057e29af8 ffff8810275efdc0 ffff881057eefe78 ffff881057eef=
e90
>> Call Trace:
>>  [<ffffffff81362323>] __scsi_queue_insert+0xa3/0x150
>>  [<ffffffff8135f393>] ? scsi_eh_ready_devs+0x5e3/0x850
>>  [<ffffffff81362a23>] scsi_queue_insert+0x13/0x20
>>  [<ffffffff8135e4d4>] scsi_eh_flush_done_q+0x104/0x160
>>  [<ffffffff8135fb6b>] scsi_error_handler+0x35b/0x660
>>  [<ffffffff8135f810>] ? scsi_error_handler+0x0/0x660
>>  [<ffffffff810908c6>] kthread+0x96/0xa0
>>  [<ffffffff8100c14a>] child_rip+0xa/0x20
>>  [<ffffffff81090830>] ? kthread+0x0/0xa0
>>  [<ffffffff8100c140>] ? child_rip+0x0/0x20
>> Code: 00 00 eb d1 4c 8b 2d 3c 8f 97 00 4d 85 ed 74 bf 49 8b 45 00 49=
 83 c5 08 48 89 de 4c 89 e7 ff d0 49 8b 45 00 48 85 c0 75 eb eb a4 <0f>=
 0b eb fe 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f 44 00 00
>> RIP  [<ffffffff8124e424>] blk_requeue_request+0x94/0xa0
>>  RSP <ffff881057eefd60>
>>
>> The RIP is this line:
>>         BUG_ON(blk_queued_rq(rq));
>>
>> After digging through the code, I think there may be a race between =
the
>> request completion and the timer handler running.
>>
>> A timer is started for each request put on the device's queue (see
>> blk_start_request->blk_add_timer).  If the request does not complete
>> before the timer expires, the timer handler (blk_rq_timed_out_timer)
>> will mark the request complete atomically:
>>
>> static inline int blk_mark_rq_complete(struct request *rq)
>> {
>>         return test_and_set_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags=
);
>> }
>>
>> and then call blk_rq_timed_out.  The latter function will call
>> scsi_times_out, which will return one of BLK_EH_HANDLED,
>> BLK_EH_RESET_TIMER or BLK_EH_NOT_HANDLED.  If BLK_EH_RESET_TIMER is
>> returned, blk_clear_rq_complete is called, and blk_add_timer is agai=
n
>> called to simply wait longer for the request to complete.
>>
>> Now, if the request happens to complete while this is going on, what
>> happens?  Given that we know the completion handler will bail if it
>> finds the REQ_ATOM_COMPLETE bit set, we need to focus on the complet=
ion
>> handler running after that bit is cleared.  So, from the above
>> paragraph, after the call to blk_clear_rq_complete.  If the completi=
on
>> sets REQ_ATOM_COMPLETE before the BUG_ON in blk_add_timer, we go boo=
m
>> there (I haven't seen this in the cores).  Next, if we get the
>> completion before the call to list_add_tail, then the timer will
>> eventually fire for an old req, which may either be freed or realloc=
ated
>> (there is evidence that this might be the case).  Finally, if the
>> completion comes in *after* the addition to the timeout list, I thin=
k
>> it's harmless.  The request will be removed from the timeout list,
>> req_atom_complete will be set, and all will be well.
>>
>> This RFC patch moves the BUG_ON(test_bit(REQ_ATOM_COMPLETE,
>> &req->atomic_flags)); from blk_add_timer to the only caller that cou=
ld
>> trip over it (blk_start_request).  It then inverts the calls to
>> blk_clear_rq_complete and blk_add_timer in blk_rq_timed_out to addre=
ss
>> the race.  I've boot tested this patch, but nothing more.
>>
>> Jens, James, others, what do you think?
>>
>> Cheers,
>> Jeff
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 93a18d1..236ae0a 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -2229,6 +2229,7 @@ void blk_start_request(struct request *req)
>>  	if (unlikely(blk_bidi_rq(req)))
>>  		req->next_rq->resid_len =3D blk_rq_bytes(req->next_rq);
>> =20
>> +	BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));
>>  	blk_add_timer(req);
>>  }
>>  EXPORT_SYMBOL(blk_start_request);
>> diff --git a/block/blk-timeout.c b/block/blk-timeout.c
>> index 65f1035..655ba90 100644
>> --- a/block/blk-timeout.c
>> +++ b/block/blk-timeout.c
>> @@ -91,8 +91,8 @@ static void blk_rq_timed_out(struct request *req)
>>  		__blk_complete_request(req);
>>  		break;
>>  	case BLK_EH_RESET_TIMER:
>> -		blk_clear_rq_complete(req);
>>  		blk_add_timer(req);
>> +		blk_clear_rq_complete(req);
>>  		break;
>>  	case BLK_EH_NOT_HANDLED:
>>  		/*
>> @@ -174,7 +174,6 @@ void blk_add_timer(struct request *req)
>>  		return;
>> =20
>>  	BUG_ON(!list_empty(&req->timeout_list));
>> -	BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));
>> =20
>>  	/*
>>  	 * Some LLDs, like scsi, peek at the timeout to prevent a
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20
> So, looked into things a bit more.
> It looks as if you're on the right track, although I doubt your
> patch will fix the issue for me :-(
>=20
> Thing is, you're right there is a race window between requeuing
> and softirq triggering, which could well be fixed by your patch.
> So for that reason alone I would like to take it.
>=20
> However, including your patch will end up opening another can of
> worms: the softirq might now be triggering _while the request is
> queued on the request queue_.
> blk_requeue_request will be putting the request back on the request
> queue, where it'll be stuck until being pulled off from
> scsi_request_fn().
> So if the softirq triggers during that condition we'll end up
> calling the BUG_ON((!list_empty(&req->queuelist)) in
> __blk_put_request().
>=20
> Guess we'd need to fix that one, too ...
>=20
Ah. Now I see it.

We're requeuing from the softirq context, ie after the completion
has triggered. So the above scenario can't actually happen and the
patch is valid.

So:

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
