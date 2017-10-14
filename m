From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: [PATCH V10 0/8] blk-mq-sched: improve sequential I/O performance
Date: Sat, 14 Oct 2017 19:38:29 +0200
Message-ID: <7774487.lQXyKRvAUb@natalenko.name>
References: <20171014092232.13943-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171014092232.13943-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Hi.

By any chance, could this be backported to 4.14? I'm confused with "SCSI:=20
allow to pass null rq to scsi_prep_state_check()" since it uses refactored=
=20
flags.

=3D=3D=3D
if (req && !(req->rq_flags & RQF_PREEMPT))
=3D=3D=3D

Is it safe to revert to REQ_PREEMPT here, or rq_flags should also be replac=
ed=20
with cmd_flags?

Thanks.

On sobota 14. =C5=99=C3=ADjna 2017 11:22:24 CEST Ming Lei wrote:
> Hi Jens,
>=20
> In Red Hat internal storage test wrt. blk-mq scheduler, we found that I/O
> performance is much bad with mq-deadline, especially about sequential I/O
> on some multi-queue SCSI devcies(lpfc, qla2xxx, SRP...)
>=20
> Turns out one big issue causes the performance regression: requests are
> still dequeued from sw queue/scheduler queue even when ldd's queue is
> busy, so I/O merge becomes quite difficult to make, then sequential IO
> performance degrades a lot.
>=20
> This issue becomes one of mains reasons for reverting default SCSI_MQ
> in V4.13.
>=20
> This 8 patches improve this situation, and brings back performance loss.
>=20
> With this change, SCSI-MQ sequential I/O performance is improved much, Pa=
olo
> reported that mq-deadline performance improved much[2] in his dbench test
> wrt V2. Also performance improvement on lpfc/qla2xx was observed with
> V1.[1]
>=20
> [1] http://marc.info/?l=3Dlinux-block&m=3D150151989915776&w=3D2
> [2] https://marc.info/?l=3Dlinux-block&m=3D150217980602843&w=3D2
>=20
> gitweb:
> 	https://github.com/ming1/linux/commits/
blk_mq_improve_scsi_mpath_perf_V10_p
> art1
>=20
> V10:
> 	- fix hang with kyber used
> 	- address comments from Bart
>=20
> V9:
> 	- change title of patch1
> 	- rename blk_mq_get_budget() as blk_mq_get_dispatch_budget()
> 	- make check on .get_budget/.put_budget cleaner
> 	- all are suggested by Jens, thank for review
>=20
> V8:
> 	- introduce helper of blk_mq_get_budget
> 	- handle failure path of get_budget
>=20
> V7:
> 	- introduce .get_budget/.put_budget, and IO merge gets improved
> 	compared with V6, and in theory this approach is better than the way
> 	taken in block legacy
>=20
> 	- drop patch of 'blk-mq-sched: don't dequeue request until all in
> ->dispatch are flushed'
>=20
> V6:
> 	- address comments from Christoph
> 	- drop the 1st patch which changes blk_mq_request_bypass_insert(),
> 	which should belong to dm-mpath's improvement
> 	- move ' blk-mq-sched: move actual dispatching into one helper'
> 	as 2nd patch, and use the introduced helper to simplify dispatch
> 	logic
> 	- merge two previous patches into one for improving dispatch from sw=20
queue
> 	- make comment/commit log line width as ~70, as suggested by
> 	  Christoph
>=20
> V5:
> 	- address some comments from Omar
> 	- add Tested-by & Reveiewed-by tag
> 	- use direct issue for blk_mq_request_bypass_insert(), and
> 	start to consider to improve sequential I/O for dm-mpath
> 	- only include part 1(the original patch 1 ~ 6), as suggested
> 	by Omar
>=20
> V4:
> 	- add Reviewed-by tag
> 	- some trival change: typo fix in commit log or comment,
> 	variable name, no actual functional change
>=20
> V3:
> 	- totally round robin for picking req from ctx, as suggested
> 	by Bart
> 	- remove one local variable in __sbitmap_for_each_set()
> 	- drop patches of single dispatch list, which can improve
> 	performance on mq-deadline, but cause a bit degrade on
> 	none because all hctxs need to be checked after ->dispatch
> 	is flushed. Will post it again once it is mature.
> 	- rebase on v4.13-rc6 with block for-next
>=20
> V2:
> 	- dequeue request from sw queues in round roubin's style
> 	as suggested by Bart, and introduces one helper in sbitmap
> 	for this purpose
> 	- improve bio merge via hash table from sw queue
> 	- add comments about using DISPATCH_BUSY state in lockless way,
> 	simplifying handling on busy state,
> 	- hold ctx->lock when clearing ctx busy bit as suggested
> 	by Bart
>=20
>=20
> Ming Lei (8):
>   blk-mq-sched: dispatch from scheduler only after progress is made on
>     ->dispatch
>   blk-mq-sched: move actual dispatching into one helper
>   sbitmap: introduce __sbitmap_for_each_set()
>   block: kyber: check if there is request in ctx in kyber_has_work()
>   blk-mq: introduce .get_budget and .put_budget in blk_mq_ops
>   blk-mq-sched: improve dispatching from sw queue
>   SCSI: allow to pass null rq to scsi_prep_state_check()
>   SCSI: implement .get_budget and .put_budget for blk-mq
>=20
>  block/blk-mq-sched.c    | 148
> +++++++++++++++++++++++++++++++++++++++++------- block/blk-mq-sched.h    =
|=20
>  2 +-
>  block/blk-mq.c          |  82 +++++++++++++++++++++++++--
>  block/blk-mq.h          |  22 ++++++-
>  block/kyber-iosched.c   |   2 +-
>  drivers/scsi/scsi_lib.c |  79 ++++++++++++++++++--------
>  include/linux/blk-mq.h  |  13 +++++
>  include/linux/sbitmap.h |  64 +++++++++++++++------
>  8 files changed, 342 insertions(+), 70 deletions(-)
