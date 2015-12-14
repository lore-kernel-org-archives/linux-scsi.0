From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH 3/9] be2iscsi: Fix to remove shutdown entry point
Date: Mon, 14 Dec 2015 11:41:00 +0530
Message-ID: <1450073466-21077-4-git-send-email-jitendra.bhivare@avagotech.com>
References: <1450073466-21077-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:54830 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752406AbbLNG2S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2015 01:28:18 -0500
In-Reply-To: <1450073466-21077-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra <jitendra.bhivare@avagotech.com>

From: Jitendra <jitendra.bhivare@avagotech.com>

Null pointer dereference in shutdown path after taking dump.

Shutdown path is not needed as FW comes up clean every time during probe
after issuing FUNCTION reset MBOX command.

Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |   17 +++--------------
 drivers/scsi/be2iscsi/be_cmds.h |    2 +-
 drivers/scsi/be2iscsi/be_main.c |   24 ++++--------------------
 drivers/scsi/be2iscsi/be_main.h |    3 +--
 4 files changed, 9 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 1e70053..e4cc98f 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -414,22 +414,11 @@ static struct be_mcc_compl *be_mcc_compl_get(struct beiscsi_hba *phba)
 }
 
 /**
- * be2iscsi_fail_session(): Closing session with appropriate error
+ * beiscsi_fail_session(): Closing session with appropriate error
  * @cls_session: ptr to session
- *
- * Depending on adapter state appropriate error flag is passed.
  **/
-void be2iscsi_fail_session(struct iscsi_cls_session *cls_session)
+void beiscsi_fail_session(struct iscsi_cls_session *cls_session)
 {
-	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
-	struct beiscsi_hba *phba = iscsi_host_priv(shost);
-	uint32_t iscsi_err_flag;
-
-	if (phba->state & BE_ADAPTER_STATE_SHUTDOWN)
-		iscsi_err_flag = ISCSI_ERR_INVALID_HOST;
-	else
-		iscsi_err_flag = ISCSI_ERR_CONN_FAILED;
-
 	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);
 }
 
@@ -447,7 +436,7 @@ void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
 			    evt->physical_port);
 
 		iscsi_host_for_each_session(phba->shost,
-					    be2iscsi_fail_session);
+					    beiscsi_fail_session);
 	} else if ((evt->port_link_status & ASYNC_EVENT_LINK_UP) ||
 		    ((evt->port_link_status & ASYNC_EVENT_LOGICAL) &&
 		     (evt->port_fault == BEISCSI_PHY_LINK_FAULT_NONE))) {
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 4bfca35..5d165ee 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -1367,5 +1367,5 @@ void be_wrb_hdr_prepare(struct be_mcc_wrb *wrb, int payload_len,
 void be_cmd_hdr_prepare(struct be_cmd_req_hdr *req_hdr,
 			u8 subsystem, u8 opcode, int cmd_len);
 
-void be2iscsi_fail_session(struct iscsi_cls_session *cls_session);
+void beiscsi_fail_session(struct iscsi_cls_session *cls_session);
 #endif /* !BEISCSI_CMDS_H */
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 61ce86b..2f3e118 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5315,7 +5315,6 @@ static void beiscsi_quiesce(struct beiscsi_hba *phba,
 
 static void beiscsi_remove(struct pci_dev *pcidev)
 {
-
 	struct beiscsi_hba *phba = NULL;
 
 	phba = pci_get_drvdata(pcidev);
@@ -5325,9 +5324,9 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 	}
 
 	beiscsi_destroy_def_ifaces(phba);
-	beiscsi_quiesce(phba, BEISCSI_CLEAN_UNLOAD);
 	iscsi_boot_destroy_kset(phba->boot_kset);
 	iscsi_host_remove(phba->shost);
+	beiscsi_quiesce(phba, BEISCSI_CLEAN_UNLOAD);
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
 	pci_disable_pcie_error_reporting(pcidev);
@@ -5336,23 +5335,6 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 	pci_disable_device(pcidev);
 }
 
-static void beiscsi_shutdown(struct pci_dev *pcidev)
-{
-
-	struct beiscsi_hba *phba = NULL;
-
-	phba = (struct beiscsi_hba *)pci_get_drvdata(pcidev);
-	if (!phba) {
-		dev_err(&pcidev->dev, "beiscsi_shutdown called with no phba\n");
-		return;
-	}
-
-	phba->state = BE_ADAPTER_STATE_SHUTDOWN;
-	iscsi_host_for_each_session(phba->shost, be2iscsi_fail_session);
-	beiscsi_quiesce(phba, BEISCSI_CLEAN_UNLOAD);
-	pci_disable_device(pcidev);
-}
-
 static void beiscsi_msix_enable(struct beiscsi_hba *phba)
 {
 	int i, status;
@@ -5673,6 +5655,9 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		goto hba_free;
 	}
 
+	/*
+	 * FUNCTION_RESET should clean up any stale info in FW for this fn
+	 */
 	ret = beiscsi_cmd_reset_function(phba);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
@@ -5861,7 +5846,6 @@ static struct pci_driver beiscsi_pci_driver = {
 	.name = DRV_NAME,
 	.probe = beiscsi_dev_probe,
 	.remove = beiscsi_remove,
-	.shutdown = beiscsi_shutdown,
 	.id_table = beiscsi_pci_id_table,
 	.err_handler = &beiscsi_eeh_handlers
 };
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 5c67c07..bd9d1e1 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -103,8 +103,7 @@
 #define BE_ADAPTER_LINK_UP	0x001
 #define BE_ADAPTER_LINK_DOWN	0x002
 #define BE_ADAPTER_PCI_ERR	0x004
-#define BE_ADAPTER_STATE_SHUTDOWN	0x008
-#define BE_ADAPTER_CHECK_BOOT	0x010
+#define BE_ADAPTER_CHECK_BOOT	0x008
 
 
 #define BEISCSI_CLEAN_UNLOAD	0x01
-- 
1.7.1

