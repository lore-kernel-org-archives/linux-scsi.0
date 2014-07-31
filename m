From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.16-rc7
Date: Thu, 31 Jul 2014 17:26:17 +0400
Message-ID: <1406813177.6957.26.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51673 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbaGaN0X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2014 09:26:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a potential data corruption fix: If we get an error sending down
a barrier, we simply ignore it meaning the barrier semantics get
violated without anyone being any the wiser.  If the system crashes at
this point, the filesystem potentially becomes corrupt.  Fix is to
report errors on failed barriers.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

James Bottomley (1):
      scsi: handle flush errors properly

And the diffstat:

 drivers/scsi/scsi_lib.c | 8 ++++++++
 1 file changed, 8 insertions(+)

Full diff below.

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f7e3163..3f50dfc 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -733,6 +733,14 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			scsi_next_command(cmd);
 			return;
 		}
+	} else if (blk_rq_bytes(req) == 0 && result && !sense_deferred) {
+		/*
+		 * Certain non BLOCK_PC requests are commands that don't
+		 * actually transfer anything (FLUSH), so cannot use
+		 * good_bytes != blk_rq_bytes(req) as the signal for an error.
+		 * This sets the error explicitly for the problem case.
+		 */
+		error = __scsi_error_from_host_byte(cmd, result);
 	}
 
 	/* no bidi support for !REQ_TYPE_BLOCK_PC yet */



