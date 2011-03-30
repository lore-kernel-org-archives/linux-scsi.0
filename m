From: madhu.iyengar@qlogic.com
Subject: [PATCH 17/18] qla2xxx: Log fcport state transitions when debug messages are enabled.
Date: Wed, 30 Mar 2011 11:46:32 -0700
Message-ID: <1301510793-2492-18-git-send-email-madhu.iyengar@qlogic.com>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45799 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755737Ab1C3SvR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 14:51:17 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>

From: Chad Dupuis <chad.dupuis@qlogic.com>

Add the inline function qla2x00_set_port_state() so that when a fcport state
transition happens we can log the state transition if debug messages are
enabled.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   |    2 +-
 drivers/scsi/qla2xxx/qla_def.h    |    8 ++++++++
 drivers/scsi/qla2xxx/qla_init.c   |    6 +++---
 drivers/scsi/qla2xxx/qla_inline.h |   19 +++++++++++++++++++
 drivers/scsi/qla2xxx/qla_mid.c    |    2 +-
 drivers/scsi/qla2xxx/qla_os.c     |    6 +++---
 6 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index cee3eed..75faf48 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1568,7 +1568,7 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 
 	/* Now that the rport has been deleted, set the fcport state to
 	   FCS_DEVICE_DEAD */
-	atomic_set(&fcport->state, FCS_DEVICE_DEAD);
+	qla2x00_set_fcport_state(fcport, FCS_DEVICE_DEAD);
 
 	/*
 	 * Transport has effectively 'deleted' the rport, clear
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 316f01b..738d3fc 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1717,6 +1717,14 @@ typedef struct fc_port {
 #define FCS_DEVICE_LOST		3
 #define FCS_ONLINE		4
 
+static const char * const port_state_str[] = {
+	"Unknown",
+	"UNCONFIGURED",
+	"DEAD",
+	"LOST",
+	"ONLINE"
+};
+
 /*
  * FC port flags.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d31ac9b..24d2d19 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2544,7 +2544,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 	fcport->vp_idx = vha->vp_idx;
 	fcport->port_type = FCT_UNKNOWN;
 	fcport->loop_id = FC_NO_LOOP_ID;
-	atomic_set(&fcport->state, FCS_UNCONFIGURED);
+	qla2x00_set_fcport_state(fcport, FCS_UNCONFIGURED);
 	fcport->supported_classes = FC_COS_UNSPECIFIED;
 
 	return fcport;
@@ -2730,7 +2730,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 			    "loop_id=0x%04x\n",
 			    vha->host_no, fcport->loop_id));
 
-			atomic_set(&fcport->state, FCS_DEVICE_LOST);
+			qla2x00_set_fcport_state(fcport, FCS_DEVICE_LOST);
 		}
 	}
 
@@ -2942,7 +2942,7 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	qla2x00_iidma_fcport(vha, fcport);
 	qla24xx_update_fcport_fcp_prio(vha, fcport);
 	qla2x00_reg_remote_port(vha, fcport);
-	atomic_set(&fcport->state, FCS_ONLINE);
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 }
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 4d17e70..4c8167e 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -83,3 +83,22 @@ qla2x00_clean_dsd_pool(struct qla_hw_data *ha, srb_t *sp)
 	}
 	INIT_LIST_HEAD(&((struct crc_context *)sp->ctx)->dsd_list);
 }
+
+static inline void
+qla2x00_set_fcport_state(fc_port_t *fcport, int state)
+{
+	int old_state;
+
+	old_state = atomic_read(&fcport->state);
+	atomic_set(&fcport->state, state);
+
+	/* Don't print state transitions during initial allocation of fcport */
+	if (old_state && old_state != state) {
+		DEBUG(qla_printk(KERN_WARNING, fcport->vha->hw,
+		    "scsi(%ld): FCPort state transitioned from %s to %s - "
+		    "portid=%02x%02x%02x.\n", fcport->vha->host_no,
+		    port_state_str[old_state], port_state_str[state],
+		    fcport->d_id.b.domain, fcport->d_id.b.area,
+		    fcport->d_id.b.al_pa));
+	}
+}
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 3082e2f..e34d7dd 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -136,7 +136,7 @@ qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
 		    vha->host_no, fcport->loop_id, fcport->vp_idx));
 
 		qla2x00_mark_device_lost(vha, fcport, 0, 0);
-		atomic_set(&fcport->state, FCS_UNCONFIGURED);
+		qla2x00_set_fcport_state(fcport, FCS_UNCONFIGURED);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7eeab98..05cec05 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2552,7 +2552,7 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
 {
 	if (atomic_read(&fcport->state) == FCS_ONLINE &&
 	    vha->vp_idx == fcport->vp_idx) {
-		atomic_set(&fcport->state, FCS_DEVICE_LOST);
+		qla2x00_set_fcport_state(fcport, FCS_DEVICE_LOST);
 		qla2x00_schedule_rport_del(vha, fcport, defer);
 	}
 	/*
@@ -2560,7 +2560,7 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
 	 * port but do the retries.
 	 */
 	if (atomic_read(&fcport->state) != FCS_DEVICE_DEAD)
-		atomic_set(&fcport->state, FCS_DEVICE_LOST);
+		qla2x00_set_fcport_state(fcport, FCS_DEVICE_LOST);
 
 	if (!do_login)
 		return;
@@ -2615,7 +2615,7 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha, int defer)
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD)
 			continue;
 		if (atomic_read(&fcport->state) == FCS_ONLINE) {
-			atomic_set(&fcport->state, FCS_DEVICE_LOST);
+			qla2x00_set_fcport_state(fcport, FCS_DEVICE_LOST);
 			if (defer)
 				qla2x00_schedule_rport_del(vha, fcport, defer);
 			else if (vha->vp_idx == fcport->vp_idx)
-- 
1.6.0.2

