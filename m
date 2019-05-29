From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Subject: [Patch v2] wd719x: pass GFP_ATOMIC instead of GFP_KERNEL
Date: Wed, 29 May 2019 23:28:51 +0530
Message-ID: <20190529175851.GA10760@hari-Inspiron-1545>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

dont acquire lock before calling wd719x_chip_init.

Issue identified by coccicheck

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
-----
changes in v1: Replace GFP_KERNEL with GFP_ATOMIC.
changes in v2: Call wd719x_chip_init  without lock as suggested
		in review
----
---
 drivers/scsi/wd719x.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index c2f4006..340ec92 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -505,11 +505,9 @@ static int wd719x_host_reset(struct scsi_cmnd *cmd)
 {
 	struct wd719x *wd = shost_priv(cmd->device->host);
 	struct wd719x_scb *scb, *tmp;
-	unsigned long flags;
 	int result;
 
 	dev_info(&wd->pdev->dev, "host reset requested\n");
-	spin_lock_irqsave(wd->sh->host_lock, flags);
 	/* Try to reinit the RISC */
 	if (wd719x_chip_init(wd) == 0)
 		result = SUCCESS;
@@ -519,7 +517,6 @@ static int wd719x_host_reset(struct scsi_cmnd *cmd)
 	/* flush all SCBs */
 	list_for_each_entry_safe(scb, tmp, &wd->active_scbs, list)
 		wd719x_finish_cmd(scb, result);
-	spin_unlock_irqrestore(wd->sh->host_lock, flags);
 
 	return result;
 }
-- 
2.7.4
