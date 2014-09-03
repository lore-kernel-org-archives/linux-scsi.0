From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/20] sd: Reduce logging output
Date: Wed,  3 Sep 2014 12:06:14 +0200
Message-ID: <1409738775-80876-20-git-send-email-hare@suse.de>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452AbaICKGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2014 06:06:32 -0400
In-Reply-To: <1409738775-80876-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

There is no need to print out the command result verbatim;
that will be done by the scsi stack if required.
Here we just should log the result in short if requested.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f96e3f9..aa94385 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1701,14 +1701,15 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			sense_deferred = scsi_sense_is_deferred(&sshdr);
 	}
 #ifdef CONFIG_SCSI_LOGGING
-	SCSI_LOG_HLCOMPLETE(1, scsi_print_result(SCpnt));
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

