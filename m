From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] scsi: qla4xxx: Use dma_pool_zalloc
Date: Wed, 7 Dec 2016 01:53:04 +0530
Message-ID: <20161206202304.GA6884@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33123 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753200AbcLFUXJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2016 15:23:09 -0500
Received: by mail-pg0-f68.google.com with SMTP id 3so20873916pgd.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Dec 2016 12:23:09 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com
Cc: linux-scsi@vger.kernel.org

We should use dma_pool_zalloc instead of dma_pool_alloc/memset

Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index c291fdf..f2edfd7 100644
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
--
1.9.1

