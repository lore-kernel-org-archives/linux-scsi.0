From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 09/10] mpt3sas: always use first reserved smid for ioctl passthrough
Date: Tue, 21 Feb 2017 13:27:08 +0100
Message-ID: <1487680029-3701-10-git-send-email-hare@suse.de>
References: <1487680029-3701-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58962 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752453AbdBUM12 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Feb 2017 07:27:28 -0500
In-Reply-To: <1487680029-3701-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

ioctl passthrough commands require a SCSIIO smid, but cannot
easily integrate with the block layer. But the driver already
has reserved some SCSIIO smids and we're only ever allowing
one ioctl command at a time we can use the first reserved smid
for ioctl commands.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 11 ++++++++---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c  | 10 ++--------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 3f9148c..0875e58 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2432,7 +2432,9 @@ struct scsiio_tracker *
 		ioc->scsi_lookup[i].cb_idx = 0xFF;
 		ioc->scsi_lookup[i].scmd = NULL;
 		ioc->scsi_lookup[i].direct_io = 0;
-		list_add(&ioc->scsi_lookup[i].tracker_list, &ioc->free_list);
+		if (i < ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT)
+			list_add(&ioc->scsi_lookup[i].tracker_list,
+				 &ioc->free_list);
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
 		_base_recovery_check(ioc);
@@ -5174,8 +5176,11 @@ struct scsiio_tracker *
 		ioc->scsi_lookup[i].smid = smid;
 		ioc->scsi_lookup[i].scmd = NULL;
 		ioc->scsi_lookup[i].direct_io = 0;
-		list_add_tail(&ioc->scsi_lookup[i].tracker_list,
-		    &ioc->free_list);
+		if (i < ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT)
+			list_add_tail(&ioc->scsi_lookup[i].tracker_list,
+				      &ioc->free_list);
+		else
+			INIT_LIST_HEAD(&ioc->lookup[i].tracker_list);
 	}
 
 	/* hi-priority queue */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 02fe1c4..23e0ef1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -719,14 +719,8 @@ enum block_state {
 			goto out;
 		}
 	} else {
-
-		smid = mpt3sas_base_get_smid_scsiio(ioc, ioc->ctl_cb_idx, NULL);
-		if (!smid) {
-			pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-			    ioc->name, __func__);
-			ret = -EAGAIN;
-			goto out;
-		}
+		/* Use first reserved smid for passthrough ioctls */
+		smid = ioc->scsiio_depth - ioc->host->reserved_cmds;
 	}
 
 	ret = 0;
-- 
1.8.5.6
