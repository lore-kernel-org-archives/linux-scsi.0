From: madhu.iyengar@qlogic.com
Subject: [PATCH 12/18] qla2xxx: Add test for valid loop id to qla2x00_relogin().
Date: Wed, 30 Mar 2011 11:46:27 -0700
Message-ID: <1301510793-2492-13-git-send-email-madhu.iyengar@qlogic.com>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45810 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755550Ab1C3SvS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 14:51:18 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Joe Carnuccio <joe.carnuccio@qlogic.com>

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

If fabric device has invalid loop id (FC_NO_LOOP_ID) then call
qla2x00_find_new_loop_id() to attempt to obtain valid loop id.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    2 ++
 drivers/scsi/qla2xxx/qla_init.c |    4 +---
 drivers/scsi/qla2xxx/qla_os.c   |   11 +++++++++++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index d009c6f..cd646ca 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -39,6 +39,8 @@ extern int qla81xx_load_risc(scsi_qla_host_t *, uint32_t *);
 extern int qla2x00_perform_loop_resync(scsi_qla_host_t *);
 extern int qla2x00_loop_resync(scsi_qla_host_t *);
 
+extern int qla2x00_find_new_loop_id(scsi_qla_host_t *, fc_port_t *);
+
 extern int qla2x00_fabric_login(scsi_qla_host_t *, fc_port_t *, uint16_t *);
 extern int qla2x00_local_device_login(scsi_qla_host_t *, fc_port_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2c9f47a..234c1c2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -35,8 +35,6 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 
 static int qla2x00_restart_isp(scsi_qla_host_t *);
 
-static int qla2x00_find_new_loop_id(scsi_qla_host_t *, fc_port_t *);
-
 static struct qla_chip_state_84xx *qla84xx_get_chip(struct scsi_qla_host *);
 static int qla84xx_init_chip(scsi_qla_host_t *);
 static int qla25xx_init_queues(struct qla_hw_data *);
@@ -3390,7 +3388,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
  * Context:
  *	Kernel context.
  */
-static int
+int
 qla2x00_find_new_loop_id(scsi_qla_host_t *vha, fc_port_t *dev)
 {
 	int	rval;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2255033..b36964d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3214,6 +3214,17 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 							fcport->d_id.b.area,
 							fcport->d_id.b.al_pa);
 
+				if (fcport->loop_id == FC_NO_LOOP_ID) {
+					fcport->loop_id = next_loopid =
+					    ha->min_external_loopid;
+					status = qla2x00_find_new_loop_id(
+					    vha, fcport);
+					if (status != QLA_SUCCESS) {
+						/* Ran out of IDs to use */
+						break;
+					}
+				}
+
 				if (IS_ALOGIO_CAPABLE(ha)) {
 					fcport->flags |= FCF_ASYNC_SENT;
 					data[0] = 0;
-- 
1.6.0.2

