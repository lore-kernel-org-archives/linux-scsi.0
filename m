From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 01/10] qla2xxx: Clean up qla24xx_iidma()
Date: Wed, 05 Jun 2013 15:02:44 +0200
Message-ID: <51AF36F4.4000706@acm.org>
References: <51AF36BF.3030602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:59661 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3FENCp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 09:02:45 -0400
In-Reply-To: <51AF36BF.3030602@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>

Remove dead code and simplify a pointer computation.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 39719f8..7221521 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1282,14 +1282,7 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
-	port_param = (struct qla_port_param *)((char *)bsg_job->request +
-		sizeof(struct fc_bsg_request));
-	if (!port_param) {
-		ql_log(ql_log_warn, vha, 0x7047,
-		    "port_param header not provided.\n");
-		return -EINVAL;
-	}
-
+	port_param = (void *)bsg_job->request + sizeof(struct fc_bsg_request);
 	if (port_param->fc_scsi_addr.dest_type != EXT_DEF_TYPE_WWPN) {
 		ql_log(ql_log_warn, vha, 0x7048,
 		    "Invalid destination type.\n");
-- 
1.7.10.4

