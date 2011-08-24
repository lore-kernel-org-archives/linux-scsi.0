From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Subject: [PATCH 3/3] be2iscsi: Add pci_disable device
Date: Wed, 24 Aug 2011 16:05:32 -0700
Message-ID: <1ee446c7-467f-4a82-b70b-6acd0a2b6fa6@exht1.ad.emulex.com>
References: <1314227133-3678-1-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:5729 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751821Ab1HXXGS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2011 19:06:18 -0400
In-Reply-To: <1314227133-3678-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

This patch adds call to pci_disable_device during
rmmod and shutdown. The lack of this call was causing hang in
insmod - rmmod loop test

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 8570436..ffaae49 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4180,6 +4180,7 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 	iscsi_host_remove(phba->shost);
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
+	pci_disable_device(pcidev);
 }
 
 static void beiscsi_shutdown(struct pci_dev *pcidev)
@@ -4193,6 +4194,7 @@ static void beiscsi_shutdown(struct pci_dev *pcidev)
 	}
 
 	beiscsi_quiesce(phba);
+	pci_disable_device(pcidev);
 }
 
 static void beiscsi_msix_enable(struct beiscsi_hba *phba)
-- 
1.7.1

