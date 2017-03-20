From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] hpsa: fix volume offline state
Date: Mon, 20 Mar 2017 16:42:48 +0100
Message-ID: <1490024568-4301-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47426 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753610AbdCTPns (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Mar 2017 11:43:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: don.brace@microsemi.com, joseph.szczypek@hpe.com

In a previous patch a hpsa_scsi_dev_t.volume_offline update line
has been removed, so let us put it back..

Fixes: 85b29008d8 (hpsa: update check for logical volume status)

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/hpsa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0d0be7754a..9d659aaace 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3885,6 +3885,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		if (h->fw_support & MISC_FW_RAID_OFFLOAD_BASIC)
 			hpsa_get_ioaccel_status(h, scsi3addr, this_device);
 		volume_offline = hpsa_volume_offline(h, scsi3addr);
+		this_device->volume_offline = volume_offline;
 		if (volume_offline == HPSA_LV_FAILED) {
 			rc = HPSA_LV_FAILED;
 			dev_err(&h->pdev->dev,
-- 
2.7.4
