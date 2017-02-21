From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 07/10] mpt3sas: check command status before attempting abort
Date: Tue, 21 Feb 2017 13:27:06 +0100
Message-ID: <1487680029-3701-8-git-send-email-hare@suse.de>
References: <1487680029-3701-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58929 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752453AbdBUM1q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Feb 2017 07:27:46 -0500
In-Reply-To: <1487680029-3701-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When attempting a command abort we should check the command status
prior to sending the abort; the command might've been completed
already.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6bc9291..1c45fb3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2261,6 +2261,14 @@ struct _sas_node *
 		return (!rc) ? SUCCESS : FAILED;
 	}
 
+	if (type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
+		scsi_lookup = mpt3sas_get_st_from_smid(ioc, smid_task);
+		if (!scsi_lookup)
+			return FAILED;
+		if (scsi_lookup->cb_idx == 0xFF)
+			return SUCCESS;
+	}
+
 	smid = mpt3sas_base_get_smid_hpr(ioc, ioc->tm_cb_idx);
 	if (!smid) {
 		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
@@ -2268,9 +2276,6 @@ struct _sas_node *
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
