From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 12/13] be2iscsi: Add warning message for unsupported adapter
Date: Tue, 13 Dec 2016 15:56:05 +0530
Message-ID: <1481624766-13846-13-git-send-email-jitendra.bhivare@broadcom.com>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:34410 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932562AbcLMK1S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2016 05:27:18 -0500
Received: by mail-qt0-f172.google.com with SMTP id n6so102374573qtd.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2016 02:27:18 -0800 (PST)
In-Reply-To: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Ketan Mukadam <ketan.mukadam@avagotech.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

From: Ketan Mukadam <ketan.mukadam@avagotech.com>

Add a warning message to indicate obsolete/unsupported
BE2 Adapter Family devices

Signed-off-by: Ketan Mukadam <ketan.mukadam@avagotech.com>
Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 2 ++
 drivers/scsi/be2iscsi/be_mgmt.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index d96f7068..6372613 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5640,6 +5640,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	case OC_DEVICE_ID2:
 		phba->generation = BE_GEN2;
 		phba->iotask_fn = beiscsi_iotask;
+		dev_warn(&pcidev->dev,
+			 "Obsolete/Unsupported BE2 Adapter Family\n");
 		break;
 	case BE_DEVICE_ID2:
 	case OC_DEVICE_ID3:
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 8acacd5e..2f6d5c2 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1262,7 +1262,8 @@ beiscsi_adap_family_disp(struct device *dev, struct device_attribute *attr,
 	case BE_DEVICE_ID1:
 	case OC_DEVICE_ID1:
 	case OC_DEVICE_ID2:
-		return snprintf(buf, PAGE_SIZE, "BE2 Adapter Family\n");
+		return snprintf(buf, PAGE_SIZE,
+				"Obsolete/Unsupported BE2 Adapter Family\n");
 		break;
 	case BE_DEVICE_ID2:
 	case OC_DEVICE_ID3:
-- 
2.7.4

