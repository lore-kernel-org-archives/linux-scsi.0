From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 05/12]  be2iscsi:moved pci_set_drvdata to inside
 beiscsi_hba_alloc
Date: Tue, 5 Jan 2010 05:07:49 +0530
Message-ID: <20100104233739.GA16781@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:14473 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753794Ab0ADXh1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 18:37:27 -0500
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
index 4a855a9..18471ed 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -112,6 +112,7 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
 	memset(phba, 0, sizeof(*phba));
 	phba->shost = shost;
 	phba->pcidev = pci_dev_get(pcidev);
+	pci_set_drvdata(pcidev, phba);
 
 	if (iscsi_host_add(shost, &phba->pcidev->dev))
 		goto free_devices;
@@ -3734,7 +3735,6 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	}
 	SE_DEBUG(DBG_LVL_8, " phba = %p \n", phba);
 
-	pci_set_drvdata(pcidev, phba);
 	if (enable_msix)
 		num_cpus = find_num_cpus();
 	else
-- 
1.6.4

