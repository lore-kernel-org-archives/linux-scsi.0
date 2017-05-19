From: Manish Rangankar <manish.rangankar@cavium.com>
Subject: [PATCH 3/7] qedi: Set dma_boundary to 0xfff.
Date: Fri, 19 May 2017 01:33:17 -0700
Message-ID: <20170519083321.18030-4-manish.rangankar@cavium.com>
References: <20170519083321.18030-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0084.outbound.protection.outlook.com ([104.47.42.84]:15076
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751329AbdESIde (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 04:33:34 -0400
In-Reply-To: <20170519083321.18030-1-manish.rangankar@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
---
 drivers/scsi/qedi/qedi.h       | 1 +
 drivers/scsi/qedi/qedi_iscsi.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/scsi/qedi/qedi.h b/drivers/scsi/qedi/qedi.h
index 269dac6..32632c9 100644
--- a/drivers/scsi/qedi/qedi.h
+++ b/drivers/scsi/qedi/qedi.h
@@ -63,6 +63,7 @@
 #define QEDI_PAGE_MASK		(~((QEDI_PAGE_SIZE) - 1))
 
 #define QEDI_PAGE_SIZE		4096
+#define QEDI_HW_DMA_BOUNDARY	0xfff
 #define QEDI_PATH_HANDLE	0xFE0000000UL
 
 struct qedi_uio_ctrl {
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 3548d46..1917793 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -59,6 +59,7 @@ struct scsi_host_template qedi_host_template = {
 	.this_id = -1,
 	.sg_tablesize = QEDI_ISCSI_MAX_BDS_PER_CMD,
 	.max_sectors = 0xffff,
+	.dma_boundary = QEDI_HW_DMA_BOUNDARY,
 	.cmd_per_lun = 128,
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = qedi_shost_attrs,
-- 
1.8.3.1
