From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/24] sd: Remove scsi_print_sense() in sd_done()
Date: Wed,  1 Oct 2014 08:22:38 +0200
Message-ID: <1412144580-72880-3-git-send-email-hare@suse.de>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaJAGXF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2014 02:23:05 -0400
In-Reply-To: <1412144580-72880-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

sd_done() was calling scsi_print_sense() for a sense code
of 'NO_SENSE'.

Reviewed-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0cb5c9f..0ccb459 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1730,7 +1730,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		 * unknown amount of data was transferred so treat it as an
 		 * error.
 		 */
-		scsi_print_sense("sd", SCpnt);
 		SCpnt->result = 0;
 		memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		break;
-- 
1.8.5.2

