From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: a100u2w: Replace mdelay() with msleep()
Date: Fri, 27 Jul 2018 17:09:13 +0800
Message-ID: <20180727090913.6870-1-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-scsi@vger.kernel.org

wait_chip_ready() and wait_firmware_ready() are never 
called in atomic context.
They call mdelay() to busily wait, which is not necessary.
mdelay() can be replaced with msleep().

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/a100u2w.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 8086bd0ac9fd..358dfeb1a9c2 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -143,7 +143,7 @@ static u8 wait_chip_ready(struct orc_host * host)
 	for (i = 0; i < 10; i++) {	/* Wait 1 second for report timeout     */
 		if (inb(host->base + ORC_HCTRL) & HOSTSTOP)	/* Wait HOSTSTOP set */
 			return 1;
-		mdelay(100);
+		msleep(100);
 	}
 	return 0;
 }
@@ -155,7 +155,7 @@ static u8 wait_firmware_ready(struct orc_host * host)
 	for (i = 0; i < 10; i++) {	/* Wait 1 second for report timeout     */
 		if (inb(host->base + ORC_HSTUS) & RREADY)		/* Wait READY set */
 			return 1;
-		mdelay(100);	/* wait 100ms before try again  */
+		msleep(100);	/* wait 100ms before try again  */
 	}
 	return 0;
 }
-- 
2.17.0
