From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 08/14] blk-mq: separate number of hardware queues from
 nr_cpu_ids
Date: Mon, 29 Oct 2018 11:31:16 -0700
Message-ID: <1540837876.196084.75.camel@acm.org>
References: <20181029163738.10172-1-axboe@kernel.dk>
         <20181029163738.10172-9-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-9-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-10-29 at 10:37 -0600, Jens Axboe wrote:
+AD4 With multiple maps, nr+AF8-cpu+AF8-ids is no longer the maximum number of
+AD4 hardware queues we support on a given devices. The initializer of
+AD4 the tag+AF8-set can have set -+AD4-nr+AF8-hw+AF8-queues larger than the available
+AD4 number of CPUs, since we can exceed that with multiple queue maps.
+AD4 
+AD4 Reviewed-by: Hannes Reinecke +ADw-hare+AEA-suse.com+AD4
+AD4 Signed-off-by: Jens Axboe +ADw-axboe+AEA-kernel.dk+AD4
+AD4 ---
+AD4  block/blk-mq.c +AHw 28 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--------
+AD4  1 file changed, 21 insertions(+-), 7 deletions(-)
+AD4 
+AD4 diff --git a/block/blk-mq.c b/block/blk-mq.c
+AD4 index 0fab36372ace..60a951c4934c 100644
+AD4 --- a/block/blk-mq.c
+AD4 +-+-+- b/block/blk-mq.c
+AD4 +AEAAQA -2663,6 +-2663,19 +AEAAQA static void blk+AF8-mq+AF8-realloc+AF8-hw+AF8-ctxs(struct blk+AF8-mq+AF8-tag+AF8-set +ACo-set,
+AD4  	mutex+AF8-unlock(+ACY-q-+AD4-sysfs+AF8-lock)+ADs
+AD4  +AH0
+AD4  
+AD4 +-/+ACo
+AD4 +- +ACo Maximum number of queues we support. For single sets, we'll never have
                       +AF4
                   hardware?
+AD4 +- +ACo more than the CPUs (software queues). For multiple sets, the tag+AF8-set
+AD4 +- +ACo user may have set -+AD4-nr+AF8-hw+AF8-queues larger.
+AD4 +- +ACo-/

Anyway:

Reviewed-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
