From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH v2 6/8] qla2xxx: disable scsi_transport_fc registration in target mode
Date: Tue, 14 Jul 2015 16:00:47 -0400
Message-ID: <1436904049-27707-7-git-send-email-himanshu.madhani@qlogic.com>
References: <1436904049-27707-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436904049-27707-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Alexei Potashnik <alexei@purestorage.com>

There are multiple reasons for disabling this:

1. It provides no functional benefit. We pretty much only get a few more
sysfs entries for each port, but all that information is already
available from /sys/kernel/debug/target/qla-session-X

2. It already only works in private-loop mode. By disabling we'll be
getting more uniform behavior with fabric mode.

3. It creates complications for the new PLOGI handling mechanism:
scsi_transport_fc port deletion timer could race with new session
from initiator and cause logout after successful login.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   14 +++++++++++---
 drivers/scsi/qla2xxx/qla_os.c   |    3 ++-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3f3cdbf..5ba5851 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3338,8 +3338,7 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 	if (IS_QLAFX00(vha->hw)) {
 		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-		qla2x00_reg_remote_port(vha, fcport);
-		return;
+		goto reg_port;
 	}
 	fcport->login_retry = 0;
 	fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
@@ -3347,7 +3346,16 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 	qla2x00_iidma_fcport(vha, fcport);
 	qla24xx_update_fcport_fcp_prio(vha, fcport);
-	qla2x00_reg_remote_port(vha, fcport);
+
+reg_port:
+	if (qla_ini_mode_enabled(vha))
+		qla2x00_reg_remote_port(vha, fcport);
+	else {
+		/*
+		 * Create target mode FC NEXUS in qla_target.c
+		 */
+		qlt_fc_port_added(vha, fcport);
+	}
 }
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index be6de2a..8a5cac8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3235,7 +3235,8 @@ qla2x00_schedule_rport_del(struct scsi_qla_host *vha, fc_port_t *fcport,
 		qla2xxx_wake_dpc(base_vha);
 	} else {
 		int now;
-		fc_remote_port_delete(rport);
+		if (rport)
+			fc_remote_port_delete(rport);
 		qlt_do_generation_tick(vha, &now);
 		qlt_fc_port_deleted(vha, fcport, now);
 	}
-- 
1.7.7
