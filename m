From: Zhou Zhengping <johnzzpcrystal@gmail.com>
Subject: [PATCH]scsi: megaraid_sas: fix raid card hotswap failure
Date: Sun, 30 Apr 2017 02:11:11 +0800
Message-ID: <1493489471-4848-1-git-send-email-johnzzpcrystal@gmail.com>
References: <1493372584-1204-1-git-send-email-johnzzpcrystal@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36857 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967719AbdD2SML (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Apr 2017 14:12:11 -0400
Received: by mail-pf0-f194.google.com with SMTP id v14so22146757pfd.3
        for <linux-scsi@vger.kernel.org>; Sat, 29 Apr 2017 11:12:10 -0700 (PDT)
In-Reply-To: <1493372584-1204-1-git-send-email-johnzzpcrystal@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de, James.Bottomley@hansenpartnership.com, Zhou Zhengping <johnzzpcrystal@gmail.com>

    When a scsi_device is unpluged from scsi controller, if the
scsi_device is still be used by application layer,it won't be
released until users release it. In this case, scsi_device_remove just
set the scsi_device's state to be SDEV_DEL. But if you plug the disk
just before the old scsi_device is released, then there will be two
scsi_device structures in scsi_host->__devices. when the next unpluging
event happens,some low-level drivers will check whether the scsi_device
has been added to host (for example, the megaraid sas series controller)
by calling scsi_device_lookup(call __scsi_device_lookup) in function
megasas_aen_polling.__scsi_device_lookup will return the first scsi_device.
Because its state is SDEV_DEL, the scsi_device_lookup will return NULL
finally, making the low-level driver assume that the scsi_device has been
removed,and won't call scsi_device_remove,which will lead the
failure of hot swap.

Signed-off-by: Zhou Zhengping <johnzzpcrystal@gmail.com>
Tested-and-reported-by: Zeng Rujia <ZengRujia@sangfor.com.cn>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=195607
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 7bfbcfa..61cdd99 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -763,6 +763,8 @@ struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
 	struct scsi_device *sdev;
 
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
+		if (sdev->sdev_state == SDEV_DEL)
+			continue;
 		if (sdev->channel == channel && sdev->id == id &&
 				sdev->lun ==lun)
 			return sdev;
-- 
1.8.3.1
