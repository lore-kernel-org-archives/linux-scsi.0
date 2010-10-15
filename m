From: madhu.iyengar@qlogic.com
Subject: [PATCH 04/12] qla2xxx: Change del_timer_sync() to del_timer() in qla2x00_ctx_sp_free().
Date: Fri, 15 Oct 2010 11:27:41 -0700
Message-ID: <1287167269-8034-5-git-send-email-madhu.iyengar@qlogic.com>
References: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36961 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756243Ab0JOSg2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2010 14:36:28 -0400
In-Reply-To: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>

From: Chad Dupuis <chad.dupuis@qlogic.com>

Using del_timer_sync() in the qla2x00_ctx_sp_free() function may cause a kernel
panic as it is not interrupt context safe and qla2x00_ctx_sp_free() may be
called from a softirq context.  Changing the call from del_timer_sync() to
del_timer() will make the function interrupt context safe.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6ea5376..77c68a7 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -71,7 +71,7 @@ qla2x00_ctx_sp_free(srb_t *sp)
 	struct srb_iocb *iocb = ctx->u.iocb_cmd;
 	struct scsi_qla_host *vha = sp->fcport->vha;
 
-	del_timer_sync(&iocb->timer);
+	del_timer(&iocb->timer);
 	kfree(iocb);
 	kfree(ctx);
 	mempool_free(sp, sp->fcport->vha->hw->srb_mempool);
-- 
1.6.0.2

