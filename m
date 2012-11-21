From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 03/19] qla2xxx: Honor status value of 2 for report-id acquisition.
Date: Wed, 21 Nov 2012 02:40:28 -0500
Message-ID: <1353483644-17262-4-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:49120 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752755Ab2KUH6y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:54 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

The value of 2 is informational message and it means that port id has
changed. The driver should honor the value and continue its normal course.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 18c509f..bdf7fa7 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3122,7 +3122,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 		if (vp_idx == 0 && (MSB(stat) != 1))
 			goto reg_needed;
 
-		if (MSB(stat) != 0) {
+		if (MSB(stat) != 0 && MSB(stat) != 2) {
 			ql_dbg(ql_dbg_mbx, vha, 0x10ba,
 			    "Could not acquire ID for VP[%d].\n", vp_idx);
 			return;
-- 
1.7.7

