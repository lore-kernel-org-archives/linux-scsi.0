From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] bsg-lib: don't free job in bsg_prepare_job
Date: Wed,  6 Sep 2017 12:11:09 +0200
Message-ID: <20170906101109.9270-3-hch@lst.de>
References: <20170906101109.9270-1-hch@lst.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170906101109.9270-1-hch@lst.de>
Sender: stable-owner@vger.kernel.org
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
index c82408c7cc3c..dbddff8174e5 100644
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
