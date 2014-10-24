From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/27] sd: Remove scsi_print_sense() in sd_done()
Date: Fri, 24 Oct 2014 14:26:42 +0200
Message-ID: <1414153627-2863-3-git-send-email-hare@suse.de>
References: <1414153627-2863-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240AbaJXM1N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2014 08:27:13 -0400
In-Reply-To: <1414153627-2863-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

sd_done() was calling scsi_print_sense() for a sense code
of 'NO_SENSE'.

Reviewed-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cfba74c..52b40b1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1743,7 +1743,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		 * unknown amount of data was transferred so treat it as an
 		 * error.
 		 */
-		scsi_print_sense("sd", SCpnt);
 		SCpnt->result = 0;
 		memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		break;
-- 
1.8.5.2

