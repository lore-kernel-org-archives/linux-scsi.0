From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 2/2] scsi: smartpqi: Replace semaphore lun_reset_sem with mutex
Date: Thu, 20 Oct 2016 14:24:02 +0530
Message-ID: <1476953642-2160-3-git-send-email-binoy.jayan@linaro.org>
References: <1476953642-2160-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476953642-2160-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: kevin Barnett <kevin.barnett@microsemi.com>, Don Brace <don.brace@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: linux-scsi@vger.kernel.org

Semaphores are going away in the future, so replace the semaphore
lun_reset_sem with the a mutex lock.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/scsi/smartpqi/smartpqi.h      | 2 +-
 drivers/scsi/smartpqi/smartpqi_init.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index b4559b1..3ecec27 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -964,7 +964,7 @@ struct pqi_ctrl_info {
 	struct timer_list heartbeat_timer;
 
 	struct mutex sync_request_mutex;
-	struct semaphore lun_reset_sem;
+	struct mutex lun_reset_mutex;
 };
 
 enum pqi_ctrl_mode {
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 4974f7e..1e5df85 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -4601,7 +4601,7 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct pqi_task_management_request *request;
 
-	down(&ctrl_info->lun_reset_sem);
+	mutex_lock(&ctrl_info->lun_reset_mutex);
 
 	io_request = pqi_alloc_io_request(ctrl_info);
 	io_request->io_complete_callback = pqi_lun_reset_complete;
@@ -4627,7 +4627,7 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info,
 		rc = io_request->status;
 
 	pqi_free_io_request(io_request);
-	up(&ctrl_info->lun_reset_sem);
+	mutex_unlock(&ctrl_info->lun_reset_mutex);
 
 	return rc;
 }
@@ -5523,7 +5523,7 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 	INIT_DELAYED_WORK(&ctrl_info->update_time_work, pqi_update_time_worker);
 
 	mutex_init(&ctrl_info->sync_request_mutex);
-	sema_init(&ctrl_info->lun_reset_sem, PQI_RESERVED_IO_SLOTS_LUN_RESET);
+	mutex_init(&ctrl_info->lun_reset_mutex);
 
 	ctrl_info->ctrl_id = atomic_inc_return(&pqi_controller_count) - 1;
 	ctrl_info->max_msix_vectors = PQI_MAX_MSIX_VECTORS;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
