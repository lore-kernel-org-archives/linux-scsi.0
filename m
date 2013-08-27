From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 08/29] qla2xxx: Remove QL_DEBUG_LEVEL_17 defines from qla_nx.c.
Date: Tue, 27 Aug 2013 01:37:34 -0400
Message-ID: <1377581875-8574-9-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51784 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752866Ab3H0GGo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:44 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R63vVq012060
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:44 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq13pa4-11
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:44 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    1 +
 drivers/scsi/qla2xxx/qla_nx.c  |   14 --------------
 2 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 9d289a4..6ee4fcb 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -27,6 +27,7 @@
  * | Async Events                 |       0x5081       | 0x502b-0x502f  |
  * |                              |                    | 0x5047,0x5052  |
  * |                              |                    | 0x5040,0x5075  |
+ * |                              |                    | 0x503d,0x5044  |
  * | Timer Routines               |       0x6011       |                |
  * | User Space Interactions      |       0x70dd       | 0x7018,0x702e, |
  * |                              |                    | 0x7020,0x7024, |
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 01b72e0..b3e48f5 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2077,13 +2077,6 @@ qla82xx_intr_handler(int irq, void *dev_id)
 		WRT_REG_DWORD(&reg->host_int, 0);
 	}
 
-#ifdef QL_DEBUG_LEVEL_17
-	if (!irq && ha->flags.eeh_busy)
-		ql_log(ql_log_warn, vha, 0x503d,
-		    "isr:status %x, cmd_flags %lx, mbox_int %x, stat %x.\n",
-		    status, ha->mbx_cmd_flags, ha->flags.mbox_int, stat);
-#endif
-
 	qla2x00_handle_mbx_completion(ha, status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -2149,13 +2142,6 @@ qla82xx_msix_default(int irq, void *dev_id)
 		WRT_REG_DWORD(&reg->host_int, 0);
 	} while (0);
 
-#ifdef QL_DEBUG_LEVEL_17
-	if (!irq && ha->flags.eeh_busy)
-		ql_log(ql_log_warn, vha, 0x5044,
-		    "isr:status %x, cmd_flags %lx, mbox_int %x, stat %x.\n",
-		    status, ha->mbx_cmd_flags, ha->flags.mbox_int, stat);
-#endif
-
 	qla2x00_handle_mbx_completion(ha, status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-- 
1.7.7

