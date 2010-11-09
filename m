From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm/pscsi: Fix failure case for __pscsi_map_task_SG()
Date: Mon,  8 Nov 2010 22:03:11 -0800
Message-ID: <1289282591-20853-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm16.bullet.mail.ac4.yahoo.com ([98.139.52.213]:33789 "HELO
	nm16.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751273Ab0KIGDO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 01:03:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

The 'ret' value in __pscsi_map_task_SG() needs to be set to the failure
code that will be handled in transport_generic_new_cmd() as each
struct se_task->transport_map_task() is executed.  This patch fixes
the pSCSI se_task map_task_SG() callers to return the OUT_OF_MEMORY
macro from target_core_transport.h to signal a failure and build
the necessary sense data.

It also changes bio_add_pc_page() to use 'rc' to make this slightly
less confusing..

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 6a31bed..7387350 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1057,7 +1057,7 @@ static int __pscsi_map_task_SG(
 	u32 data_len = task->task_size, i, len, bytes, off;
 	int nr_pages = (task->task_size + task_sg[0].offset +
 			PAGE_SIZE - 1) >> PAGE_SHIFT;
-	int nr_vecs = 0, ret = 0;
+	int nr_vecs = 0, rc, ret = PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
 	int rw = (TASK_CMD(task)->data_direction == DMA_TO_DEVICE);
 
 	if (!task->task_size)
@@ -1119,9 +1119,9 @@ static int __pscsi_map_task_SG(
 				" bio: %p page: %p len: %d off: %d\n", i, bio,
 				page, len, off);
 
-			ret = bio_add_pc_page(pdv->pdv_sd->request_queue,
+			rc = bio_add_pc_page(pdv->pdv_sd->request_queue,
 					bio, page, bytes, off);
-			if (ret != bytes)
+			if (rc != bytes)
 				goto fail;
 
 			DEBUG_PSCSI("PSCSI: bio->bi_vcnt: %d nr_vecs: %d\n",
-- 
1.5.6.5

