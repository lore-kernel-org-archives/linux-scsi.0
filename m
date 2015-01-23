From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 12/17] ncr53c8xx: Fix bidi command support
Date: Fri, 23 Jan 2015 13:12:23 +0100
Message-ID: <54C23AA7.1050608@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0082.outbound.protection.outlook.com ([157.56.110.82]:24400
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753527AbbAWM1N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:27:13 -0500
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitzmic@gmail.com>
---
 drivers/scsi/ncr53c8xx.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 5b93ed8..b9c489a 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4286,13 +4286,12 @@ static int ncr_queue_command (struct ncb *np, struct scsi_cmnd *cmd)
 		direction = DMA_NONE;
 
 	/*
-	**	If data direction is BIDIRECTIONAL, speculate FROM_DEVICE
+	**	For bidi commands, speculate FROM_DEVICE
 	**	but prepare alternate pointers for TO_DEVICE in case 
 	**	of our speculation will be just wrong.
 	**	SCRIPTS will swap values if needed.
 	*/
 	switch(direction) {
-	case DMA_BIDIRECTIONAL:
 	case DMA_TO_DEVICE:
 		goalp = NCB_SCRIPT_PHYS (np, data_out2) + 8;
 		if (segments <= MAX_SCATTERL)
@@ -4301,7 +4300,7 @@ static int ncr_queue_command (struct ncb *np, struct scsi_cmnd *cmd)
 			lastp = NCB_SCRIPTH_PHYS (np, hdata_out2);
 			lastp -= (segments - MAX_SCATTERL) * 16;
 		}
-		if (direction != DMA_BIDIRECTIONAL)
+		if (!scsi_bidi_cmd(cmd))
 			break;
 		cp->phys.header.wgoalp	= cpu_to_scr(goalp);
 		cp->phys.header.wlastp	= cpu_to_scr(lastp);
@@ -4328,7 +4327,7 @@ static int ncr_queue_command (struct ncb *np, struct scsi_cmnd *cmd)
 	cp->phys.header.lastp = cpu_to_scr(lastp);
 	cp->phys.header.goalp = cpu_to_scr(goalp);
 
-	if (direction == DMA_BIDIRECTIONAL)
+	if (scsi_bidi_cmd(cmd))
 		cp->phys.header.savep = 
 			cpu_to_scr(NCB_SCRIPTH_PHYS (np, data_io));
 	else
-- 
2.1.2

