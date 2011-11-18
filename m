From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 16/18] qla2xxx: Ensure there's enough request-queue space for passthru IOCBs.
Date: Fri, 18 Nov 2011 09:03:20 -0800
Message-ID: <1321635802-16491-17-git-send-email-chad.dupuis@qlogic.com>
References: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:26496
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758259Ab1KRRQa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:16:30 -0500
In-Reply-To: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

The driver should ensure there's a sufficient number of IOCBs
to satisfy the number of scatter-gather entries specified in the
command.  Add a 'count' to the control structure, srb_ctx, to use
in qla2x00_alloc_iocbs().

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c  |   16 ++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    1 +
 drivers/scsi/qla2xxx/qla_iocb.c |   11 +++++++++--
 4 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index c0bc0c6..b1d0f93 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -31,6 +31,7 @@ qla2x00_get_ctx_bsg_sp(scsi_qla_host_t *vha, fc_port_t *fcport, size_t size)
 	memset(sp, 0, sizeof(*sp));
 	sp->fcport = fcport;
 	sp->ctx = ctx;
+	ctx->iocbs = 1;
 done:
 	return sp;
 }
@@ -389,6 +390,20 @@ done:
 	return rval;
 }
 
+inline uint16_t
+qla24xx_calc_ct_iocbs(uint16_t dsds)
+{
+	uint16_t iocbs;
+
+	iocbs = 1;
+	if (dsds > 2) {
+		iocbs += (dsds - 2) / 5;
+		if ((dsds - 2) % 5)
+			iocbs++;
+	}
+	return iocbs;
+}
+
 static int
 qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 {
@@ -489,6 +504,7 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	ct = sp->ctx;
 	ct->type = SRB_CT_CMD;
 	ct->name = "bsg_ct";
+	ct->iocbs = qla24xx_calc_ct_iocbs(req_sg_cnt + rsp_sg_cnt);
 	ct->u.bsg_job = bsg_job;
 
 	ql_dbg(ql_dbg_user, vha, 0x7016,
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d046db1..a6a4eeb 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -271,6 +271,7 @@ struct srb_iocb {
 struct srb_ctx {
 	uint16_t type;
 	char *name;
+	int iocbs;
 	union {
 		struct srb_iocb *iocb_cmd;
 		struct fc_bsg_job *bsg_job;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 05931e6..1fa067e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -111,6 +111,7 @@ qla2x00_get_ctx_sp(scsi_qla_host_t *vha, fc_port_t *fcport, size_t size,
 	memset(sp, 0, sizeof(*sp));
 	sp->fcport = fcport;
 	sp->ctx = ctx;
+	ctx->iocbs = 1;
 	ctx->u.iocb_cmd = iocb;
 	iocb->free = qla2x00_ctx_sp_free;
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 841ffb3..55a9676 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1818,6 +1818,7 @@ qla2x00_alloc_iocbs(scsi_qla_host_t *vha, srb_t *sp)
 	uint32_t index, handle;
 	request_t *pkt;
 	uint16_t cnt, req_cnt;
+	struct srb_ctx *ctx;
 
 	pkt = NULL;
 	req_cnt = 1;
@@ -1846,6 +1847,12 @@ qla2x00_alloc_iocbs(scsi_qla_host_t *vha, srb_t *sp)
 	req->outstanding_cmds[handle] = sp;
 	sp->handle = handle;
 
+	/* Adjust entry-counts as needed. */
+	if (sp->ctx) {
+		ctx = sp->ctx;
+		req_cnt = ctx->iocbs;
+	}
+
 skip_cmd_array:
 	/* Check for room on request queue. */
 	if (req->cnt < req_cnt) {
@@ -2622,8 +2629,8 @@ qla2x00_start_sp(srb_t *sp)
 		break;
 	case SRB_CT_CMD:
 		IS_FWI2_CAPABLE(ha) ?
-		qla24xx_ct_iocb(sp, pkt) :
-		qla2x00_ct_iocb(sp, pkt);
+		    qla24xx_ct_iocb(sp, pkt) :
+		    qla2x00_ct_iocb(sp, pkt);
 		break;
 	case SRB_ADISC_CMD:
 		IS_FWI2_CAPABLE(ha) ?
-- 
1.6.0.2


