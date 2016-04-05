From: Bastien Philbert <bastienphilbert@gmail.com>
Subject: [PATCH] csiostor: Fix backwards locking in the function __csio_unreg_rnode
Date: Tue,  5 Apr 2016 17:19:03 -0400
Message-ID: <1459891143-20451-1-git-send-email-bastienphilbert@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This fixes backwards locking in the function __csio_unreg_rnode to
properly lock before the call to the function csio_unreg_rnode and
not unlock with spin_unlock_irq as this would not allow the proper
protection for concurrent access on the shared csio_hw structure
pointer hw. In addition switch the locking after the critical region
function call to properly unlock instead with spin_unlock_irq on

Signed-off-by: Bastien Philbert <bastienphilbert@gmail.com>
---
 drivers/scsi/csiostor/csio_rnode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_rnode.c b/drivers/scsi/csiostor/csio_rnode.c
index e9c3b04..029a09e 100644
--- a/drivers/scsi/csiostor/csio_rnode.c
+++ b/drivers/scsi/csiostor/csio_rnode.c
@@ -580,9 +580,9 @@ __csio_unreg_rnode(struct csio_rnode *rn)
 		ln->last_scan_ntgts--;
 	}
 
-	spin_unlock_irq(&hw->lock);
-	csio_unreg_rnode(rn);
 	spin_lock_irq(&hw->lock);
+	csio_unreg_rnode(rn);
+	spin_unlock_irq(&hw->lock);
 
 	/* Cleanup I/Os that were waiting for rnode to unregister */
 	if (cmpl)
-- 
2.5.0
