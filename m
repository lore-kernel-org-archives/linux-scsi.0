From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Always retry internal target error
Date: Tue, 17 Oct 2017 09:11:03 +0200
Message-ID: <1508224263-130302-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60405 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933857AbdJQHLF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Oct 2017 03:11:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

EMC Symmetrix is returning 'internal target error' for a variety
of conditions, most of which will be transient.
So we should always retry it, even with failfast set.
Otherwise we'd get spurious path flaps with multipath.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 5086489..5722c2e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -497,6 +497,16 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (sshdr.asc == 0x10) /* DIF */
 			return SUCCESS;
 
+		if (!strncmp(scmd->device->vendor, "EMC", 3) &&
+		    !strncmp(scmd->device->model, "SYMMETRIX", 9) &&
+		    (sshdr.asc == 0x44) && (sshdr.ascq == 0x0)) {
+			/*
+			 * EMC Symmetrix returns 'Internal target failure'
+			 * for a variety of internal issues, all of which
+			 * can be recovered by retry.
+			 */
+			return ADD_TO_MLQUEUE;
+		}
 		return NEEDS_RETRY;
 	case NOT_READY:
 	case UNIT_ATTENTION:
@@ -1846,6 +1856,9 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		rtn = scsi_check_sense(scmd);
 		if (rtn == NEEDS_RETRY)
 			goto maybe_retry;
+		else if (rtn == ADD_TO_MLQUEUE)
+			/* Always enforce a retry for ADD_TO_MLQUEUE */
+			rtn = NEEDS_RETRY;
 		/* if rtn == FAILED, we have no sense information;
 		 * returning FAILED will wake the error handler thread
 		 * to collect the sense and redo the decide
-- 
1.8.5.6
