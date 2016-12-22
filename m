From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH v2] scsi: qla4xxx: Use dma_pool_zalloc
Date: Thu, 22 Dec 2016 17:42:58 +0530
Message-ID: <20161222121258.GA8278@gnr743-HP-ZBook-15>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34767 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938786AbcLVMNt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2016 07:13:49 -0500
Received: by mail-pg0-f65.google.com with SMTP id b1so19951440pgc.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2016 04:13:01 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nilesh.Javali@cavium.com, QLogic-Storage-Upstream@qlogic.com
Cc: linux-scsi@vger.kernel.org, sahu.rameshwar73@gmail.com

We should use dma_pool_zalloc instead of dma_pool_alloc/memset

Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
---
v2 changes:
   - Address comment from Nilesh to make same change in
     all applicable places inside qla4xxx source

 drivers/scsi/qla4xxx/ql4_mbx.c | 6 ++----
 drivers/scsi/qla4xxx/ql4_os.c  | 4 +---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index c291fdf..8f97839 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1587,12 +1587,11 @@ int qla4xxx_get_chap(struct scsi_qla_host *ha, char *username, char *password,
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
@@ -1651,13 +1650,12 @@ int qla4xxx_set_chap(struct scsi_qla_host *ha, char *username, char *password,
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
index 01c3610..0c91c89 100644
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

