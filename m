From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH 07/10] aacraid: Fix AIF triggered IOP_RESET
Date: Tue, 1 Dec 2015 04:39:45 -0800
Message-ID: <1448973589-9216-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:48252 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753760AbbLATeV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2015 14:34:21 -0500
In-Reply-To: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com, RaghavaAditya.Renukunta@pmcs.com

From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>

while driver removal is in progress or PCI shutdown is invoked, driver
kills AIF aacraid thread, but IOCTL requests from the management tools
re-start AIF thread leading to IOP_RESET.

Fixed by setting adapter_shutdown flag when PCI shutdown is invoked.

Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
---
 drivers/scsi/aacraid/linit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 6912efd..3a4dbe7 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1454,6 +1454,7 @@ static int aac_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
 
 	scsi_block_requests(shost);
+	aac->adapter_shutdown = 1;
 	aac_send_shutdown(aac);
 
 	aac_release_resources(aac);
-- 
1.9.1

