From: madhu.iyengar@qlogic.com
Subject: [PATCH 13/14] qla2xxx: Fix to avoid recursive lock failure during BSG timeout.
Date: Tue, 21 Dec 2010 16:00:26 -0800
Message-ID: <1292976027-12034-14-git-send-email-madhu.iyengar@qlogic.com>
References: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36172 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754042Ab0LVADZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 19:03:25 -0500
In-Reply-To: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 10942fc..903b058 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1512,6 +1512,7 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 				if (((sp_bsg->type == SRB_CT_CMD) ||
 					(sp_bsg->type == SRB_ELS_CMD_HST))
 					&& (sp_bsg->u.bsg_job == bsg_job)) {
+					spin_unlock_irqrestore(&ha->hardware_lock, flags);
 					if (ha->isp_ops->abort_command(sp)) {
 						DEBUG2(qla_printk(KERN_INFO, ha,
 						    "scsi(%ld): mbx "
@@ -1527,6 +1528,7 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 						bsg_job->req->errors =
 						bsg_job->reply->result = 0;
 					}
+					spin_lock_irqsave(&ha->hardware_lock, flags);
 					goto done;
 				}
 			}
-- 
1.6.0.2

