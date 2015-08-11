From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [PATCH V6 08/10] [SCSI] aacraid: Send commit-config to controller firmware
Date: Tue, 11 Aug 2015 01:58:19 -0400
Message-ID: <1439272701-15344-9-git-send-email-Mahesh.Rajashekhara@pmcs.com>
References: <1439272701-15344-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:50561 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649AbbHKF7s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2015 01:59:48 -0400
In-Reply-To: <1439272701-15344-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Rich.Bono@pmcs.com, Mahesh.Rajashekhara@pmcs.com

Description:
	Controller BIOS/UEFI driver used to send this request.  But for
	IBM-Power system there is no BIOS/UEFI driver.  So this change is
	required for IBM, otherwise controller will be read-only mode.

Changes from V2:
None

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
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

