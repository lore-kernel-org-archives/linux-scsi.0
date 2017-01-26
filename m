From: Jens Axboe <axboe@fb.com>
Subject: Re: split scsi passthrough fields out of struct request
	V2
Date: Thu, 26 Jan 2017 14:51:52 -0700
Message-ID: <e1d5f4e6-c63f-545d-710f-d4d10fa8d2e0@fb.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485455329.2540.7.camel@sandisk.com>
	<e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
	<1485456745.2540.9.camel@sandisk.com>
	<db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
	<20170126185924.GA25289@lst.de>
	<ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
	<71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
	<4054e944-b28d-1cd6-574f-6cd90e28c301@fb.com>
	<1485464486.2540.12.camel@sandisk.com>
	<6995c991-65a4-8dca-c36e-fb2eff277ca9@fb.com>
	<1485467235.2540.14.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1485467235.2540.14.camel@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@lst.de" <hch@lst.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On 01/26/2017 02:47 PM, Bart Van Assche wrote:
> (gdb) list *(blk_mq_sched_get_request+0x310)
> 0xffffffff8132dcf0 is in blk_mq_sched_get_request (block/blk-mq-sched.c:136).
> 131                                     rq->rq_flags |= RQF_QUEUED;
> 132                     } else
> 133                             rq = __blk_mq_alloc_request(data, op);
> 134             } else {
> 135                     rq = __blk_mq_alloc_request(data, op);
> 136                     data->hctx->tags->rqs[rq->tag] = rq;
> 137             }
> 138
> 139             if (rq) {
> 140                     if (!op_is_flush(op)) {
> 
> (gdb) disas blk_mq_sched_get_request
> [ ... ]
>    0xffffffff8132dce3 <+771>:   callq  0xffffffff81324ab0 <__blk_mq_alloc_request>
>    0xffffffff8132dce8 <+776>:   mov    %rax,%rcx
>    0xffffffff8132dceb <+779>:   mov    0x18(%r12),%rax
>    0xffffffff8132dcf0 <+784>:   movslq 0x5c(%rcx),%rdx
> [ ... ]
> (gdb) print &((struct request *)0)->tag
> $1 = (int *) 0x5c <irq_stack_union+92>
> 
> I think this means that rq == NULL and that a test for rq is missing after the
> __blk_mq_alloc_request() call?

That is exactly what it means, looks like that one path doesn't handle
that.  You'd have to exhaust the pool with atomic allocs for this to
trigger, we don't do that at all in the normal IO path. So good catch,
must be the dm part that enables this since it does NOWAIT allocations.


diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 3136696f4991..c27613de80c5 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -134,7 +134,8 @@ struct request *blk_mq_sched_get_request(struct request_queue *q,
 			rq = __blk_mq_alloc_request(data, op);
 	} else {
 		rq = __blk_mq_alloc_request(data, op);
-		data->hctx->tags->rqs[rq->tag] = rq;
+		if (rq)
+			data->hctx->tags->rqs[rq->tag] = rq;
 	}
 
 	if (rq) {

-- 
Jens Axboe
