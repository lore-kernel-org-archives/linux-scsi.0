From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 27/37] smartpqi: controller offline improvements
Date: Tue, 25 Apr 2017 14:48:37 -0500
Message-ID: <149314971725.13903.12898094371142997631.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0062.outbound.protection.outlook.com ([104.47.32.62]:20288
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1169438AbdDYTtB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:49:01 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

improve support for taking controller offline.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    2 
 drivers/scsi/smartpqi/smartpqi_init.c |  141 ++++++++++++++++++---------------
 2 files changed, 77 insertions(+), 66 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 94b92ae..2ed15cf 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -994,7 +994,6 @@ struct pqi_ctrl_info {
 	u8		inbound_spanning_supported : 1;
 	u8		outbound_spanning_supported : 1;
 	u8		pqi_mode_enabled : 1;
-	u8		update_time_worker_scheduled : 1;
 
 	struct list_head scsi_device_list;
 	spinlock_t	scsi_device_list_lock;
@@ -1016,6 +1015,7 @@ struct pqi_ctrl_info {
 	u32		previous_heartbeat_count;
 	__le32 __iomem	*heartbeat_counter;
 	struct timer_list heartbeat_timer;
+	struct work_struct ctrl_offline_work;
 
 	struct semaphore sync_request_sem;
 	atomic_t	num_busy_threads;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 8a0a486..66f02f4 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -61,10 +61,8 @@ MODULE_LICENSE("GPL");
 static char *hpe_branded_controller = "HPE Smart Array Controller";
 static char *microsemi_branded_controller = "Microsemi Smart Family Controller";
 
-static void pqi_perform_lockup_action(void);
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info);
-static void pqi_complete_all_queued_raid_bypass_retries(
-	struct pqi_ctrl_info *ctrl_info, int result);
+static void pqi_ctrl_offline_worker(struct work_struct *work);
 static void pqi_retry_raid_bypass_requests(struct pqi_ctrl_info *ctrl_info);
 static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info);
 static void pqi_scan_start(struct Scsi_Host *shost);
@@ -224,7 +222,6 @@ static inline void pqi_save_ctrl_mode(struct pqi_ctrl_info *ctrl_info,
 	sis_write_driver_scratch(ctrl_info, mode);
 }
 
-#define PQI_RESCAN_WORK_INTERVAL       (10 * HZ)
 static inline void pqi_ctrl_block_requests(struct pqi_ctrl_info *ctrl_info)
 {
 	ctrl_info->block_requests = true;
@@ -310,10 +307,26 @@ static inline bool pqi_device_in_reset(struct pqi_scsi_dev *device)
 	return device->in_reset;
 }
 
+static inline void pqi_schedule_rescan_worker_with_delay(
+	struct pqi_ctrl_info *ctrl_info, unsigned long delay)
+{
+	if (pqi_ctrl_offline(ctrl_info))
+		return;
+
+	schedule_delayed_work(&ctrl_info->rescan_work, delay);
+}
+
 static inline void pqi_schedule_rescan_worker(struct pqi_ctrl_info *ctrl_info)
 {
-	schedule_delayed_work(&ctrl_info->rescan_work,
-		PQI_RESCAN_WORK_INTERVAL);
+	pqi_schedule_rescan_worker_with_delay(ctrl_info, 0);
+}
+
+#define PQI_RESCAN_WORK_DELAY  (10 * HZ)
+
+static inline void pqi_schedule_rescan_worker_delayed(
+	struct pqi_ctrl_info *ctrl_info)
+{
+	pqi_schedule_rescan_worker_with_delay(ctrl_info, PQI_RESCAN_WORK_DELAY);
 }
 
 static inline void pqi_cancel_rescan_worker(struct pqi_ctrl_info *ctrl_info)
@@ -746,6 +759,9 @@ static void pqi_update_time_worker(struct work_struct *work)
 	ctrl_info = container_of(to_delayed_work(work), struct pqi_ctrl_info,
 		update_time_work);
 
+	if (pqi_ctrl_offline(ctrl_info))
+		return;
+
 	rc = pqi_write_current_time_to_host_wellness(ctrl_info);
 	if (rc)
 		dev_warn(&ctrl_info->pci_dev->dev,
@@ -758,21 +774,13 @@ static void pqi_update_time_worker(struct work_struct *work)
 static inline void pqi_schedule_update_time_worker(
 	struct pqi_ctrl_info *ctrl_info)
 {
-	if (ctrl_info->update_time_worker_scheduled)
-		return;
-
 	schedule_delayed_work(&ctrl_info->update_time_work, 0);
-	ctrl_info->update_time_worker_scheduled = true;
 }
 
 static inline void pqi_cancel_update_time_worker(
 	struct pqi_ctrl_info *ctrl_info)
 {
-	if (!ctrl_info->update_time_worker_scheduled)
-		return;
-
 	cancel_delayed_work_sync(&ctrl_info->update_time_work);
-	ctrl_info->update_time_worker_scheduled = false;
 }
 
 static int pqi_report_luns(struct pqi_ctrl_info *ctrl_info, u8 cmd,
@@ -1939,7 +1947,7 @@ static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 
 	rc = pqi_update_scsi_devices(ctrl_info);
 	if (rc)
-		pqi_schedule_rescan_worker(ctrl_info);
+		pqi_schedule_rescan_worker_delayed(ctrl_info);
 
 	mutex_unlock(&ctrl_info->scan_mutex);
 
@@ -2762,6 +2770,10 @@ static void pqi_event_worker(struct work_struct *work)
 
 	pqi_ctrl_busy(ctrl_info);
 	pqi_wait_if_ctrl_blocked(ctrl_info, NO_TIMEOUT);
+	if (pqi_ctrl_offline(ctrl_info))
+		goto out;
+
+	pqi_schedule_rescan_worker_delayed(ctrl_info);
 
 	event = ctrl_info->events;
 	for (i = 0; i < PQI_NUM_SUPPORTED_EVENTS; i++) {
@@ -2772,9 +2784,8 @@ static void pqi_event_worker(struct work_struct *work)
 		event++;
 	}
 
+out:
 	pqi_ctrl_unbusy(ctrl_info);
-
-	pqi_schedule_rescan_worker(ctrl_info);
 }
 
 #define PQI_HEARTBEAT_TIMER_INTERVAL	(10 * HZ)
@@ -4751,25 +4762,13 @@ static void pqi_raid_bypass_retry_worker(struct work_struct *work)
 	pqi_retry_raid_bypass_requests(ctrl_info);
 }
 
-static void pqi_complete_all_queued_raid_bypass_retries(
-	struct pqi_ctrl_info *ctrl_info, int result)
+static void pqi_clear_all_queued_raid_bypass_retries(
+	struct pqi_ctrl_info *ctrl_info)
 {
 	unsigned long flags;
-	struct pqi_io_request *io_request;
-	struct pqi_io_request *next;
-	struct scsi_cmnd *scmd;
 
 	spin_lock_irqsave(&ctrl_info->raid_bypass_retry_list_lock, flags);
-
-	list_for_each_entry_safe(io_request, next,
-		&ctrl_info->raid_bypass_retry_list, request_list_entry) {
-		list_del(&io_request->request_list_entry);
-		scmd = io_request->scmd;
-		pqi_free_io_request(io_request);
-		scmd->result = result;
-		pqi_scsi_done(scmd);
-	}
-
+	INIT_LIST_HEAD(&ctrl_info->raid_bypass_retry_list);
 	spin_unlock_irqrestore(&ctrl_info->raid_bypass_retry_list_lock, flags);
 }
 
@@ -6325,6 +6324,7 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 	INIT_DELAYED_WORK(&ctrl_info->update_time_work, pqi_update_time_worker);
 
 	init_timer(&ctrl_info->heartbeat_timer);
+	INIT_WORK(&ctrl_info->ctrl_offline_work, pqi_ctrl_offline_worker);
 
 	sema_init(&ctrl_info->sync_request_sem,
 		PQI_RESERVED_IO_SLOTS_SYNCHRONOUS_REQUESTS);
@@ -6404,58 +6404,69 @@ static void pqi_perform_lockup_action(void)
 	}
 }
 
-static void pqi_complete_all_queued_requests(struct pqi_ctrl_info *ctrl_info,
-	int result)
+static struct pqi_raid_error_info pqi_ctrl_offline_raid_error_info = {
+	.data_out_result = PQI_DATA_IN_OUT_HARDWARE_ERROR,
+	.status = SAM_STAT_CHECK_CONDITION,
+};
+
+static void pqi_fail_all_outstanding_requests(struct pqi_ctrl_info *ctrl_info)
 {
 	unsigned int i;
-	unsigned int path;
-	struct pqi_queue_group *queue_group;
-	unsigned long flags;
 	struct pqi_io_request *io_request;
-	struct pqi_io_request *next;
 	struct scsi_cmnd *scmd;
 
-	for (i = 0; i < ctrl_info->num_queue_groups; i++) {
-		queue_group = &ctrl_info->queue_groups[i];
-
-		for (path = 0; path < 2; path++) {
-			spin_lock_irqsave(
-				&queue_group->submit_lock[path], flags);
-
-			list_for_each_entry_safe(io_request, next,
-				&queue_group->request_list[path],
-				request_list_entry) {
-
-				scmd = io_request->scmd;
-				if (scmd) {
-					scmd->result = result;
-					pqi_scsi_done(scmd);
-				}
-
-				list_del(&io_request->request_list_entry);
-			}
+	for (i = 0; i < ctrl_info->max_io_slots; i++) {
+		io_request = &ctrl_info->io_request_pool[i];
+		if (atomic_read(&io_request->refcount) == 0)
+			continue;
 
-			spin_unlock_irqrestore(
-				&queue_group->submit_lock[path], flags);
+		scmd = io_request->scmd;
+		if (scmd) {
+			set_host_byte(scmd, DID_NO_CONNECT);
+		} else {
+			io_request->status = -ENXIO;
+			io_request->error_info =
+				&pqi_ctrl_offline_raid_error_info;
 		}
+
+		io_request->io_complete_callback(io_request,
+			io_request->context);
 	}
 }
 
-static void pqi_fail_all_queued_requests(struct pqi_ctrl_info *ctrl_info)
+static void pqi_take_ctrl_offline_deferred(struct pqi_ctrl_info *ctrl_info)
 {
-	pqi_complete_all_queued_requests(ctrl_info, DID_NO_CONNECT << 16);
-	pqi_complete_all_queued_raid_bypass_retries(ctrl_info,
-		DID_NO_CONNECT << 16);
+	pqi_perform_lockup_action();
+	pqi_stop_heartbeat_timer(ctrl_info);
+	pqi_free_interrupts(ctrl_info);
+	pqi_cancel_rescan_worker(ctrl_info);
+	pqi_cancel_update_time_worker(ctrl_info);
+	pqi_ctrl_wait_until_quiesced(ctrl_info);
+	pqi_fail_all_outstanding_requests(ctrl_info);
+	pqi_clear_all_queued_raid_bypass_retries(ctrl_info);
+	pqi_ctrl_unblock_requests(ctrl_info);
+}
+
+static void pqi_ctrl_offline_worker(struct work_struct *work)
+{
+	struct pqi_ctrl_info *ctrl_info;
+
+	ctrl_info = container_of(work, struct pqi_ctrl_info, ctrl_offline_work);
+	pqi_take_ctrl_offline_deferred(ctrl_info);
 }
 
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info)
 {
+	if (!ctrl_info->controller_online)
+		return;
+
 	ctrl_info->controller_online = false;
+	ctrl_info->pqi_mode_enabled = false;
+	pqi_ctrl_block_requests(ctrl_info);
 	sis_shutdown_ctrl(ctrl_info);
 	pci_disable_device(ctrl_info->pci_dev);
 	dev_err(&ctrl_info->pci_dev->dev, "controller offline\n");
-	pqi_perform_lockup_action();
-	pqi_fail_all_queued_requests(ctrl_info);
+	schedule_work(&ctrl_info->ctrl_offline_work);
 }
 
 static void pqi_print_ctrl_info(struct pci_dev *pci_dev,
