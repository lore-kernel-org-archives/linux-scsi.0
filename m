From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 08/15] smartpqi: correct event acknowledgment timeout
 issue
Date: Wed, 31 Aug 2016 14:54:53 -0500
Message-ID: <147267329322.22907.8917922331774007832.stgit@brunhilda>
References: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0066.outbound.protection.outlook.com ([104.47.36.66]:14512
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1759047AbcHaUJz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 16:09:55 -0400
In-Reply-To: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

the driver no longer waits for the firmware to consume
the event ack IU.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
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
index d759703..ea822b1 100644
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

