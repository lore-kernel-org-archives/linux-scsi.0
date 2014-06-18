From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 2/6] qla2xxx: Use qla2x00_clear_drv_active on probe failure
Date: Wed, 18 Jun 2014 10:02:15 -0400
Message-ID: <1403100139-1798-3-git-send-email-joe.lawrence@stratus.com>
References: <1403100139-1798-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o141.mxlogic.net ([208.65.145.74]:56876 "EHLO
	p02c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaFROEa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jun 2014 10:04:30 -0400
In-Reply-To: <1403100139-1798-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>, Bill Kuzeja <william.kuzeja@stratus.com>, Dave Bulkow <david.bulkow@stratus.com>, Joe Lawrence <joe.lawrence@stratus.com>

Take advantage of commit fe1b806f "qla2xxx: Refactor shutdown code so
some functionality can be reused" to remove an inlined copy of
qla2x00_clear_drv_active in the driver's probe hardware error path.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6a512b7..31913bb 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -238,6 +238,7 @@ static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
 
 static int qla2x00_change_queue_depth(struct scsi_device *, int, int);
 static int qla2x00_change_queue_type(struct scsi_device *, int);
+static void qla2x00_clear_drv_active(struct qla_hw_data *);
 static void qla2x00_free_device(scsi_qla_host_t *);
 
 struct scsi_host_template qla2xxx_driver_template = {
@@ -2946,16 +2947,8 @@ probe_failed:
 	scsi_host_put(base_vha->host);
 
 probe_hw_failed:
-	if (IS_QLA82XX(ha)) {
-		qla82xx_idc_lock(ha);
-		qla82xx_clear_drv_active(ha);
-		qla82xx_idc_unlock(ha);
-	}
-	if (IS_QLA8044(ha)) {
-		qla8044_idc_lock(ha);
-		qla8044_clear_drv_active(ha);
-		qla8044_idc_unlock(ha);
-	}
+	qla2x00_clear_drv_active(ha);
+
 iospace_config_failed:
 	if (IS_P3P_TYPE(ha)) {
 		if (!ha->nx_pcibase)
-- 
1.7.10.4

