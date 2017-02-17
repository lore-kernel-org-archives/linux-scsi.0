From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 11/11] mpt3sas: register reserved commands
Date: Fri, 17 Feb 2017 09:23:10 +0100
Message-ID: <1487319790-97340-12-git-send-email-hare@suse.de>
References: <1487319790-97340-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34676 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754199AbdBQIXV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:23:21 -0500
In-Reply-To: <1487319790-97340-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The mpt3sas driver requires a reserved command space to handle
SCSI passthrough commands.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index e9470a3..97189ad 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2360,6 +2360,8 @@ struct scsiio_tracker *
 	} else {
 		u32 unique_tag = blk_mq_unique_tag(scmd->request);
 		u16 tag = blk_mq_unique_tag_to_tag(unique_tag);
+
+		WARN_ON(tag < ioc->shost->reserved_cmds);
 		request = scsi_cmd_priv(scmd);
 		smid = tag + 1;
 	}
@@ -3521,7 +3523,8 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 	/* set the scsi host can_queue depth
 	 * with some internal commands that could be outstanding
 	 */
-	ioc->shost->can_queue = ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT;
+	ioc->shost->reserved_cmds = INTERNAL_SCSIIO_CMDS_COUNT;
+	ioc->shost->can_queue = ioc->scsiio_depth - ioc->shost->reserved_cmds;
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT
 		"scsi host: can_queue depth (%d)\n",
 		ioc->name, ioc->shost->can_queue));
-- 
1.8.5.6
