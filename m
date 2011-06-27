From: Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 01/19] qla4xxx: remove unnecessary read of PCI_CAP_ID_EXP
Date: Mon, 27 Jun 2011 12:37:12 -0500
Message-ID: <1309196232-15663-1-git-send-email-jdmason@kudzu.us>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34108 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab1F0RhR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2011 13:37:17 -0400
Received: by pzk9 with SMTP id 9so3099811pzk.19
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2011 10:37:17 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, iscsi-driver@qlogic.com, linux-scsi@vger.kernel.org

The PCIE capability offset is saved during PCI bus walking.  It will
remove an unnecessary search in the PCI configuration space if this
value is referenced instead of reacquiring it.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
---
 drivers/scsi/qla4xxx/ql4_nx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index fdfe27b..3a4bf7d 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1582,7 +1582,7 @@ qla4_8xxx_start_firmware(struct scsi_qla_host *ha, uint32_t image_start)
 	}
 
 	/* Negotiated Link width */
-	pcie_cap = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
+	pcie_cap = pci_pcie_cap(ha->pdev);
 	pci_read_config_word(ha->pdev, pcie_cap + PCI_EXP_LNKSTA, &lnk);
 	ha->link_width = (lnk >> 4) & 0x3f;
 
-- 
1.7.5.4

