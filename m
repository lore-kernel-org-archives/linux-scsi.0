From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 07/11] mpt3sas: check command status before attempting abort
Date: Fri, 17 Feb 2017 09:23:06 +0100
Message-ID: <1487319790-97340-8-git-send-email-hare@suse.de>
References: <1487319790-97340-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34687 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753622AbdBQIXV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:23:21 -0500
In-Reply-To: <1487319790-97340-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When attempting a command abort we should check the command status
prior to sending the abort; the command might've been completed
already.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a88f2ac..989cdc8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2261,6 +2261,12 @@ struct _sas_node *
 		return (!rc) ? SUCCESS : FAILED;
 	}
 
+	if (type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
+		scsi_lookup = mpt3sas_get_st_from_smid(ioc, smid_task);
+		if (scsi_lookup->cb_idx == 0xFF)
+			return SUCCESS;
+	}
+
 	smid = mpt3sas_base_get_smid_hpr(ioc, ioc->tm_cb_idx);
 	if (!smid) {
 		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
@@ -2268,9 +2274,6 @@ struct _sas_node *
 		return FAILED;
 	}
 
-	if (type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK)
-		scsi_lookup = mpt3sas_get_st_from_smid(ioc, smid_task);
-
 	dtmprintk(ioc, pr_info(MPT3SAS_FMT
 		"sending tm: handle(0x%04x), task_type(0x%02x), smid(%d)\n",
 		ioc->name, handle, type, smid_task));
-- 
1.8.5.6
