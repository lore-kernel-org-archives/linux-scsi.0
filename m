From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH 14/15] qedf: Add change_queue_depth member to scsi_host_template().
Date: Tue, 23 May 2017 06:19:30 -0700
Message-ID: <20170523131931.1777-15-chad.dupuis@cavium.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0073.outbound.protection.outlook.com ([104.47.36.73]:64688
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S937119AbdEWNT5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 May 2017 09:19:57 -0400
In-Reply-To: <20170523131931.1777-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Add the change_queue_depth member to our SCSI host template so the queue
depth of devices attached to qedf can be changed dynamically.

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index bc85c56..5610803 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -722,6 +722,7 @@ static int qedf_slave_configure(struct scsi_device *sdev)
 	.dma_boundary = QED_HW_DMA_BOUNDARY,
 	.sg_tablesize = QEDF_MAX_BDS_PER_CMD,
 	.can_queue = FCOE_PARAMS_NUM_TASKS,
+	.change_queue_depth = scsi_change_queue_depth,
 };
 
 static int qedf_get_paged_crc_eof(struct sk_buff *skb, int tlen)
-- 
1.8.5.6
