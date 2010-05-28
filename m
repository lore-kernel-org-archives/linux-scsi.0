From: giridhar.malavali@qlogic.com
Subject: [PATCH 03/17] qla2xxx: Fix cpu-affinity usage for non-capable ISPs.
Date: Fri, 28 May 2010 15:08:17 -0700
Message-ID: <1275084511-95266-4-git-send-email-giridhar.malavali@qlogic.com>
References: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52663 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751059Ab0E1WIc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 18:08:32 -0400
In-Reply-To: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

The TMFs used for pre-24xx ISPs incorrectly assumed 'cpu' tag
data could be valid.  These chips have no multi-q/cpu-affinity
support.  This corrects an oops seen on ISP23xx parts.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index f3650d0..043f808 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -866,8 +866,8 @@ qla2x00_abort_target(struct fc_port *fcport, unsigned int l, int tag)
 
 	l = l;
 	vha = fcport->vha;
-	req = vha->hw->req_q_map[tag];
-	rsp = vha->hw->rsp_q_map[tag];
+	req = vha->hw->req_q_map[0];
+	rsp = req->rsp;
 	mcp->mb[0] = MBC_ABORT_TARGET;
 	mcp->out_mb = MBX_9|MBX_2|MBX_1|MBX_0;
 	if (HAS_EXTENDED_IDS(vha->hw)) {
@@ -915,8 +915,8 @@ qla2x00_lun_reset(struct fc_port *fcport, unsigned int l, int tag)
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->vha->host_no));
 
 	vha = fcport->vha;
-	req = vha->hw->req_q_map[tag];
-	rsp = vha->hw->rsp_q_map[tag];
+	req = vha->hw->req_q_map[0];
+	rsp = req->rsp;
 	mcp->mb[0] = MBC_LUN_RESET;
 	mcp->out_mb = MBX_9|MBX_3|MBX_2|MBX_1|MBX_0;
 	if (HAS_EXTENDED_IDS(vha->hw))
-- 
1.6.2.rc1.30.gd43c

