From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 5/8] target: Use sgl_alloc_order() and sgl_free()
Date: Thu, 12 Oct 2017 15:45:47 -0700
Message-ID: <20171012224550.25440-6-bart.vanassche@wdc.com>
References: <20171012224550.25440-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171012224550.25440-1-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Bart Van Assche <bart.vanassche@wdc.com>, "Nicholas A . Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>
List-Id: linux-scsi@vger.kernel.org

Use the sgl_alloc_order() and sgl_free() functions instead of open
coding these functions.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/target/Kconfig                 |  1 +
 drivers/target/target_core_transport.c | 47 ++++------------------------------
 2 files changed, 6 insertions(+), 42 deletions(-)

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index e2bc99980f75..4c44d7bed01a 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -5,6 +5,7 @@ menuconfig TARGET_CORE
 	select CONFIGFS_FS
 	select CRC_T10DIF
 	select BLK_SCSI_REQUEST # only for scsi_command_size_tbl..
+	select SGL_ALLOC
 	default n
 	help
 	Say Y or M here to enable the TCM Storage Engine and ConfigFS enabled
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 836d552b0385..e8f0eabd25ab 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -34,6 +34,7 @@
 #include <linux/cdrom.h>
 #include <linux/module.h>
 #include <linux/ratelimit.h>
+#include <linux/sgl_alloc.h>
 #include <linux/vmalloc.h>
 #include <asm/unaligned.h>
 #include <net/sock.h>
@@ -2293,13 +2294,7 @@ static void target_complete_ok_work(struct work_struct *work)
 
 void target_free_sgl(struct scatterlist *sgl, int nents)
 {
-	struct scatterlist *sg;
-	int count;
-
-	for_each_sg(sgl, sg, nents, count)
-		__free_page(sg_page(sg));
-
-	kfree(sgl);
+	sgl_free(sgl);
 }
 EXPORT_SYMBOL(target_free_sgl);
 
@@ -2423,42 +2418,10 @@ int
 target_alloc_sgl(struct scatterlist **sgl, unsigned int *nents, u32 length,
 		 bool zero_page, bool chainable)
 {
-	struct scatterlist *sg;
-	struct page *page;
-	gfp_t zero_flag = (zero_page) ? __GFP_ZERO : 0;
-	unsigned int nalloc, nent;
-	int i = 0;
-
-	nalloc = nent = DIV_ROUND_UP(length, PAGE_SIZE);
-	if (chainable)
-		nalloc++;
-	sg = kmalloc_array(nalloc, sizeof(struct scatterlist), GFP_KERNEL);
-	if (!sg)
-		return -ENOMEM;
+	gfp_t gfp = GFP_KERNEL | (zero_page ? __GFP_ZERO : 0);
 
-	sg_init_table(sg, nalloc);
-
-	while (length) {
-		u32 page_len = min_t(u32, length, PAGE_SIZE);
-		page = alloc_page(GFP_KERNEL | zero_flag);
-		if (!page)
-			goto out;
-
-		sg_set_page(&sg[i], page, page_len, 0);
-		length -= page_len;
-		i++;
-	}
-	*sgl = sg;
-	*nents = nent;
-	return 0;
-
-out:
-	while (i > 0) {
-		i--;
-		__free_page(sg_page(&sg[i]));
-	}
-	kfree(sg);
-	return -ENOMEM;
+	*sgl = sgl_alloc_order(length, 0, nents, gfp, chainable);
+	return *sgl ? 0 : -ENOMEM;
 }
 EXPORT_SYMBOL(target_alloc_sgl);
 
-- 
2.14.2
