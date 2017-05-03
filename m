From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 11/36] smartpqi: add pqi_wait_for_completion_io
Date: Wed, 3 May 2017 18:53:24 -0500
Message-ID: <149385560411.11043.9537106099057315910.stgit@brunhilda>
References: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0079.outbound.protection.outlook.com ([104.47.37.79]:9856
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752014AbdECXxa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 19:53:30 -0400
In-Reply-To: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

Add check for controller lockup during waits for synchronous
controller commands.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 6f31cd9..586a1d5 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3578,6 +3578,37 @@ static void pqi_start_io(struct pqi_ctrl_info *ctrl_info,
 	spin_unlock_irqrestore(&queue_group->submit_lock[path], flags);
 }
 
+#define PQI_WAIT_FOR_COMPLETION_IO_TIMEOUT_SECS		10
+
+static int pqi_wait_for_completion_io(struct pqi_ctrl_info *ctrl_info,
+	struct completion *wait)
+{
+	int rc;
+	unsigned int wait_secs = 0;
+
+	while (1) {
+		if (wait_for_completion_io_timeout(wait,
+			PQI_WAIT_FOR_COMPLETION_IO_TIMEOUT_SECS * HZ)) {
+			rc = 0;
+			break;
+		}
+
+		pqi_check_ctrl_health(ctrl_info);
+		if (pqi_ctrl_offline(ctrl_info)) {
+			rc = -ENXIO;
+			break;
+		}
+
+		wait_secs += PQI_WAIT_FOR_COMPLETION_IO_TIMEOUT_SECS;
+
+		dev_err(&ctrl_info->pci_dev->dev,
+			"waiting %u seconds for completion\n",
+			wait_secs);
+	}
+
+	return rc;
+}
+
 static void pqi_raid_synchronous_complete(struct pqi_io_request *io_request,
 	void *context)
 {
@@ -3601,7 +3632,7 @@ static int pqi_submit_raid_request_synchronous_with_io_request(
 		io_request);
 
 	if (timeout_msecs == NO_TIMEOUT) {
-		wait_for_completion_io(&wait);
+		pqi_wait_for_completion_io(ctrl_info, &wait);
 	} else {
 		if (!wait_for_completion_io_timeout(&wait,
 			msecs_to_jiffies(timeout_msecs))) {
