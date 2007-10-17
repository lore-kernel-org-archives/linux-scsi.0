From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 20/32] in2000.c: convert to accessors and !use_sg cleanup
Date: Wed, 17 Oct 2007 20:05:27 +0200
Message-ID: <47164EE7.7040406@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:1925 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753685AbXJQSH2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 14:07:28 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


 - convert to accessors and !use_sg cleanup

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/in2000.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index ab7cbf3..ced38de 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -369,16 +369,16 @@ static int in2000_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
  *  - SCp.phase records this command's SRCID_ER bit setting
  */
 
-	if (cmd->use_sg) {
-		cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
-		cmd->SCp.buffers_residual = cmd->use_sg - 1;
+	if (scsi_bufflen(cmd)) {
+		cmd->SCp.buffer = scsi_sglist(cmd);
+		cmd->SCp.buffers_residual = scsi_sg_count(cmd) - 1;
 		cmd->SCp.ptr = (char *) page_address(cmd->SCp.buffer->page) + cmd->SCp.buffer->offset;
 		cmd->SCp.this_residual = cmd->SCp.buffer->length;
 	} else {
 		cmd->SCp.buffer = NULL;
 		cmd->SCp.buffers_residual = 0;
-		cmd->SCp.ptr = (char *) cmd->request_buffer;
-		cmd->SCp.this_residual = cmd->request_bufflen;
+		cmd->SCp.ptr = NULL;
+		cmd->SCp.this_residual = 0;
 	}
 	cmd->SCp.have_data_in = 0;
 
-- 
1.5.3.1


