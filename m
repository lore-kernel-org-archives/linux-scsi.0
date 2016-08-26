From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 09/17] smartpqi: correct event acknowledgment timeout issue
Date: Fri, 26 Aug 2016 11:45:00 -0500
Message-ID: <147222990010.31214.2025743657616417732.stgit@brunhilda>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0084.outbound.protection.outlook.com ([104.47.41.84]:60672
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751223AbcHZRTQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 13:19:16 -0400
In-Reply-To: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

the driver no longer waits for the firmware to consume
the event ack IU.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   14 +++++++-------
 drivers/scsi/smartpqi/smartpqi_init.c |   20 --------------------
 2 files changed, 7 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 5f965ad..07b6444 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -634,13 +634,6 @@ struct pqi_encryption_info {
 
 #define RAID_MAP_MAX_ENTRIES		1024
 
-#define PQI_RESERVED_IO_SLOTS_LUN_RESET			1
-#define PQI_RESERVED_IO_SLOTS_EVENT_ACK			1
-#define PQI_RESERVED_IO_SLOTS_SYNCHRONOUS_REQUESTS	3
-#define PQI_RESERVED_IO_SLOTS				\
-	(PQI_RESERVED_IO_SLOTS_LUN_RESET + PQI_RESERVED_IO_SLOTS_EVENT_ACK + \
-	PQI_RESERVED_IO_SLOTS_SYNCHRONOUS_REQUESTS)
-
 #define PQI_PHYSICAL_DEVICE_BUS		0
 #define PQI_RAID_VOLUME_BUS		1
 #define PQI_HBA_BUS			2
@@ -884,6 +877,13 @@ struct pqi_event {
 	__le32	additional_event_id;
 };
 
+#define PQI_RESERVED_IO_SLOTS_LUN_RESET			1
+#define PQI_RESERVED_IO_SLOTS_EVENT_ACK			PQI_NUM_SUPPORTED_EVENTS
+#define PQI_RESERVED_IO_SLOTS_SYNCHRONOUS_REQUESTS	3
+#define PQI_RESERVED_IO_SLOTS				\
+	(PQI_RESERVED_IO_SLOTS_LUN_RESET + PQI_RESERVED_IO_SLOTS_EVENT_ACK + \
+	PQI_RESERVED_IO_SLOTS_SYNCHRONOUS_REQUESTS)
+
 struct pqi_ctrl_info {
 	unsigned int	ctrl_id;
 	struct pci_dev	*pci_dev;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 6dda9f5..52c752f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2642,26 +2642,6 @@ static void pqi_start_event_ack(struct pqi_ctrl_info *ctrl_info,
 	writel(iq_pi, queue_group->iq_pi[RAID_PATH]);
 
 	spin_unlock_irqrestore(&queue_group->submit_lock[RAID_PATH], flags);
-
-	/*
-	 * We have to special-case this type of request because the firmware
-	 * does not generate an interrupt when this type of request completes.
-	 * Therefore, we have to poll until we see that the firmware has
-	 * consumed the request before we move on.
-	 */
-
-	timeout = (PQI_EVENT_ACK_TIMEOUT * HZ) + jiffies;
-
-	while (1) {
-		if (*queue_group->iq_ci[RAID_PATH] == iq_pi)
-			break;
-		if (time_after(jiffies, timeout)) {
-			dev_err(&ctrl_info->pci_dev->dev,
-				"completing event acknowledge timed out\n");
-			break;
-		}
-		usleep_range(1000, 2000);
-	}
 }
 
 static void pqi_acknowledge_event(struct pqi_ctrl_info *ctrl_info,

