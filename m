From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH 2/2] scsi: mpt3sas: wait for and flush running commands on shutdown/unload
Date: Fri, 16 Feb 2018 20:39:58 -0200
Message-ID: <1518820798-21018-3-git-send-email-mauricfo@linux.vnet.ibm.com>
References: <1518820798-21018-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750819AbeBPWkP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Feb 2018 17:40:15 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w1GMdG4S030006
        for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2018 17:40:15 -0500
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2g67yq0j0d-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2018 17:40:14 -0500
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Fri, 16 Feb 2018 17:40:14 -0500
In-Reply-To: <1518820798-21018-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Bart.VanAssche@wdc.com, sreekanth.reddy@broadcom.com
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dougmill@linux.vnet.ibm.com

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

This patch finishes all outstanding SCSI IO commands (but not other
commands, e.g., task management) in the shutdown and unload paths.

It first waits for the commands to complete (this is done after
setting 'ioc->remove_host = 1 ', which prevents new commands to
be queued) then it flushes commands that might still be running.

This avoids triggering error handling (e.g., abort command) for
all commands possibly completed by the adapter after interrupts
disabled.

Suggested-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Tested-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
[mauricfo: introduced something in commit message.]
Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |  8 ++++----
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  3 +++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 10 +++++++++-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 59a87ca..0aafbfd 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6297,14 +6297,14 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 }
 
 /**
- * _wait_for_commands_to_complete - reset controller
+ * mpt3sas_wait_for_commands_to_complete - reset controller
  * @ioc: Pointer to MPT_ADAPTER structure
  *
  * This function is waiting 10s for all pending commands to complete
  * prior to putting controller in reset.
  */
-static void
-_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc)
+void
+mpt3sas_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc)
 {
 	u32 ioc_state;
 
@@ -6377,7 +6377,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 			is_fault = 1;
 	}
 	_base_reset_handler(ioc, MPT3_IOC_PRE_RESET);
-	_wait_for_commands_to_complete(ioc);
+	mpt3sas_wait_for_commands_to_complete(ioc);
 	_base_mask_interrupts(ioc);
 	r = _base_make_ioc_ready(ioc, type);
 	if (r)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 789bc42..99ccf83 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1433,6 +1433,9 @@ void mpt3sas_base_update_missing_delay(struct MPT3SAS_ADAPTER *ioc,
 
 int mpt3sas_port_enable(struct MPT3SAS_ADAPTER *ioc);
 
+void
+mpt3sas_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc);
+
 
 /* scsih shared API */
 struct scsi_cmnd *mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 5ab3caf..c2ea13c7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4456,7 +4456,7 @@ static int _scsih_set_satl_pending(struct scsi_cmnd *scmd, bool pending)
 		st = scsi_cmd_priv(scmd);
 		mpt3sas_base_clear_st(ioc, st);
 		scsi_dma_unmap(scmd);
-		if (ioc->pci_error_recovery)
+		if (ioc->pci_error_recovery || ioc->remove_host)
 			scmd->result = DID_NO_CONNECT << 16;
 		else
 			scmd->result = DID_RESET << 16;
@@ -9742,6 +9742,10 @@ static void scsih_remove(struct pci_dev *pdev)
 	unsigned long flags;
 
 	ioc->remove_host = 1;
+
+	mpt3sas_wait_for_commands_to_complete(ioc);
+	_scsih_flush_running_cmds(ioc);
+
 	_scsih_fw_event_cleanup_queue(ioc);
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
@@ -9818,6 +9822,10 @@ static void scsih_remove(struct pci_dev *pdev)
 	unsigned long flags;
 
 	ioc->remove_host = 1;
+
+	mpt3sas_wait_for_commands_to_complete(ioc);
+	_scsih_flush_running_cmds(ioc);
+
 	_scsih_fw_event_cleanup_queue(ioc);
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
-- 
1.8.3.1
