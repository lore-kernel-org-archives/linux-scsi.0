From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] scsi: fix a double-fetch bug in sg_write
Date: Tue, 25 Dec 2018 14:24:26 -0600
Message-ID: <20181225202427.69476-1-kjlu@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

"opcode" has been copied in from user space and checked. We should not
copy it in again, which may have been modified by malicous
multi-threading user programs through race conditions. The fix uses the
opcode fetched in the first copy.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/scsi/sg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4dacbfffd113..41774e4f9508 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -686,7 +686,8 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	hp->flags = input_size;	/* structure abuse ... */
 	hp->pack_id = old_hdr.pack_id;
 	hp->usr_ptr = NULL;
-	if (__copy_from_user(cmnd, buf, cmd_size))
+	cmnd[0] = opcode;
+	if (__copy_from_user(cmnd + 1, buf + 1, cmd_size - 1))
 		return -EFAULT;
 	/*
 	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
-- 
2.17.2 (Apple Git-113)
