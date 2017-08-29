From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] scsi: remove memset before memcpy
Date: Wed, 30 Aug 2017 00:19:19 +0530
Message-ID: <1504032559-24969-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com
Cc: martin.petersen@oracle.com, kashyap.desai@broadcom.com, anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, sumit.saxena@broadcom.com, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, megaraidlinux.pdl@broadcom.com, Himanshu Jha <himanshujha199640@gmail.com>
List-Id: linux-scsi@vger.kernel.org

calling memcpy immediately after memset with the same region of memory
makes memset redundant.

Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/scsi/bfa/bfa_ioc.c                  | 1 -
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 --
 drivers/scsi/qla4xxx/ql4_os.c               | 1 -
 3 files changed, 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 256f4af..c37a4be 100644
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
index 11bd2e6..20bbb9b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1505,8 +1505,6 @@ map_cmd_status(struct fusion_context *fusion,
 
 		scmd->result = (DID_OK << 16) | ext_status;
 		if (ext_status == SAM_STAT_CHECK_CONDITION) {
-			memset(scmd->sense_buffer, 0,
-			       SCSI_SENSE_BUFFERSIZE);
 			memcpy(scmd->sense_buffer, sense,
 			       SCSI_SENSE_BUFFERSIZE);
 			scmd->result |= DRIVER_SENSE << 24;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 64c6fa5..c87658c 100644
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
