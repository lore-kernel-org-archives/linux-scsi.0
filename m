From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 09/10] mpt2sas: Call the _scsih_ir_shutdown prior to reporting the volumes missing from the OS
Date: Tue, 4 Jan 2011 11:40:23 +0530
Message-ID: <20110104061015.GJ5751@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:51753 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176Ab1ADHEc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2011 02:04:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Issue:
IR shutdown(sending) and IR shutdown(complete) messages not
listed in /var/log/messages when driver is removed.

The driver needs to issue a MPI2_RAID_ACTION_SYSTEM_SHUTDOWN_INITIATED
request when the driver is unloaded so the IR metadata journal is updated.
If this request is not sent, then the volume would need a "check
consistency" issued on the next bootup if the volume was roamed from one
initiator to another. The current driver supports this feature only when the
system is rebooted, however this also need to be supported if the driver is
unloaded

Fix:
To fix this issue, the driver is going
to need to call the _scsih_ir_shutdown prior to reporting
the volumes missing from the OS, hence the device handles
are still present.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index db287d7..5ded3db 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -6665,6 +6665,7 @@ _scsih_remove(struct pci_dev *pdev)
 		destroy_workqueue(wq);
 
 	/* release all the volumes */
+	_scsih_ir_shutdown(ioc);
 	list_for_each_entry_safe(raid_device, next, &ioc->raid_device_list,
 	    list) {
 		if (raid_device->starget) {
