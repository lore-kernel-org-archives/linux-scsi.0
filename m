From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 52/87] scsi: qlogicpti: remove memset after dma_alloc_coherent in qlogicpti.c
Date: Fri, 28 Jun 2019 01:42:33 +0800
Message-ID: <20190627174233.4776-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/qlogicpti.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 9335849f6bea..7868db052042 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -828,8 +828,6 @@ static int qpti_map_queues(struct qlogicpti *qpti)
 		printk("QPTI: Cannot map request queue.\n");
 		return -1;
 	}
-	memset(qpti->res_cpu, 0, QSIZE(RES_QUEUE_LEN));
-	memset(qpti->req_cpu, 0, QSIZE(QLOGICPTI_REQ_QUEUE_LEN));
 	return 0;
 }
 
-- 
2.11.0
