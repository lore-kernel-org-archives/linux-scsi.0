From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 11/12] be2iscsi: Add warning message for unsupported adapter
Date: Mon,  5 Dec 2016 13:36:50 +0530
Message-ID: <1480925211-13223-12-git-send-email-jitendra.bhivare@broadcom.com>
References: <1480925211-13223-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:36580 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbcLEIHc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 03:07:32 -0500
Received: by mail-qt0-f181.google.com with SMTP id w33so306292358qtc.3
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2016 00:07:32 -0800 (PST)
In-Reply-To: <1480925211-13223-1-git-send-email-jitendra.bhivare@broadcom.com>
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
index 3f3a138..08d0855 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5663,6 +5663,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
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
@@ -1262,7 +1262,8 @@ int beiscsi_boot_get_shandle(struct beiscsi_hba *phba, unsigned int *s_handle)
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
1.8.3.1

