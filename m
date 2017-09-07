From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] bsg-lib: don't free job in bsg_prepare_job
Date: Thu,  7 Sep 2017 13:54:35 +0200
Message-ID: <20170907115436.5069-2-hch@lst.de>
References: <20170907115436.5069-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170907115436.5069-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The job structure is allocated as part of the request, so we should not
free it in the error path of bsg_prepare_job.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
---
 block/bsg-lib.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index dd56d7460cb9..c587c71d78af 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -154,7 +154,6 @@ static int bsg_prepare_job(struct device *dev, struct request *req)
 failjob_rls_rqst_payload:
 	kfree(job->request_payload.sg_list);
 failjob_rls_job:
-	kfree(job);
 	return -ENOMEM;
 }
 
-- 
2.11.0
