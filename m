From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 63/87] scsi: ips.c: remove memset after dma_alloc_coherent
Date: Fri, 28 Jun 2019 01:44:57 +0800
Message-ID: <20190627174458.5730-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/ips.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index e8bc8d328bab..ad941bb28060 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -4322,8 +4322,6 @@ ips_allocatescbs(ips_ha_t * ha)
 		return 0;
 	}
 
-	memset(ha->scbs, 0, ha->max_cmds * sizeof (ips_scb_t));
-
 	for (i = 0; i < ha->max_cmds; i++) {
 		scb_p = &ha->scbs[i];
 		scb_p->scb_busaddr = command_dma + sizeof (ips_scb_t) * i;
-- 
2.11.0
