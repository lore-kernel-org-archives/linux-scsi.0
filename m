From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/22] sd: Reduce logging output
Date: Thu, 28 Aug 2014 19:33:36 +0200
Message-ID: <1409247216-76074-23-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbaH1Rdq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:46 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

There is no need to print out the command result verbatim;
that will be done by the scsi stack if required.
Here we just should log the result in short if requested.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 624692c..3061acf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1701,14 +1701,15 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			sense_deferred = scsi_sense_is_deferred(&sshdr);
 	}
 #ifdef CONFIG_SCSI_LOGGING
-	SCSI_LOG_HLCOMPLETE(1, scsi_print_result(SCpnt, SUCCESS));
+	SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
+		"sd_done: result[status,msg,host,driver]=%x,%x,%x,%x\n",
+		status_byte(result), msg_byte(result),
+		host_byte(result), driver_byte(result)));
 	if (sense_valid) {
 		SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
-						   "sd_done: sb[respc,sk,asc,"
-						   "ascq]=%x,%x,%x,%x\n",
-						   sshdr.response_code,
-						   sshdr.sense_key, sshdr.asc,
-						   sshdr.ascq));
+			"sd_done: sb[respc,sk,asc,ascq]=%x,%x,%x,%x\n",
+			sshdr.response_code, sshdr.sense_key,
+			sshdr.asc, sshdr.ascq));
 	}
 #endif
 	sdkp->medium_access_timed_out = 0;
-- 
1.8.5.2

