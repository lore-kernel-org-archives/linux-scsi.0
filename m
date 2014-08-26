From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH RESEND 2/6] qla2xxx: Use qla2x00_clear_drv_active on probe failure
Date: Tue, 26 Aug 2014 17:11:18 -0400
Message-ID: <1409087478-18745-1-git-send-email-joe.lawrence@stratus.com>
References: <1409087303-18479-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o144.mxlogic.net ([208.65.144.67]:34454 "EHLO
	p01c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbaHZVLq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Aug 2014 17:11:46 -0400
In-Reply-To: <1409087303-18479-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>, Bill Kuzeja <william.kuzeja@stratus.com>, Dave Bulkow <david.bulkow@stratus.com>, Joe Lawrence <joe.lawrence@stratus.com>

Take advantage of commit fe1b806f4f71 ("qla2xxx: Refactor shutdown code
so some functionality can be reused") to remove an inlined copy of
qla2x00_clear_drv_active in the driver's probe hardware error path.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8252c0e..53449d7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -238,6 +238,7 @@ static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
 
 static int qla2x00_change_queue_depth(struct scsi_device *, int, int);
 static int qla2x00_change_queue_type(struct scsi_device *, int);
+static void qla2x00_clear_drv_active(struct qla_hw_data *);
 static void qla2x00_free_device(scsi_qla_host_t *);
 
 struct scsi_host_template qla2xxx_driver_template = {
@@ -2954,16 +2955,8 @@ probe_failed:
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

