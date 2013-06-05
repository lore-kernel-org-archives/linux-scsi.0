From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 06/10] qla2xxx: Remove redundant assignments
Date: Wed, 05 Jun 2013 15:06:55 +0200
Message-ID: <51AF37EF.8020606@acm.org>
References: <51AF36BF.3030602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:34589 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab3FENG4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 09:06:56 -0400
In-Reply-To: <51AF36BF.3030602@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>

The value of the pointer called "nxt" is not used after the
"nxt = qla24xx_copy_eft(ha, nxt)" statement. Hence keep the function
call but remove the assignment.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index cfa2a20..c612785 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1468,7 +1468,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	nxt = qla2xxx_copy_queues(ha, nxt);
 
-	nxt = qla24xx_copy_eft(ha, nxt);
+	qla24xx_copy_eft(ha, nxt);
 
 	/* Chain entries -- started with MQ. */
 	nxt_chain = qla25xx_copy_fce(ha, nxt_chain, &last_chain);
@@ -1787,7 +1787,7 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	nxt = qla2xxx_copy_queues(ha, nxt);
 
-	nxt = qla24xx_copy_eft(ha, nxt);
+	qla24xx_copy_eft(ha, nxt);
 
 	/* Chain entries -- started with MQ. */
 	nxt_chain = qla25xx_copy_fce(ha, nxt_chain, &last_chain);
@@ -2289,7 +2289,7 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 copy_queue:
 	nxt = qla2xxx_copy_queues(ha, nxt);
 
-	nxt = qla24xx_copy_eft(ha, nxt);
+	qla24xx_copy_eft(ha, nxt);
 
 	/* Chain entries -- started with MQ. */
 	nxt_chain = qla25xx_copy_fce(ha, nxt_chain, &last_chain);
-- 
1.7.10.4

