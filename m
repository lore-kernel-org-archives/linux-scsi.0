From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 08/29] scsi: aacraid: Move code to wait for IO completion to shutdown func
Date: Thu, 21 Dec 2017 09:33:59 -0800
Message-ID: <20171221173420.8213-9-RaghavaAditya.Renukunta@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0044.outbound.protection.outlook.com ([104.47.37.44]:6558
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753884AbdLURei (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 12:34:38 -0500
In-Reply-To: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, aacraid@microsemi.com, tom.white@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>

Ideally driver needs to wait for IO to be submitted or responded to before
shutdown.

Move code to wait for IO completion into shutdown path

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/comminit.c | 36 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/aacraid/commsup.c  | 25 -------------------------
 2 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 9eff246..0dc7b5a 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -42,6 +42,8 @@
 #include <linux/completion.h>
 #include <linux/mm.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
 
 #include "aacraid.h"
 
@@ -284,6 +286,38 @@ static void aac_queue_init(struct aac_dev * dev, struct aac_queue * q, u32 *mem,
 	q->entries = qsize;
 }
 
+static void aac_wait_for_io_completion(struct aac_dev *aac)
+{
+	unsigned long flagv = 0;
+	int i = 0;
+
+	for (i = 60; i; --i) {
+		struct scsi_device *dev;
+		struct scsi_cmnd *command;
+		int active = 0;
+
+		__shost_for_each_device(dev, aac->scsi_host_ptr) {
+			spin_lock_irqsave(&dev->list_lock, flagv);
+			list_for_each_entry(command, &dev->cmd_list, list) {
+				if (command->SCp.phase == AAC_OWNER_FIRMWARE) {
+					active++;
+					break;
+				}
+			}
+			spin_unlock_irqrestore(&dev->list_lock, flagv);
+			if (active)
+				break;
+
+		}
+		/*
+		 * We can exit If all the commands are complete
+		 */
+		if (active == 0)
+			break;
+		ssleep(1);
+	}
+}
+
 /**
  *	aac_send_shutdown		-	shutdown an adapter
  *	@dev: Adapter to shutdown
@@ -306,6 +340,8 @@ int aac_send_shutdown(struct aac_dev * dev)
 		mutex_unlock(&dev->ioctl_mutex);
 	}
 
+	aac_wait_for_io_completion(dev);
+
 	fibctx = aac_fib_alloc(dev);
 	if (!fibctx)
 		return -ENOMEM;
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 32b8bdb..9840bd3 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1701,31 +1701,6 @@ int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	 */
 	host = aac->scsi_host_ptr;
 	scsi_block_requests(host);
-	if (forced < 2) for (retval = 60; retval; --retval) {
-		struct scsi_device * dev;
-		struct scsi_cmnd * command;
-		int active = 0;
-
-		__shost_for_each_device(dev, host) {
-			spin_lock_irqsave(&dev->list_lock, flagv);
-			list_for_each_entry(command, &dev->cmd_list, list) {
-				if (command->SCp.phase == AAC_OWNER_FIRMWARE) {
-					active++;
-					break;
-				}
-			}
-			spin_unlock_irqrestore(&dev->list_lock, flagv);
-			if (active)
-				break;
-
-		}
-		/*
-		 * We can exit If all the commands are complete
-		 */
-		if (active == 0)
-			break;
-		ssleep(1);
-	}
 
 	/* Quiesce build, flush cache, write through mode */
 	if (forced < 2)
-- 
2.9.4
