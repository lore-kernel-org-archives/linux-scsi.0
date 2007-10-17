From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 17/32] ppa.c: convert to accessors and !use_sg cleanup
Date: Wed, 17 Oct 2007 20:00:49 +0200
Message-ID: <47164DD1.9090806@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:3205 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754144AbXJQSB5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 14:01:57 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>

[PATCH 17/32] ppa.c: convert to accessors and !use_sg cleanup

 - convert to accessors and !use_sg cleanup

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/ppa.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 67b6d76..f9fdc8a 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -752,19 +752,17 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 		cmd->SCp.phase++;
 
 	case 4:		/* Phase 4 - Setup scatter/gather buffers */
-		if (cmd->use_sg) {
-			/* if many buffers are available, start filling the first */
-			cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
+		if (scsi_bufflen(cmd)) {
+			cmd->SCp.buffer = scsi_sglist(cmd);
 			cmd->SCp.this_residual = cmd->SCp.buffer->length;
 			cmd->SCp.ptr = page_address(cmd->SCp.buffer->page) +
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
 
 	case 5:		/* Phase 5 - Data transfer stage */
-- 
1.5.3.1


