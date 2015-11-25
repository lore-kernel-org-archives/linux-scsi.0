From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] target: use offset_in_page macro
Date: Wed, 25 Nov 2015 21:49:27 +0800
Message-ID: <a4523a15b2ebf30e6eec6d04ab851a2c8d8bf041.1448459290.git.geliangtang@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Dan Carpenter <dan.carpenter@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use offset_in_page macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/target/target_core_user.c | 2 +-
 drivers/target/tcm_fc/tfc_io.c    | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 937cebf..d5477c0 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -194,7 +194,7 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 
 static inline void tcmu_flush_dcache_range(void *vaddr, size_t size)
 {
-	unsigned long offset = (unsigned long) vaddr & ~PAGE_MASK;
+	unsigned long offset = offset_in_page(vaddr);
 
 	size = round_up(size+offset, PAGE_SIZE);
 	vaddr -= offset;
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 847c1aa..6f7c65a 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -154,9 +154,9 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 			BUG_ON(!page);
 			from = kmap_atomic(page + (mem_off >> PAGE_SHIFT));
 			page_addr = from;
-			from += mem_off & ~PAGE_MASK;
+			from += offset_in_page(mem_off);
 			tlen = min(tlen, (size_t)(PAGE_SIZE -
-						(mem_off & ~PAGE_MASK)));
+						offset_in_page(mem_off)));
 			memcpy(to, from, tlen);
 			kunmap_atomic(page_addr);
 			to += tlen;
@@ -314,9 +314,9 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 
 		to = kmap_atomic(page + (mem_off >> PAGE_SHIFT));
 		page_addr = to;
-		to += mem_off & ~PAGE_MASK;
+		to += offset_in_page(mem_off);
 		tlen = min(tlen, (size_t)(PAGE_SIZE -
-					  (mem_off & ~PAGE_MASK)));
+					  offset_in_page(mem_off)));
 		memcpy(to, from, tlen);
 		kunmap_atomic(page_addr);
 
-- 
2.5.0
