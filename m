From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv5 2/8] sd: Return SUCCESS in sd_eh_action() after device offline
Date: Tue,  4 Apr 2017 16:26:46 +0200
Message-ID: <1491316012-105426-3-git-send-email-hare@suse.de>
References: <1491316012-105426-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37413 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752687AbdDDO0z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Apr 2017 10:26:55 -0400
In-Reply-To: <1491316012-105426-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>

If sd_eh_action() decides to take the device offline there is
no point in returning FAILED, as taking the device offline
is the ultimate step in SCSI EH anyway.
So further escalation via SCSI EH is not likely to make a
difference and we can as well return SUCCESS.

Cc: Benjamin Block <bblock@linux.vnet.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bd2a38e..00b168b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1751,7 +1751,7 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 			    "Medium access timeout failure. Offlining disk!\n");
 		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
 
-		return FAILED;
+		return SUCCESS;
 	}
 
 	return eh_disp;
-- 
1.8.5.6
