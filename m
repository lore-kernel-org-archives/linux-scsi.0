From: Christos Gkekas <chris.gekas@gmail.com>
Subject: [PATCH] =?UTF-8?q?csi:=20hpsa:=20Fix=20configured=5Flogical=5Fdri?= =?UTF-8?q?ve=5Fcount=C2=B7check?=
Date: Mon, 16 Oct 2017 20:28:02 +0100
Message-ID: <1508182082-11828-1-git-send-email-chris.gekas@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christos Gkekas <chris.gekas@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Check whether configured_logical_drive_count is less than 255. Previous
check was always evaluating to true as this variable is defined as u8.

Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9abe810..4ed3d26 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4091,7 +4091,7 @@ static int hpsa_set_local_logical_count(struct ctlr_info *h,
 	memset(id_ctlr, 0, sizeof(*id_ctlr));
 	rc = hpsa_bmic_id_controller(h, id_ctlr, sizeof(*id_ctlr));
 	if (!rc)
-		if (id_ctlr->configured_logical_drive_count < 256)
+		if (id_ctlr->configured_logical_drive_count < 255)
 			*nlocals = id_ctlr->configured_logical_drive_count;
 		else
 			*nlocals = le16_to_cpu(
-- 
2.7.4
