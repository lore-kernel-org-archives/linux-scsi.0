From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 08/10] qla2xxx: Remove unreachable code
Date: Thu, 4 Jun 2015 15:56:41 -0700
Message-ID: <5570D7A9.7050505@sandisk.com>
References: <5570D656.9050704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0074.outbound.protection.outlook.com ([65.55.169.74]:64288
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753546AbbFDW4r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jun 2015 18:56:47 -0400
In-Reply-To: <5570D656.9050704@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The "return QLA_SUCCESS" statement just above the "fw_load_failed"
label cannot be reached, hence remove it. Additionally remove the
"else" keyword since the code block below the if-statement ends
with a return statement.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Acked-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 678fb5b..b359a83 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2473,14 +2473,12 @@ try_blob_fw:
 		ql_log(ql_log_info, vha, 0x00a5,
 		    "Firmware loaded successfully from binary blob.\n");
 		return QLA_SUCCESS;
-	} else {
-		ql_log(ql_log_fatal, vha, 0x00a6,
-		    "Firmware load failed for binary blob.\n");
-		blob->fw = NULL;
-		blob = NULL;
-		goto fw_load_failed;
 	}
-	return QLA_SUCCESS;
+
+	ql_log(ql_log_fatal, vha, 0x00a6,
+	       "Firmware load failed for binary blob.\n");
+	blob->fw = NULL;
+	blob = NULL;
 
 fw_load_failed:
 	return QLA_FUNCTION_FAILED;
-- 
2.1.4

