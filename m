From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 6/7] be2iscsi: Fix the session cleanup when reboot/shutdown happens
Date: Sun, 12 Jan 2014 16:42:19 -0800
Message-ID: <1389573741-3523-6-git-send-email-jayamohan.kallickal@emulex.com>
References: <1389573741-3523-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52998 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaAMCiT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2014 21:38:19 -0500
Received: by mail-pd0-f174.google.com with SMTP id w10so2154031pde.19
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2014 18:38:19 -0800 (PST)
In-Reply-To: <1389573741-3523-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 In iSCSI Boot scenario, when machine is reboot/shutdown phase
 the active sessions are not closed. Driver queue cleanup is
 done as part of unload and device is disabled.

 Sessions are still active, iSCSI commands are issued from
 session which comes to driver, as driver cleanup and device
 disabled there is kernel stack dump with errors.

 Fix is invoking iscsi_session_failure with ISCSI_ERR_INVALID_HOST
 on all the active sessions when shutdown routine is called.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be.h       |    1 +
 drivers/scsi/be2iscsi/be_cmds.c  |   17 ++++++++++++++++-
 drivers/scsi/be2iscsi/be_cmds.h  |    1 +
 drivers/scsi/be2iscsi/be_iscsi.c |    1 +
 drivers/scsi/be2iscsi/be_main.c  |    2 ++
 drivers/scsi/be2iscsi/be_main.h  |    5 +++++
 6 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 23c73fe..1bfb0bd 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -139,6 +139,7 @@ struct be_ctrl_info {
 #define PAGE_SHIFT_4K 12
 #define PAGE_SIZE_4K (1 << PAGE_SHIFT_4K)
 #define mcc_timeout		120000 /* 12s timeout */
+#define BEISCSI_LOGOUT_SYNC_DELAY	250
 
 /* Returns number of pages spanned by the data starting at the given addr */
 #define PAGES_4K_SPANNED(_address, size)				\
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 4e1074a..757d10d 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -400,8 +400,23 @@ static struct be_mcc_compl *be_mcc_compl_get(struct beiscsi_hba *phba)
 	return NULL;
 }
 
-static void be2iscsi_fail_session(struct iscsi_cls_session *cls_session)
+/**
+ * be2iscsi_fail_session(): Closing session with appropriate error
+ * @cls_session: ptr to session
+ *
+ * Depending on adapter state appropriate error flag is passed.
+ **/
+void be2iscsi_fail_session(struct iscsi_cls_session *cls_session)
 {
+	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
+	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+	uint32_t iscsi_err_flag;
+
+	if (phba->state & BE_ADAPTER_STATE_SHUTDOWN)
+		iscsi_err_flag = ISCSI_ERR_INVALID_HOST;
+	else
+		iscsi_err_flag = ISCSI_ERR_CONN_FAILED;
+
 	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);
 }
 
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 59abd27..64b60e7 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -1325,4 +1325,5 @@ void be_wrb_hdr_prepare(struct be_mcc_wrb *wrb, int payload_len,
 void be_cmd_hdr_prepare(struct be_cmd_req_hdr *req_hdr,
 			u8 subsystem, u8 opcode, int cmd_len);
 
+void be2iscsi_fail_session(struct iscsi_cls_session *cls_session);
 #endif /* !BEISCSI_CMDS_H */
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 9ba2a64..0a605cd 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1371,6 +1371,7 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 	beiscsi_mccq_compl(phba, tag, NULL, NULL);
 	beiscsi_close_conn(beiscsi_ep, tcp_upload_flag);
 free_ep:
+	msleep(BEISCSI_LOGOUT_SYNC_DELAY);
 	beiscsi_free_ep(beiscsi_ep);
 	beiscsi_unbind_conn_to_cid(phba, beiscsi_ep->ep_cid);
 	iscsi_destroy_endpoint(beiscsi_ep->openiscsi_ep);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 8e19b90..89da085 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5411,6 +5411,8 @@ static void beiscsi_shutdown(struct pci_dev *pcidev)
 		return;
 	}
 
+	phba->state = BE_ADAPTER_STATE_SHUTDOWN;
+	iscsi_host_for_each_session(phba->shost, be2iscsi_fail_session);
 	beiscsi_quiesce(phba, BEISCSI_CLEAN_UNLOAD);
 	pci_disable_device(pcidev);
 }
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 62c5a24..3806a09 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -97,9 +97,14 @@
 
 #define INVALID_SESS_HANDLE	0xFFFFFFFF
 
+/**
+ * Adapter States
+ **/
 #define BE_ADAPTER_LINK_UP	0x001
 #define BE_ADAPTER_LINK_DOWN	0x002
 #define BE_ADAPTER_PCI_ERR	0x004
+#define BE_ADAPTER_STATE_SHUTDOWN	0x008
+
 
 #define BEISCSI_CLEAN_UNLOAD	0x01
 #define BEISCSI_EEH_UNLOAD	0x02
-- 
1.7.10.4

