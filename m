From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 23/33] qlogicpti: sg chaining support
Date: Mon, 16 Jul 2007 11:47:37 +0200
Message-ID: <1184579268290-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9331 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761371AbXGPJsj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:39 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, davem@davemloft.net

Cc: davem@davemloft.net
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/qlogicpti.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index c4195ea..e36e6cd 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -868,7 +868,7 @@ static inline int load_cmd(struct scsi_cmnd *Cmnd, struct Command_Entry *cmd,
 			   struct qlogicpti *qpti, u_int in_ptr, u_int out_ptr)
 {
 	struct dataseg *ds;
-	struct scatterlist *sg;
+	struct scatterlist *sg, *s;
 	int i, n;
 
 	if (Cmnd->use_sg) {
@@ -884,11 +884,12 @@ static inline int load_cmd(struct scsi_cmnd *Cmnd, struct Command_Entry *cmd,
 		n = sg_count;
 		if (n > 4)
 			n = 4;
-		for (i = 0; i < n; i++, sg++) {
-			ds[i].d_base = sg_dma_address(sg);
-			ds[i].d_count = sg_dma_len(sg);
+		for_each_sg(sg, s, n, i) {
+			ds[i].d_base = sg_dma_address(s);
+			ds[i].d_count = sg_dma_len(g);
 		}
 		sg_count -= 4;
+		sg = s;
 		while (sg_count > 0) {
 			struct Continuation_Entry *cont;
 
@@ -907,9 +908,9 @@ static inline int load_cmd(struct scsi_cmnd *Cmnd, struct Command_Entry *cmd,
 			n = sg_count;
 			if (n > 7)
 				n = 7;
-			for (i = 0; i < n; i++, sg++) {
-				ds[i].d_base = sg_dma_address(sg);
-				ds[i].d_count = sg_dma_len(sg);
+			for_each_sg(sg, s, n, i) {
+				ds[i].d_base = sg_dma_address(s);
+				ds[i].d_count = sg_dma_len(s);
 			}
 			sg_count -= n;
 		}
-- 
1.5.3.rc0.90.gbaa79

