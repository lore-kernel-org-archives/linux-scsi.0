From: Wenwen Wang <wang6495@umn.edu>
Subject: [PATCH] scsi: 3w-xxxx: fix a missing-check bug
Date: Sun,  6 May 2018 00:48:14 -0500
Message-ID: <1525585714-17548-1-git-send-email-wang6495@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>, Adam Radford <aradford@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

In tw_chrdev_ioctl(), the length of the data buffer is firstly copied from
the userspace pointer 'argp' and saved to the kernel object
'data_buffer_length'. Then a security check is performed on it to make sure
that the length is not more than 'TW_MAX_IOCTL_SECTORS * 512'. Otherwise,
an error code -EINVAL is returned. If the security check is passed, the
entire ioctl command is copied again from the 'argp' pointer and saved to
the kernel object 'tw_ioctl'. Then, various operations are performed on
'tw_ioctl' according to the 'cmd'. Given that the 'argp' pointer resides in
userspace, a malicious userspace process can race to change the buffer
length between the two copies. This way, the user can bypass the security
check and inject invalid data buffer length. This can cause potential
security issues in the following execution.

This patch checks the buffer length obtained in the second copy. An error
code -EINVAL will be returned if it is not same as the original one in the
first copy.

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
---
 drivers/scsi/3w-xxxx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 33261b6..ef79194 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -919,6 +919,10 @@ static long tw_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long a
 	/* Now copy down the entire ioctl */
 	if (copy_from_user(tw_ioctl, argp, data_buffer_length + sizeof(TW_New_Ioctl) - 1))
 		goto out2;
+	if (tw_ioctl->data_buffer_length != data_buffer_length) {
+		retval = -EINVAL;
+		goto out2;
+	}
 
 	passthru = (TW_Passthru *)&tw_ioctl->firmware_command;
 
-- 
2.7.4
