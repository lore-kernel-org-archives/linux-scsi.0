From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 16/23] Revert "[SCSI] qla2xxx: Optimize existing port name server query matching."
Date: Fri,  8 Feb 2013 01:57:57 -0500
Message-ID: <1360306684-8286-17-git-send-email-saurav.kashyap@qlogic.com>
References: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:11612 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759916Ab3BHHTL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:11 -0500
In-Reply-To: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

This reverts commit c0822b63ccbf3b019059f384c290b080cae859f1.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    3 ---
 drivers/scsi/qla2xxx/qla_init.c |   14 +++++++++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3d980a2..a8d97f7 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1848,9 +1848,6 @@ typedef struct fc_port {
 	uint8_t scan_state;
 } fc_port_t;
 
-#define QLA_FCPORT_SCAN_NONE	0
-#define QLA_FCPORT_SCAN_FOUND	1
-
 /*
  * Fibre channel port/lun states.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 51f007f..edb4f8e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2746,7 +2746,6 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 	fcport->loop_id = FC_NO_LOOP_ID;
 	qla2x00_set_fcport_state(fcport, FCS_UNCONFIGURED);
 	fcport->supported_classes = FC_COS_UNSPECIFIED;
-	fcport->scan_state = QLA_FCPORT_SCAN_NONE;
 
 	return fcport;
 }
@@ -3229,6 +3228,13 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 			}
 		}
 
+#define QLA_FCPORT_SCAN		1
+#define QLA_FCPORT_FOUND	2
+
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			fcport->scan_state = QLA_FCPORT_SCAN;
+		}
+
 		rval = qla2x00_find_all_fabric_devs(vha, &new_fcports);
 		if (rval != QLA_SUCCESS)
 			break;
@@ -3244,7 +3250,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0)
 				continue;
 
-			if (fcport->scan_state != QLA_FCPORT_SCAN_FOUND &&
+			if (fcport->scan_state == QLA_FCPORT_SCAN &&
 			    atomic_read(&fcport->state) == FCS_ONLINE) {
 				qla2x00_mark_device_lost(vha, fcport,
 				    ql2xplogiabsentdevice, 0);
@@ -3259,9 +3265,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 					    fcport->d_id.b.al_pa);
 					fcport->loop_id = FC_NO_LOOP_ID;
 				}
-				continue;
 			}
-			fcport->scan_state = QLA_FCPORT_SCAN_NONE;
 		}
 
 		/* Starting free loop ID. */
@@ -3516,7 +3520,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 			    WWN_SIZE))
 				continue;
 
-			fcport->scan_state = QLA_FCPORT_SCAN_FOUND;
+			fcport->scan_state = QLA_FCPORT_FOUND;
 
 			found++;
 
-- 
1.7.7

