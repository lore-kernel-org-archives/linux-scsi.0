From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 05/15] be2iscsi:moved pci_set_drvdata to inside
 beiscsi_hba_alloc
Date: Fri, 4 Dec 2009 08:50:27 +0530
Message-ID: <20091204032018.GA6080@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:6674 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753606AbZLDDUN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2009 22:20:13 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

 This patch moves pci_set_drvdata to inside beiscsi_hba_alloc

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b24be79..d5ed2c8 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -112,6 +112,7 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
 	memset(phba, 0, sizeof(*phba));
 	phba->shost = shost;
 	phba->pcidev = pci_dev_get(pcidev);
+	pci_set_drvdata(pcidev, phba);
 
 	if (iscsi_host_add(shost, &phba->pcidev->dev))
 		goto free_devices;
@@ -3733,7 +3734,6 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	}
 	SE_DEBUG(DBG_LVL_8, " phba = %p \n", phba);
 
-	pci_set_drvdata(pcidev, phba);
 	if (enable_msix)
 		num_cpus = find_num_cpus();
 	else
-- 
1.6.4

