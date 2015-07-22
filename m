From: <rajinikanth.pandurangan@pmcs.com>
Subject: [PATCH V5 08/11] [SCSI] aacraid: Send commit-config to controller firmware
Date: Wed, 22 Jul 2015 09:49:14 -0700
Message-ID: <1437583757-5449-9-git-send-email-rajinikanth.pandurangan@pmcs.com>
References: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:57054 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965440AbbGVQuL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jul 2015 12:50:11 -0400
In-Reply-To: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, rich.bono@pmcs.com, mahesh.rajashekhara@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com, rajinikanth.pandurangan@pmcs.com

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Description:
        Controller BIOS/UEFI driver used to send this request.  But for
        IBM-Power system there is no BIOS/UEFI driver.  So this change is
        required for IBM, otherwise controller will be read-only mode.

Changes from V2:
None

Reviewed by:
 Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>,
 Johannes Thumshirn <jthumshirn@suse.de>

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/linit.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 3b6e5c6..35dd849 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1270,8 +1270,11 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		shost->max_channel = aac->maximum_num_channels;
 	else
 		shost->max_channel = 0;
-
+#if defined(__powerpc__) || defined(__PPC__) || defined(__ppc__)
+	aac_get_config_status(aac, 1);
+#else
 	aac_get_config_status(aac, 0);
+#endif
 	aac_get_containers(aac);
 	list_add(&aac->entry, insert);
 
-- 
1.9.3

