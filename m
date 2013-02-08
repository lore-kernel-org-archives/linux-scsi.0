From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 05/23] qla2xxx: Reject loopback request if one is already in progress.
Date: Fri,  8 Feb 2013 01:57:46 -0500
Message-ID: <1360306684-8286-6-git-send-email-saurav.kashyap@qlogic.com>
References: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:25321 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759947Ab3BHHTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:09 -0500
In-Reply-To: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

If another function on the port has initiated a loopback operation do not
process the current request.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    8 ++++++++
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index f7cb6a3..5b49766 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -746,6 +746,14 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 				goto done_free_dma_rsp;
 			}
 
+			if ((config[0] & INTERNAL_LOOPBACK_MASK) != 0) {
+				ql_dbg(ql_dbg_user, vha, 0x70c4,
+				    "Loopback operation already in "
+				    "progress.\n");
+				rval = -EAGAIN;
+				goto done_free_dma_rsp;
+			}
+
 			ql_dbg(ql_dbg_user, vha, 0x70c0,
 			    "elreq.options=%04x\n", elreq.options);
 
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index af045ed..c1d2310 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -24,7 +24,7 @@
  * | Async Events                 |       0x5071       | 0x502b-0x502f  |
  * |                              |                    | 0x5047,0x5052  |
  * | Timer Routines               |       0x6011       |                |
- * | User Space Interactions      |       0x70c3       | 0x7018,0x702e, |
+ * | User Space Interactions      |       0x70c4       | 0x7018,0x702e, |
  * |                              |                    | 0x7020,0x7024, |
  * |                              |                    | 0x7039,0x7045, |
  * |                              |                    | 0x7073-0x7075, |
-- 
1.7.7

