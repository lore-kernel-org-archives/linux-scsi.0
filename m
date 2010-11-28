From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] megaraid_sas: Convert instance->issuepend_done to atomic_t
Date: Sat, 27 Nov 2010 23:17:35 -0800
Message-ID: <1290928656-31116-3-git-send-email-nab@linux-iscsi.org>
References: <1290928656-31116-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm8-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.194]:26795 "HELO
	nm8-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751583Ab0K1HYw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Nov 2010 02:24:52 -0500
In-Reply-To: <1290928656-31116-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Bo Yang <Bo.Yang@lsi.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts struct megasas_instance->issuepend_done to
an atomic_t fw_issuepend_done.  This is because ->issuepend_done is
being used as a check to determine if SCSI_MLQUEUE_HOST_BUSY should
be returned during megasas_queue_command_lck().  So in order for a
conversion to lock-less operation to occur, this bit needs to be
handled in an atomic manner.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/megaraid/megaraid_sas.c |   13 ++++++-------
 drivers/scsi/megaraid/megaraid_sas.h |    2 +-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index c103554..fca9713 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -1344,7 +1344,7 @@ megasas_queue_command_lck(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd
 	instance = (struct megasas_instance *)
 	    scmd->device->host->hostdata;
 
-	if (instance->issuepend_done == 0)
+	if (atomic_read(&instance->fw_issuepend_done) == 0)
 		return SCSI_MLQUEUE_HOST_BUSY;
 
 	spin_lock_irqsave(&instance->hba_lock, flags);
@@ -1590,8 +1590,7 @@ void megasas_do_ocr(struct megasas_instance *instance)
 	}
 	instance->instancet->disable_intr(instance->reg_set);
 	instance->adprecovery   = MEGASAS_ADPRESET_SM_INFAULT;
-	instance->issuepend_done = 0;
-
+	atomic_set(&instance->fw_issuepend_done, 0);
 	atomic_set(&instance->fw_outstanding, 0);
 	megasas_internal_reset_defer_cmds(instance);
 	process_fw_state_change_wq(&instance->work_init);
@@ -1941,7 +1940,7 @@ megasas_service_aen(struct megasas_instance *instance, struct megasas_cmd *cmd)
 	megasas_return_cmd(instance, cmd);
 
 	if ((instance->unload == 0) &&
-		((instance->issuepend_done == 1))) {
+		((atomic_read(&instance->fw_issuepend_done) == 1))) {
 		struct megasas_aen_event *ev;
 		ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
 		if (!ev) {
@@ -2357,7 +2356,7 @@ process_fw_state_change_wq(struct work_struct *work)
 		instance->instancet->enable_intr(instance->reg_set);
 
 		megasas_issue_pending_cmds_again(instance);
-		instance->issuepend_done = 1;
+		atomic_set(&instance->fw_issuepend_done, 1);
 	}
 	return ;
 }
@@ -2417,8 +2416,8 @@ megasas_deplete_reply_queue(struct megasas_instance *instance,
 
 			instance->instancet->disable_intr(instance->reg_set);
 			instance->adprecovery	= MEGASAS_ADPRESET_SM_INFAULT;
-			instance->issuepend_done = 0;
 
+			atomic_set(&instance->fw_issuepend_done, 0);
 			atomic_set(&instance->fw_outstanding, 0);
 			megasas_internal_reset_defer_cmds(instance);
 
@@ -3798,7 +3797,7 @@ megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	megasas_poll_wait_aen = 0;
 	instance->flag_ieee = 0;
 	instance->ev = NULL;
-	instance->issuepend_done = 1;
+	atomic_set(&instance->fw_issuepend_done, 1);
 	instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
 	megasas_poll_wait_aen = 0;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index ad16f5e..eaeb873 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1303,6 +1303,7 @@ struct megasas_instance {
 
 	atomic_t fw_outstanding;
 	atomic_t fw_reset_no_pci_access;
+	atomic_t fw_issuepend_done;
 
 	struct megasas_instance_template *instancet;
 	struct tasklet_struct isr_tasklet;
@@ -1311,7 +1312,6 @@ struct megasas_instance {
 	u8 flag;
 	u8 unload;
 	u8 flag_ieee;
-	u8 issuepend_done;
 	u8 disableOnlineCtrlReset;
 	u8 adprecovery;
 	unsigned long last_time;
-- 
1.7.2.3

