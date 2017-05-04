From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V3 06/14] hpsa: do not reset enclosures
Date: Thu, 4 May 2017 14:08:37 -0500
Message-ID: <149392491757.10271.8975885257765983552.stgit@brunhilda>
References: <149392483740.10271.14468343789177475526.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0057.outbound.protection.outlook.com ([104.47.37.57]:3220
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756183AbdEDTIn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 May 2017 15:08:43 -0400
In-Reply-To: <149392483740.10271.14468343789177475526.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

Prevent enclosure resets.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.tell@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9fb30c4..2990897 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5853,6 +5853,9 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 		return FAILED;
 	}
 
+	if (dev->devtype == TYPE_ENCLOSURE)
+		return SUCCESS;
+
 	/* if controller locked up, we can guarantee command won't complete */
 	if (lockup_detected(h)) {
 		snprintf(msg, sizeof(msg),
