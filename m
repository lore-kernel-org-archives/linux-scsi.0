From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 66/87] scsi: bnx2fc: remove memset after dma_alloc_coherent in bnx2fc_io.c
Date: Fri, 28 Jun 2019 01:45:26 +0800
Message-ID: <20190627174526.5940-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 8def63c0755f..92b289466797 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -614,8 +614,6 @@ int bnx2fc_init_mp_req(struct bnx2fc_cmd *io_req)
 		bnx2fc_free_mp_resc(io_req);
 		return FAILED;
 	}
-	memset(mp_req->req_buf, 0, CNIC_PAGE_SIZE);
-	memset(mp_req->resp_buf, 0, CNIC_PAGE_SIZE);
 
 	/* Allocate and map mp_req_bd and mp_resp_bd */
 	sz = sizeof(struct fcoe_bd_ctx);
-- 
2.11.0
