From: giridhar.malavali@qlogic.com
Subject: [PATCH 2/7] qla2xxx: Correctly set FCF_TAPE_PRESENT flag based on scsi-device.
Date: Tue, 25 Aug 2009 11:36:16 -0700
Message-ID: <1251225381-768-3-git-send-email-giridhar.malavali@qlogic.com>
References: <1251225381-768-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47029 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755829AbZHYSgW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 14:36:22 -0400
In-Reply-To: <1251225381-768-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Santosh Vernekar <santosh.vernekar@qlogic.com>

From: Santosh Vernekar <santosh.vernekar@qlogic.com>

In fabric-login based on iop BIT_8 firmware notifies presence of
a FCP2 device and not necessarily a TAPE device.  So instead of
setting FCF_TAPE_PRESENT flag there we set it using
scsi_device->type after mid-layer scan recognises "type" of the
device.

It also adds a new flag FCF_FCP2_DEVICE for any future use.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c  |    4 ++--
 drivers/scsi/qla2xxx/qla_os.c   |    3 +++
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f19a936..b1d5148 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1614,6 +1614,7 @@ typedef struct fc_port {
 #define FCF_FABRIC_DEVICE	BIT_0
 #define FCF_LOGIN_NEEDED	BIT_1
 #define FCF_TAPE_PRESENT	BIT_2
+#define FCF_FCP2_DEVICE		BIT_3
 
 /* No loop ID flag. */
 #define FC_NO_LOOP_ID		0x1000
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2214ece..d420385 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3341,7 +3341,7 @@ qla2x00_fabric_login(scsi_qla_host_t *vha, fc_port_t *fcport,
 			} else {
 				fcport->port_type = FCT_TARGET;
 				if (mb[1] & BIT_1) {
-					fcport->flags |= FCF_TAPE_PRESENT;
+					fcport->flags |= FCF_FCP2_DEVICE;
 				}
 			}
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e07f37e..6c14b1e 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1017,7 +1017,7 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 
 		data[0] = MBS_COMMAND_COMPLETE;
 		if (lio->ctx.type == SRB_LOGIN_CMD && le16_to_cpu(mbx->mb1) & BIT_1)
-			fcport->flags |= FCF_TAPE_PRESENT;
+			fcport->flags |= FCF_FCP2_DEVICE;
 
 		goto done_post_logio_done_work;
 	}
@@ -1210,7 +1210,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		if (iop[0] & BIT_4) {
 			fcport->port_type = FCT_TARGET;
 			if (iop[0] & BIT_8)
-				fcport->flags |= FCF_TAPE_PRESENT;
+				fcport->flags |= FCF_FCP2_DEVICE;
 		}
 		if (iop[0] & BIT_5)
 			fcport->port_type = FCT_INITIATOR;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7d56692..6b2b637 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1217,6 +1217,7 @@ qla2xxx_slave_configure(struct scsi_device *sdev)
 	scsi_qla_host_t *vha = shost_priv(sdev->host);
 	struct qla_hw_data *ha = vha->hw;
 	struct fc_rport *rport = starget_to_rport(sdev->sdev_target);
+	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
 	struct req_que *req = vha->req;
 
 	if (sdev->tagged_supported)
@@ -1225,6 +1226,8 @@ qla2xxx_slave_configure(struct scsi_device *sdev)
 		scsi_deactivate_tcq(sdev, req->max_q_depth);
 
 	rport->dev_loss_tmo = ha->port_down_retry_count;
+	if (sdev->type == TYPE_TAPE)
+		fcport->flags |= FCF_TAPE_PRESENT;
 
 	return 0;
 }
-- 
1.6.2.rc1.30.gd43c

