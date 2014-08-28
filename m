From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/22] sd: Remove scsi_print_sense() in sd_done()
Date: Thu, 28 Aug 2014 19:33:17 +0200
Message-ID: <1409247216-76074-4-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbaH1Rdj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:39 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

sd_done() was calling scsi_print_sense() for a sense code
of 'NO_SENSE'.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index aa43496..f5ca203 100644
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

