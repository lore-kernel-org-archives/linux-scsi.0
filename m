From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 03/14] lpfc: Set driver environment data on adapter
Date: Thu, 11 Aug 2016 11:35:50 -0700
Message-ID: <57acc586.QP/MzTE9arrPa2Cj%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:36480 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbcHKSfx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 14:35:53 -0400
Received: by mail-qk0-f170.google.com with SMTP id l2so4044383qkf.3
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 11:35:53 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id r10sm2227909qtc.5.2016.08.11.11.35.51
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Aug 2016 11:35:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Set driver environment data on adapter

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h | 12 ++++++++++++
 drivers/scsi/lpfc/lpfc_sli.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index ee80227..0b2c337 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -921,6 +921,7 @@ struct mbox_header {
 #define LPFC_MBOX_OPCODE_GET_PORT_NAME			0x4D
 #define LPFC_MBOX_OPCODE_MQ_CREATE_EXT			0x5A
 #define LPFC_MBOX_OPCODE_GET_VPD_DATA			0x5B
+#define LPFC_MBOX_OPCODE_SET_HOST_DATA			0x5D
 #define LPFC_MBOX_OPCODE_SEND_ACTIVATION		0x73
 #define LPFC_MBOX_OPCODE_RESET_LICENSES			0x74
 #define LPFC_MBOX_OPCODE_GET_RSRC_EXTENT_INFO		0x9A
@@ -2919,6 +2920,16 @@ struct lpfc_mbx_set_feature {
 };
 
 
+#define LPFC_SET_HOST_OS_DRIVER_VERSION    0x2
+struct lpfc_mbx_set_host_data {
+#define LPFC_HOST_OS_DRIVER_VERSION_SIZE   48
+	struct mbox_header header;
+	uint32_t param_id;
+	uint32_t param_len;
+	uint8_t  data[LPFC_HOST_OS_DRIVER_VERSION_SIZE];
+};
+
+
 struct lpfc_mbx_get_sli4_parameters {
 	struct mbox_header header;
 	struct lpfc_sli4_parameters sli4_parameters;
@@ -3313,6 +3324,7 @@ struct lpfc_mqe {
 		struct lpfc_mbx_get_port_name get_port_name;
 		struct lpfc_mbx_set_feature  set_feature;
 		struct lpfc_mbx_memory_dump_type3 mem_dump_type3;
+		struct lpfc_mbx_set_host_data set_host_data;
 		struct lpfc_mbx_nop nop;
 	} un;
 };
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7080ce2..0082e59 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -47,6 +47,7 @@
 #include "lpfc_compat.h"
 #include "lpfc_debugfs.h"
 #include "lpfc_vport.h"
+#include "lpfc_version.h"
 
 /* There are only four IOCB completion types. */
 typedef enum _lpfc_iocb_type {
@@ -6289,6 +6290,25 @@ lpfc_sli4_repost_els_sgl_list(struct lpfc_hba *phba)
 	return 0;
 }
 
+void
+lpfc_set_host_data(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
+{
+	uint32_t len;
+
+	len = sizeof(struct lpfc_mbx_set_host_data) -
+		sizeof(struct lpfc_sli4_cfg_mhdr);
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_SET_HOST_DATA, len,
+			 LPFC_SLI4_MBX_EMBED);
+
+	mbox->u.mqe.un.set_host_data.param_id = LPFC_SET_HOST_OS_DRIVER_VERSION;
+	mbox->u.mqe.un.set_host_data.param_len = 8;
+	snprintf(mbox->u.mqe.un.set_host_data.data,
+		 LPFC_HOST_OS_DRIVER_VERSION_SIZE,
+		 "Linux %s v"LPFC_DRIVER_VERSION,
+		 (phba->hba_flag & HBA_FCOE_MODE) ? "FCoE" : "FC");
+}
+
 /**
  * lpfc_sli4_hba_setup - SLI4 device intialization PCI function
  * @phba: Pointer to HBA context object.
@@ -6540,6 +6560,15 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		goto out_free_mbox;
 	}
 
+	lpfc_set_host_data(phba, mboxq);
+
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
+				"2134 Failed to set host os driver version %x",
+				rc);
+	}
+
 	/* Read the port's service parameters. */
 	rc = lpfc_read_sparam(phba, mboxq, vport->vpi);
 	if (rc) {
-- 
2.5.0

