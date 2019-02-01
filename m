From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/8] block: remove req->special
Date: Fri,  1 Feb 2019 08:55:56 +0100
Message-ID: <20190201075557.9249-8-hch@lst.de>
References: <20190201075557.9249-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190201075557.9249-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, ooo@electrozaur.com
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

No users left.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c         | 1 -
 include/linux/blkdev.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3ba37b9e15e9..502cbf964a3b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -331,7 +331,6 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 	rq->nr_integrity_segments = 0;
 #endif
-	rq->special = NULL;
 	/* tag was already set */
 	rq->extra_len = 0;
 	WRITE_ONCE(rq->deadline, 0);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 338604dff7d0..fd1450d53f1c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -216,8 +216,6 @@ struct request {
 	unsigned short write_hint;
 	unsigned short ioprio;
 
-	void *special;		/* opaque pointer available for LLD use */
-
 	unsigned int extra_len;	/* length of alignment and padding */
 
 	enum mq_rq_state state;
-- 
2.20.1
