From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/10] mpt3sas: use hi-priority queue for TMFs
Date: Tue, 31 Jan 2017 10:25:57 +0100
Message-ID: <1485854760-122683-8-git-send-email-hare@suse.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46348 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751664AbdAaJ0K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Jan 2017 04:26:10 -0500
In-Reply-To: <1485854760-122683-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When sending a TMF via the ioctl interface we should be using
the hi-priority queue instead of the scsi queue to be consistent
with overall TMF usage.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 95f0f24..e952175 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -720,7 +720,7 @@ enum block_state {
 		}
 	} else {
 
-		smid = mpt3sas_base_get_smid_scsiio(ioc, ioc->ctl_cb_idx, NULL);
+		smid = mpt3sas_base_get_smid_hpr(ioc, ioc->ctl_cb_idx);
 		if (!smid) {
 			pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
 			    ioc->name, __func__);
-- 
1.8.5.6

