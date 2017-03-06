From: Joe Perches <joe@perches.com>
Subject: [PATCH] scsi: qedf: Use vsprintf extension %pad
Date: Mon,  6 Mar 2017 10:32:27 -0800
Message-ID: <f6a0331e574df0ab1c9dad61571b92c17971ae99.1488825093.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com
Cc: kbuild test robot <lkp@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Using %llx for a dma_addr_t can lead to format/argument mismatches.
Use %pad and the address of the dma_addr_t instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/qedf/qedf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index d9d7a86b5f8b..8e2a160490e6 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2456,8 +2456,8 @@ static int qedf_alloc_bdq(struct qedf_ctx *qedf)
 	}
 
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
-	    "BDQ PBL addr=0x%p dma=0x%llx.\n", qedf->bdq_pbl,
-	    qedf->bdq_pbl_dma);
+		  "BDQ PBL addr=0x%p dma=%pad\n",
+		  qedf->bdq_pbl, &qedf->bdq_pbl_dma);
 
 	/*
 	 * Populate BDQ PBL with physical and virtual address of individual
-- 
2.10.0.rc2.1.g053435c
