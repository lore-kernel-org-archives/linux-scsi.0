From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 09/10] qla2xxx: Remove dead code
Date: Tue, 27 Jan 2015 10:34:56 +0100
Message-ID: <54C75BC0.7000705@sandisk.com>
References: <54C75AF8.90102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0077.outbound.protection.outlook.com ([157.56.110.77]:33304
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755168AbbA0JfF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2015 04:35:05 -0500
In-Reply-To: <54C75AF8.90102@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The "return QLA_SUCCESS" statement just above the "fw_load_failed"
label cannot be reached, hence remove it. Additionally remove the
"else" keyword since the code block below the if-statement ends
with a return statement.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 7521054..ff1f49c 100644
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
2.1.2

