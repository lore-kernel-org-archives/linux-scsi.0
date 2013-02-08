From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 04/23] qla2xxx: Print thermal unsupported message.
Date: Fri,  8 Feb 2013 01:57:45 -0500
Message-ID: <1360306684-8286-5-git-send-email-saurav.kashyap@qlogic.com>
References: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:12267 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759916Ab3BHHTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:09 -0500
In-Reply-To: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

When the Read SFP mailbox command fails on the thermal device,
print a message explaining that thermal is not supported.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index ba2d7a8..af045ed 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -12,7 +12,7 @@
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
  * | Module Init and Probe        |       0x0126       | 0x4b,0xba,0xfa |
- * | Mailbox commands             |       0x114f       | 0x111a-0x111b  |
+ * | Mailbox commands             |       0x1150       | 0x111a-0x111b  |
  * |                              |                    | 0x112c-0x112e  |
  * |                              |                    | 0x113a         |
  * | Device Discovery             |       0x2087       | 0x2020-0x2022, |
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 319b0f2..92d51fc 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4446,7 +4446,11 @@ qla2x00_get_thermal_temp(scsi_qla_host_t *vha, uint16_t *temp, uint16_t *frac)
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1018,
 	    "Done %s.\n", __func__);
+	return rval;
 fail:
+	ql_log(ql_log_warn, vha, 0x1150,
+	    "Thermal not supported by this card "
+	    "(ignoring further requests).\n");
 	return rval;
 }
 
-- 
1.7.7

