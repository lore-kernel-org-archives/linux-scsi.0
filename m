From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] hpsa: use correct DID_NO_CONNECT hostbyte
Date: Fri, 18 Nov 2016 08:32:47 +0100
Message-ID: <1479454369-100281-2-git-send-email-hare@suse.de>
References: <1479454369-100281-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50680 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752247AbcKRHc6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Nov 2016 02:32:58 -0500
In-Reply-To: <1479454369-100281-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Martin Wilck <martin.wilck@suse.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

NOT_READY is a sense key, not a legit scsi hostbyte value.
Use DID_NO_CONNECT instead.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ea64c01..488e17c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5493,7 +5493,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 
 	dev = cmd->device->hostdata;
 	if (!dev) {
-		cmd->result = NOT_READY << 16; /* host byte */
+		cmd->result = DID_NO_CONNECT << 16;
 		cmd->scsi_done(cmd);
 		return 0;
 	}
-- 
1.8.5.6

