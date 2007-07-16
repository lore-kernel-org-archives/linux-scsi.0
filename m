From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 15/33] scsi: simplify scsi_free_sgtable()
Date: Mon, 16 Jul 2007 11:47:29 +0200
Message-ID: <11845792682917-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9298 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760575AbXGPJsi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:38 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com

Just pass in the command, no point in passing in the scatterlist
and scatterlist pool index seperately.

Cc: fujita.tomonori@lab.ntt.co.jp
Cc: James.Bottomley@SteelEye.com
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/scsi_lib.c     |    9 +++++----
 drivers/scsi/scsi_tgt_lib.c |    4 ++--
 include/scsi/scsi_cmnd.h    |    2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9fe66f8..0b4610c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -746,13 +746,14 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 
 EXPORT_SYMBOL(scsi_alloc_sgtable);
 
-void scsi_free_sgtable(struct scatterlist *sgl, int index)
+void scsi_free_sgtable(struct scsi_cmnd *cmd)
 {
+	struct scatterlist *sgl = cmd->request_buffer;
 	struct scsi_host_sg_pool *sgp;
 
-	BUG_ON(index >= SG_MEMPOOL_NR);
+	BUG_ON(cmd->sglist_len >= SG_MEMPOOL_NR);
 
-	sgp = scsi_sg_pools + index;
+	sgp = scsi_sg_pools + cmd->sglist_len;
 	mempool_free(sgl, sgp->pool);
 }
 
@@ -778,7 +779,7 @@ EXPORT_SYMBOL(scsi_free_sgtable);
 static void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
 	if (cmd->use_sg)
-		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
+		scsi_free_sgtable(cmd);
 
 	/*
 	 * Zero these out.  They now point to freed memory, and it is
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 2570f48..d6e58e5 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -329,7 +329,7 @@ static void scsi_tgt_cmd_done(struct scsi_cmnd *cmd)
 	scsi_tgt_uspace_send_status(cmd, tcmd->tag);
 
 	if (cmd->request_buffer)
-		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
+		scsi_free_sgtable(cmd);
 
 	queue_work(scsi_tgtd, &tcmd->work);
 }
@@ -370,7 +370,7 @@ static int scsi_tgt_init_cmd(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 	}
 
 	eprintk("cmd %p cnt %d\n", cmd, cmd->use_sg);
-	scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
+	scsi_free_sgtable(cmd);
 	return -EINVAL;
 }
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a059f1b..760d4a5 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -133,7 +133,7 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 extern void scsi_kunmap_atomic_sg(void *virt);
 
 extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
-extern void scsi_free_sgtable(struct scatterlist *, int);
+extern void scsi_free_sgtable(struct scsi_cmnd *);
 
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
-- 
1.5.3.rc0.90.gbaa79

