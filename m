From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH V5 00/14] blk-mq-sched: improve sequential I/O
 performance(part 1)
Date: Mon, 9 Oct 2017 13:09:22 +0100
Message-ID: <1e56f7e1-2a2f-26c9-9c74-97e0d22bc98b@huawei.com>
References: <20170930102720.30219-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170930102720.30219-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 30/09/2017 11:27, Ming Lei wrote:
> Hi Jens,
>
> In Red Hat internal storage test wrt. blk-mq scheduler, we
> found that I/O performance is much bad with mq-deadline, especially
> about sequential I/O on some multi-queue SCSI devcies(lpfc, qla2xxx,
> SRP...)
>
> Turns out one big issue causes the performance regression: requests
> are still dequeued from sw queue/scheduler queue even when ldd's
> queue is busy, so I/O merge becomes quite difficult to make, then
> sequential IO degrades a lot.
>
> This issue becomes one of mains reasons for reverting default SCSI_MQ
> in V4.13.
>
> The 1st patch takes direct issue in blk_mq_request_bypass_insert(),
> then we can improve dm-mpath's performance in part 2, which will
> be posted out soon.
>
> The 2nd six patches improve this situation, and brings back
> some performance loss.
>
> With this change, SCSI-MQ sequential I/O performance is
> improved much, Paolo reported that mq-deadline performance
> improved much[2] in his dbench test wrt V2. Also performanc
> improvement on lpfc/qla2xx was observed with V1.[1]
>
> Please consider it for V4.15.
>
> [1] http://marc.info/?l=linux-block&m=150151989915776&w=2
> [2] https://marc.info/?l=linux-block&m=150217980602843&w=2
>

I tested this series for the SAS controller on HiSilicon hip07 platform 
as I am interested in enabling MQ for this driver. Driver is 
./drivers/scsi/hisi_sas/.

So I found that that performance is improved when enabling default 
SCSI_MQ with this series vs baseline. However, it is still not as a good 
as when default SCSI_MQ is disabled.

Here are some figures I got with fio:
4.14-rc2 without default SCSI_MQ
read, rw, write IOPS	
952K, 133K/133K, 800K

4.14-rc2 with default SCSI_MQ
read, rw, write IOPS	
311K, 117K/117K, 320K

This series* without default SCSI_MQ
read, rw, write IOPS	
975K, 132K/132K, 790K

This series* with default SCSI_MQ
read, rw, write IOPS	
770K, 164K/164K, 594K

Please note that hisi_sas driver does not enable mq by exposing multiple 
queues to upper layer (even though it has multiple queues). I have been 
playing with enabling it, but my performance is always worse...

* I'm using 
https://github.com/ming1/linux/commits/blk_mq_improve_scsi_mpath_perf_V5.1, 
as advised by Ming Lei.

Thanks,
John

> V5:
> 	- address some comments from Omar
> 	- add Tested-by & Reveiewed-by tag
> 	- use direct issue for blk_mq_request_bypass_insert(), and
> 	start to consider to improve sequential I/O for dm-mpath
> 	- only include part 1(the original patch 1 ~ 6), as suggested
> 	by Omar
>
> V4:
> 	- add Reviewed-by tag
> 	- some trival change: typo fix in commit log or comment,
> 	variable name, no actual functional change
>
> V3:
> 	- totally round robin for picking req from ctx, as suggested
> 	by Bart
> 	- remove one local variable in __sbitmap_for_each_set()
> 	- drop patches of single dispatch list, which can improve
> 	performance on mq-deadline, but cause a bit degrade on
> 	none because all hctxs need to be checked after ->dispatch
> 	is flushed. Will post it again once it is mature.
> 	- rebase on v4.13-rc6 with block for-next
>
> V2:
> 	- dequeue request from sw queues in round roubin's style
> 	as suggested by Bart, and introduces one helper in sbitmap
> 	for this purpose
> 	- improve bio merge via hash table from sw queue
> 	- add comments about using DISPATCH_BUSY state in lockless way,
> 	simplifying handling on busy state,
> 	- hold ctx->lock when clearing ctx busy bit as suggested
> 	by Bart
>
>
> Ming Lei (7):
>   blk-mq: issue rq directly in blk_mq_request_bypass_insert()
>   blk-mq-sched: fix scheduler bad performance
>   sbitmap: introduce __sbitmap_for_each_set()
>   blk-mq: introduce blk_mq_dequeue_from_ctx()
>   blk-mq-sched: move actual dispatching into one helper
>   blk-mq-sched: improve dispatching from sw queue
>   blk-mq-sched: don't dequeue request until all in ->dispatch are
>     flushed
>
>  block/blk-core.c        |   3 +-
>  block/blk-mq-debugfs.c  |   1 +
>  block/blk-mq-sched.c    | 104 ++++++++++++++++++++++++++++++++++++-------
>  block/blk-mq.c          | 114 +++++++++++++++++++++++++++++++++++++++---------
>  block/blk-mq.h          |   4 +-
>  drivers/md/dm-rq.c      |   2 +-
>  include/linux/blk-mq.h  |   3 ++
>  include/linux/sbitmap.h |  64 +++++++++++++++++++--------
>  8 files changed, 238 insertions(+), 57 deletions(-)
>
