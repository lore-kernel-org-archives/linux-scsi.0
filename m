From: Yuanyuan Zhong <yzhong@purestorage.com>
Subject: [PATCH] scsi: mpt3sas: validate device handle before ata pending flag
Date: Tue, 12 Dec 2017 18:51:49 -0700
Message-ID: <1513129909-25243-1-git-send-email-yzhong@purestorage.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:44752 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbdLMBwQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Dec 2017 20:52:16 -0500
Received: by mail-pl0-f65.google.com with SMTP id n13so89010plp.11
        for <linux-scsi@vger.kernel.org>; Tue, 12 Dec 2017 17:52:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sathya.prakash@broadcom.com
Cc: chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Yuanyuan Zhong <yzhong@purestorage.com>

Commit ffb584565894 ("scsi: mpt3sas: fix hang on ata passthrough
commands") introduced ata_command_pending bit-flag to ensure sending
only one outstanding pass through ATA command to target device.

However if target device become irresponsive with ata_command_pending,
we won't be able to remove it timely, since we try to dispatch a
SYNCHRONIZE_CACHE command and bail out with SAM_STAT_BUSY repeatedly.

Move the invalid device handle checking a bit earlier than the
ata_command_pending.

Signed-off-by: Yuanyuan Zhong <yzhong@purestorage.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b258f21..32fc0d8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4758,6 +4758,16 @@ static int _scsih_set_satl_pending(struct scsi_cmnd *scmd, bool pending)
 		return 0;
 	}
 
+	sas_target_priv_data = sas_device_priv_data->sas_target;
+
+	/* invalid device handle */
+	handle = sas_target_priv_data->handle;
+	if (handle == MPT3SAS_INVALID_DEVICE_HANDLE) {
+		scmd->result = DID_NO_CONNECT << 16;
+		scmd->scsi_done(scmd);
+		return 0;
+	}
+
 	/*
 	 * Bug work around for firmware SATL handling.  The loop
 	 * is based on atomic operations and ensures consistency
@@ -4771,17 +4781,6 @@ static int _scsih_set_satl_pending(struct scsi_cmnd *scmd, bool pending)
 		}
 	} while (_scsih_set_satl_pending(scmd, true));
 
-	sas_target_priv_data = sas_device_priv_data->sas_target;
-
-	/* invalid device handle */
-	handle = sas_target_priv_data->handle;
-	if (handle == MPT3SAS_INVALID_DEVICE_HANDLE) {
-		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
-		return 0;
-	}
-
-
 	/* host recovery or link resets sent via IOCTLs */
 	if (ioc->shost_recovery || ioc->ioc_link_reset_in_progress)
 		return SCSI_MLQUEUE_HOST_BUSY;
-- 
1.9.1
