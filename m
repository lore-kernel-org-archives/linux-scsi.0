From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 03/10] qla2xxx: Remove dead code in qla2x00_configure_hba()
Date: Wed, 05 Jun 2013 15:04:28 +0200
Message-ID: <51AF375C.3000902@acm.org>
References: <51AF36BF.3030602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:59638 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3FENE3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 09:04:29 -0400
In-Reply-To: <51AF36BF.3030602@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>

At the end of qla2x00_configure_hba() we know that rval == QLA_SUCCESS.
Hence remove the code that depends on rval != QLA_SUCCESS.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3565dfd..c68bb01 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2309,13 +2309,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 		    "Topology - %s, Host Loop address 0x%x.\n",
 		    connect_type, vha->loop_id);
 
-	if (rval) {
-		ql_log(ql_log_warn, vha, 0x2011,
-		    "%s FAILED\n", __func__);
-	} else {
-		ql_dbg(ql_dbg_disc, vha, 0x2012,
-		    "%s success\n", __func__);
-	}
+	ql_dbg(ql_dbg_disc, vha, 0x2012, "%s success\n", __func__);
 
 	return(rval);
 }
-- 
1.7.10.4

