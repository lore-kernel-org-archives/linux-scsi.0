From: madhu.iyengar@qlogic.com
Subject: [PATCH 01/10] qla2xxx: Don't issue set or get port param MBC if port is not online.
Date: Fri,  3 Sep 2010 15:20:48 -0700
Message-ID: <1283552457-4497-2-git-send-email-madhu.iyengar@qlogic.com>
References: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39315 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752752Ab0ICW05 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:26:57 -0400
In-Reply-To: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c  |    7 +++----
 drivers/scsi/qla2xxx/qla_init.c |    3 +++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 9067629..fdfbf83 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1254,10 +1254,9 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
-	if (fcport->loop_id == FC_NO_LOOP_ID) {
-		DEBUG2(printk(KERN_ERR "%s(%ld): Invalid port loop id, "
-			"loop_id = 0x%x\n",
-			__func__, vha->host_no, fcport->loop_id));
+	if (atomic_read(&fcport->state) != FCS_ONLINE) {
+		DEBUG2(printk(KERN_ERR "%s(%ld): Port not online\n",
+			__func__, vha->host_no));
 		return -EINVAL;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9c383ba..3514237 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2799,6 +2799,9 @@ qla2x00_iidma_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (!IS_IIDMA_CAPABLE(ha))
 		return;
 
+	if (atomic_read(&fcport->state) != FCS_ONLINE)
+		return;
+
 	if (fcport->fp_speed == PORT_SPEED_UNKNOWN ||
 	    fcport->fp_speed > ha->link_data_rate)
 		return;
-- 
1.6.0.2

