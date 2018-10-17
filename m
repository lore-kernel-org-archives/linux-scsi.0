From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] scsi/sd: Avoid that hibernation triggers a kernel warning
Date: Wed, 17 Oct 2018 13:27:19 -0700
Message-ID: <20181017202719.137168-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Lee Duncan <lduncan@suse.com>, Hannes Reinecke <hare@suse.com>, Luis Chamberlain <mcgrof@kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Although the power management code never calls the system-wide and runtime
suspend callbacks concurrently, runtime power state changes can happen
while the system is being suspended or resumed. See also the dpm_suspend()
and dpm_resume() calls in hibernation_snapshot(). Make sure the sd driver
supports this. This patch avoids that the following call trace is reported
during system-wide suspend:

WARNING: CPU: 0 PID: 701 at drivers/scsi/scsi_lib.c:3047 scsi_device_quiesce+0x4b/0xd0
Workqueue: events_unbound async_run_entry_fn
RIP: 0010:scsi_device_quiesce+0x4b/0xd0
Call Trace:
 scsi_bus_suspend_common+0x71/0xe0
 scsi_bus_freeze+0x15/0x20
 dpm_run_callback+0x88/0x360
 __device_suspend+0x1c4/0x840
 async_suspend+0x1f/0xb0
 async_run_entry_fn+0x6e/0x2c0
 process_one_work+0x4ae/0xa20
 worker_thread+0x63/0x5a0
 kthread+0x1cf/0x1f0
 ret_from_fork+0x24/0x30

Fixes: cd84a62e0078 ("block, scsi: Change the preempt-only flag into a counter")
Cc: Lee Duncan <lduncan@suse.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c    | 16 +++++-----------
 include/scsi/scsi_device.h |  1 -
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 62348412ed1b..3106e910e766 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3040,13 +3040,11 @@ scsi_device_quiesce(struct scsi_device *sdev)
 	int err;
 
 	/*
-	 * It is allowed to call scsi_device_quiesce() multiple times from
-	 * the same context but concurrent scsi_device_quiesce() calls are
-	 * not allowed.
+	 * Since all scsi_device_quiesce() and scsi_device_resume() calls
+	 * are serialized it is safe to check the device state without holding
+	 * the SCSI device state mutex.
 	 */
-	WARN_ON_ONCE(sdev->quiesced_by && sdev->quiesced_by != current);
-
-	if (sdev->quiesced_by == current)
+	if (sdev->sdev_state == SDEV_QUIESCE)
 		return 0;
 
 	blk_set_pm_only(q);
@@ -3063,9 +3061,7 @@ scsi_device_quiesce(struct scsi_device *sdev)
 
 	mutex_lock(&sdev->state_mutex);
 	err = scsi_device_set_state(sdev, SDEV_QUIESCE);
-	if (err == 0)
-		sdev->quiesced_by = current;
-	else
+	if (err)
 		blk_clear_pm_only(q);
 	mutex_unlock(&sdev->state_mutex);
 
@@ -3089,8 +3085,6 @@ void scsi_device_resume(struct scsi_device *sdev)
 	 * device deleted during suspend)
 	 */
 	mutex_lock(&sdev->state_mutex);
-	WARN_ON_ONCE(!sdev->quiesced_by);
-	sdev->quiesced_by = NULL;
 	blk_clear_pm_only(sdev->request_queue);
 	if (sdev->sdev_state == SDEV_QUIESCE)
 		scsi_device_set_state(sdev, SDEV_RUNNING);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 202f4d6a4342..ef86c8adc5d5 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -226,7 +226,6 @@ struct scsi_device {
 	unsigned char		access_state;
 	struct mutex		state_mutex;
 	enum scsi_device_state sdev_state;
-	struct task_struct	*quiesced_by;
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
 
-- 
2.19.1.568.g152ad8e336-goog
