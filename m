From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] scsi/qla4xxx/ql4_isr.c: remove dead code
Date: Tue, 19 Feb 2008 21:29:22 +0200
Message-ID: <20080219192922.GH31955@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:36968 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756175AbYBST36 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 14:29:58 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Somayajulu <david.somayajulu@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This patch removes dead code spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/qla4xxx/ql4_isr.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

--- linux-2.6/drivers/scsi/qla4xxx/ql4_isr.c.old	2008-02-19 20:29:16.000000000 +0200
+++ linux-2.6/drivers/scsi/qla4xxx/ql4_isr.c	2008-02-19 20:30:37.000000000 +0200
@@ -91,38 +91,22 @@ static void qla4xxx_status_entry(struct 
 		if (scsi_status == 0) {
 			cmd->result = DID_OK << 16;
 			break;
 		}
 
 		if (sts_entry->iscsiFlags & ISCSI_FLAG_RESIDUAL_OVER) {
 			cmd->result = DID_ERROR << 16;
 			break;
 		}
 
-		if (sts_entry->iscsiFlags &ISCSI_FLAG_RESIDUAL_UNDER) {
+		if (sts_entry->iscsiFlags &ISCSI_FLAG_RESIDUAL_UNDER)
 			scsi_set_resid(cmd, residual);
-			if (!scsi_status && ((scsi_bufflen(cmd) - residual) <
-				cmd->underflow)) {
-
-				cmd->result = DID_ERROR << 16;
-
-				DEBUG2(printk("scsi%ld:%d:%d:%d: %s: "
-					"Mid-layer Data underrun0, "
-					"xferlen = 0x%x, "
-					"residual = 0x%x\n", ha->host_no,
-					cmd->device->channel,
-					cmd->device->id,
-					cmd->device->lun, __func__,
-					scsi_bufflen(cmd), residual));
-				break;
-			}
-		}
 
 		cmd->result = DID_OK << 16 | scsi_status;
 
 		if (scsi_status != SCSI_CHECK_CONDITION)
 			break;
 
 		/* Copy Sense Data into sense buffer. */
 		memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 
 		sensebytecnt = le16_to_cpu(sts_entry->senseDataByteCnt);

