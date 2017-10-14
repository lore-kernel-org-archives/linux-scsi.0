From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V10 0/8] blk-mq-sched: improve sequential I/O performance
Date: Sat, 14 Oct 2017 17:22:24 +0800
Message-ID: <20171014092232.13943-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33378 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751753AbdJNJWn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 14 Oct 2017 05:22:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>

Hi Jens,

In Red Hat internal storage test wrt. blk-mq scheduler, we found that I/O
performance is much bad with mq-deadline, especially about sequential I/O
on some multi-queue SCSI devcies(lpfc, qla2xxx, SRP...)

Turns out one big issue causes the performance regression: requests are
still dequeued from sw queue/scheduler queue even when ldd's queue is
busy, so I/O merge becomes quite difficult to make, then sequential IO
performance degrades a lot.

This issue becomes one of mains reasons for reverting default SCSI_MQ
in V4.13.

This 8 patches improve this situation, and brings back performance loss.

With this change, SCSI-MQ sequential I/O performance is improved much, Paolo
reported that mq-deadline performance improved much[2] in his dbench test
wrt V2. Also performance improvement on lpfc/qla2xx was observed with V1.[1]

[1] http://marc.info/?l=linux-block&m=150151989915776&w=2
[2] https://marc.info/?l=linux-block&m=150217980602843&w=2

gitweb:
	https://github.com/ming1/linux/commits/blk_mq_improve_scsi_mpath_perf_V10_part1

V10:
	- fix hang with kyber used
	- address comments from Bart

V9:
	- change title of patch1
	- rename blk_mq_get_budget() as blk_mq_get_dispatch_budget()
	- make check on .get_budget/.put_budget cleaner
	- all are suggested by Jens, thank for review

V8:
	- introduce helper of blk_mq_get_budget
	- handle failure path of get_budget

V7:
	- introduce .get_budget/.put_budget, and IO merge gets improved
	compared with V6, and in theory this approach is better than the way
	taken in block legacy

	- drop patch of 'blk-mq-sched: don't dequeue request until all in ->dispatch are flushed'

V6:
	- address comments from Christoph
	- drop the 1st patch which changes blk_mq_request_bypass_insert(),
	which should belong to dm-mpath's improvement
	- move ' blk-mq-sched: move actual dispatching into one helper'
	as 2nd patch, and use the introduced helper to simplify dispatch
	logic
	- merge two previous patches into one for improving dispatch from sw queue
	- make comment/commit log line width as ~70, as suggested by
	  Christoph

V5:
	- address some comments from Omar
	- add Tested-by & Reveiewed-by tag
	- use direct issue for blk_mq_request_bypass_insert(), and
	start to consider to improve sequential I/O for dm-mpath
	- only include part 1(the original patch 1 ~ 6), as suggested
	by Omar

V4:
	- add Reviewed-by tag
	- some trival change: typo fix in commit log or comment,
	variable name, no actual functional change

V3:
	- totally round robin for picking req from ctx, as suggested
	by Bart
	- remove one local variable in __sbitmap_for_each_set()
	- drop patches of single dispatch list, which can improve
	performance on mq-deadline, but cause a bit degrade on
	none because all hctxs need to be checked after ->dispatch
	is flushed. Will post it again once it is mature.
	- rebase on v4.13-rc6 with block for-next

V2:
	- dequeue request from sw queues in round roubin's style
	as suggested by Bart, and introduces one helper in sbitmap
	for this purpose
	- improve bio merge via hash table from sw queue
	- add comments about using DISPATCH_BUSY state in lockless way,
	simplifying handling on busy state,
	- hold ctx->lock when clearing ctx busy bit as suggested
	by Bart


Ming Lei (8):
  blk-mq-sched: dispatch from scheduler only after progress is made on
    ->dispatch
  blk-mq-sched: move actual dispatching into one helper
  sbitmap: introduce __sbitmap_for_each_set()
  block: kyber: check if there is request in ctx in kyber_has_work()
  blk-mq: introduce .get_budget and .put_budget in blk_mq_ops
  blk-mq-sched: improve dispatching from sw queue
  SCSI: allow to pass null rq to scsi_prep_state_check()
  SCSI: implement .get_budget and .put_budget for blk-mq

 block/blk-mq-sched.c    | 148 +++++++++++++++++++++++++++++++++++++++++-------
 block/blk-mq-sched.h    |   2 +-
 block/blk-mq.c          |  82 +++++++++++++++++++++++++--
 block/blk-mq.h          |  22 ++++++-
 block/kyber-iosched.c   |   2 +-
 drivers/scsi/scsi_lib.c |  79 ++++++++++++++++++--------
 include/linux/blk-mq.h  |  13 +++++
 include/linux/sbitmap.h |  64 +++++++++++++++------
 8 files changed, 342 insertions(+), 70 deletions(-)

-- 
2.9.5
