From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] qla2xxx: use struct t10_pi_tuple
Date: Sun, 11 Sep 2016 19:35:40 +0200
Message-ID: <1473615341-27203-3-git-send-email-hch@lst.de>
References: <1473615341-27203-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46209 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932307AbcIKRfu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2016 13:35:50 -0400
In-Reply-To: <1473615341-27203-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

Instead of defining a local version of it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/qla2xxx/qla_def.h | 10 ----------
 drivers/scsi/qla2xxx/qla_isr.c |  2 +-
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ae4a747..73b12e4 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -279,16 +279,6 @@ struct req_que;
 struct qla_tgt_sess;
 
 /*
- * (sd.h is not exported, hence local inclusion)
- * Data Integrity Field tuple.
- */
-struct sd_dif_tuple {
-	__be16 guard_tag;	/* Checksum */
-	__be16 app_tag;		/* Opaque storage */
-	__be32 ref_tag;		/* Target LBA or indirect LBA */
-};
-
-/*
  * SCSI Request Block
  */
 struct srb_cmd {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 987f1c7..068c4e4 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1828,7 +1828,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 		if (scsi_prot_sg_count(cmd)) {
 			uint32_t i, j = 0, k = 0, num_ent;
 			struct scatterlist *sg;
-			struct sd_dif_tuple *spt;
+			struct t10_pi_tuple *spt;
 
 			/* Patch the corresponding protection tags */
 			scsi_for_each_prot_sg(cmd, sg,
-- 
2.1.4

