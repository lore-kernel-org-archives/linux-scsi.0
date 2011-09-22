From: Roland Dreier <roland@purestorage.com>
Subject: [PATCH] [SCSI] qla2xxx: Fix crash in qla2x00_abort_all_cmds() on unload
Date: Thu, 22 Sep 2011 00:06:05 -0700
Message-ID: <1316675165-6207-1-git-send-email-roland@purestorage.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:59161 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751001Ab1IVHGM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2011 03:06:12 -0400
Received: by gyd10 with SMTP id 10so2039107gyd.12
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2011 00:06:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

I hit a crash in qla2x00_abort_all_cmds() if the qla2xxx module is
unloaded right after it is loaded.  I debugged this down to the abort
handling improperly treating a command of type SRB_ADISC_CMD as if it
had a bsg_job to complete when that command actually uses the iocb_cmd
part of the union.  (I guess to hit this one has to unload the module
while the async FC initialization is still in progress)

It seems we should only look for a bsg_job if type is SRB_ELS_CMD_RPT,
SRB_ELS_CMD_HST or SRB_CT_CMD, so switch the test to make that explicit.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
I don't know the code well enough to be sure this is the right fix,
but there's definitely a crash here :)

 drivers/scsi/qla2xxx/qla_os.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4cace3f..1e69527 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1328,10 +1328,9 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 					qla2x00_sp_compl(ha, sp);
 				} else {
 					ctx = sp->ctx;
-					if (ctx->type == SRB_LOGIN_CMD ||
-					    ctx->type == SRB_LOGOUT_CMD) {
-						ctx->u.iocb_cmd->free(sp);
-					} else {
+					if (ctx->type == SRB_ELS_CMD_RPT ||
+					    ctx->type == SRB_ELS_CMD_HST ||
+					    ctx->type == SRB_CT_CMD) {
 						struct fc_bsg_job *bsg_job =
 						    ctx->u.bsg_job;
 						if (bsg_job->request->msgcode
@@ -1343,6 +1342,8 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 						kfree(sp->ctx);
 						mempool_free(sp,
 							ha->srb_mempool);
+					} else {
+						ctx->u.iocb_cmd->free(sp);
 					}
 				}
 			}
