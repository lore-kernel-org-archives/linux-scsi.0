From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Do not retry invalid function error
Date: Tue, 17 Oct 2017 09:10:56 +0200
Message-ID: <1508224256-130260-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933831AbdJQHK6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Oct 2017 03:10:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hitachi USP-V returns 'Invalid function' when the internal
staging mechanism encountered an error. These errors should
not be retried on another path.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 3894205..5086489 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -579,6 +579,7 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
 	case ILLEGAL_REQUEST:
 		if (sshdr.asc == 0x20 || /* Invalid command operation code */
 		    sshdr.asc == 0x21 || /* Logical block address out of range */
+		    sshdr.asc == 0x22 || /* Invalid function */
 		    sshdr.asc == 0x24 || /* Invalid field in cdb */
 		    sshdr.asc == 0x26) { /* Parameter value invalid */
 			set_host_byte(scmd, DID_TARGET_FAILURE);
-- 
1.8.5.6
