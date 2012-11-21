From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 09/19] qla2xxx: Add Gen3 PCIe speed 8GT/s to the log message.
Date: Wed, 21 Nov 2012 02:40:34 -0500
Message-ID: <1353483644-17262-10-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:46087 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753507Ab2KUH6y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:54 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e4fd192..67f7b56 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -494,12 +494,20 @@ qla24xx_pci_info_str(struct scsi_qla_host *vha, char *str)
 		    (BIT_4 | BIT_5 | BIT_6 | BIT_7 | BIT_8 | BIT_9)) >> 4;
 
 		strcpy(str, "PCIe (");
-		if (lspeed == 1)
+		switch (lspeed) {
+		case 1:
 			strcat(str, "2.5GT/s ");
-		else if (lspeed == 2)
+			break;
+		case 2:
 			strcat(str, "5.0GT/s ");
-		else
+			break;
+		case 3:
+			strcat(str, "8.0GT/s ");
+			break;
+		default:
 			strcat(str, "<unknown> ");
+			break;
+		}
 		snprintf(lwstr, sizeof(lwstr), "x%d)", lwidth);
 		strcat(str, lwstr);
 
-- 
1.7.7

