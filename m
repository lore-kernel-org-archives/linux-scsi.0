From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 09/12] mpt3sas: simplify task management functions
Date: Wed, 22 Feb 2017 11:31:49 +0100
Message-ID: <1487759512-3873-10-git-send-email-hare@suse.de>
References: <1487759512-3873-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49694 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754396AbdBVKcB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 05:32:01 -0500
In-Reply-To: <1487759512-3873-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

One can simply check 'target_busy' or 'device_busy' when figuring
out if there are outstanding commands; no need to painstakingly
counting them by hand.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 88 +++---------------------------------
 1 file changed, 7 insertions(+), 81 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 1c45fb3..e0cb35d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1133,74 +1133,6 @@ struct _sas_node *
 }
 
 /**
- * _scsih_scsi_lookup_find_by_target - search for matching channel:id
- * @ioc: per adapter object
- * @id: target id
- * @channel: channel
- * Context: This function will acquire ioc->scsi_lookup_lock.
- *
- * This will search for a matching channel:id in the scsi_lookup array,
- * returning 1 if found.
- */
-static u8
-_scsih_scsi_lookup_find_by_target(struct MPT3SAS_ADAPTER *ioc, int id,
-	int channel)
-{
-	u8 found;
-	unsigned long	flags;
-	int i;
-
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	found = 0;
-	for (i = 0 ; i < ioc->scsiio_depth; i++) {
-		if (ioc->scsi_lookup[i].scmd &&
-		    (ioc->scsi_lookup[i].scmd->device->id == id &&
-		    ioc->scsi_lookup[i].scmd->device->channel == channel)) {
-			found = 1;
-			goto out;
-		}
-	}
- out:
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-	return found;
-}
-
-/**
- * _scsih_scsi_lookup_find_by_lun - search for matching channel:id:lun
- * @ioc: per adapter object
- * @id: target id
- * @lun: lun number
- * @channel: channel
- * Context: This function will acquire ioc->scsi_lookup_lock.
- *
- * This will search for a matching channel:id:lun in the scsi_lookup array,
- * returning 1 if found.
- */
-static u8
-_scsih_scsi_lookup_find_by_lun(struct MPT3SAS_ADAPTER *ioc, int id,
-	unsigned int lun, int channel)
-{
-	u8 found;
-	unsigned long	flags;
-	int i;
-
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	found = 0;
-	for (i = 0 ; i < ioc->scsiio_depth; i++) {
-		if (ioc->scsi_lookup[i].scmd &&
-		    (ioc->scsi_lookup[i].scmd->device->id == id &&
-		    ioc->scsi_lookup[i].scmd->device->channel == channel &&
-		    ioc->scsi_lookup[i].scmd->device->lun == lun)) {
-			found = 1;
-			goto out;
-		}
-	}
- out:
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-	return found;
-}
-
-/**
  * scsih_change_queue_depth - setting device queue depth
  * @sdev: scsi device struct
  * @qdepth: requested queue depth
@@ -2339,19 +2271,9 @@ struct _sas_node *
 		rc = FAILED;
 		break;
 
-	case MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
-		if (_scsih_scsi_lookup_find_by_target(ioc, id, channel))
-			rc = FAILED;
-		else
-			rc = SUCCESS;
-		break;
 	case MPI2_SCSITASKMGMT_TASKTYPE_ABRT_TASK_SET:
 	case MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET:
-		if (_scsih_scsi_lookup_find_by_lun(ioc, id, lun, channel))
-			rc = FAILED;
-		else
-			rc = SUCCESS;
-		break;
+	case MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
 	case MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK:
 		rc = SUCCESS;
 		break;
@@ -2554,7 +2476,9 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->channel,
 	    scmd->device->id, scmd->device->lun,
 	    MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 30);
-
+	/* Check for busy commands after reset */
+	if (r == SUCCESS && atomic_read(&scmd->device->device_busy))
+		r = FAILED;
  out:
 	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(%p)\n",
 	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
@@ -2616,7 +2540,9 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->channel,
 	    scmd->device->id, 0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
 	    30);
-
+	/* Check for busy commands after reset */
+	if (r == SUCCESS && atomic_read(&starget->target_busy))
+		r = FAILED;
  out:
 	starget_printk(KERN_INFO, starget, "target reset: %s scmd(%p)\n",
 	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
-- 
1.8.5.6
