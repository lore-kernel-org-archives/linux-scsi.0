From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 15/18] be2iscsi: Fix the session cleanup when reboot/shutdown happens
Date: Fri,  5 Apr 2013 20:38:35 -0700
Message-ID: <1365219519-3457-15-git-send-email-jayamohan.kallickal@emulex.com>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58127 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422636Ab3DFDjK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 23:39:10 -0400
Received: by mail-pa0-f47.google.com with SMTP id bj3so2343645pad.6
        for <linux-scsi@vger.kernel.org>; Fri, 05 Apr 2013 20:39:10 -0700 (PDT)
In-Reply-To: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 During reboot/shutdown cycle, the active sessions were not updated.
 In iSCSI Boot case, the boot session was alive and this fix informs
 that the machine is going down, so no more ops happens on that session.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |    2 +-
 drivers/scsi/be2iscsi/be_cmds.h |    3 +++
 drivers/scsi/be2iscsi/be_main.c |    1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index e66aa7c..a3bfc1d 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -340,7 +340,7 @@ static struct be_mcc_compl *be_mcc_compl_get(struct beiscsi_hba *phba)
 	return NULL;
 }
 
-static void be2iscsi_fail_session(struct iscsi_cls_session *cls_session)
+void be2iscsi_fail_session(struct iscsi_cls_session *cls_session)
 {
 	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);
 }
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 9907308..2288625 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -18,6 +18,7 @@
 #ifndef BEISCSI_CMDS_H
 #define BEISCSI_CMDS_H
 
+#include <scsi/scsi_transport_iscsi.h>
 /**
  * The driver sends configuration and managements command requests to the
  * firmware in the BE. These requests are communicated to the processor
@@ -735,6 +736,8 @@ int be_cmd_wrbq_create(struct be_ctrl_info *ctrl, struct be_dma_mem *q_mem,
 
 bool is_link_state_evt(u32 trailer);
 
+void be2iscsi_fail_session(struct iscsi_cls_session *cls_session);
+
 /* Configuration Functions */
 int be_cmd_set_vlan(struct beiscsi_hba *phba, uint16_t vlan_tag);
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 228d331..672fdf6 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4841,6 +4841,7 @@ static void beiscsi_shutdown(struct pci_dev *pcidev)
 		return;
 	}
 
+	iscsi_host_for_each_session(phba->shost, be2iscsi_fail_session);
 	beiscsi_quiesce(phba);
 	pci_disable_device(pcidev);
 }
-- 
1.7.10.4

