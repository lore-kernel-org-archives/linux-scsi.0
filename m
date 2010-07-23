From: giridhar.malavali@qlogic.com
Subject: [PATCH 09/17] qla2xxx: Add qla2x00_free_fcports() function
Date: Fri, 23 Jul 2010 15:28:30 +0500
Message-ID: <1279880918-62876-10-git-send-email-giridhar.malavali@qlogic.com>
References: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47954 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755708Ab0GWJ73 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 05:59:29 -0400
In-Reply-To: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, madhu.iyengar@qlogic.com, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>

From: Chad Dupuis <chad.dupuis@qlogic.com>

This function was added to encapsulate freeing the memory for all the fcports
associated with a particular vha.  Also added a call to qla2x00_free_fcports()
to qla2x00_free_device() to free the memory for all the fcports associated with
a vha during device removal.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    7 +------
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_os.c   |   13 +++++++++++++
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 7ebf365..93a4c20 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1827,7 +1827,6 @@ static int
 qla24xx_vport_delete(struct fc_vport *fc_vport)
 {
 	scsi_qla_host_t *vha = fc_vport->dd_data;
-	fc_port_t *fcport, *tfcport;
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t id = vha->vp_idx;
 
@@ -1841,11 +1840,7 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 
 	scsi_remove_host(vha->host);
 
-	list_for_each_entry_safe(fcport, tfcport, &vha->vp_fcports, list) {
-		list_del(&fcport->list);
-		kfree(fcport);
-		fcport = NULL;
-	}
+	qla2x00_free_fcports(vha);
 
 	qla24xx_deallocate_vp_id(vha);
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 55f4599..84441e8 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -122,6 +122,7 @@ extern struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *,
 extern void qla2x00_free_host(struct scsi_qla_host *);
 extern void qla2x00_relogin(struct scsi_qla_host *);
 extern void qla2x00_do_work(struct scsi_qla_host *);
+extern void qla2x00_free_fcports(struct scsi_qla_host *);
 
 /*
  * Global Functions in qla_mid.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5be8db7..fcdbf7a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2487,11 +2487,24 @@ qla2x00_free_device(scsi_qla_host_t *vha)
 
 	qla2x00_free_irqs(vha);
 
+	qla2x00_free_fcports(vha);
+
 	qla2x00_mem_free(ha);
 
 	qla2x00_free_queues(ha);
 }
 
+void qla2x00_free_fcports(struct scsi_qla_host *vha)
+{
+	fc_port_t *fcport, *tfcport;
+
+	list_for_each_entry_safe(fcport, tfcport, &vha->vp_fcports, list) {
+		list_del(&fcport->list);
+		kfree(fcport);
+		fcport = NULL;
+	}
+}
+
 static inline void
 qla2x00_schedule_rport_del(struct scsi_qla_host *vha, fc_port_t *fcport,
     int defer)
-- 
1.6.0.2

