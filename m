From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 04/12] qla4xxx: use correct fw_ddb_index in abort task
Date: Thu, 2 Dec 2010 22:12:22 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872243F411B@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:3240 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab0LCGMY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2010 01:12:24 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Karen Higgins <karen.higgins@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    3 +--
 drivers/scsi/qla4xxx/ql4_mbx.c |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 0f3bfc3..060e64f 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -175,7 +175,7 @@
 struct srb {
 	struct list_head list;	/* (8)	 */
 	struct scsi_qla_host *ha;	/* HA the SP is queued on */
-	struct ddb_entry	*ddb;
+	struct ddb_entry *ddb;
 	uint16_t flags;		/* (1) Status flags. */
 
 #define SRB_DMA_VALID		BIT_3	/* DMA Buffer mapped. */
@@ -191,7 +191,6 @@ struct srb {
 	struct scsi_cmnd *cmd;	/* (4) SCSI command block */
 	dma_addr_t dma_handle;	/* (4) for unmap of single transfers */
 	struct kref srb_ref;	/* reference count for this srb */
-	uint32_t fw_ddb_index;
 	uint8_t err_id;		/* error id */
 #define SRB_ERR_PORT	   1	/* Request failed because "port down" */
 #define SRB_ERR_LOOP	   2	/* Request failed because "loop down" */
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 2d2f9c8..8961d4c 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -934,7 +934,7 @@ int qla4xxx_abort_task(struct scsi_qla_host *ha, struct srb *srb)
 		return status;
 
 	mbox_cmd[0] = MBOX_CMD_ABORT_TASK;
-	mbox_cmd[1] = srb->fw_ddb_index;
+	mbox_cmd[1] = srb->ddb->fw_ddb_index;
 	mbox_cmd[2] = index;
 	/* Immediate Command Enable */
 	mbox_cmd[5] = 0x01;
-- 
1.7.3.2

