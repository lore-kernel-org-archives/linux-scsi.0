From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH] scsi: qla4xxx: Remove redundant memset before memcpy
Date: Fri, 13 Jan 2017 15:34:50 +0530
Message-ID: <1484301890-22207-1-git-send-email-mayhs11saini@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35099 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751380AbdAMKFH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2017 05:05:07 -0500
Received: by mail-pf0-f196.google.com with SMTP id f144so7792769pfa.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2017 02:05:07 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anil.gurumurthy@qlogic.com
Cc: sudarsana.kalluru@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, linux-scsi@vger.kernel.org, Shyam Saini <mayhs11saini@gmail.com>

The region set by the call to memset, immediately overwritten by the
subsequent call to memcpy and thus makes the  memset redundant

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 drivers/scsi/bfa/bfa_ioc.c                  | 1 -
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 --
 drivers/scsi/qla4xxx/ql4_os.c               | 1 -
 3 files changed, 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index a1ada4a..a3aa8d3 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -2763,7 +2763,6 @@ bfa_ioc_get_type(struct bfa_ioc_s *ioc)
 void
 bfa_ioc_get_adapter_serial_num(struct bfa_ioc_s *ioc, char *serial_num)
 {
-	memset((void *)serial_num, 0, BFA_ADAPTER_SERIAL_NUM_LEN);
 	memcpy((void *)serial_num,
 			(void *)ioc->attr->brcd_serialnum,
 			BFA_ADAPTER_SERIAL_NUM_LEN);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 24778ba..32102f6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1406,8 +1406,6 @@ map_cmd_status(struct megasas_cmd_fusion *cmd, u8 status, u8 ext_status)
 
 		cmd->scmd->result = (DID_OK << 16) | ext_status;
 		if (ext_status == SAM_STAT_CHECK_CONDITION) {
-			memset(cmd->scmd->sense_buffer, 0,
-			       SCSI_SENSE_BUFFERSIZE);
 			memcpy(cmd->scmd->sense_buffer, cmd->sense,
 			       SCSI_SENSE_BUFFERSIZE);
 			cmd->scmd->result |= DRIVER_SENSE << 24;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 9fbb33f..21c1c78 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -619,7 +619,6 @@ static void qla4xxx_create_chap_list(struct scsi_qla_host *ha)
 		goto exit_chap_list;
 	}
 
-	memset(ha->chap_list, 0, chap_size);
 	memcpy(ha->chap_list, chap_flash_data, chap_size);
 
 exit_chap_list:
-- 
2.7.4

