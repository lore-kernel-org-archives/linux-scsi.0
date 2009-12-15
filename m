From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] scsi_lib: Bug in completion of bidi commands
Date: Tue, 15 Dec 2009 17:25:43 +0200
Message-ID: <4B27AA77.3040002@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:22003 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754187AbZLOPZr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2009 10:25:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>, Benny Halevy <bhalevy@panasas.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Stable Tree <stable@kernel.org>


Because of the terrible structuring of scsi-bidi-commands
it breaks some of the life time rules of a scsi-command.
It is now not allowed to free up the block-request before
cleanup and partial deallocation of the scsi-command. (Which
is not so for none bidi commands)

The right fix to this problem would be to make bidi command
a first citizen by allocating a scsi_sdb pointer at scsi command
just like cmd->prot_sdb. The bidi sdb should be allocated/deallocated
as part of the get/put_command (Again like the prot_sdb) and the
current decoupling of scsi_cmnd and blk-request should be kept.

For now make sure scsi_release_buffers() is called before the
call to blk_end_request_all() which might cause the suicide of
the block requests. At best the leak of bidi buffers, at worse
a crash, as there is a race between the existence of the bidi_request
and the free of the associated bidi_sdb.

The reason this was never hit before is because only OSD has the potential
of doing asynchronous bidi commands. (So does bsg but it is never used)
And OSD clients just happen to do all their bidi commands synchronously, up
until recently.

CC: Stable Tree <stable@kernel.org>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5987da8..bc9a881 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -749,9 +749,9 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			 */
 			req->next_rq->resid_len = scsi_in(cmd)->resid;
 
+			scsi_release_buffers(cmd);
 			blk_end_request_all(req, 0);
 
-			scsi_release_buffers(cmd);
 			scsi_next_command(cmd);
 			return;
 		}
-- 
1.6.5.2

