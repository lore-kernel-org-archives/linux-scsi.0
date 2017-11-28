From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 02/22] qla2xxx: Fix gpnid error processing
Date: Tue, 28 Nov 2017 11:34:43 -0800
Message-ID: <20171128193503.13695-3-himanshu.madhani@cavium.com>
References: <20171128193503.13695-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0071.outbound.protection.outlook.com ([104.47.42.71]:8096
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752410AbdK1TfK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Nov 2017 14:35:10 -0500
In-Reply-To: <20171128193503.13695-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Stop GPNID command from advancing if command has failed.

Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index bc3db6abc9a0..ddc69d36877e 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3211,6 +3211,11 @@ static void qla2x00_async_gpnid_sp_done(void *s, int res)
 	    sp->name, res, ct_req->req.port_id.port_id,
 	    ct_rsp->rsp.gpn_id.port_name);
 
+	if (res) {
+		sp->free(sp);
+		return;
+	}
+
 	memset(&ea, 0, sizeof(ea));
 	memcpy(ea.port_name, ct_rsp->rsp.gpn_id.port_name, WWN_SIZE);
 	ea.sp = sp;
-- 
2.12.0
