From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 02/14] cxlflash: Fix crash in cxlflash_restore_luntable()
Date: Tue, 15 Nov 2016 17:14:02 -0600
Message-ID: <1479251642-22744-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45063 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S964793AbcKOXON (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Nov 2016 18:14:13 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAFNE7lt006162
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 18:14:12 -0500
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0b-001b2d01.pphosted.com with ESMTP id 26r9rwcd3q-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 18:14:12 -0500
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Tue, 15 Nov 2016 16:14:11 -0700
In-Reply-To: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>

During test, the following crash was observed:

[34538.981505] Faulting instruction address: 0xd000000007c9c870
cpu 0x9: Vector: 300 (Data Access) at [c0000007f1e8f590]
    pc: d000000007c9c870: cxlflash_restore_luntable+0x70/0x1d0 [cxlflash]
    lr: d000000007c9c84c: cxlflash_restore_luntable+0x4c/0x1d0 [cxlflash]
    sp: c0000007f1e8f810
   msr: 9000000100009033
   dar: c00000171d637438
 dsisr: 40000000
  current = 0xc0000007f1e43f90
  paca    = 0xc000000007b25100   softe: 0        irq_happened: 0x01
    pid   = 493, comm = eehd
enter ? for help
[c0000007f1e8f8a0] d000000007c940b0 init_afu+0xd60/0x1200 [cxlflash]
[c0000007f1e8f9a0] d000000007c945a8 cxlflash_pci_slot_reset+0x58/0xe0 [cxlflash]
[c0000007f1e8fa20] d00000000715f790 cxl_pci_slot_reset+0x230/0x340 [cxl]
[c0000007f1e8fae0] c000000000040dd4 eeh_report_reset+0x144/0x180
[c0000007f1e8fb20] c00000000003f708 eeh_pe_dev_traverse+0x98/0x170
[c0000007f1e8fbb0] c000000000041618 eeh_handle_normal_event+0x328/0x410
[c0000007f1e8fc30] c000000000041db8 eeh_handle_event+0x178/0x330
[c0000007f1e8fce0] c000000000042118 eeh_event_handler+0x1a8/0x1b0
[c0000007f1e8fd80] c00000000011420c kthread+0xec/0x100
[c0000007f1e8fe30] c00000000000a47c ret_from_kernel_thread+0x5c/0xe0

When superpipe mode is disabled for a LUN, the references for the
local lun are deleted but the LUN is still identified as being present
in the LUN table. This mismatched state can result in the above crash
when the LUN table is restored during an error recovery operation.

To fix this issue, the local LUN information structure is updated to
reflect the LUN is no longer in the LUN table once all references to
the LUN are gone.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/lunmgt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/cxlflash/lunmgt.c b/drivers/scsi/cxlflash/lunmgt.c
index a0923ca..6c318db9 100644
--- a/drivers/scsi/cxlflash/lunmgt.c
+++ b/drivers/scsi/cxlflash/lunmgt.c
@@ -254,8 +254,14 @@ int cxlflash_manage_lun(struct scsi_device *sdev,
 		if (lli->parent->mode != MODE_NONE)
 			rc = -EBUSY;
 		else {
+			/*
+			 * Clean up local LUN for this port and reset table
+			 * tracking when no more references exist.
+			 */
 			sdev->hostdata = NULL;
 			lli->port_sel &= ~CHAN2PORT(chan);
+			if (lli->port_sel == 0U)
+				lli->in_table = false;
 		}
 	}
 
-- 
2.1.0

