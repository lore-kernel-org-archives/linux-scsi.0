From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH] mpt3sas: Fix for block device of raid exists even after deleting raid disk
Date: Thu, 27 Oct 2016 16:16:26 +0530
Message-ID: <1477565186-13970-1-git-send-email-Sreekanth.Reddy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:33929 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964886AbcJ0OGL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2016 10:06:11 -0400
Received: by mail-qk0-f174.google.com with SMTP id x11so45770482qka.1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Oct 2016 07:05:53 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>

While merging mpt3sas & mpt2sas code, we posted below patch for WarpDrive
support,

mpt3sas: Ported WarpDrive product SSS6200 support
commit id is 7786ab6aff

In this patch and in the below hunk, we have added is_warpdrive
check condition on the wrong line
---------------------------------------------------------------------------
 scsih_target_alloc(struct scsi_target *starget)
                        sas_target_priv_data->handle = raid_device->handle;
                        sas_target_priv_data->sas_address = raid_device->wwid;
                        sas_target_priv_data->flags |= MPT_TARGET_FLAGS_VOLUME;
-                       raid_device->starget = starget;
+                       sas_target_priv_data->raid_device = raid_device;
+                       if (ioc->is_warpdrive)
+                               raid_device->starget = starget;
                }
                spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
                return 0;
------------------------------------------------------------------------------

Actually that check should be for below line
 sas_target_priv_data->raid_device = raid_device;

Due to above hunk, we are not initializing raid_device's starget for raid volumes,
and so during raid disk deletion driver is not calling scsi_remove_target() API as
driver observes starget field of raid_device's structure as NULL.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 981be7b..618c9df8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1279,9 +1279,9 @@ scsih_target_alloc(struct scsi_target *starget)
 			sas_target_priv_data->handle = raid_device->handle;
 			sas_target_priv_data->sas_address = raid_device->wwid;
 			sas_target_priv_data->flags |= MPT_TARGET_FLAGS_VOLUME;
-			sas_target_priv_data->raid_device = raid_device;
 			if (ioc->is_warpdrive)
-				raid_device->starget = starget;
+				sas_target_priv_data->raid_device = raid_device;
+			raid_device->starget = starget;
 		}
 		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 		return 0;
-- 
2.4.3

