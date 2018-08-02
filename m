From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 2/2] blk-mq: fix blk_mq_tagset_busy_iter
Date: Fri,  3 Aug 2018 01:49:37 +0800
Message-ID: <20180802174937.15444-3-ming.lei@redhat.com>
References: <20180802174937.15444-1-ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802174937.15444-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, Guenter Roeck <linux@roeck-us.net>, Mark Brown <broonie@kernel.org>, Matt Hart <matthew.hart@linaro.org>, Johannes Thumshirn <jthumshirn@suse.de>, John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Commit d250bf4e776ff09d5("blk-mq: only iterate over inflight requests
in blk_mq_tagset_busy_iter") uses 'blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT'
to replace 'blk_mq_request_started(req)', this way is wrong, and causes
lots of test system hang during booting.

Fix the issue by using blk_mq_request_started(req) inside bt_tags_iter().

Fixes: d250bf4e776ff09d5 ("blk-mq: only iterate over inflight requests in blk_mq_tagset_busy_iter")
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matt Hart <matthew.hart@linaro.org>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.com>,
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reported-by: Mark Brown <broonie@kernel.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-tag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 09b2ee6694fb..3de0836163c2 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -271,7 +271,7 @@ static bool bt_tags_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
 	 * test and set the bit before assining ->rqs[].
 	 */
 	rq = tags->rqs[bitnr];
-	if (rq && blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT)
+	if (rq && blk_mq_request_started(rq))
 		iter_data->fn(rq, iter_data->data, reserved);
 
 	return true;
-- 
2.9.5
