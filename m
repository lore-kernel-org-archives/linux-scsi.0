From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 21/22] scsi: reduce messages for command failure
Date: Thu, 28 Aug 2014 19:33:35 +0200
Message-ID: <1409247216-76074-22-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbaH1Rdq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:46 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

When devices fail they can generate quite a lot of error
messages, possibly overloading the logging system.
So we should be putting these messages under logging control
to be able to silence them if requested.
And we should shorten the overall message; more verbose
logging can be requested by the normal scsi logging.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ed5e40f..64f8e33 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1038,10 +1038,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
 		if (!(req->cmd_flags & REQ_QUIET)) {
-			scsi_print_result(cmd, SUCCESS);
-			if (driver_byte(result) & DRIVER_SENSE)
-				scsi_print_sense(cmd);
-			scsi_print_command(cmd);
+			SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, cmd,
+				"Failed command, error %d\n", error));
 		}
 		if (!scsi_end_request(req, error, blk_rq_err_bytes(req), 0))
 			return;
-- 
1.8.5.2

