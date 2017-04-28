From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 04/12] hpsa: do not reset enclosures
Date: Fri, 28 Apr 2017 13:20:10 -0500
Message-ID: <149340361021.4102.8016202133411483359.stgit@brunhilda>
References: <149340349509.4102.15752249884898695693.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0075.outbound.protection.outlook.com ([104.47.41.75]:63306
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1426437AbdD1SUY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Apr 2017 14:20:24 -0400
In-Reply-To: <149340349509.4102.15752249884898695693.stgit@brunhilda>
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
