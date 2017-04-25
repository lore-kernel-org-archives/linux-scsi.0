From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 22/37] smartpqi: enhance kdump
Date: Tue, 25 Apr 2017 14:48:06 -0500
Message-ID: <149314968661.13903.4048408723273337166.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0048.outbound.protection.outlook.com ([104.47.34.48]:47885
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1174204AbdDYTsg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:48:36 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

constrain resource usage during kdump to avoid kdump failures

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    6 +++-
 drivers/scsi/smartpqi/smartpqi_init.c |   45 +++++++++++++++++++++++----------
 2 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index be04bcb..400d1fb 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -686,8 +686,10 @@ struct pqi_config_table_heartbeat {
 	__le32	heartbeat_counter;
 };
 
-#define PQI_MAX_OUTSTANDING_REQUESTS	((u32)~0)
-#define PQI_MAX_TRANSFER_SIZE		(4 * 1024U * 1024U)
+#define PQI_MAX_OUTSTANDING_REQUESTS		((u32)~0)
+#define PQI_MAX_OUTSTANDING_REQUESTS_KDUMP	32
+#define PQI_MAX_TRANSFER_SIZE			(4 * 1024U * 1024U)
+#define PQI_MAX_TRANSFER_SIZE_KDUMP		(512 * 1024U)
 
 #define RAID_MAP_MAX_ENTRIES		1024
 
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 5678b6a..6235b6d 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -4360,8 +4360,12 @@ static void pqi_calculate_io_resources(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->error_buffer_length =
 		ctrl_info->max_io_slots * PQI_ERROR_BUFFER_ELEMENT_LENGTH;
 
-	max_transfer_size =
-		min(ctrl_info->max_transfer_size, PQI_MAX_TRANSFER_SIZE);
+	if (reset_devices)
+		max_transfer_size = min(ctrl_info->max_transfer_size,
+			PQI_MAX_TRANSFER_SIZE_KDUMP);
+	else
+		max_transfer_size = min(ctrl_info->max_transfer_size,
+			PQI_MAX_TRANSFER_SIZE);
 
 	max_sg_entries = max_transfer_size / PAGE_SIZE;
 
@@ -4381,19 +4385,24 @@ static void pqi_calculate_io_resources(struct pqi_ctrl_info *ctrl_info)
 
 static void pqi_calculate_queue_resources(struct pqi_ctrl_info *ctrl_info)
 {
-	int num_cpus;
-	int max_queue_groups;
 	int num_queue_groups;
 	u16 num_elements_per_iq;
 	u16 num_elements_per_oq;
 
-	max_queue_groups = min(ctrl_info->max_inbound_queues / 2,
-		ctrl_info->max_outbound_queues - 1);
-	max_queue_groups = min(max_queue_groups, PQI_MAX_QUEUE_GROUPS);
+	if (reset_devices) {
+		num_queue_groups = 1;
+	} else {
+		int num_cpus;
+		int max_queue_groups;
+
+		max_queue_groups = min(ctrl_info->max_inbound_queues / 2,
+			ctrl_info->max_outbound_queues - 1);
+		max_queue_groups = min(max_queue_groups, PQI_MAX_QUEUE_GROUPS);
 
-	num_cpus = num_online_cpus();
-	num_queue_groups = min(num_cpus, ctrl_info->max_msix_vectors);
-	num_queue_groups = min(num_queue_groups, max_queue_groups);
+		num_cpus = num_online_cpus();
+		num_queue_groups = min(num_cpus, ctrl_info->max_msix_vectors);
+		num_queue_groups = min(num_queue_groups, max_queue_groups);
+	}
 
 	ctrl_info->num_queue_groups = num_queue_groups;
 	ctrl_info->max_hw_queue_index = num_queue_groups - 1;
@@ -5834,9 +5843,17 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 		return rc;
 	}
 
-	if (ctrl_info->max_outstanding_requests > PQI_MAX_OUTSTANDING_REQUESTS)
-		ctrl_info->max_outstanding_requests =
-			PQI_MAX_OUTSTANDING_REQUESTS;
+	if (reset_devices) {
+		if (ctrl_info->max_outstanding_requests >
+			PQI_MAX_OUTSTANDING_REQUESTS_KDUMP)
+			ctrl_info->max_outstanding_requests =
+					PQI_MAX_OUTSTANDING_REQUESTS_KDUMP;
+	} else {
+		if (ctrl_info->max_outstanding_requests >
+			PQI_MAX_OUTSTANDING_REQUESTS)
+			ctrl_info->max_outstanding_requests =
+					PQI_MAX_OUTSTANDING_REQUESTS;
+	}
 
 	pqi_calculate_io_resources(ctrl_info);
 
@@ -7117,4 +7134,6 @@ static void __attribute__((unused)) verify_structures(void)
 		PQI_QUEUE_ELEMENT_LENGTH_ALIGNMENT != 0);
 
 	BUILD_BUG_ON(PQI_RESERVED_IO_SLOTS >= PQI_MAX_OUTSTANDING_REQUESTS);
+	BUILD_BUG_ON(PQI_RESERVED_IO_SLOTS >=
+		PQI_MAX_OUTSTANDING_REQUESTS_KDUMP);
 }
