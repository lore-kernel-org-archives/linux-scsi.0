From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 1/2] scsi: smartpqi: Replace semaphore sync_request_sem with mutex
Date: Thu, 20 Oct 2016 14:24:01 +0530
Message-ID: <1476953642-2160-2-git-send-email-binoy.jayan@linaro.org>
References: <1476953642-2160-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476953642-2160-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: kevin Barnett <kevin.barnett@microsemi.com>, Don Brace <don.brace@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: linux-scsi@vger.kernel.org

Semaphores are going away in the future, so replace the semaphore
sync_request_sem with the a mutex lock. timeout_msecs is not used
for the lock sync_request_sem, so remove the timed locking too.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/scsi/smartpqi/smartpqi.h      |  4 +++-
 drivers/scsi/smartpqi/smartpqi_init.c | 31 ++++++-------------------------
 2 files changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 07b6444..b4559b1 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -19,6 +19,8 @@
 #if !defined(_SMARTPQI_H)
 #define _SMARTPQI_H
 
+#include <linux/mutex.h>
+
 #pragma pack(1)
 
 #define PQI_DEVICE_SIGNATURE	"PQI DREG"
@@ -961,7 +963,7 @@ struct pqi_ctrl_info {
 	unsigned int	num_heartbeats_requested;
 	struct timer_list heartbeat_timer;
 
-	struct semaphore sync_request_sem;
+	struct mutex sync_request_mutex;
 	struct semaphore lun_reset_sem;
 };
 
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index a535b26..4974f7e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3444,29 +3444,11 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 	unsigned long msecs_blocked;
 	size_t iu_length;
 
-	/*
-	 * Note that specifying PQI_SYNC_FLAGS_INTERRUPTABLE and a timeout value
-	 * are mutually exclusive.
-	 */
-
-	if (flags & PQI_SYNC_FLAGS_INTERRUPTABLE) {
-		if (down_interruptible(&ctrl_info->sync_request_sem))
+	if (flags & PQI_SYNC_FLAGS_INTERRUPTABLE)
+		if (mutex_lock_interruptible(&ctrl_info->sync_request_mutex))
 			return -ERESTARTSYS;
-	} else {
-		if (timeout_msecs == NO_TIMEOUT) {
-			down(&ctrl_info->sync_request_sem);
-		} else {
-			start_jiffies = jiffies;
-			if (down_timeout(&ctrl_info->sync_request_sem,
-				msecs_to_jiffies(timeout_msecs)))
-				return -ETIMEDOUT;
-			msecs_blocked =
-				jiffies_to_msecs(jiffies - start_jiffies);
-			if (msecs_blocked >= timeout_msecs)
-				return -ETIMEDOUT;
-			timeout_msecs -= msecs_blocked;
-		}
-	}
+	else
+		mutex_lock(&ctrl_info->sync_request_mutex);
 
 	io_request = pqi_alloc_io_request(ctrl_info);
 
@@ -3508,7 +3490,7 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 
 	pqi_free_io_request(io_request);
 
-	up(&ctrl_info->sync_request_sem);
+	mutex_unlock(&ctrl_info->sync_request_mutex);
 
 	return rc;
 }
@@ -5540,8 +5522,7 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 	INIT_DELAYED_WORK(&ctrl_info->rescan_work, pqi_rescan_worker);
 	INIT_DELAYED_WORK(&ctrl_info->update_time_work, pqi_update_time_worker);
 
-	sema_init(&ctrl_info->sync_request_sem,
-		PQI_RESERVED_IO_SLOTS_SYNCHRONOUS_REQUESTS);
+	mutex_init(&ctrl_info->sync_request_mutex);
 	sema_init(&ctrl_info->lun_reset_sem, PQI_RESERVED_IO_SLOTS_LUN_RESET);
 
 	ctrl_info->ctrl_id = atomic_inc_return(&pqi_controller_count) - 1;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
