From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 17/24] in2000.c: convert to accessors and !use_sg cleanup
Date: Wed, 12 Sep 2007 03:06:26 +0300
Message-ID: <46E72D82.6020101@panasas.com>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:10214 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761097AbXILAKc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 20:10:32 -0400
In-Reply-To: <46E6F92D.2090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


 - convert to accessors and !use_sg cleanup

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/in2000.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 312190a..31e841c 100644
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


