From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] scsi: cxgbi: add null check before pointer dereference
Date: Mon, 22 May 2017 11:03:28 -0500
Message-ID: <20170522160328.GA15668@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

Add null check before dereferencing pointer _sg_ inside sg_next()

Addresses-Coverity-ID: 1364845
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index bd7d39e..6119ddf 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1256,15 +1256,18 @@ void cxgbi_ddp_set_one_ppod(struct cxgbi_pagepod *ppod,
 		*sg_off = offset;
 	}
 
-	if (offset == len) {
-		offset = 0;
-		sg = sg_next(sg);
-		if (sg) {
-			addr = sg_dma_address(sg);
-			len = sg_dma_len(sg);
+	if (sg) {
+		if (offset == len) {
+			offset = 0;
+			sg = sg_next(sg);
+			if (sg) {
+				addr = sg_dma_address(sg);
+				len = sg_dma_len(sg);
+			}
 		}
-	}
-	ppod->addr[i] = sg ? cpu_to_be64(addr + offset) : 0ULL;
+		ppod->addr[i] = cpu_to_be64(addr + offset);
+	} else
+		ppod->addr[i] = 0ULL;
 }
 EXPORT_SYMBOL_GPL(cxgbi_ddp_set_one_ppod);
 
-- 
2.5.0
