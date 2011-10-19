From: <nagalakshmi.nandigama@lsi.com>
Subject: RESEND [PATCH 05/10] mpt2sas: Fix for issue - Drives not getting
 properly deleted if sas cable is removed while host reset is active
Date: Wed, 19 Oct 2011 15:37:00 +0530
Message-ID: <201110191612.p9JGCvk7026298@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:42107 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755407Ab1JSQNN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2011 12:13:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Fix for issue Drives not getting properly deleted if sas cable is removed 
while host reset is active. 

The fix is in the driver-firmware handshake device removal code. We
need to read the controller ioc_state to see if controller is OPERATIONAL
prior to sending target reset and OP_REMOVE. Previously it was checking
the flag ioc->shost_recovery flag, which is always set when host reset is
active, thus preventing drives from getting properly deleted.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index deb9791..141f445 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3018,11 +3018,23 @@ _scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	struct MPT2SAS_TARGET *sas_target_priv_data;
 	unsigned long flags;
 	struct _tr_list *delayed_tr;
+	u32 ioc_state;
 
-	if (ioc->shost_recovery || ioc->remove_host ||
-	    ioc->pci_error_recovery) {
-		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: host reset in "
-		   "progress!\n", __func__, ioc->name));
+	if (ioc->remove_host) {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: host has been "
+		    "removed: handle(0x%04x)\n", __func__, ioc->name, handle));
+		return;
+	} else if (ioc->pci_error_recovery) {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: host in pci "
+		    "error recovery: handle(0x%04x)\n", __func__, ioc->name,
+		    handle));
+		return;
+	}
+	ioc_state = mpt2sas_base_get_iocstate(ioc, 1);
+	if (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: host is not "
+		   "operational: handle(0x%04x)\n", __func__, ioc->name,
+		   handle));
 		return;
 	}
 
@@ -3223,11 +3235,21 @@ _scsih_tm_tr_complete(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	    mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	Mpi2SasIoUnitControlRequest_t *mpi_request;
 	u16 smid_sas_ctrl;
+	u32 ioc_state;
 
-	if (ioc->shost_recovery || ioc->remove_host ||
-	    ioc->pci_error_recovery) {
-		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: host reset in "
-		   "progress!\n", __func__, ioc->name));
+	if (ioc->remove_host) {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: host has been "
+		   "removed\n", __func__, ioc->name));
+		return 1;
+	} else if (ioc->pci_error_recovery) {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: host in pci "
+		    "error recovery\n", __func__, ioc->name));
+		return 1;
+	}
+	ioc_state = mpt2sas_base_get_iocstate(ioc, 1);
+	if (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: host is not "
+		    "operational\n", __func__, ioc->name));
 		return 1;
 	}
 
