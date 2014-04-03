From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 1/9] target/iblock: Fix double bioset_integrity_free bug
Date: Thu,  3 Apr 2014 09:35:45 +0000
Message-ID: <1396517753-23546-2-git-send-email-nab@daterainc.com>
References: <1396517753-23546-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1396517753-23546-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a double free bug during IBLOCK backend shutdown
where bioset_integrity_free() was incorrectly called ahead of
bioset_free(), who is already making the same call directly.

This bug was introduced with commit ecebbf6cc, and will end up
triggering a general protection fault in iblock_free_device()

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: <stable@vger.kernel.org> #3.14+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 554d4f7..9e0232c 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -203,10 +203,9 @@ static void iblock_free_device(struct se_device *dev)
 
 	if (ib_dev->ibd_bd != NULL)
 		blkdev_put(ib_dev->ibd_bd, FMODE_WRITE|FMODE_READ|FMODE_EXCL);
-	if (ib_dev->ibd_bio_set != NULL) {
-		bioset_integrity_free(ib_dev->ibd_bio_set);
+	if (ib_dev->ibd_bio_set != NULL)
 		bioset_free(ib_dev->ibd_bio_set);
-	}
+
 	kfree(ib_dev);
 }
 
-- 
1.7.10.4
