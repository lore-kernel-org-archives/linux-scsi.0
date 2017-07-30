From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 03/29] scsi: am53c974: constify pci_device_id.
Date: Sun, 30 Jul 2017 14:07:12 +0530
Message-ID: <1501403839-8876-4-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501403839-8876-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:38342 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753947AbdG3Iht (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Jul 2017 04:37:49 -0400
In-Reply-To: <1501403839-8876-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, mdr@sgi.com, hare@suse.com, aacraid@adaptec.com, matthew@wil.cx, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, gotom@debian.or.jp, mrochs@linux.vnet.ibm.com, yokota@netlab.is.tsukuba.ac.jp, QLogic-Storage-Upstream@cavium.com, jinpu.wang@profitbricks.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/am53c974.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
index beea30e..ffc49d0 100644
--- a/drivers/scsi/am53c974.c
+++ b/drivers/scsi/am53c974.c
@@ -542,7 +542,7 @@ static void pci_esp_remove_one(struct pci_dev *pdev)
 	scsi_host_put(esp->host);
 }
 
-static struct pci_device_id am53c974_pci_tbl[] = {
+static const struct pci_device_id am53c974_pci_tbl[] = {
 	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_SCSI,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ }
-- 
2.7.4
