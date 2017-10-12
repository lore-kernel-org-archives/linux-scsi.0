From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V7 0/6] blk-mq-sched: improve sequential I/O performance
Date: Fri, 13 Oct 2017 02:36:58 +0800
Message-ID: <20171012183704.22326-1-ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Jens,

In Red Hat internal storage test wrt. blk-mq scheduler, we
found that I/O performance is much bad with mq-deadline, especially
about sequential I/O on some multi-queue SCSI devcies(lpfc, qla2xxx,
SRP...)

Turns out one big issue causes the performance regression: requests
are still dequeued from sw queue/scheduler queue even when ldd's
queue is busy, so I/O merge becomes quite difficult to make, then
sequential IO degrades a lot.

This issue becomes one of mains reasons for reverting default SCSI_MQ
in V4.13.

This six patches improve this situation, and brings back
performance loss.

With this change, SCSI-MQ sequential I/O performance is
improved much, Paolo reported that mq-deadline performance
improved much[2] in his dbench test wrt V2. Also performance
improvement on lpfc/qla2xx was observed with V1.[1]

[1] http://marc.info/?l=linux-block&m=150151989915776&w=2
[2] https://marc.info/?l=linux-block&m=150217980602843&w=2

gitweb:
	https://github.com/ming1/linux/commits/blk_mq_improve_scsi_mpath_perf_V7_part1

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

Ming Lei (6):
  blk-mq-sched: fix scheduler bad performance
  blk-mq-sched: move actual dispatching into one helper
  sbitmap: introduce __sbitmap_for_each_set()
  blk-mq: introduce .get_budget and .put_budget in blk_mq_ops
  blk-mq-sched: improve dispatching from sw queue
  SCSI: implement .get_budget and .put_budget for blk-mq

 block/blk-mq-sched.c    | 121 +++++++++++++++++++++++++++++++++++++++++-------
 block/blk-mq.c          |  74 +++++++++++++++++++++++++++--
 block/blk-mq.h          |   4 +-
 drivers/scsi/scsi_lib.c |  42 +++++++++++++----
 include/linux/blk-mq.h  |  12 +++++
 include/linux/sbitmap.h |  64 ++++++++++++++++++-------
 6 files changed, 268 insertions(+), 49 deletions(-)

-- 
2.9.5
