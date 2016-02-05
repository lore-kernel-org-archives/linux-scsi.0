From: jiangyiwen <jiangyiwen@huawei.com>
Subject: [PATCH] block: do not return -EOPNOTSUPP only when issue a discard
 request
Date: Fri, 5 Feb 2016 15:10:46 +0800
Message-ID: <56B44AF6.2090003@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:47113 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbcBEHKz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2016 02:10:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>

commit 8af1954d172a("blkdev: Do not return -EOPNOTSUPP if discard
is supported") only solve the situation of discard, because When
applications issue a discard request to device, they can't expect
deterministic behaviour. However, WRITE SAME should not ignore error
with EOPNOTSUPP, because if applications issue WRITE SAME requests to
device, it should return deterministic results to applications
according to the T10 standard, or else it will cause an inconsistent
state between upper layer and bottom layer.

So ignoring error with EOPNOTSUPP only in discard situation.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 9ebf653..e4f02f1 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -19,7 +19,9 @@ static void bio_batch_end_io(struct bio *bio)
 {
 	struct bio_batch *bb = bio->bi_private;

-	if (bio->bi_error && bio->bi_error != -EOPNOTSUPP)
+	/* ignore -EOPNOTSUPP only when issue a discard request */
+	if (bio->bi_error && (!(bio->bi_rw & REQ_DISCARD) ||
+			(bio->bi_error != -EOPNOTSUPP)))
 		bb->error = bio->bi_error;
 	if (atomic_dec_and_test(&bb->done))
 		complete(bb->wait);
-- 
1.8.4.3

