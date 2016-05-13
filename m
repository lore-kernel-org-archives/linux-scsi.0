From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi_lib: correctly retry failed zero length REQ_TYPE_FS
 commands
Date: Fri, 13 May 2016 12:04:06 -0700
Message-ID: <1463166246.2291.84.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35298 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752977AbcEMTEJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2016 15:04:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sebastian Parschauer <s.parschauer@gmx.de>, linux-scsi@vger.kernel.org

When SCSI was written, all commands coming from the filesystem
(REQ_TYPE_FS commands) had data.  This meant that our signal for
needing to complete the command was the number of bytes completed being
equal to the number of bytes in the request.  Unfortunately, with the
advent of flush barriers, we can now get zero length REQ_TYPE_FS
commands, which confuse this logic because they satisfy the condition
every time.  This means they never get retried even for retryable
conditions, like UNIT ATTENTION because we complete them early assuming
they're done.  Fix this by special casing the early completion
condition to recognise zero length commands with errors and let them
drop through to the retry code.

Reported-by: Sebastian Parschauer <s.parschauer@gmx.de>
Signed-off-by: James E.J. Bottomley <jejb@linux.vnet.ibm.com>

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8106515..f704d02 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -911,9 +911,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 
 	/*
-	 * If we finished all bytes in the request we are done now.
+	 * special case: failed zero length commands always need to
+	 * drop down into the retry code. Otherwise, if we finished
+	 * all bytes in the request we are done now.
 	 */
-	if (!scsi_end_request(req, error, good_bytes, 0))
+	if (!(blk_rq_bytes(req) == 0 && error) &&
+	    !scsi_end_request(req, error, good_bytes, 0))
 		return;
 
 	/*
