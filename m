From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 11/15] lpfc: Fix debugfs root inode "lpfc" not getting deleted on driver unload.
Date: Wed, 10 May 2017 12:07:09 -0700
Message-ID: <20170510190713.30171-12-jsmart2021@gmail.com>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36322 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754037AbdEJTHg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2017 15:07:36 -0400
Received: by mail-qt0-f194.google.com with SMTP id j13so48890qta.3
        for <linux-scsi@vger.kernel.org>; Wed, 10 May 2017 12:07:36 -0700 (PDT)
In-Reply-To: <20170510190713.30171-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

When unloading and reloading the driver, the driver
fails to recreate the lpfc root inode in the debugfs tree.

The driver is incorrectly removing the lpfc root inode
in lpfc_debugfs_terminate in the first driver instance that
unloads and then sets the lpfc_debugfs_root global parameter
to NULL.  When the final driver instance unloads, the debugfs
calls quietly ignore the remove on a NULL pointer.  The bug
is that the debugfs_remove call returns void so the driver
doesn't know to correctly set the global parameter to NULL.

Base the debugfs_remove of the lpfc_debugfs_root parameter
on lpfc_debugfs_hba_count because this parameter tracks the
fnX instance tracked per driver instance.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index c7d1c9d37a64..4bcb92c844ca 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -5866,8 +5866,10 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 			atomic_dec(&lpfc_debugfs_hba_count);
 		}
 
-		debugfs_remove(lpfc_debugfs_root); /* lpfc */
-		lpfc_debugfs_root = NULL;
+		if (atomic_read(&lpfc_debugfs_hba_count) == 0) {
+			debugfs_remove(lpfc_debugfs_root); /* lpfc */
+			lpfc_debugfs_root = NULL;
+		}
 	}
 #endif
 	return;
-- 
2.11.0
