From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target/iblock: Fix double iblock_complete_cmd callback bug
Date: Thu,  8 Nov 2012 19:58:59 +0000
Message-ID: <1352404739-22881-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a double completion bug where ibr->pending = 2 usage
plus the extra callback to iblock_complete_cmd() invoked after bio
submission in iblock_execute_rw() can interfere with the normal
bio->bi_done() -> iblock_bio_done() -> iblock_complete_cmd() completion
path, causing a double target_complete_cmd() call to occur.

This bug was introduced during v3.4-rc2 code with:

commit 5787cacd0bd5ee016ad807b244550d34fe2beebe
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Apr 24 00:25:06 2012 -0400

    target: remove struct se_task

Also drop the bio_cnt >= IBLOCK_MAX_BIO_PER_TASK rolling call to
iblock_submit_bios() to avoid the exception case where outstanding
bios completing via iblock_bio_done() are not accounted for when
returning returning non zero from iblock_execute_rw().

This bug was originally reported by Kelsey when a single se_cmd
descriptor required more than one bio to complete.

Reported-by: Kelsey Prantis <kelsey.prantis@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 57d7674..d066932 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -47,7 +47,6 @@
 
 #include "target_core_iblock.h"
 
-#define IBLOCK_MAX_BIO_PER_TASK	 32	/* max # of bios to submit at a time */
 #define IBLOCK_BIO_POOL_SIZE	128
 
 static struct se_subsystem_api iblock_template;
@@ -602,7 +601,6 @@ static int iblock_execute_rw(struct se_cmd *cmd)
 	struct scatterlist *sg;
 	u32 sg_num = sgl_nents;
 	sector_t block_lba;
-	unsigned bio_cnt;
 	int rw;
 	int i;
 
@@ -658,8 +656,7 @@ static int iblock_execute_rw(struct se_cmd *cmd)
 	bio_list_init(&list);
 	bio_list_add(&list, bio);
 
-	atomic_set(&ibr->pending, 2);
-	bio_cnt = 1;
+	atomic_set(&ibr->pending, 1);
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
 		/*
@@ -669,10 +666,6 @@ static int iblock_execute_rw(struct se_cmd *cmd)
 		 */
 		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
 				!= sg->length) {
-			if (bio_cnt >= IBLOCK_MAX_BIO_PER_TASK) {
-				iblock_submit_bios(&list, rw);
-				bio_cnt = 0;
-			}
 
 			bio = iblock_get_bio(cmd, block_lba, sg_num);
 			if (!bio)
@@ -680,7 +673,6 @@ static int iblock_execute_rw(struct se_cmd *cmd)
 
 			atomic_inc(&ibr->pending);
 			bio_list_add(&list, bio);
-			bio_cnt++;
 		}
 
 		/* Always in 512 byte units for Linux/Block */
@@ -689,7 +681,6 @@ static int iblock_execute_rw(struct se_cmd *cmd)
 	}
 
 	iblock_submit_bios(&list, rw);
-	iblock_complete_cmd(cmd);
 	return 0;
 
 fail_put_bios:
-- 
1.7.2.5
