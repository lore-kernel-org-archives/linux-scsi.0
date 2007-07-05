From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 5/8] Remove old code from scsi_lib.c
Date: Thu, 05 Jul 2007 16:43:50 +0300
Message-ID: <468CF596.8010700@panasas.com>
References: <468CDB3C.4060500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27077 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757708AbXGENoJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 09:44:09 -0400
In-Reply-To: <468CDB3C.4060500@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>


   For easier viewing old code is removed in this patch.
   Also SCSI_MAX_PHYS_SEGMENTS is no longer used. Remove it.

 Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c  |   55 ----------------------------------------------
 include/scsi/scsi.h      |    7 ------
 include/scsi/scsi_cmnd.h |    1 -
 3 files changed, 0 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a5505ec..56829bf 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -733,61 +733,6 @@ static struct scsi_sgtable *_scsi_alloc_sgtable(int sg_count, gfp_t gfp_mask)
 	return sgt;
 }
 
-struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
-{
-	struct scsi_host_sg_pool *sgp;
-	struct scatterlist *sgl;
-
-	BUG_ON(!cmd->use_sg);
-
-	switch (cmd->use_sg) {
-	case 1 ... 8:
-		cmd->sglist_len = 0;
-		break;
-	case 9 ... 16:
-		cmd->sglist_len = 1;
-		break;
-	case 17 ... 32:
-		cmd->sglist_len = 2;
-		break;
-#if (SCSI_MAX_PHYS_SEGMENTS > 32)
-	case 33 ... 64:
-		cmd->sglist_len = 3;
-		break;
-#if (SCSI_MAX_PHYS_SEGMENTS > 64)
-	case 65 ... 128:
-		cmd->sglist_len = 4;
-		break;
-#if (SCSI_MAX_PHYS_SEGMENTS  > 128)
-	case 129 ... 256:
-		cmd->sglist_len = 5;
-		break;
-#endif
-#endif
-#endif
-	default:
-		return NULL;
-	}
-
-	sgp = scsi_sg_pools + cmd->sglist_len;
-	sgl = mempool_alloc(sgp->pool, gfp_mask);
-	return sgl;
-}
-
-EXPORT_SYMBOL(scsi_alloc_sgtable);
-
-void scsi_free_sgtable(struct scatterlist *sgl, int index)
-{
-	struct scsi_host_sg_pool *sgp;
-
-	BUG_ON(index >= SG_MEMPOOL_NR);
-
-	sgp = scsi_sg_pools + index;
-	mempool_free(sgl, sgp->pool);
-}
-
-EXPORT_SYMBOL(scsi_free_sgtable);
-
 /*
  * Function:    scsi_release_buffers()
  *
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 9f8f80a..702fcfe 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -11,13 +11,6 @@
 #include <linux/types.h>
 
 /*
- *	The maximum sg list length SCSI can cope with
- *	(currently must be a power of 2 between 32 and 256)
- */
-#define SCSI_MAX_PHYS_SEGMENTS	MAX_PHYS_SEGMENTS
-
-
-/*
  *	SCSI command lengths
  */
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index d408d93..4b87c0f 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -120,7 +120,6 @@ struct scsi_cmnd {
 	unsigned char tag;	/* SCSI-II queued command tag */
 	unsigned long pid;	/* Process ID, starts at 0. Unique per host. */
 
-	unsigned short sglist_len;
 	unsigned short __deprecated use_sg;
 	unsigned __deprecated request_bufflen;
 	void __deprecated *request_buffer;
-- 
1.5.2.2.249.g45fd


