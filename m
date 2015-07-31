From: Ketan Mukadam <ketan.mukadam@avagotech.com>
Subject: [PATCH 1/1] be2iscsi : Add warning message for unsupported adapter
Date: Sat,  1 Aug 2015 03:50:08 +0530
Message-ID: <1438381208-7780-1-git-send-email-ketan.mukadam@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:51799 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751625AbbGaFyk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2015 01:54:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Ketan Mukadam <ketan.mukadam@avagotech.com>

Add a warning message to indicate obsolete/unsupported
BE2 Adapter Family devics

Signed-off-by: Ketan Mukadam <ketan.mukadam@avagotech.com>
---
 drivers/scsi/be2iscsi/be_main.c | 2 ++
 drivers/scsi/be2iscsi/be_mgmt.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 7a6dbfb..9b0c5cc 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5619,6 +5619,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	case OC_DEVICE_ID2:
 		phba->generation = BE_GEN2;
 		phba->iotask_fn = beiscsi_iotask;
+		dev_warn(&pcidev->dev,
+			 "Obsolete, Unsupported BE2 Adapter Family\n");
 		break;
 	case BE_DEVICE_ID2:
 	case OC_DEVICE_ID3:
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index ca4016f..ac08adb 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1535,7 +1535,8 @@ beiscsi_adap_family_disp(struct device *dev, struct device_attribute *attr,
 	case BE_DEVICE_ID1:
 	case OC_DEVICE_ID1:
 	case OC_DEVICE_ID2:
-		return snprintf(buf, PAGE_SIZE, "BE2 Adapter Family\n");
+		return snprintf(buf, PAGE_SIZE, "Obsolete/Unsupported "
+						"BE2 Adapter Family\n");
 		break;
 	case BE_DEVICE_ID2:
 	case OC_DEVICE_ID3:
-- 
1.8.3.1

