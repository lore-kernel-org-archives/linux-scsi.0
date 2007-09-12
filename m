From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 16/24] imm.c: convert to accessors and !use_sg cleanup
Date: Wed, 12 Sep 2007 03:05:24 +0300
Message-ID: <46E72D44.8000200@panasas.com>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:29877 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757697AbXILAF5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 20:05:57 -0400
In-Reply-To: <46E6F92D.2090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


 - convert to accessors and !use_sg cleanup
 - Not ready for sg-chaining

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/imm.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 005d2b0..5ee4e0a 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -843,21 +843,18 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
 
 		/* Phase 4 - Setup scatter/gather buffers */
 	case 4:
-		if (cmd->use_sg) {
-			/* if many buffers are available, start filling the first */
-			cmd->SCp.buffer =
-			    (struct scatterlist *) cmd->request_buffer;
+		if (scsi_bufflen(cmd)) {
+			cmd->SCp.buffer = scsi_sglist(cmd);
 			cmd->SCp.this_residual = cmd->SCp.buffer->length;
 			cmd->SCp.ptr =
 			    page_address(cmd->SCp.buffer->page) +
 			    cmd->SCp.buffer->offset;
 		} else {
-			/* else fill the only available buffer */
 			cmd->SCp.buffer = NULL;
-			cmd->SCp.this_residual = cmd->request_bufflen;
-			cmd->SCp.ptr = cmd->request_buffer;
+			cmd->SCp.this_residual = 0;
+			cmd->SCp.ptr = NULL;
 		}
-		cmd->SCp.buffers_residual = cmd->use_sg - 1;
+		cmd->SCp.buffers_residual = scsi_sg_count(cmd) - 1;
 		cmd->SCp.phase++;
 		if (cmd->SCp.this_residual & 0x01)
 			cmd->SCp.this_residual++;
-- 
1.5.3.1


