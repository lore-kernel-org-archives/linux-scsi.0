From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 13/29] qla2xxx: Reduce mbx-command timeout for Login/Logout requests.
Date: Thu, 9 Feb 2012 11:15:45 -0800
Message-ID: <1328814961-21866-14-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:3182
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758435Ab2BITcL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:11 -0500
Received: from mail67-ch1 (localhost [127.0.0.1])	by mail67-ch1-R.bigfish.com
 (Postfix) with ESMTP id 88A3C1805A3	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:32:10 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Don't use default 30 second mailbox-command timeout for these
serial requests, instead, limit the TMO to the standard 2*RATOV
plus some fudge-factor.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 61e2fb7..5470177 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1643,7 +1643,8 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
 	lg->vp_index = vha->vp_idx;
-	rval = qla2x00_issue_iocb(vha, lg, lg_dma, 0);
+	rval = qla2x00_issue_iocb_timeout(vha, lg, lg_dma, 0,
+	    (ha->r_a_tov / 10 * 2) + 2);
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x1063,
 		    "Failed to issue login IOCB (%x).\n", rval);
@@ -1906,8 +1907,8 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
 	lg->vp_index = vha->vp_idx;
-
-	rval = qla2x00_issue_iocb(vha, lg, lg_dma, 0);
+	rval = qla2x00_issue_iocb_timeout(vha, lg, lg_dma, 0,
+	    (ha->r_a_tov / 10 * 2) + 2);
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x106f,
 		    "Failed to issue logout IOCB (%x).\n", rval);
-- 
1.6.0.2


