From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: imm: Replace mdelay with msleep in imm_init
Date: Sun, 24 Dec 2017 18:32:24 +0800
Message-ID: <1514111544-26598-1-git-send-email-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-scsi@vger.kernel.org

imm_init is not called in an interrupt handler 
nor holding a spinlock.
The function mdelay in it can be replaced with msleep, 
to reduce busy wait.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/imm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 87c9419..4805c0e 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -591,9 +591,9 @@ static int imm_init(imm_struct *dev)
 	if (imm_connect(dev, 0) != 1)
 		return -EIO;
 	imm_reset_pulse(dev->base);
-	mdelay(1);	/* Delay to allow devices to settle */
+	msleep(1);	/* Delay to allow devices to settle */
 	imm_disconnect(dev);
-	mdelay(1);	/* Another delay to allow devices to settle */
+	msleep(1);	/* Another delay to allow devices to settle */
 	return device_check(dev);
 }
 
-- 
1.7.9.5
