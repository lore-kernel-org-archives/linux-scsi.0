From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] qlogicpti: Fix resource releasing in order handling path
Date: Mon,  8 May 2017 13:42:14 +0200
Message-ID: <20170508114214.17730-1-christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

Reorder 'fail_free_irq' and 'fail_unmap_regs' in order to correctly free
resources  in case of error.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/qlogicpti.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 69bfc0a1aea3..e5aeb26bd9b1 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1385,6 +1385,9 @@ static int qpti_sbus_probe(struct platform_device *op)
 			  qpti->req_cpu, qpti->req_dvma);
 #undef QSIZE
 
+fail_free_irq:
+	free_irq(qpti->irq, qpti);
+
 fail_unmap_regs:
 	of_iounmap(&op->resource[0], qpti->qregs,
 		   resource_size(&op->resource[0]));
@@ -1392,9 +1395,6 @@ static int qpti_sbus_probe(struct platform_device *op)
 		of_iounmap(&op->resource[0], qpti->sreg,
 			   sizeof(unsigned char));
 
-fail_free_irq:
-	free_irq(qpti->irq, qpti);
-
 fail_unlink:
 	scsi_host_put(host);
 
-- 
2.11.0
