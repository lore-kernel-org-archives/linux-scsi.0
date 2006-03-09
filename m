From: andrew.vasquez@qlogic.com
Subject: [PATCH 08/10] qla2xxx: Correct FCAL login retry logic for ISP24xx.
Date: Thu, 9 Mar 2006 14:27:44 -0800
Message-ID: <11419432591162-git-send-email-andrew.vasquez@qlogic.com>
References: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:5959 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751967AbWCIW1p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2006 17:27:45 -0500
In-Reply-To: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

ISP24XX FW does not support Mbx 0x74 ie Login Local Port.
Added the equivalent code for ISP24XX ie to relogin in non
fabric case for ISP24XX use login iocb.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_gbl.h  |    5 +++--
 drivers/scsi/qla2xxx/qla_init.c |    4 ++--
 drivers/scsi/qla2xxx/qla_mbx.c  |   11 ++++++++---
 drivers/scsi/qla2xxx/qla_os.c   |    2 +-
 4 files changed, 14 insertions(+), 8 deletions(-)

dfe53b0b4e9a31ede6ac9fc294649d070076819c
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index e897ead..91e83e2 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -42,7 +42,7 @@ extern int qla2x00_loop_resync(scsi_qla_
 
 extern int qla2x00_find_new_loop_id(scsi_qla_host_t *, fc_port_t *);
 extern int qla2x00_fabric_login(scsi_qla_host_t *, fc_port_t *, uint16_t *);
-extern int qla2x00_local_device_login(scsi_qla_host_t *, uint16_t);
+extern int qla2x00_local_device_login(scsi_qla_host_t *, fc_port_t *);
 
 extern void qla2x00_restart_queues(scsi_qla_host_t *, uint8_t);
 
@@ -166,7 +166,8 @@ qla24xx_login_fabric(scsi_qla_host_t *, 
     uint16_t *, uint8_t);
 
 extern int
-qla2x00_login_local_device(scsi_qla_host_t *, uint16_t, uint16_t *, uint8_t);
+qla2x00_login_local_device(scsi_qla_host_t *, fc_port_t *, uint16_t *,
+    uint8_t);
 
 extern int
 qla2x00_fabric_logout(scsi_qla_host_t *, uint16_t, uint8_t, uint8_t, uint8_t);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ebc7c24..89a3fc0 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2888,13 +2888,13 @@ qla2x00_fabric_login(scsi_qla_host_t *ha
  *      3 - Fatal error
  */
 int
-qla2x00_local_device_login(scsi_qla_host_t *ha, uint16_t loop_id)
+qla2x00_local_device_login(scsi_qla_host_t *ha, fc_port_t *fcport)
 {
 	int		rval;
 	uint16_t	mb[MAILBOX_REGISTER_COUNT];
 
 	memset(mb, 0, sizeof(mb));
-	rval = qla2x00_login_local_device(ha, loop_id, mb, BIT_0);
+	rval = qla2x00_login_local_device(ha, fcport, mb, BIT_0);
 	if (rval == QLA_SUCCESS) {
 		/* Interrogate mailbox registers for any errors */
 		if (mb[0] == MBS_COMMAND_ERROR)
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 85c83e0..d6cb3bd 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1631,20 +1631,25 @@ qla2x00_login_fabric(scsi_qla_host_t *ha
  *
  */
 int
-qla2x00_login_local_device(scsi_qla_host_t *ha, uint16_t loop_id,
+qla2x00_login_local_device(scsi_qla_host_t *ha, fc_port_t *fcport,
     uint16_t *mb_ret, uint8_t opt)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+		return qla24xx_login_fabric(ha, fcport->loop_id,
+		    fcport->d_id.b.domain, fcport->d_id.b.area,
+		    fcport->d_id.b.al_pa, mb_ret, opt);
+
 	DEBUG3(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
 
 	mcp->mb[0] = MBC_LOGIN_LOOP_PORT;
 	if (HAS_EXTENDED_IDS(ha))
-		mcp->mb[1] = loop_id;
+		mcp->mb[1] = fcport->loop_id;
 	else
-		mcp->mb[1] = loop_id << 8;
+		mcp->mb[1] = fcport->loop_id << 8;
 	mcp->mb[2] = opt;
 	mcp->out_mb = MBX_2|MBX_1|MBX_0;
  	mcp->in_mb = MBX_7|MBX_6|MBX_1|MBX_0;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0fc89ac..029bbf4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2295,7 +2295,7 @@ qla2x00_do_dpc(void *data)
 					} else
 						status =
 						    qla2x00_local_device_login(
-							ha, fcport->loop_id);
+							ha, fcport);
 
 					if (status == QLA_SUCCESS) {
 						fcport->old_loop_id = fcport->loop_id;
-- 
1.2.4.gf067


