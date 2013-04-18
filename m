From: James Smart <james.smart@emulex.com>
Subject: [PATCH 15/22] lpfc 8.3.39: Fixed not returning FAILED status when
 SCSI invoking host reset handler failed
Date: Wed, 17 Apr 2013 20:18:39 -0400
Message-ID: <1366244319.1513.16.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:15683 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935682Ab3DRASo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:18:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed not returning FAILED status when SCSI invoking host reset handler failed


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_crtn.h |    1 +
 lpfc_init.c |    2 +-
 lpfc_scsi.c |   14 +++++++++++---
 3 files changed, 13 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2013-04-10 16:46:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2013-04-15 18:26:46.908041345 -0400
@@ -470,3 +470,4 @@ int lpfc_sli4_xri_sgl_update(struct lpfc
 void lpfc_free_sgl_list(struct lpfc_hba *, struct list_head *);
 uint32_t lpfc_sli_port_speed_get(struct lpfc_hba *);
 int lpfc_sli4_request_firmware_update(struct lpfc_hba *, uint8_t);
+void lpfc_sli4_offline_eratt(struct lpfc_hba *);
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-04-15 18:26:40.579041201 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-04-15 18:26:46.925041345 -0400
@@ -1202,7 +1202,7 @@ lpfc_offline_eratt(struct lpfc_hba *phba
  * This routine is called to bring a SLI4 HBA offline when HBA hardware error
  * other than Port Error 6 has been detected.
  **/
-static void
+void
 lpfc_sli4_offline_eratt(struct lpfc_hba *phba)
 {
 	lpfc_offline_prep(phba, LPFC_MBX_NO_WAIT);
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-04-15 18:26:43.653041272 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-04-15 18:26:46.934041346 -0400
@@ -5376,16 +5376,24 @@ lpfc_host_reset_handler(struct scsi_cmnd
 	struct lpfc_hba *phba = vport->phba;
 	int rc, ret = SUCCESS;
 
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+			 "3172 SCSI layer issued Host Reset Data:\n");
+
 	lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 	lpfc_offline(phba);
 	rc = lpfc_sli_brdrestart(phba);
 	if (rc)
 		ret = FAILED;
-	lpfc_online(phba);
+	rc = lpfc_online(phba);
+	if (rc)
+		ret = FAILED;
 	lpfc_unblock_mgmt_io(phba);
 
-	lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
-			"3172 SCSI layer issued Host Reset Data: x%x\n", ret);
+	if (ret == FAILED) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+				 "3323 Failed host reset, bring it offline\n");
+		lpfc_sli4_offline_eratt(phba);
+	}
 	return ret;
 }
 



