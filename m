From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Subject: [PATCH] scsi: pmcraid: Remove call to memset after dma_alloc_coherent
Date: Fri, 31 May 2019 00:00:13 +0530
Message-ID: <20190530183013.GA8526@hari-Inspiron-1545>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch fixes below warning reported by coccicheck

./drivers/scsi/pmcraid.c:4728:3-21: WARNING: dma_alloc_coherent use in
pinstance -> hrrq_start [ i ] already zeroes out memory,  so memset is
not needed

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 drivers/scsi/pmcraid.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index e338d7a..112a617 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4678,8 +4678,6 @@ static int pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)
 			pmcraid_release_control_blocks(pinstance, i);
 			return -ENOMEM;
 		}
-		memset(pinstance->cmd_list[i]->ioa_cb, 0,
-			sizeof(struct pmcraid_control_block));
 	}
 	return 0;
 }
-- 
2.7.4
