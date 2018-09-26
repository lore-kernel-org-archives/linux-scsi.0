From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: qla4xxx: remove redundant check on drvr_wait
Date: Wed, 26 Sep 2018 14:08:48 +0100
Message-ID: <20180926130848.30645-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The check for a non-zero drvr_wait is redundant as the same check
is performed earlier in the outer while loop, the inner check will
always be true if we reached this point inside the while loop.
Remove the redundant if check.

Detected by cppcheck:
(warning) Identical inner 'if' condition is always true.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla4xxx/ql4_init.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 52b1a0bc93c9..1ef74aa2d00a 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -766,12 +766,10 @@ int ql4xxx_lock_drvr_wait(struct scsi_qla_host *a)
 	while (drvr_wait) {
 		if (ql4xxx_lock_drvr(a) == 0) {
 			ssleep(QL4_LOCK_DRVR_SLEEP);
-			if (drvr_wait) {
-				DEBUG2(printk("scsi%ld: %s: Waiting for "
-					      "Global Init Semaphore(%d)...\n",
-					      a->host_no,
-					      __func__, drvr_wait));
-			}
+			DEBUG2(printk("scsi%ld: %s: Waiting for "
+				      "Global Init Semaphore(%d)...\n",
+				      a->host_no,
+				      __func__, drvr_wait));
 			drvr_wait -= QL4_LOCK_DRVR_SLEEP;
 		} else {
 			DEBUG2(printk("scsi%ld: %s: Global Init Semaphore "
-- 
2.17.1
