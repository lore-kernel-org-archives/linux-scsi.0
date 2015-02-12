From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH]  be2iscsi: Fix kernel panic when device initialization fails
Date: Thu, 12 Feb 2015 06:45:47 +0530
Message-ID: <b34d5567-d9e1-44b2-ac6d-42d97d32309f@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:42523 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbbBKIuB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2015 03:50:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Jayamohan.Kallickal@Emulex.Com, MinhDuc.Tran@Emulex.Com
Cc: John Soni Jose <sony.john-n@emulex.com>

 Kernel panic was happening as iscsi_host_remove() was called on
 a host which was not yet added.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index f319340..1b0b31c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5736,9 +5736,9 @@ free_port:
 hba_free:
 	if (phba->msix_enabled)
 		pci_disable_msix(phba->pcidev);
-	iscsi_host_remove(phba->shost);
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
+	pci_set_drvdata(pcidev, NULL);
 disable_pci:
 	pci_disable_device(pcidev);
 	return ret;
-- 
1.7.1

