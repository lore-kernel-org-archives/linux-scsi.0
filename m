From: Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH] scsi: don't reinitialize adapter's req_table
Date: Sun, 21 Aug 2016 10:39:24 +0800
Message-ID: <1471747164-31441-1-git-send-email-shawn.lin@rock-chips.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bradley Grove <linuxdrivers@attotech.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>
List-Id: linux-scsi@vger.kernel.org

req_table is allocate by kzalloc, so we don't need to
zero it again anyway.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

 drivers/scsi/esas2r/esas2r_init.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 78ce4d61..d6e53ae 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -963,10 +963,6 @@ bool esas2r_init_adapter_struct(struct esas2r_adapter *a,
 
 	/* initialize the allocated memory */
 	if (test_bit(AF_FIRST_INIT, &a->flags)) {
-		memset(a->req_table, 0,
-		       (num_requests + num_ae_requests +
-			1) * sizeof(struct esas2r_request *));
-
 		esas2r_targ_db_initialize(a);
 
 		/* prime parts of the inbound list */
-- 
2.3.7
