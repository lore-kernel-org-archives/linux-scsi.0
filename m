From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Thu, 13 Oct 2011 15:09:19 +0200
Message-ID: <4E96E2FF.6070601@linux.vnet.ibm.com>
References: <201109221318.p8MDIXPP020015@pentland.suse.de> <20110928004722.GA27421@kernel.dk> <CA+55aFznvejXWe68BpjsJqCWnDizbHWBOzKLY_H+YqhRiK42sQ@mail.gmail.com> <4E82751C.9050908@kernel.dk> <CA+55aFyL76hD7o_839G7tKa0y6dFRcK-kC+g_h_coEp=Qk23pw@mail.gmail.com> <1317183038.17578.9.camel@dabdike.hansenpartnership.com> <4E832A55.30709@kernel.dk> <1317219074.19034.4.camel@dabdike.hansenpartnership.com> <4E832BD2.50409@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E832BD2.50409@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org

This fix also went into 3.0.5 via
http://git.kernel.org/?p=3Dlinux/kernel/git/stable/stable-queue.git;a=3D=
blob;f=3Dreleases/3.0.5/block-free-queue-resources-at-blk_release_queue=
=2Epatch
(originated at http://marc.info/?l=3Dlinux-scsi&m=3D131669751909474&w=3D=
2 and=20
http://marc.info/?l=3Dlinux-scsi&m=3D131669414205696&w=3D2)

However, it seems we still have a use-after-free bug, now causing the=20
following oops with kernel 3.0.6 when removing paths to storage while=20
generating load on device-mapper multipath disks:

> Unable to handle kernel pointer dereference at virtual kernel address=
 6b6b6b6b6b6b6000
> Oops: 0038 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Modules linked in: iptable_filter ip_tables x_tables dm_round_robin s=
unrpc qeth_l3 binfmt_misc dm_multipath scsi_dh dm_mod ipv6 qeth ccwgrou=
p [last unloaded: scsi_wait_scan]
> CPU: 1 Not tainted 3.0.6-50.x.20111006-s390xdefault #1
> Process blast.LzS_64_SL (pid: 26613, task: 0000000063e2a398, ksp: 000=
0000064de3560)
> Krnl PSW : 0704100180000000 000000000048a038 (scsi_print_command+0x44=
/0xf8)
>            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
> Krnl GPRS: 000000000000006b 6b6b6b6b6b6b6b6b 000000006717f800 0000000=
00094f2e0
>            000000000061242e 000000000062bd88 0000000066fb90d8 0000000=
065391ad7
>            000000006717f800 000000006717f800 000000006716a090 0000000=
06717f800
>            0000000000000004 0000000000672f88 0000000064de3838 0000000=
064de3808
> Krnl Code: 000000000048a026: f0b80004ebbf        srp     4(12,%r0),30=
07(%r14),8
>            000000000048a02c: f0a0000407f4        srp     4(11,%r0),20=
36,0
>            000000000048a032: e31020800004        lg      %r1,128(%r2)
>           >000000000048a038: e31010b00004        lg      %r1,176(%r1)
>            000000000048a03e: b9020011            ltgr    %r1,%r1
>            000000000048a042: a7840032            brc     8,48a0a6
>            000000000048a046: e33020000004        lg      %r3,0(%r2)
>            000000000048a04c: c04000182f4c        larl    %r4,78fee4
> Call Trace:
> ([<000000006717f800>] 0x6717f800)
>  [<0000000000487f28>] scsi_log_send+0xf0/0x130
>  [<000000000048824c>] scsi_dispatch_cmd+0xc8/0x4bc
>  [<0000000000490694>] scsi_request_fn+0x3b8/0x480
>  [<00000000003fe4c8>] __elv_add_request+0x174/0x35c
>  [<0000000000402fd6>] blk_insert_cloned_request+0x72/0xcc
>  [<000003e001e134f2>] dm_dispatch_request+0x5a/0x94 [dm_mod]
>  [<000003e001e15f36>] dm_request_fn+0x216/0x398 [dm_mod]
>  [<0000000000405590>] queue_unplugged+0x60/0x1a8
>  [<0000000000407470>] blk_flush_plug_list+0x218/0x29c
>  [<00000000006136ec>] io_schedule+0x94/0x100
>  [<000000000020e6d6>] sleep_on_page_killable+0x22/0x60
>  [<00000000006140a8>] __wait_on_bit_lock+0xc0/0x124
>  [<000000000020e5f8>] __lock_page_killable+0x78/0x84
>  [<0000000000210690>] generic_file_aio_read+0x56c/0x800
>  [<000000000027a0a0>] do_sync_read+0xcc/0x11c
>  [<000000000027a974>] vfs_read+0xb0/0x194
>  [<000000000027aab0>] SyS_read+0x58/0xb4
>  [<00000000006185f6>] sysc_noemu+0x16/0x1c
>  [<000003fffd473bd4>] 0x3fffd473bd4
> INFO: lockdep is turned off.
> Last Breaking-Event-Address:
>  [<000000000048a020>] scsi_print_command+0x2c/0xf8

During a different run, we also got a similar oops which was not logged=
=20
but only its panic_on_oops:

> Kernel panic - not syncing: Fatal exception: panic_on_oops
> CPU: 1 Tainted: G      D     3.0.6-50.x.20111006-s390xdefault #1
> Process blast.LzS_64_SL (pid: 6551, task: 00000000a2942398, ksp: 0000=
0000a11834e0)
> 00000000a1183630 00000000a11835b0 0000000000000002 0000000000000000
>        00000000a1183650 00000000a11835c8 00000000a11835c8 00000000006=
1242e
>        0000000000000000 0000000000000000 00000000a3176ed7 00000000001=
00ed2
>        000000000000000d 000000000000000c 00000000a1183618 00000000000=
00000
>        0000000000000000 0000000000100a18 00000000a11835b0 00000000a11=
835f0
> Call Trace:
> ([<0000000000100926>] show_trace+0xee/0x144)
>  [<0000000000612258>] panic+0xb0/0x234
>  [<0000000000100ed2>] die+0x166/0x168
>  [<000000000011eede>] do_no_context+0xba/0xf8
>  [<000000000061ad28>] do_asce_exception+0x130/0x18c
>  [<0000000000618918>] pgm_exit+0x0/0x4
>  [<000000000048a0d4>] scsi_print_command+0xe0/0xf8
> ([<000000000048a0e6>] scsi_print_command+0xf2/0xf8)
>  [<0000000000487f28>] scsi_log_send+0xf0/0x130
>  [<000000000048824c>] scsi_dispatch_cmd+0xc8/0x4bc
>  [<0000000000490694>] scsi_request_fn+0x3b8/0x480
>  [<00000000003fe4c8>] __elv_add_request+0x174/0x35c
>  [<0000000000402fd6>] blk_insert_cloned_request+0x72/0xcc
>  [<000003e001e134f2>] dm_dispatch_request+0x5a/0x94 [dm_mod]
>  [<000003e001e15f36>] dm_request_fn+0x216/0x398 [dm_mod]
>  [<0000000000405590>] queue_unplugged+0x60/0x1a8
>  [<0000000000407470>] blk_flush_plug_list+0x218/0x29c
>  [<000000000040751e>] blk_finish_plug+0x2a/0x58
>  [<000000000021034e>] generic_file_aio_read+0x22a/0x800
>  [<000000000027a0a0>] do_sync_read+0xcc/0x11c
>  [<000000000027a974>] vfs_read+0xb0/0x194
>  [<000000000027aab0>] SyS_read+0x58/0xb4
>  [<00000000006185f6>] sysc_noemu+0x16/0x1c
>  [<000003fffd395bd4>] 0x3fffd395bd4
> INFO: lockdep is turned off.

The other CPU was doing scsi_print_command successfully to the console=20
(sclp_console_write) when this panic occurred.

Earlier, we tried Alan's patch
http://marc.info/?l=3Dlinux-scsi&m=3D130963676807728&w=3D2
on 3.0.4, but in contrast to Cascardo's experience
http://marc.info/?l=3Dlinux-scsi&m=3D131482024119345&w=3D2
it did not work for us.

Initially, we encountered use-after-free bugs in
scsi_print_command / scsi_dispatch_cmd
http://marc.info/?l=3Dlinux-scsi&m=3D130824013229933&w=3D2
__elv_add_request
http://marc.info/?l=3Dlinux-scsi&m=3D130858383702949&w=3D2

Also related is the following thread:
http://marc.info/?l=3Dlinux-scsi&m=3D130977887419062&w=3D2

Unfortunately, I don't understand what exactly is going wrong here.
Can you shed some light on this?

On 09/28/2011 04:14 PM, Jens Axboe wrote:
> Alright, lets call this fully tested and fixed then. Linus, I committ=
ed
> it, please pull:
>
>    git://git.kernel.dk/linux-block.git for-linus
>
> Hannes Reinecke (1):
>        block: Free queue resources at blk_release_queue()
>
>   block/blk-core.c  |   13 ++++++-------
>   block/blk-sysfs.c |    5 +++++
>   2 files changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index b2ed78a..d34433a 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -348,9 +348,10 @@ void blk_put_queue(struct request_queue *q)
>   EXPORT_SYMBOL(blk_put_queue);
>
>   /*
> - * Note: If a driver supplied the queue lock, it should not zap that=
 lock
> - * unexpectedly as some queue cleanup components like elevator_exit(=
) and
> - * blk_throtl_exit() need queue lock.
> + * Note: If a driver supplied the queue lock, it is disconnected
> + * by this function. The actual state of the lock doesn't matter
> + * here as the request_queue isn't accessible after this point
> + * (QUEUE_FLAG_DEAD is set) and no other requests will be queued.
>    */
>   void blk_cleanup_queue(struct request_queue *q)
>   {
> @@ -367,10 +368,8 @@ void blk_cleanup_queue(struct request_queue *q)
>   	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
>   	mutex_unlock(&q->sysfs_lock);
>
> -	if (q->elevator)
> -		elevator_exit(q->elevator);
> -
> -	blk_throtl_exit(q);
> +	if (q->queue_lock !=3D&q->__queue_lock)
> +		q->queue_lock =3D&q->__queue_lock;
>
>   	blk_put_queue(q);
>   }
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index e681805..60fda88 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -479,6 +479,11 @@ static void blk_release_queue(struct kobject *ko=
bj)
>
>   	blk_sync_queue(q);
>
> +	if (q->elevator)
> +		elevator_exit(q->elevator);
> +
> +	blk_throtl_exit(q);
> +
>   	if (rl->rq_pool)
>   		mempool_destroy(rl->rq_pool);
>
>
>

--=20
Steffen Maier

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
