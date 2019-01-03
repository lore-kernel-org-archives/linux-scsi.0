From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: smartpqi_init: fix boolean expression in
 pqi_device_remove_start
Date: Thu, 3 Jan 2019 10:47:44 -0600
Message-ID: <20190103164744.GA16360@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

Fix boolean expression by using logical AND operator '&&'
instead of bitwise operator '&'.

This issue was detected with the help of Coccinelle.

Fixes: 1e46731efd9c ("scsi: smartpqi: check for null device pointers")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index e2fa3f476227..40f58238ce4a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -323,7 +323,7 @@ static inline void pqi_device_remove_start(struct pqi_scsi_dev *device)
 static inline bool pqi_device_in_remove(struct pqi_ctrl_info *ctrl_info,
 					struct pqi_scsi_dev *device)
 {
-	return device->in_remove & !ctrl_info->in_shutdown;
+	return device->in_remove && !ctrl_info->in_shutdown;
 }
 
 static inline void pqi_schedule_rescan_worker_with_delay(
-- 
2.20.1
