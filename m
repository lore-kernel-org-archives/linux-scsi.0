From: Christos Gkekas <chris.gekas@gmail.com>
Subject: [PATCH] scsi: hpsa: simplify hpsa_set_local_logical_count()
Date: Sun, 15 Oct 2017 20:35:03 +0100
Message-ID: <1508096103-6751-1-git-send-email-chris.gekas@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christos Gkekas <chris.gekas@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Variable configured_logical_drive_count is defined as u8 and thus the
nested if statement always evaluates to true. Remove it and simplify.

Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
---
 drivers/scsi/hpsa.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9abe810..7d4f139 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4090,14 +4090,7 @@ static int hpsa_set_local_logical_count(struct ctlr_info *h,
 	}
 	memset(id_ctlr, 0, sizeof(*id_ctlr));
 	rc = hpsa_bmic_id_controller(h, id_ctlr, sizeof(*id_ctlr));
-	if (!rc)
-		if (id_ctlr->configured_logical_drive_count < 256)
-			*nlocals = id_ctlr->configured_logical_drive_count;
-		else
-			*nlocals = le16_to_cpu(
-					id_ctlr->extended_logical_unit_count);
-	else
-		*nlocals = -1;
+	*nlocals = rc ? -1 : id_ctlr->configured_logical_drive_count;
 	return rc;
 }
 
-- 
2.7.4
