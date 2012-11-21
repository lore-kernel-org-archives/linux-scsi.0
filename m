From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 19/19] qla2xxx: Display that driver is operating in legacy interrupt mode.
Date: Wed, 21 Nov 2012 02:40:44 -0500
Message-ID: <1353483644-17262-20-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:36132 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753590Ab2KUH64 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:56 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 9b9c632..53f9e49 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -11,7 +11,7 @@
  * ----------------------------------------------------------------------
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
- * | Module Init and Probe        |       0x0124       | 0x4b,0xba,0xfa |
+ * | Module Init and Probe        |       0x0125       | 0x4b,0xba,0xfa |
  * | Mailbox commands             |       0x114f       | 0x111a-0x111b  |
  * |                              |                    | 0x112c-0x112e  |
  * |                              |                    | 0x113a         |
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 55ee3ba..873c820 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2940,7 +2940,9 @@ skip_msi:
 		    "Failed to reserve interrupt %d already in use.\n",
 		    ha->pdev->irq);
 		goto fail;
-	}
+	} else if (!ha->flags.msi_enabled)
+		ql_dbg(ql_dbg_init, vha, 0x0125,
+		    "INTa mode: Enabled.\n");
 
 clear_risc_ints:
 
-- 
1.7.7

