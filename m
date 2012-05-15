From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 14/22] qla2xxx: Optimize existing port name server query matching.
Date: Tue, 15 May 2012 14:34:21 -0400
Message-ID: <1337106869-14191-15-git-send-email-chad.dupuis@qlogic.com>
References: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:25546 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S966435Ab2EOS5q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2012 14:57:46 -0400
In-Reply-To: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    3 +++
 drivers/scsi/qla2xxx/qla_init.c |   14 +++++---------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f601a93..7aedd90 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1723,6 +1723,9 @@ typedef struct fc_port {
 	uint8_t scan_state;
 } fc_port_t;
 
+#define QLA_FCPORT_SCAN_NONE	0
+#define QLA_FCPORT_SCAN_FOUND	1
+
 /*
  * Fibre channel port/lun states.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6c26e04..33a23eb 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2499,6 +2499,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 	fcport->loop_id = FC_NO_LOOP_ID;
 	qla2x00_set_fcport_state(fcport, FCS_UNCONFIGURED);
 	fcport->supported_classes = FC_COS_UNSPECIFIED;
+	fcport->scan_state = QLA_FCPORT_SCAN_NONE;
 
 	return fcport;
 }
@@ -2985,13 +2986,6 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 			}
 		}
 
-#define QLA_FCPORT_SCAN		1
-#define QLA_FCPORT_FOUND	2
-
-		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			fcport->scan_state = QLA_FCPORT_SCAN;
-		}
-
 		rval = qla2x00_find_all_fabric_devs(vha, &new_fcports);
 		if (rval != QLA_SUCCESS)
 			break;
@@ -3007,7 +3001,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0)
 				continue;
 
-			if (fcport->scan_state == QLA_FCPORT_SCAN &&
+			if (fcport->scan_state != QLA_FCPORT_SCAN_FOUND &&
 			    atomic_read(&fcport->state) == FCS_ONLINE) {
 				qla2x00_mark_device_lost(vha, fcport,
 				    ql2xplogiabsentdevice, 0);
@@ -3022,7 +3016,9 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 					    fcport->d_id.b.al_pa);
 					fcport->loop_id = FC_NO_LOOP_ID;
 				}
+				continue;
 			}
+			fcport->scan_state = QLA_FCPORT_SCAN_NONE;
 		}
 
 		/* Starting free loop ID. */
@@ -3277,7 +3273,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 			    WWN_SIZE))
 				continue;
 
-			fcport->scan_state = QLA_FCPORT_FOUND;
+			fcport->scan_state = QLA_FCPORT_SCAN_FOUND;
 
 			found++;
 
-- 
1.7.7

