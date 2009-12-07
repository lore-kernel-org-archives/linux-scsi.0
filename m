From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: [PATCH 1/5] BNX2I - Add 5771E device support to bnx2i driver
Date: Mon, 7 Dec 2009 11:39:33 -0800
Message-ID: <1260214773.31468.92.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1603 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbZLGTje (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Dec 2009 14:39:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, mchan@broadcom.com, poswald@novell.com

    * Add code to enumerate 5771E device

Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 0c4210d..3c46458 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -83,8 +83,12 @@ void bnx2i_identify_device(struct bnx2i_hba *hba)
 		set_bit(BNX2I_NX2_DEV_5709, &hba->cnic_dev_type);
 		hba->mail_queue_access = BNX2I_MQ_BIN_MODE;
 	} else if (hba->pci_did == PCI_DEVICE_ID_NX2_57710 ||
-		   hba->pci_did == PCI_DEVICE_ID_NX2_57711)
+		   hba->pci_did == PCI_DEVICE_ID_NX2_57711 ||
+		   hba->pci_did == PCI_DEVICE_ID_NX2_57711E)
 		set_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type);
+	else
+		printk(KERN_ALERT "bnx2i: unknown device, 0x%x\n", 
+				  hba->pci_did);
 }
 
 
-- 
1.6.5.1




