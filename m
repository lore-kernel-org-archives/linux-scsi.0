From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 31/33] Fusion: sg chaining support
Date: Mon, 16 Jul 2007 11:47:45 +0200
Message-ID: <11845792691073-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9353 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762681AbXGPJsm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:42 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, Eric.Moore@lsi.com

Cc: Eric.Moore@lsi.com
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/message/fusion/mptscsih.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index d356173..f087249 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -297,7 +297,7 @@ nextSGEset:
 		v2 = sg_dma_address(sg);
 		mptscsih_add_sge(psge, sgflags | thisxfer, v2);
 
-		sg++;		/* Get next SG element from the OS */
+		sg = sg_next(sg);	/* Get next SG element from the OS */
 		psge += (sizeof(u32) + sizeof(dma_addr_t));
 		sgeOffset += (sizeof(u32) + sizeof(dma_addr_t));
 		sg_done++;
@@ -318,7 +318,7 @@ nextSGEset:
 		v2 = sg_dma_address(sg);
 		mptscsih_add_sge(psge, sgflags | thisxfer, v2);
 		/*
-		sg++;
+		sg = sg_next(sg);
 		psge += (sizeof(u32) + sizeof(dma_addr_t));
 		*/
 		sgeOffset += (sizeof(u32) + sizeof(dma_addr_t));
-- 
1.5.3.rc0.90.gbaa79

