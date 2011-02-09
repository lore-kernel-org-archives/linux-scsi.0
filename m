From: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/2] cciss: Disable ASPM
Date: Wed,  9 Feb 2011 13:07:11 -0500
Message-ID: <1297274831-10405-2-git-send-email-mjg@redhat.com>
References: <1297274831-10405-1-git-send-email-mjg@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab1BISI1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Feb 2011 13:08:27 -0500
In-Reply-To: <1297274831-10405-1-git-send-email-mjg@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mjg@redhat.com
Cc: Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org

https://bugzilla.redhat.com/show_bug.cgi?id=618612 indicates that current
hpsa hardware has problems if ASPM is enabled. Disable it to avoid crashes.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/block/cciss.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 516d5bb..bb77666 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/types.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
@@ -4561,6 +4562,9 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	InquiryData_struct *inq_buff;
 	ctlr_info_t *h;
 
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+			       PCIE_LINK_STATE_CLKPM);
+
 	rc = cciss_init_reset_devices(pdev);
 	if (rc)
 		return rc;
-- 
1.7.4

