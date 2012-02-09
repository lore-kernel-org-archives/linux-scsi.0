From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 09/11] qla2xxx: Remove resetting memory during device initialization for ISP82xx.
Date: Thu, 9 Feb 2012 11:14:11 -0800
Message-ID: <1328814853-21764-10-git-send-email-chad.dupuis@qlogic.com>
References: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:1378
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758381Ab2BITaa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:30:30 -0500
Received: from mail10-ch1 (localhost [127.0.0.1])	by mail10-ch1-R.bigfish.com
 (Postfix) with ESMTP id D74C0C0077	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:30:29 +0000 (UTC)
In-Reply-To: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Shyam Sundar <shyam.sundar@qlogic.com>

With IOs running and PegHalt testing the system reboots when memory reset is
performed during device initialization.

Signed-off-by: Shyam Sundar <shyam.sundar@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 1cd46cd..bb06c20 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1165,19 +1165,6 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0xfeffffff);
 	else
 		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0xffffffff);
-
-	/* reset ms */
-	val = qla82xx_rd_32(ha, QLA82XX_CRB_QDR_NET + 0xe4);
-	val |= (1 << 1);
-	qla82xx_wr_32(ha, QLA82XX_CRB_QDR_NET + 0xe4, val);
-	msleep(20);
-
-	/* unreset ms */
-	val = qla82xx_rd_32(ha, QLA82XX_CRB_QDR_NET + 0xe4);
-	val &= ~(1 << 1);
-	qla82xx_wr_32(ha, QLA82XX_CRB_QDR_NET + 0xe4, val);
-	msleep(20);
-
 	qla82xx_rom_unlock(ha);
 
 	/* Read the signature value from the flash.
-- 
1.6.0.2


