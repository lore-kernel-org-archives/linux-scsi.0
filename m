From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH  08/14] qla2xxx: Do not reset ISP for error entry with an out of range handle.
Date: Tue, 4 Aug 2015 13:37:58 -0400
Message-ID: <1438709884-623-9-git-send-email-himanshu.madhani@qlogic.com>
References: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:48220 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752569AbbHDSXq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2015 14:23:46 -0400
In-Reply-To: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Instead of resetting the adapter wait for the login to timeout
and retry. Resetting the adapter can cause extended path recovery
times.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a82ba35..fd7b86a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2474,13 +2474,7 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	}
 fatal:
 	ql_log(ql_log_warn, vha, 0x5030,
-	    "Error entry - invalid handle/queue.\n");
-
-	if (IS_P3P_TYPE(ha))
-		set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
-	else
-		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-	qla2xxx_wake_dpc(vha);
+	    "Error entry - invalid handle/queue (%04x).\n", que);
 }
 
 /**
-- 
1.7.7

