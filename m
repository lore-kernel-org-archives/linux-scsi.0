From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: RE: [PATCH v2] scsi: mpt3sas: fix oops in error handlers after shutdown/unload
Date: Mon, 12 Feb 2018 11:58:53 +0530
Message-ID: <2fd5c995219c5e07ef04765f67b9b8a7@mail.gmail.com>
References: <1517523386-9868-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:46850 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932396AbeBLG24 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2018 01:28:56 -0500
Received: by mail-pl0-f65.google.com with SMTP id x2so609388plr.13
        for <linux-scsi@vger.kernel.org>; Sun, 11 Feb 2018 22:28:55 -0800 (PST)
In-Reply-To: <1517523386-9868-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Bart.VanAssche@wdc.com
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dougmill@linux.vnet.ibm.com

Mauricio,

Instead of returning the scmd with DID_NO_CONNECT in TM path, can we wait
for some time (10 seconds) in shutdown/unload path for the outstanding
commands to complete and even then the scmds are outstanding then return
all the outstanding scmds with DID_NO_CONNECT in the shutdown/unload path
itself as shown below,

----
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c
b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 13d6e4e..f62ce50 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6294,14 +6294,14 @@ _base_reset_handler(struct MPT3SAS_ADAPTER *ioc,
int reset_phase)
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

@@ -6374,7 +6374,7 @@ mpt3sas_base_hard_reset_handler(struct
MPT3SAS_ADAPTER *ioc,
 			is_fault = 1;
 	}
 	_base_reset_handler(ioc, MPT3_IOC_PRE_RESET);
-	_wait_for_commands_to_complete(ioc);
+	mpt3sas_wait_for_commands_to_complete(ioc);
 	_base_mask_interrupts(ioc);
 	r = _base_make_ioc_ready(ioc, type);
 	if (r)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h
b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 789bc42..99ccf83 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1433,6 +1433,9 @@ void mpt3sas_base_update_missing_delay(struct
MPT3SAS_ADAPTER *ioc,

 int mpt3sas_port_enable(struct MPT3SAS_ADAPTER *ioc);

+void
+mpt3sas_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc);
+

 /* scsih shared API */
 struct scsi_cmnd *mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER
*ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 74fca18..458709e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4453,7 +4453,7 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER
*ioc)
 		st = scsi_cmd_priv(scmd);
 		mpt3sas_base_clear_st(ioc, st);
 		scsi_dma_unmap(scmd);
-		if (ioc->pci_error_recovery)
+		if (ioc->pci_error_recovery || ioc->remove_host)
 			scmd->result = DID_NO_CONNECT << 16;
 		else
 			scmd->result = DID_RESET << 16;
@@ -9739,6 +9739,10 @@ static void scsih_remove(struct pci_dev *pdev)
 	unsigned long flags;

 	ioc->remove_host = 1;
+
+	mpt3sas_wait_for_commands_to_complete(ioc);
+	_scsih_flush_running_cmds(ioc);
+
 	_scsih_fw_event_cleanup_queue(ioc);

 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
@@ -9815,6 +9819,10 @@ scsih_shutdown(struct pci_dev *pdev)
 	unsigned long flags;

 	ioc->remove_host = 1;
+
+	mpt3sas_wait_for_commands_to_complete(ioc);
+	_scsih_flush_running_cmds(ioc);
+
 	_scsih_fw_event_cleanup_queue(ioc);

 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
---

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Mauricio Faria de
Oliveira
Sent: Friday, February 2, 2018 3:46 AM
To: linux-scsi@vger.kernel.org; Bart.VanAssche@wdc.com
Cc: sathya.prakash@broadcom.com; chaitra.basappa@broadcom.com;
suganath-prabu.subramani@broadcom.com; jejb@linux.vnet.ibm.com;
martin.petersen@oracle.com; dougmill@linux.vnet.ibm.com
Subject: [PATCH v2] scsi: mpt3sas: fix oops in error handlers after
shutdown/unload

This patch adds checks for 'ioc->remove_host' in the SCSI error handlers,
so not to access pointers/resources potentially freed in the PCI
shutdown/module unload path.  The error handlers may be invoked after
shutdown/unload, depending on other components.

This problem was observed with kexec on a system with a mpt3sas based
adapter and an infiniband adapter which takes long enough to shutdown:

The mpt3sas driver finished shutting down / disabled interrupt handling,
thus some commands have not finished and timed out.

Since the system was still running (waiting for the infiniband adapter to
shutdown), the scsi error handler for task abort of mpt3sas was invoked,
and hit an oops -- either in scsih_abort() because 'ioc->scsi_lookup' was
NULL (without commit dbec4c9040ed
("scsi: mpt3sas: lockless command submission")), or later up in
scsih_host_reset() (with or without that commit), because it eventually
called mpt3sas_base_get_iocstate().

After that commit, the oops in scsih_abort() does not occur anymore
(_scsih_scsi_lookup_find_by_scmd() is no longer called), but that commit
is too big and out of the scope of linux-stable, where this patch might
help, so still go for the changes.

Also, this might help to prevent similar errors in the future, in case
code changes and possibly tries to access freed stuff.

Note the fix in scsih_host_reset() is still important anyway.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
v2:
 - rebase on top of mkp/scsi.git's fixes branch
 - insert check for 'ioc->remove_host' in existing
   checks which already set DID_NO_CONNECT instead
   of duplicating that code. (helps with backports)
 - update commit message about that commit.

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 74fca18..5ab3caf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2835,7 +2835,8 @@ int mpt3sas_scsih_issue_locked_tm(struct
MPT3SAS_ADAPTER *ioc, u16 handle,
 	_scsih_tm_display_info(ioc, scmd);

 	sas_device_priv_data = scmd->device->hostdata;
-	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
+	    ioc->remove_host) {
 		sdev_printk(KERN_INFO, scmd->device,
 			"device been deleted! scmd(%p)\n", scmd);
 		scmd->result = DID_NO_CONNECT << 16;
@@ -2898,7 +2899,8 @@ int mpt3sas_scsih_issue_locked_tm(struct
MPT3SAS_ADAPTER *ioc, u16 handle,
 	_scsih_tm_display_info(ioc, scmd);

 	sas_device_priv_data = scmd->device->hostdata;
-	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
+	    ioc->remove_host) {
 		sdev_printk(KERN_INFO, scmd->device,
 			"device been deleted! scmd(%p)\n", scmd);
 		scmd->result = DID_NO_CONNECT << 16;
@@ -2961,7 +2963,8 @@ int mpt3sas_scsih_issue_locked_tm(struct
MPT3SAS_ADAPTER *ioc, u16 handle,
 	_scsih_tm_display_info(ioc, scmd);

 	sas_device_priv_data = scmd->device->hostdata;
-	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
+	    ioc->remove_host) {
 		starget_printk(KERN_INFO, starget, "target been deleted!
scmd(%p)\n",
 			scmd);
 		scmd->result = DID_NO_CONNECT << 16;
@@ -3019,7 +3022,7 @@ int mpt3sas_scsih_issue_locked_tm(struct
MPT3SAS_ADAPTER *ioc, u16 handle,
 	    ioc->name, scmd);
 	scsi_print_command(scmd);

-	if (ioc->is_driver_loading) {
+	if (ioc->is_driver_loading || ioc->remove_host) {
 		pr_info(MPT3SAS_FMT "Blocking the host reset\n",
 		    ioc->name);
 		r = FAILED;
--
1.8.3.1
