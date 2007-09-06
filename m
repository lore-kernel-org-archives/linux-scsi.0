From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] remove sglist_len
Date: Thu, 06 Sep 2007 09:19:01 +0100
Message-ID: <20070906091901G.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:55113 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbXIFLqX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2007 07:46:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@SteelEye.com
Cc: fujita.tomonori@lab.ntt.co.jp

This is against Jens' sg chaining branch.

http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=d6beb57f48231f5c012fb7d55b369bc0af6b0c41

The sg chaining patchset adds __use_sg to save the length of sg list
before dma mapping. The sg chaining patchset also uses sglist_len but
we can live without it. So let's remove sglist_len since we can add
something to scsi_cmnd structure only when we definitely need to do.

Now the sg chaining provides a way to decrease memory consumption and
doesn't add anything to scsi_cmnd structure.

James, do you want to change more about the sg chaining's scsi_lib.c?

--
>From b887de7c48a674ace622544addd70ebc8ae31fd2 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 6 Sep 2007 08:41:33 +0100
Subject: [PATCH] remove sglist_len

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c  |   11 ++++-------
 include/scsi/scsi_cmnd.h |    1 -
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2fc2380..1e0f691 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -774,10 +774,8 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 		/*
 		 * first loop through, set initial index and return value
 		 */
-		if (!ret) {
-			cmd->sglist_len = index;
+		if (!ret)
 			ret = sgl;
-		}
 
 		/*
 		 * chain previous sglist, if any. we know the previous
@@ -830,8 +828,6 @@ void scsi_free_sgtable(struct scsi_cmnd *cmd)
 	struct scatterlist *sgl = cmd->request_buffer;
 	struct scsi_host_sg_pool *sgp;
 
-	BUG_ON(cmd->sglist_len >= SG_MEMPOOL_NR);
-
 	/*
 	 * if this is the biggest size sglist, check if we have
 	 * chained parts we need to free
@@ -866,9 +862,10 @@ void scsi_free_sgtable(struct scsi_cmnd *cmd)
 		 * Restore original, will be freed below
 		 */
 		sgl = cmd->request_buffer;
-	}
+		sgp = scsi_sg_pools + SG_MEMPOOL_NR - 1;
+	} else
+		sgp = scsi_sg_pools + scsi_sgtable_index(cmd->__use_sg);
 
-	sgp = scsi_sg_pools + cmd->sglist_len;
 	mempool_free(sgl, sgp->pool);
 }
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 6263c4e..bb6358a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -72,7 +72,6 @@ struct scsi_cmnd {
 
 	/* These elements define the operation we ultimately want to perform */
 	unsigned short use_sg;	/* Number of pieces of scatter-gather */
-	unsigned short sglist_len;	/* size of malloc'd scatter-gather list */
 	unsigned short __use_sg;
 
 	unsigned underflow;	/* Return error if less than
-- 
1.5.2.4

