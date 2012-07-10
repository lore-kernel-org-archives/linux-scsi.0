From: Jon Mason <jdmason@kudzu.us>
Subject: [PATCH RESUBMIT 1/3] qla4xxx: remove unnecessary read of PCI_CAP_ID_EXP
Date: Tue, 10 Jul 2012 14:57:55 -0700
Message-ID: <1341957477-30946-2-git-send-email-jdmason@kudzu.us>
References: <1341957477-30946-1-git-send-email-jdmason@kudzu.us>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56985 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab2GJV5g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jul 2012 17:57:36 -0400
Received: by yhmm54 with SMTP id m54so571606yhm.19
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jul 2012 14:57:35 -0700 (PDT)
In-Reply-To: <1341957477-30946-1-git-send-email-jdmason@kudzu.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, Ravi Anand <ravi.anand@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, iscsi-driver@qlogic.com

The PCIE capability offset is saved during PCI bus walking.  It will
remove an unnecessary search in the PCI configuration space if this
value is referenced instead of reacquiring it.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
Cc: Ravi Anand <ravi.anand@qlogic.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: iscsi-driver@qlogic.com
---
 drivers/scsi/qla4xxx/ql4_nx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 228b670..939d726 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1590,7 +1590,7 @@ qla4_8xxx_start_firmware(struct scsi_qla_host *ha, uint32_t image_start)
 	}
 
 	/* Negotiated Link width */
-	pcie_cap = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
+	pcie_cap = pci_pcie_cap(ha->pdev);
 	pci_read_config_word(ha->pdev, pcie_cap + PCI_EXP_LNKSTA, &lnk);
 	ha->link_width = (lnk >> 4) & 0x3f;
 
-- 
1.7.9.5

