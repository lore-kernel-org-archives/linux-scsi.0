From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 5/7] hpsa: correct ioaccel2 error procecssing.
Date: Wed, 27 Apr 2016 17:14:07 -0500
Message-ID: <146179524703.31195.9154842043010596458.stgit@brunhilda>
References: <146179474454.31195.15135625511559409075.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0067.outbound.protection.outlook.com ([157.56.110.67]:9248
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752749AbcD0W3p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 18:29:45 -0400
In-Reply-To: <146179474454.31195.15135625511559409075.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

set offload_to_be_enabled to 0 when an ioaccel2 error is processed.

Before, an ioaccel completion error would turn of ioaccel but a rescan
would turn it back on again.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e7406ef..3f9f758 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2360,8 +2360,10 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 		c2->error_data.serv_response ==
 			IOACCEL2_SERV_RESPONSE_FAILURE) {
 		if (c2->error_data.status ==
-			IOACCEL2_STATUS_SR_IOACCEL_DISABLED)
+			IOACCEL2_STATUS_SR_IOACCEL_DISABLED) {
 			dev->offload_enabled = 0;
+			dev->offload_to_be_enabled = 0;
+		}
 
 		return hpsa_retry_cmd(h, c);
 	}

