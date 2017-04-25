From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 30/37] smartpqi: update timeout on admin commands
Date: Tue, 25 Apr 2017 14:48:55 -0500
Message-ID: <149314973561.13903.18185640757974966656.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0079.outbound.protection.outlook.com ([104.47.37.79]:32789
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1176519AbdDYTt3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:49:29 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

Increase the timeout on admin commands from 3 seconds to 60
seconds and added a check for controller crash in the loop
where the driver polls for admin command completion.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index e841c1b..52ad6e7 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3432,6 +3432,8 @@ static void pqi_submit_admin_request(struct pqi_ctrl_info *ctrl_info,
 	writel(iq_pi, admin_queues->iq_pi);
 }
 
+#define PQI_ADMIN_REQUEST_TIMEOUT_SECS	60
+
 static int pqi_poll_for_admin_response(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_general_admin_response *response)
 {
@@ -3443,7 +3445,7 @@ static int pqi_poll_for_admin_response(struct pqi_ctrl_info *ctrl_info,
 	admin_queues = &ctrl_info->admin_queues;
 	oq_ci = admin_queues->oq_ci_copy;
 
-	timeout = (3 * HZ) + jiffies;
+	timeout = (PQI_ADMIN_REQUEST_TIMEOUT_SECS * HZ) + jiffies;
 
 	while (1) {
 		oq_pi = *admin_queues->oq_pi;
@@ -3454,6 +3456,8 @@ static int pqi_poll_for_admin_response(struct pqi_ctrl_info *ctrl_info,
 				"timed out waiting for admin response\n");
 			return -ETIMEDOUT;
 		}
+		if (!sis_is_firmware_running(ctrl_info))
+			return -ENXIO;
 		usleep_range(1000, 2000);
 	}
 
