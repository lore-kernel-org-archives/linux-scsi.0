From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: do not print 'reservation conflict' for TEST UNIT READY
Date: Mon, 12 Sep 2016 10:20:53 +0200
Message-ID: <1473668453-115818-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39438 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750896AbcILIVH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Sep 2016 04:21:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

SPC-2 and SPC-3 (or later) differ in the handling of reservation
conflict for TEST UNIT READY. SPC-2 will return 'reservation conflict',
whereas SPC-3 will return GOOD status.
On a mixed system with both SPC-2 and SPC-3 targets one will
see lots of 'reservation conflict' messages from the SPC-2 system but
no messages from the SPC-3 system when eg multipath path checkers.
These messages might confuse the unsuspecting user although in fact
they just signal normal operation.
So we should not be printing out 'reservation conflict' for
TEST UNIT READY responses.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_error.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 106a6ad..3040fe5 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1923,8 +1923,9 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		return SUCCESS;
 
 	case RESERVATION_CONFLICT:
-		sdev_printk(KERN_INFO, scmd->device,
-			    "reservation conflict\n");
+		if (scmd->cmnd[0] != TEST_UNIT_READY)
+			sdev_printk(KERN_INFO, scmd->device,
+				    "reservation conflict\n");
 		set_host_byte(scmd, DID_NEXUS_FAILURE);
 		return SUCCESS; /* causes immediate i/o error */
 	default:
-- 
1.8.5.6

