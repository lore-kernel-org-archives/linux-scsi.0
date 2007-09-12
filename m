From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 10/24] eata_pio.c: convert to accessors and !use_sg cleanup
Date: Wed, 12 Sep 2007 03:00:05 +0300
Message-ID: <46E72C05.4030405@panasas.com>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:6878 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965735AbXILAAj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 20:00:39 -0400
In-Reply-To: <46E6F92D.2090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


 - convert to accessors and !use_sg cleanup

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/eata_pio.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index f33ad01..266ddc9 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -400,7 +400,7 @@ static int eata_pio_queue(struct scsi_cmnd *cmd,
 		cp->DataIn = 0;	/* Input mode  */
 
 	cp->Interpret = (cmd->device->id == hd->hostid);
-	cp->cp_datalen = cpu_to_be32(cmd->request_bufflen);
+	cp->cp_datalen = cpu_to_be32(scsi_bufflen(cmd));
 	cp->Auto_Req_Sen = 0;
 	cp->cp_reqDMA = 0;
 	cp->reqlen = 0;
@@ -417,14 +417,14 @@ static int eata_pio_queue(struct scsi_cmnd *cmd,
 	cp->cmd = cmd;
 	cmd->host_scribble = (char *) &hd->ccb[y];
 
-	if (cmd->use_sg == 0) {
+	if (!scsi_bufflen(cmd)) {
 		cmd->SCp.buffers_residual = 1;
-		cmd->SCp.ptr = cmd->request_buffer;
-		cmd->SCp.this_residual = cmd->request_bufflen;
+		cmd->SCp.ptr = NULL;
+		cmd->SCp.this_residual = 0;
 		cmd->SCp.buffer = NULL;
 	} else {
-		cmd->SCp.buffer = cmd->request_buffer;
-		cmd->SCp.buffers_residual = cmd->use_sg;
+		cmd->SCp.buffer = scsi_sglist(cmd);
+		cmd->SCp.buffers_residual = scsi_sg_count(cmd);
 		cmd->SCp.ptr = page_address(cmd->SCp.buffer->page) + cmd->SCp.buffer->offset;
 		cmd->SCp.this_residual = cmd->SCp.buffer->length;
 	}
-- 
1.5.3.1


