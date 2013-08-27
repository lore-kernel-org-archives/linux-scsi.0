From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 11/29] qla2xxx: Notify ISPFX00 firmware when driver is unloaded or system is shut down.
Date: Tue, 27 Aug 2013 01:37:37 -0400
Message-ID: <1377581875-8574-12-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51771 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852Ab3H0GGl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:41 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R64Oi4012247
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:40 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq13pa9-6
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:40 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Acked-by: Srinivasa Rao <srinivasa.rao@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    1 +
 drivers/scsi/qla2xxx/qla_mr.c  |    2 +-
 drivers/scsi/qla2xxx/qla_os.c  |    7 +++++++
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index d03b15d..9a80c49 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -594,6 +594,7 @@ extern int qlafx00_start_scsi(srb_t *);
 extern int qlafx00_abort_isp(scsi_qla_host_t *);
 extern int qlafx00_iospace_config(struct qla_hw_data *);
 extern int qlafx00_init_firmware(scsi_qla_host_t *, uint16_t);
+extern int qlafx00_driver_shutdown(scsi_qla_host_t *, int);
 extern int qlafx00_fw_ready(scsi_qla_host_t *);
 extern int qlafx00_configure_devices(scsi_qla_host_t *);
 extern int qlafx00_reset_initialize(scsi_qla_host_t *);
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index e087a49..ab2ae8e 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -294,7 +294,7 @@ premature_exit:
  * Context:
  *	Kernel context.
  */
-static int
+int
 qlafx00_driver_shutdown(scsi_qla_host_t *vha, int tmo)
 {
 	int rval;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3f53151..17a86b6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3006,6 +3006,10 @@ qla2x00_shutdown(struct pci_dev *pdev)
 	vha = pci_get_drvdata(pdev);
 	ha = vha->hw;
 
+	/* Notify ISPFX00 firmware */
+	if (IS_QLAFX00(ha))
+		qlafx00_driver_shutdown(vha, 20);
+
 	/* Turn-off FCE trace */
 	if (ha->flags.fce_enabled) {
 		qla2x00_disable_fce_trace(vha, NULL, NULL);
@@ -3053,6 +3057,9 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	ha->flags.host_shutting_down = 1;
 
 	set_bit(UNLOADING, &base_vha->dpc_flags);
+	if (IS_QLAFX00(ha))
+		qlafx00_driver_shutdown(base_vha, 20);
+
 	mutex_lock(&ha->vport_lock);
 	while (ha->cur_vport_count) {
 		spin_lock_irqsave(&ha->vport_slock, flags);
-- 
1.7.7

