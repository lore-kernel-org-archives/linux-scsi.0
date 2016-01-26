From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 03/11] qla2xxx: Allow fw to hold status before sending ABTS response.
Date: Tue, 26 Jan 2016 12:10:38 -0500
Message-ID: <1453828246-28686-4-git-send-email-himanshu.madhani@qlogic.com>
References: <1453828246-28686-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:31514 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756956AbcAZRxT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jan 2016 12:53:19 -0500
In-Reply-To: <1453828246-28686-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

Set bit 12 of additional firmware options 3 to let firmware
hold status IOCB until ABTS response is received from Target.

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |   11 ++++++++++-
 drivers/scsi/qla2xxx/qla_os.c   |    7 +++++++
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 0103e46..1bfdcdf 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -121,6 +121,7 @@ extern int ql2xmdcapmask;
 extern int ql2xmdenable;
 extern int ql2xexlogins;
 extern int ql2xexchoffld;
+extern int ql2xfwholdabts;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a663ff6..cf487b9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2062,6 +2062,10 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 	if (IS_P3P_TYPE(ha))
 		return;
 
+	/*  Hold status IOCBs until ABTS response received. */
+	if (ql2xfwholdabts)
+		ha->fw_options[3] |= BIT_12;
+
 	/* Update Serial Link options. */
 	if ((le16_to_cpu(ha->fw_seriallink_options24[0]) & BIT_0) == 0)
 		return;
@@ -6410,12 +6414,17 @@ qla81xx_update_fw_options(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 
+	/*  Hold status IOCBs until ABTS response received. */
+	if (ql2xfwholdabts)
+		ha->fw_options[3] |= BIT_12;
+
 	if (!ql2xetsenable)
-		return;
+		goto out;
 
 	/* Enable ETS Burst. */
 	memset(ha->fw_options, 0, sizeof(ha->fw_options));
 	ha->fw_options[2] |= BIT_9;
+out:
 	qla2x00_set_fw_options(vha, ha->fw_options);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f1788db..d94a236 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -233,6 +233,13 @@ MODULE_PARM_DESC(ql2xexchoffld,
 		 "Number of exchanges to offload. "
 		 "0 (Default)- Disabled.");
 
+int ql2xfwholdabts = 0;
+module_param(ql2xfwholdabts, int, S_IRUGO);
+MODULE_PARM_DESC(ql2xfwholdabts,
+		"Allow FW to hold status IOCB until ABTS rsp received. "
+		"0 (Default) Do not set fw option. "
+		"1 - Set fw option to hold ABTS.");
+
 /*
  * SCSI host template entry points
  */
-- 
1.7.7

