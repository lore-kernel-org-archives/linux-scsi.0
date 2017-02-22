From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 05/12] mpt3sas: open-code _scsih_scsi_lookup_get()
Date: Wed, 22 Feb 2017 11:31:45 +0100
Message-ID: <1487759512-3873-6-git-send-email-hare@suse.de>
References: <1487759512-3873-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49692 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753338AbdBVKcB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 05:32:01 -0500
In-Reply-To: <1487759512-3873-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Just a wrapper around the scsi lookup array and only used
in one place, so open-code it.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b8cd0a1..52de355 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1061,19 +1061,6 @@ struct _sas_node *
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
@@ -6126,7 +6113,7 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
 		if (ioc->shost_recovery)
 			goto out;
-		scmd = _scsih_scsi_lookup_get(ioc, smid);
+		scmd = ioc->scsi_lookup[smid - 1].scmd;
 		if (!scmd)
 			continue;
 		sdev = scmd->device;
-- 
1.8.5.6
