From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 15/19] lpfc: Fix secure firmware updates
Date: Thu, 21 Sep 2017 23:17:37 -0700
Message-ID: <20170922061741.12347-16-jsmart2021@gmail.com>
References: <20170922061741.12347-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34623 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751809AbdIVGSL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 02:18:11 -0400
Received: by mail-pg0-f68.google.com with SMTP id u18so126740pgo.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 23:18:10 -0700 (PDT)
In-Reply-To: <20170922061741.12347-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Firmware update fails with: status x17 add_status x56 on the final write

If multiple DMA buffers are used for the download, some firmware revs
have difficulty with signatures and crcs split across the dma buffer
boundaries.  Resolve by making all writes be a single 4k page in length.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 1db0a38683f4..2b145966c73f 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3636,7 +3636,7 @@ struct lpfc_mbx_get_port_name {
 #define MB_CEQ_STATUS_QUEUE_FLUSHING		0x4
 #define MB_CQE_STATUS_DMA_FAILED		0x5
 
-#define LPFC_MBX_WR_CONFIG_MAX_BDE		8
+#define LPFC_MBX_WR_CONFIG_MAX_BDE		1
 struct lpfc_mbx_wr_object {
 	struct mbox_header header;
 	union {
-- 
2.13.1
