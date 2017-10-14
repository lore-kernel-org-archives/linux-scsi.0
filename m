From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V10 4/8] block: kyber: check if there is request in ctx in kyber_has_work()
Date: Sat, 14 Oct 2017 17:22:28 +0800
Message-ID: <20171014092232.13943-5-ming.lei@redhat.com>
References: <20171014092232.13943-1-ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171014092232.13943-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

There may be request in sw queue, and not fetched to domain queue
yet, so check it in kyber_has_work().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/kyber-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index f58cab82105b..94df3ce99f2f 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -641,7 +641,7 @@ static bool kyber_has_work(struct blk_mq_hw_ctx *hctx)
 		if (!list_empty_careful(&khd->rqs[i]))
 			return true;
 	}
-	return false;
+	return sbitmap_any_bit_set(&hctx->ctx_map);
 }
 
 #define KYBER_LAT_SHOW_STORE(op)					\
-- 
2.9.5
