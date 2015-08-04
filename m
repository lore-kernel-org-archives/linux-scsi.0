From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH  07/14] qla2xxx: Do not reset adapter if SRB handle is in range.
Date: Tue, 4 Aug 2015 13:37:57 -0400
Message-ID: <1438709884-623-8-git-send-email-himanshu.madhani@qlogic.com>
References: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:5032 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753161AbbHDSXr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2015 14:23:47 -0400
In-Reply-To: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

If an SRB is NULL but the handle is in range just drop the
command instead of also resetting the adapter. If the handle
is in range then the command was valid at some point and may
have been aborted. Resetting the adapter can lead to extended
recovery times in this case.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c |   20 ++++++++++++--------
 drivers/scsi/qla2xxx/qla_os.c  |    4 ++--
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index cd188cc..b2d8f83 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -19,7 +19,7 @@
  * | Device Discovery             |       0x2016       | 0x2020-0x2022, |
  * |                              |                    | 0x2011-0x2012, |
  * |                              |                    | 0x2099-0x20a4  |
- * | Queue Command and IO tracing |       0x3059       | 0x300b         |
+ * | Queue Command and IO tracing |       0x3075       | 0x300b         |
  * |                              |                    | 0x3027-0x3028  |
  * |                              |                    | 0x303d-0x3041  |
  * |                              |                    | 0x302d,0x3033  |
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index de0d9d8..a82ba35 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2074,14 +2074,18 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	}
 
 	/* Validate handle. */
-	if (handle < req->num_outstanding_cmds)
+	if (handle < req->num_outstanding_cmds) {
 		sp = req->outstanding_cmds[handle];
-	else
-		sp = NULL;
-
-	if (sp == NULL) {
+		if (!sp) {
+			ql_dbg(ql_dbg_io, vha, 0x3075,
+			    "%s(%ld): Already returned command for status handle (0x%x).\n",
+			    __func__, vha->host_no, sts->handle);
+			return;
+		}
+	} else {
 		ql_dbg(ql_dbg_io, vha, 0x3017,
-		    "Invalid status handle (0x%x).\n", sts->handle);
+		    "Invalid status handle, out of range (0x%x).\n",
+		    sts->handle);
 
 		if (!test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags)) {
 			if (IS_P3P_TYPE(ha))
@@ -2368,12 +2372,12 @@ out:
 		ql_dbg(ql_dbg_io, fcport->vha, 0x3022,
 		    "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%llu "
 		    "portid=%02x%02x%02x oxid=0x%x cdb=%10phN len=0x%x "
-		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x.\n",
+		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x sp=%p cp=%p.\n",
 		    comp_status, scsi_status, res, vha->host_no,
 		    cp->device->id, cp->device->lun, fcport->d_id.b.domain,
 		    fcport->d_id.b.area, fcport->d_id.b.al_pa, ox_id,
 		    cp->cmnd, scsi_bufflen(cp), rsp_info_len,
-		    resid_len, fw_resid_len);
+		    resid_len, fw_resid_len, sp, cp);
 
 	if (rsp->status_srb == NULL)
 		sp->done(ha, sp, res);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 070f2a1..8208f6a0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -958,8 +958,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	}
 
 	ql_dbg(ql_dbg_taskm, vha, 0x8002,
-	    "Aborting from RISC nexus=%ld:%d:%llu sp=%p cmd=%p\n",
-	    vha->host_no, id, lun, sp, cmd);
+	    "Aborting from RISC nexus=%ld:%d:%llu sp=%p cmd=%p handle=%x\n",
+	    vha->host_no, id, lun, sp, cmd, sp->handle);
 
 	/* Get a reference to the sp and drop the lock.*/
 	sp_get(sp);
-- 
1.7.7

