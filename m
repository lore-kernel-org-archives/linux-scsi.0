From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Subject: [PATCH] wd719x: pass GFP_ATOMIC instead of GFP_KERNEL
Date: Wed, 29 May 2019 07:05:40 +0530
Message-ID: <20190529013540.GA20273@hari-Inspiron-1545>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

wd719x_chip_init is getting called in interrupt disabled
mode(spin_lock_irqsave) , so we need to GFP_ATOMIC instead
of GFP_KERNEL.

Issue identified by coccicheck

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 drivers/scsi/wd719x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index c2f4006..f300fd7 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -319,7 +319,7 @@ static int wd719x_chip_init(struct wd719x *wd)
 
 	if (!wd->fw_virt)
 		wd->fw_virt = dma_alloc_coherent(&wd->pdev->dev, wd->fw_size,
-						 &wd->fw_phys, GFP_KERNEL);
+						 &wd->fw_phys, GFP_ATOMIC);
 	if (!wd->fw_virt) {
 		ret = -ENOMEM;
 		goto wd719x_init_end;
-- 
2.7.4
