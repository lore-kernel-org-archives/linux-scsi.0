From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH V4 6/9] aacraid: Fundamental reset support for Series 7
Date: Fri, 29 Jan 2016 14:45:47 -0800
Message-ID: <1454107550-24173-7-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
References: <1454107550-24173-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:36229 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932595AbcA2Wfn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jan 2016 17:35:43 -0500
In-Reply-To: <1454107550-24173-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, jthumshirn@suse.de, thenzl@redhat.com, shane.seymour@hpe.com, RaghavaAditya.Renukunta@pmcs.com

From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>

Series 7 does not support PCI hot reset used by EEH.

Enabled fundamental reset only for Series 7

Changes in V2:
None

Changes in V3:
None

Changes in V4:
None

Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/aacraid/linit.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 4bc4503..af8974e 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1135,6 +1135,12 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	u64 dmamask;
 	extern int aac_sync_mode;
 
+	/*
+	 * Only series 7 needs freset.
+	 */
+	 if (pdev->device == PMC_DEVICE_S7)
+		pdev->needs_freset = 1;
+
 	list_for_each_entry(aac, &aac_devices, entry) {
 		if (aac->id > unique_id)
 			break;
-- 
1.9.1

