From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 64/87] scsi: esas2r: remove memset after dma_alloc_coherent
Date: Fri, 28 Jun 2019 01:45:08 +0800
Message-ID: <20190627174508.5782-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/esas2r/esas2r_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 950cd92df2ff..67e7a78f408b 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -390,7 +390,6 @@ int esas2r_init_adapter(struct Scsi_Host *host, struct pci_dev *pcid,
 		     a->uncached,
 		     upper_32_bits(bus_addr),
 		     lower_32_bits(bus_addr));
-	memset(a->uncached, 0, a->uncached_size);
 	next_uncached = a->uncached;
 
 	if (!esas2r_init_adapter_struct(a,
-- 
2.11.0
