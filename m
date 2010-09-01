From: Naohiro Aota <naota@elisp.net>
Subject: [PATCH] bsg: call idr_pre_get() outside the lock.
Date: Wed, 01 Sep 2010 23:26:01 +0900
Message-ID: <m2eidda6bq.fsf@elisp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>, Naohiro Aota <naota@elisp.net>, Daniel Mack <daniel@caiaq.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The idr_pre_get() kernel-doc says "This function should be called
prior to locking and calling the idr_get_new* functions.", but the
idr_pre_get() calling in bsg_register_queue() is put inside
mutex_lock(). Let's fix it.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 block/bsg.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 82d5882..5fd8dd1 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -1010,13 +1010,11 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
 	bcd = &q->bsg_dev;
 	memset(bcd, 0, sizeof(*bcd));
 
-	mutex_lock(&bsg_mutex);
-
 	ret = idr_pre_get(&bsg_minor_idr, GFP_KERNEL);
-	if (!ret) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
+	if (!ret)
+		return -ENOMEM;
+
+	mutex_lock(&bsg_mutex);
 
 	ret = idr_get_new(&bsg_minor_idr, bcd, &minor);
 	if (ret < 0)
-- 
1.7.2
