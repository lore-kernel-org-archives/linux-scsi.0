From: Zhou Zhengping <johnzzpcrystal@gmail.com>
Subject: [PATCH] MegaRAID SAS: Raidcard hotswap wouldn't work if the device's fd is held in userspace
Date: Fri, 28 Apr 2017 17:43:04 +0800
Message-ID: <1493372584-1204-1-git-send-email-johnzzpcrystal@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32846 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756135AbdD1JnP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2017 05:43:15 -0400
Received: by mail-pf0-f196.google.com with SMTP id b23so752497pfc.0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2017 02:43:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Zhou Zhengping <johnzzpcrystal@gmail.com>

    When a scsi_device is unpluged from scsi controller, if the
scsi_device is still be used by application layer,it won't be
released until users release it. In this case, scsi_device_remove just set
the scsi_device's state to be SDEV_DEL. But if you plug the disk
just before the old scsi_device is released, then there will be two
scsi_device structures in scsi_host->__devices. when the next unpluging
event happens,some low-level drivers will check whether the scsi_device
has been added to host (for example, the megaraid sas series controller)
by calling scsi_device_lookup(call __scsi_device_lookup) in function
megasas_aen_polling.__scsi_device_lookup will return the first scsi_device.
Because its state is SDEV_DEL, the scsi_device_lookup will return NULL finally,
making the low-level driver assume that the scsi_device has been
removed,and won't call scsi_device_remove,which will lead the
failure of hot swap.

Signed-off-by: Zhou Zhengping <johnzzpcrystal@gmail.com>
Tested-and-reported-by: Zeng Rujia <ZengRujia@sangfor.com.cn>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=195607
---
 drivers/scsi/scsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 61c82a3..b455619 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1262,6 +1262,8 @@ struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
 	struct scsi_device *sdev;
 
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
+		if (sdev->sdev_state == SDEV_DEL)
+			continue;
 		if (sdev->channel == channel && sdev->id == id &&
 				sdev->lun ==lun)
 			return sdev;
-- 
1.8.3.1
