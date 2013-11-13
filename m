From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Subject: [PATCH] scsi/ipr: Bugfix: add null pointer check for ioa_cfg
Date: Tue, 12 Nov 2013 22:02:17 -0500
Message-ID: <1384311737-1663-1-git-send-email-qiudayu@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:33788 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab3KMDC2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2013 22:02:28 -0500
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <qiudayu@linux.vnet.ibm.com>;
	Wed, 13 Nov 2013 08:32:25 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id CD6C7125805D
	for <linux-scsi@vger.kernel.org>; Wed, 13 Nov 2013 08:33:10 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rAD32Ja245547528
	for <linux-scsi@vger.kernel.org>; Wed, 13 Nov 2013 08:32:19 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rAD32LJO008865
	for <linux-scsi@vger.kernel.org>; Wed, 13 Nov 2013 08:32:21 +0530
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: brking@us.ibm.com, JBottomley@parallels.com, Mike Qiu <qiudayu@linux.vnet.ibm.com>

When we detects EEH errors during driver probe time, the error
handlers of the driver are invoked by EEH core. Unfortunately,
we haven't built some data structs that the error handlers
refers to. That leads to kernel crash eventually.

task: c000000010d66a60 ti: c000000010ff0000 task.ti: c000000010ff0000
NIP: d0000000008cb4dc LR: d0000000008cb4d8 CTR: c0000000084af4e0
REGS: c000000010ff37b0 TRAP: 0300   Tainted: G        W
MSR: 8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 88000028  XER: 20000009
SOFTE: 1
CFAR: c00000000800908c
DAR: 00000000000012e0, DSISR: 40000000

GPR00: c00000000806b258 c000000010ff3a30 d0000000008e3bb8 0000000000000000
GPR04: 0000000000000002 0000000000000000 8000010019990500 0000000000000000
GPR08: c0000000091c9778 c000000026904440 d0000000008cb350 c0000000084af4e0
GPR12: d0000000008d5000 c00000000ec50400 c0000000080bce10 c000000026a73af0
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR24: c000000009074ea8 c000000026083960 c000000026083960 0000000000000000
GPR28: c000000010ff3c80 d0000000008db330 c000000010ff3c80 c00000002669b000
NIP [d0000000008cb4dc] .ipr_pci_error_detected+0x18c/0x220 [ipr]
LR [d0000000008cb4d8] .ipr_pci_error_detected+0x188/0x220 [ipr]
PACATMSCRATCH [800000000280f032]
 Call Trace:
[c000000010ff3a30] [c000000010ff3ad0] 0xc000000010ff3ad0 (unreliable)
[c000000010ff3ad0] [c00000000806b258] .eeh_report_error+0x98/0x110
[c000000010ff3b60] [c00000000806a19c] .eeh_pe_dev_traverse+0x9c/0x190
[c000000010ff3c10] [c00000000806b670] .eeh_handle_event+0x70/0x330
[c000000010ff3ca0] [c00000000806ba58] .eeh_event_handler+0x128/0x190
[c000000010ff3d30] [c0000000080bcef8] .kthread+0xe8/0xf0
[c000000010ff3e30] [c00000000800a1dc] .ret_from_kernel_thread+0x5c/0x80
Instruction dump:
eb41ffd0 eb61ffd8 eb81ffe0 7c0803a6 eba1ffe8 ebc1fff0 ebe1fff8 4e800020
60420000 38630090 48009b2d e8410028 <e92312e0> 7c7f1b78 e8690058 48009609

This patch is to solve this issue.

Reported-by: Ping Tian Han <pthan@cn.ibm.com>
Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 36ac1c3..5304809 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -8652,6 +8652,8 @@ static void ipr_pci_frozen(struct pci_dev *pdev)
 	unsigned long flags = 0;
 	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
 
+	if (unlikely(!ioa_cfg))
+		return;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
 	_ipr_initiate_ioa_reset(ioa_cfg, ipr_reset_freeze, IPR_SHUTDOWN_NONE);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
@@ -8670,6 +8672,8 @@ static pci_ers_result_t ipr_pci_slot_reset(struct pci_dev *pdev)
 	unsigned long flags = 0;
 	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
 
+	if (unlikely(!ioa_cfg))
+		return PCI_ERS_RESULT_NONE;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
 	if (ioa_cfg->needs_warm_reset)
 		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
@@ -8693,6 +8697,8 @@ static void ipr_pci_perm_failure(struct pci_dev *pdev)
 	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
 	int i;
 
+	if (unlikely(!ioa_cfg))
+		return;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
 	if (ioa_cfg->sdt_state == WAIT_FOR_DUMP)
 		ioa_cfg->sdt_state = ABORT_DUMP;
@@ -9740,6 +9746,8 @@ static void __ipr_remove(struct pci_dev *pdev)
 	unsigned long driver_lock_flags;
 	ENTER;
 
+	if (unlikely(!ioa_cfg))
+		return;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
 	while (ioa_cfg->in_reset_reload) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
@@ -9789,6 +9797,8 @@ static void ipr_remove(struct pci_dev *pdev)
 
 	ENTER;
 
+	if (unlikely(!ioa_cfg))
+		return;
 	ipr_remove_trace_file(&ioa_cfg->host->shost_dev.kobj,
 			      &ipr_trace_attr);
 	ipr_remove_dump_file(&ioa_cfg->host->shost_dev.kobj,
@@ -9887,6 +9897,8 @@ static void ipr_shutdown(struct pci_dev *pdev)
 	unsigned long lock_flags = 0;
 	int i;
 
+	if (unlikely(!ioa_cfg))
+		return;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	if (blk_iopoll_enabled && ioa_cfg->iopoll_weight &&
 			ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
-- 
1.8.2.1

