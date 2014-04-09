From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/2] block: Fix for_each_bvec()
Date: Tue,  8 Apr 2014 22:43:43 -0400
Message-ID: <1397011424-10970-1-git-send-email-martin.petersen@oracle.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Kent Overstreet <kmo@daterainc.com>, Nicholas Bellinger <nab@linux-iscsi.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: "Martin K. Petersen" <martin.petersen@oracle.com>

Commit 4550dd6c6b062 introduced for_each_bvec() which iterates over each
bvec attached to a bio or bip. However, the macro fails to check bi_size
before dereferencing which can lead to crashes while counting/mapping
integrity scatterlist segments.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: <stable@vger.kernel.org> # v3.14+
---
 include/linux/bio.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 5a4d39b4686b..5aa372a7380c 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -216,9 +216,9 @@ static inline void bvec_iter_advance(struct bio_vec *bv, struct bvec_iter *iter,
 }
 
 #define for_each_bvec(bvl, bio_vec, iter, start)			\
-	for ((iter) = start;						\
-	     (bvl) = bvec_iter_bvec((bio_vec), (iter)),			\
-		(iter).bi_size;						\
+	for (iter = (start);						\
+	     (iter).bi_size &&						\
+		((bvl = bvec_iter_bvec((bio_vec), (iter))), 1);	\
 	     bvec_iter_advance((bio_vec), &(iter), (bvl).bv_len))
 
 
-- 
1.8.3.1
