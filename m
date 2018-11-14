From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V2] SCSI: fix queue cleanup race before queue
 initialization is done
Date: Wed, 14 Nov 2018 08:20:09 -0700
Message-ID: <63c063ad-7d74-4268-bfd4-2de89908949e@kernel.dk>
References: <20181114082551.12141-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181114082551.12141-1-ming.lei@redhat.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, Andrew Jones <drjones@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, stable <stable@vger.kernel.org>, "jianchao . wang" <jianchao.w.wang@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 11/14/18 1:25 AM, Ming Lei wrote:
> c2856ae2f315d ("blk-mq: quiesce queue before freeing queue") has
> already fixed this race, however the implied synchronize_rcu()
> in blk_mq_quiesce_queue() can slow down LUN probe a lot, so caused
> performance regression.
> 
> Then 1311326cf4755c7 ("blk-mq: avoid to synchronize rcu inside blk_cleanup_queue()")
> tried to quiesce queue for avoiding unnecessary synchronize_rcu()
> only when queue initialization is done, because it is usual to see
> lots of inexistent LUNs which need to be probed.
> 
> However, turns out it isn't safe to quiesce queue only when queue
> initialization is done. Because when one SCSI command is completed,
> the user of sending command can be waken up immediately, then the
> scsi device may be removed, meantime the run queue in scsi_end_request()
> is still in-progress, so kernel panic can be caused.
> 
> In Red Hat QE lab, there are several reports about this kind of kernel
> panic triggered during kernel booting.
> 
> This patch tries to address the issue by grabing one queue usage
> counter during freeing one request and the following run queue.

Thanks applied, this bug was elusive but ever present in recent
testing that we did internally, it's been a huge pain in the butt.
The symptoms were usually a crash in blk_mq_get_driver_tag() with
hctx->tags == NULL, or a crash inside deadline request insert off
requeue.

-- 
Jens Axboe
