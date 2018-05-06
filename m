From: Wenwen Wang <wang6495@umn.edu>
Subject: [PATCH] scsi: 3ware: fix a missing-check bug
Date: Sun,  6 May 2018 00:50:47 -0500
Message-ID: <1525585856-17639-1-git-send-email-wang6495@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>, Adam Radford <aradford@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

In twl_chrdev_ioctl(), the ioctl driver command is firstly copied from the
userspace pointer 'argp' and saved to the kernel object 'driver_command'.
Then a security check is performed on the data buffer size indicated by
'driver_command', which is 'driver_command.buffer_length'. If the security
check is passed, the entire ioctl command is copied again from the 'argp'
pointer and saved to the kernel object 'tw_ioctl'. Then, various operations
are performed on 'tw_ioctl' according to the 'cmd'. Given that the 'argp'
pointer resides in userspace, a malicious userspace process can race to
change the buffer size between the two copies. This way, the user can
bypass the security check and inject invalid data buffer size. This can
cause potential security issues in the following execution.

This patch checks the buffer size obtained in the second copy. An error
code -EINVAL will be returned if it is not same as the original one in the
first copy.

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
---
 drivers/scsi/3w-sas.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index cf9f2a0..ea41969 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -757,6 +757,11 @@ static long twl_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	/* Now copy down the entire ioctl */
 	if (copy_from_user(tw_ioctl, argp, driver_command.buffer_length + sizeof(TW_Ioctl_Buf_Apache) - 1))
 		goto out3;
+	if (tw_ioctl->driver_command.buffer_length !=
+	    driver_command.buffer_length) {
+		retval = -EINVAL;
+		goto out3;
+	}
 
 	/* See which ioctl we are doing */
 	switch (cmd) {
-- 
2.7.4
