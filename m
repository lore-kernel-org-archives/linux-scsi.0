From: Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH 1/2] scsi: core: fix missing .cleanup_rq for SCSI
	hosts without request batching
Date: Wed,  7 Aug 2019 16:49:47 +0200
Message-ID: <20190807144948.28265-2-maier@linux.ibm.com>
References: <20190807144948.28265-1-maier@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190807144948.28265-1-maier@linux.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Hannes Reinecke <hare@suse.com>, "Ewan D . Milne" <emilne@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-next@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

This was missing from scsi_mq_ops_no_commit of linux-next commit
8930a6c20791 ("scsi: core: add support for request batching")
from Martin's scsi/5.4/scsi-queue or James' scsi/misc.

See also linux-next commit b7e9e1fb7a92 ("scsi: implement .cleanup_rq
callback") from block/for-next.

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Fixes: 8930a6c20791 ("scsi: core: add support for request batching")
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ae03d3e2600f..90c257622bb0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1834,6 +1834,7 @@ static const struct blk_mq_ops scsi_mq_ops_no_commit = {
 	.init_request	= scsi_mq_init_request,
 	.exit_request	= scsi_mq_exit_request,
 	.initialize_rq_fn = scsi_initialize_rq,
+	.cleanup_rq	= scsi_cleanup_rq,
 	.busy		= scsi_mq_lld_busy,
 	.map_queues	= scsi_map_queues,
 };
-- 
2.17.1
