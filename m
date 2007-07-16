From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 28/33] ia64 simscsi: convert to use data buffer accessors
Date: Mon, 16 Jul 2007 11:47:42 +0200
Message-ID: <11845792683756-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9295 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762623AbXGPJsm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:42 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, tony.luck@intel.com

Cc: tony.luck@intel.com
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/ia64/hp/sim/simscsi.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index bb87682..aedce13 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -173,7 +173,7 @@ simscsi_sg_readwrite (struct scsi_cmnd *sc, int mode, unsigned long offset)
 			return;
 		}
 		offset +=  sl->length;
-		sl++;
+		sl = sg_next(sl);
 		list_len--;
 	}
 	sc->result = GOOD;
@@ -239,18 +239,22 @@ simscsi_readwrite10 (struct scsi_cmnd *sc, int mode)
 static void simscsi_fillresult(struct scsi_cmnd *sc, char *buf, unsigned len)
 {
 
-	int scatterlen = sc->use_sg;
-	struct scatterlist *slp;
+	int scatterlen = sc->use_sg, i;
+	struct scatterlist *sg;
 
 	if (scatterlen == 0)
 		memcpy(sc->request_buffer, buf, len);
-	else for (slp = (struct scatterlist *)sc->request_buffer;
-		  scatterlen-- > 0 && len > 0; slp++) {
-		unsigned thislen = min(len, slp->length);
+	else {
+		scsi_for_each_sg(sc, sg, scatterlen, i) {
+			unsigned thislen;
 
-		memcpy(page_address(slp->page) + slp->offset, buf, thislen);
-		slp++;
-		len -= thislen;
+			if (len <= 0)
+				break;
+
+			thislen = min(len, sg->length);
+			memcpy(page_address(sg->page) + sg->offset, buf, thislen);
+			len -= thislen;
+		}
 	}
 }
 
-- 
1.5.3.rc0.90.gbaa79

