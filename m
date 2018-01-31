From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH] test-case
Date: Wed, 31 Jan 2018 17:24:44 -0200
Message-ID: <1517426684-23050-1-git-send-email-mauricfo@linux.vnet.ibm.com>
References: <1517425200-19126-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48828 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750983AbeAaTZM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Jan 2018 14:25:12 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0VJP5ZS008671
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2018 14:25:12 -0500
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fukv004wp-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2018 14:25:11 -0500
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Wed, 31 Jan 2018 12:25:10 -0700
In-Reply-To: <1517425200-19126-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

This patch can be verified with this simple test-case,
which inserts a wait loop at the bottom of 'scsih_shutdown()'
and forces SCSI commands to timeout (skip 'scmd->scsi_done()').

It abuses the 'ioc->logging_level' parameter do to that, with:
- 0x10000000: wait loop on scsih_shutdown() and skip scsi_done()
- 0x01000000: force scsih_abort() to return FAILED early,
              so to run device/target/host reset.

Oops in scsih_abort()
=====================

Test-case:

	# echo 0x10000000 > /sys/module/mpt3sas/parameters/logging_level
	# dd if=/dev/sdf of=/dev/null count=1 iflag=direct &
	# kexec --force --append="$(cat /proc/cmdline)" --initrd=/boot/initrd.img-4.15.0 /boot/vmlinux-4.15.0

Without patch:

	[  141.936251] setting logging_level(0x10000000)
	[  141.977920] mpt3sas_cm0: skip scsi_done scmd(00000000a85f0166)
	[  147.927561] sd 16:0:1:0: [sdf] Synchronizing SCSI cache
	[  147.927831] sd 16:0:0:0: [sde] Synchronizing SCSI cache
	[  147.928090] mpt3sas_cm0: sending diag reset !!
	[  149.041346] mpt3sas_cm0: diag reset: SUCCESS
	[  149.057985] mpt3sas_cm0: sleep on shutdown
	[  150.098619] mpt3sas_cm0: sleep on shutdown
	[  151.138571] mpt3sas_cm0: sleep on shutdown
	...
	[  171.938245] mpt3sas_cm0: sleep on shutdown
	[  172.678231] sd 16:0:1:0: attempting task abort! scmd(00000000a85f0166)
	...
	[  172.678545] Unable to handle kernel paging request for data at address 0x00000008
	[  172.678600] Faulting instruction address: 0xd00000001789e8c0
	[  172.678648] Oops: Kernel access of bad area, sig: 11 [#1]
	...
	[  172.679804] NIP [d00000001789e8c0] scsih_abort+0xc0/0x290 [mpt3sas]
	[  172.679854] LR [d00000001789e8a8] scsih_abort+0xa8/0x290 [mpt3sas]
	[  172.679903] Call Trace:
	[  172.679926] [c000001fed68fbc0] [d00000001789e8a8] scsih_abort+0xa8/0x290 [mpt3sas] (unreliable)
	[  172.679994] [c000001fed68fc50] [c00000000075a274] scmd_eh_abort_handler+0xc4/0x1a0
	[  172.680053] [c000001fed68fc90] [c0000000000fea88] process_one_work+0x188/0x450
	[  172.680109] [c000001fed68fd20] [c0000000000fede8] worker_thread+0x98/0x550
	[  172.680157] [c000001fed68fdc0] [c000000000107344] kthread+0x164/0x1b0
	[  172.680206] [c000001fed68fe30] [c00000000000b6e0] ret_from_kernel_thread+0x5c/0x7c
	[  172.680261] Instruction dump:
	...

With patch:

	[  233.259952] setting logging_level(0x10000000)
	[  233.290008] mpt3sas_cm0: skip scsi_done scmd(000000007ec97dda)
	[  234.600934] sd 16:0:1:0: [sdf] Synchronizing SCSI cache
	[  234.601222] sd 16:0:0:0: [sde] Synchronizing SCSI cache
	[  234.601470] mpt3sas_cm0: sending diag reset !!
	[  235.718433] mpt3sas_cm0: diag reset: SUCCESS
	[  235.734534] mpt3sas_cm0: sleep on shutdown
	[  236.805704] mpt3sas_cm0: sleep on shutdown
	[  237.845708] mpt3sas_cm0: sleep on shutdown
	...
	[  263.845781] mpt3sas_cm0: sleep on shutdown
	[  264.185782] sd 16:0:1:0: attempting task abort! scmd(000000007ec97dda)
	...
	[  264.186104] sd 16:0:1:0: task abort: SUCCESS scmd(000000007ec97dda)
	[  264.225788] sd 16:0:1:0: [sdf] tag#0 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
	[  264.225910] sd 16:0:1:0: [sdf] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
	[  264.225969] print_req_error: I/O error, dev sdf, sector 0

Oops in scsih_host_reset()
==========================

Test-case:

	# echo 0x11000000 > /sys/module/mpt3sas/parameters/logging_level
	# dd if=/dev/sdf of=/dev/null count=1 iflag=direct &
	# kexec --force --append="$(cat /proc/cmdline)" --initrd=/boot/initrd.img-4.15.0 /boot/vmlinux-4.15.0

Without patch:

	[  241.734670] setting logging_level(0x11000000)
	[  251.587765] mpt3sas_cm0: skip scsi_done scmd(0000000060a524f9)
	[  252.771054] sd 16:0:1:0: [sdf] Synchronizing SCSI cache
	[  252.771335] sd 16:0:0:0: [sde] Synchronizing SCSI cache
	[  252.771582] mpt3sas_cm0: sending diag reset !!
	[  253.889275] mpt3sas_cm0: diag reset: SUCCESS
	[  253.906315] mpt3sas_cm0: sleep on shutdown
	[  254.966487] mpt3sas_cm0: sleep on shutdown
	[  256.006417] mpt3sas_cm0: sleep on shutdown
	...
	[  282.005452] mpt3sas_cm0: sleep on shutdown
	[  282.105416] sd 16:0:1:0: attempting task abort! scmd(0000000060a524f9)
	...
	[  282.105707] mpt3sas_cm0: fail task abort scmd(0000000060a524f9)
	[  282.105754] sd 16:0:1:0: task abort: FAILED scmd(0000000060a524f9)
	[  282.105811] sd 16:0:1:0: attempting device reset! scmd(0000000060a524f9)
	...
	[  282.106087] mpt3sas_scsih_issue_tm: mpt3sas_cm0: host reset in progress!
	[  282.106136] sd 16:0:1:0: device reset: FAILED scmd(0000000060a524f9)
	[  282.106183] scsi target16:0:1: attempting target reset! scmd(0000000060a524f9)
	...
	[  282.106467] mpt3sas_scsih_issue_tm: mpt3sas_cm0: host reset in progress!
	[  282.106516] scsi target16:0:1: target reset: FAILED scmd(0000000060a524f9)
	[  282.106603] mpt3sas_cm0: attempting host reset! scmd(0000000060a524f9)
	...
	[  282.106711] Unable to handle kernel paging request for data at address 0xd000380081790000
	[  282.106766] Faulting instruction address: 0xd000000015c669b8
	[  282.106814] Oops: Kernel access of bad area, sig: 11 [#1]
	...
	[  282.107871] NIP [d000000015c669b8] mpt3sas_base_get_iocstate+0x38/0xb0 [mpt3sas]
	[  282.107931] LR [d000000015c6a430] mpt3sas_base_hard_reset_handler+0x190/0x720 [mpt3sas]
	[  282.108027] Call Trace:
	[  282.108050] [c0000000027afab0] [d000000015c6a430] mpt3sas_base_hard_reset_handler+0x190/0x720 [mpt3sas]
	[  282.108118] [c0000000027afb80] [d000000015c712fc] scsih_host_reset+0x7c/0x100 [mpt3sas]
	[  282.108177] [c0000000027afc00] [c000000000757b1c] scsi_try_host_reset+0x5c/0x150
	[  282.114928] [c0000000027afc40] [c0000000007596ec] scsi_eh_ready_devs+0x6fc/0x930
	[  282.121871] [c0000000027afd10] [c00000000075ade0] scsi_error_handler+0x4c0/0x4e0
	[  282.128805] [c0000000027afdc0] [c000000000107344] kthread+0x164/0x1b0
	[  282.135730] [c0000000027afe30] [c00000000000b6e0] ret_from_kernel_thread+0x5c/0x7c
	[  282.142667] Instruction dump:
	...

With patch:

	[   56.769476] setting logging_level(0x11000000)
	[   56.944673] mpt3sas_cm0: skip scsi_done scmd(000000007bea2626)
	[   58.147663] sd 16:0:1:0: [sdf] Synchronizing SCSI cache
	[   58.147950] sd 16:0:0:0: [sde] Synchronizing SCSI cache
	[   58.148205] mpt3sas_cm0: sending diag reset !!
	[   59.261682] mpt3sas_cm0: diag reset: SUCCESS
	[   59.277795] mpt3sas_cm0: sleep on shutdown
	[   60.348839] mpt3sas_cm0: sleep on shutdown
	[   61.388832] mpt3sas_cm0: sleep on shutdown
	...
	[   87.388832] mpt3sas_cm0: sleep on shutdown
	[   88.208829] sd 16:0:1:0: attempting task abort! scmd(000000007bea2626)
	...
	[   88.209117] mpt3sas_cm0: fail task abort scmd(000000007bea2626)
	[   88.209160] sd 16:0:1:0: task abort: FAILED scmd(000000007bea2626)
	[   88.209224] sd 16:0:1:0: attempting device reset! scmd(000000007bea2626)
	...
	[   88.209563] sd 16:0:1:0: device reset: SUCCESS scmd(000000007bea2626)
	[   88.209614] scsi target16:0:1: attempting target reset! scmd(000000007bea2626)
	...
	[   88.209952] scsi target16:0:1: target reset: SUCCESS scmd(000000007bea2626)
	[   88.210003] mpt3sas_cm0: attempting host reset! scmd(000000007bea2626)
	...
	[   88.210117] mpt3sas_cm0: host reset: FAILED scmd(000000007bea2626)
	[   88.210166] sd 16:0:1:0: Device offlined - not ready after error recovery
	[   88.210220] sd 16:0:1:0: [sdf] tag#0 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
	[   88.210290] sd 16:0:1:0: [sdf] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
	[   88.210351] print_req_error: I/O error, dev sdf, sector 0
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 3c4e47c..611cee33 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2997,6 +2997,12 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		"attempting task abort! scmd(%p)\n", scmd);
 	_scsih_tm_display_info(ioc, scmd);
 
+	if (ioc->logging_level & 0x01000000) {
+		pr_info(MPT3SAS_FMT "fail task abort scmd(%p)\n", ioc->name, scmd);
+		r = FAILED;
+		goto out;
+	}
+
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		sdev_printk(KERN_INFO, scmd->device,
@@ -5584,6 +5590,11 @@ static int _scsih_set_satl_pending(struct scsi_cmnd *scmd, bool pending)
 
 	scsi_dma_unmap(scmd);
 
+	if (ioc->logging_level & 0x10000000 && scmd->cmnd[0] != 0x35) {
+		pr_info(MPT3SAS_FMT "skip scsi_done scmd(%p)\n", ioc->name, scmd);
+		return 1;
+	}
+
 	scmd->scsi_done(scmd);
 	return 1;
 }
@@ -10016,6 +10027,11 @@ static void scsih_remove(struct pci_dev *pdev)
 
 	_scsih_ir_shutdown(ioc);
 	mpt3sas_base_detach(ioc);
+
+	while (ioc->logging_level & 0x10000000) {
+		pr_info(MPT3SAS_FMT "sleep on shutdown\n", ioc->name);
+		ssleep(1);
+	}
 }
 
 
-- 
1.8.3.1
