From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: t10-pi: Return correct ref tag when queue has no integrity profile
Date: Tue,  4 Dec 2018 21:31:10 -0500
Message-ID: <20181205023110.20162-1-martin.petersen@oracle.com>
References: <yq1ftvcsoes.fsf@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <yq1ftvcsoes.fsf@oracle.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: john.garry@huawei.com, "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Commit ddd0bc756983 ("block: move ref_tag calculation func to the block
layer") moved ref tag calculation from SCSI to a library function. However,
this change broke returning the correct ref tag for devices operating in
DIF mode since these do not have an associated block integrity profile.
This in turn caused read/write failures on PI-formatted disks attached to
an mpt3sas controller.

Fixes: ddd0bc756983 ("block: move ref_tag calculation func to the block layer")
Cc: stable@vger.kernel.org # 4.19+
Reported-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 include/linux/t10-pi.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/t10-pi.h b/include/linux/t10-pi.h
index b9626aa7e90c..3e2a80cc7b56 100644
--- a/include/linux/t10-pi.h
+++ b/include/linux/t10-pi.h
@@ -39,12 +39,13 @@ struct t10_pi_tuple {
 
 static inline u32 t10_pi_ref_tag(struct request *rq)
 {
+	unsigned int shift = ilog2(queue_logical_block_size(rq->q));
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
-	return blk_rq_pos(rq) >>
-		(rq->q->integrity.interval_exp - 9) & 0xffffffff;
-#else
-	return -1U;
+	if (rq->q->integrity.interval_exp)
+		shift = rq->q->integrity.interval_exp;
 #endif
+	return blk_rq_pos(rq) >> (shift - SECTOR_SHIFT) & 0xffffffff;
 }
 
 extern const struct blk_integrity_profile t10_pi_type1_crc;
-- 
2.19.2
