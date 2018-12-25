From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] scsi: a potential double-fetch bug when copying msg
Date: Tue, 25 Dec 2018 15:26:09 -0600
Message-ID: <20181225212609.69856-1-kjlu@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

user_msg[0] is copied in twice from user space. It contains size and is
critical. The fix ensures it is not changed in the second copy.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/scsi/dpt_i2o.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 93bd1d1bd5b5..2294520842e0 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1850,6 +1850,8 @@ static int adpt_i2o_passthru(adpt_hba* pHba, u32 __user *arg)
 			rcode = -EFAULT;
 			goto cleanup;
 		}
+		/* Ensure it is not changed in the second copy */
+		msg[0] = size;
 		sg_count = (size - sg_offset*4) / sizeof(struct sg_simple_element);
 
 		// TODO add 64 bit API
-- 
2.17.2 (Apple Git-113)
