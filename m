From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] scsi: qla4xxx: Use dma_pool_zalloc()
Date: Thu, 15 Feb 2018 00:30:20 +0530
Message-ID: <20180214190020.GA5566@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:37289 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162210AbeBNS7E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Feb 2018 13:59:04 -0500
Received: by mail-pl0-f67.google.com with SMTP id ay8so9041738plb.4
        for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2018 10:59:04 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com
Cc: linux-scsi@vger.kernel.org

Use dma_pool_zalloc() instead of dma_pool_alloc + memset

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c | 6 ++----
 drivers/scsi/qla4xxx/ql4_os.c  | 4 +---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index bda2e64..5d56904 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1584,12 +1584,11 @@ int qla4xxx_get_chap(struct scsi_qla_host *ha, char *username, char *password,
 	struct ql4_chap_table *chap_table;
 	dma_addr_t chap_dma;

-	chap_table = dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
+	chap_table = dma_pool_zalloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
 	if (chap_table == NULL)
 		return -ENOMEM;

 	chap_size = sizeof(struct ql4_chap_table);
-	memset(chap_table, 0, chap_size);

 	if (is_qla40XX(ha))
 		offset = FLASH_CHAP_OFFSET | (idx * chap_size);
@@ -1648,13 +1647,12 @@ int qla4xxx_set_chap(struct scsi_qla_host *ha, char *username, char *password,
 	uint32_t chap_size = 0;
 	dma_addr_t chap_dma;

-	chap_table = dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
+	chap_table = dma_pool_zalloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
 	if (chap_table == NULL) {
 		ret =  -ENOMEM;
 		goto exit_set_chap;
 	}

-	memset(chap_table, 0, sizeof(struct ql4_chap_table));
 	if (bidi)
 		chap_table->flags |= BIT_6; /* peer */
 	else
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 82e889b..5896343 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -825,12 +825,10 @@ static int qla4xxx_delete_chap(struct Scsi_Host *shost, uint16_t chap_tbl_idx)
 	uint32_t chap_size;
 	int ret = 0;

-	chap_table = dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
+	chap_table = dma_pool_zalloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
 	if (chap_table == NULL)
 		return -ENOMEM;

-	memset(chap_table, 0, sizeof(struct ql4_chap_table));
-
 	if (is_qla80XX(ha))
 		max_chap_entries = (ha->hw.flt_chap_size / 2) /
 				   sizeof(struct ql4_chap_table);
--
1.9.1
