From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 02/42] qla2xxx: Do not schedule reset when one is already active when receiving an invalid status handle.
Date: Fri, 11 Apr 2014 16:54:07 -0400
Message-ID: <1397249687-32666-3-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:45336 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754837AbaDKVcH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:07 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

If an adapter reset is already in progress, do not schedule another one when
we receive an invalid status handle.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 95314ef..7549d09 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2009,11 +2009,13 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		ql_dbg(ql_dbg_io, vha, 0x3017,
 		    "Invalid status handle (0x%x).\n", sts->handle);
 
-		if (IS_P3P_TYPE(ha))
-			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
-		else
-			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-		qla2xxx_wake_dpc(vha);
+		if (!test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags)) {
+			if (IS_P3P_TYPE(ha))
+				set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
+			else
+				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+			qla2xxx_wake_dpc(vha);
+		}
 		return;
 	}
 
-- 
1.7.7

