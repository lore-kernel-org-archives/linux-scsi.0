From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 04/11] mpt3sas: open-code _scsih_scsi_lookup_get()
Date: Thu, 21 Dec 2017 23:31:40 -0800
Message-ID: <1513927907-19735-5-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1513927907-19735-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:39626 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753466AbdLVHc3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Dec 2017 02:32:29 -0500
Received: by mail-wr0-f194.google.com with SMTP id a41so27096574wra.6
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2017 23:32:28 -0800 (PST)
In-Reply-To: <1513927907-19735-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Hannes Reinecke <hare@suse.de>, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>

From: Hannes Reinecke <hare@suse.de>

Just a wrapper around the scsi lookup array and only used
in one place, so open-code it.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6fea5e6..7d76e8f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1445,19 +1445,6 @@ _scsih_is_nvme_device(u32 device_info)
 }
 
 /**
- * _scsih_scsi_lookup_get - returns scmd entry
- * @ioc: per adapter object
- * @smid: system request message index
- *
- * Returns the smid stored scmd pointer.
- */
-static struct scsi_cmnd *
-_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc, u16 smid)
-{
-	return ioc->scsi_lookup[smid - 1].scmd;
-}
-
-/**
  * __scsih_scsi_lookup_get_clear - returns scmd entry without
  *						holding any lock.
  * @ioc: per adapter object
@@ -7541,7 +7528,7 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
 		if (ioc->shost_recovery)
 			goto out;
-		scmd = _scsih_scsi_lookup_get(ioc, smid);
+		scmd = ioc->scsi_lookup[smid - 1].scmd;
 		if (!scmd)
 			continue;
 		sdev = scmd->device;
-- 
2.5.5
