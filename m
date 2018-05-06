From: Wenwen Wang <wang6495@umn.edu>
Subject: [PATCH] scsi: sg: fix a missing-check bug
Date: Sat,  5 May 2018 22:21:34 -0500
Message-ID: <1525576895-15708-1-git-send-email-wang6495@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:SCSI SG DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

In sg_write(), the opcode of the command is firstly copied from the
userspace pointer 'buf' and saved to the kernel variable 'opcode', using
the __get_user() function. The size of the command, i.e., 'cmd_size' is
then calculated based on the 'opcode'. After that, the whole command,
including the opcode, is copied again from 'buf' using the
__copy_from_user() function and saved to 'cmnd'. Finally, the function
 sg_common_write() is invoked to process 'cmnd'. Given that the 'buf'
pointer resides in userspace, a malicious userspace process can race to
change the opcode of the command between the two copies. That means, the
opcode indicated by the variable 'opcode' could be different from the
opcode in 'cmnd'. This can cause inconsistent data in 'cmnd' and
potential logical errors in the function sg_common_write(), as it needs to
work on 'cmnd'.

This patch reuses the opcode obtained in the first copy and only copies the
remaining part of the command from userspace.

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
---
 drivers/scsi/sg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c198b963..0ad8106 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -657,7 +657,8 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
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
2.7.4
