From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] scsi: fix a double-fetch bug in adpt_i2o_passthru
Date: Tue, 25 Dec 2018 15:20:47 -0600
Message-ID: <20181225212048.69782-1-kjlu@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

user_msg[0] is a size variable, which is copied in from user space and
checked. It is copied in again from user space after the check, and used
in the following execution. Malicious user programs can race to change
user_msg[0] between the two copies, leading to incorrect size. The fix
ensures to use the checked size.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/scsi/dpt_i2o.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 37de8fb186d7..93bd1d1bd5b5 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1733,6 +1733,9 @@ static int adpt_i2o_passthru(adpt_hba* pHba, u32 __user *arg)
 	if(copy_from_user(msg, user_msg, size)) {
 		return -EFAULT;
 	}
+	/* Ensure it is not changed in the second copy */
+	msg[0] = size;
+
 	get_user(reply_size, &user_reply[0]);
 	reply_size = reply_size>>16;
 	if(reply_size > REPLY_FRAME_SIZE){
-- 
2.17.2 (Apple Git-113)
